---
tags: [processos, recap, sql, cliente, servidor]
status: feito-codigo
data: 2026-09-17
tela: Armazem
---

# Recap: Armazem SQL, 300 slots, 3 paginas jogaveis

> **Historico.** Persistencia SQL nao fechou no jogo. Save vivo em
> 2026-09-18: arquivo WH03 — [[2026-09-18 - Recap Armazem arquivo WH03]].
> A recap 2026-09-15 continua verdadeira para a **pintura**. Grade 300
> e fio v3 desta entrega **ficaram**.

## O que o jogador passa a ver (depois do SQL + F5)

- Grade maior (20 colunas × 15 linhas), celula proporcional a moldura.
- Continua **3 abas**. Nao ha quarta aba.
- Mesmo NPC, mesmo cromado, mesmo drag da pedra por baixo.

## O que era

Pedra, 100 `sITEM`, `.war`. Depois (15/09): ImGui + 3×100 WH02 +
`wVersion=2`, grade 9×9 apertada.

## O que mudou no codigo

- `sWAREHOUSE`: `Pages[5][300]`, `Weight` `int`, `WareHouseRevision`.
- Save/load SQL em `record.cpp`; import WH02 uma vez.
- Fio `WarehouseWire.h`; `ApplyLoadedChunk` no client.
- `SQLConnection` bind binario com tamanho.
- Sessao liberada no disconnect.

## Por que

Mais espaco sem transcode novo e sem 12º database. Compressao de 300
`sITEM` nao cabe em 8192 — por isso so ocupados. Anti-dupe e o eixo:
unique SQL + inventario + revision, nao so o checksum do arquivo.

## O que nao fizemos

- Reescrever drag ImGui.
- `WarehouseDB` no `openDatabase`.
- Liberar paginas 4–5 no cliente.
- Criar tabela no boot do `server.exe`.

## Como testar

Ver a planta [[Armazem]] (checklist no fim). Minimo: script SSMS,
client+server juntos, relogin, overlap, ouro, dois clientes.

## Ligacoes

ADR [[0008 - Armazem SQL, 300 slots, 5 paginas 3 liberadas]].
Planta [[Armazem]]. Banco [[Banco-de-Dados]]. Protocolo
[[Protocolo-de-Rede]].
