---
tags: [arquitetura, glossario]
---

# Glossário Técnico

> Termos, siglas e convenções específicas deste projeto — **verificados no
> código em 2026-08-31**. Se um termo confuso aparecer de novo, atualize
> aqui pra nunca precisar adivinhar de novo.

## Engine / bibliotecas

| Termo | O que é (verificado) |
|---|---|
| **Delta3D** | Engine 3D **própria do projeto** (pré-compilada, namespace `Delta3D::Core/Graphics/Math/...`), roda em **Direct3D 9**, matemática derivada do Urho3D. É a base do renderizador novo do cliente. **Não é o Delta3D open-source** (não tem dtCore/dtABC). Em `dependencies/Delta3D/`. |
| **smLib3d** | Engine 3D **legada** (era DirectX 7/8): stages `.dsx`, objetos, render antigo, matrizes, seno/cosseno. Usada tanto no cliente quanto no servidor (herança). |
| **sinbaram** | **Núcleo do jogo** (cliente): HUD clássico, inventário, itens, loja, troca, skills, quests, efeitos — 38 arquivos `sin*.cpp`. No servidor: itens premium/cash (`haPremiumItem.cpp`). Nome de origem coreana. |
| **HoBaram** | Engine/UI **legada "Ho"** (cliente): tela de abertura/login (`HoOpening`, `HoLogin`), party clássica, efeitos, física, céu, pets. |
| **TJBOY** | Subsistemas legados do cliente (menu de clã, auth/launcher `isaocheck`). No servidor são **sobras** sem função ativa. |
| **ZipArchive** | Biblioteca de terceiros (Artpol Software) pra ler/escrever `.zip` — usada pra abrir os pacotes `.pak` de assets. Em `dependencies/ziparchive/` (lib de 35 MB). |
| **ohZipLib** | Leitor de zip próprio do PT (`WinInt/ZipLib.h`) — usado em `netplay.cpp` e downloads HTTP. |
| **imGui** | Dear ImGui **1.83 WIP** — UI de debug/overlays novos (HUD/InstancesFlag, Roleta, RankingWindow...). Não é a UI clássica do jogador. |
| **rapidjson** / **nlohmann::json** | Duas bibliotecas JSON: `rapidjson` **1.1.0** em `Shared/` (Discord/serialização), `nlohmann` no servidor. Confirme qual o arquivo usa antes de importar. |
| **zlib** | Compressão **1.2.11** — rede/save (`netplay.cpp`, `Quest.cpp`, `NewShop*`). Binário linkado de `C:\Temp\Libs\zlib`. |
| **Lua** | **5.0.2** — scripts de efeitos (`HoBaram/NewEffect/HoEffect/Script/Lua`), no cliente. |
| **Chilkat / libcurl** | Biblioteca externa gigante (HTTP, SSL, cripto) + curl 7.69.1 estático — em `Game/API/`. Não é código do jogo. |
| **Discord (discord-rpc)** | SDK oficial de **Rich Presence** (App ID `898283856086597702`) — mostra "jogando Priston" no Discord. Só no **cliente**. |

## Protocolo de rede

| Termo | O que é |
|---|---|
| **`smTRANSCODE_*`** | Código de pacote de rede, definido em `Shared/smPacket.h` (~2.800 linhas). Cada valor = um tipo de mensagem (ex: `smTRANSCODE_ATTACKDATA 0x48470030`). **Nunca reutilizar um valor.** |
| **`smTRANS_COMMAND`** | Struct do pacote: `{ int size; int code; int LParam; WParam; SParam; EParam; }` (24 bytes). `code` = o `smTRANSCODE_*`. |
| **Handler de pacote** | Função que trata um `smTRANSCODE_*` recebido: `RecvMessage` no servidor (OnSever.cpp:18175, switch gigante) e no cliente (`netplay.cpp:1188`). Pacote novo = handler nos dois lados. |
| **`TCP_SERVPORT`** | Porta de login/DataServer: **32299** (lida do `Connect.ini`). |
| **`TCP_GAMEPORT`** | Porta do jogo: **8185** (constante em `smwsock.h`, igual nos 2 lados). |
| **`WSAAsyncSelect`** | Modelo de rede do servidor: socket assíncrono dirigido por mensagens do Windows (sem 1 thread por conexão). |
| **`_PACKET_PASS_XOR`** | Chave de criptografia XOR do cliente (**0x8B**). |
| **`smTRANSCODE_ENCODE_PACKET`** | Pacote codificado/criptografado (`0x80010000`/`0x90010000`) — decodificado no recv. |
| **CP949/EUC-KR** | Codificação dos comentários coreanos legados — aparecem como "lixo" em editores, mas o código é válido. |

## Termos de jogo (sistemas confirmados)

| Termo | Módulo | O que é (verificado) |
|---|---|---|
| **Aging** | servidor | Evolução de itens com chance de falha; falhou -> recuperável pagando num NPC (`Aging/RestaureItem.cpp`, tabela `AgingFailed`) |
| **Restaure** | servidor | Recuperação de itens perdidos no Aging |
| **Roleta** | servidor + cliente | Evento: os **10 maiores danos** contra um monstro viram sorteio; prêmio na tabela `Roleta` |
| **Caravana** | servidor + cliente | NPC caravana que acompanha o jogador (comércio móvel; nomeável; tabela `Caravans`) |
| **Arena** | servidor + cliente | Evento PvP em times (campo 49, ranking por equipe) |
| **EragonLair** | servidor | Boss dragão com stages |
| **Invasao** | servidor | Evento de invasão (campo 53) — no cliente é stub (não implementado lá) |
| **Questions** | servidor | Evento quiz com etapas |
| **VIP** | servidor + cliente | Níveis VIP + NPCs premium ("Loja da Gaby"), itens de cash com duração (`PremiumData.TimeLeft`) |
| **Montarias** | cliente | Montarias (modelos, animações) |
| **Castelo Sagrado** | servidor | Siege com mercenários (20/lado), impostos (`Imposto`), ranking Sod |
| **SOD** | servidor + cliente | Sistema "SoD" (origem coreana) — ranking próprio (`SodRanking`, `sinSOD2.cpp`) |
| **PostBox** | servidor | Correio do jogo — sem pasta própria; usa `Data/PostBox/<usercode>/<id>.dat` |
| **PCBang / LowLevelPet** | cliente | Pets (sistemas de PC Bang e pet de nível baixo) |
| **HoOpening / HoLogin** | cliente | Telas de abertura e login clássicas |

## Estruturas e formatos

| Termo | O que é |
|---|---|
| **`.dat`** | Arquivo binário de personagem (`Data/DataServer/userdata/<código>/<nome>.dat`) — o servidor salva o personagem nele |
| **`.pak` / `.pkg`** | Pacotes de assets em formato zip (`game\data\*.pkg`, lidos via `PackageFile.cpp`/ZipArchive) |
| **`.dsx`** | Formato de stage/mapa da engine legada smLib3d |
| **`.fx`** | Shaders (ex: `Terrain.fx` — terreno do renderizador novo) |
| **`smConfig`** | Struct global de configuração (cliente e servidor) — janela, rede, qualidade |
| **`VRKeyBuff[256]`** | Array global com o estado das teclas (cliente) |
| **`rsPLAYINFO`** | Classe gigante do jogador no servidor (smPacket.h:1099) |
| **`smCHAR`** | Classe do personagem no cliente (character.cpp, 16.249 linhas) |

## Classes de personagem (`Shared/Skills/*.h`)

As **8 classes jogáveis** do Priston, um header por classe com as skills:

| Nome | Código (`JOBCODE_*`) | Header |
|---|---|---|
| Fighter (Lutador) | 1 | `fighter.h` |
| Mechanician (Mecânico) | 2 | `mechanician.h` |
| Archer (Arqueira) | 3 | `archer.h` |
| Pikeman (Piqueiro) | 4 | `pikeman.h` |
| Atalanta | 5 | `atalanta.h` |
| Knight (Cavaleiro) | 6 | `knight.h` |
| Magician (Maga) | 7 | `magician.h` |
| Priestess (Sacerdotisa) | 8 | `priestess.h` |

## Siglas úteis

- **WDPT** — a base de código original do servidor (fork da comunidade)
- **MMO / MMORPG** — jogo online massivo
- **ODBC** — API padrão do Windows pra falar com bancos de dados
- **DX9 / D3D9** — Direct3D 9 (API gráfica)
- **GM** — Game Master (administrador do jogo)
- **ADR** — Architecture Decision Record (registro de decisão — pasta `06-Decisoes/`)
- **SDD** — Software Design Document (este projeto -> `05-Specs/SDD-Source-Priston.md`)
- **CLI** — interface de linha de comando (console do servidor)