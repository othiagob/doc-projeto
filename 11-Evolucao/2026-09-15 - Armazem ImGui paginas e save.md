---
tags: [evolucao]
status: feita
data: 2026-09-15
---

# 2026-09-15 - Armazem ImGui paginas e save

## Resumo em 30 segundos

O bau saiu da pedra (contra a ADR 0005) e entrou no cromado ImGui, com
busca e 3 paginas. A logica `cWAREHOUSE` ficou. Rede: mesmo transcode,
uma pagina por pacote, `.war` com magica `WH02`. Inventario nao migrou.
Planta: [[Armazem]].

## Linha do tempo

- 2026-09-13: ADR 0005 + spec rascunho (pedra, busca, textura, paginas
  por ultimo).
- Implementacao: UI ImGui + paginas no fio + save novo, na mesma
  fatia (nao so textura).
- 2026-09-15: ritual do livro, fluxogramas, ADR 0006.

## O que mudou (por area)

### Cliente

`WarehouseWindow` (cromado 15, busca, abas, grade, ouro). `cWAREHOUSE`
ganhou `Pages[3][100]`, `SwitchPage`, `SaveAllPages`, filtro de nome.
Pedra classica escondida enquanto o bau esta aberto. ImGui render no
`sinDraw`.

### Servidor

`record.cpp`: ler/gravar WH02, merge por pagina, enviar 3 pacotes no
open. `WareHouseItemInfo` 300. Loops `WAREHOUSE_TOTAL_SLOTS`.

### Shared / protocolo

- Tocou em `Shared/`? **sim** (`smPacket.h`)
- `smTRANSCODE_*` novos: **nenhum**
- Reuso: `0x48470047` (dados), `0x48470048` (abrir)

### Banco

Nenhum. Save e arquivo `.war`, nao SQL.

### Documentacao e regras Cursor

ADR 0006. Recap 10-Processos. Spec `feita`. Roadmap armazem = feito.
Regra 15 ganha path do titulo. Convencao de fluxograma:
[[Como-documentar-funcionalidade]].

## Acertos (manter)

- Nao inflar `TRANS_WAREHOUSE` para 300.
- Magica no arquivo + leitor legado.
- Ouro so na pagina 0.
- Titulo PNG; cromado no `ImDrawList`.

## Falhas e experimentos revertidos (nao repetir)

| Tentativa | Por que quebrou | O que ficou |
|---|---|---|
| Desenhar o bau com o `ImGui::Render` do status (`sinCharStatus`) | `CraftItemMain.bmp` cobria a janela | Render no fim de `sinDraw` |
| Deixar o painel de pedra visivel | `shop-1.bmp` e da loja/aging tambem | `ShouldHideClassicPanels` |
| Um pacote com 300 slots | Estoura `smSOCKBUFF_SIZE` 8192 | 3 pacotes de 100 |

Nao voltar a 9-slice de janela (tabela de falhas 2026-09-08).

## Decisoes importantes

[[0006 - Armazem ImGui, paginas no mesmo transcode]] substitui o
"armazem fica pedra" da [[0005 - Distribuidor ImGui, armazem e inventario em pedra, artes no Cliente Full]].
Inventario e distribuidor na 0005 seguem.

## Arquivos e assets

Ver lista no recap [[2026-09-15 - Recap Armazem ImGui paginas e busca]].
PNG: `C:\Cliente Full\game\images\warehouse\armazem.png`.

## O que testar

O plano do recap (6 itens). Arquitetura: o bloco "O que testar" em
[[Armazem]].

## O que ainda confunde / proximo bloco

Caravana ainda e 100 slots / arquivo proprio. Organizar inventario e
correio 168h nao comecaram.
