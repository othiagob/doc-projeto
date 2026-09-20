---
tags: [processos, recap, cliente, servidor]
status: feito
data: 2026-09-18
tela: Armazem
---

# Recap: Armazem grava de novo em arquivo WH03

> Testado no jogo (2026-09-18): depositar item, fechar, reabrir —
> o item ficou. A recap 2026-09-15 continua verdadeira para a
> **pintura**. A recap 2026-09-17 descreve a **tentativa SQL** (codigo
> que nao fechou). Esta nota e o save que vale.

## O que o jogador ve

- Mesma janela ImGui, 3 abas, grade grande, drag da pedra por baixo.
- Fechar o bau **guarda** o item. Se o save falhar: o item volta e
  aparece "Falha ao salvar o armazem." (nao mais "Muitos Itens").

## O que era

Depois de 15/09 o save vivo era `.war` WH02 (100 por pagina) e
funcionava. Em 17/09 o codigo passou a SQL (ADR 0008); no jogo o
save **nao** fechava.

## O que mudou no codigo

- `record.cpp`: `WareHouseFileWrite` / load WH03; commit (funcao ainda
  chamada `WareHouseSqlCommit`) grava arquivo, nao `UserDB`.
- Magica `WAREHOUSE_FILE_MAGIC_V3` em `WarehouseWire.h`.
- WH02: copia `.wh02` e regrava WH03 na primeira abertura.
- Client: `OnSaveResult` / close com mensagem honesta + `RestoreInvenItem`.

## Por que

SQL neste ODBC gastou dias sem um anel persistir. Arquivo e o caminho
que ja tinha funcionado em 15/09, agora com a grade 300 e o fio v3.

## O que nao fizemos

- Reescrever drag ImGui.
- Apagar as tabelas SQL se existirem no SSMS (orfas).
- Limpar todos os helpers SQL mortos em `record.cpp` (deixados).
- Liberar paginas 4–5.

## Como testar

1. Compilar **server.exe** (e Game.exe se a mensagem ainda for a antiga).
2. 1 anel, fecha, reabre.
3. Log: `Warehouse FILE commit OK` / `Warehouse FILE load`.
4. Arquivo em `Data\DataServer\warehouse\<n>\<conta>.war`.

Planta: [[Armazem]]. Processo completo: [[Armazem-como-funciona]].
ADR [[0009 - Armazem arquivo WH03, SQL revertido]].
Falhas: [[2026-09-18 - Armazem WH03 e falhas SQL]].

## Shared / protocolo

- Tocou `Shared/WarehouseWire.h` (magica WH03 + RESULT).
- Transcodes: nenhum novo. `0x48470047` / `0x48470048`.
