---
tags: [arquitetura, cliente, servidor, shared]
status: ativo
data: 2026-09-18
---

# Armazem (NPC Warehouse)

Planta viva do bau. **Como funciona (fluxogramas):**
[[Armazem-como-funciona]].

Recap UI: [[2026-09-15 - Recap Armazem ImGui paginas e busca]].
Recap SQL (tentativa, nao e o save vivo):
[[2026-09-17 - Recap Armazem SQL 300 slots]].
Recap arquivo atual: [[2026-09-18 - Recap Armazem arquivo WH03]].
ADR UI: [[0006 - Armazem ImGui, paginas no mesmo transcode]].
ADR persistencia viva: [[0009 - Armazem arquivo WH03, SQL revertido]].
ADR SQL (substituida): [[0008 - Armazem SQL, 300 slots, 5 paginas 3 liberadas]].
Falhas: [[2026-09-18 - Armazem WH03 e falhas SQL]].
Spec antiga (pedra): [[2026-09-13-armazem-paginas-busca]].

## Uma frase

ImGui pinta a janela; `cWAREHOUSE` arrasta; o servidor grava
`Data\DataServer\warehouse\<n>\<conta>.war` (magica WH03). UserDB
**nao** e a fonte do bau.

## Trajetoria

### Era (ate ~2026-09-14)

NPC `Warehouse` / `Blacksmith` / `MagicMaster`. Janela de **pedra**
(`shop-1.bmp`). Uma pagina de 100 `sITEM`. Arquivo `.war`. Pacote
`smTRANSCODE_WAREHOUSE` (`0x48470047`) com blob da pagina inteira.
Abrir: `OPEN_WAREHOUSE` (`0x48470048`).

### Tentamos e funcionou (2026-09-15)

So a pintura foi para ImGui (`WarehouseWindow` + `frame.png` + titulo
kit B `armazem.png`). Drag ficou em `cWAREHOUSE`. 3 paginas WH02,
`wVersion=2`. **Save em arquivo funcionava.** Grade visivel 9×9 de
22 px parecia pequena na moldura 760×540.

Reescrever overlap no ImGui foi **condenado** (tabela de falhas 15/09).

### Tentamos e nao fizemos (planejamento 17/09)

- So aumentar o pixel da celula.
- 300 `sITEM` no `Data[]` (estoura 8192).
- Database `WarehouseDB` no boot.
- 5 abas jogaveis no dia 1.

### Tentamos e falhou no jogo (2026-09-17 a 18)

Persistencia SQL `UserDB.Warehouse` / `WarehouseItem` (ADR 0008).
Grade 20×15 e fio `wVersion=3` **entraram**. O save SQL **nao**.
Sintoma: 1 anel, fecha, item volta. Varias correcoes ODBC nao
fecharam. Nao repetir sem ADR nova — ver evolucao 18/09.

### Estamos (2026-09-18, testado)

Hibrido UI 0006. Grade 20×15, 3 abas, fio v3 ocupados. Persistencia
**arquivo WH03**. WH02 importa uma vez (backup `.wh02`).

```mermaid
flowchart LR
  ui[ImGui WarehouseWindow]
  logic[cWAREHOUSE]
  wire[0x48470047 v3 chunks]
  file[.war WH03]

  ui --> logic
  logic --> wire
  wire --> file
```

## Constantes (`Shared/smPacket.h`)

| Simbolo | Valor | Papel |
|---|---|---|
| `WAREHOUSE_MAX_PAGES` | 5 | RAM |
| `WAREHOUSE_UNLOCKED_PAGES` | 3 | jogo agora |
| `WAREHOUSE_PAGE_SLOTS` | 300 | por pagina |
| `WAREHOUSE_GRID_COLS` | 20 | overlap |
| `WAREHOUSE_GRID_ROWS` | 15 | overlap |
| `WAREHOUSE_TOTAL_SLOTS` | 1500 | `WareHouseItemInfo` |
| `WAREHOUSE_PACKET_VERSION` | 3 | fio |
| `WAREHOUSE_WIRE_DATA_MAX` | 7800 | `TRANS_WAREHOUSE.Data` |
| `WAREHOUSE_DEFAULT_WEIGHT_MAX` | 8000 | teto |
| `WAREHOUSE_FILE_MAGIC_V3` | `0x33304857` | disco WH03 |

`TRANS_WAREHOUSE_LEGACY` so para binario antigo (100 `sITEM`).

## Persistencia (arquivo)

Path: `Data\DataServer\warehouse\<GetUserCode>\<conta>.war`.

Header WH03: magica, revision, money, weightMax, unlocked, count,
depois `sWAREHOUSE_SAVE_ITEM[]`. Write via `.tmp` + `MoveFileEx`.

`Create-Warehouse.sql` e **legado**. Tabelas no SSMS, se existirem,
nao sao lidas pelo `server.exe`.

## Pacote (nenhum transcode novo)

Socket 8192. Nunca mandar `sizeof(sITEM)*300`. Detalhe e mermaid
de abrir/fechar: [[Armazem-como-funciona]].

`wVersion[0] != 3` no save = recusa. Pagina >= 3 = recusa.

## Anti-dupe

Overlap 20×15, Head+ChkSum na sessao, choque com inventario, paginas
alem de `UnlockedPages`. Sem unique SQL.

## UI

Celula escala para 20×15 no painel. Tres abas. Paginas 4–5 na RAM,
sem aba.

## O que o humano faz

1. Compilar **server.exe** (+ Game.exe se a mensagem de falha for antiga).
2. Checklist: 1 item persiste; log `FILE commit OK`; arquivo `.war`;
   falha de disco restaura inventario; WH02 antigo importa.

## Arquivos

| Onde | Arquivo |
|---|---|
| Shared | `smPacket.h`, `WarehouseWire.h` |
| Client | `WarehouseWindow.cpp/.h`, `sinTrade.cpp/.h`, `netplay.cpp` |
| Server | `record.cpp`, `OnSever.cpp` |
| SQL legado | `docs/sql/Create-Warehouse.sql` |
