---
tags: [evolucao]
status: ativo
data: 2026-09-19
---

# 2026-09-19 - Ritual docs, kit Antigravity, clan e intro

## Escopo do bloco

Documentacao (vault + source). Codigo de clan/intro/kit B ja estava
na working tree; o ritual descreveu, nao reimplementou.

## O que deu certo

- Pasta `ANTIGRAVITY AGENT/` na source: leitura obrigatória para IA
  que vai editar C++ no Antigravity, spec-driven, fluxos mermaid.
- Livro ganhou plantas [[Clan]] e [[Login-e-intro]] e mermaid nas
  notas de mundo/processo.
- Inventario de artes: kit B `frame.png` em todas as janelas grandes;
  clan e intro.

## O que falhou / risco

Nao e revert: e lacuna. `dwGuildNpcTime` sem assignment. Documentado
para a proxima sessao de codigo **nao** descobrir isso de novo.

## Decisoes

ADR [[0010 - Mestre dos Clan ImGui, GuildWire e ClanDB]].
Antigravity passa a ter kit de **codigo** alem de Gemini artes.
O vault continua o livro; a pasta na source e o onboarding do repo.

## O que testar daqui a meses

Abrir `ANTIGRAVITY AGENT/README.md` numa sessao fria e ver se um
agente novo ainda acerta Shared, tres diretorios e o bau WH03.
