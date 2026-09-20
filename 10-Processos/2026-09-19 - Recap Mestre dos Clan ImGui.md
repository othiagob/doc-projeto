---
tags: [processos]
status: parcial
data: 2026-09-19
modulo: cliente, servidor, shared, docs
---

# 2026-09-19 - Recap Mestre dos Clan ImGui

Planta: [[Clan]]. Spec: [[2026-09-19-mestre-dos-clan]].
ADR: [[0010 - Mestre dos Clan ImGui, GuildWire e ClanDB]].

## Como era

Menu de cla legado (TJBOY / `OPEN_CLANMENU`). Sem janela kit B e sem
servico SQL unico no `GuildService`.

## O que o jogador ve agora

**No codigo (teste no jogo ainda pendente):** janela ImGui 760×540
titulo `mestre-dos-clan.png`, busca de clans, fundar, roster,
candidaturas, motd, auditoria, cargos. Sem PNG: texto dourado.

## O que implementei (e por que)

Hibrido igual armazem/distribuidor: UI nova, autoridade no server.
Fio em `Shared/GuildWire.h` para nao inflar `smPacket.h`. Transcodes
novos `0x48478A20`–`23` (grep mostrou faixa livre depois de
`CLANMONEY`). Persistencia `ClanDB` porque o boot ja exige esse banco.

Por que SQL aqui e nao arquivo: cla e compartilhado entre personagens
e precisa de busca. O bau e por conta e ja tinha `.war` estavel.

## Arquivos tocados

- `SrcGame/src/Game/HUD/ClanWindow.cpp` / `.h`
- `SrcGame/src/Game/netplay.cpp` (OPEN + SNAPSHOT + envio)
- `SrcServer/src/Server/Clan/GuildService.cpp` / `.h`
- `SrcServer/src/Server/SrcServer/OnSever.cpp` (cases)
- `Shared/GuildWire.h`, `Shared/smPacket.h`, `Shared.vcxitems`
- `docs/sql/Create-ClanGuild.sql`
- artes `game/images/clan/`

## Shared / protocolo

- Tocou em `Shared/`: sim
- `smTRANSCODE_GUILD_OPEN` `0x48478A20`
- `smTRANSCODE_GUILD_SNAPSHOT` `0x48478A21`
- `smTRANSCODE_GUILD_SEARCH` `0x48478A22`
- `smTRANSCODE_GUILD_ACTION` `0x48478A23`
- Reusa `smTRANSCODE_OPEN_CLANMENU` `0x48478A00`

## O que testar

1. Script SQL no `ClanDB`.
2. Abrir a janela pelo NPC.
3. Criar cla nv 40 + gold; relogar.
4. Apply / accept / kick / leave.
5. Se tudo vier "NPC": stamp `dwGuildNpcTime` — ver planta.

## O que ficou de fora

Marca 3D, siege, teste em runtime nesta sessao de docs.

## Aprendizado

Pacote de lista = chunks. NPC gate precisa de timestamp gravado no
mesmo instante em que o server autoriza a janela — senao a UI abre
e a acao morre.
