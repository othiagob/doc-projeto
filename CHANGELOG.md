---
tags: [changelog]
---

# Changelog

Formato baseado em [Keep a Changelog](https://keepachangelog.com/).
Toda entrada relevante (feature, fix, mudança de protocolo) deve virar uma
linha aqui — é o resumo que você lê em 30 segundos pra lembrar "o que mudou
desde a última vez que joguei build".

## [Unreleased]

### Adicionado (2026-09-06)
- `05-Specs/Processo-Spec-Driven.md` — ciclo oficial de mudanças não-triviais
  (ideia -> backlog -> spec -> Cursor -> teste -> registro)
- `08-Ideias/Melhorias-Sugeridas.md` — melhorias concretas já viáveis
  (segurança, banco, código, GM, jogabilidade, automação) em ordem de prioridade
- `03-Aprendizado-CPP/Exercicios-Guiados.md` — exercícios do nível 0 (básico
  introdutório) ao 5, com introdução didática e o código real do jogo
- `03-Aprendizado-SQL/` — trilha de SQL Server + exercícios guiados S0-S9 nas
  tabelas reais do projeto
- `09-Guias/VPS-e-SQL-Server.md` — operação do banco em produção (inventário,
  checklist de segurança, rotina de backup)
- `Dados-SQL/README.md` — índice das tabelas exportadas + dicionário de colunas

### Alterado (2026-09-06)
- `ListaItens_Drop.md` movido da raiz para `Dados-SQL/`
- `.gitignore`: `Arquivos do Jogo/` (7GB de source/cliente/binários) fica
  fora do repo de documentação
- `TEMPLATE-Spec.md` ganhou `status` no frontmatter; `Home.md`, `README.md`
  e `AGENTS.md` atualizados com a nova estrutura

### Adicionado (2026-09-03)
- `01-Projeto/Mapa-Geral-do-Projeto.md` — mapa mental didático da estrutura,
  com exemplos reais de código (ponto de partida de estudo)
- `07-Git-e-Workflow/Fluxo-de-Trabalho.md` — ciclo padrão central de uma
  tarefa (escolher -> spec -> estudar -> implementar -> testar -> registrar)
- `README.md` reduzido a um "ponte" curto (Home.md continua sendo o índice principal)
- `AGENTS.md` na raiz como contexto para IAs que trabalham neste vault no Linux

### Alterado (2026-09-03)
- `Home.md` reescrito como índice didático com ordem de leitura recomendada
- `09-Guias/index.md` deduplicado (aponta para o Home)

### Removido (2026-09-03)
- Pastas `_arquivado/` e `_arquivado-equipe/` (arquivos obsoletos do tempo
  do projeto em dupla) — decisão do autor
- Config local do Obsidian (`.obsidian/workspace*.json` e `.obsidian` de
  subpastas) deixou de ser versionada (via `.gitignore`)

### Adicionado (2026-08-31)
- Análise completa do código-fonte (servidor, cliente, protocolo, banco)
 e reestruturação da documentação para uso individual (Thiago)
- Documento de design (SDD) em `05-Specs/SDD-Source-Priston.md`
- Documentação do protocolo de rede (`02-Arquitetura/Protocolo-de-Rede.md`)
- Documentação do banco de dados (`02-Arquitetura/Banco-de-Dados.md`)
- Backlog de ideias (`08-Ideias/Backlog-de-Ideias.md`)
- Guias em `09-Guias/`

### Corrigido (2026-08-31)
- Documentação de arquitetura: hipóteses "(a validar)" substituídas por
 fatos verificados no código real
- Referências ao trabalho em dupla removidas (documentação agora é pessoal)

### Alterado (2026-08-31)
- Regras do Cursor (`00-project-overview.mdc`) instaladas dentro do
  repositório do jogo (`C:\Source Priston\Source Priston\.cursor\rules\`)
- Documentação reestilizada: sem emojis nem decoração colorida — texto
  puro e símbolos ASCII simples (preferência do autor)

### Protocolo (Shared)
> Toda entrada aqui deve citar o `smTRANSCODE_*` envolvido.
-

---

## Como preencher
Ao final de cada branch de feature/fix mergeada em `main`, adicione uma
linha em `[Unreleased]`. Quando fizer uma build/release para testers, mova
o conteúdo de `[Unreleased]` para uma nova seção `## [vX.Y.Z] - AAAA-MM-DD`
e marque a tag de git correspondente (ver `07-Git-e-Workflow/Workflow-Git.md`).