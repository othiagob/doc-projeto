---
tags: [ui, artes, cliente]
status: ativo
data: 2026-09-16
---

# Inventario de artes visuais

Estado em **2026-09-19**. Atualize esta nota quando uma arte entrar no
cliente ou uma tela mudar de classico para ImGui.

Recap deste bloco: [[2026-09-13 - Recap artes de login e titulos ImGui]].
Cromado ImGui ja documentado em [[2026-09-08 - Recap janelas ImGui de jogador]]
e na sessao [[2026-09-08 - HUD ImGui lojas ranking mix e painel do servidor]].

## Feito — titulos ImGui (jogador ja ve)

Canvas padrao **400x64**, fundo recortado, fallback em texto dourado se o
PNG faltar. Source e Cliente Full **iguais** nestes arquivos:

| Tela | Arquivo no cliente |
|---|---|
| Loja de Coins | `game/images/shop/loja-de-coins.png` |
| Loja de Tempo | `game/images/shop/loja-de-tempo.png` |
| Desafios | `game/images/quest/desafios.png` |
| Overlay Em andamento | `game/images/quest/emandamento.png` |
| Configuracoes | `game/images/settings/configuracoes.png` |
| Ranking | `game/images/ranking/ranking.png` |
| Lista de Mix | `game/images/mix/lista-de-mix.png` |
| Armazem | `game/images/warehouse/armazem.png` |
| Distribuidor | `game/images/postbox/distribuidor.png` |
| Mestre dos Clan | `game/images/clan/mestre-dos-clan.png` (320×26 kit B) |

Excecao pontual do Distribuidor (nao e o cromado padrao):

| Peca | Arquivo | Tamanho | Uso |
|---|---|---|---|
| Moldura da janela | `game/images/postbox/frame.png` | **760x540** | Blit 1:1 em `PostBoxWindow`. Nao copiar para Desafios/Loja/Armazem. |

Contrato: `.cursor/rules/15-imgui-windows.mdc`. Janelas:
`QuestWindow`, `Settings`, `NewShop`, `NewShopTime`, `RankingWindow`,
`MixWindow`, `WarehouseWindow`, `PostBoxWindow`, `ClanWindow`. Cromado compartilhado: `ImGuiWindowChrome.h`.

Moldura kit B (`frame.png` 760×540, bronze 732) — mesmo arquivo em:

`postbox/`, `quest/`, `settings/`, `shop/`, `ranking/`, `mix/`,
`warehouse/`, `clan/`. Nao e 9-slice.

HUD classico de pedra (inventario, HP, `sinbaram/` **exceto o bau**)
**nao** usa estes PNG. O armazem migrou (ADR 0006).

## Feito a parte — login de conta + intro

Kit PNG Fallen Tale. O C++ carrega de `game\images\login\`:

Kit PNG Fallen Tale. O C++ carrega de `game\images\login\`:

| Arquivo | Uso |
|---|---|
| `bg1.png` | Fundo (cover, sem amassar a logo) — `LoginModel.cpp` |
| `window.png` | Painel |
| `btl.png` / `btl_.png` | Botao Entrar (idle / hover) |
| `bte.png` / `bte_.png` | Botao Sair (idle / hover) |
| `bg_selector.png` | Seletor de mundo |

Nomes existem na source **e** no Cliente Full, mas os **bytes divergem**
(tamanhos diferentes). Runtime = cliente. Pasta `login\source\` na source
= recortes de referencia para IA; o jogo nao le.

Ainda referenciados no codigo e **ausentes** nos dois lados:
`bg_servers.png`, `seasonal_overlay.png`.

Intro (`IntroSplash`): video `game\textures\misc\login.asf` ou PNG
`intro.png` (brief `docs/prompt-antigravity-intro-ui.md`). Planta:
[[Login-e-intro]].

## Em arte, ainda nao no jogo — char select

Brief para gerador de arte (mesmo nome e tamanho, TGA):

`C:\Source Priston\Source Priston\docs\prompt-antigravity-charselect-ui.md`

O jogo ainda usa o pipeline classico em `HoLogin.cpp`:
`C:\Cliente Full\StartImage\login\` (`CharSelect\`, `Moryon\`, retratos,
info). Nao redesenhar o login de conta nesse brief — ja foi feito a parte.

Status no backlog: **estudar / arte** (trocar arquivo no cliente; C++ so
muda se o nome ou o tamanho mudarem — o prompt pede para nao mudar).

## Classico de proposito (nao e atraso)

Estas telas continuam BMP/TGA legado ate pedido explicito (ADR 0002 +
[[0005 - Distribuidor ImGui, armazem e inventario em pedra, artes no Cliente Full]];
bau saiu da lista em 2026-09-15, ADR 0006):

- Inventario e HP (`sinbaram/`)
- Icones de item (`image\sinImage\Items\...`)
- Premium, caravana, party classica, minimapa, shop NPC de ouro

## Experimentos que nao entram no padrao

Nao commitar como "UI oficial" (tabela de falhas da sessao 2026-09-08):

- PNG de 9-slice (`game/images/ui/` frame-corner / edges)
- Pergaminho de fundo em Desafios
- Titulo PNG enorme com fundo vazio (a escala usa a imagem inteira)

## Correcoes visuais ja feitas (nao so arte nova)

- Clique na janela ImGui nao anda o personagem (`WantCaptureMouse`)
- Titulo recortado 400x64 (canvas enorme virava selo ilegivel)
- Acentos ImGui em UTF-8 na borda da janela; minimapa continua ANSI
  (ADR 0004)
- Server.exe **nao** usa ouro de jogador (ADR 0002, `16-desktop-tools.mdc`)

## Como as artes nascem

PNG/TGA de UI: **Antigravity + Gemini** -> `C:\Cliente Full`. O Cursor
nao gera esses arquivos. [[Como-gerar-artes]].

Hub: [[index]]. Roadmap: [[Roadmap-UI]].
