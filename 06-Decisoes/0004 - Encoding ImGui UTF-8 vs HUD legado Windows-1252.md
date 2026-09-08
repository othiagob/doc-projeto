---
tags: [decisao, imgui, encoding, cliente, servidor]
status: aceita
data: 2026-09-08
---

# 0004 - Encoding: ImGui em UTF-8; HUD/chat legado em Windows-1252

## Contexto

O client mistura dois sistemas de texto:

- **ImGui** espera UTF-8.
- HUD antigo, minimapa e chat usam **Windows-1252** (`DrawTextA`, buffers
  ANSI).

Uma tentativa de colocar UTF-8 no array compartilhado `MapasWU8` corrigiu
Desafios e quebrou o minimapa (`F. das Ilusoes` virou `IlusÃµes`). Outra
tentativa de acento em `Alert()` do servidor com string UTF-8 no fonte
chegou errada no chat. No MSVC, `"\xEDdo"` junta o hex (`\xED` + `d` +
`o` vira um numero hex maior).

## Opcoes consideradas

1. **Migrar o client inteiro para UTF-8** — correto a longo prazo, mas
   toca `sinbaram/`, minimapa, chat, dezenas de buffers. Fora de escopo.
2. **Um array so, encoding "o que funcionar na tela que estamos vendo"** —
   quebra a outra tela.
3. **Converter na borda:** quem desenha ImGui chama `ToUtf8()` (ou
   equivalente). Arrays compartilhados e `Alert()` do servidor ficam
   Windows-1252. Nao editar `imGui/` nem `STRCLASS` / `MapasWU8` /
   `WChar_to_UTF82` so para acento.

## Decisao

Opcao 3.

Regras praticas:

- Nao colocar UTF-8 em `MapasWU8`.
- Chat do client: acentos em `Alert()` com `\xNN` (Windows-1252). Se a
  letra seguinte for `0-9` / `a-f`, quebrar a string: `"\xED" "do"`.
- ImGui: strings UTF-8 no fonte **ou** conversao na hora de desenhar.
- Nao "consertar encoding" mexendo no nucleo do ImGui vendorizado em
  `SrcGame/src/Game/imGui/`.

## Consequencias

- Toda tela ImGui nova precisa converter nomes de mapa / item legado.
- Chat e quest alert no servidor nao usam os mesmos literais que o titulo
  PNG da janela ImGui.
- Custo: dois encodings para sempre, ate uma migracao consciente.
