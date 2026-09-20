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

Kit para IA escrever **codigo** no Antigravity (nao substitui este
livro): `C:\Source Priston\Source Priston\ANTIGRAVITY AGENT\`.

```mermaid
flowchart LR
  mundo[Mundo planta]
  hist[Historia changelog]
  regras[Regras ADR]
  caminho[Caminho spec]
  mundo --> hist
  hist --> regras
  regras --> caminho
```

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

- Janelas ImGui no cromado unico: Desafios, Loja Coins/Tempo, Ranking, Mix, Configuracoes, **Armazem**, **Distribuidor**, **Mestre dos Clan** (codigo 19/09, teste no jogo pendente). Recap Desafios/loja: [[2026-09-08 - Recap janelas ImGui de jogador]]. Recap bau UI: [[2026-09-15 - Recap Armazem ImGui paginas e busca]]. Recap bau save atual: [[2026-09-18 - Recap Armazem arquivo WH03]]. Recap correio: [[2026-09-15 - Recap Distribuidor ImGui e correio 168h]]. Recap cla: [[2026-09-19 - Recap Mestre dos Clan ImGui]]. Plantas: [[Armazem]] · [[Armazem-como-funciona]] · [[Distribuidor]] · [[Clan]] · [[Login-e-intro]].
- Login de conta com PNG Fallen Tale (runtime = Cliente Full). Intro antes do form: [[Login-e-intro]].
- Painel do `Server.exe` (tema claro, splash, modal de confirmação, status de operador, ADR 0002). Recaps: [[2026-09-16 - Recap painel Server.exe splash e Segoe]] · [[2026-09-16 - Recap painel Server.exe modal e operador]].
- Kit agente na source: `ANTIGRAVITY AGENT/` (spec-driven + fluxos).

**Caminho de UI (specs, ainda nao e codigo)** — [[Roadmap-UI]]

1. Organizar inventario — [[2026-09-13-inventario-organizar]]

**Arte em andamento:** char select ainda TGA classico. Brief na source:
`docs/prompt-antigravity-charselect-ui.md`.

Mapa de artes: [[Inventario-de-Artes]].

---

## Historia recente

- [[2026-09-19 - Ritual documentacao e Antigravity Agent]] — diario
- [[2026-09-19 - Recap Mestre dos Clan ImGui]]
- [[2026-09-19 - Ritual docs e Antigravity Agent]] — sessao
- [[2026-09-18 - Armazem WH03 arquivo]] — diario
- [[2026-09-18 - Recap Armazem arquivo WH03]]
- [[2026-09-18 - Armazem WH03 e falhas SQL]] — sessao (nao repetir SQL do bau)
- [[2026-09-17]] — diario (tentativa SQL)
- [[2026-09-17 - Recap Armazem SQL 300 slots]]
- [[2026-09-17 - Armazem SQL e capacidade]] — sessao
- [[2026-09-16 - Painel Server.exe UX operador]] — diario
- [[2026-09-16 - Recap painel Server.exe modal e operador]]
- [[2026-09-16 - Ritual vault, Distribuidor no git e painel Server]] — diario
- [[2026-09-16 - Recap painel Server.exe splash e Segoe]]
- [[2026-09-15 - Recap Distribuidor ImGui e correio 168h]]
- [[2026-09-16 - Distribuidor ImGui, correio e painel Server]] — sessao
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
  [[0006 - Armazem ImGui, paginas no mesmo transcode]],
  [[0007 - Distribuidor ImGui, PB02 e transcodes novos]],
  [[0008 - Armazem SQL, 300 slots, 5 paginas 3 liberadas]] (substituida na persistencia),
  [[0009 - Armazem arquivo WH03, SQL revertido]],
  [[0010 - Mestre dos Clan ImGui, GuildWire e ClanDB]]

---

## Mundo (referencia)

- [[Sobre-o-Projeto]] — o que e, regras de ouro
- [[Arquitetura]] · [[Armazem]] · [[Armazem-como-funciona]] · [[Distribuidor]] · [[Clan]] · [[Login-e-intro]] · [[Protocolo-de-Rede]] · [[Banco-de-Dados]] · [[Glossario-Tecnico]]
- [[SDD-Source-Priston]] — design completo
- `Dados-SQL/README.md` · [[ListaItens_Drop]]
- Guias: `09-Guias/index` · [[VPS-e-SQL-Server]]
- IAs: [[Trabalhando-com-Multiplas-IAs]] (Cursor, Hermes, opencode, **Antigravity** artes Gemini **e** kit de codigo na source)

## Caminho e processo

- [[Fluxo-de-Trabalho]] · [[Processo-Spec-Driven]] · [[Workflow-Git]]
- [[Melhorias-Sugeridas]] · [[Backlog-de-Ideias]]
- Specs de UI: armazem e distribuidor **feitas**; clan **em andamento** (codigo); falta organizar inventario (link na porta Caminho)

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
