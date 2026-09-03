---
tags: [arquitetura, cliente, servidor, shared]
---

# Arquitetura do Projeto — Source Priston (VERIFICADA)

> **Status:** verificada no código real em 2026-08-31 (análise profunda do
> cliente, servidor e build). Não há mais "(a validar)" — cada pasta abaixo
> teve a responsabilidade confirmada lendo os arquivos.
> Detalhes completos por área nos anexos: `anexos/` (cliente, servidor, build).

## 1. Visão geral

MMO cliente-servidor em **C++** (Visual Studio 2022, toolset v143, **32-bit**),
com duas soluções que compartilham código:

```
C:\Source Priston\Source Priston\
|-- SrcGame/      -> CLIENTE (Game.sln -> Game.exe) - o jogo na tela
|-- SrcServer/    -> SERVIDOR (server.sln -> Server.exe) - a "verdade" do jogo
|-- Shared/       -> código compilado DENTRO dos dois (protocolo, utils, tabelas)
`-- dependencies/ -> bibliotecas de terceiros pré-compiladas (NUNCA editar)
```

- **Cliente:** C++17 · janela Windows · render Direct3D9 via engine Delta3D
- **Servidor:** C++14 · console (sem janela gráfica) · SQL Server via ODBC
- **Saída do build:** `C:\Source Priston\Game.exe` e `Server.exe` (fora do repo)

### Regra de ouro

**Tudo que precisa ser idêntico nos dois lados vive em `Shared/`** — o
protocolo de rede (`smPacket.h`), a tabela de XP (`LevelTable.h`), as
skills por classe (`Skills/*.h`) e utilidades (`Utils/`). O `Shared.vcxitems`
faz esse código ser compilado **dentro de cada executável**. Mudar só de um
lado = jogo dessincronizado.

---

## 2. CLIENTE — `SrcGame/`

Solução: `Game.sln` -> projeto `src/game.vcxproj`. Entry point real:
**`src/Game/Winmain.cpp`** (linha 529, `WinMain`). Cuidado: `Main.cpp`,
`Game.cpp`, `CSystem.cpp`, `UnitGame.cpp` e `View.cpp` são **código morto**
(sobras de tutorial) — não se engane com os nomes.

### Ciclo de vida

1. Anti-debug/anti-hack no boot (`SetUnhandledExceptionFilter` + hook),
 limite de 4 instâncias do jogo.
2. Lê `game.ini` -> preenche `smConfig` (resolução, som, câmera, IP/porta).
3. Cria a janela -> `InitD3D` (Direct3D9 + Delta3D) -> ImGui -> Discord ->
 socket -> tela de login (`GameMode 1`).
4. Game loop: `PeekMessage -> PlayD3D() + PlayRecvMessageQue()` — renderiza
 e processa pacotes da rede no mesmo loop.
5. Login: `HoOpening` (conta/senha) -> DataServer
 (`smTRANSCODE_ID_GETUSERINFO`) -> lista de servidores -> escolha do mundo ->
 `ConnectServer_GameMain` -> `GameMode 2` (jogo).

### Mapa de pastas do cliente (responsabilidades confirmadas)

| Pasta/Arquivo | Responsabilidade |
|---|---|
| `Winmain.cpp` (5.336 l.) | Entry point: janela, game loop, `PlayD3D`/`smPlayD3D` (render), `WndProc` (input), quit |
| `Engine/` | **Engine gráfica nova** (C++17, DX9/Delta3D): `Directx/` (renderer, câmera, terreno `Terrain.fx`, fontes, sprites, pós-processamento), `UI/` (**framework de janelas moderno**: UIWindow, UIButton, UIText...), `Keyboard/`, `Mouse/`, `Timer/`, `DynamicAnimation/` (animações SMD/INX) |
| `sinbaram/` (38 .cpp) | **Núcleo do jogo em si** (sistema legado "sin"): `sinMain` (loop in-game), `sinInterFace` (HUD clássico), inventário, itens, loja, troca, skills, quests, efeitos, `haPremiumItem` (itens de cash) |
| `HoBaram/` | Engine/UI legada "Ho": `HoOpening` (abertura + conta/senha), `HoLogin` (3.618 l., seleção de personagem/mundo), `HoParty`, efeitos/física/céu, pets (`LowLevelPet`, `PCBangPet`), efeitos com **Lua 5.0.2** |
| `character.cpp` (16.249 l.) | Classe **`smCHAR`** — todo personagem (posição, animação, ataque, render). O coração do cliente |
| `field.cpp` | Classe **`sFIELD`** — mapas: gates, warps, spawns, música, `FieldMain()` |
| `netplay.cpp` (13.681 l.) | **Rede do cliente**: despacho de TODOS os pacotes (`RecvMessage`), login, filas |
| `smwsock.cpp` | Winsock: 2 threads por conexão (send/recv), criptografia XOR `0x8B` |
| `Damage.cpp` | Dano, alvos em área, encode/decode de pacotes de dano, anti-speedhack |
| `ActionGame.cpp` | Movimento por teclado + dash + auto-alvo |
| `playsub.cpp` / `playmain.cpp` | HUD clássico (`DrawGameState`) / loop in-game + carregar mapas |
| `GameCore.cpp` | **`CGameCore`** — gerenciador das janelas modernas (chat, party, minimapa, tooltips) |
| `HUD/` | Overlays novos: minimapa, dano, alvo, ranking, roleta, SOD (alguns em **ImGui**) |
| `Login/` | Tela de login nova (checkbox "Lembrar ID", seleção de mundo "Draco Priston") |
| `Chat/` | Chat novo (janela moderna) |
| `Party/` | Party/raid |
| `Quest/` | Quest + `QuestWindow` (1.474 l.) |
| `Shop/` | Loja nova + itens premium por tempo |
| `Caravana/` | Sistema de caravana (comércio móvel) |
| `Eventos/` | Arena (PvP em times), WarMode; **Invasao é stub** (1 linha) |
| `Skill/` | `SkillManager` — janela/tooltips de habilidades |
| `Montarias/` | Montarias (modelos, animações) |
| `VIP/` | Nível VIP do jogador + comandos |
| `Discord/` + `Discord.cpp` | **Discord Rich Presence** (App ID `898283856086597702`) |
| `AntiCheat.cpp` / `cracker.cpp` / `checkdll.cpp` | Anti-cheat: checksums de funções, anti-hook/anti-debug, busca de DLLs de hack, NProtect |
| `cSkinChanger.cpp` | Janela de **skins** (aparência alternativa de itens) |
| `CurseFilter.cpp` | Filtro de palavras ofensivas no chat |
| `Settings.cpp` | Janela de configurações + leitura/gravação do `game.ini` |
| `WinInt/` | Downloads HTTP (sons), threads de internet, `ohZipLib` |
| `API/` | **Chilkat** + libcurl (bibliotecas externas, não é código do jogo) |
| `TJBOY/` | Subsistemas legados: menu de clã, auth/launcher (isaocheck), ParkPlayer |
| `smLib3d/` | **Engine 3D legada** (era DirectX 7/8): stages `.dsx`, objetos, render antigo |
| `srcsound/` | Áudio legado (DirectSound) |
| `imGui/` | Biblioteca Dear ImGui 1.83 WIP (HUDs novos) |
| `srcServer/` | Só headers: textos/mensagens do servidor traduzidos (lang) |
| `game.ini` | Config do cliente (ver seção 5) |

### UI: 3 sistemas convivendo

1. **Clássico "sin"** — janelas desenhadas com texturas (`game\images\...`)
 + `DrawFontText` (inventário, status, loja...).
2. **Moderno `Engine/UI`** — classes `UIWindow`/`UIElement` com eventos
 (login novo, chat, quests). Gerenciadas pelo `CGameCore`.
3. **ImGui** — overlays/alertas dos sistemas novos (HUD/InstancesFlag,
 Roleta, RankingWindow, SodWindow...).

> Ao editar UI: **descubra primeiro qual sistema a tela usa** (sin, Engine/UI
> ou ImGui) antes de mexer — os três coexistem.

### Anti-cheat do cliente

`CAntiCheat` (thread própria): checksum de funções críticas (detecta hooks,
inclusive `GetTickCount` anti-speedhack), enumera janelas com nomes de
cheats, procura DLLs de hack no diretório. `cracker.cpp` valida checksum de
funções e NProtect. Em runtime: `LockSpeedProtect` + `_PACKET_PASS_XOR`.

---

## 3. SERVIDOR — `SrcServer/`

Solução: `server.sln` -> projeto `src/server.vcxproj`. **Console application**
(sem janela gráfica). Idioma: core original em coreano (CP949) + camada de
modificações em português. ~260 arquivos — mas **`SrcServer/OnSever.cpp`
tem 34.764 linhas (1 MB)** e concentra quase toda a lógica do jogo.

### Ciclo de vida

1. `Winmain.cpp:83` — `main()`: hook de crash, lê `Devices.ini`,
 `initializeSQL()` (banco), chama `ServerWinMain()`.
2. `OnSever.cpp:24944` — `ServerWinMain()`: conecta o singleton `SQL` (shop),
 cria janela *message-only* (sem UI — servidor dirigido por mensagens),
 carrega skills/quests/GMs, `InitAll()` (aloca jogadores, carrega
 monstros/itens/NPCs **do banco**, mapas, timer de 100 ms), `InitBindSock`
 (bind + listen), dispara thread do **console CLI**.
3. **Loop:** `PeekMessage` + `WM_TIMER` (100 ms) -> `srPlayMain()` (fps 70,
 bots, eventos, logs).
4. **Desligamento:** salva castelo -> salva `.dat` dos personagens online ->
 fecha banco -> limpa tudo.

### Mapa de pastas do servidor (responsabilidades confirmadas)

| Pasta | Responsabilidade | Arquivos-chave |
|---|---|---|
| `SrcServer/` (raiz) | **Núcleo**: entry, dispatch gigante de pacotes (`RecvMessage`), loop, castelo, billing | `OnSever.cpp` (34.764 l.), `DllServer.cpp`, `gameSQL.cpp`, `BlessCastle.h` |
| `Character/` | Personagens: combate, dano, skills, **save `.dat`** | `playmain.cpp`, `playsub.cpp`, `damage.cpp`, `record.cpp` |
| `Login/` | Autenticação de conta (UserDB, tabela `Users`) | `ProcessLogin.cpp` |
| `GameServer/` | Carrega do banco: monstros, itens, NPCs, drops | `GameServer.cpp` |
| `Database/` | **Camada ODBC moderna** — 12 bancos | `SQLConnection.h/.cpp` |
| `SQL.cpp` (raiz) | Singleton ODBC p/ shop em jogo + logs | `SQL.cpp`, `SQL.h` |
| `smwsock.cpp` (raiz) | **Sockets**: accept/recv/send, threads, firewall automático | `smwsock.cpp/.h` |
| `Chat/` | Chat (normal, sussurro, item-link, filtro) | `ChatServer.cpp`, `Chat.h` |
| `Party/` | Grupo/raid (máx. 6 membros, 2 raids) | `Party.cpp`, `CPartyHandler.cpp` |
| `Quest/` | Quests vindas do banco | `Quest.cpp/.h` |
| `Shop/` | Loja premium em jogo (+ por tempo) | `NewShop.cpp`, `NewShopTime.cpp` |
| `GM/` | GMs do banco + **comandos `/...` no chat** | `GM.cpp`, `ServerCommand.cpp` |
| `CLI/` | Console do servidor (`exit;`, `kick <nome>;`...) | `CLI.cpp/.h` |
| `Security/` | Firewall do Windows + validação de entrada | `Firewall.cpp`, `Joi.hpp` |
| `Ranking/` | Rankings geral/PvP/castelo | `TopRanking.cpp`, `PVPRanking.cpp`, `SodRanking.cpp` |
| `Aging/` | Recuperação de itens falhos no Aging | `RestaureItem.cpp` |
| `Roleta/` | Evento roleta (top dano vira sorteio) | `Roleta.cpp` |
| `Caravana/` | Sistema de caravana | `Caravana.cpp` |
| `Eventos/` | **Arena PvP**, **EragonLair** (dragão), **Invasao**, **Questions** (quiz) | `Arena.cpp`, `EragonLair.cpp`, `Invasao.cpp`, `Questions.cpp` |
| `VIP/` | Sistema VIP + NPCs premium | `Vip.cpp` |
| `sinbaram/` | Itens premium/cash (montaria, poções EXP, pets...) | `haPremiumItem.cpp`, `sinItem.cpp`... |
| `Skills/` | Magias (`openSkills`, 5.600+ linhas) | `Skills.cpp`, `SkillPacket.h` |
| `smLib3d/` | Biblioteca 3D herdada do cliente (mapas, matrizes) | `smMap3d`, `smObj3d`, `smSin`, `smType.h` |
| `English/` | Textos de NPCs em inglês (headers `#include`) | `e_ServerMsg.h`, `e_TalkText.h` |
| `SrcLang/` | Leitor de texto japonês (legado) | `jts.cpp/.h` |
| `Data/` | **Salvamento binário dos personagens**: `DataServer/userdata/<código>/<nome>.dat` | (vazio no repo — gerado em runtime) |
| `netplay.cpp` (raiz) | Comunicação servidor<->servidor | `netplay.cpp/.h` |
| `AreaServer.cpp` | Modo servidor de área | `AreaServer.cpp/.h` |
| `ConnectReader.cpp` | Lê `Connect.ini` -> porta `TCP_SERVPORT` | `ConnectReader.cpp/.h` |
| `field.cpp` (raiz) | Mapas/gates | `field.cpp/.h` |
| `fileread.cpp` (raiz) | Helpers de `.ini` + parser do `Devices.ini` | `fileread.cpp/.h` |
| `TJBOY/` | **Sobras do cliente** (clã, isaocheck) — não é sistema do servidor | `clanmenu/*` |
| `SQL/`, `Network/`, `Animation/`, `PostBox/`, `Debug/`, `Release/` | **Vazias** (sem código) | — |

### Rede do servidor

- **Modelo:** sockets assíncronos por **mensagens do Windows**
 (`WSAAsyncSelect`) + pool fixo de **400 threads de envio + 200 de
 recebimento** (filas de até 1024 sockets). Não é 1 thread por conexão.
- **Limites:** `CONNECTMAX = 1024` slots, `rsConnectUserLimit = 800` jogadores.
- **Portas:** `TCP_SERVPORT` = **32299** (lida do `Connect.ini`, usada no
 login/DataServer) · `TCP_GAMEPORT` = **8185** (definida no header) ·
 `smConfig.dwServerPort` (Devices.ini, se ≠ 0).
- **Formato de pacote:** `struct smTRANS_COMMAND { int size; int code; int
 LParam; int WParam; int SParam; int EParam; }` (24 bytes) — `code` é o
 `smTRANSCODE_*` do `Shared/smPacket.h`.
- **Parse:** `RecvMessage` (OnSever.cpp:18175) — valida (`rsCompareSafePacket`),
 trata criptografia (`smTRANSCODE_ENCODE_PACKET`, chave por jogador
 `dwDecPacketCode`) e despacha num `switch` gigante (centenas de cases).
- **Anti-scan:** pacote com header `"GET "` (HTTP) -> **bloqueia o IP no
 Firewall do Windows** e desconecta.

### Segurança / anti-cheat do servidor

- `Security/Firewall.cpp` — regras reais no Firewall do Windows
 (`netsh advfirewall`) contra IPs suspeitos.
- Controle de flood: > 251 pacotes de ataque em 5 s -> log de hack + kick.
- `RecordHackLogFile` -> tabela `CheatLog`; ban por MAC/HD (`BannedMac`).
- **Senha em texto puro** (comparada sem hash no login) — fraqueza
 conhecida, anotada como pendência.

### Sistemas exclusivos do servidor

**Roleta** (10 maiores danos viram sorteio), **Aging+RestaureItem** (recuperar
item falho pagando), **Caravana** (NPC escolta), **VIP** (níveis + NPCs
premium "Loja da Gaby"), **Shop por moedas**, **Arena PvP 5v5**, **EragonLair**
(boss dragão), **Invasão**, **Quiz**, **Castelo Sagrado** (siege com
mercenários + impostos), multiplicadores globais **eventoxp/eventodrop**,
**AutoPlayServer** (bots, máx. 2048), ~50 **comandos GM** (`/drop`, `/aging`,
`/giveexp`, `/addcoin`, `/ban`, `/set_eventexp`...), console CLI
(`kick`, `reloadGMS`, `shutdown`...).

> **Discord NÃO existe no servidor** — a lib `Shared/Discord` é usada só no
> cliente (Rich Presence).

---

## 4. COMPARTILHADO — `Shared/`

| Arquivo/Pasta | O que é |
|---|---|
| `smPacket.h` | **O contrato de rede** (~2.800 linhas): todos os `smTRANSCODE_*` + structs (`smTRANS_COMMAND`, `smCHAR_INFO`, `TRANS_ATTACKDATA`, `rsPLAYINFO`...). Ver [[Protocolo-de-Rede]] |
| `LevelTable.h` | Tabela de **XP por nível** (até nível ~380; números gigantes no fim = curva de level alto) |
| `GlobalsShared.h` | Constantes do jogo: limites de ouro (`MAX_GOLD_*`), tempos de item prime (`PRIME_ITEM_TIME_*`), flags de usuário (`BIMASK_VIP_USER`...), códigos de classe (`JOBCODE_*`), classes de monstro (`MONSTER_CLASS_*`) |
| `Skills/*.h` | Skills por classe (8 classes: archer, atalanta, fighter, knight, magician, mechanician, pikeman, priestess) |
| `Utils/` | Matemática 3D (`X3D*`), FileReader, Debug, logs, mutex, strings — compilado nos dois lados |
| `rapidjson/` | JSON **1.1.0** (usado no Discord/serialização) |
| `zlib/` | **zlib 1.2.11** (fonte; binário linkado de `C:\Temp\Libs`) |
| `Discord/` | SDK **discord-rpc** (Rich Presence) — usado só no cliente |
| `Shared.vcxitems` | O projeto "compartilhado" — importado pelos 2 .vcxproj |

---

## 5. Configurações

### Cliente — `game.ini` (junto do executável)

| Seção | Chaves | O que controla |
|---|---|---|
| `[Screen]` | `Windowed`, `Width`, `Height`, `Ratio` | janela/fullscreen, resolução, proporção |
| `[Graphics]` | `BitDepth`, `HighTextureQuality`, `TextureQuality`, `VSync`, `Damage`, `Effects`, `DynamicLights/Shadows` | qualidade gráfica |
| `[Audio]` | `NoSound`, `Music`, `Sound`, `Ambient` + volumes | áudio |
| `[Camera]` | `FarCameraSight`, `InvertedCamera`, `cCamView`, `cCamRange` | câmera |
| `[ConnectServer]` | **`IP`, `Port`** | **pra onde o cliente conecta** (hoje: `189.46.228.170:31620`) |

> **Atenção:** O IP atual é de um servidor externo antigo. Para teste local use
> `IP=127.0.0.1` e a porta que seu servidor escuta.

### Servidor — `Server\Config\*.ini` (criados na implantação, NÃO estão no repo)

| Arquivo | Conteúdo |
|---|---|
| `Devices.ini` | IP/porta do servidor, qualidade de rede, DebugMode, `Odbc_Config` |
| `SQL.ini` | `[Database] Host, User, Password` — conexão com o banco |
| `Server.ini` | `[Server] Maintenance`, `[Event] AgingFree, MixFree`, `[Config] LevelInicial, LevelFinal` (1–150) |
| `Connect.ini` | `[ConnectServer] IP, Port, Clan` — define `TCP_SERVPORT` (32299) |
| `ExpManager.ini` | `[ExpConfig] Nv[1..150]` — multiplicadores de EXP por nível |

---

## 6. Build e dependências (resumo — detalhes em `anexos/Relatorio-Analise-Build.md`)

- **2 soluções:** `Game.sln` e `server.sln`; só **Debug|Win32** e **Release|Win32** (não existe x64).
- **Toolset v143** (VS2022) · Cliente C++17 · Servidor C++14 · `CharacterSet=MultiByte`.
- **Saída:** `Game.exe` e `Server.exe` vão para **`C:\Source Priston\`** (pasta pai do repo). `OutDir/` só tem intermediários (.obj).
- ****Atenção:** Debug está quebrado nesta máquina** (caminhos absolutos do dev original: `C:\Source\Libs`, `C:\Libs`). **Use Release|Win32** — é a config comprovadamente funcional.
- **Dependências:** Delta3D (engine 3D própria, D3D9, math do Urho3D — pré-compilada em `dependencies/`), ZipArchive (assets .pak), zlib 1.2.11, rapidjson 1.1.0, discord-rpc, imGui 1.83, Lua 5.0.2, Chilkat + libcurl 7.69.1, DirectX SDK June 2010 em `C:\Temp\Libs\DX9`.
- Sem scripts de build (.bat/.cmd) — tudo pelo Visual Studio. Ver [[Como-Compilar]].

---

## 7. O que NÃO existe (para não procurar em vão)

- [ ] Scripts `.sql` de criação do banco (pasta `SQL/` vazia — schema roda manualmente)
- [ ] Pasta `Network/` com código (socket layer é `smwsock.cpp`)
- [ ] Assets do jogo (mapas, imagens, sons ficam em `game\` junto do executável)
- [ ] Integração Discord no servidor
- [ ] Define `__SERVER__`/`__CLIENTE__` (cliente e servidor são projetos separados, sem `#ifdef` cruzado)

---

## 8. Ver também

- [[Protocolo-de-Rede]] · [[Banco-de-Dados]] · [[Glossario-Tecnico]] · [[SDD-Source-Priston]]
- Guias: [[Como-Compilar]] · [[Como-Rodar]]
- Anexos: `anexos/Relatorio-Analise-Cliente.md` · `anexos/Relatorio-Analise-Servidor.md` · `anexos/Relatorio-Analise-Build.md`