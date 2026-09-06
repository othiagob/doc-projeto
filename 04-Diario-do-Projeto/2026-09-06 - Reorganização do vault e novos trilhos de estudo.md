---
tags: [docs, processo, aprendizado]
data: 2026-09-06
---

# 2026-09-06 - Reorganização do vault e novos trilhos de estudo

> Sessão com modelo de IA mais avançado (pedido do Thiago): refinar tudo que
> já existia e preparar material de estudo + processo de evolução do jogo.

## O que foi feito

- Estrutura geral revisada: caminhos desatualizados corrigidos, pastas novas
  ligadas no `Home.md`/`README.md`/`AGENTS.md`.
- **Processo spec-driven oficializado** em `05-Specs/Processo-Spec-Driven.md`
  (via rápida x ciclo completo, status de spec, regra "Cursor lista arquivos
  antes de editar").
- **Melhorias viáveis catalogadas** em `08-Ideias/Melhorias-Sugeridas.md`
  (segurança primeiro: hash de senha, credenciais hardcoded; depois banco,
  código, GM, jogabilidade).
- **Exercícios guiados** criados:
  - `03-Aprendizado-CPP/Exercicios-Guiados.md` — nível 1 a 5, todo baseado
    em código real (Debug.h, strings.h, GlobalsShared.h, LevelTable.h, GM/).
  - `03-Aprendizado-SQL/` — trilha + exercícios S1-S9 usando as tabelas já
    exportadas em `Dados-SQL/` (SELECT -> JOIN -> transações).
- **Banco em produção documentado**: `09-Guias/VPS-e-SQL-Server.md`
  (inventário com campos a preencher, checklist de segurança, rotina de
  backup).
- `Arquivos do Jogo/` (source + cliente, ~7GB) ficou **fora do git** via
  `.gitignore`.
- `Dados-SQL/README.md` virou o índice das tabelas exportadas;
  `ListaItens_Drop.md` mudou pra lá.

## Decisões tomadas

- O vault fica como fonte única de verdade; regras do Cursor e AGENTS.md
  apenas espelham o que está aqui (ver `01-Projeto/Trabalhando-com-Multiplas-IAs.md`).
- Aprendizado de SQL ganha pasta própria (`03-Aprendizado-SQL/`) por ser
  stack separada de C++ com trilha independente.

## Problemas encontrados

- CHANGELOG tinha seções de 2026-08-31 sem data no cabeçalho — datadas.
- Ajuste do dia: caminhos do vault nos docs seguem os do Windows (máquina de
  programação) — não trocar por caminhos Linux; este Linux é só estudo.

## Próximos passos

- [ ] Thiago: ler `Home.md` e `05-Specs/Processo-Spec-Driven.md` e ajustar o
      que não concordar
- [ ] Thiago: preencher o inventário de `09-Guias/VPS-e-SQL-Server.md`
- [ ] Começar pelos exercícios S1-S3 (SQL) + E1.1/E1.3 (C++) e registrar no
      `03-Aprendizado-CPP/Registro-de-Aprendizado.md`
- [ ] Primeira melhoria a puxar do backlog: backup automático do banco

## Notas soltas

- A cópia da source em `Arquivos do Jogo/` dá pra estudar aqui no Linux
  (ás scripts/exercícios já apontam pra lá) — edição mesmo continua sendo só
  no Windows via Cursor.
