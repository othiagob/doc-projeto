---
tags: [analise, ex-machina, arquitetura, c++, dx11, rmlui, slikenet]
---

# 01 - Raio-X da Source Ex-Machina

Estudo aprofundado sobre o repositório de código localizado em `D:\Source Cliente e Server`.

---

## 1. Identificação do Projeto

- **Nome Oficial:** `priston-ex-machina`
- **Autor Original:** Igor Segalla (`igorsegallafa`)
- **Repositório Remoto:** `https://github.com/igorsegallafa/priston-ex-machina.git`
- **Total de Commits:** 242 commits
- **Último Commit:** `f85d712` (*"Use GetSubsystem instead of static variable to register RPC"* - 17 de Setembro de 2021)
- **Compilador Alvo:** Visual Studio 2019 / 2022 (v142 / v143), MSBuild, padrão C++17 / C++20.
- **Gerenciador de Pacotes:** `vcpkg` (instalação estática em x64: `slikenet:x64-windows-static directxtk:x64-windows-static lua:x64-windows-static rmlui:x64-windows-static`).

---

## 2. Estrutura da Solução (`ex-machina.sln`)

A solução está particionada em 4 projetos modulares:

```
D:\Source Cliente e Server\
├── bin/                          # Binários compilados (Debug/Release para x86 e x64)
├── include/ & lib/               # Dependências locais
├── docs/                         # Documentação e Doxygen (Doxyfile)
├── src/
│   ├── shared/                   # Código comum a cliente e servidores (DLL/Lib estática)
│   │   ├── Core/                 # Subsystem, EventProvider, EventsDef
│   │   ├── IO/                   # AsyncWorker, BinaryReader, BinaryWriter, Logger
│   │   ├── Network/              # Connection, MessageStream, MessagesHandler, RPC
│   │   └── Utils/                # StringFormat, StringExtender, FlagSet, FunctionBinding
│   ├── game/                     # Cliente do Jogo (Game.exe)
│   │   ├── Audio/                # Gerenciamento de áudio moderno
│   │   ├── Graphics/             # Renderizador nativo DirectX 11 / DirectXTK
│   │   ├── UI/                   # Integração de interface HTML/CSS com RmlUi
│   │   ├── Network/              # Handlers de rede cliente
│   │   └── Legacy/               # Código original do Priston refatorado e desacoplado
│   ├── gameserver/               # Servidor do Jogo (gameserver.exe)
│   │   ├── Network/              # Loop de rede e conexões via SlikeNet
│   │   └── Legacy/               # Lógica original do servidor limpa de inline assembly
│   └── dataserver/               # Servidor de dados (Login/Contas - protótipo moderno)
```

---

## 3. Principais Inovações Técnicas

### 3.1. Eliminação Total de Assembly Inline (`__asm = 0`)
No Priston Tale clássico de 2001/2004, dezenas de rotinas usavam assembly inline de 32-bit (`__asm { ... }`) para cálculos matemáticos (`smsin`, matrizes), manipulação de ponteiros e criptografia de pacotes. Isso impedia completamente a compilação nativa em **64-bit (x64)**.
- **No Ex-Machina:** A contagem de `__asm` é **rigorosamente zero**. Todas as funções foram reescritas com instruções C++ portáveis e intrínsecos padrão.

### 3.2. Renderizador Nativo DirectX 11 (DirectXTK)
- O código em `src/game/Graphics/` substitui as chamadas legadas do Direct3D 9 / DirectDraw por:
  - `ID3D11Device` e `ID3D11DeviceContext` inicializados em hardware moderno.
  - `DirectXTK` (DirectX ToolKit da Microsoft) para geometria, estados de renderização (`CommonStates`), manipulação de matrizes (`SimpleMath`) e shaders HLSL.
  - O código legado (`src/game/Legacy/Engine/Graphics/smDsx.cpp`) foi adaptado para alimentar esse pipeline DX11 sem depender de rotinas legadas de 16-bit.

### 3.3. Interface de Usuário Moderna com RmlUi (HTML/CSS)
- Ao invés de usar o modelo arcaico do Priston Tale (desenhar caixas retangulares cheias de cálculos de coordenadas `x, y, w, h` e blits 2D manuais), o Ex-Machina integrou a biblioteca **RmlUi** (sucessora do libRocket).
- A engine renderiza interfaces escritas em **HTML/CSS** diretamente na tela via GPU (`RenderInterface.cpp`).
- Arquivos de exemplo inclusos: `window.rml` e `rml.rcss`.

### 3.4. Rede Moderna Baseada em SlikeNet e RPC
- A camada de rede substitui a antiga Winsock monolítica síncrona por **SlikeNet** (fork mantido da famosa RakNet).
- Possui:
  - Envio e recebimento via `SLNet::BitStream`.
  - Serialização automática e segura de tipos (`MessageStream::ReadValue<T>()`).
  - RPC (Remote Procedure Call) tipado com `std::tuple` e `std::apply` (`RemoteProcedureCall.hpp`), permitindo disparar funções do servidor diretamente com argumentos fortemente tipados.

### 3.5. Padrão de Subsistemas (Subsystem Architecture)
- Inspirado na arquitetura da Unreal Engine, o Ex-Machina possui a classe base `Shared::Subsystem` (`src/shared/Core/Subsystem.hpp`).
- Cada subsistema (Gráficos, Rede, Logger, Áudio) é um singleton gerenciado de ciclo de vida bem definido, permitindo testes unitários e desacoplamento de dependências.

---

## 4. Comparação com o Projeto Fallen (`C:\Source Priston`)

| Aspecto | Projeto Fallen (`c:\Source Priston`) | Source Ex-Machina (`D:\Source Cliente e Server`) |
|---|---|---|
| **Arquitetura Alvo** | 32-bit (x86 / Win32) | 32-bit e 64-bit (x64 nativo) |
| **Padrão C++** | C++14 / C++17 com MSVC | C++17 / C++20 moderno com vcpkg |
| **Assembly Inline** | Poucos resíduos (8 ocorrências) | **Zero** ocorrências |
| **API Gráfica** | DirectX 9 clássico | DirectX 11 nativo com DirectXTK |
| **Camada de UI** | Clássico PT + ImGui customizado | Clássico PT + RmlUi (HTML/CSS nativo) |
| **Rede** | WinSockets / Packets clássicos do PT | SlikeNet UDP / BitStream / RPC |
| **Sistemas Custom** | Armazém SQL (WH03), Logs GM, ImGui | Estrutura limpa de engine, sem sistemas de jogo extras |
| **Classes Ativas** | 8 Classes (Fighter .. Priestess) | 8 Classes (Fighter .. Priestess) |
| **Nível de Tiers** | Tier 1 a Tier 4 | Tier 1 a Tier 4 |

---

## 5. Conclusão da Análise da Source

A source `priston-ex-machina` é um projeto de **engenharia de software e modernização de engine**, e **não** uma base de conteúdo expandido (não possui classes 9 e 10 nem Tier 5 codificados). 

Ela é excelente para nos ensinar **como limpar o código legado, como migrar para x64, como integrar RmlUi e como modernizar a rede**.