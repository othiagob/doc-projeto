---
tags: [processos, cliente, artes, ui]
status: parcial
data: 2026-09-13
modulo: cliente, docs
---

# 2026-09-13 - Recap artes de login e titulos ImGui

Documentacao do que o jogador ja ve em arte, separado do cromado ImGui
de 2026-09-06/08 (esse bloco ja tem recap proprio). Hub vivo:
[[index]] em `12-UI-e-Artes/`. Inventario detalhado:
[[Inventario-de-Artes]]. Onde copiar arquivo: [[Onde-vivem-as-imagens]].

## Como era

Login de conta e selecao de personagem usavam a arvore classica
`StartImage` / BMP antigo. As janelas ImGui novas (Desafios, Lojas,
Ranking, Mix, Configuracoes) passaram a pedir titulo PNG 400x64 no
cliente. Nao havia no vault um mapa "arte feita vs arte so no disco vs
arte ainda classica". A pasta `game/images` na source parecia ser "a
pasta do jogo" — nao e.

## O que o jogador ve agora

- Titulos ImGui recortados nas telas ja padronizadas (mesmo arquivo na
  source e no `C:\Cliente Full`).
- Login de conta com kit PNG Fallen Tale (`bg1`, painel, Entrar/Sair,
  seletor). O exe le o Cliente Full; a copia na source pode estar
  diferente (tamanhos divergentes em 2026-09-13).
- Selecao / criacao de personagem **ainda classica** (`StartImage\Login\`,
  TGA). Existe um prompt de substituicao arquivo-a-arquivo no repo do
  jogo (`docs/prompt-antigravity-charselect-ui.md`), nao aplicado.

## O que implementei (e por que)

Nesta data: **so documentacao no vault** (nenhum C++). Por que: as artes
ja estavam no cliente/source e o roadmap (distribuidor, armazem,
organizar inventario) precisava de um lugar para nao misturar "feito"
com "ideia".

O cromado ImGui em si foi o bloco 2026-09-08 — ver
[[2026-09-08 - Recap janelas ImGui de jogador]].

## Arquivos tocados

No repo do jogo: nenhum nesta sessao de docs.

Assets que o jogo ja carrega (Cliente Full):

- `game\images\login\` (PNG de conta)
- `game\images\shop|quest|settings|ranking|mix\` (titulos)
- `StartImage\login\` (char select classico)

Vault: pasta `12-UI-e-Artes/`, ADR 0005, tres specs em rascunho.

## Shared / protocolo

- Tocou em `Shared/`? nao
- Transcodes novos? nenhum

## O que testar

1. Subir o client pelo F5 — fundo de login e o PNG do Cliente Full, nao
   o da source.
2. Abrir Desafios / Loja / Ranking / Mix / Config — titulo PNG, nao texto.
3. Char select — ainda TGA antigo (esperado).

## O que ficou de fora / proximos passos

- Sincronizar bytes de login source vs cliente (operacional, nao codigo).
- Gerar/aplicar TGA de char select.
- Implementar as tres specs: [[2026-09-13-inventario-organizar]],
  [[2026-09-13-armazem-paginas-busca]],
  [[2026-09-13-distribuidor-correio]].

## Aprendizado

O caminho no C++ e relativo ao `game.exe`. Duplicar PNG na source so
ajuda o Cursor e o git — o jogador so ve o Cliente Full. Duas arvores
de login: `game\images\login\` (conta) e `StartImage\Login\` (personagem).
