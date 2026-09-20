---
tags: [changelog]
---

# Changelog

Formato baseado em [Keep a Changelog](https://keepachangelog.com/).
Toda entrada relevante (feature, fix, mudança de protocolo) deve virar uma
linha aqui — é o resumo que você lê em 30 segundos pra lembrar "o que mudou
desde a última vez que joguei build".

## [Unreleased]

### Documentacao

#### Ritual 2026-09-19 (fluxogramas + kit Antigravity Agent)

Livro ganhou mermaid nas notas de mundo/processo. Plantas [[Clan]] e
[[Login-e-intro]]. Pasta na source `ANTIGRAVITY AGENT/` para IA
escrever C++ com spec-driven. ADR 0010. Recap clan (codigo, teste
pendente). Diario e sessao 19/09.

### Codigo do jogo

#### Mestre dos Clan ImGui + ClanDB — 2026-09-19

Janela `ClanWindow` kit B. Servidor `GuildService`. Fio
`Shared/GuildWire.h`. Transcodes `smTRANSCODE_GUILD_OPEN/SNAPSHOT/SEARCH/ACTION`
(`0x48478A20`–`0x48478A23`). SQL `ClanDB` via `Create-ClanGuild.sql`.
Teste no jogo pendente (gate NPC `dwGuildNpcTime`).

Planta: [[Clan]]. Recap: [[2026-09-19 - Recap Mestre dos Clan ImGui]].
ADR [[0010 - Mestre dos Clan ImGui, GuildWire e ClanDB]].

#### Intro antes do login — 2026-09-19

`IntroSplash`: video `login.asf` ou `intro.png` ou texto. Skip
clique/tecla. Sem transcode. Planta: [[Login-e-intro]].

#### Armazem arquivo WH03 (SQL revertido) — 2026-09-18

Save vivo volta para `Data\DataServer\warehouse\<n>\<conta>.war`
(magica WH03, so ocupados, 300×3). Grade 20×15, 3 abas e fio
`wVersion=3` **permanecem**. SQL `UserDB.Warehouse` nao e mais lido.
Testado: item persiste ao fechar/reabrir. Falha de save: mensagem
honesta + rollback do inventario.

Planta: [[Armazem]]. Como funciona: [[Armazem-como-funciona]].
Recap: [[2026-09-18 - Recap Armazem arquivo WH03]].
ADR [[0009 - Armazem arquivo WH03, SQL revertido]].
Falhas: [[2026-09-18 - Armazem WH03 e falhas SQL]].

#### Armazem SQL, 300 slots, 3 paginas jogaveis — 2026-09-17

Tentativa: persistencia `UserDB.dbo.Warehouse` / `WarehouseItem`.
Grade 20×15 e `wVersion=3` nasceram aqui. **No jogo o save SQL nao
fechou** (18/09 voltou para arquivo). Nao repetir sem ADR nova.

Recap historica: [[2026-09-17 - Recap Armazem SQL 300 slots]].
ADR 0008 (substituida na persistencia).

#### Armazem ImGui — 2026-09-15

Janela de jogador no cromado 15 (titulo `armazem.png`), busca por nome,
3 paginas. Logica continua em `cWAREHOUSE`. Sem transcode novo:
`smTRANSCODE_WAREHOUSE` (`0x48470047`). Em 2026-09-15 o save ainda era
`.war` WH02 e `wVersion=2` (100 slots/pagina). Isso foi **substituido**
em 2026-09-17 (tentativa SQL + grade 300) e o save vivo em 2026-09-18
(arquivo WH03) — ver entradas acima.

Recap UI: [[2026-09-15 - Recap Armazem ImGui paginas e busca]].
Planta atual: [[Armazem]]. ADR UI [[0006 - Armazem ImGui, paginas no mesmo transcode]].

#### Painel Server.exe (modal, status, operador) — 2026-09-16

Modal de confirmar desligar/sair/kick com margem, borda e dim suave.
Header com ocupação e pílula **A desligar**. Status ganhou pico, RAM,
SQL (host + bancos), mapas. Jogadores: classe, copiar IP. Log: filtro
e copiar. Sem transcode. Sem ouro.

Recap: [[2026-09-16 - Recap painel Server.exe modal e operador]].
Regra: `16-desktop-tools.mdc`. ADR [[0002 - Duas identidades visuais jogador vs ferramenta]].

#### Painel Server.exe (splash + Segoe) — 2026-09-16

Splash a ecrã inteiro enquanto SQL/mapas sobem. Fonte Segoe UI. Sidebar
agrupada (Monitorar / Operar), cards com filete, X nativo minimiza.
`AdminChrome.h` apagado (leftover do ouro no servidor). Sem transcode.

Recap: [[2026-09-16 - Recap painel Server.exe splash e Segoe]].
Regra: `16-desktop-tools.mdc`. ADR [[0002 - Duas identidades visuais jogador vs ferramenta]].

#### Armazem: clique direito deposita — 2026-09-16

Com o bau aberto, clique direito num item da bag de pedra tenta guardar
(peso, espaço, poção). Sem transcode novo.

Recap bau: [[2026-09-15 - Recap Armazem ImGui paginas e busca]].

#### Distribuidor ImGui + correio 168h — 2026-09-15

Janela `PostBoxWindow` (lista + detalhe, cromado 15). Titulo
`distribuidor.png` (400x64) e moldura `frame.png` (760x540) — excecao
pontual, nao copiar para outras janelas. Transcodes novos
`POSTBOX_OPEN/LIST/CLAIM/REFUSE/SEND` (`0x48478A81`–`0x48478A85`).
`ITEM_EXPRESS` (`0x48478A80`) so entrega o item claimado. Save `PB02`,
writer unico, TTL 168h, envio P2P com blob `sITEMINFO`. Inventario
continua pedra. Primeiro commit na source em 2026-09-16.

Recap: [[2026-09-15 - Recap Distribuidor ImGui e correio 168h]].
Planta: [[Distribuidor]]. ADR [[0007 - Distribuidor ImGui, PB02 e transcodes novos]].

### Documentacao

#### Ritual 2026-09-18 (armazem WH03 + falhas SQL)

Planta [[Armazem]] atualizada. Documento auxiliar
[[Armazem-como-funciona]] (fluxogramas mermaid). ADR 0009. Recap,
diario, sessao `11-Evolucao`. ADR 0008 marcada substituida. Autorizacao
permanente do Cursor no vault (sem pedir arquivo a arquivo).

#### Ritual 2026-09-17 (armazem SQL)

Planta [[Armazem]] reescrita (trajetoria + SQL). ADR 0008. Recap e nota
em `11-Evolucao/`. Protocolo `wVersion=3`. Diario [[2026-09-17]].
Script `Create-Warehouse.sql` no vault.

#### Ritual 2026-09-16 (capa, protocolo, indices)

Capa [[Home]] passou o Distribuidor de "spec" para "ja no jogo".
Protocolo ganhou a tabela `POSTBOX_*`. Recap e planta que estavam so
no disco do vault entram no git. Spec [[2026-09-13-distribuidor-correio]]
continua `feita`.

#### Fluxogramas de funcionalidade — 2026-09-15

Mudanca grande de fluxo passa a ter mermaid em `02-Arquitetura/`.
Convencao: [[Como-documentar-funcionalidade]]. Primeiro exemplo: o bau.

#### UI / artes — 2026-09-13

Hub `12-UI-e-Artes/` + livro de evolucao no vault (`Home.md`,
`Livro-de-Evolucao.md`, `Onde-Escrever.md`, `Tres-Diretorios.md`).
ADR 0005. Specs rascunho: distribuidor, armazem, organizar inventario.

Artes PNG/TGA: **Antigravity + Gemini**, destino `C:\Cliente Full`.
Regra Cursor `05-directories-and-art.mdc` + `06-antigravity-brief.mdc`
(prompt completo ao refatorar janela: kit login/char select, pecas em
arquivo vs cromado ImDrawList) + `01-consult-vault.mdc`.

Nenhum C++ nesta entrada. Login PNG e titulos ImGui ja estavam no
cliente; o vault passou a ser o livro (historia, regras, caminho).

### Codigo do jogo

#### Bloco HUD / loja / painel — 2026-09-08

Relato completo: [[2026-09-08 - HUD ImGui lojas ranking mix e painel do servidor]].
ADRs 0002, 0003, 0004. Recaps em `10-Processos/`.

- Janelas de jogador (Desafios, Configuracoes, Loja Coins, Loja Tempo,
  Ranking, Mix) no mesmo cromado ImGui (`ImGuiWindowChrome.h`). Titulos PNG.
  Clique na UI nao anda o personagem. HUD de pedra intacto.
- Loja: SQL `ShopItems.DiscountPercent`; `ItemCode` = codigo do item; icone
  BMP no client. Lista `0x252031` em chunks (socket 8192).
- Servidor: log de SQL com nome do banco; `EnsurePainelDatabase`; painel
  ImGui do `Server.exe` (tema claro, `ToolTheme.h`). Sem transcode novo em
  `Shared/`.

### Documentacao

#### Adicionado (2026-09-08)
- `11-Evolucao/` — sessoes especiais de evolucao (template + primeira nota)
- ADRs `0002`, `0003`, `0004`
- `09-Guias/sql/Create-PainelDB.sql`
- Recaps `2026-09-08` em `10-Processos/`
- Diario `2026-09-08 - HUD ImGui loja ranking mix e painel`

#### Quest (cliente) — 2026-09-06

Redesign da janela **Desafios** (tecla Q). So cliente; servidor e `Shared/`
intactos. Recap: [[2026-09-06 - Recap Desafios ImGui]].

- Janela ImGui com cromado proprio (fundo escuro, borda dourada, cantos em L),
  sem `StyleColorArmageddon()`. Lista agrupada (entregar / andamento /
  disponiveis / concluidas) + detalhe + rodape de acao.
- Abas Unicas / Diarias / Repetitivas; nas repetitivas, faixa de nivel
  (`sinChar->Level` vs `minLevel`/`maxLevel`).
- Titulo em imagem `game/images/quest/desafios.png` (fallback texto DESAFIOS).
- Cancelar desafio: popup ImGui no mesmo cromado; fundo da tela mais escuro
  (~0.80). VOLTAR / CONFIRMAR. Sem `cMessageBox`.
- Taskbar "Em andamento": arrastavel, minimizavel, cantos retos, titulo
  `emandamento.png`. Clique no nome abre Desafios nessa quest (`FocusQuest`).
  Clique na caixa nao move o personagem (`IsBlockingMouse` + `WantCaptureMouse`).
- Quest pronta para entregar na taskbar: texto verde + barra verde `n/n`
  (sem check e sem "OK").
- `MapasWU8` permanece ANSI (minimapa / `DrawTextA`); Desafios converte
  com `ToUtf8()`. Corrige `IlusÃµes` no minimapa.
- Q abre/fecha a janela grande (`openFlag`), nao o overlay.

### Documentacao

#### Adicionado (2026-09-06)
- `10-Processos/` — secao nova para recap de processos ja implementados
  (como era / o que o jogador ve / o que implementei). Primeira nota:
  `2026-09-06 - Recap Desafios ImGui.md`. Template em `TEMPLATE-Processo.md`.
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
Ao final de cada bloco de feature/fix no **jogo**, adicione linhas em
`[Unreleased]` no **topico certo** (`Quest (cliente)`, `Protocolo (Shared)`,
etc.). Se o bloco merece recap (como era / o que implementei), copie
`10-Processos/TEMPLATE-Processo.md`.

Mudanca so de documentacao vai em `### Documentacao`.

Quando fizer uma build/release para testers, mova o conteúdo de
`[Unreleased]` para uma nova seção `## [vX.Y.Z] - AAAA-MM-DD`
e marque a tag de git correspondente (ver `07-Git-e-Workflow/Workflow-Git.md`).