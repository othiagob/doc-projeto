---
tags: [moc, inicio]
---

# Priston — Base de Documentação do Projeto (vault)

> **Autor:** Thiago · **Uso:** pessoal (você + as IAs que você usar: Cursor, Hermes)
> **Última revisão:** 2026-08-31 (análise completa do código — ver [[2026-08-31 - Análise completa do código e reestruturação da documentação]])

Este é o ponto de partida. Toda vez que abrir o Obsidian pra trabalhar no
projeto, comece por aqui.

## Mapa do vault

- [[Como-Usar-Este-Vault|Como usar este vault]] — leia isso primeiro, é rápido
- **Projeto**
  - [[Sobre-o-Projeto]] — o que é, seus objetivos, como está organizado
  - [[Trabalhando-com-Multiplas-IAs]] — como usar Cursor + Hermes sem perder contexto
- **Arquitetura**
  - [[Arquitetura]] — mapa VERIFICADO das pastas do código (client/server/shared)
  - [[Protocolo-de-Rede]] — como cliente e servidor conversam (`smPacket.h`)
  - [[Banco-de-Dados]] — SQL Server, bancos e conexão
  - [[Glossario-Tecnico]] — termos, siglas, códigos de pacote
  - [[SDD-Source-Priston]] — o documento de design completo (a "SPEC" do projeto)
- **Aprendizado de C++**
  - [[Trilha-de-Aprendizado]]
  - [[Exercicios-Seguros]]
  - [[Registro-de-Aprendizado]] — seu log pessoal de estudos
- **Specs** (antes de features grandes)
  - `TEMPLATE-Spec` — copie ao começar uma feature/mudança não-trivial
- **Decisões** (por que fizemos assim, e não de outro jeito)
  - `TEMPLATE-ADR`
  - [[0001 - Uso de Cursor Rules e estrutura de docs]]
- **Diário do Projeto** (log cronológico de trabalho)
  - `TEMPLATE-Entrada-Diario`
  - [[2026-08-31 - Setup inicial do projeto e documentação]]
  - [[2026-08-31 - Análise completa do código e reestruturação da documentação]]
- **Ideias** (coisas que você quer fazer um dia)
  - [[Backlog-de-Ideias]] — o lugar pra anotar tudo que você quer implementar/testar
- **Git e Workflow**
  - [[Workflow-Git]]
  - [[CHANGELOG]] — o que já mudou no jogo, versão a versão

## Regra simples pra não se perder

Se você não sabe onde algo deveria morar neste vault, pergunte: **"isso é
sobre o código em si, sobre uma decisão, sobre um aprendizado pessoal, ou
sobre o dia a dia de trabalho?"** — isso já aponta a pasta certa (Arquitetura,
Decisões, Aprendizado, Diário). Ideia de mudança futura vai em
[[Backlog-de-Ideias]].

Quando em dúvida: crie a nota mesmo assim, no lugar que parecer mais certo,
e mova depois. Um vault imperfeito e usado vale mais que um vault perfeito
e vazio.