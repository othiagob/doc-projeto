# Arquitetura do Projeto — Source Priston

> Última revisão: preencher a cada mudança estrutural relevante.
> Este documento é a "planta baixa". Ele não descreve *cada* função — descreve
> onde as coisas moram e por quê, para que qualquer pessoa (ou o Cursor) saiba
> em qual pasta procurar/editar antes de tocar em código.

## 1. Visão geral

Projeto MMO cliente-servidor em C++ (Visual Studio 2022, toolset v143, C++17),
dividido em três grandes áreas:

```
Source Priston/
├── SrcGame/       -> Cliente (renderização, input, UI, lógica local)
├── SrcServer/      -> Servidor (autoridade de jogo, banco de dados, segurança)
├── Shared/          -> Código compartilhado entre client e server
└── dependencies/    -> Bibliotecas de terceiros (NÃO EDITAR)
```

Regra de ouro: **qualquer coisa que descreva o protocolo de rede ou regras de
jogo que precisam ser idênticas nos dois lados vive em `Shared/`.** Se você
duplicar isso em `SrcGame` e `SrcServer` separadamente, vai dessincronizar
cedo ou tarde.

## 2. Cliente — `SrcGame/src/Game/`

Solução: `Game.sln` → projeto `game.vcxproj`. Engine gráfica: `Delta3D`
(wrapper sobre DirectX, em `dependencies/Delta3D/`).

| Pasta | Responsabilidade (hipótese a confirmar) |
|---|---|
| `Engine/` | núcleo de render/loop/janela |
| `HUD/` | interface do jogador em jogo (vida, mana, barra de skill, etc.) |
| `WinInt/` | janelas/telas Win32 (login, criação de char, etc. — a validar) |
| `Login/` | fluxo de autenticação no cliente |
| `Chat/` | sistema de chat |
| `Party/` | grupo/party |
| `Quest/` | sistema de missões |
| `Shop/` | loja / cash shop |
| `Skill/` | execução/exibição de habilidades |
| `Caravana/`, `Eventos/`, `Montarias/`, `Park/`, `Roleta` (server), `VIP/`, `HoBaram/`, `TJBOY/` | features específicas do servidor Priston (eventos, montarias, VIP etc.) |
| `Discord/` | integração com Discord (rich presence / webhook?) |
| `imGui/` | biblioteca de UI de debug/ferramentas |
| `sinbaram/`, `smLib3d/`, `srcsound/` | bibliotecas internas legadas (engine antiga / som) |
| `API/` | chamadas externas (a confirmar quais) |

> ⚠️ Ação recomendada: para cada pasta acima, abra os 2-3 arquivos mais
> importantes, confirme a responsabilidade real, e apague o "(a validar)".
> Faça isso aos poucos — não precisa ser hoje. Marque no PR quando confirmar
> uma pasta.

## 3. Servidor — `SrcServer/src/Server/`

Solução: `server.sln` → projeto `server.vcxproj`.

| Pasta | Responsabilidade (hipótese a confirmar) |
|---|---|
| `GameServer/` | loop principal do servidor de jogo |
| `Database/` | acesso a banco de dados |
| `Security/` | anti-cheat / validação / criptografia de pacotes |
| `GM/` | comandos e ferramentas de game master |
| `CLI/` | interface de linha de comando do servidor |
| `Character/` | modelo de personagem no servidor |
| `Ranking/` | rankings/leaderboards |
| `Aging/` | sistema de "aging" (evolução/envelhecimento de item ou personagem) |
| `Roleta/` | sistema de roleta/sorteio |
| `Data/`, `Resource/` | dados estáticos carregados pelo servidor |
| `English/`, `SrcLang/` | strings localizadas |
| `nlohmann/` | biblioteca JSON (`nlohmann/json`) vendorizada |

## 4. Compartilhado — `Shared/`

Este é o código mais sensível do projeto: uma mudança aqui **sempre** afeta
cliente e servidor ao mesmo tempo.

| Arquivo/Pasta | O que é |
|---|---|
| `smPacket.h` | definição dos códigos de pacote de rede (`smTRANSCODE_*`) — **o contrato entre client e server** |
| `LevelTable.h` | tabela de progressão/nível |
| `Skills/*.h` | um header por classe (archer, atalanta, fighter, knight, magician, mechanician, pikeman, priestess) — dados/definições de skill por classe |
| `Utils/` | matemática (`X3DVector3`, `X3DMatrix4`, `X3DQuaternion`...), strings, mutex, debug, leitura de arquivo |
| `rapidjson/`, `zlib/` | bibliotecas vendorizadas |
| `Discord/` | integração compartilhada com Discord |

## 5. Dependências — `dependencies/`

- `Delta3D/` — engine gráfica (headers + `.lib`/`.pdb` pré-compilados). **Não
  editar.** Se precisar mudar comportamento de render, prefira encapsular a
  chamada no lado do jogo (`Game/Engine/`) em vez de tocar na lib.
- `ziparchive/` — biblioteca de leitura/escrita de `.zip` (baseada em MFC).
  **Não editar.**

## 6. Build

- IDE: Visual Studio 2022, toolset **v143**, SDK do Windows **10.0.26100.0**,
  padrão **C++17**.
- Configurações: `Debug`/`Release` × `Win32` (client) — servidor pode ter
  targets próprios (`DebugServer`/`ReleaseServer` em `OutDir/`).
- Saída: `OutDir/DebugGame`, `OutDir/ReleaseGame`, `OutDir/DebugServer`,
  `OutDir/ReleaseServer` (ignorados no git — corretamente).

## 7. O que falta documentar (backlog de arquitetura)

Preencha conforme for confirmando:
- [ ] Fluxo completo de login (client → server, quais pacotes)
- [ ] Como uma skill nova é adicionada (quais arquivos tocar em Shared + Game + Server)
- [ ] Como o servidor persiste dados (schema do banco, migrations existem?)
- [ ] Sistema de anti-cheat em `Security/` — o que ele valida
- [ ] Fluxo de item (criação, trade, warehouse, mix) — múltiplos `smTRANSCODE_*` envolvidos
