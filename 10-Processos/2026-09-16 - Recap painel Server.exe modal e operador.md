---
tags: [processos]
status: feito
data: 2026-09-16
modulo: servidor
---

# 2026-09-16 - Recap painel Server.exe modal e operador

## Como era

O painel claro (ADR 0002, recap
[[2026-09-16 - Recap painel Server.exe splash e Segoe]]) ja tinha splash,
Segoe e sidebar. O modal de confirmar desligar/sair/kick herdava o estilo
da casca: padding 0, sem borda, altura fixa 400x188. Texto e botoes colados
na borda; overlay escuro padrao do ImGui em cima do tema claro. `OpenPopup`
todo frame. Status mostrava pouco (online, uptime, EXP/DROP, IP, porta).
Kick na tabela era um botao vermelho apertado. Log clonava 400 linhas
todo frame.

## O que o operador ve agora

Confirmar desligar/sair/kick e um cartao com margem, borda e fundo
escurecido suave. Voltar e Escape cancelam. Desligar diz quantos estao
online e que fecha em 8 minutos; sair agora avisa que e na hora. Header
mostra ocupacao `N / max` e, se o shutdown ja corre, pílula **A desligar**.
Status: pico da sessao, RAM do processo, host SQL (sem senha), bancos
ligados, mapas com mais gente. Jogadores: classe, clique no IP copia.
Log: filtro, so erros, copiar visiveis. Manutencao ao vivo em Acoes
(nao grava o INI).

O jogador **nao** ve isto. Continua ferramenta desktop, nao HUD Fallen Tale.

## O que implementei (e por que)

- `PushToolPopupStyle` no modal: a casca precisa padding 0 para desenhar
  header/sidebar; o popup nao pode herdar isso. Por isso o desligar
  parecia "estranho".
- `OpenPopup` so na transicao; `AlwaysAutoResize` em vez de 188 px magicos.
- `rsIsShuttingDown` / `rsShutDownMinutesLeft` so leitura. Nao ha cancelar
  a thread de 8 min — so `Quit` a derruba, e isso e sair de verdade.
- SQL: `GetName` + lista ja ligada + host cacheado no boot. Sem ping ODBC
  por frame (contenderia com o jogo).
- Snapshot de log a cada 400 ms + `ImGuiListClipper`. UTF-8 do nick/conta
  no snapshot, nao em cada celula.

## Arquivos tocados

- `SrcServer/src/Server/HUD/ServerPanel.cpp` / `.h` (h inalterado no papel)
- `SrcServer/src/Server/HUD/ToolTheme.h`
- `SrcServer/src/Server/HUD/ServerConfigPages.cpp`
- `SrcServer/src/Server/SrcServer/OnSever.cpp` / `onserver.h`
- `SrcServer/src/Server/Database/SQLConnection.cpp` / `.h`
- `.cursor/rules/16-desktop-tools.mdc`

## Shared / protocolo

- Tocou em `Shared/`? nao
- Transcodes novos? nenhum

## O que testar

1. **Desligar em 8 minutos** — modal com margem e borda; Voltar e Escape
   cancelam; confirmar avisa o mundo; header vira **A desligar**; segundo
   clique nao abre lixo.
2. **Sair agora** — texto distinto (encerra na hora).
3. Kick — nick certo; IP clique copia.
4. Status — ocupacao, pico, SQL host, bancos, RAM, top mapas.
5. Log — filtro, so erros, copiar; splash de boot intacto.
6. Arquivos — Salvar / Ler do disco no cromado da ferramenta; SQL.ini
   ainda pede reinicio.
7. X nativo ainda **minimiza**.

## O que ficou de fora / proximos passos

- Cancelar shutdown de 8 min (thread sem flag segura).
- Health-check SQL periodico.
- Mapeamento de todas as tabelas no painel (ja fora no recap do splash).
- Ouro de jogador no `Server.exe` continua **proibido**.

## Aprendizado

Estilo global com padding 0 serve a casca custom (`ImDrawList`) e
estraga popup. Modal de ferramenta precisa do proprio padding/borda,
mesmo tema, mesmo ficheiro.
