---
tags: [arquitetura, cliente, servidor, shared, sql]
status: ativo
data: 2026-09-17
---

# Armazem (NPC Warehouse)

Planta viva do bau. Recap da UI ImGui (2026-09-15):
[[2026-09-15 - Recap Armazem ImGui paginas e busca]]. Recap SQL/300
slots: [[2026-09-17 - Recap Armazem SQL 300 slots]]. ADR UI
[[0006 - Armazem ImGui, paginas no mesmo transcode]]. ADR persistencia
[[0008 - Armazem SQL, 300 slots, 5 paginas 3 liberadas]]. Spec antiga
(pedra): [[2026-09-13-armazem-paginas-busca]].

## Trajetoria (como era, o que tentamos, aonde estamos)

### Era (ate ~2026-09-14)

NPC `Warehouse` / `Blacksmith` / `MagicMaster`. Janela de **pedra**
(`shop-1.bmp`, `cWAREHOUSE` desenha e arrasta). Uma pagina de 100
`sITEM`. Persistencia: arquivo `.war` no DataServer (`rsLoadWareHouseData`
/ `rsSaveWareHouseData`). Pacote `smTRANSCODE_WAREHOUSE` (`0x48470047`):
blob comprimido de **toda** a pagina. Abrir: `OPEN_WAREHOUSE`
(`0x48470048`). Ouro no bau viaja na pagina 0. Peso era `short`.

Anti-dupe classico: `Head`/`ChkSum` contra inventario (`InvenItemInfo`)
e contra o proprio bau (`WareHouseItemInfo`).

### Tentamos (2026-09-15)

Migrar **so a pintura** para ImGui (`WarehouseWindow` + `frame.png` +
titulo kit B `armazem.png`). Logica e drag **ficam** em `cWAREHOUSE`.
Reescrever overlap no ImGui foi condenado na tabela de falhas daquela
sessao.

Paginas: 3 × 100 no mesmo transcode, `wVersion=2`, magica `WH02`.
`dwTemp[0]` = pagina. Ouro so na pagina 0. Busca por nome local.
Inventario ao lado continua pedra.

Isso funcionou, mas a grade **9×9 de 22 px** (~198 px) parecia um
carimbo dentro da moldura 760×540. Capacidade espacial real de 1×1 era
81 por pagina, nao 100.

### Tentamos e nao fizemos (2026-09-17, planejamento)

- So aumentar o pixel da celula: conforto, mesmos 100 slots.
- Grade 12×12 / 144 slots ainda no `.war` WH03: ainda estoura compressao
  se encher 300 `sITEM` no `Data[]`.
- Database `WarehouseDB` no boot: mais um nome obrigatorio, `exit(0)`.
- 5 paginas **jogaveis** de imediato: schema sim, jogo nao (anti-dupe e
  teste).

### Estamos (2026-09-17)

Hibrido UI **igual** a 0006. Persistencia **SQL no UserDB**. Grade
**20×15** (300 celulas 1×1). 5 paginas na RAM/schema, **3 abas** no
jogo. Pacote `wVersion=3`: so ocupados, chunks, commit. `.war` WH02
importa uma vez. Codigo na source; **tabelas ainda precisam do script
no SSMS**. Teste de jogo completo ainda e checklist humano.

## Constantes (`Shared/smPacket.h`)

| Simbolo | Valor | Papel |
|---|---|---|
| `WAREHOUSE_MAX_PAGES` | 5 | RAM + SQL |
| `WAREHOUSE_UNLOCKED_PAGES` | 3 | jogo agora |
| `WAREHOUSE_PAGE_SLOTS` | 300 | por pagina |
| `WAREHOUSE_GRID_COLS` | 20 | overlap |
| `WAREHOUSE_GRID_ROWS` | 15 | overlap |
| `WAREHOUSE_TOTAL_SLOTS` | 1500 | `WareHouseItemInfo` |
| `WAREHOUSE_PACKET_VERSION` | 3 | fio |
| `WAREHOUSE_WIRE_DATA_MAX` | 7800 | `TRANS_WAREHOUSE.Data` |
| `WAREHOUSE_DEFAULT_WEIGHT_MAX` | 8000 | teto |

`TRANS_WAREHOUSE_LEGACY` existe so para o binario antigo (100 `sITEM`).
Nao e o formato vivo.

## Dois mundos (nao misturar)

| Mundo | Classe | O que faz |
|---|---|---|
| Pintura | `WarehouseWindow` | Moldura 760×540, 3 abas, grade 20×15 **escalada** ao retangulo, busca, ouro |
| Logica | `cWAREHOUSE` (`sinTrade`) | `sWAREHOUSE`, overlap, peso `int`, ouro, `Pages[5][300]` |

Filtros PNG (armas, armaduras…) sao **so UI**. Nao mudam o SQL.

## Pacote (nenhum transcode novo)

Socket 8192. Nunca mandar `sizeof(sITEM)*300`.

```
NPC clique
  -> OPEN_WAREHOUSE (0x48470048)
  -> DataServer: SELECT Warehouse + WarehouseItem
  -> N chunks WAREHOUSE (0x48470047) por pagina, wVersion[0]=3
     dwTemp[0]=pagina  dwTemp[1]=chunk  dwTemp[2]=totalChunks
     dwTemp[3]=revision  dwTemp[4]=0
  -> chunk final da ultima pagina: dwTemp[4]=1 (sessao pronta)
  -> client: ApplyLoadedChunk; AllPagesReady quando as 3 chegaram

Fechar / salvar
  -> 3 paginas, cada uma em N chunks (so ocupados, EecodeCompress)
  -> ultimo chunk da pagina 2: dwTemp[4]=1
  -> servidor junta na sessao; so no commit valida overlap, Head+ChkSum,
     inventario, UnlockedPages, Revision; transacao SQL
```

`wVersion[0] != 3` no save = recusa. Pagina >= 3 = recusa + log.

Abrir o bau de novo: `rsWareHouseSessionFree` no reset/disconnect
(`OnSever.cpp`). Reenvio do chunk 0 de uma pagina **substitui** aquela
pagina na sessao (nao empilha duplicata).

Detalhe do fio: `Shared/WarehouseWire.h` (`sWAREHOUSE_WIRE_ITEM` =
`sITEMINFO` + x,y,w,h,Class,Slot). Sem ponteiro GPU no SQL.

## Persistencia SQL (`UserDB`)

Nao e o 12º database. Script:
`09-Guias/sql/Create-Warehouse.sql`.

| Tabela | Chave | Conteudo |
|---|---|---|
| `dbo.Warehouse` | `AccountID` | Money, WeightMax, UnlockedPages, Revision, ImportedFromWar |
| `dbo.WarehouseItem` | Account + Page + Slot | GridX/Y, ItemBlob (`sITEMINFO`), ItemCode, Head, ChkSum |

Unique filtrado: `(AccountID, Head, ChkSum) WHERE Head<>0 AND ChkSum<>0`.
Pocao/ouro (Head 0) ficam de fora do indice — o C++ ainda valida peso e
overlap.

Save atomico: DELETE itens da conta + INSERT da sessao + UPDATE cabecalho
com `Revision = @rev`. Depois SELECT; se nao for `@rev+1`, rollback
(buraco de 0 linhas).

Import `.war`: se `ImportedFromWar=0` e o arquivo WH02 existir, le e
grava SQL uma vez. Save do personagem **nao** reabre o `.war` em
`sWAREHOUSE` de 300 slots; usa `WareHouseItemInfo` + ouro.

`rsSaveWareHouseData` no `netplay` do servidor (compressao 300 `sITEM`)
fica **desligado** (`return FALSE`) para ninguem gravar o formato morto.

## Anti-dupe (eixo desta entrega)

1. Unique SQL na conta.
2. Choque Head+ChkSum com inventario na hora do commit → recusa, log,
   kick.
3. Unique na sessao (mesmo item em duas paginas).
4. Overlap 20×15 no servidor (`WarehouseWire_ValidateOverlap`).
5. `Revision` da sessao tem que bater com o SQL.
6. Paginas alem de `UnlockedPages` recusadas.

## UI

Celula **escala** para caber 20×15 no painel (nao 22 px fixos). Tres
abas. Paginas 4–5 existem em `cWAREHOUSE` e no SQL (`UnlockedPages` ate
5); o C++ de jogo nao mostra aba 4 e 5 ainda.

## O que o humano ainda faz

1. Colar o SQL no SSMS (`UserDB`).
2. Compilar **client + server**.
3. Checklist: bau vazio, import WH02, 300 na pagina, 3 abas, recusa
   pagina 4, overlap, ouro, relogin, dois clientes mesma conta,
   item do inventario vs bau.

## Arquivos

| Onde | Arquivo |
|---|---|
| Shared | `smPacket.h`, `WarehouseWire.h` |
| Client | `WarehouseWindow.cpp/.h`, `sinTrade.cpp/.h`, `netplay.cpp` |
| Server | `record.cpp`, `SQLConnection.cpp/.h`, `OnSever.cpp`, `netplay.cpp` |
| SQL | `docs/sql/Create-Warehouse.sql` (source) e esta pasta no vault |
