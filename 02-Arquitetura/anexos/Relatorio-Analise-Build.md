**Verificado em:** 31/ago/2026. Tudo abaixo foi confirmado lendo os arquivos; o que não foi confirmado está marcado **NÃO VERIFICADO**.

---

## 1) Soluções e Projetos

| Arquivo | Papel |
|---|---|
| `SrcGame/Game.sln` | Solução do **cliente** (projeto `Game` + projeto `Shared`) |
| `SrcServer/server.sln` | Solução do **servidor** (projeto `Server` + projeto `Shared`) |
| `Shared/Shared.vcxitems` | Projeto "compartilhado" (vcxitems) — NÃO é compilado separado; é **importado** pelos dois .vcxproj e compilado dentro de cada um |

### Configurações e plataformas
- Apenas **Debug|Win32** e **Release|Win32** nas duas soluções. **Não existe x64** — tudo é 32-bit (`/MACHINE:I386` no linker).
- **Toolset: v143** (= Visual Studio 2022) nos dois projetos. `ToolsVersion` 14/15 nos .vcxproj é só herança do VS antigo.
- `CharacterSet = MultiByte` (nada de Unicode), `UseOfMfc = false`.

### C++ standard
- **Game:** `stdcpp17` (C++17) nas duas configs.
- **Server:** Debug = `Default` (C++14), Release = `stdcpp14`. Ou seja, servidor é **C++14**.

### Defines de preprocessador (do .vcxproj)
- **Game Debug:** `_ITERATOR_DEBUG_LEVEL=0; _SECURE_SCL=0; _HAS_STD_BYTE=0; DELTA3D; _D3D9; WIN32; _DEBUG; _WINDOWS; CURL_STATICLIB`
- **Game Release:** `_HAS_STD_BYTE=0; DELTA3D; _D3D9; WIN32; NDEBUG; _WINDOWS`
- **Server Debug:** `WIN32; _DEBUG; _WINDOWS` — **Server Release:** `WIN32; NDEBUG; _WINDOWS`
- `_WIN32` não aparece: é definido automaticamente pelo compilador MSVC.
- **`__SERVER__` NÃO EXISTE** — verificado: 0 ocorrências nos .vcxproj e no código. Cliente e servidor são projetos separados que compilam cópias próprias dos fontes (não usam `#ifdef` de cliente/servidor, usam arquivos separados).
- Curiosidade: até no Debug o game usa CRT estático de Release (`MultiThreaded` = /MT) e linka libs Release — por isso desligam `_ITERATOR_DEBUG_LEVEL` e `_SECURE_SCL`. O server Debug usa `/MTd` normal.

### Diretórios (Game, `SrcGame/src/game.vcxproj`)
- **Includes adicionais (AdditionalIncludeDirectories):** `$(ProjectDir)Game\`, `..\..\Shared\` (via Shared.vcxitems também), `..\Shared\Discord\Include`, `..\dependencies\ziparchive\ZipArchive`, `..\dependencies\Delta3D\Include\`
- **IncludePath (PropertyGroup):**
  - Debug: `C:\Source\Libs; ...imGui; ...API\include; C:\Libs\curl-7.69.1...\include; C:\Source\Libs\DX9\Include; C:\Source\Libs\zlib\include` -> **caminhos da máquina do dev original — NÃO existem nesta máquina**
  - Release: `C:\Temp\Libs; C:\Temp\Libs\curl-7.69.1\curl-7.69.1\include; C:\Temp\Libs\DX9\Include; C:\Temp\Libs\zlib\include` -> **existem nesta máquina [ok]**
- **LibraryPath (Release):** `C:\Temp\Libs\DX9\Lib\x86; C:\Temp\Libs\curl-7.69.1\curl-7.69.1\builds\libcurl-vc16-x86-debug-static-ipv6-sspi-winssl-obj-lib; C:\Temp\Libs\zlib\lib`
- **Links do Game (Release):** `ZipArchive.lib` (de `dependencies\ziparchive\ziparchive\Release STL MT\`), `Delta3D.lib` (de `dependencies\Delta3D\Lib\`), `dsound.lib`, `odbc32.lib`, `odbccp32.lib`, `libcurl_a_debug.lib`, `Ws2_32.lib`, `Crypt32.lib`, `Wldap32.lib`, `Normaliz.lib`, `Lua.lib` + `lualib.lib` (itens `<Library>`, Lua 5.0.2 em `Game\HoBaram\...\Script\Lua\Win32`). DirectX entra via `#pragma comment(lib, "d3d9.lib"/"d3dx9.lib")` em `Game/Engine/Directx/DXGraphicEngine.cpp` (linhas 25-26).
- **Links do Server:** Debug = `dsound.lib; odbc32.lib; odbccp32.lib; zlib.lib`; Release = `dsound.lib; odbc32.lib; odbccp32.lib; shell32.lib` (sem zlib no Release). LibraryPath aponta para `$(SolutionDir)\Library` (não existe) e `C:\Temp\Libs`.
- SubSystem: Game = **Windows** (janela), Server = **Console**. Ambos `FixedBaseAddress=true`, ASLR desligado (típico de MMORPG antigo). Game tem `BaseAddress 0x870000`.
- Resíduo do dev original: `ImportLibrary = ..\..\..\Users\Luiz\Desktop\aPT v1042\Game.lib` (explica a pasta `C:\Source Priston\Users\` que sobrou).

### O que é o Shared (`Shared/Shared.vcxitems`)
Arquivos compilados **dentro dos dois executáveis**: `Utils/` (matemática X3D*, FileReader, Debug, logs, mutex), `GlobalsShared.h` (constantes do jogo: limites de ouro, tempos de item prime), `LevelTable.h`, `smPacket.h`, `Skills/*.h` (skills das 9 classes), `Hashing/CRC.h`. O vcxitems também adiciona `Shared\` como diretório de include. Verificado: servidor usa `Utils` em `Server/Database/SQLConnection.cpp` e `Server/Party/CPartyHandler.cpp`.

---

## 2) Dependências

### `dependencies/Delta3D` — engine gráfica própria (pré-compilada)
- **Não é o Delta3D open-source** (aquele usava dtCore/dtABC — nada disso existe aqui). É uma engine com namespace próprio `Delta3D::Core`, `Delta3D::Graphics`, `Delta3D::Math`, `Delta3D::IO`, `Delta3D::Legacy`.
- **API:** interfaces `ICore.h`, `IGraphics.h`, `IMath.h`, `IIO.h`, `ILegacy.h`, `IResource.h`, `IThirdParty.h`; núcleo em `Include/Core`, `Include/Graphics` (Renderer, Camera, Texture, Mesh, Shader, Terrain, Particle, Quadtree, ...), `Include/Math` (Vector2/3, Matrix4, Quaternion, BoundingBox, Frustum, Color...).
- **Roda em Direct3D9:** `Graphics/GraphicsImpl.h` guarda `IDirect3DDevice9* device;` (verificado).
- **Math derivada do Urho3D:** `IMath.h` tem o comentário "Copyright (c) 2008-2019 the Urho3D project" (verificado).
- **Pré-compilada:** só tem `Include/` + `Lib/` no repo, sem .cpp. `Lib/` contém `Delta3D.lib` (~10 MB, Release) e `Delta3D_d.lib` (~19 MB, Debug) + `.pdb`.
- **Onde é usada:** `SrcGame/src/Game/Engine/Directx/DXGraphicEngine.h` (inclui IGraphics.h/ICore.h/IMath.h), `character.h/.cpp`, `Particle.cpp`, `smLib3d/smObj3d.*`, `smrend3d.h`, `smStage3d.cpp`, `smStgObj.cpp`, `AnimationHandler.cpp`, `DXSelectGlow.h`. Ou seja: é a base de renderização 3D do cliente.

### `dependencies/ziparchive` — biblioteca de ZIP (Artpol Software)
- Bibliotecas clássica "ZipArchive Library" (artpol-software.com) para C++ — tem `ZipArchive.sln`, `ZipArchive.vcxproj` (toolset v143), build `Release STL MT/ZipArchive.lib` (35 MB) e `Debug STL MT/ZipArchive.lib`.
- **Versão exata: NÃO VERIFICADO** (sem marcador claro; o `_readme.txt` fala de trial da versão completa). Suporta AES, BZip2, Zip64.
- **Onde é usada:** `SrcGame/src/Game/sinbaram/sinLinkHeader.h` linha 71 (`#include "ZipArchive.h"`) — lida com pacotes `.pak/.zip` do jogo. Obs.: o jogo também tem um leitor de zip próprio antigo: `Game/WinInt/ZipLib.h` + `ohZipLib.lib` (usado em `netplay.cpp` e `WavIntHttp.cpp`).

### `Shared/zlib` — zlib **1.2.11** (verificado em `zlib.h`)
- Código-fonte completo + `contrib` (inclui DotZLib em C#). Para linkar, o projeto usa o binário externo em `C:\Temp\Libs\zlib\lib\zlib.lib` (Release/Debug do server).
- **Onde é usada:** `netplay.cpp`, `Quest/Quest.cpp`, `Shop/NewShop.cpp`, `Shop/NewShopTime.cpp` (compressão de dados de rede/save). Obs.: `Game/TJBOY/clanmenu/` tem uma **cópia própria** de zlib.h/zconf.h.

### `Shared/rapidjson` — **rapidjson 1.1.0** (verificado: MAJOR 1, MINOR 1, PATCH 0)
- **Onde é usada:** principalmente no Discord — `Game/Discord/serialization.h` (`#include "rapidjson/document.h"`, `stringbuffer.h`, `writer.h`) monta o JSON do Rich Presence; também referenciado pelos headers Chilkat `API/include/CkJsonObject.h` e em `imgui_demo.cpp`.

### `Shared/Discord` — **discord-rpc** (Rich Presence oficial do Discord)
- É o **SDK oficial discord-rpc**: `include/discord_rpc.h` (struct `DiscordRichPresence`, `Discord_Initialize`, `Discord_UpdatePresence`, `Discord_Shutdown`) + `lib/discord-rpc.lib`. **Não é webhook.**
- O cliente **compila o fonte do próprio SDK** (vendored em `Game/Discord/`: `discord_rpc.cpp`, `rpc_connection.cpp`, `serialization.cpp`, `connection_win.cpp`, `discord_register_win.cpp`) e o `discord-rpc.lib` de `Shared/Discord/lib` está presente mas **nenhum item de link o referencia explicitamente** (linkar o .lib junto com o fonte geraria símbolos duplicados — provável resíduo, **NÃO VERIFICADO** se é linkado de outra forma).
- Uso real: `Game/Discord.cpp` — `Discord_Initialize("898283856086597702", ...)` (linha 72), `Discord_UpdatePresence` (241), `Discord_Shutdown` (246); chamado de `Game/Winmain.cpp`. Mostra "jogando Priston" com nome/estado do personagem na aba do Discord.

### `Shared/Utils` — utilidades próprias do projeto
- Matemática 3D (`X3DVector2/3/4`, `X3DMatrix4`, `X3DQuaternion`, `X3DAABB`, `X3DFrustum`, `X3DSphere`, `X3DQuad`, `X3DEasings`, `EXEVertex`, `Geometry`), `FileReader`, `Debug`, logging (`Logs/utils_logging*`), `CMutex`, `strings`.
- Compilado **dentro dos dois executáveis** via Shared.vcxitems (ver seção 1).

---

## 3) OutDir / saída de build

Definições nos .vcxproj (caminhos **relativos a `SrcGame/src/` e `SrcServer/src/`**):

| Projeto/Config | IntDir (objetos) | OutDir (executável) | Resultado |
|---|---|---|---|
| Game Debug | `OutDir\DebugGame\` | `..\..\..` = **`C:\Source Priston\`** | `Game.exe` + `Game.pdb` |
| Game Release | `OutDir\ReleaseGame\` | `..\..\..` = **`C:\Source Priston\`** | `Game.exe` + `Game.pdb` |
| Server Debug | `OutDir\DebugServer\` | `..\..\..\PTServer\` = `C:\Source Priston\PTServer\` (pasta **não existe** — seria criada) | `Server.exe` |
| Server Release | `OutDir\ReleaseServer\` | `..\..\..` = **`C:\Source Priston\`** | `Server.exe` + `Server.pdb` |

- **Importante:** o executável NÃO sai para dentro do repo — sai para a pasta **pai** (`C:\Source Priston\`). Confirmado: lá estão `Game.exe` (10 MB, 30/ago 19:35), `Game.pdb` (45 MB), `Server.exe` (6 MB, 30/ago 15:46), `Server.pdb` — evidência de build Release recente.
- **`OutDir\` dentro do repo contém só intermediários:** ~277 `.obj` (ReleaseGame), 279 (DebugGame), 109 (ReleaseServer), 112 (DebugServer — inclui `BotServer.obj` órfão, arquivo que não existe mais nos fontes), `vc143.pdb` (pdb do compilador, presente nas 4 pastas — verificado), `game.res`, e logs do MSBuild em `Game.tlog/Server.tlog` (`CL.command.1.tlog`, `lastbuildstate`, etc.). Sem .exe dentro.

---

## 4) Git

- **Repo:** `https://github.com/othiagob/Source-Priston.git` (remote `origin`), branch única `main`, **6 commits** (29–30/ago/2026): `Initial commit` -> `Start base` -> `Fix alttime` -> `Fix - Correção de compilação de game` -> `Fix - Compilação servidor.` -> `843956f` (HEAD). 1.958 arquivos rastreados; `.git` = 61 MB, sem pack (objetos soltos — `size-pack: 0 bytes`).
- **Estado:** 1 arquivo modificado não commitado: `SrcGame/src/Game/Winmain.cpp` (título da janela: "Draco Priston - ver. 1.00.03..." -> "PROJETO PRISTON - L. JURYS E THIAGO B.").
- **`.gitignore`:** objetos (`*.obj`, `*.o`), DLLs/exes (`*.dll`, `*.exe`), PCH (`*.pch`, `*.ipch`), `*.tlog`, `.vs/` (IntelliSense — 0 arquivos `.vs` rastreados [ok]), `/bin`, `/OutDir`. **Não** ignora `.pdb` explicitamente, mas as pastas de build são cobertas pelo `/OutDir`.
- **`.gitattributes`:** só `* text=auto` (normalização LF).
- **Tamanho total da árvore: 1,7 GB** — dominado por lixo de build não rastreado: `OutDir` 426 MB, `SrcGame` 983 MB (quase tudo `.vs/` = banco do IntelliSense + `.ipch`), `SrcServer` 158 MB (idem), `dependencies` 79 MB (as `.lib` pré-compiladas **são rastreadas** — 9 `.lib` no git, incluindo Delta3D 10+19 MB e ZipArchive 35 MB), `Shared` 4,6 MB.

---

## 5) Como compilar

Não existem scripts `.bat`/`.cmd`/`.ps1` de build (verificado: nenhum no repo). Compilação é pelo Visual Studio:

1. **Pré-requisitos de máquina** (a pasta `C:\Temp\Libs` **já existe nesta máquina** e contém: `DX9` — SDK DirectX completo, `zlib`, `curl-7.69.1`, `boost`, `asio`, `CppNet.lib`, `PHP`): `C:\Temp\Libs\DX9\Include\d3d9.h` presente, `DIRECT3D_VERSION 0x0900`; `libcurl_a_debug.lib` em `C:\Temp\Libs\curl-7.69.1\curl-7.69.1\builds\libcurl-vc16-x86-debug-static-ipv6-sspi-winssl-obj-lib\` [ok]; `zlib.lib`/`zlibstatic.lib` em `C:\Temp\Libs\zlib\lib` [ok].
2. **Cliente:** abrir `SrcGame\Game.sln`. **Servidor:** abrir `SrcServer\server.sln`.
3. Selecionar **`Release | Win32`** e Build. (As configs **Debug apontam para caminhos que não existem** nesta máquina — `C:\Source\Libs`, `C:\Libs` — então Debug provavelmente falha; Release é a config que comprova-se funcionar: exes de 30/ago.)
4. **Ordem:** o projeto `Shared` na solução é só um container de itens compartilhados (`SharedMSBuildProjectFiles`) — **não há build separado**. O Visual Studio compila `Shared/Utils/*` **dentro** do Game e do Server automaticamente (o vcxproj importa o vcxitems). Dependências externas (`Delta3D.lib`, `ZipArchive.lib`, `discord-rpc` fonte, `curl`, `zlib`, `Lua`) já estão pré-compiladas no repo/em `C:\Temp\Libs` — nada a compilar antes.
5. **Saída:** `C:\Source Priston\Game.exe` e `C:\Source Priston\Server.exe` (fora do repo).
6. Obs.: o `.vcxproj.user` do Game aponta `LocalDebuggerWorkingDirectory` para `E:\Games\WPT - 1074...` (máquina original — ajuste se for depurar); o do Server aponta para `..\..\..\PTServer\` e tem configs de **deploy remoto** (`C:\PTServer\`, IPs `190.102.40.25:4024` / `15.204.184.155:4024` — do dev original).

---

## 6) Requisitos

- **Visual Studio 2022** com workload "Desenvolvimento para desktop com C++" (toolset **v143**).
- **Windows SDK 10.0.26100.0** exigido pelo Game (instalado nesta máquina [ok]; o Server usa "10.0" = mais recente). SDKs instalados aqui: 10.0.22621.0, 10.0.26100.0, 10.0.28000.0. O Release do Game referencia explicitamente os headers do SDK 10.0.22621.0 no `ExternalIncludePath`.
- **DirectX SDK (June 2010)** em `C:\Temp\Libs\DX9` (Include/Lib/Redist...; `d3d9.h` e `Lib\x86\d3d9.lib` + `d3dx9.lib`). Não é o "DirectX SDK da Microsoft" instalado em `Program Files` — está na pasta de libs da máquina (verificado: nenhum `Microsoft DirectX SDK` em Program Files).
- **Dependências externas de máquina:** `C:\Temp\Libs\` (DX9, zlib 1.2.11, curl 7.69.1 estático). As demais vêm do repo: `dependencies\Delta3D\Lib\*.lib`, `dependencies\ziparchive\ziparchive\Release STL MT\ZipArchive.lib`, `Shared\Discord\include+lib`, `Shared\rapidjson`, `Shared\zlib`, Lua 5.0.2 pré-compilada em `SrcGame\src\Game\HoBaram\NewEffect\HoEffect\Script\Lua\Win32`.
- Sem scripts, sem CMake, sem vcpkg — build 100% MSBuild/VCXPROJ com caminhos absolutos embutidos (frágil em outra máquina: é o padrão clássico desses sources de PT).

---

## 7) Tabela resumo

| Dependência | Versão / Uso | Onde está |
|---|---|---|
| **Delta3D** | Engine 3D própria (pré-compilada), Direct3D9, math do Urho3D; renderização do cliente | `dependencies/Delta3D/` (Include + Lib: Delta3D.lib / Delta3D_d.lib) — usada em `Engine/Directx/DXGraphicEngine.*`, `character.*`, `smLib3d/*`, `Particle.cpp` |
| **ZipArchive (Artpol)** | Leitura de `.pak/.zip` (assets); versão exata NÃO VERIFICADO | `dependencies/ziparchive/ziparchive/` (libs em `Release STL MT/` e `Debug STL MT/`) — usada em `sinbaram/sinLinkHeader.h` |
| **ohZipLib** | Zip wrapper próprio do PT (leitura de pacotes) | `SrcGame/src/Game/WinInt/ZipLib.h` + `ohZipLib.lib` — usada em `netplay.cpp`, `WavIntHttp.cpp` |
| **zlib** | **1.2.11**; compressão de rede/save | Fonte em `Shared/zlib/`; binário linkado de `C:\Temp\Libs\zlib\lib\zlib.lib` — usada em `netplay.cpp`, `Quest.cpp`, `NewShop*.cpp` |
| **rapidjson** | **1.1.0**; JSON (payloads do Discord, headers Chilkat) | `Shared/rapidjson/` — usada em `Game/Discord/serialization.*`, `API/include/CkJsonObject.h` |
| **Discord (discord-rpc)** | Rich Presence oficial (app id `898283856086597702`); não é webhook; versão NÃO VERIFICADO | `Shared/Discord/` (include + discord-rpc.lib) + SDK fonte vendored em `SrcGame/src/Game/Discord/` — usada em `Discord.cpp`, `Winmain.cpp` |
| **Shared/Utils** | Matemática 3D X3D*, FileReader, logs, mutex — compilado dentro do cliente E do servidor | `Shared/Utils/` (via `Shared.vcxitems`) — servidor usa em `SQLConnection.cpp`, `CPartyHandler.cpp` |
| **imGui** | **1.83 WIP**; HUD/debug UI (backends DX9 + Win32) | `SrcGame/src/Game/imGui/` |
| **Lua** | **5.0.2**; scripts de efeitos (HoEffect) | `SrcGame/src/Game/HoBaram/NewEffect/HoEffect/Script/Lua/Win32/` (Lua.lib, lualib.lib) |
| **Chilkat "API"** | Headers Ck* (JSON/HTTP/compressão) + libcurl | `SrcGame/src/Game/API/include/` + `API/libcurl_a_debug.lib` (rastreada) |
| **libcurl** | **7.69.1** estático (vc16 x86 debug) | `C:\Temp\Libs\curl-7.69.1\...` — usada em `SodWindow.cpp`, `NewShop.cpp`, `NewShopTime.cpp` |
| **ODBC** | `odbc32.lib`/`odbccp32.lib` — acesso a SQL Server | SDK do Windows — servidor: `Server/SQL.cpp`, `Server/Database/SQLConnection.cpp` |
| **DirectSound** | `dsound.lib` — áudio | SDK do Windows (DX9) |
| **DirectX 9 / D3DX** | `d3d9.lib` + `d3dx9.lib` via `#pragma comment` | `C:\Temp\Libs\DX9\Lib\x86\` |
| **Windows SDK** | 10.0.26100.0 (Game) / 10.0 (Server) | `C:\Program Files (x86)\Windows Kits\10\Include\{22621,26100,28000}` |

---

**Resumo do trabalho:** li os 2 .sln, 2 .vcxproj, o Shared.vcxitems, .gitignore/.gitattributes, inspecionei Delta3D (headers + libs), ziparchive, zlib, rapidjson, Discord, Utils, a árvore OutDir e o git; confirmei executáveis e libs reais em `C:\Source Priston\` e `C:\Temp\Libs`. **Nenhum arquivo foi criado/modificado.** Não verificado: versão exata do ZipArchive e do discord-rpc, e se `discord-rpc.lib` chega a ser linkado. Ponto de atenção para editar com Cursor/IA: caminhos absolutos embutidos nos .vcxproj (Debug quebrado nesta máquina) e o fato de o .exe sair para fora do repo.