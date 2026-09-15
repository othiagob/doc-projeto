# AGENTS.md — Contexto para IAs trabalhando neste vault (Linux)

> Este arquivo é carregado automaticamente pelo opencode (e por outras IAs
> que respeitam `AGENTS.md`) quando a sessão é aberta a partir desta pasta
> no **Linux**. Ele complementa o `00-project-overview.mdc` do Cursor
> (Windows) e a regra central do vault: **o vault manda** — ver
> `01-Projeto/Trabalhando-com-Multiplas-IAs.md`.

## Mapa de localizações

**Windows (Cursor + Visual Studio + jogo):**

| Papel | Caminho |
|---|---|
| Cliente do jogo | `C:\Cliente Full` |
| Source code | `C:\Source Priston\Source Priston` |
| Este vault | `C:\Users\carol\Desktop\doc-projeto` |

Artes PNG/TGA: Antigravity + Gemini, gravar no Cliente Full.

**Linux (opencode)** — docs antigos com `C:\...` nao se aplicam aqui:

| Item | Caminho no Linux |
|---|---|
| Este vault de documentação | `/home/othiagob/Documentos/priston-documents` |
| Cópia da source p/ leitura/análise | `Arquivos do Jogo/01 - Source Priston/Source Priston` (dentro do vault, fora do git via `.gitignore`) |
| Cliente full extraído | `Arquivos do Jogo/02 - Cliente_Full_WDPT_2026` (fora do git) |
| Código editável/compilável (repo git) | máquina **Windows** — via Cursor + Visual Studio |

## Papel desta IA no projeto

O opencode no Linux é usado para **estudo, análise, documentação e
planejamento** — **nunca** para compilar ou rodar o jogo.

- Este vault (`priston-documents` / `doc-projeto`) e o **livro de
  evolucao** do Thiago: historia, regras, caminho, e caderno de C++/SQL.
  Capa: `Home.md`. Como navegar: `00-Inicio/Livro-de-Evolucao.md` e
  `00-Inicio/Onde-Escrever.md`. Ritual de sync (quando o usuario pedir):
  `00-Inicio/Ritual-Documentacao.md`. No Windows o Cursor consulta o
  livro **antes** de criar/ajustar/refatorar (`.cursor/rules/01-consult-vault.mdc`).
- O código-fonte está presente no Linux **apenas para leitura/análise/estudo**.
- O build é 100% MSBuild/Visual Studio 2022 no **Windows** (`SrcGame/Game.sln`
  e `SrcServer/server.sln`, Win32). Não existe build nativo no Linux e **não
  compilamos nem rodamos nada aqui**.
- Aqui: lemos o código e **explicamos** (ensinar C++ no processo), atualizamos
  o vault, planejamos specs e cuidamos do git (quando pedido).
- Qualquer código novo/alterado que esta IA (ou outra via chat) gerar é
  apenas material de estudo/quando aplicado no Windows (Cursor) e compilado lá.

## Pontos de entrada do código

- `SrcGame/src/Game/` — cliente (engine Delta3D + DirectX). Entry: `Winmain.cpp`,
  `Main.cpp`. Config: `game.ini` (`[ConnectServer]` IP/porta).
- `SrcServer/src/Server/` — servidor. Entry: `Winmain.cpp` -> `OnSever.cpp`
  (`ServerWinMain`, gigante ~34k linhas: dispatch de pacotes, game loop).
- `Shared/` — código que precisa ser **idêntico** nos dois lados:
  `smPacket.h` (protocolo, ~2.800 `smTRANSCODE_*`), `LevelTable.h`,
  `GlobalsShared.h`, `Skills/`, `Utils/`.
- `dependencies/` — terceiros vendorizados (Delta3D, ziparchive) — **nunca editar**.

## Regras de ouro (herdadas — resumo)

1. Nunca editar `dependencies/`.
2. Toda mudança em `Shared/` implica revisar os dois lados (client + server).
   Liste os pontos de impacto antes de editar.
3. Nunca inventar códigos `smTRANSCODE_*` — procurar equivalente em
   `Shared/smPacket.h` primeiro; citar o código envolvido em qualquer tarefa de rede.
4. Escopo pequeno por tarefa; nenhum refactor amplo "de brinde".
5. Sem testes automatizados — toda mudança de lógica exige um plano de teste
   manual claro (o que testar no jogo).
6. Não criar `.vcxproj`/`.sln` novos nem mexer em Diretório de Saída/Intermediário.
7. Seguir a convenção de idioma/código já usada no arquivo que está sendo editado.

## Convenções de escrita

- Sem emojis nem decoração colorida nos docs — texto puro + ASCII (preferência
  do autor). Ver `CHANGELOG.md`.
- Siga os templates existentes para entrada de diário, spec (SDD) e decisão (ADR).
- Ao fazer uma mudança relevante no jogo, registrar no diário (`04-Diario-do-Projeto/`),
  no `CHANGELOG.md` (topico do modulo) e, se for um bloco que o jogador
  percebe, em `10-Processos/` (template + recap). Bloco grande (varias
  areas + decisoes): `11-Evolucao/`. Tela / arte / "ja fizemos isso na
  UI?": `12-UI-e-Artes/`.

## Docs que valem ser lidos antes de tarefas não-triviais

- `Home.md` — capa do livro (comece aqui)
- `00-Inicio/Livro-de-Evolucao.md` — as quatro partes (mundo / historia / regras / caminho)
- `00-Inicio/Tres-Diretorios.md` — Cliente Full, source, vault
- `00-Inicio/Onde-Escrever.md` — onde criar a proxima nota
- `00-Inicio/Ritual-Documentacao.md` — sync diario/semanal quando o usuario pedir
- `12-UI-e-Artes/Como-gerar-artes.md` — Antigravity + Gemini; o Cursor
  entrega o prompt completo (`06-antigravity-brief.mdc` no repo do jogo)
- `01-Projeto/Mapa-Geral-do-Projeto.md` — mapa mental didático da estrutura
- `02-Arquitetura/Arquitetura.md` — planta do código
- `02-Arquitetura/Protocolo-de-Rede.md` e `Glossario-Tecnico.md` — se tocar rede/Shared
- `05-Specs/SDD-Source-Priston.md` — design completo
- `05-Specs/Processo-Spec-Driven.md` — ciclo oficial de mudanças não-triviais
- `08-Ideias/Backlog-de-Ideias.md` e `08-Ideias/Melhorias-Sugeridas.md` — o que fazer a seguir
- `10-Processos/index.md` — recap do que ja foi implementado no jogo
- `11-Evolucao/index.md` — sessoes especiais (falhas, acertos, decisoes)
- `12-UI-e-Artes/index.md` — mapa de artes (feito vs falta) e roadmap de
  telas; ADR 0005 + 0006. Armazem feito: `02-Arquitetura/Armazem.md`
- `09-Guias/` — como compilar/rodar/configurar banco; `VPS-e-SQL-Server.md` p/ produção
- `Dados-SQL/README.md` — tabelas do banco exportadas (itens, drops, NPCs)
- `07-Git-e-Workflow/Fluxo-de-Trabalho.md` — o ciclo padrão de uma tarefa
- `01-Projeto/Trabalhando-com-Multiplas-IAs.md` — como múltiplas IAs compartilham contexto

## Git

- O **código do jogo** tem repo próprio (`github.com/othiagob/Source-Priston`),
  branch `main` — não mexer daqui sem necessidade.
- Este **vault de documentação** é um repo git separado
  (`github.com/othiagob/doc-projeto`, branch `main`). Convenção de commit:
  Conventional Commits
  (ver `07-Git-e-Workflow/Workflow-Git.md`).
- Não commitar sem pedido explícito do usuário.
