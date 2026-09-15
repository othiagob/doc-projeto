---
tags: [inicio, processo, documentacao]
status: ativo
data: 2026-09-13
---

# Ritual de documentacao (diario / semanal)

O codigo muda no Cursor. O livro so permanece verdadeiro se periodicamente
olharmos o que foi feito e gravarmos. Thiago pede isso **no chat** — nao
e automatico.

Frases que disparam o ritual: "atualiza a documentacao", "revisa o que
trabalhamos", "sync do vault", "ritual da semana", "o que falta no livro".

Regra Cursor (sempre ativa): `.cursor/rules/01-consult-vault.mdc`.
Onde cada nota mora: [[Onde-Escrever]].

## Diario (fim do dia de codigo)

Curto. Uma entrada em `04-Diario-do-Projeto/` + linha no `CHANGELOG.md`
se o jogador percebeu algo.

Checklist:

- [ ] O que compilou / o que testou no jogo
- [ ] Decisao nova? Se sim, ADR ou pelo menos uma frase no diario
- [ ] PNG novo no Cliente Full? Atualizar [[Inventario-de-Artes]]
- [ ] Spec em andamento? Status ainda `rascunho` / `em andamento`

Nao precisa recap de processo todo dia.

## Semanal (ou depois de um bloco)

A IA (Cursor) percorre source + conversas da semana e **so escreve o
que o livro ainda nao tem**.

Ordem:

1. `git status` / `git log` da source (`C:\Source Priston\Source Priston`).
2. `CHANGELOG.md` do vault — falta a linha da semana?
3. Tela que o jogador ve diferente -> recap em `10-Processos/` (TEMPLATE).
4. Varias areas + falhas revertidas -> sessao em `11-Evolucao/`.
5. Spec cujo codigo ja foi testado -> `status: feita` + link do recap.
6. Roadmap / backlog: `em andamento` vira `feito` (ou o contrario se
   parou).
7. ADR nova se o "por que" mudou. Rules `.mdc` na mesma sessao.
8. Capa [[Home]] secao **Hoje no projeto** se o quadro mudou.
9. Feature grande (client+server, save, transcode, hibrido UI/logica):
   fluxograma mermaid em `02-Arquitetura/<Nome>.md` e um link na
   [[Arquitetura]]. Modelo: [[Armazem]]. Convencao:
   [[Como-documentar-funcionalidade]].

Nao: reescrever Arquitetura, SDD ou recaps antigos sem necessidade.
Nao: commitar sem pedido.

## Antes de comecar codigo novo (nao e o ritual — e o hábito)

O Cursor **consulta** o livro (CHANGELOG, recaps, evolucao, ADR, spec)
para nao repetir trabalho nem experimento revertido. Isso e a regra
`01-consult-vault.mdc`, nao este ritual.

Livro: [[Livro-de-Evolucao]]. Capa: [[Home]].
