---
tags: [docs, ui, artes, cliente]
data: 2026-09-13
---

# 2026-09-13 - Artes visuais e roadmap de UI

> Hub `12-UI-e-Artes/` e livro de evolucao no vault. Sem C++ nesta
> sessao. Artes novas: Antigravity + Gemini -> Cliente Full.

## O que foi feito

- Varredura do que ja existe de arte e de onde o exe le arquivo
  (`C:\Cliente Full`).
- Pasta `12-UI-e-Artes/` (mapa, inventario, onde vivem, roadmap,
  como gerar artes).
- ADR 0005; tres specs rascunho (distribuidor, armazem, organizar).
- Recap de artes. Capa do vault reescrita como livro (mundo / historia /
  regras / caminho) + [[Onde-Escrever]] + [[Tres-Diretorios]].
- Regras Cursor: `05-directories-and-art.mdc`; tres caminhos em `00`,
  `10`, `15`.

## Decisoes tomadas

- Distribuidor = ImGui; armazem e inventario ficam pedra (ADR 0005).
- Enviar item = correio para outro personagem, 168h.
- PNG/TGA: Antigravity (Gemini), nao o Cursor.
- Tres diretorios: Cliente Full / Source Priston / doc-projeto.
- Ordem sugerida de codigo (editavel no roadmap): organizar inventario
  -> armazem (busca/textura, paginas por ultimo) -> distribuidor.

## Problemas encontrados

- Login: mesmos nomes na source e no cliente, **tamanhos diferentes**.
- Codigo pede `bg_servers.png` e `seasonal_overlay.png` que nao existem.
- PostBox atual nao tem TTL nem envio entre jogadores; armazem e 100
  slots num blob — paginas mexem em protocolo/save.

## Proximos passos

- Quando for codar: colar a spec no Cursor e pedir a lista de arquivos
  **antes** de editar (`Processo-Spec-Driven`).
- Arte de char select: seguir o prompt em
  `Source-Priston/docs/prompt-antigravity-charselect-ui.md` e gravar no
  Cliente Full.
- Opcional: copiar o PNG de login aprovado para um lado so, para as
  duas pastas nao mentirem uma para a outra.

## Notas soltas

- Vault: `C:\Users\carol\Desktop\doc-projeto`.
- Cliente: `C:\Cliente Full`.
- Nao criar regra Cursor 17 nesta sessao — direcao de arte ficou no
  vault (`Como-gerar-artes`) e na regra `05-directories-and-art.mdc`;
  janela ImGui nova continua na regra 15.
