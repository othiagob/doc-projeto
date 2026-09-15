---
tags: [diario, cliente, servidor, shared, ui]
data: 2026-09-15
---

# 2026-09-15 - Armazem ImGui, paginas e busca

## O que foi feito

Ritual de documentacao do bau + fluxogramas na arquitetura. O codigo
ja estava no client/servidor: janela ImGui (`WarehouseWindow`), 3
paginas de 100, busca local, `.war` `WH02`, mesmo
`smTRANSCODE_WAREHOUSE` (`0x48470047`).

Livro: recap [[2026-09-15 - Recap Armazem ImGui paginas e busca]],
planta [[Armazem]], ADR [[0006 - Armazem ImGui, paginas no mesmo transcode]].

## Decisoes tomadas

ADR 0006: armazem **saiu da pedra** (a 0005 pedia o contrario).
Inventario continua pedra. Paginas = 3 pacotes, nao um blob de 300.

Convencao nova: mudanca grande de fluxo ganha mermaid em
`02-Arquitetura/` — [[Como-documentar-funcionalidade]].

## Problemas encontrados (no codigo, nao neste ritual)

- `shop-1.bmp` compartilhado: precisou esconder o painel classico.
- `ImGui::Render` cedo demais cobria o bau com mix/aging.
- Socket 8192: 300 itens num pacote nao cabem.

## Proximos passos

Organizar inventario e distribuidor/correio ainda sao spec. Testar no
jogo o plano do recap se ainda nao fechou o ciclo.

## Notas soltas

Titulo PNG: `game/images/warehouse/armazem.png` no Cliente Full
(copia opcional na source). Brief:
`docs/prompt-antigravity-armazem-ui.md`.
