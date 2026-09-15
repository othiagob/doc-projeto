---
tags: [ui, artes, cliente]
status: ativo
data: 2026-09-13
---

# Onde vivem as imagens

O `game.exe` **nao** le a pasta da source. Ele abre arquivos relativos ao
diretorio de trabalho, que no F5 do Visual Studio e `C:\Cliente Full`
(`game.vcxproj.user` -> `LocalDebuggerWorkingDirectory`).

Compilar o `SrcGame` **nao** embute PNG/TGA/BMP no `.exe`. Se o arquivo
existe so em `C:\Source Priston\Source Priston\game\images` e falta no
cliente, a tela nao aparece (ou a janela ImGui cai no texto dourado de
fallback).

ADR: [[0005 - Distribuidor ImGui, armazem e inventario em pedra, artes no Cliente Full]].

## Os dois lugares

| Onde | Para o jogo | Para o git / Cursor |
|---|---|---|
| `C:\Cliente Full\...` | **Obrigatorio** — e o que o exe abre | Nao precisa estar no git da source |
| `C:\Source Priston\Source Priston\game\images\...` | **Nao entra no jogo** | Copia opcional: o Cursor ve a arte; da para versionar titulos |

A pasta na source e um recorte pequeno (login, titulos de Loja/Desafios/
Ranking/Mix/Config). O cliente tem a arvore completa: `UI`, `premium`,
`shop` (icones), `StartImage`, `image\sinImage\Items`, etc.

## Duas arvores de login

| Tela | Caminho que o C++ pede | Onde colocar o arquivo |
|---|---|---|
| Login de conta (PNG novo) | `game\images\login\...` | `C:\Cliente Full\game\images\login\` |
| Selecao / criacao de personagem | `StartImage\Login\...` | `C:\Cliente Full\StartImage\login\` |
| Titulos ImGui 400x64 | `game\images\<tela>\<nome>.png` | `C:\Cliente Full\game\images\...` |
| Icone de item | `image\sinImage\Items\<pasta>\itCODIGO.bmp` | Cliente Full (nao vem do SQL) |
| HUD de pedra (inventario, mix, aging, loja NPC) | `Image\SinImage\...` BMP | Cliente Full |

Codigo de referencia:

- Login: `SrcGame/src/Game/Login/LoginModel.cpp` (`bg1.png`),
  `LoginScreen.cpp`, `HoOpening.cpp` (`window`, `btl`, `bte`)
- Char select: `SrcGame/src/Game/HoBaram/HoLogin.cpp` (`StartImage\Login\...`)
- Titulos ImGui: `NewShop.cpp`, `QuestWindow.cpp`, `Settings.cpp`,
  `RankingWindow.cpp`, `MixWindow.cpp`, `WarehouseWindow.cpp`
  (`game/images/warehouse/armazem.png`)

## Source vs cliente (cuidado)

Os titulos ImGui (Loja, Desafios, Ranking, Mix, Configuracoes) estavam
**byte-iguais** nos dois lados em 2026-09-13.

Os PNGs de **login** tem os **mesmos nomes** nos dois lados, mas
**tamanhos diferentes**. O exe usa o Cliente Full. Artes novas nascem no
**Antigravity (Gemini)** — grave no cliente. Copiar para a source e
opcional (backup / Cursor ver a imagem). Ver [[Como-gerar-artes]].

Referencias de artista (`game\images\login\source\*_ref.png`) **nao** sao
carregadas pelo jogo.

Arquivos que o codigo ainda pede e **nao existem** (source nem cliente):

- `game\images\login\bg_servers.png`
- `game\images\login\seasonal_overlay.png`

## Como nao se perder

1. Arte nova de tela ImGui: mesmo nome que o C++ ja procura, no Cliente Full.
2. Char select: substituir TGA **com o mesmo nome e tamanho** em
   `StartImage\login\` (brief: no repo do jogo,
   `docs/prompt-antigravity-charselect-ui.md`).
3. Nao trate as duas pastas como a mesma coisa. Atualizar so a source nao
   muda o jogo; atualizar so o cliente nao atualiza o git.

Hub: [[index]].
