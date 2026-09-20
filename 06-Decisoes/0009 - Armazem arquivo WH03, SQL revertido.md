---
tags: [decisao, cliente, servidor, shared]
status: aceita
data: 2026-09-18
---

# 0009 - Armazem arquivo WH03 (SQL revertido)

## Contexto

A ADR [[0008 - Armazem SQL, 300 slots, 5 paginas 3 liberadas]] trocou o
save do bau de `.war` WH02 para `UserDB.dbo.Warehouse` / `WarehouseItem`.
A grade 20×15, o fio `wVersion=3` (so ocupados) e o hibrido ImGui +
`cWAREHOUSE` (ADR 0006) eram o pedido certo. A persistencia SQL, no
ODBC deste projeto (`SQLConnection`), **nao fechou** depois de varias
tentativas: o jogador depositava um anel, fechava, e o item voltava
com rollback. A mensagem antiga "Muitos Itens no Armazem" era mentira
(era falha de save, nao capacidade).

Pedido do Thiago: opcoes **alem de SQL**. Escolha: arquivo `.war` no
formato atual (ocupados, 300×3), sem banco.

## Opcoes consideradas

1. **Continuar no SQL** (mais RESET_PARAMS, ItemBlob, transacao) —
   ja tentado; o wrapper ODBC e um atoleiro. Nao voltar sem ADR nova
   e outro caminho de banco.
2. **Arquivo `.war` WH03** (ocupados, 300 slots × 3 paginas) — mesmo
   disco classico, magica nova, sem `Data[]` de 300 `sITEM`.
3. **SQLite / outro motor** — isolamento, mas e um 12o caminho de
   persistencia. Fora de escopo agora.
4. **Voltar WH02 100 slots** — perderia a grade 20×15 que o jogador
   ja usa.

## Decisao

Opcao 2.

- Persistencia viva: `Data\DataServer\warehouse\<codigo>\<conta>.war`
  magica `WH03` (`WAREHOUSE_FILE_MAGIC_V3` = `0x33304857`).
- Fio continua `wVersion=3`, chunks de ocupados, mesmos transcodes.
- WH02 antigo: import uma vez, backup `.war.wh02`, regrava WH03.
- Primeira abertura sem arquivo: bau vazio, revision 1; primeiro save
  grava WH03.
- Anti-dupe no **commit em memoria** (overlap, Head+ChkSum, inventario).
  Sem unique SQL.
- Rollback do inventario no client **permanece** se o save falhar.
- ADR 0006 (hibrido UI) **permanece**. ADR 0008 fica **substituida**
  so na persistencia (SQL nao e fonte viva).

## Consequencias

- Nao precisa de `Create-Warehouse.sql` no SSMS para o bau funcionar.
- Tabelas `UserDB.Warehouse*` se existirem ficam orfas. Helpers SQL
  em `record.cpp` podem ainda estar no fonte (mortos); nao reativar.
- Backup do bau = copiar a pasta `Data\DataServer\warehouse\` (como
  o correio `PB02`).
- Dois PCs na mesma conta: o ultimo save de arquivo ganha. Nao ha
  `Revision` atomica no SQL.
- Planta: [[Armazem]]. Como funciona: [[Armazem-como-funciona]].
  Falhas: [[2026-09-18 - Armazem WH03 e falhas SQL]].
