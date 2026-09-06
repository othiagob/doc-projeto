# Priston — Documentação do Projeto

Este repositório guarda a **documentação viva** do projeto Source Priston
(um servidor privado de Priston Tale em C++): arquitetura, protocolo de
rede, banco de dados, decisões, diário, aprendizado de C++ e backlog de
ideias. É, acima de tudo, o **caderno de estudos** do autor.

> **Importante:** este repositório é **só a documentação**. O código do jogo
> fica em outro repositório (`Source-Priston`), com `SrcGame/` (cliente),
> `SrcServer/` (servidor) e `Shared/` (código compartilhado).

## Começando

A forma de usar esta documentação é abri-la no **Obsidian** (como vault) e
começar pelo índice principal:

- **`Home.md`** — o ponto de partida e a ordem de leitura recomendada.

Se preferir navegar aqui mesmo no GitHub, o índice por tema também está no
`Home.md`.

## Estrutura

| Pasta | O que tem |
|---|---|
| `00-Inicio/` | Como usar o vault, primeiros passos |
| `01-Projeto/` | Visão geral, mapa geral do projeto, múltiplas IAs |
| `02-Arquitetura/` | Arquitetura verificada, protocolo, banco, glossário |
| `03-Aprendizado-CPP/` | Trilha de estudos C++ e exercícios guiados |
| `03-Aprendizado-SQL/` | Trilha de SQL Server e exercícios nas tabelas reais |
| `04-Diario-do-Projeto/` | Log diário de trabalho |
| `05-Specs/` | Specs de features + SDD + processo spec-driven |
| `06-Decisoes/` | ADRs — decisões e o porquê |
| `07-Git-e-Workflow/` | Fluxo de trabalho + convenções de git |
| `08-Ideias/` | Backlog de ideias + melhorias sugeridas |
| `09-Guias/` | Guias passo a passo (compilar, rodar, banco, VPS) |
| `Dados-SQL/` | Exportações de tabelas do banco (itens, drops, NPCs...) |
| `Arquivos do Jogo/` | Source e cliente full (só leitura; `.gitignore`, fora do repo) |

## Convenções

- Documentação sem emojis nem decoração colorida — texto puro + ASCII.
- O arquivo `AGENTS.md` na raiz é o contexto que IAs carregam
  automaticamente ao trabalhar neste vault no Linux.
- O fluxo de trabalho e as convenções de git estão em `07-Git-e-Workflow/`.

## Histórico

Veja o `CHANGELOG.md` para o que mudou na documentação.
