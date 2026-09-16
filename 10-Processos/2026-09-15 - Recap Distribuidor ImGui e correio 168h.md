---
tags: [processos]
status: feito
data: 2026-09-15
modulo: cliente, servidor, shared
---

# 2026-09-15 - Recap Distribuidor ImGui e correio 168h

## Como era

Falar com o NPC distribuidor abria um Yes/No de **um** item
(`smTRANSCODE_ITEM_EXPRESS`). A fila era invisivel. O arquivo PostBox
era texto sem data; o load **apagava** o `.dat`; o save so no logout.
Quest/loja anexavam no arquivo — se a caixa ja estava na memoria, o
item novo sumia ate o relog. Nao dava para enviar item real (aged/mix)
para outro personagem.

## O que o jogador ve agora

Janela ImGui no cromado das Desafios: aba **Receber** (lista + detalhe)
e aba **Enviar**. Aceitar / recusar na propria janela. Inventario cheio
mostra recado e o item **continua** na lista. Enviar pede nick + item
do inventario. Prazo de 7 dias nos itens novos; legado antigo nao
expira. Inventario ao lado continua pedra.

- Titulo PNG: `game/images/postbox/distribuidor.png` (400x64). Moldura
  PNG: `game/images/postbox/frame.png` (760x540, blit 1:1) — **excecao
  so desta janela**. Se o titulo faltar, texto `DISTRIBUIDOR`. Prompt:
  `docs/prompt-antigravity-distribuidor-ui.md`.

## O que implementei (e por que)

- Transcodes novos `0x48478A81`–`0x48478A85` para nao misturar lista/envio
  com a entrega ja existente de `ITEM_EXPRESS`.
- Lista so com metadados em chunks — o socket de 8192 nao aguenta 500
  `sITEMINFO`.
- Magica `PB02` + leitor de texto legado; save atomico na hora; writer
  unico para quest/loja/GM/P2P. Licao do bau (ADR 0006): nao dump da
  struct com ponteiro, nao apagar o arquivo no load.
- Claim por `dwEntryId`. P2P grava blob `sITEMINFO`; sistema ainda nasce
  do catalogo no claim.
- Recusa e TTL devolvem ao remetente; item de sistema some + log.
- `/postbox_ttl` no GM para testar sem esperar 168h.

## Arquivos tocados

- `Shared/smPacket.h`
- `SrcGame/src/Game/HUD/PostBoxWindow.cpp` / `.h`
- `SrcGame/src/Game/netplay.cpp`, `GameCore.cpp`, `Winmain.cpp`,
  `HUD/InstancesFlag.cpp`, `sinbaram/sinMain.cpp`, `game.vcxproj`
- `SrcServer/.../Character/record.cpp`, `OnSever.cpp`, `Svr_Damge.cpp`,
  `Quest/Quest.cpp`, `Shop/NewShop.cpp`, `GM/ServerCommand.cpp`
- `docs/prompt-antigravity-distribuidor-ui.md`
- `game/images/postbox/distribuidor.png`, `game/images/postbox/frame.png`

## Shared / protocolo

- Tocou em `Shared/`? sim
- Transcodes: `POSTBOX_OPEN` `0x48478A81`, `LIST` `0x48478A82`,
  `CLAIM` `0x48478A83`, `REFUSE` `0x48478A84`, `SEND` `0x48478A85`.
  `ITEM_EXPRESS` `0x48478A80` permanece so a entrega do item claimado.

## Como testar

1. Recompensa de desafio aparece na lista, nao no Yes/No.
2. Aceitar com inventario cheio — recado, item pendente.
3. Aceitar com espaco — some da lista, entra no inventario.
4. Enviar machado/pocao para nick online e offline.
5. Recusar envio P2P — volta ao remetente. Recusar quest — some.
6. Clique na janela: personagem parado. ESC fecha.
7. PNG on/off. GM `/postbox_ttl 60` para expirar rapido.

## Proximo passo natural

Organizar inventario continua spec a parte. Char select ainda TGA.
