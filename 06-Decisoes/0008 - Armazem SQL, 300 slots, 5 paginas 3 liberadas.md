---
tags: [decisao, sql, cliente, servidor, shared]
status: substituida
data: 2026-09-17
---

# 0008 - Armazem SQL, 300 slots, 5 paginas (3 liberadas)

> **Substituida em 2026-09-18** pela ADR
> [[0009 - Armazem arquivo WH03, SQL revertido]] **na persistencia**.
> A grade 300, 3 paginas jogaveis e o fio `wVersion=3` **ficaram**.
> `UserDB.dbo.Warehouse` **nao** e a fonte viva. Nao reativar SQL do
> bau sem ADR nova. Historico: [[2026-09-18 - Armazem WH03 e falhas SQL]].

## Contexto

A ADR [[0006 - Armazem ImGui, paginas no mesmo transcode]] deixou o bau
no ImGui com 3 paginas de 100 `sITEM` no arquivo `.war` (magica `WH02`),
mesmo transcode, `wVersion=2`. A grade visivel continuava **9×9 de 22 px**
(~198 px numa janela 760×540). O jogador sentia o espaco pequeno.

Pedido: mais slots, 3 paginas no jogo, schema pronto para 5, persistencia
SQL, anti-dupe mais duro. Reescrever o drag em ImGui continua **proibido**
(tabela de falhas 2026-09-15).

## Opcoes consideradas

1. **So escalar a celula visual** (9×9 maior) — conforto, zero capacidade.
2. **Ampliar a grade e o `.war` WH03** — mais celulas, ainda arquivo binario,
   compressao de 300 `sITEM` estoura 8192.
3. **Banco `WarehouseDB` novo no boot** — isolamento de backup, mas
   `exit(0)` se faltar (lista obrigatoria).
4. **UserDB + pacote so de ocupados em chunks** — conta = bau; tabelas
   manuais no SSMS; mesmo `smTRANSCODE_WAREHOUSE`; `wVersion=3`.

## Decisao

Opcao 4.

- Persistencia: `UserDB.dbo.Warehouse` + `WarehouseItem`. Sem 12º database.
- Capacidade: 300 slots/pagina, 5 paginas no schema/RAM, **3 liberadas**
  (`WAREHOUSE_UNLOCKED_PAGES`). Pagina >= 3 o servidor recusa.
- Fio: so itens ocupados (`sITEMINFO` + posicao), comprimidos, fatias
  `dwTemp[1/2]`. Commit `dwTemp[4]=1`. Nao inflar `Data[]` com 300 `sITEM`.
- Drag: continua `cWAREHOUSE`.
- `.war` WH02: import **uma vez**; depois so SQL.
- Anti-dupe: unique SQL `Head+ChkSum` por conta; choque com inventario;
  `Revision` da sessao; transacao atomica das 3 paginas.

A ADR 0006 **permanece** para o hibrido UI/logica. Esta nota substitui
so a persistencia (`.war` como fonte viva) e o tamanho da grade.

## Consequencias

- Client e servidor **juntos** (`wVersion` 3).
- `WareHouseItemInfo` sobe para **1500**.
- Script SSMS: `09-Guias/sql/Create-Warehouse.sql` (copia na source
  `docs/sql/Create-Warehouse.sql`). Tabelas ausentes = recusa o bau, nao
  mata o `server.exe`.
- Peso: `Weight` vira `int`; teto SQL `WeightMax` (8000).
- Planta: [[Armazem]]. Recap:
  [[2026-09-17 - Recap Armazem SQL 300 slots]].
