---
tags: [processos]
status: feito
data: 2026-09-16
modulo: servidor
---

# 2026-09-16 - Recap painel Server.exe splash e Segoe

## Como era

O `Server.exe` ja tinha janela ImGui clara (ADR 0002, recap
[[2026-09-08 - Recap loja SQL e painel Server]]). A ligacao SQL
acontecia com a janela vazia ou atrasada. Sidebar era lista chata de
botoes. Fonte padrao do ImGui (ProggyClean). `AdminChrome.h` ainda
existia como leftover da tentativa de ouro no servidor.

## O que o operador ve agora

Splash a ecrã inteiro enquanto os bancos e o mundo sobem, com spinner,
barra e as ultimas linhas do `cout`. Depois, header com online/uptime,
sidebar em grupos (Monitorar / Operar), item selecionado com filete
azul, cards de metrica iguais. Fonte Segoe UI do Windows. X nativo
continua **minimizando**; sair/desligar pede confirmacao.

O jogador **nao** ve isto. E ferramenta desktop, nao HUD Fallen Tale.

## O que implementei (e por que)

- `ServerPanel_IsBooting` / `SetBootStatus` / `PumpBoot` / `SetReady`
  para a UI existir **antes** do `initializeSQL` e nao congelar no
  primeiro bind.
- Segoe 16/13/22 — ProggyClean e fonte de debug, ilegivel num painel
  de operador.
- Sidebar e cards desenhados no `ImDrawList` do `ToolTheme` (filete
  de 3 px, hover). Abas de config viram chips (`ToolChipTab`).
- `AdminChrome.h` apagado: a sessao 08/09 ja tinha condenado o ouro
  no servidor.

## Arquivos tocados

- `SrcServer/src/Server/HUD/ServerPanel.cpp` / `.h`
- `SrcServer/src/Server/HUD/ToolTheme.h`
- `SrcServer/src/Server/HUD/ServerConfigPages.cpp`
- `SrcServer/src/Server/HUD/AdminChrome.h` (apagado)
- `SrcServer/src/Server/Winmain.cpp`
- `SrcServer/src/Server/Database/SQLConnection.cpp`
- `.cursor/rules/16-desktop-tools.mdc`

## Shared / protocolo

- Tocou em `Shared/`? nao
- Transcodes novos? nenhum

## O que testar

1. Subir o `Server.exe` — splash mostra cada banco (`A ligar UserDB...`).
2. Depois do bind, dashboard com online/uptime. X minimiza.
3. Trocar de pagina na sidebar (filete no item ativo).
4. Confirmar desligar. Abrir uma aba de config (chips refluem).

## O que ficou de fora / proximos passos

Mapeamento de todas as tabelas no painel. Ouro de jogador no
`Server.exe` continua **proibido**.

## Aprendizado

Ferramenta desktop precisa de pump de mensagens no boot — senão o
Win32 nao pinta enquanto o ODBC bloqueia a thread principal.
