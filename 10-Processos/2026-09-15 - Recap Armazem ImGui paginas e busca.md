---
tags: [processos, cliente, servidor, shared, imgui, feature]
status: feito
data: 2026-09-15
modulo: cliente servidor shared
---

# 2026-09-15 - Recap Armazem ImGui paginas e busca

O jogador passou a ver o bau no cromado ImGui, com busca e 3 paginas
(300 slots). A logica de item nao foi reescrita: `cWAREHOUSE` continua
mandando. Planta com fluxogramas: [[Armazem]]. ADR:
[[0006 - Armazem ImGui, paginas no mesmo transcode]]. Spec:
[[2026-09-13-armazem-paginas-busca]] (`feita`).

## Como era

Uma janela de pedra (`shop-1.bmp` + `Warehouse.bmp`), 100 slots, sem
busca, sem pagina. Pacote unico `smTRANSCODE_WAREHOUSE` (`0x48470047`).
Arquivo `Data\DataServer\WareHouse\<id>.war` com um blob so. Spec de
13/09 ainda pedia para **ficar na pedra** (ADR 0005).

## O que o jogador ve agora

- Janela ImGui no cromado das Desafios/Loja, titulo PNG `armazem.png`.
- Campo de busca por nome (esconde na grade; nao apaga).
- Botoes **1 / 2 / 3** — 100 slots cada, 300 no total.
- Ouro e peso na lateral; depositar/retirar num modal do mesmo cromado.
- Inventario ao lado **continua pedra**. Drag bau <-> bag igual ao
  antigo.
- Clique na janela nao anda o personagem. ESC fecha (ou limpa busca /
  modal primeiro).

## O que implementei (e por que)

- **Visual em `WarehouseWindow`, logica em `cWAREHOUSE`.** Reescrever
  overlap de 22 px em ImGui duplica item. A janela nova traduz clique
  para as funcoes antigas (`PickUpWareHouseItem`, `LastSetWareHouseItem`).
- **3 pacotes, nao 1 blob de 300.** O socket tem 8192 bytes. Cada
  pagina comprime 100 `sITEM` no `TRANS_WAREHOUSE` que ja existia.
  `wVersion[0] = 2`, `dwTemp[0] = pagina`. Transcode novo: nenhum.
- **`.war` com magica `WH02`.** Leitor aceita arquivo legado (1 pagina)
  e, no proximo save, grava 3. Merge por pagina no servidor: chegar a
  pagina 2 nao apaga a 1.
- **Esconder a pedra compartilhada.** `shop-1.bmp` tambem e loja NPC /
  aging. `ShouldHideClassicPanels` enquanto o bau abre ou carrega.
- **ImGui por cima do HUD de pedra.** Render em `sinDraw` (depois do
  mix/aging). Se ficasse em `sinCharStatus`, o `CraftItemMain.bmp`
  cobria o bau.
- **`WareHouseItemInfo[300]`** no `rsPLAYINFO` (`Shared/smPacket.h`) e
  loops `WAREHOUSE_TOTAL_SLOTS` no `OnSever.cpp` — anti-dupe cobre as
  3 paginas.

## Arquivos tocados

Repo do jogo (`C:\Source Priston\Source Priston`):

- `SrcGame/src/Game/HUD/WarehouseWindow.cpp` / `.h` (novo)
- `SrcGame/src/Game/sinbaram/sinTrade.cpp` / `.h`
- `SrcGame/src/Game/netplay.cpp` / `.h`
- `SrcGame/src/Game/GameCore.cpp`, `Winmain.cpp`, `HUD/InstancesFlag.cpp`
- `SrcGame/src/Game/sinbaram/sinMain.cpp`, `sinSubMain.cpp`, `sinShop.cpp`,
  `sinCharStatus.cpp`
- `SrcGame/src/Game/cSkinChanger.cpp` (nao desenha com o bau aberto)
- `SrcGame/src/game.vcxproj`
- `SrcServer/src/Server/Character/record.cpp` / `.h`
- `SrcServer/src/Server/sinbaram/sinTrade.h`
- `SrcServer/src/Server/SrcServer/OnSever.cpp` (loops 300 + save com
  `lpPlayInfo`)
- `Shared/smPacket.h` (constantes + `WareHouseItemInfo[300]`)
- Brief: `docs/prompt-antigravity-armazem-ui.md`
- Copia do titulo: `game/images/warehouse/armazem.png`

Cliente Full: `C:\Cliente Full\game\images\warehouse\armazem.png`

## Shared / protocolo

- Tocou em `Shared/`? **sim** (`smPacket.h`)
- Transcodes novos? **nenhum**
- Reuso: `smTRANSCODE_WAREHOUSE` (`0x48470047`),
  `smTRANSCODE_OPEN_WAREHOUSE` (`0x48470048`)

## O que testar

1. Depositar e retirar (pagina 1 e pagina 3). Relogar.
2. `.war` antigo — abre, paginas novas vazias, ouro igual.
3. Busca parcial; limpar volta a grade; item nao some.
4. Drag para o inventario de pedra e de volta.
5. Mix / aging / loja NPC com o bau **fechado** — pedra deles intacta.
6. Peso estourado — NPC nao abre o bau (mensagem antiga).

## O que ficou de fora / proximos passos

- Organizar inventario (spec propria, ainda pedra).
- Distribuidor / correio 168h.
- Caravana (continua 100 slots, arquivo separado).
- Armazem de clan.

## Aprendizado

Uma pagina por pacote cabe no socket; tres paginas num pacote so nao
cabem. Visual ImGui + logica `sin` e um hibrido valido quando o drag
ja existe. Ordem de `ImGui::Render` no frame importa tanto quanto o
cromado.

Planta: [[Armazem]].
