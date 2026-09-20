---
tags: [specs]
status: em andamento
data: 2026-09-19
---

# Spec: Mestre dos Clan (ImGui + ClanDB)

Copia de trabalho no vault. Kit do agente (mesma spec):
`C:\Source Priston\Source Priston\ANTIGRAVITY AGENT\SPECS\2026-09-19-mestre-dos-clan.md`.

Planta: [[Clan]]. Recap: [[2026-09-19 - Recap Mestre dos Clan ImGui]].
ADR: [[0010 - Mestre dos Clan ImGui, GuildWire e ClanDB]].

## Contexto

Janela de guilda no cromado 15, autoridade SQL em `ClanDB`.

## Escopo

`ClanWindow`, `GuildService`, `GuildWire.h`, transcodes
`GUILD_OPEN/SNAPSHOT/SEARCH/ACTION`, script `Create-ClanGuild.sql`,
PNG kit B em `game/images/clan/`.

## Fora de escopo

Inventario ImGui, marca 3D, siege, reescrever TJBOY.

## Impacto Shared / protocolo

Sim. `GuildWire.h` + `smPacket.h`. Client e server juntos.
Nao reutilizar valores de postbox (`0x48478A81`–`85`).

## Comportamento esperado

Ver recap e planta. Criar exige nv 40 e 500000 gold. Max 40 membros.

## Plano de teste manual

Ver recap. Inclui o caso `GUILD_ERR_NPC` se o stamp do NPC faltar.

## Riscos

Stamp `dwGuildNpcTime`; colunas NOT NULL antigas em `CL`/`UL`.
