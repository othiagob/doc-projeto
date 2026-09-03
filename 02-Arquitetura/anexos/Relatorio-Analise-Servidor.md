
# Relatório Técnico — Servidor Priston Tale (SrcServer)

**Projeto:** `C:/Source Priston/Source Priston/SrcServer` (solução `server.sln`, projeto `src/server.vcxproj`)
**Build:** VS2022 (v143), Win32 32-bit, `CharacterSet=MultiByte`, gera `Server.exe`
**Idioma do código-fonte:** core original em coreano (CP949/EUC-KR) + camada de modificações em português
**~260 arquivos, 1 arquivo gigante:** `src/Server/SrcServer/OnSever.cpp` (34.764 linhas, 1 MB) concentra quase toda a lógica do jogo.

---

## 1) ENTRY POINTS e ciclo de vida

**Cadeia de inicialização:**

1. **`C:/Source Priston/Source Priston/SrcServer/src/Server/Winmain.cpp` (linha 83) — `main()`**
  - Instala `SetUnhandledExceptionFilter` + hook via `HookAPI` (injeta jump de 5 bytes em `SetUnhandledExceptionFilter` do kernel32 para não deixar outro módulo sobrescrever o handler de crash).
  - Lê `Server\Config\Devices.ini` via `smConfigDecode`.
  - `initSinCos()` (tabelas seno/cosseno), `srand(GetCurrentTime())`.
  - **`initializeSQL()`** — conecta ao banco (lê `SQL.ini`).
  - Cria 2 critical sections globais e chama **`ServerWinMain()`** (declarada extern).

2. **`C:/Source Priston/Source Priston/SrcServer/src/Server/SrcServer/OnSever.cpp` (linha 24944) — `ServerWinMain()`**
  - Conecta o **singleton `SQL`** (shop em jogo) lendo `Server\Config\SQL.ini` (`[Database] Host/User/Password`); se não ler, usa fallback hardcoded `PRIME\DRACO / sa / DRACO123@#`.
  - `SetupDefWindow()` (linha 571):
  - Registra uma **janela message-only** (`HWND_MESSAGE`, sem UI) — o servidor é dirigido por mensagens do Windows (modelo WSAAsyncSelect, ver seção 3).
  - `rsRefreshConfig()` — relê todos os .ini (Devices.ini, Connect.ini, Server.ini, ExpManager.ini).
  - `InitGameSocket(TRUE)` — `WSAStartup` + cria pool de threads de rede.
  - `openSkills()` — carrega magias; `GameMasters::getInstance()->readFromDatabase()`; `Quest::GetInstance()->SendAllQuests`; `SERVERCOMMAND->LoadIndicators()`.
  - `InitAll()` (linha 11192): aloca memória dos jogadores (`rsPlayInfo[CONNECTMAX]`), carrega material/monstros/itens/NPCs **do banco** (`InitMonster()` -> `GameServer::readMonstersFromDB()`; `InitItems()` -> `readItemsFromDB()`), `srReadStage()` (mapas), `SetTimer(hwnd, 0, 100, NULL)` (timer de 100 ms do game loop), `InitODBC()`, `InitLogSql()`, `rsInit_Castle()` (Castelo Sagrado).
  - `InitBindSock(smConfig.dwServerPort)` ou `InitBindSock(TCP_SERVPORT)` — **bind + listen**.
  - Dispara **`std::thread cmd(&CLI::run, ...)`** (console de comandos, detached).
  - **Loop principal** (`while (!done)`): `PeekMessage` + `TranslateMessage`/`DispatchMessage`; sai no `WM_QUIT` ou `Quit != 0`; `WaitMessage()` quando ocioso.
  - **Desligamento:** `rsSaveCastleInfo()` -> `quit=1` -> `bSql_ServerExit()` -> `CloseBindSock()` -> `RemoveAll()` (linha 11270: salva o .dat de cada personagem online, `rsCloseDataBase()`, `CloseLogSql()`, `CloseODBC()`, `srRemoveChar()`, `srRemoveStage()`, `CloseMaterial()`).

**Game loop real:** `WM_TIMER` (100 ms) -> `srPlayMain()` (linha 11154): loop com controle de frame (`fps=70`), chama `srAutoPlayMain()` (bots), `srAutoTransPlay()`; a cada ~512 ticks: `CheckLostTransThread()`, contagem de jogadores, `DisplayMessage()`, `EventMonsterTime()`, `bSql_RecordCurrency()`; a cada ~8 ticks: `smCheckWaitMessage()`; a cada ~64: `rsTimeRecData()`.

**Login assíncrono:** fila `LogAccountQue[128]` + até 4 threads de login (`URS_LOG_THREAD_MAX=4`) — o login no banco não bloqueia o loop principal.

---

## 2) MÓDULOS (por pasta, responsabilidade confirmada no código)

| Pasta | Responsabilidade real (confirmada) |
|---|---|
| `SrcServer/` | **Núcleo do servidor.** `OnSever.cpp` (34.764 linhas): entry do game, `WndProc`, `RecvMessage` (dispatch gigante de pacotes), `srPlayMain`, `InitAll`, castelo (`BlessCastle.h`), billing (`Login.h`). `DllServer.cpp`: log SQL (LogDB). `gameSQL.cpp`/`Gamesql.h`: wrapper ODBC legado (DSN). `ClientFuncPos.cpp`: posições de funções do cliente |
| `Character/` | Lógica do personagem: `playmain.cpp`/`playsub.cpp` (estados, movimentos), `damage.cpp` (dano), `SkillSub.cpp`, **`record.cpp` (salva/ler personagens em `.dat`)** |
| `Login/` | `ProcessLogin.cpp` — autenticação de conta (UserDB, tabela `Users`) |
| `GameServer/` | `GameServer.cpp` — **carrega do banco** monsters, itens (armas/armaduras/vestes/escudos), NPCs e drops (tabelas `MonsterList`, `Weapons`, `DropList`, `NpcList`...) |
| `Network/` | **VAZIA** (socket layer vive em `smwsock.cpp` na raiz) |
| `SQL/` | **VAZIA** — scripts .sql NÃO estão no repositório |
| `Database/` | `SQLConnection.h/.cpp` — **nova camada ODBC** com 12 bancos nomeados (UserDB, ServerDB, LogDB, ClanDB, SoDDB, EventosDB, ShopCoin, Quest, GameServer, ITEMLogDB, PainelDB, UserDB_VIP) |
| `SQL.cpp/.h` (raiz) | Singleton ODBC para o **shop em jogo** (conectado no boot com credenciais do SQL.ini) |
| `smwsock.cpp/.h` (raiz) | **Camada de sockets** (WSAAsyncSelect + threads de transmissão) |
| `Chat/` | `ChatServer.cpp` — chat do jogo (normal, sussurro, item-link, filtro de palavras), `Chat.h` (códigos de pacote, cores) |
| `Party/` | Grupo/raid: `CPartyHandler.cpp` + `Party.cpp` (máx. 6 membros, 2 raids, estados/ações) |
| `Quest/` | `Quest.cpp` — quests carregadas do banco (`Quests`, `PlayerActiveQuest`, `PlayerCompletedQuest`, `QuestRewards`) |
| `Shop/` | `NewShop.cpp` — **loja premium em jogo** (itens por moeda do servidor); `NewShopTime.cpp` (loja com validade temporária); tabelas `ShopItems`, `ShopItemsTime`, `StoreSettings` |
| `GM/` | `GM.cpp` (lista de GMs do banco `GameMasters`), **`ServerCommand.cpp` (comandos `/...` no chat)** |
| `CLI/` | `CLI.cpp` — console do servidor (`exit;`, `shutdown;`, `kick <nome>`, `reloadGMS;`, `reloadConfig;`...). Pasta contém também build .NET (`ServerGUI.exe`, net472) |
| `Security/` | `Firewall.cpp` (bloqueio de IP no firewall do Windows), `Joi.hpp` (biblioteca de validação de entrada estilo "Joi" do JS) |
| `Ranking/` | `TopRanking.cpp`, `PVPRanking.cpp`, `SodRanking.cpp` (ranking de PvP/geral/castelo) |
| `Aging/` | `RestaureItem.cpp` — **recuperação de itens perdidos no Aging** (NPC, tabela `AgingFailed`) |
| `Roleta/` | `Roleta.cpp` — **evento roleta** (top dano vira sorteio; tabela `Roleta`) |
| `Caravana/` | `Caravana.cpp` — **sistema de caravana** (companheiro NPC escoltado, renomeável; tabela `Caravans`) |
| `Eventos/` | `Arena.cpp` (PvP em arena, campo 49), `EragonLair.cpp` (boss dragão), `Invasao.cpp` (invasão, campo 53), `Questions.cpp` (quiz) |
| `VIP/` | `Vip.cpp` — sistema VIP (níveis, NPCs de premium "Itens Premiuns"/"Loja da Gaby") |
| `PostBox/` | **VAZIA** — o sistema existe mas usa `Data/PostBox/<usercode>/<id>.dat` (record.cpp) e lógica espalhada (Quest.cpp, NewShop.cpp) |
| `sinbaram/` | Itens premium/estendidos: `haPremiumItem.cpp` (itens de cash: montaria, poções EXP, pets...), `sinItem.cpp`, `sinInvenTory.cpp`, `sinSkill.cpp`, `sinQuest.cpp`, `sinMain.cpp` |
| `Skills/` | `Skills.cpp` (5.600+ linhas, `openSkills()`/`readAll()`, `SkillPacket.h`) |
| `smLib3d/` | Biblioteca 3D herdada do cliente: `smMap3d`, `smObj3d`, `smGeosub`, `smmatrix`, `smSin`, `smRead3d`, `smType.h` (struct `smCONFIG` de configuração) |
| `Animation/` | **VAZIA** |
| `Data/` | `DataServer/userdata/<código>/<nome>.dat` — **salvamento binário dos personagens** (todos vazios no repo) |
| `English/` | Textos de chat de NPCs/mobs em inglês (`e_ServerMsg.h`, `e_TalkText.h`, `e_sinMsg.h`...) — incluídos por `#include` |
| `SrcLang/` | `jts.cpp/.h` — leitor de arquivos de texto japonês (JTS) herdado |
| `Shared/` (fora do SrcServer) | `smPacket.h` (códigos de pacote!), `LevelTable.h`, `Skills/` (headers por classe), `Utils/` (log, arquivos, strings), `nlohmann/json` (na pasta do server), `Discord/` (**lib do cliente; não usado no servidor**) |
| `Resource/` | Ícones/RC do servidor (herança de UI do cliente) |
| `Debug/` `Release/` | Apenas logs de build (`.tlog`) |
| `TJBOY/` | **Restos do código do cliente**: `clanmenu/` (UI de clã) e `isaocheck/` (verificação HTTP, anti-cheat do cliente original) |
| `netplay.cpp/.h` (raiz) | Comunicação entre servidores (`rsTRANS_SERVER`), `RecvPlayData`, helpers de busca de personagens/monstros, `GetAreaServerSock` |
| `AreaServer.cpp/.h` (raiz) | Modo servidor de área (conecta a area servers remotos via `smConnectSock3`) |
| `ConnectReader.cpp/.h` (raiz) | Lê `Connect.ini` -> define **`TCP_SERVPORT`** (default 32299) e IP de conexão |
| `field.cpp/.h` (raiz) | Mapas: classe `sFIELD`, gates (`sFGATE`), warpgates (`sWARPGATE`) |
| `fileread.cpp/.h` (raiz) | Helpers de .ini (`LeIniStr`/`LeIniInt`/`WriteIniStr` = `GetPrivateProfileStringA`) + `smConfigDecode` (parser de Devices.ini) |
| `WinDump.cpp` | Crash dump (`unhandled_handler`) |
| `ExemploUso.cpp` | Exemplo didático de uso do ConnectReader (não compõe o jogo) |
| Outros na raiz | `cSkinChanger`, `checkname`, `TextMessage`, `effectsnd`, `playmodel`, `ItemForm`, `smReg`, `language.h`, `atlconv.h` — heranças/utilitários |

**Correções de suposições comuns:** (1) *não* há pasta Network com código — é `smwsock.cpp`; (2) *não* há scripts SQL no repo (pasta `SQL/` vazia); (3) `Animation/`, `PostBox/`, `Debug/`, `Release/` vazias; (4) `TJBOY` e `Resource` são sobras do cliente, não sistemas do servidor; (5) `SrcLang/jts` é texto japonês, não "idioma do server" (o idioma real fica em `English/`).

---

## 3) REDE

**Modelo:** sockets **assíncronos dirigidos por mensagens do Windows** (`WSAAsyncSelect`) + **pool de threads de transferência**. Não é thread-por-conexão.

- **InitBindSock** (`smwsock.cpp:2433`): `socket(AF_INET, SOCK_STREAM)`, `bind`, `listen(sock, MAX_PENDING_CONNECTS=32)`, `WSAAsyncSelect(sock, hwnd, WSA_ACCEPT, FD_ACCEPT)`.
- **`WndProc`** (OnSever.cpp:24694) recebe: `WSA_ACCEPT -> WSAMessage_Accept` (aceita e acha slot livre em `smWSock[CONNECTMAX]`), `WSA_READ -> WSAMessage_Read` -> `RecvMessage` (thread de recv), `SWM_RECVSUCCESS -> RecvMessage` (dispatch de pacotes).
- **Limites:** `CONNECTMAX = 1024` (server), `smSOCKBUFF_SIZE = 8192` (buffer por socket).
- **Threads:** pool fixo de **400 threads de envio + 200 de recebimento** (`TRANS_THREAD_SEND_MAX/RECV_MAX`), filas de espera de 1024 sockets; há também modo sem-thread (legado).
- **Portas:** `TCP_SERVPORT` (default **32299**, lido de `Connect.ini [ConnectServer] Port`), `smConfig.dwServerPort` (Devices.ini, usado se ≠ 0), `TCP_GAMEPORT = 8185` (definido no header, porta usada pelo cliente). `InitBindSock` também define `BindPort = 23` como valor inicial (default da variável, substituído em runtime).
- **Formato de pacote:** `struct smTRANS_COMMAND { int size; int code; int LParam; int WParam; int SParam; int EParam; }` (24 bytes). `size` = tamanho total, `code` = opcode (constantes `smTRANSCODE_*` em `C:/Source Priston/Source Priston/Shared/smPacket.h`, ~2.700 linhas, ex.: `smTRANSCODE_PLAYDATA1 0x48470010`, `smTRANSCODE_VERSION 0x4847008A`).
- **Parse:** `RecvMessage` (OnSever.cpp:18175) — lê `size`/`code` do buffer, valida `code` (`rsCompareSafePacket`), trata **criptografia de pacote** (`smTRANSCODE_ENCODE_PACKET` / chave por jogador `dwDecPacketCode`) e despacha num `switch` gigante (centenas de cases -> handlers de cada sistema: login, playdata, ataque, itens, shop, party, chat, eventos...).
- **Anti-scan:** se o header do pacote for `0x20544547` ("GET " — HTTP), o servidor **bloqueia o IP no Firewall do Windows** e desconecta (smwsock.cpp:355).
- **Config de rede:** `Server\Config\Connect.ini` (`[ConnectServer] IP / Port / Clan`). Os .ini **não estão no repositório** — são criados na implantação ao lado do `Server.exe`.

---

## 4) BANCO DE DADOS

- **Banco: Microsoft SQL Server**, acessado via **ODBC** (`sql.h`/`sqlext.h`, driver `{SQL Server}`), Winsock 1.1 no resto.
- **String de conexão** (Database/SQLConnection.cpp:133): `Persist Security Info=False; Integrated Security=False; Driver={SQL Server}; Server=%s; Database=%s; Uid=%s; Pwd=%s;`
- **Credenciais:** `Server\Config\SQL.ini` -> `[Database] Host / User / Password` (via `initializeSQL()`); fallback embutido no código: servidor `PRIME\DRACO`, usuário `sa`, senha `DRACO123@#` (OnSever.cpp:24970).
- **Camadas de acesso (3):**
 1. **`SQLConnection`** (Database/, novo) — 12 bancos: `UserDB`, `UserDB` (VIP), `ServerDB`, `LogDB`, `ClanDB`, `SoDDB`, `EventosDB`, `ShopCoin`, `Quest`, `GameServer`, `ITEMLogDB`, `PainelDB`. Uso: `Prepare()` (com **bloqueio anti-SQL-injection**: rejeita query com aspas `0x27`), `BindInputParameter`, `Execute`, `GetData`, `NextRow`.
 2. **`SQL`** (SQL.cpp, singleton) — usado pelo shop em jogo e logs.
 3. **`SQLDATA`** (gameSQL.cpp/Gamesql.h, legado) — ODBC com DSN, database `UserDB` fixa.
- **Login:** `ProcessLogin::Login` -> `SELECT password, blocked FROM Users WHERE username=?` — **senha comparada em texto puro** (`boost::equals`), sem hash (achado de segurança relevante).
- **Tabelas reais encontradas no código** (grep nos `Prepare(...)`):
  - Contas/char: `Users`, `UserInfo`, `AllGameUser`, `AccountLogin`, `Banneds`, `CT`, `UL`, `IL`, `GameMasters`
  - Gameplay: `MonsterList`, `Weapons`, `MagicWeapons`, `Armor`, `ArmorT`, `Robes`, `Shields`, `DropList`, `DropItem`, `NpcList`, `NpcMessage`, `NpcSellList`, `FieldIndicators`, `NoticeSystem`
  - Custom BR: `PremiumData` (VIP), `VIP`, `Caravans`, `ArenaRanking`, `AgingFailed`, `Restaure`, `Roleta`, `SodRecord`, `Imposto` (taxa), `ChangeNick`, `ChangeClass`, `ShopItems`, `ShopItemsTime`, `StoreSettings`, `PendingDonations`, `ConfirmedDonations`, `TradeCoin`, `RecvCoins`, `OnlineReward`, `OnlineRewardLog`, `EventPRISTON`, `LowLevelPresent`, `ValeLevelLog`, `QuestionsList`, `Quests`, `PlayerActiveQuest`, `PlayerCompletedQuest`, `QuestRewards`
  - Anti-cheat/log: `CheatLog`, `BannedMac` (MAC/HD banidos), `WindowCheatList`, `FunctionChecksumList`
- **Salvamento de personagem:** arquivos binários `Data\DataServer\userdata\<código do usuário>\<nome>.dat` (+ `userdata_backup`, `userinfo`, pastas de deletados) — o banco guarda conta/premium/quests, o `.dat` guarda o personagem.

---

## 5) SEGURANÇA / ANTICHEAT

- **`Security/Firewall.cpp`** — adiciona regras reais no Firewall do Windows (`netsh advfirewall`) para bloquear/liberar IP+porta; acionado automaticamente em: pacote "GET " (varredura HTTP) e falhas de conexão (smwsock.cpp:355-433).
- **`Security/Joi.hpp`** — biblioteca de validação de entrada (números com min/max/allow/disallow, strings, etc.), usada pelo sistema de itens premium (`sinbaram/sinLinkHeader.h`).
- **Controle de flood de pacotes** (OnSever.cpp:18212): se o jogador mandar **> 251 pacotes de ataque em 5 s** -> log de hack (`RecordHackLogFile`, código 5100) + desconexão.
- **`rsCompareSafePacket`** — valida códigos de pacote recebidos (anti-pacote-forjado).
- **`RecordHackLogFile`** — log central de suspeitas (arquivo + tabela `CheatLog`).
- **Checksum/verificação de cliente:** tabelas `FunctionChecksumList` e `WindowCheatList` (lista de janelas suspeitas consultada do banco).
- **Banimentos:** tabela `BannedMac` (MAC address e `szHDUUID`) verificada no login; `Users.blocked`; lista de IPs bloqueados/liberados (`rsCheckDisableIP`/`rsCheckEnableIP`).
- **Versão:** pacote `smTRANSCODE_VERSION` enviado na conexão (`Server_LimitVersion`); código `version_security` presente.
- **XignCode/XTrap:** hooks existem mas estão **desativados** (`#ifdef _XIGNCODE_SERVER` não definido; `_npGAME_GUARD_AUTH` comentado) — NÃO VERIFICADO se há outro anticheat ativo além do acima.
- **Sessão:** checagem de conta já logada (2ª conexão derruba a antiga após 60 s); senha em **texto puro** = fraqueza confirmada.

---

## 6) COISAS INTERESSANTES (sistemas exclusivos)

- **Roleta** (`Roleta/Roleta.cpp`): evento em que os **10 maiores danos** contra um monstro viram participantes com chance proporcional ao dano; prêmio gravado na tabela `Roleta` (roda em thread própria `ThreadRoleta`).
- **Aging + RestaureItem** (`Aging/RestaureItem.cpp`): quando um item falha no Aging, o jogador pode **recuperá-lo num NPC** pagando (tabela `AgingFailed`); códigos `OPEN_RECOVERY_AGING_NPC 0x50600030`, `GET_FAILED_ITEMS`, `RECOVER_AGING_ITEM`.
- **Caravana** (`Caravana/Caravana.cpp`): NPC caravana que acompanha o jogador (nomeável, salvavel na tabela `Caravans`; pacotes `smTRANSCODE_OPEN_CARAVAN 0x4580605`, `smTRANSCODE_CARAVAN`).
- **VIP** (`VIP/Vip.cpp`): níveis VIP com NPCs premium ("Itens Premiuns", "Loja da Gaby"), itens de cash via `haPremiumItem` (montaria, poção EXP, pet Fênix, vampiric cuspid, caravanas Arma/Hopy/Buma, chapéus...), duração em `PremiumData.TimeLeft`.
- **Shop em jogo** (`Shop/NewShop.cpp`): loja por **moedas** (`WhereCoinsComeFrom`), shop com tempo (`NewShopTime`), doações pendentes/confirmadas (`PendingDonations`, `ConfirmedDonations`).
- **Eventos** (`Eventos/`): **Arena** PvP 5v5 (campo 49, ranking por equipe), **EragonLair** (boss dragão com stages), **Invasao** (campo 53, teleporte/início/fim), **Questions** (quiz com etapas).
- **Castelo Sagrado** (`SrcServer/BlessCastle.h`, `rsInit_Castle`): siege com mercenários (20 soldados por lado), taxas (`Imposto`), ranking Sod (`SodRanking`), salvo no shutdown (`rsSaveCastleInfo`).
- **Bônus globais:** `eventoxp` / `eventodrop` (multiplicadores de EXP e drop ativáveis por comando), `ExpManager.ini` com multiplicador por nível (`Nv[1..150]`), level inicial/final (`g_LevelInicial=1`, `g_LevelFinal=150`).
- **AutoPlayServer:** suporte a bots (máx. 2048) para "encher" o servidor (`AUTOPLAYER_MAX`).
- **Modo LoginServer/billing:** `srBillingMain()` ativável.
- **Comandos GM** (via chat, `GM/ServerCommand.cpp`): `/drop`, `/aging`, `/start_castle`, `/end_castle`, `/easy_castle`, `/giveexp`, `/shutdown`, `/reloadSkill`, `/start_arena`, `/enter_arena`, `/equipes_arena`, `/sod_enter`, `/sod_view`, `/get_bosstime`, `/set_bosstime`, `/end_arena`, `/addcoin`, `/set_eventexp`, `/get_eventexp`, `/set_eventdrop`, `/get_eventdrop`, `/update_quest`, `/ban`, `/forceban`, `/desban`, `/reset_manualpvp`, `/ativar_agingfree`, `/desativar_agingfree`, `/updateranking`, `/show_donate`, `/add_indicador`, `/remove_indicador`, `/reload_indicador`, `/reload_exp`, `/inv`, `/monster`, `/mymonster`, `/event_monster`, `/userid`, `/premium`, `/repot`, `/bau`, `/CLAN>`, `/TRADE>`, `//PARTY`, `//raid`, `/enable_whisper`...
- **Console (CLI):** `exit;`, `shutdown;`, `clear;`, `connected;`, `kick <nome>;`, `reloadGMS;`, `showGMS;`, `reloadConfig;`.
- **Chat:** `PACKET_CHAT_GAME`, sussurro, link de item no chat, chat de party/clã, **lista de palavras bloqueadas no chat comercial** (`pszaWordsTrade` em ChatServer.h), distâncias de alcance (`USER_TALKRANGE 1200`).
- **Discord: NÃO há integração no servidor.** A lib (`Shared/Discord`, discord-rpc) existe, mas só é usada no **cliente** (`SrcGame/src/Game/Discord/`).
- **Sem web/API externa no server** — só o HTTP-check legado do cliente em `TJBOY/isaocheck`.

---

## 7) CONFIG

**Importante: nenhum arquivo .ini existe no repositório** — são criados na implantação. Caminho relativo ao executável: `Server\Config\`. Arquivos referenciados no código:

| Arquivo | Seções/Chaves confirmadas no código |
|---|---|
| `Server\Config\Devices.ini` | Parser `smConfigDecode` (fileread.cpp): modo janela, qualidade de rede, `szServerIP`, `dwServerPort`, `szDataServerIP`, `DebugMode`, comandos de monstro; também preenche `Odbc_Config` (DSN/User/Password/Table) e `rsServerConfig` (Enable_PKField, AutoPlayer, TT_DataServer...) |
| `Server\Config\SQL.ini` | `[Database] Host, User, Password` (SQLConnection.cpp:375; OnSever.cpp:24955) |
| `Server\Config\Server.ini` | `[Server] Maintenance=True/False` (rsRefreshConfig); `[Event] AgingFree`, `MixFree`; `[Config] LevelInicial`, `LevelFinal` |
| `Server\Config\Connect.ini` | `[ConnectServer] IP, Port, Clan` (ConnectReader.cpp) — define `TCP_SERVPORT` (default 32299) |
| `Server\Config\ExpManager.ini` | `[ExpConfig] Nv[1]..Nv[150]` — multiplicadores de EXP por nível |

Outras constantes de runtime relevantes: `rsConnectUserLimit = 800` (limite de jogadores), `CONNECTMAX = 1024` (slots), `fps = 70`, `TCP_GAMEPORT = 8185`.

---

## 8) RESUMO — pasta -> responsabilidade -> arquivos-chave

| Pasta | Responsabilidade | Arquivos-chave |
|---|---|---|
| `SrcServer/` | Núcleo do servidor (entry, dispatch de pacotes, loop, castelo, billing, logs) | `OnSever.cpp`, `DllServer.cpp`, `gameSQL.cpp`, `Login.h`, `BlessCastle.h` |
| `Character/` | Personagens: combate, dano, skills e **save .dat** | `playmain.cpp`, `playsub.cpp`, `damage.cpp`, `record.cpp`, `SkillSub.cpp` |
| `Login/` | Autenticação de contas | `ProcessLogin.cpp` |
| `GameServer/` | Carrega monstros/itens/NPCs/drops do banco | `GameServer.cpp` |
| `Database/` | Camada ODBC moderna (12 bancos) | `SQLConnection.h/.cpp` |
| `SQL.cpp` (raiz) | Singleton ODBC p/ shop e logs | `SQL.cpp`, `SQL.h` |
| `smwsock.cpp` (raiz) | Sockets: accept/recv/send, threads, firewall | `smwsock.cpp/.h` |
| `Chat/` | Chat do jogo | `ChatServer.cpp`, `Chat.h` |
| `Party/` | Grupo/raid | `Party.cpp`, `CPartyHandler.cpp` |
| `Quest/` | Quests via banco | `Quest.cpp/.h` |
| `Shop/` | Loja premium em jogo | `NewShop.cpp`, `NewShopTime.cpp` |
| `GM/` | GMs + comandos `/...` | `GM.cpp`, `ServerCommand.cpp` |
| `CLI/` | Console do servidor | `CLI.cpp/.h` |
| `Security/` | Firewall + validação de entrada | `Firewall.cpp/.h`, `Joi.hpp` |
| `Ranking/` | Rankings geral/PvP/castelo | `TopRanking.cpp`, `PVPRanking.cpp`, `SodRanking.cpp` |
| `Aging/` | Recuperação de itens falhos no Aging | `RestaureItem.cpp/.h` |
| `Roleta/` | Evento roleta por dano | `Roleta.cpp/.h` |
| `Caravana/` | Sistema de caravana | `Caravana.cpp/.h` |
| `Eventos/` | Arena, Dragão, Invasão, Quiz | `Arena.cpp`, `EragonLair.cpp`, `Invasao.cpp`, `Questions.cpp` |
| `VIP/` | Sistema VIP | `Vip.cpp/.h` |
| `PostBox/` | (vazia) — correio usa `Data/PostBox/*.dat` | — (lógica em `record.cpp`) |
| `sinbaram/` | Itens premium (cash) | `haPremiumItem.cpp`, `sinItem.cpp`, `sinInvenTory.cpp`, `sinSkill.cpp`, `sinMain.cpp` |
| `Skills/` | Sistema de magias | `Skills.cpp`, `SkillPacket.h` |
| `smLib3d/` | Biblioteca 3D/mapas herdada | `smMap3d.cpp`, `smObj3d.cpp`, `smSin.cpp`, `smType.h` |
| `English/` | Textos de NPCs (EN) | `e_ServerMsg.h`, `e_TalkText.h`, ... |
| `SrcLang/` | Leitor de texto japonês (legado) | `jts.cpp/.h` |
| `Shared/` (fora) | Protocolo de pacotes + utilidades | `smPacket.h`, `LevelTable.h`, `Utils/`, `Skills/` |
| `ConnectReader` | Lê Connect.ini -> porta/IP | `ConnectReader.cpp/.h` |
| `netplay.cpp` (raiz) | Comunicação servidor<->servidor | `netplay.cpp/.h` |
| `field.cpp` (raiz) | Mapas/portais | `field.cpp/.h` |
| `fileread.cpp` (raiz) | Leitura de .ini + Devices.ini parser | `fileread.cpp/.h` |
| `TJBOY/` | Sobras do cliente (clã, isaocheck) | `clanmenu/*`, `isaocheck/*` |
| `SQL/`, `Network/`, `Animation/`, `Debug/`, `Release/` | Vazias (sem código) | — |

**Não verificado:** conteúdo real dos `.ini` (não existem no repo), scripts de criação do banco (não existem no repo), se o pool de 400/200 threads é efetivamente usado com `smTransThreadMode` ativo no binário, detalhes do algoritmo de criptografia de pacote (`dwDecPacketCode`).