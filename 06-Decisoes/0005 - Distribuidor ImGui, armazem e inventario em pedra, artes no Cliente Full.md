---
tags: [decisao, imgui, cliente, artes]
status: aceita
data: 2026-09-13
---

# 0005 - Distribuidor ImGui, armazem e inventario em pedra, artes no Cliente Full

> **Atualizacao 2026-09-15:** a parte "armazem fica pedra" foi
> **substituida** por [[0006 - Armazem ImGui, paginas no mesmo transcode]].
> Distribuidor ImGui e inventario de pedra nesta ADR **continuam**.

## Contexto

A ADR [[0002 - Duas identidades visuais jogador vs ferramenta]] definiu
o cromado ImGui para janelas **novas** de jogador e deixou o HUD de pedra
(`sinbaram/`, inventario, HP) ate pedido explicito.

Em 2026-09-13 o pedido explicito chegou, mas **nao para tudo**: o
distribuidor deve ficar no mesmo layout trabalhador das Desafios
(lista + detalhe); o armazem deve melhorar **sem** sair da pedra; o
inventario so ganha um botao de organizar.

No mesmo periodo ficou claro que a pasta `game/images` na source nao e o
que o `game.exe` le — o working directory e `C:\Cliente Full`.

## Opcoes consideradas

1. **Migrar distribuidor, armazem e inventario para ImGui** — visual
   unico, mas o armazem/inventario sao grade de slots 22px com drag-and-drop
   legado. Reescrever isso em ImGui e um projeto enorme e facil de
   duplicar item.
2. **Nao migrar ninguem** — so textura no distribuidor classico (Yes/No
   de um item). Nao atende a lista pendente nem o envio para outro
   personagem.
3. **Hibrido:** distribuidor = ImGui (tela nova, fluxo de lista); armazem
   e inventario = pedra, com paginas/busca/botao. Artes de runtime no
   Cliente Full; source `game/images` e copia opcional.

## Decisao

Opcao 3.

- **Distribuidor:** janela ImGui, contrato `15-imgui-windows.mdc`, layout
  de `QuestWindow.cpp`. Spec: [[2026-09-13-distribuidor-correio]].
- **Armazem:** `cWareHouse` + BMP em `Image\SinImage\Shopall\`. Paginas,
  textura, busca. Spec: [[2026-09-13-armazem-paginas-busca]].
- **Inventario:** `cINVENTORY` de pedra; um botao organizar. Spec:
  [[2026-09-13-inventario-organizar]].
- **Artes:** o exe le `C:\Cliente Full`. A pasta na source nao substitui
  o cliente. Detalhe: [[Onde-vivem-as-imagens]].

A ADR 0002 continua valida para o `Server.exe` (tema claro, acento azul)
e para nao inventar cromado paralelo em janela ImGui.

## Consequencias

- Pedido explicito de migrar **uma** tela de pedra (distribuidor) nao
  autoriza migrar as outras.
- Paginas de armazem e correio 168h mexem em save/protocolo — specs
  obrigatórias, os dois lados, sem inventar `smTRANSCODE_*` sem procurar
  em `smPacket.h`.
- Gerar arte com outra IA: gravar no Cliente Full no caminho que o C++
  ja pede. Copiar para a source so se quiser o Cursor ver ou versionar.
- Hub vivo: `12-UI-e-Artes/`.
