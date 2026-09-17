---
tags: [specs, cliente, servidor, shared, ui]
status: feita
data: 2026-09-13
implementado: 2026-09-15
---

# Spec: Armazem — paginas, textura e busca

> **Feita (2026-09-15).** A UI saiu da pedra: janela ImGui
> (`WarehouseWindow`) + logica `cWAREHOUSE`. 3 paginas no mesmo
> transcode. Recap: [[2026-09-15 - Recap Armazem ImGui paginas e busca]].
> Planta: [[Armazem]]. ADR UI: [[0006 - Armazem ImGui, paginas no mesmo transcode]].
> Persistencia SQL (300 slots): ADR [[0008 - Armazem SQL, 300 slots, 5 paginas 3 liberadas]],
> recap [[2026-09-17 - Recap Armazem SQL 300 slots]].
> O texto abaixo e o plano original (pedra) — nao reescreva; o "como
> ficou" esta na planta.

## Contexto

O armazem e a janela classica de pedra: um painel, **100 slots**, grade
9x9 de 22px, arte `Image\SinImage\Shopall\shop-1.bmp` + titulo
`Warehouse.bmp`. Classe `cWAREHOUSE` em `sinTrade.h` / `sinTrade.cpp`.
Pacotes `smTRANSCODE_WAREHOUSE` (`0x48470047`) e
`smTRANSCODE_OPEN_WAREHOUSE` (`0x48470048`). Save
`Data\DataServer\WareHouse\<code>\<id>.war`. Nao ha paginas nem busca.

Pedido: **continuar na pedra** (nao ImGui). Mais paginas, textura/titulo
melhores, pesquisa por nome. ADR:
[[0005 - Distribuidor ImGui, armazem e inventario em pedra, artes no Cliente Full]].

## Escopo

- Manter `cWareHouse` e o fluxo de drag entre inventario e armazem.
- **Busca por nome:** filtro no client sobre os itens ja carregados
  (esconder os que nao batem; case-insensitive, nome parcial). Nao
  precisa de pacote novo se a pagina atual ja esta na memoria.
- **Textura:** novos BMP/TGA no **mesmo caminho** que o codigo ja
  carrega (`Shopall\shop-1.bmp`, `Warehouse.bmp`, ou arquivos novos
  **se** o C++ for apontado para eles — preferir mesmo nome para nao
  espalhar path). Arte no Cliente Full.
- **Paginas:** proposta **3 paginas x 100 slots = 300**. Numero pode
  mudar antes de implementar. UI: abas ou setas na propria janela de
  pedra.
- Peso/ouro do armazem: nao redesenhar a regra; so garantir que paginas
  extras nao quebrem `Money` / `Weight` / checksum.

Implementar em fatias se o risco assustar: (1) textura, (2) busca,
(3) paginas por ultimo.

## Fora de escopo

- Migrar para ImGui
- Botao organizar do inventario (spec propria)
- Distribuidor / correio
- Armazem de clan / caravana
- Busca no servidor (query SQL)

## Impacto em Shared / protocolo

- Toca em `Shared/`? **paginas: sim** (tamanho do blob). **busca e
  textura: nao**.
- `sWAREHOUSE` tem `WareHouseItem[100]`. `TRANS_WAREHOUSE` usa
  `Data[sizeof(sITEM)*100+256]`. Client `SaveWareHouse` /
  `LoadWareHouse` em `netplay.cpp`; `Version_WareHouse` ja existe.
- Preferencia: **nao inventar transcode**. Estender o blob e subir
  `wVersion` para o server aceitar 100 (legado) e 300 (novo). Client e
  server **juntos**. Arquivos `.war` antigos devem abrir na pagina 1
  e paginas 2–3 vazias.
- Se 300 itens comprimidos passarem de 8192, precisa de chunks ou
  enviar pagina a pagina — medir na implementacao, nao chutar.

## Modulos afetados

- [ ] SrcGame: `sinTrade.cpp` / `sinTrade.h` (draw, input, grid,
      campo de busca); `netplay.cpp` (save/load); arte no Cliente Full
- [ ] SrcServer: load/save `.war` (`record.cpp`, handlers em
      `OnSever.cpp` ~22873+)
- [ ] Shared: so se `TRANS_WAREHOUSE` / struct compartilhada viver em
      `smPacket.h` (hoje o array 100 esta no client `sinTrade.h` e o
      wire em `smPacket.h`)

## Comportamento esperado

**Antes:** um painel cheio, sem achar item pelo nome, visual velho,
teto 100.

**Depois:** mesmo jeito de arrastar itens; da para filtrar pelo nome;
visual mais limpo na mesma familia de pedra; mais espaco em paginas.
Busca nao apaga item — so esconde na grade.

## Plano de teste manual

1. Depositar e retirar item (regressao do fluxo atual).
2. Digitar nome parcial — so os que batem visiveis; limpar busca —
   volta tudo da pagina.
3. Item na pagina 2 nao some ao mudar para pagina 1 e voltar.
4. Relogar — `.war` com 3 paginas carrega igual.
5. Personagem com `.war` antigo (100 slots) — entra, nao corrompe,
   paginas novas vazias.
6. Ouro do armazem igual ao antes (checksum).
7. Inventario + trade + caravana fechados quando o armazem abre
   (exclusividade ja existente).

## Riscos conhecidos

- Estourar `smSOCKBUFF_SIZE` com 300 `sITEM`.
- Checksum / `dwLastWareHouseChkSum` / money XOR — facilmente duplica
  ouro se o save novo for interpretado como velho.
- Grade 9x9 vs 100 slots: a UI ja e apertada; paginas sao melhores que
  densificar a grade.
- Trocar so a textura com tamanho diferente do BMP antigo pode
  deslocar a hitbox dos slots — manter dimensoes ou ajustar as
  constantes de area (`SetWareHouseItemAreaCheck`, +22*9).
