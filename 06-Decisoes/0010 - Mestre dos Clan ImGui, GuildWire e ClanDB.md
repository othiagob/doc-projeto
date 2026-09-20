---
tags: [decisao, imgui, cliente, servidor, shared, sql]
status: aceita
data: 2026-09-19
---

# 0010 - Mestre dos Clan ImGui, GuildWire e ClanDB

## Contexto

Precisavamos de UI Fallen Tale para guilda e de autoridade no
servidor, sem reabrir o menu TJBOY nem HTTP de cla.

## Opcoes consideradas

1. **So client, menu legado** — rapido, sem busca SQL nova, UI morta.
2. **Arquivo por cla** (estilo WH03) — ruim para busca e roster
   compartilhado.
3. **ImGui kit B + `GuildService` + `ClanDB` + `GuildWire.h`** —
   mesmo desenho do Distribuidor: UI nova, fio explicito, SQL no
   banco que o boot ja abre.

## Decisao

Opcao 3. Transcodes `0x48478A20`–`23`. Nao reusar `ITEM_EXPRESS` nem
o blob do bau. Titulo kit B 320×26. Script SQL manual.

## Consequencias

- Toda mudanca de cargo/membro passa pelo server.
- Schema legado `CL`/`UL` precisa de DEFAULT (script), nao DROP.
- Gate de NPC (`dwGuildNpcTime`) tem de ser gravado no talk; senão
  a janela mente.
- Inventario continua pedra. Clan nao vira 9-slice.
