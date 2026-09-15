---
tags: [arquitetura, processo, documentacao]
status: ativo
data: 2026-09-15
---

# Como documentar uma funcionalidade grande

Quando o codigo muda o **fluxo** (quem guarda, quem desenha, qual
pacote, qual arquivo), o recap em `10-Processos/` conta o que o
jogador ve. Isso nao basta para a proxima IA (ou voce daqui a meses)
entender o desenho.

Modelo ja no livro: [[Armazem]].

## Quando criar a nota

Crie `02-Arquitetura/<NomeCurto>.md` se a mudanca tiver **pelo menos
dois** destes:

- Client e servidor juntos
- Struct / transcode / tamanho de blob (`Shared/`)
- Formato de save (`.war`, `.dat`, PostBox)
- Janela nova **e** logica antiga convivendo (ImGui pinta, `sinbaram`
  decide)

Nao precisa para: troca de cor, PNG de titulo, bug de uma linha,
texto da UI.

## O que a nota precisa ter

1. **Uma frase** — o desenho novo, sem jargao.
2. **Fluxograma de camadas** (quem fala com quem). Mermaid no Obsidian:
   `flowchart` ou `sequenceDiagram`.
3. **Fluxo feliz** — abrir, usar, gravar. Sequence se for rede.
4. **Onde mora no disco / no fio** — se houver save ou pacote. Cite o
   `smTRANSCODE_*` e o arquivo.
5. **O que nao mudou** — para ninguem reescrever o que ainda e legado.
6. **Link** a partir de [[Arquitetura]] (secao "Funcionalidades com
   fluxograma") e do recap em `10-Processos/`.

Nao copie o recap. Recap = jogador. Esta nota = planta.

## Depois de escrever

- Uma linha no recap: "Planta: [[NomeCurto]]".
- Se o "por que" mudou: ADR em `06-Decisoes/`.
- Ritual: [[Ritual-Documentacao]] passo dos fluxogramas.

Hub: [[Arquitetura]].
