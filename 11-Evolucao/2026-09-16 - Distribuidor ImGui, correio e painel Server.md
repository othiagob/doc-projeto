---
tags: [evolucao]
status: feita
data: 2026-09-16
---

# 2026-09-16 - Distribuidor ImGui, correio e painel Server

## Resumo em 30 segundos

O NPC distribuidor deixou de ser um Yes/No de um item. Virou janela
ImGui (lista + envio P2P + prazo 168h), save `PB02`, transcodes novos
`0x48478A81`–`0x48478A85`. Codigo nasceu em 15/09; entrou no git da
source em 16/09. No mesmo bloco: splash/Segoe no `Server.exe` e clique
direito para guardar no bau. Inventario continua pedra.

## Linha do tempo

- 13/09: spec e ADR 0005 (distribuidor = ImGui, inventario = pedra).
- 15/09: bau no ar (ADR 0006) e codigo do correio (ADR 0007), ainda
  sem commit.
- 16/09: ritual do livro, commit da source, polimento do painel,
  `frame.png` do Distribuidor, clique direito no bau.

Fora deste bloco: char select TGA, botao organizar inventario.

## O que mudou (por area)

### Cliente

- `PostBoxWindow` (cromado 15 + titulo 400x64 + `frame.png` 760x540).
- Clique direito na bag com o bau aberto deposita o item.
- Titulos ImGui refeitos (Gemini). Nick da selecao de personagem
  um pouco mais baixo na placa.

### Servidor

- Writer unico PostBox, TTL, claim/refuse/send atomicos.
- Painel: splash de boot, Segoe, sidebar agrupada. `AdminChrome.h`
  removido.

### Shared / protocolo

- Tocou em `Shared/`? **sim** (`smPacket.h`)
- `smTRANSCODE_POSTBOX_OPEN` `0x48478A81`
- `smTRANSCODE_POSTBOX_LIST` `0x48478A82`
- `smTRANSCODE_POSTBOX_CLAIM` `0x48478A83`
- `smTRANSCODE_POSTBOX_REFUSE` `0x48478A84`
- `smTRANSCODE_POSTBOX_SEND` `0x48478A85`
- `ITEM_EXPRESS` `0x48478A80` permanece so a entrega apos o claim

### Banco

- Sem tabela nova. Lookup de nick offline: `UserInfo.Account`.

### Documentacao e regras Cursor

- Planta [[Distribuidor]], recap 15/09, ADR 0007, spec `feita`.
- Capa e backlog deixam de tratar o correio como spec.
- `15-imgui-windows.mdc`: `frame.png` e excecao pontual.
- `16-desktop-tools.mdc`: splash, Segoe, chips.

## Acertos (manter)

- Lista so com metadados em chunks (licao da loja / socket 8192).
- Save com magica + leitor legado; nao apagar o `.dat` no load.
- Writer unico (quest/loja/GM/P2P) — a caixa na memoria nao perde
  item novo.
- Identidade do Server.exe continua clara + azul.

## Falhas e experimentos revertidos (nao repetir)

Herdados, nao reabertos:

- Ouro ImGui no `Server.exe` (`AdminChrome`) — apagado de verdade
  neste bloco.
- 9-slice / PNG de janela inteira como padrao de jogador — o
  `frame.png` do Distribuidor e **excecao de uma tela**, nao o novo
  cromado.

## Decisoes importantes

- [[0007 - Distribuidor ImGui, PB02 e transcodes novos]]
- [[0002 - Duas identidades visuais jogador vs ferramenta]]
- [[0006 - Armazem ImGui, paginas no mesmo transcode]]

## Arquivos e assets

Repo do jogo: `PostBoxWindow`, `record.cpp` (PB02), `OnSever.cpp`,
`smPacket.h`, `ServerPanel` / `ToolTheme`, `sinInvenTory.cpp`.
Prompts: `docs/prompt-antigravity-distribuidor-ui.md`.
Cliente Full: `game/images/postbox/distribuidor.png` e `frame.png`.

## O que testar

1. NPC distribuidor abre lista, nao Yes/No.
2. Claim com inventario cheio / com espaco.
3. Enviar item a nick online e offline; recusar devolve P2P.
4. `/postbox_ttl 60` expira sem esperar 7 dias.
5. Splash do Server.exe durante o SQL.
6. Clique direito no bau.

## O que ainda confunde / proximo bloco

Organizar inventario (spec). Char select Fallen Tale (arte).
Passcode / 5 falhas do PostBox legado — conferir se ainda e usado.
