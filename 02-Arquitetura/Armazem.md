---
tags: [arquitetura, cliente, servidor, shared, ui]
status: ativo
data: 2026-09-15
---

# Arquitetura — Armazem (3 paginas)

Como o baú funciona **depois** da remodelagem de 2026-09-15. Recap do
jogador: [[2026-09-15 - Recap Armazem ImGui paginas e busca]]. ADR:
[[0006 - Armazem ImGui, paginas no mesmo transcode]]. Spec original:
[[2026-09-13-armazem-paginas-busca]] (status `feita`; a UI saiu da
pedra — ver ADR 0006).

Convencao de fluxograma para outras features grandes:
[[Como-documentar-funcionalidade]].

## Em uma frase

A janela e ImGui (`WarehouseWindow`). A logica de item, peso, ouro e
checksum continua em `cWAREHOUSE`. Cada pagina de 100 slots viaja num
pacote `smTRANSCODE_WAREHOUSE` (`0x48470047`) ja existente. O arquivo
`.war` guarda as 3 paginas. Inventario permanece HUD de pedra.

## Camadas (quem faz o que)

```mermaid
flowchart TB
  jogador[Jogador / NPC do bau]
  ui["WarehouseWindow<br/>ImGui: cromado, busca, abas 1/2/3, grade, ouro"]
  logic["cWAREHOUSE / sWAREHOUSE<br/>sinTrade.cpp — overlap, pickup, peso, checksum"]
  inv["Inventario de pedra<br/>sinInvenTory — nao migrou"]
  net["netplay.cpp<br/>SaveWareHouse / LoadWareHouse"]
  pkt["Shared/smPacket.h<br/>TRANS_WAREHOUSE + wVersion=2 + dwTemp pagina"]
  srv["record.cpp<br/>rsLoad / rsSaveWareHouseData"]
  disk["Data/DataServer/WareHouse/id.war"]

  jogador --> ui
  ui --> logic
  logic --> inv
  logic --> net
  net --> pkt
  pkt --> srv
  srv --> disk
```

Por que essa separacao: reescrever o drag 22 px em ImGui do zero duplica
item. O visual novo so pinta e traduz clique; quem mexe no `sITEM` e o
codigo legado que ja existia.

| Camada | Arquivo | Papel |
|---|---|---|
| Visual | `SrcGame/.../HUD/WarehouseWindow.cpp` | Cromado 15, busca, paginas, grade, modal de ouro, mouse |
| Logica | `SrcGame/.../sinbaram/sinTrade.cpp` (`cWAREHOUSE`) | 3 paginas na RAM, overlap, save, checksum |
| Rede client | `SrcGame/.../netplay.cpp` | Comprime 100 slots por pacote; `dwTemp[0]` = pagina |
| Contrato | `Shared/smPacket.h` | Mesmo transcode; constantes `WAREHOUSE_*`; `WareHouseItemInfo[300]` |
| Autoridade | `SrcServer/.../Character/record.cpp` | Le/grava `.war`; envia 3 pacotes; anti-dupe |
| Arte | `C:\Cliente Full\game\images\warehouse\armazem.png` | Titulo 400x64. Cromado nao e PNG |

Constantes (os dois lados, `smPacket.h`):

| Simbolo | Valor | Significado |
|---|---|---|
| `WAREHOUSE_PAGE_COUNT` | 3 | Paginas 0, 1, 2 (botoes 1 / 2 / 3 na UI) |
| `WAREHOUSE_PAGE_SLOTS` | 100 | Slots por pagina — igual ao legado |
| `WAREHOUSE_TOTAL_SLOTS` | 300 | Teto na RAM e em `WareHouseItemInfo` |
| `WAREHOUSE_PACKET_VERSION` | 2 | `wVersion[0]` do pacote novo |
| `WAREHOUSE_FILE_MAGIC` | `0x32304857` | Bytes `WH02` no inicio do `.war` |

Ouro e peso moram so na pagina 0. Paginas 1 e 2 zeram `WareHouseMoney` /
`UserMoney` no fio para nao duplicar gold.

## Abrir o bau

```mermaid
sequenceDiagram
  participant NPC
  participant Client as Cliente
  participant WH as cWAREHOUSE
  participant UI as WarehouseWindow
  participant DS as DataServer
  participant Disk as arquivo .war

  NPC->>Client: smTRANSCODE_OPEN_WAREHOUSE 0x48470048
  Client->>UI: ArmHideClassic (esconde pedra shop-1.bmp)
  Client->>DS: encaminha o pedido
  DS->>Disk: ReadWareHouseFilePages
  Note over DS,Disk: Magica WH02 = 3 paginas<br/>Sem magica = .war antigo, 1 pagina
  DS->>Client: 3x smTRANSCODE_WAREHOUSE 0x48470047
  Note over DS,Client: dwTemp[0] = 0, 1, 2<br/>wVersion[0] = 2
  Client->>WH: pagina 0: BeginLoad + ApplyLoadedPage(0)
  Client->>WH: paginas 1 e 2: ApplyLoadedPage
  WH->>WH: TryFinishOpen quando AllPagesReady
  WH->>UI: OpenFlag = 1, desenha ImGui
```

Se o pacote chegar sem versao 2 (cliente/servidor velho): a pagina 0
abre e `FillEmptyRemainingPages` zera 1 e 2. `.war` antigo nao corrompe.

Enquanto `IsLoadingPages()`, a pedra classica continua escondida
(`ShouldHideClassicPanels`). Sem isso o `shop-1.bmp` (compartilhado com
loja NPC / aging) aparece por um frame.

## Fechar e gravar

```mermaid
sequenceDiagram
  participant UI as WarehouseWindow
  participant WH as cWAREHOUSE
  participant Net as SaveWareHousePage
  participant DS as rsSaveWareHouseData
  participant Disk as id.war

  UI->>WH: X / ESC / RequestClose
  WH->>WH: CloseWareHouse -> SaveAllPages
  loop pagina 0, 1, 2
    WH->>Net: comprime sWAREHOUSE daquela pagina
    Net->>DS: smTRANSCODE_WAREHOUSE wVersion=2 dwTemp=pagina
    DS->>Disk: le .war, troca so aquela pagina, grava .tmp atomico
  end
  Note over Net: Depois da ultima pagina, SaveGameData
```

Nao cabe um blob de 300 `sITEM` no socket (`smSOCKBUFF_SIZE` = 8192).
Por isso **nao** inchamos `TRANS_WAREHOUSE.Data`. Cada pacote continua
com `Data[sizeof(sITEM)*100+256]`. Tres viagens, mesmo transcode.

O servidor **nao substitui o arquivo inteiro** com a primeira pagina:
lê as 3, aplica a que chegou, escreve de novo. Sem isso, mudar da
pagina 2 apagaria a 1.

## Memoria vs fio vs disco

```mermaid
flowchart LR
  ram["RAM do client<br/>Pages[3][100]<br/>sWAREHOUSE mostra a pagina atual"]
  wire["Rede<br/>1 pacote = 1 pagina comprimida<br/>TRANS_WAREHOUSE"]
  file["Disco<br/>magic WH02 + nPages<br/>+ size + pacote, tres vezes"]

  ram -- "SaveAllPages" --> wire
  wire -- "rsSave mergeia" --> file
  file -- "rsLoad envia 3" --> wire
  wire -- "BeginLoad / ApplyLoadedPage" --> ram
```

Formato do `.war` novo:

```
DWORD magic     = 0x32304857   // "WH02"
int   nPages    = 3
para cada pagina:
    int  pktSize
    bytes do TRANS_WAREHOUSE (pktSize)
```

`.war` legado: um `TRANS_WAREHOUSE` cru, sem magica. O leitor
(`ReadWareHouseFilePages`) detecta, trata como 1 pagina, e o save
seguinte ja grava WH02 com paginas 2 e 3 vazias.

Checksum de item / ouro XOR (`dwChkSum`, `WareHouseMoney ^ chkSum`)
nao mudou de regra. Ouro so viaja na pagina 0.

Anti-dupe no servidor: `rsPLAYINFO.WareHouseItemInfo` passou de **120**
para **300** (`Shared/smPacket.h`). Loops em `OnSever.cpp` usam
`WAREHOUSE_TOTAL_SLOTS`, nao mais `100`.

## UI (o que o jogador clica)

```mermaid
flowchart TB
  chrome["Cromado ImDrawList<br/>DrawPlayerWindowChrome"]
  title["Titulo PNG 400x64<br/>game/images/warehouse/armazem.png"]
  search["Busca por nome<br/>filtro local, case-insensitive"]
  pages["Botoes 1 / 2 / 3<br/>SwitchPage"]
  grid["Grade 9x9 celulas<br/>icone BMP do item"]
  side["Peso, ouro, depositar / retirar"]
  gold["Modal de ouro<br/>mesmo cromado"]

  chrome --> title
  chrome --> search
  chrome --> pages
  chrome --> grid
  chrome --> side
  side --> gold
  search -->|"achou noutra pagina"| pages
```

- Busca **nao** apaga item: `ItemMatchesSearch` so esconde na grade.
  Se o nome esta noutra pagina, `FindSearchPage` troca sozinho.
- Clique na janela nao anda o personagem: `IsBlockingMouse` em
  `GameCore` / `Winmain` (mesmo padrao de Desafios).
- Campo de busca come teclado: `ShouldCaptureKeyboard` (senao o chat
  ou atalhos do `sinProc` roubam a letra).
- ImGui desenha **depois** do HUD de pedra (`sinDraw` em `sinMain.cpp`).
  Se renderizar antes (como estava em `sinCharStatus`), o BMP
  `CraftItemMain` cobre o bau.

Inventario ao lado continua pedra. Drag bau <-> bag usa as funcoes
antigas (`PickUpWareHouseItem`, `LastSetWareHouseItem`) com coordenada
logica convertida da grade ImGui.

## Pacotes (nenhum transcode novo)

| Codigo | Valor | Uso agora |
|---|---|---|
| `smTRANSCODE_OPEN_WAREHOUSE` | `0x48470048` | NPC pede para abrir. Client encaminha ao DataServer. |
| `smTRANSCODE_WAREHOUSE` | `0x48470047` | Ida e volta dos itens. `wVersion[0]=2`, `dwTemp[0]=pagina`. |

Caravana **nao** entrou neste desenho (`TRANS_CARAVAN` segue 100 slots).

## O que testar (arquitetura)

1. Personagem com `.war` antigo (100 slots) — abre, paginas 2 e 3 vazias, nao some ouro.
2. Depositar na pagina 2, fechar, relogar — item ainda na 2.
3. Busca com item na pagina 3 — a UI salta para essa pagina; limpar volta o filtro, nao apaga o item.
4. Inventario de pedra ao lado — drag nos dois sentidos.
5. Abrir mix/aging/loja NPC com o bau fechado — `shop-1.bmp` ainda aparece (compartilhado).
6. Peso acima do limite — `OPEN_WAREHOUSE` recusa como antes.

## Ver tambem

- Recap: [[2026-09-15 - Recap Armazem ImGui paginas e busca]]
- Sessao: [[2026-09-15 - Armazem ImGui paginas e save]]
- Protocolo geral: [[Protocolo-de-Rede]]
- Planta: [[Arquitetura]]
- Titulo PNG: [[Inventario-de-Artes]]
