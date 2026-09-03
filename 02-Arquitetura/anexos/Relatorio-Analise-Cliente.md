# Deep-Dive do CLIENTE — Priston Tale (SrcGame)

**Escopo:** `C:\Source Priston\Source Priston\SrcGame` (projeto `Game.sln` -> `src/game.vcxproj`)
**Stack:** C++17, Visual Studio 2022 (PlatformToolset **v143**), Win32 (32-bit), Windows SDK 10.0.26100
**Tamanho:** 1.161 arquivos no repo do cliente; `src/Game` = 295 `.cpp` + 822 `.h`
**Convenção de verdade:** tudo abaixo foi lido/confirmado no código. Onde há inferência, está marcado **NÃO VERIFICADO**.

> Nota de leitura: muitos arquivos antigos estão em codificação coreana (CP949/EUC-KR); os comentários aparecem como "lixo" em editores, mas o código é válido.

---

## 1. ENTRY POINT

### Onde o programa começa
| Arquivo | Papel |
|---|---|
| `src/Game/Winmain.cpp` (5.336 linhas) | **Arquivo principal de verdade.** Contém `WinMain`, a janela, o game loop, `InitD3D`, `PlayD3D` (loop de frames), `smPlayD3D` (renderização), `WndProc` (entrada de input). |
| `src/Game/Main.cpp` | **Código morto** — tem um `WinMain` de exemplo comentado (tutorial) que criaria `std::shared_ptr<Game>`. Não compila no fluxo real. |
| `src/Game/Game.cpp` / `Game.h` | **Stub** — `Game::Init()` só retorna TRUE. Classe sobrou de um tutorial, não usada. |
| `src/Game/CSystem.cpp` / `CSystem.h` | **Código morto** — esqueleto de tutorial (janela "Priston Tale" + `DXGraphicEngine` + loop com `Frame()` vazio). **NÃO é o sistema real** — a janela real é criada no `Winmain.cpp`. |
| `src/Game/ActionGame.cpp` | Não é entry point: é o **controle de movimento/ataque** por teclado+mouse (ver seção 2). |

### `WinMain` (Winmain.cpp:529)
Fluxo real:
1. **Anti-hack de startup:** `SetUnhandledExceptionFilter` + hook do próprio `SetUnhandledExceptionFilter` (anti-debugger); `AntiDebugger()`; cria `CAntiCheat` e inicia thread de checagem.
2. **Limite de clientes:** `EnumWindows` conta janelas do jogo; se > 4, `ExitProcess(0)`.
3. **Lê `game.ini`** (seções `Screen`, `Graphics`, `Audio`, `Camera`, `ConnectServer`) e preenche a struct global `smConfig` (`smConfig.h`). O IP/porta do servidor vão para `smConfig.szServerIP`, `szDataServerIP` e `TCP_SERVPORT` (padrão 32299).
4. **Cria a janela** — classe `szAppName`, título da janela "PristonPK" (depois trocado para "PROJETO PRISTON - L. JURYS E THIAGO B."). Modo janela (`WS_CAPTION|WS_SYSMENU|...`) ou fullscreen (`WS_POPUP|WS_EX_TOPMOST`) conforme `[Screen] Windowed`.
5. **`InitD3D(hwnd)`** (Winmain.cpp:3175): `GRAPHICENGINE->InitD3D(hwnd, largura, altura)` -> `SetDisplayMode` -> `InitRender()`/`InitTexture()` -> `GameInit()` (inicializa materiais, efeitos, stage, `sinInit()` = HUD Sinbaram) -> cria o jogador (`InitRotPlayer()`).
6. **Inicializa ImGui** (`ImGui_ImplWin32_Init` + `ImGui_ImplDX9_Init`) — usado pelo chat/HUD novos; `Discord_Handle.Initialize()` (Rich Presence); `InitGameSocket()` (Winsock); `SetGameMode(1)` (modo "opening/login").

### Game loop (Winmain.cpp:834)
```cpp
while (TRUE) {
 if (PeekMessage(&msg, ...)) { TranslateMessage; DispatchMessage; } // eventos Windows (input)
 else { PlayD3D(); PlayRecvMessageQue(); } // update + render + rede
 // se quit: salva jogo (SaveGameData) e sai
}
```
- `PlayD3D()` (Winmain.cpp:2571) — loop de frames **com passo fixo** (`FPS_TIME`): atualiza timers, câmera (trace atrás do jogador), e despacha por `GameMode`:
  - `GameMode 1` -> `MainOpening()` (tela de abertura + login).
  - `GameMode 2` -> `PlayMain()` + `sinMain()` (jogo em si).
- `PlayRecvMessageQue()` -> `rsMainServer.RecvMessageQue()` — processa pacotes recebidos (ver seção 5).

### Renderização (`smPlayD3D`, Winmain.cpp:4674)
Ordem real de render por frame:
1. `Renderer->Begin()` -> `ImGuiFlags::InstancesFlag()` (overlay ImGui)
2. Câmera: `MakeTraceMatrix` + `camera->SetPosition(...)` (câmera nova `Graphics::Camera`, Delta3D)
3. `RenderShadowMap()` -> pós-processamento (`DX::postProcess`, efeito "Dead" quando o personagem morre)
4. `DrawSky()` -> `DrawPat3D()` (personagens) -> `DisplayStage()` (mapa/terreno, shader `Terrain.fx`) -> `DrawPat3D_Alpha()` -> `DrawPatShadow()` (sombras)
5. `DrawEffect()` -> `cSin3D.Draw()` -> `DrawPat2D()` -> fim do pós-processo -> glow de seleção (`DX::cSelectGlow`)
6. **HUD 2D:** `DrawGameState()` (UI clássica `sin*`) -> `showFPS()` -> `Discord_Handle.Update()` -> `TitleBox::Render()` -> `Renderer->End()`

### Input (mouse/teclado)
- `WndProc` (Winmain.cpp:1156) + `GameWindowMessage` (Winmain.cpp:5024):
  - Teclado: `WM_KEYDOWN/WM_KEYUP` -> array global `BYTE VRKeyBuff[256]` (estado de teclas).
  - Mouse: `WM_LBUTTONDOWN/UP`, `WM_RBUTTONDOWN/UP` -> `MouseButton[0..2]`; movimento -> `MouseX/MouseY`, `pCursorPos` (cursor virtual do jogo).
  - Atalhos: `Ctrl+F12` (relog?), `Esc`, `Tab`, `Enter` (chat), suporte a **IME asiático** (`Ime.cpp`, `imm32`).
- O jogo lê `VRKeyBuff[...]` em `PlayMain` (setas = câmera/movimento) e `ActionGameMain()` (setas + espaço = andar/atacar). Mouse na borda da tela gira a câmera.

### Como o cliente conecta no servidor (login)
Fluxo confirmado em `HoBaram/HoOpening.cpp` + `HoBaram/HoLogin.cpp` + `netplay.cpp`:
1. **HoOpening** — tela de abertura com campos de **conta/senha** (usa um controle `EDIT` do Windows, `hTextWnd`, com IME).
2. `LoginDataServer()` cria thread -> `ConnectServer_InfoMain()` (conecta no **DataServer**: IP de `game.ini`, porta `TCP_SERVPORT`) -> envia `TransUserCommand(smTRANSCODE_ID_GETUSERINFO, conta, senha)`.
3. Servidor devolve lista de servidores/mundos + personagens do usuário (`smTRANSCODE_ID_SETUSERINFO` processado em `HoRecvMessage`).
4. Jogador escolhe o mundo -> `LoginGameServer(índice)` -> `ConnectServer_GameMain(IP1:porta1, IP2:porta2, IP3:porta3)` (até 3 servidores: principal/usuário/estendido) -> entra no jogo (`GameMode 2`).
5. A tela de login **nova** (`Login/LoginScreen.cpp`, com checkbox "Lembrar ID" e fundo vídeo `login.asf`/imagem) roda **dentro** do HoOpening.

---

## 2. MÓDULOS DO JOGO (pasta -> responsabilidade real)

### Pastas em `src/Game/`

| Pasta | Responsabilidade confirmada (arquivos lidos) |
|---|---|
| **Engine/** | Nova engine gráfica C++17 sobre DirectX9/Delta3D (`Graphics::`). `Directx/`: `DXGraphicEngine`, `DXRenderer`, `DXTerrain` (shader `Terrain.fx`), `DXCamera`, `DXFont`, `DXSprite`, `DXTexture`, `PostProcess`, `DXSelectGlow`, `DXVideoRenderer` (vídeo AVI/ASF do login). `UI/`: **framework de janelas moderno** — `UIWindow`, `UIElement`, `UIButton`, `UIImage`, `UIText`, `UIList`, `UIItemBox`, `UITooltip`, `UIMessageBox`, `UICheckBox`, `UIDropdownMenu`, etc. `Keyboard/`, `Mouse/`, `Timer/`: classes `CKeyboard`, `CMouse`, `Core::Timer`. `DynamicAnimation/`: import/export de animações **SMD/INX** (3D Studio Max). `CFont.cpp`: fontes. |
| **HUD/** | Overlays de interface: `MiniMap/MiniMapHandler.cpp` (minimapa), `Party/CPartyWindow.cpp` (janela de party/raid), `HudController.cpp` (alvo selecionado), `DisplayDamage.cpp` (números de dano), `MessageBox.cpp`, `RankingWindow.cpp`, `RestaureWindow.cpp`, `Roleta.cpp` (roleta de prêmios), `SodWindow.cpp`, `MixWindow.cpp`, `CustomHud.cpp`, `InstancesFlag.cpp` (**HUD ImGui**: alertas/chat/whisper). |
| **Login/** | Tela de login nova: `LoginScreen.cpp` (checkboxes "Lembrar ID", "Login Animado", seleção de mundo "Draco Priston") e `LoginModel.cpp`. Chamada pelo `HoOpening`. |
| **Chat/** | Chat novo (`CHAT::Window` + `CHAT::Handle`, herdam `CBaseWindow`/`CBaseHandle`): render, histórico, clique, teclado. Registrado no `CGameCore`. |
| **Party/** | `CPartyHandler.cpp` — gerência de party/raid (membros vivos/mortos, membros seguros, update periódico). |
| **Quest/** | `Quest.cpp` (estado das quests, dados comprimidos `QUEST_COMPRESSEDPCKG`) + `QuestWindow.cpp` (janela de quests, 1.474 linhas). |
| **Shop/** | Loja nova: `NewShop.cpp` (categorias, preços, desconto, compra) + `NewShopTime.cpp` (itens premium por tempo). |
| **Caravana/** | `Caravana.cpp` — sistema de caravana (comércio móvel: seguir/ficar/renomear, `CrashWareHouseItem`, checksum) + `ChangeCaravanName.cpp`. |
| **Eventos/** | `Arena.cpp` (EventoArena — PvP em equipes com ranking), `WarMode.cpp` (Modo Guerra/PvP), `Invasao.cpp` (**stub de 1 linha** — evento não implementado aqui). |
| **Discord/** | Biblioteca **discord-rpc** + wrapper `Discord.cpp` (top-level) — Rich Presence (App ID `898283856086597702`), `Discord_Handle.Update(lpCurPlayer)`. |
| **Skill/** | `SkillManager.cpp` (1.937 linhas) — janela de habilidades: infobox, tooltips, valores por nível, mastery, pet mode. |
| **sinbaram/** | **Núcleo do jogo em si** (38 `.cpp`): `sinMain.cpp` (loop in-game), `sinInterFace.cpp` (HUD clássico), `sinItem.cpp`, `sinInvenTory.cpp` (inventário), `sinCharStatus.cpp` (status), `sinShop.cpp`, `sinTrade.cpp` (troca), `sinQuest.cpp`, `sinSkill.cpp`/`sinSkillEffect.cpp`, `sinEffect.cpp`/`sinEffect2.cpp`, `sinParticle.cpp`/`AssaParticle*.cpp`, `sin3D.cpp`, `sinEvent.cpp`, `sinMessageBox.cpp`, `sinMedia.cpp`, `sinHelp.cpp`, `sinWarpGate.cpp`, `sinPublicEffect.cpp`, `sinPetMessage.cpp`, `sinMsg.cpp`, `sinUtil.cpp`, `sinSOD2.cpp`, `sinSubMain.cpp` (regen de stamina a cada 1s, skills contínuas), `HaQuest.cpp`, `haPremiumItem.cpp`, `YameEffect.cpp`, `SkillFunction/` (Tempskron, Morayion). |
| **HoBaram/** | Engine legada "Ho" (UI/física/partículas): `HoOpening.cpp` (tela de abertura + campos conta/senha), `HoLogin.cpp` (3.618 linhas — tela de login clássica: lista de servidores, seleção/criação/exclusão de personagem), `HoParty.cpp` (janela de party clássica + abas de quest/amigos/whisper), `HoEffect.cpp`/`HoParticle.cpp`/`HoPhysics.cpp`/`HoSky.cpp` (efeitos/céu), `HoLogic.cpp`, `HoAnimData.cpp`, `LowLevelPetSystem.cpp`/`PCBangPetSystem.cpp` (pets), `NewEffect/HoEffect/Script/Lua` (efeitos com script Lua). |
| **TJBOY/** | Subsistemas "TJ": `clanmenu/` (menu de clã completo — `cE_user`, `cE_Cmake`, `cE_CJoin`, `cE_chip`, `cE_Notice`, `cE_SelectCha`, `Zip.cpp`, `NpcWav.cpp`, `Help.cpp`, `GuideHelp.cpp`...), `isaocheck/` (auth/launcher), `park/ParkPlayer` (reprodução de vídeo), `Ygy/` (`memmap` = memória compartilhada, `Packet`, `Process`, `MainWnd` — aparenta comunicação com launcher; **NÃO VERIFICADO** o propósito exato). |
| **WinInt/** | Internet: `WinIntThread.cpp` (thread de downloads), `WavIntHttp.cpp` (**download de sons via HTTP**, `InternetOpen`), `RingBuff.h`/`ZipLib.h`/`ohZipLib.lib` (zip). |
| **API/** | **Chilkat** (biblioteca gigante C++: HTTP, SSL, cripto, zip...) + `libcurl_a_debug.lib`. Não é código do jogo. |
| **Montarias/** | `CMountHandler.cpp`/`CMountManager` — montarias: carregar modelos, adicionar/remover montaria no personagem, visibilidade, animações. |
| **VIP/** | `VIP.cpp` — nível VIP do jogador (`lpCurPlayer->vipLevel`), comandos VIP, tempo de premium. |
| **TitleBox/** | `TitleBox.cpp` — texto de título temporário no topo da tela (`SetText`, `Render`). |
| **Park/** | `HoMessageBox.cpp` — caixas de mensagem clássicas (nomes com 2-3 linhas, marca de clã). |
| **Server/** | **Vazia.** |
| **srcServer/** | Só headers: mensagens/idioma do servidor do ponto de vista do cliente (`LangServerMessage.h`, `LangQuestMsg.h`, `LangSkillInfo.h`, `LangTextMessage.h`, `HackTrap.h`, `BlessCastle.h`, `ClientFuncPos.h`, `onserver.h`). |
| **SrcLang/** | `jts.cpp` — checagem de texto japonês/2-bytes para o chat. |
| **srcsound/** | Áudio legado: `Wave.cpp` (carregar WAV), `Dxwav.cpp` (DirectSound). — 1 linha |
| **smLib3d/** | **Engine 3D legada** (era DirectX 7/8): `smStage3d` (mapa), `smObj3d`, `smMap3d`, `smRend3d`, `smTexture`, `smDsx` (formato de stage), `smJpeg`, `smMatrix`, `FilterEffect`. — 1 linha |
| **imGui/** | Biblioteca **Dear ImGui** (UI imediata para DX9) usada pelos HUDs novos. — 1 linha |

### Arquivos `.cpp` soltos importantes (raiz de `src/Game/`)

| Arquivo | Responsabilidade confirmada |
|---|---|
| `character.cpp` (16.249 l.) | **Classe `smCHAR`** — todo personagem: posição, ângulo, movimento, animações (padrões `smPAT3D`/`smDPAT`), armas nas mãos (`smCHARTOOL`), ataque/alvo, montaria, morte, render. É o coração do jogo. |
| `field.cpp` (2.394 l.) | **Classe `sFIELD`** — campos/mapas: gates de transição, warp gates, pontos de spawn, música de fundo, objetos do stage, skybox, eventos de campo, `FieldMain()`. |
| `Damage.cpp` | Cálculo/aplicação de dano: `dm_SendTransDamage`, seleção de alvos em área (`dm_SelectRange`), `dm_EncodePacket`/`dm_DecodePacket` (codificar/decodificar pacotes de dano), `LockSpeedProtect` (anti-speedhack). |
| `netplay.cpp` (13.681 l.) | **Rede principal do cliente**: conexões (DataServer/UserServer/ExtendServer), `RecvMessage()` (despacha TODOS os pacotes do servidor por opcode), `TransUserCommand` (login), fila de pacotes (`RecvDataQue`), `ConnectServer_*`. |
| `smwsock.cpp` (2.768 l.) | **Camada Winsock**: classe `smWINSOCK` + threads de envio/recebimento (`smWinsockSendThreadProc`/`smWinsockRecvThreadProc`), filas de envio, criptografia de pacote (`CheckEncRecvPacket`). |
| `playsub.cpp` (6.025 l.) | Sub-rotinas do jogo: desenho do HUD clássico, `DrawGameState`, processamento por estado. |
| `playmain.cpp` (4.442 l.) | `PlayMain()` (loop in-game: câmera por teclado, updates), `LoadStageFromField` (carrega mapas `smSTAGE3D`), `playmodel.h` (modelo animado do personagem). |
| `ActionGame.cpp` | Controle por teclado (`VK_UP/DOWN/LEFT/RIGHT` + espaço), **dash** (duplo clique de seta), auto-seleção de alvo (`agFindAttack`/`agFindItem`), modo ação. |
| `AntiCheat.cpp` (878 l.) | `CAntiCheat`: checa checksum de funções (`GetTickCount`, `sinSetLife/Mana/Stamina` — detecta hooks), enumera janelas suspeitas, procura DLLs de hack, thread `CheckThread()`. |
| `cracker.cpp` (1.019 l.) | Proteção de código: `Check_CodeSafe` (verifica integridade/checksum de funções), `Check_nProtect` (NProtect), anti-debug, verificações chamadas no loop. |
| `checkdll.cpp` | Varre o diretório do executável atrás de DLLs de hack. |
| `cSkinChanger.cpp` | Janela de **skins** — troca a aparência de itens/equipamento (`SetSkinChangerItemAreaCheck`). |
| `CurseFilter.cpp` | Filtro de palavras ofensivas no chat (`IsCurse`, `ConvertString`, carrega listas de um arquivo). |
| `AreaServer.cpp` | Conexão com **Area Servers** (servidores de área): `RecvAreaServerMap`, `AreaServerMode`, sockets `lpWSockServer_Area[2]`. |
| `Controller.cpp` | Classe `Controller` — **stub** (construtor/destrututor vazios). **NÃO VERIFICADO** uso real. |
| `avictrl.cpp` | Reprodução de vídeos **AVI** (texturas animadas). |
| `BellatraFontEffect.cpp` | Efeito de fonte do evento Bellatra (pontuação/tempo). |
| `CAutoCamera.cpp` | Câmera automática (segue o personagem). |
| `ConfirmationBox.cpp` | Caixa de confirmação (Sim/Não) usada em ações críticas. |
| `Discord.cpp` | Wrapper do Discord Rich Presence. |
| `Drawsub.cpp` | Helpers de desenho 2D (`DrawFontText`, `dsMenuCursorPos`, offsets de desenho por camada). |
| `effectsnd.cpp` | Sons de efeito e BGM (`ChangeBGM`, `PlayFootStep`, `InitSoundEffect`). |
| `fileread.cpp` | Carregamento de arquivos/texturas (usa `PackageFile` para `.pkg`). |
| `FontImage.cpp` | Fontes desenhadas em imagem (`DrawFontImage`). |
| `FullZoomMap.cpp` | Mapa ampliado (zoom total) — `SetFullZoomMap`, `CreateBeforeFullZoomMap`. |
| `GameCore.cpp` | **`CGameCore`** — gerenciador das janelas modernas: `vWindowElement` (ordenado por nível), `vHandleElement`, foco, input distribuído, `Render2D()`. Cria Chat, Party, HUD alvo, MiniMap, MessageBox, ItemInfoBox, SkillInfoBox, MessageBalloon. |
| `HelpTime.cpp` | Utilitários de data/hora (anos bissextos). |
| `Ime.cpp` | Suporte a IME (digitação coreana/japonesa). |
| `IniFiles.cpp` | Leitor de `.ini` (classe `IniFiles` usada pelo `Settings`). |
| `makeshadow.cpp` | Sombras 3D + colisão linha-vs-polígono (`CollisionLineVSPolygon`). |
| `mapedit.cpp` | Funções de **editor de mapa** (`DisplayEditMap`...). **NÃO VERIFICADO** se usado em runtime ou só em build de debug. |
| `mini_dump.cpp` | Geração de crash dump (`SetUnhandledExceptionFilter`). |
| `Model.cpp` | Classe `Model` — **NÃO VERIFICADO** (provável modelo de dados; 1 leitura superficial). |
| `PackageFile.cpp` | Lê **pacotes `.pkg`** (zip) da pasta `game\data\` — `ReadPackage`, cache. |
| `Particle.cpp` | Sistema de partículas (`SetParticle`, `PlayParticle`, luzes dinâmicas). |
| `pbackground.cpp` | Fundo/skybox (`smBACKGROUND`). |
| `record.cpp` | Salvar/carregar dados do jogador (`GetUserDataFile`, `GetPostBoxFile`), pontos de ticket. |
| `Settings.cpp` (2.121 l.) | **Janela de configurações** do jogo: lê/grava `game.ini` (Ratio, TextureQuality, Damage, Effects, DynamicLights, DynamicShadows, VSync, BlockUI, Music/Sound/Ambient, volumes, câmera, mostrar barras HP/MP/SP). |
| `sinHaQuest.cpp` | Quest do Ha (evento). |
| `SkillSub.cpp` | Execução de habilidades: `OpenPlaySkill`, `PlaySkillAttack`, `PlaySkillLoop`, motion blur. |
| `smReg.cpp` | Acesso ao **Registry** do Windows (`GetRegString`/`SetRegString`). |
| `stritem.cpp` | **NÃO VERIFICADO** — poucas linhas; aparenta helpers de string/item. |
| `Testecpp.cpp` | **Teste/stub** — **NÃO VERIFICADO** uso real. |
| `TextMessage.cpp` | Mensagens de texto vindas do servidor (`srcServer/LangTextMessage.h`). |
| `timer.cpp` | Timer de alta precisão (multi-core aware). |
| `UnitGame.cpp` / `View.cpp` | **Código morto/stub** (esqueleto de editor/tutorial). |
| `npkcrypt.h`, `ofuscate.h` | Headers de proteção: NProtect/GameGuard (`NPK*`) e ofuscação de strings. |

---

## 3. ARQUITETURA INTERNA

### Estrutura geral — duas gerações de código convivendo
1. **Legado (~2001-2005, estilo C):** engine `smLib3d` + globais (`smConfig`, `smRender`, `VRKeyBuff`, `lpCurPlayer`) + sistemas "Ho" (login/party) + sistema "sin" (HUD/jogo). Funções soltas, `smCHAR*` global, desenho por texturas 2D.
2. **Moderno (C++17, adições recentes do servidor privado):** `Engine/Directx` (wrapper DX9 novo com shaders), `Engine/UI` (janelas com herança/eventos), `CGameCore` (singleton gerenciador de janelas), `Shared/smPacket.h`, `Settings`, `Login/`, `Chat/`, `Discord`.

### Classes principais
| Classe | Onde | Papel |
|---|---|---|
| `smCHAR` | `character.h` | Personagem (jogador, NPC, monstro): posição `pX/pY/pZ`, ângulo, `MotionInfo` (estado da animação), `Pattern`/`Pattern2` (corpo/rosto), armas `HvLeftHand/HvRightHand`, alvo de ataque `chrAttackTarget`, `smCharInfo` (stats). |
| `sFIELD` | `field.h` | Campo/mapa: gates, warp gates, spawn points, música, céu, nível mínimo, `FieldMain()`. |
| `smSTAGE3D` | `smLib3d` | Stage 3D renderizável (carregado por nome via `LoadStageFromField`). |
| `smRENDER3D` (`smRender`) | `smLib3d/smRend3d.h` | Estado global de renderização: luzes, cores, materiais, buffers. |
| `CGameCore` | `GameCore.cpp` | Singleton (`GAMECOREHANDLE`) das janelas modernas: `AddWindow`, `SetFocus`, `OnMouseClick/KeyPress`, `Render2D()`. |
| `cInterFace`, `cInvenTory`, `cItem`, `cShop`, `cTrade`, `cCharStatus`, `CSKILL` | `sinbaram/` | Objetos globais clássicos do HUD (interface, inventário, itens, loja, troca, status, habilidades). |
| `CAntiCheat` | `AntiCheat.h` | Anti-cheat do cliente (thread + checksums + janelas suspeitas). |
| `Graphics::*` | `Engine/Directx` + Delta3D | Novo renderizador: `Graphics::Graphics::GetInstance()->GetRenderer()`, `Graphics::Camera`, shaders, luzes. |

### Fluxo de renderização
`WinMain loop -> PlayD3D -> smPlayD3D` (detalhado na seção 1). Resumo: câmera traça o jogador -> limpa backbuffer -> **shadow map** -> pós-processamento -> céu -> personagens (`DrawPat3D`) -> terreno/mapa (`DisplayStage` com shader `Terrain.fx`) -> transparências -> sombras -> efeitos/partículas -> sprites 2D (`DrawPat2D`) -> glow de seleção -> **HUD 2D** (`DrawGameState` + `CGameCore::Render2D` + ImGui) -> apresentar.

### HUD / UI — como as janelas são feitas (3 sistemas)
1. **Clássico "sin":** janelas desenhadas com texturas (`CreateTextureMaterial("game\\images\\...")`) + `DrawFontText`; camadas controladas por `dsDrawOffsetArray` (TOP/RIGHT/BOTTOM). Ex.: `sinInterFace`, `sinInvenTory`, `cCharStatus`.
2. **Moderno `Engine/UI`:** classes `UIWindow`/`UIElement` com `Render()`, `OnMouseClick()`, eventos (`UI::Event::Build(std::bind(...))`), imagens via `UI::ImageLoader`. Registradas no `CGameCore` (que ordena por `GetWindowLevel()` e gerencia foco). Ex.: `Login/LoginScreen`, `Chat/ChatWindow`, `Quest/QuestWindow`.
3. **ImGui (Dear ImGui DX9):** overlays/alertas/chat novo (`HUD/InstancesFlag.cpp`, `MixWindow`, `Roleta`, `RankingWindow`, `SodWindow`, `RestaureWindow`).

### Animações / skins
- Animações = **padrões de frames**: `smPAT3D`/`smDPAT` (dados de animação) + `playmodel.h` (modelo: `SetMotion`, estados `CHRMOTION_STATE_*`).
- Import/export de animações 3D Studio Max: `Engine/DynamicAnimation` (formatos `.smd`, `.inx`).
- **Skins:** `cSkinChanger` troca a textura/modelo visual de itens equipados (aparência alternativa), `SetSkinChangerItemAreaCheck`.

### Anti-cheat do cliente
- `CAntiCheat` (thread dedicada): checksum de funções críticas para detectar **hooks** (inclusive `GetTickCount` — anti-speedhack), enumeração de janelas com nomes de cheats conhecidos, procura por DLLs de hack no diretório (`checkdll.cpp`), `AddNewThreadException`.
- `cracker.cpp`: `Check_CodeSafe(addr)` valida checksum de código das funções do jogo (chamado em `InitD3D`/`GameInit`), `Check_nProtect()` (NProtect GameGuard), anti-debug (hook de `SetUnhandledExceptionFilter` no `WinMain`).
- Em runtime: `LockSpeedProtect` (dano/movimento), checksum das skills a cada frame (`SendSetHackUser3` se divergir), verificação de `_PACKET_PASS_XOR` (0x8B) em `PlayMain`.
- Pacotes XignCode/NProtect definidos em `Shared/smPacket.h` (`smTRANSCODE_XIGNCODE_*`, `_xTrap_GUARD`).

---

## 4. CONFIG (`game.ini` + outras)

### `src/Game/game.ini` (lido em `WinMain`, linhas 592-703; gravado por `Settings.cpp`)
```ini
[Screen]
Windowed=True ; 1 = janela, 0 = fullscreen
Width=1024 ; resolução X
Height=768 ; resolução Y
AutoAdjust=True ; ajuste automático de janela (proporção)

[Graphics]
BitDepth=32 ; 16/32 bits por pixel
HighTextureQuality=True ; True = qualidade máxima de textura

[Audio]
NoSound=False ; True = desliga o som (BGM)

[Camera]
FarCameraSight=True ; True = visão de câmera longa (FOG distante)
InvertedCamera=Off ; On/Off — inverte rotação da câmera com as setas

[ConnectServer]
IP=189.46.228.170 ; IP do servidor (vai p/ smConfig.szServerIP e szDataServerIP)
Port=31620 ; Porta TCP (vai p/ TCP_SERVPORT; padrão 32299)
```

### Chaves extras que o `Settings.cpp` lê/grava no mesmo `game.ini` (confirmadas nas linhas 1147-1384)
- `[Screen] Ratio` (4:3, 5:4, 16:9, 16:10), `Width`, `Height`
- `[Graphics] TextureQuality` (int), `BitDepth`, `Damage` (bool), `Effects`, `DynamicLights`, `DynamicShadows`, `VSync`, `BlockUI`
- `[Audio] Music`, `Sound`, `Ambient` (bools) + volumes de música/som (em `Settings`)
- Câmera: `cCamView` (distância), `cCamRange` (limite de zoom-out, 440-600), `cCamShake`, `cCamInv`
- HUD: mostrar/ocultar barras HP/MP/SP, ouro, amuletos, anéis, sheltoms, força, premiums, cristal, itens def/off, habilidades por classe (MS/FS/PS/AS/KS/ATS/PRS/MGS), "naked" (sem roupa), `bRememberLogin`, `bHidePlayerNames`, `bShowLife`, `bShowNotice`
- `ShortCut.ini` — atalhos (lido por `ReadShotcutMessage` no `WinMain`)
- `smConfig` também guarda: `NetworkQuality`, `WeatherSwitch`, brilho/contraste do mapa (`MapBright`, `MapContrast`, `MapLightVector`), arquivos de fundo/menu/stage, `DebugMode`

---

## 5. REDE no cliente

### Camada de sockets — `smwsock.cpp/.h`
- Classe **`smWINSOCK`** (WinSock 1.1, `WSAStartup(1,1)`): socket TCP (`SOCK_STREAM`), conecta (`connect()`), fecha, envia/recebe.
- **2 threads por conexão**: `smWinsockRecvThreadProc` (recebe pacotes e os enfileira) e `smWinsockSendThreadProc` (drena fila de envio) — criadas em `InitGameSocket`.
- Contadores de pacotes recebidos/enviados/erros; `CheckEncRecvPacket`/`PushEncRecvPacket` (anti-replay de pacotes criptografados).
- Criptografia de pacote: XOR com chave `_PACKET_PASS_XOR` (0x8B) — ver `smwsock.cpp:1182` (`#ifdef _PACKET_PASS_XOR`).

### Camada de protocolo — `netplay.cpp` + `Shared/smPacket.h`
- **`Shared/smPacket.h`** (fora de SrcGame, em `C:\Source Priston\Source Priston\Shared\`): define TODOS os opcodes `smTRANSCODE_*` (0x4847xxxx) e as structs de pacote:
  - Base: `smTRANS_COMMAND { int size; int code; int LParam; WParam; SParam; EParam; }`
  - Variantes: `smTRANS_COMMAND_EX`, `smTRANS_COMMAND_DWORD`, `smTRANS_COMMAND_BUFF`, `smTRANS_COMMAND_SOD`, `smTRANS_COMMAND_POLLING`, `smTRANS_EXP64`, `XIGNCODE_PACKET`, `smTRANS_XTRAP_*`.
- **Envio:** helpers em `netplay.cpp` (142 chamadas `Send2`): `TransUserCommand` (login: envia versão `Client_Version`, `_PACKET_PASS_XOR`, **MAC address** (via `UuidCreateSequential`), **volume serial do HD**, **nome do PC**, caminho do executável), `Send_GetCharInfo`, `SendSetHackUser2/3` (reporte anti-cheat), etc.
- **Recebimento:** thread de rede -> fila `RecvDataQue` (ring buffer) -> main thread `PlayRecvMessageQue()` -> `rsTRANS_SERVER::RecvMessageQue()` -> `RecvMessage(pData)` (netplay.cpp:1188):
 1. Se pacote criptografado (`smTRANSCODE_ENCODE_PACKET`/`_2`): decodifica (`DecodePacket`/`fnDecodePacket`) e valida contra replay.
 2. `switch (code)` gigante: `smTRANSCODE_PLAYDATA*` (movimento de personagens), `ATTACKDATA` (ataques), `ADDEXP` (exp), `SKILLS` (habilidades), quests, itens, chat, party, premium, etc.
- **Conexões separadas:** `smWsockServer` (principal), `smWsockDataServer` (login/dados), `smWsockUserServer`, `smWsockExtendServer` — função `ConnectServer_GameMain` aceita até 3 IPs+portas (reuso do mesmo socket quando o IP coincide).

### Autenticação (login)
1. `TransUserCommand(smTRANSCODE_ID_GETUSERINFO, UserAccount, UserPassword)` -> DataServer.
2. Servidor responde `smTRANSCODE_ID_SETUSERINFO` (personagens) + lista de servidores.
3. Escolha do mundo -> conexão `ConnectServer_GameMain(ip1:porta1, ip2:porta2, ip3:porta3)` -> `GameMode 2`.
4. Checagem de versão: `Client_Version = CLIENT_VERSION_NUM (1000)`; o servidor valida `(-Client_Version*2) == CLIENT_VERSION_CHECK` (netplay.cpp:350).

---

## 6. RECURSOS (assets)

**Os assets NÃO estão no repositório** — o cliente carrega tudo de uma pasta `game\` que fica junto do executável (build em `OutDir\ReleaseGame\`). Confirmado pelos caminhos hardcoded:

| Caminho (relativo ao executável) | Conteúdo |
|---|---|
| `game\data\*.pkg` | Pacotes de dados em **formato zip** (`PackageFile.cpp` — `ReadPackage`, `CZipArchive`). |
| `game\images\...` | Imagens de UI: `.png`, `.tga`, `.bmp` (ex.: `game\images\login\bg_selector.png`, `game\images\Caravan\*.png`, `game\images\settings\*.tga`, `game\images\messagebox\*.png`). |
| `game\textures\...` | Texturas de mundo (ex.: `game\textures\misc\login.asf` — vídeo de fundo do login). |
| `game\scripts\shaders\Terrain.fx` | Shader de terreno (novo renderizador DX9). |
| `game\data\` (mapas) | Stages/mapas carregados por nome (`LoadStageFromField` -> `smSTAGE3D`; formato legado da smLib3d `.dsx`). **NÃO VERIFICADO** extensões exatas no disco (o repo só tem o código). |
| `savedata\clanDATA\...` | Cache de imagens de clã (referência em `Winmain.cpp:558`). |
| `ShortCut.ini` | Atalhos do teclado. |
| `game.ini` | Configuração (seção 4). |
| Modelos 3D | Formatos de animação `.smd`/`.inx` (3D Studio Max) via `Engine/DynamicAnimation`. |
| Áudio | `.wav` (BGM/efeitos via `srcsound`), download via HTTP (`WinInt/WavIntHttp`). |

---

## 7. RESUMO — tabela "arquivo/pasta -> responsabilidade"

| Arquivo / Pasta | Responsabilidade |
|---|---|
| `Winmain.cpp` | Entry point real: janela, game loop, init D3D, render, input, quit |
| `Game.cpp`, `Main.cpp`, `CSystem.cpp`, `UnitGame.cpp`, `View.cpp` | Código morto/stub de tutoriais (não usados) |
| `ActionGame.cpp` | Movimento por teclado + dash + auto-alvo de ataque |
| `character.cpp/.h` | Classe `smCHAR` — personagens (movimento, animação, ataque) |
| `field.cpp/.h` | Classe `sFIELD` — mapas/campos, gates, warps, spawns |
| `Damage.cpp` | Dano, seleção de alvos, encode/decode de pacotes de dano, anti-speedhack |
| `netplay.cpp` | Rede: conexões, despacho de pacotes, login (13,6k linhas) |
| `smwsock.cpp/.h` | Winsock: threads de send/recv, filas, criptografia de pacote |
| `playsub.cpp` / `playmain.cpp` | Loop in-game / desenho HUD clássico / carregamento de mapas |
| `GameCore.cpp` | `CGameCore` — gerenciador das janelas modernas (chat, party, minimapa, HUD alvo...) |
| `CSystem` -> `Engine/` | Engine gráfica nova (DX9/Delta3D): renderer, câmera, shaders, fontes, UI framework |
| `Engine/UI/` | Framework de janelas moderno (UIWindow/UIElement/UIButton/...) |
| `sinbaram/` (38 cpp) | Núcleo do jogo: HUD clássico, inventário, itens, loja, troca, skills, quests, efeitos |
| `HoBaram/` | Tela de abertura/login clássica, party clássica, efeitos, física, céu, pets |
| `Login/` | Tela de login nova (checkboxes, vídeo/imagem, seleção de mundo) |
| `Chat/` | Chat novo (janela moderna) |
| `Party/` | Party/raid (handler moderno) |
| `Quest/` | Quest (dados) + janela de quests |
| `Shop/` | Loja nova + itens premium por tempo |
| `Caravana/` | Sistema de caravana (comércio móvel) |
| `Eventos/` | Arena (PvP em times), WarMode; Invasao = stub |
| `Skill/` | SkillManager — janela/tooltips de habilidades |
| `HUD/` | Overlays: minimapa, dano, alvo, ranking, roleta, SOD, ImGui |
| `VIP/` | Nível VIP + comandos + tempo de premium |
| `Montarias/` | Montarias (modelos, visibilidade, animações) |
| `TitleBox/` | Texto de título temporário |
| `Park/` | Caixas de mensagem clássicas (nomes, clã) |
| `Discord/` + `Discord.cpp` | Rich Presence do Discord |
| `WinInt/` | Downloads via HTTP (sons), threads de internet |
| `API/` | Chilkat + libcurl (bibliotecas externas) |
| `srcServer/` | Headers de mensagens/idioma do servidor (tradução) |
| `SrcLang/` | Checagem de texto japonês/2-bytes |
| `TJBOY/` | Clan menu, auth/launcher (isaocheck), ParkPlayer, Ygy (memmap/packet/process — NÃO VERIFICADO) |
| `AntiCheat.cpp`, `cracker.cpp`, `checkdll.cpp` | Anti-cheat: checksums, hooks, anti-debug, DLLs de hack, NProtect |
| `cSkinChanger.cpp` | Janela de skins (aparência de itens) |
| `CurseFilter.cpp` | Filtro de ofensas no chat |
| `AreaServer.cpp` | Conexão com Area Servers |
| `Settings.cpp` | Janela de configurações + leitura/gravação do `game.ini` |
| `smLib3d/` | Engine 3D legada (DirectX 7/8) — 1 linha |
| `srcsound/` | Áudio legado DirectSound — 1 linha |
| `imGui/` | Biblioteca Dear ImGui — 1 linha |
| `Shared/smPacket.h` (fora de SrcGame) | Definição de todos os pacotes/opcodes do protocolo |
| `game.ini` | Config: resolução, janela, qualidade, som, câmera, IP/porta do servidor |

**IP/porta reais no código:** `[ConnectServer] IP=189.46.228.170 Port=31620` (game.ini); porta padrão `32299` (`TCP_SERVPORT`); constante `TCP_GAMEPORT 8185` em `smwsock.h` (não usada no fluxo principal — **NÃO VERIFICADO**).