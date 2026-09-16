---
tags: [decisao, imgui, cliente, servidor, shared]
status: aceita
data: 2026-09-15
---

# 0007 - Distribuidor ImGui, PB02 e transcodes novos

## Contexto

A ADR [[0005 - Distribuidor ImGui, armazem e inventario em pedra, artes no Cliente Full]]
ja cravou: distribuidor = ImGui, inventario = pedra. A spec
[[2026-09-13-distribuidor-correio]] pedia lista + envio P2P + TTL 168h
sem reusar `smTRANSCODE_ITEM_EXPRESS`.

O baú (ADR [[0006 - Armazem ImGui, paginas no mesmo transcode]]) ensinou
a nao inflar pacote e a nao dump cego de struct C++ no arquivo.

## Opcoes consideradas

1. **Estender `ITEM_EXPRESS`** — um codigo para abrir, listar, claimar e
   enviar. Barato no fio; mistura significados e estoura 8192 se mandar
   `sITEMINFO` da fila.
2. **Lista com item cheio** — o destino ve o machado aged de verdade ja
   no OPEN. Pacote grande, risco de dupe na UI.
3. **Transcodes novos + metadados na lista + blob so no save/claim** —
   OPEN/LIST/CLAIM/REFUSE/SEND. `ITEM_EXPRESS` fica so a entrega de um
   `sITEMINFO` depois do claim. Save magica `PB02` com leitor de texto
   legado.

## Decisao

Opcao 3.

- Janela ImGui `PostBoxWindow` (contrato 15). Inventario continua pedra
  (ADR 0005).
- Codigos novos `0x48478A81`–`0x48478A85`. Nao reutilizar
  `ITEM_EXPRESS` (`0x48478A80`) para lista ou envio.
- Lista = metadados em chunks (`POSTBOX_LIST_CHUNK` 16). Claim por
  `dwEntryId` estavel.
- Arquivo `Data\PostBox\<usercode>\<id>.dat`: magica `PB02`
  (`0x32304250`), leitor legado. Nao apaga no load. Save na hora
  (temp + replace).
- Item de jogador: blob `sITEMINFO`. Item de sistema (quest/loja):
  continua catalogo (`CreatePerfItem`) ate o claim.
- TTL 168h nos itens novos; legado sem data = sem prazo. Recusa e
  expiracao devolvem ao remetente; sistema descarta + log.
- Sem tabela SQL nova. Lookup de nick offline: `UserInfo.Account`.

## Consequencias

- Client e server sobem juntos (Shared).
- Titulo PNG `game/images/postbox/distribuidor.png` (Antigravity).
- Moldura PNG `game/images/postbox/frame.png` (760x540) so nesta janela.
  As outras ImGui de jogador continuam cromado `ImDrawList`.
- Comando GM `/postbox_ttl <segundos>` para testar sem esperar 7 dias.

Planta: [[Distribuidor]]. Recap: [[2026-09-15 - Recap Distribuidor ImGui e correio 168h]].
