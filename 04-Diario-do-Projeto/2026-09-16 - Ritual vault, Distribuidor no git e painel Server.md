---
tags: [diario, cliente, servidor, shared, ui, documentacao]
status: feito
data: 2026-09-16
---

# 2026-09-16 - Ritual vault, Distribuidor no git e painel Server

## O que foi feito

Ritual de documentacao. O codigo do Distribuidor (ImGui + PB02 +
transcodes `0x48478A81`–`0x48478A85`) ja existia desde 15/09, com recap
e ADR 0007 no vault, mas **nao estava no git da source** nem a capa
tinha saído de "ainda nao e codigo".

Tambem no working tree, ainda sem commit:

- Painel do `Server.exe`: splash de boot, Segoe UI, sidebar agrupada.
  `AdminChrome.h` apagado.
- Clique direito na bag deposita no armazem (com o bau aberto).
- Titulos ImGui refeitos + pecas do Distribuidor
  (`distribuidor.png`, `frame.png`).
- Ajuste fino do nick na selecao de personagem (`HoLogin.cpp`).

## Decisoes tomadas

Nenhuma ADR nova. Continua valendo 0002 (sem ouro no Server.exe),
0006 (bau) e 0007 (correio). `frame.png` 760x540 e **excecao so do
Distribuidor** — as outras janelas de jogador seguem cromado
`ImDrawList`. Sem copiar isso para Desafios/Loja sem pedido.

## Problemas encontrados

A capa [[Home]] e o backlog ainda listavam o Distribuidor como spec.
O [[Protocolo-de-Rede]] tinha o bau e nao o correio. Indices de
`10-Processos/` e `11-Evolucao/` nao apontavam o recap 15/09.

## Proximos passos

- Testar no jogo o fluxo do Distribuidor (lista, claim, envio, TTL via
  `/postbox_ttl`).
- Organizar inventario continua spec.
- Char select ainda TGA classico.

## Notas soltas

Cliente Full continua sendo o que o F5 le. Copia na source
`game/images/` e opcional.
