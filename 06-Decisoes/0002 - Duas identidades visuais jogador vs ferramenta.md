---
tags: [decisao, imgui, cliente, servidor]
status: aceita
data: 2026-09-08
---

# 0002 - Duas identidades visuais: jogador vs ferramenta desktop

## Contexto

Depois da janela **Desafios** (2026-09-06), as telas de jogador (Loja,
Configuracoes, Ranking, Mix, e as proximas) passaram a ser remodeladas em
ImGui. No mesmo periodo o `Server.exe` ganhou um painel ImGui (DirectX 9)
no mesmo hwnd dos sockets. A tentacao imediata foi copiar o cromado de
ouro do jogo para o servidor.

## Opcoes consideradas

1. **Um cromado so (ouro escuro) em client e Server.exe** — visual
   consistente, mas o servidor e ferramenta de operador, nao HUD de MMO.
   PNG de titulo 400x64 e bezel de ouro ficam deslocados numa janela
   Windows redimensionavel.
2. **ImGui cru / tema Armageddon global** — rapido, mas `StyleColorArmageddon()`
   pinta o tema **global** e suja todas as janelas do client.
3. **Duas identidades escritas em regra:** jogador = cromado escuro + ouro
   (`15-imgui-windows.mdc`); ferramenta desktop = claro suave + acento azul
   (`16-desktop-tools.mdc`).

## Decisao

Opcao 3.

- Jogador (`SrcGame`): `HUD/ImGuiWindowChrome.h` (`DrawPlayerWindowChrome`).
  Layout de referencia: `QuestWindow.cpp`. Cromado polido de referencia:
  `Settings.cpp`. HUD classico de pedra (`sinbaram/`) **nao** migra ate
  pedido explicito.
- Ferramenta (`SrcServer`, `Server.exe`): `HUD/ToolTheme.h`. X nativo
  **minimiza**; sair/desligar so com confirmacao. Se o DirectX falhar, o
  mundo continua no console.
- `AdminChrome.h` no servidor e leftover da tentativa da opcao 1 — nao e
  a identidade adotada. Nao reative sem ADR nova.

Novos detalhes de cromado de jogador **so entram na regra 15** quando o
usuario pedir para adotar algo ja polido no jogo. Nao inventar visual
paralelo "so desta tela".

## Consequencias

- Toda tarefa de janela de jogador comeca lendo `15-imgui-windows.mdc` do
  comeco ao fim.
- Toda tarefa de painel do `Server.exe` le `16-desktop-tools.mdc`.
- Custo: dois temas para manter. Beneficio: o operador nao trabalha num
  "jogo dentro do servidor", e o jogador nao ve UI de formulario Windows.
