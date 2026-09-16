---
tags: [processos, servidor, loja, banco, feature]
status: feito
data: 2026-09-08
modulo: servidor
---

# 2026-09-08 - Recap loja SQL e painel Server

Relato completo: [[2026-09-08 - HUD ImGui lojas ranking mix e painel do servidor]].
ADRs: [[0003 - Catalogo SQL vs icone BMP no client]],
[[0002 - Duas identidades visuais jogador vs ferramenta]].
Regra: `.cursor/rules/40-database.mdc`, `16-desktop-tools.mdc`.

## Como era

A loja misturava nome de coluna SQL (`Discount` vs `DiscountPercent`) e
as vezes se tentava "consertar" icone mudando `ItemCode`. Lista grande
podia nao caber no socket (8192). Falha de SQL nao dizia **qual** banco.
`PainelDB` parecia dispensavel. `Server.exe` era sobretudo console.

## O que o jogador / operador ve agora

Jogador: loja com lista completa (chunks), desconto do SQL, icone BMP ou
`NO IMAGE` sem compra. Operador: painel claro no `Server.exe` (status,
players, eventos, arquivos, log, acoes); X minimiza; DirectX opcional.

## O que implementei (e por que)

- SELECT `DiscountPercent`; chunks `0x252031`. Por que: schema real e
  limite do socket.
- Log com nome do banco; `EnsurePainelDatabase`. Por que: boot falhava
  opaco; bans GM precisam de `Banneds`.
- `ToolTheme` + `ServerPanel`. Por que: ferramenta desktop nao e HUD de
  ouro.

## Arquivos tocados

- `SrcServer/src/Server/Shop/NewShop.cpp`, `NewShop.h`
- `SrcServer/src/Server/Database/SQLConnection.cpp`
- `SrcServer/src/Server/HUD/*`, `Winmain.cpp`, `OnSever.cpp`,
  `server.vcxproj`
- `SrcServer/src/Server/Quest/Quest.cpp` (encoding de Alert)
- `09-Guias/sql/Create-PainelDB.sql` (este vault)

## Shared / protocolo

- Tocou em `Shared/`? nao
- `NewShopItems_ReceiveItems` (`0x252031`) — mesmo codigo, payload em
  chunks. Client e server `NewShop.h` alinhados (`7800`, `chunkIndex`,
  `totalChunks`).

## O que testar

1. Loja com catálogo grande — todos os itens aparecem.
2. Compra — item do `ItemCode`.
3. Boot sem PainelDB — cria e sobe.
4. Painel — minimizar, confirmacao de shutdown, log.

## O que ficou de fora

Mapeamento de todas as tabelas. `AdminChrome.h` foi apagado em 2026-09-16
(recap [[2026-09-16 - Recap painel Server.exe splash e Segoe]]).

## Aprendizado

Struct de pacote e tamanho de buffer sao o contrato. Coluna SQL e nome
de campo C++ podem ser diferentes (`DiscountPercent` / `Discount`).
