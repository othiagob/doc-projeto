---
tags: [specs, cliente, servidor, shared, ui]
status: feita
data: 2026-09-13
---

# Spec: Distribuidor / correio (ImGui + envio + 168h)

## Contexto

O NPC distribuidor hoje e um correio **so de receber**: o servidor manda
**um** item (`smTRANSCODE_ITEM_EXPRESS`, `0x48478A80`), o jogador confirma
num Yes/No (`sinMessageBox`). Nao ha lista, nao ha prazo, o jogador nao
envia item para outra pessoa. Quest, loja e eventos ja depositam no
PostBox (`Data\PostBox\<usercode>\<id>.dat`). `POST_ITEM_MAX` = 500.
A struct `_POST_BOX_ITEM` **nao tem data**.

Queremos o mesmo tipo de tela das Desafios: lista a esquerda, detalhe a
direita, cromado ImGui. Poder **enviar** um item real do inventario
(machado, armadura, force, pocoes de mana) para **outro personagem**.
O destinatario tem **168 horas** para aceitar.

Hub: [[Roadmap-UI]]. ADR visual: [[0005 - Distribuidor ImGui, armazem e inventario em pedra, artes no Cliente Full]].
ADR protocolo/save: [[0007 - Distribuidor ImGui, PB02 e transcodes novos]].
Planta: [[Distribuidor]]. Recap: [[2026-09-15 - Recap Distribuidor ImGui e correio 168h]].

## Escopo

- Janela ImGui ao falar com o NPC distribuidor (tipo GiftExpress / case 15).
- Lista de itens pendentes da conta/personagem (nao um popup por vez).
- Detalhe: icone BMP do item, nome, remetente, tempo restante, documento.
- Aceitar / recusar na janela (mesmo cromado; popup de confirmar se for
  destrutivo).
- Enviar: escolher item do inventario, nome do personagem destino,
  confirmar. Servidor tira o item **antes** de gravar no PostBox.
- TTL **168 horas** a partir do deposito. Proposta padrao se expirar:
  **devolver ao remetente** (PostBox dele) se a conta ainda existir;
  se nao existir, logar e descartar. Cravar isto antes de codar se
  quiser outro comportamento (sumir / ficar para sempre).
- Titulo PNG 400x64 no Cliente Full, ex.:
  `game/images/postbox/distribuidor.png` (nome final na implementacao;
  fallback texto `DISTRIBUIDOR`).
- Clique na janela nao anda o personagem (`IsBlockingMouse` /
  `WantCaptureMouse`).
- Manter o que ja funciona: deposito por quest/loja/GM continua
  alimentando a mesma caixa.

## Fora de escopo

- Armazem e botao organizar inventario
- Char select / login
- Enviar ouro como item separado (a menos que o fluxo atual de MONEY no
  arquivo PostBox ja cubra — nao expandir nesta spec)
- Anexo de varios itens num unico envelope
- Chat/correio de texto sem item
- Migrar o HUD de pedra

## Impacto em Shared / protocolo

- Toca em `Shared/`? **sim** (`smPacket.h`: `_POST_BOX_ITEM` precisa de
  remetente + timestamp/expiracao; fluxo de **lista** e de **envio**)
- Client e server precisam mudar **juntos**
- Novos `smTRANSCODE_*`? **provavelmente sim** (listar pendentes, enviar,
  recusar). **Nao** reaproveitar `smTRANSCODE_ITEM_EXPRESS` (`0x48478A80`)
  para outro significado. Procurar equivalente em `smPacket.h` antes de
  criar. Documentar cada codigo novo no CHANGELOG e nesta spec.
- Socket `smSOCKBUFF_SIZE` = 8192. Lista grande em **chunks** (mesmo
  padrao da loja `0x252031`).
- `POST_ITEM_MAX` 500: a UI lista; nao precisa mandar 500 de uma vez.

Codigos existentes a nao confundir:

| Codigo | Uso atual |
|---|---|
| `smTRANSCODE_ITEM_EXPRESS` `0x48478A80` | Entrega de um `sITEMINFO` apos o claim |
| `smTRANSCODE_POSTBOX_OPEN` `0x48478A81` | Abrir janela / pedir lista |
| `smTRANSCODE_POSTBOX_LIST` `0x48478A82` | Lista em chunks |
| `smTRANSCODE_POSTBOX_CLAIM` `0x48478A83` | Aceitar por `dwEntryId` |
| `smTRANSCODE_POSTBOX_REFUSE` `0x48478A84` | Recusar |
| `smTRANSCODE_POSTBOX_SEND` `0x48478A85` | Enviar item + resultado |
| `smTRANSCODE_OPEN_EVENTGIFT` `0x4847004F` | NPC de evento — **nao** e PostBox |

## Modulos afetados

- [x] SrcGame: `HUD/PostBoxWindow`; `netplay.cpp`; mouse/ESC em
      `GameCore` / `Winmain` / `sinMain`. Yes/No deixa de ser a UI da fila.
- [x] SrcServer: `OnSever.cpp`, `record.cpp` (PB02), writers em
      `Quest.cpp` / `NewShop.cpp`, NPC em `Svr_Damge.cpp`
- [x] Shared: `smPacket.h` (struct + transcodes `0x48478A81`–`0x48478A85`)

## Comportamento esperado

**Antes:** fala com o NPC -> uma caixa "quer este item?" -> sim/nao.
Fila invisivel. Sem envio entre jogadores. Sem prazo.

**Depois:** fala com o NPC -> janela lista + detalhe. Ve o que tem para
coletar, quanto tempo falta, de quem veio. Pode aceitar (inventario com
espaco) ou recusar. Pode enviar um item seu para outro nick. Item some
do inventario na hora do envio (servidor). Depois de 168h sem aceite,
proposta: volta para o remetente.

## Plano de teste manual

1. Quest/loja que ja manda para o distribuidor: o item aparece na **lista**,
   nao so no Yes/No antigo.
2. Aceitar com inventario cheio — recusa clara, item continua pendente.
3. Aceitar com espaco — item no inventario, some da lista, arquivo PostBox
   sem aquele Flag.
4. Enviar machado/armadura/force/pocao para outro personagem online e
   offline. Remetente perde o item na hora. Destino ve na lista.
5. Recusar envio recebido — item nao duplica; definir na implementacao se
   volta ao remetente (alinhar com expiracao).
6. Deixar um item ~168h (ou clock de teste/GM) — devolve ou descarta
   conforme a decisao cravada.
7. Clique na janela — personagem parado.
8. Titulo PNG presente e ausente (fallback texto).
9. Dois clientes: nao duplicar o mesmo item (log do servidor).

## Riscos conhecidos

- **Dupe:** qualquer envio/claim tem que ser atomico no servidor.
  Nunca confiar no client "eu tirei do inventario".
- Mudar `_POST_BOX_ITEM` quebra o parser do `.dat` antigo — precisa de
  formato com versao ou campos extras no fim da linha, com load que
  aceite arquivo velho (sem data = sem TTL, ou TTL infinito para legado).
- Pacote unico > 8192 (loja ja ensinou).
- Icone BMP: mesmo contrato da loja (`itCODIGO.bmp`); sem arquivo =
  `NO IMAGE`, nao inventar ItemCode.
- Passcode / 5 falhas (`PostPassFailCount`) — nao jogar fora sem ler o
  fluxo atual se ainda for usado.
