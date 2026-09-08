---
tags: [processos, cliente, imgui, feature]
status: feito
data: 2026-09-08
modulo: cliente
---

# 2026-09-08 - Recap janelas ImGui de jogador

Bloco que copiou o padrao de Desafios para Loja, Ranking, Mix e
Configuracoes. Relato completo: [[2026-09-08 - HUD ImGui lojas ranking mix e painel do servidor]].
Contrato: `.cursor/rules/15-imgui-windows.mdc`. ADR: [[0002 - Duas identidades visuais jogador vs ferramenta]].

## Como era

Cada tela ImGui de jogador tinha cara propria (ou o tema global
Armageddon). Ranking/Mix/Shop nao compartilhavam bezel, titulo PNG nem
bloqueio de mouse. Clique na UI andava o personagem. Configuracoes ja
tinha o visual mais polido; as outras ainda nao.

## O que o jogador ve agora

Mesmo cromado escuro + ouro fino em Desafios, Configuracoes, Loja de
Coins, Loja de Tempo, Ranking e Mix. Titulo em PNG recortado. Clique na
janela nao move o personagem. Inventario e HP continuam no HUD de pedra.

## O que implementei (e por que)

- `ImGuiWindowChrome.h` — um bezel so. Por que: copiar retangulos em
  cinco `.cpp` diverge na primeira correcao.
- `IsBlockingMouse` + `WantCaptureMouse` em `GameCore` / `Winmain`. Por
  que: o jogo trata clique no chao como andar.
- Titulos PNG no git (`game/images/...`) e no cliente full. Por que: o
  exe le o working directory, nao a source.

## Arquivos tocados

- `SrcGame/src/Game/HUD/ImGuiWindowChrome.h`
- `QuestWindow.*`, `Settings.*`, `NewShop.*`, `NewShopTime.*`,
  `RankingWindow.*`, `MixWindow.*`, `InstancesFlag.cpp`, `GameCore.cpp`,
  `Winmain.cpp`, `sinbaram/sinMain.cpp` (e vizinhos de mouse)
- `.cursor/rules/15-imgui-windows.mdc`

## Shared / protocolo

- Tocou em `Shared/`? nao
- Transcodes novos? nenhum. Ranking `0x51800010`, Mix `0x51800012`, loja
  `0x252030`–`0x252032` (existentes).

## O que testar

1. Abrir cada janela — cromado e titulo PNG.
2. Clicar dentro — personagem parado.
3. Inventario — visual legado.

## O que ficou de fora

Party e demais telas ImGui antigas. HUD de pedra. 9-slice PNG.

## Aprendizado

Push/Pop de estilo e por janela. Rounding nativo do ImGui no DirectX
desta engine nao reproduz o mockup — desenhe o contorno.
