---
tags: [specs, cliente, ui]
status: rascunho
data: 2026-09-13
---

# Spec: Botao organizar inventario

## Contexto

O inventario e `cINVENTORY` (`sinInvenTory.h` / `.cpp`):
`INVENTORY_MAXITEM` = 100, grade **12x6** celulas de 22px, 16 posicoes
de equipamento (`INVENTORY_MAX_POS`). Existe `AutoSetInvenItem` para
**encaixar um item novo**, nao para arrumar a bag. Outros Pristons tem
um botao que compacta/agrupa; e o pedido desta spec.

O inventario **fica pedra**. Nao e redesign. ADR:
[[0005 - Distribuidor ImGui, armazem e inventario em pedra, artes no Cliente Full]].

## Escopo

- Um botao no HUD do inventario (BMP no estilo dos botoes ja existentes,
  arte no Cliente Full).
- Ao clicar: reorganizar **so a bag** (os 100 slots de `InvenItem`).
  Proposta de ordem: agrupar por tipo/codigo, depois preencher buracos
  da esquerda para a direita, cima para baixo — o mesmo criterio de
  grade que o jogo ja usa (celulas 22px, item 1x1 / 2x2 / etc. tem que
  **caber**, nao so reordenar o array).
- Nao mover os 16 slots de equipamento.
- Nao misturar com armazem, trade, craft, aging, shop pessoal — se
  alguma dessas janelas estiver aberta, o botao nao roda (ou fica
  desabilitado).
- Persistencia: usar o save de inventario que ja existe. Confirmar na
  implementacao que um rearrange local seguido do save habitual basta
  (expectativa: **sem** transcode novo). Se o servidor valida layout
  slot a slot e rejeita, parar e documentar — nao forcar.

## Fora de escopo

- Redesign ImGui do inventario
- Organizar armazem (pode ser ideia futura na spec do armazem)
- Sort no equipamento
- Stack automatico de pocoes alem do que o jogo ja faz ao juntar
- Atalho de teclado (so o botao, a menos que caiba sem escopo extra)

## Impacto em Shared / protocolo

- Toca em `Shared/`? **nao** (expectativa)
- Transcodes novos? **nenhum** (expectativa)
- Se na implementacao o save exigir pacote extra, **parar** e atualizar
  esta spec antes de inventar codigo em `smPacket.h`

## Modulos afetados

- [ ] SrcGame: `sinInvenTory.cpp` / `.h` (botao, rotina de sort que
      respeita ocupacao 2D); arte BMP no Cliente Full; talvez
      `sinInterFace.cpp` (hit-test)
- [ ] SrcServer: so se o save atual quebrar — senao nao mexer
- [ ] Shared: nao

## Comportamento esperado

**Antes:** itens espalhados, buracos no meio, so da para arrumar a mao.

**Depois:** um clique agrupa e compacta a bag. Equipado continua igual.
Relogar: a ordem nova permanece.

## Plano de teste manual

1. Bag baguncada com itens 1x1 e 2x2 — depois do clique, sem overlap e
   sem item "flutuando" fora da grade.
2. Equipamento (arma, armadura, aneis) inalterado.
3. Relogar — bag continua organizada.
4. Com trade / armazem / craft abertos — botao nao bagunca o outro
   painel.
5. Inventario cheio sem buracos — clique e no-op seguro (sem crash).
6. Quest item / item bound — continua no inventario, mesmo codigo.

## Riscos conhecidos

- Itens ocupam **retangulo na grade**, nao um indice linear. Sort burro
  por array quebra 2x2 (overdraw, item sumido).
- `InvenItemTemp` / backup usados pelo armazem — nao corromper o backup
  no meio de um deposito.
- Checksum de inventario no servidor se existir validacao estrita de
  posicao.
