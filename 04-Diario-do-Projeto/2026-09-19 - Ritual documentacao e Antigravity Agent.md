---
tags: [diario]
status: ativo
data: 2026-09-19
---

# 2026-09-19 - Ritual vault, kit Antigravity, clan e intro no livro

Pedido: atualizar documentacao, fluxogramas, pasta **ANTIGRAVITY AGENT**
na source (spec-driven para IA escrever codigo), commit e push.

## O que o livro passou a ter

- Plantas mermaid em Arquitetura, Protocolo, Banco, SDD, processo,
  mapa, tres diretorios, UI.
- Plantas novas: [[Clan]], [[Login-e-intro]].
- Recap e spec do Mestre dos Clan (codigo na source, teste no jogo
  pendente). ADR 0010.
- Kit `ANTIGRAVITY AGENT/` no repo `Source-Priston` — onboarding de
  agente (Antigravity incluso) sem substituir este vault.

## Codigo que o ritual encontrou (ainda nao era o foco do ritual)

Clan ImGui + `GuildService` + `GuildWire.h` + SQL `Create-ClanGuild.sql`.
IntroSplash. `frame.png` kit B em varias pastas de janela.

Nao compilei nem joguei nesta sessao. Stamp `dwGuildNpcTime` parece
nao ser gravado — anotado na planta [[Clan]].

## Vault precisa disto?

Sim — era o pedido. Source tambem (pasta do agente + este alinhamento
nas rules).
