---
tags: [decisao, imgui, cliente, servidor, shared]
status: aceita
data: 2026-09-15
---

# 0006 - Armazem ImGui, paginas no mesmo transcode

## Contexto

A ADR [[0005 - Distribuidor ImGui, armazem e inventario em pedra, artes no Cliente Full]]
deixou o armazem na pedra: paginas, busca e textura **sem** sair do
`cWareHouse` + BMP. A spec [[2026-09-13-armazem-paginas-busca]] repetia
isso.

Na implementacao o pedido visual mudou: o bau passou a usar o cromado
ImGui das outras janelas de jogador (regra 15), com titulo
`armazem.png`. O inventario **nao** migrou. Precisava caber 300 slots
sem estourar o socket de 8192 nem inventar `smTRANSCODE_*`.

## Opcoes consideradas

1. **Ficar na pedra (ADR 0005)** — menor risco de UI. A grade 9x9 ja
   era apertada; busca e abas em BMP novo iam brigar com hitbox de 22
   px e com o `shop-1.bmp` compartilhado.
2. **Reescrever drag e slots em ImGui** — visual unico, alto risco de
   duplicar item (o mesmo medo da ADR 0005).
3. **Hibrido:** `WarehouseWindow` pinta e traduz clique; `cWAREHOUSE`
   continua dono do `sITEM`. Rede: 3 pacotes no transcode antigo,
   uma pagina cada. Save `.war` com magica `WH02` e leitor legado.

4. **Um blob de 300 no `TRANS_WAREHOUSE`** — muda o tamanho do pacote,
   quase certamente passa de 8192 comprimido, exige chunk ou transcode
   novo.

## Decisao

Opcao 3.

- Armazem = janela ImGui (contrato 15). Inventario = pedra (ADR 0005
  permanece para a bag).
- Sem transcode novo. `wVersion[0] = 2`, `dwTemp[0] = indice da pagina`.
- `.war` antigo abre na pagina 1; paginas 2–3 nascem vazias.
- Ouro/peso so na pagina 0.

A parte "armazem fica pedra" da ADR 0005 fica **substituida** por esta
nota. Distribuidor e inventario na 0005 continuam validos.

## Consequencias

- Toda tela de jogador nova ou remodelada (incluindo o bau) segue
  `15-imgui-windows.mdc`. HUD de pedra restante: inventario, HP, mix,
  aging, loja NPC de ouro, caravana.
- Client e servidor **juntos** em qualquer save de pagina. `WareHouseItemInfo`
  no `rsPLAYINFO` tem de ter 300 entradas.
- Prompt de arte do bau e titulo 400x64, nao redesenho de `shop-1.bmp`.
- Planta: [[Armazem]] (persistencia **SQL** desde 2026-09-17 — ADR
  [[0008 - Armazem SQL, 300 slots, 5 paginas 3 liberadas]]). Recap UI:
  [[2026-09-15 - Recap Armazem ImGui paginas e busca]].

O hibrido ImGui + `cWAREHOUSE` desta ADR **permanece**. O save `.war`
WH02 / `wVersion=2` / `WareHouseItemInfo[300]` foi substituido pela 0008.
