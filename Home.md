---
tags: [moc, inicio]
---

# Priston — Base de Documentação do Projeto (vault)

> **Autor:** Thiago · **Uso:** pessoal (você + as IAs que você usar: Cursor,
> Hermes, opencode). Este é o "caderno de estudos + documentação viva" do
> projeto — estudar o código do jogo, documentar tudo, e servir de guia de
> aprendizado de C++.

Este é o ponto de partida. Toda vez que abrir o Obsidian pra trabalhar no
projeto, comece por aqui.

---

## Comece por aqui (ordem de leitura)

Se você está **começando agora**, leia nesta ordem. É uma trilha didática:
primeiro a visão geral, depois o detalhe, depois como trabalhar.

1. **[[Mapa-Geral-do-Projeto|Mapa Geral do Projeto]]** — entenda a estrutura
   em uma leitura (linguagem simples, com exemplos reais). Comece aqui.
2. **[[Sobre-o-Projeto]]** — o que é o projeto, seus objetivos e regras.
3. **[[Trilha-de-Aprendizado]]** — o plano de estudos de C++ com o projeto.
4. **[[Fluxo-de-Trabalho]]** — o ciclo padrão de uma tarefa, do início ao fim.
5. **[[Como-Usar-Este-Vault]]** — convenções de pastas/tags/templates.

Já trabalha no projeto e quer um atalho? Vá direto para o mapa de pastas
abaixo ou use o índice por tema.

---

## Mapa do vault (por tema)

- **Projeto / visão geral**
  - [[Mapa-Geral-do-Projeto]] — mapa mental didático da estrutura
  - [[Sobre-o-Projeto]] — o que é, objetivos, regras de ouro
  - [[Trabalhando-com-Multiplas-IAs]] — como usar Cursor + Hermes + opencode
- **Arquitetura** (referência técnica verificada)
  - [[Arquitetura]] — planta baixa do código (client/server/shared)
  - [[Protocolo-de-Rede]] — como cliente e servidor conversam (`smPacket.h`)
  - [[Banco-de-Dados]] — SQL Server, bancos e conexão
  - [[Glossario-Tecnico]] — termos, siglas, códigos de pacote
  - [[SDD-Source-Priston]] — o documento de design completo (a "SPEC" do projeto)
- **Aprendizado de C++**
  - [[Trilha-de-Aprendizado]] — o plano de estudos
  - [[Exercicios-Seguros]] — tarefas de baixo risco no código real
  - [[Registro-de-Aprendizado]] — seu log pessoal de estudos
- **Processo e fluxo de trabalho**
  - [[Fluxo-de-Trabalho]] — o ciclo padrão de uma tarefa (central)
  - [[Workflow-Git]] — branches, commits, tags
  - [[CHANGELOG]] — o que já mudou, versão a versão
- **Specs e decisões** (antes/durante features)
  - `05-Specs/TEMPLATE-Spec` — copie ao começar uma feature não-trivial
  - `06-Decisoes/TEMPLATE-ADR` — registre o "porquê" das decisões
- **Diário do Projeto** (log cronológico de trabalho)
  - `04-Diario-do-Projeto/TEMPLATE-Entrada-Diario`
- **Ideias** (coisas que você quer fazer um dia)
  - [[Backlog-de-Ideias]]
- **Guias** (passo a passo prático)
  - `09-Guias/index` — compilar, rodar, configurar banco

---

## Regra simples pra não se perder

Se você não sabe onde algo deveria morar neste vault, pergunte: **"isso é
sobre o código em si, sobre uma decisão, sobre um aprendizado pessoal, ou
sobre o dia a dia de trabalho?"** — isso já aponta a pasta certa (Arquitetura,
Decisões, Aprendizado, Diário). Ideia de mudança futura vai em
[[Backlog-de-Ideias]].

Quando em dúvida: crie a nota mesmo assim, no lugar que parecer mais certo,
e mova depois. Um vault imperfeito e usado vale mais que um vault perfeito
e vazio.

---

## Estrutura de pastas

| Pasta | O que tem |
|---|---|
| `00-Inicio/` | Como usar o vault, primeiros passos |
| `01-Projeto/` | Visão geral, mapa geral, sobre o projeto, múltiplas IAs |
| `02-Arquitetura/` | Arquitetura verificada, protocolo, banco, glossário (+ anexos) |
| `03-Aprendizado-CPP/` | Trilha de estudos, exercícios seguros, registro de aprendizado |
| `04-Diario-do-Projeto/` | Log diário de trabalho |
| `05-Specs/` | Specs de features + SDD |
| `06-Decisoes/` | ADRs — decisões e o porquê |
| `07-Git-e-Workflow/` | Fluxo de trabalho + convenções de git |
| `08-Ideias/` | Backlog de ideias |
| `09-Guias/` | Guias passo a passo (compilar, rodar, banco) |
| `AGENTS.md` | Contexto para IAs que trabalham neste vault no Linux |

> **Obs:** pastas arquivadas antigas foram removidas (arquivos obsoletos do
> tempo em que o projeto era em dupla). Ver `CHANGELOG.md`.
