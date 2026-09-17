---
tags: [diario, servidor, ui]
status: feito
data: 2026-09-16
---

# 2026-09-16 - Painel Server.exe UX operador

## O que foi feito

Passada no `Server.exe`: o modal de confirmar desligar estava colado na
borda (herdava padding 0 da casca). Corrigido com estilo proprio de
popup. Status, header, jogadores e log passaram a mostrar mais estado
(ocupacao, pico, SQL, RAM, mapas, classe, filtro). Botoes alinhados ao
`ToolTheme`. Relatorio neste vault (changelog, recap, regra 16).

## Decisoes tomadas

Nenhuma ADR nova. Continua [[0002 - Duas identidades visuais jogador vs ferramenta]].
Nao cancelar a thread de shutdown de 8 minutos. Sem ping SQL por frame.
Sem ouro.

## Problemas encontrados

O `##ToolConfirm` chamava `OpenPopup` todo frame, tamanho fixo 188 px,
`WindowPadding` 0 e `ModalWindowDimBg` no default escuro do ImGui.
Por isso a janela de desligar parecia estranha.

## Proximos passos

Testar no `Server.exe` o modal, a pílula **A desligar**, copiar IP e o
filtro do log. Organizar inventario continua spec. Char select ainda TGA.

## Notas soltas

Jogador nao ve este painel. Recap:
[[2026-09-16 - Recap painel Server.exe modal e operador]].
