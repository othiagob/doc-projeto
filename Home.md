---
tags: [moc, inicio]
---

# Source Priston — livro de evolucao

Capa do vault. Toda vez que abrir o Obsidian, comece aqui.

Como o livro funciona: [[Livro-de-Evolucao]].
Onde criar a proxima nota: [[Onde-Escrever]].
Tres pastas no disco: [[Tres-Diretorios]].
Ritual diario/semanal (voce pede no chat): [[Ritual-Documentacao]].

---

## Tres diretorios (Windows)

| Papel | Caminho |
|---|---|
| Cliente do jogo | `C:\Cliente Full` |
| Source code | `C:\Source Priston\Source Priston` |
| Documentacao (este vault) | `C:\Users\carol\Desktop\doc-projeto` |

PNG/TGA novos: **Antigravity + Gemini**, gravar no Cliente Full.
[[Como-gerar-artes]].

---

## Quatro portas

| Porta | Pergunta | Abra |
|---|---|---|
| **Mundo** | Como o jogo e o codigo se partem? | [[Mapa-Geral-do-Projeto]], [[Arquitetura]], [[Tres-Diretorios]] |
| **Historia** | O que ja aconteceu? | [[CHANGELOG]], `11-Evolucao/`, `10-Processos/` |
| **Regras** | Por que e assim? | `06-Decisoes/`, [[Processo-Spec-Driven]] |
| **Caminho** | O que falta? | [[Roadmap-UI]], [[Backlog-de-Ideias]], `05-Specs/` |

---

## Hoje no projeto

**Ja no jogo (jogador ve)**

- Janelas ImGui no cromado unico: Desafios, Loja Coins/Tempo, Ranking, Mix, Configuracoes, **Armazem**. Recap Desafios/loja: [[2026-09-08 - Recap janelas ImGui de jogador]]. Recap bau: [[2026-09-15 - Recap Armazem ImGui paginas e busca]]. Planta do bau: [[Armazem]].
- Login de conta com PNG Fallen Tale (runtime = Cliente Full).
- Painel do `Server.exe` (tema claro, ADR 0002).

**Caminho de UI (specs, ainda nao e codigo)** — [[Roadmap-UI]]

1. Organizar inventario — [[2026-09-13-inventario-organizar]]
2. Distribuidor ImGui + correio 168h — [[2026-09-13-distribuidor-correio]]

**Arte em andamento:** char select ainda TGA classico. Brief na source:
`docs/prompt-antigravity-charselect-ui.md`.

Mapa de artes: [[Inventario-de-Artes]].

---

## Historia recente

- [[2026-09-15 - Armazem ImGui paginas e busca]] — diario
- [[2026-09-15 - Recap Armazem ImGui paginas e busca]]
- [[2026-09-15 - Armazem ImGui paginas e save]] — sessao
- [[2026-09-13 - Artes visuais e roadmap UI]] — diario
- [[2026-09-13 - Recap artes de login e titulos ImGui]]
- [[2026-09-08 - HUD ImGui lojas ranking mix e painel do servidor]] — sessao
- ADRs: [[0002 - Duas identidades visuais jogador vs ferramenta]],
  [[0003 - Catalogo SQL vs icone BMP no client]],
  [[0004 - Encoding ImGui UTF-8 vs HUD legado Windows-1252]],
  [[0005 - Distribuidor ImGui, armazem e inventario em pedra, artes no Cliente Full]],
  [[0006 - Armazem ImGui, paginas no mesmo transcode]]

---

## Mundo (referencia)

- [[Sobre-o-Projeto]] — o que e, regras de ouro
- [[Arquitetura]] · [[Armazem]] · [[Protocolo-de-Rede]] · [[Banco-de-Dados]] · [[Glossario-Tecnico]]
- [[SDD-Source-Priston]] — design completo
- `Dados-SQL/README.md` · [[ListaItens_Drop]]
- Guias: `09-Guias/index` · [[VPS-e-SQL-Server]]
- IAs: [[Trabalhando-com-Multiplas-IAs]] (Cursor, Hermes, opencode, **Antigravity/Gemini** nas artes)

## Caminho e processo

- [[Fluxo-de-Trabalho]] · [[Processo-Spec-Driven]] · [[Workflow-Git]]
- [[Melhorias-Sugeridas]] · [[Backlog-de-Ideias]]
- Specs de UI: armazem **feita**; faltam organizar inventario e distribuidor (links na porta Caminho)

## Aprendizado (caderno ao lado)

- [[Trilha-de-Aprendizado]] · [[Exercicios-Guiados]] · [[Exercicios-Seguros]]
- [[Trilha-SQL-Server]] · [[Exercicios-SQL-Guiados]]
- [[Registro-de-Aprendizado]]

Primeira leitura (se esta comecando): Mapa Geral -> Sobre o Projeto ->
Trilha -> Fluxo -> [[Como-Usar-Este-Vault]].

---

## Pastas = papel

Numeracao so ordena a barra do Obsidian.

| Pasta | Papel no livro |
|---|---|
| `00-Inicio/` | Capa, tres diretorios, onde escrever, ritual de sync |
| `01-Projeto/` | Mundo: visao, mapa, IAs |
| `02-Arquitetura/` | Mundo: planta verificada no codigo |
| `03-Aprendizado-*` | Caderno de estudo (C++ / SQL) |
| `04-Diario-do-Projeto/` | Historia curta (o dia) |
| `05-Specs/` | Caminho: o que vamos implementar |
| `06-Decisoes/` | Regras: o porquê |
| `07-Git-e-Workflow/` | Como a tarefa anda + git |
| `08-Ideias/` | Caminho: backlog |
| `09-Guias/` | Mundo: como rodar a maquina |
| `10-Processos/` | Historia: recap que o jogador percebe |
| `11-Evolucao/` | Historia: bloco inteiro (falhas incluidas) |
| `12-UI-e-Artes/` | Caminho + mapa de artes |
| `Dados-SQL/` | Mundo: tabelas exportadas |
| `Arquivos do Jogo/` | Linux: copia de leitura (fora do git) |

Quando em duvida: [[Onde-Escrever]]. Vault imperfeito e usado vale mais
que vault perfeito e vazio.
