---
tags: [cliente, quest, feature, imgui]
data: 2026-09-06
---

# 2026-09-06 - Janela de Desafios ImGui

> Sessao de cliente: redesign da aba de quests (tecla Q). Recap completo
> em [[2026-09-06 - Recap Desafios ImGui]].

## O que foi feito

- Janela Desafios reorganizada (cromado proprio, lista agrupada, detalhe +
  rodape, popup de cancelar, faixa de nivel nas repetitivas).
- Titulos em PNG recortado (`desafios.png`, `emandamento.png`).
- Taskbar de progressao: arrastar, minimizar, clique no nome, barra verde
  quando pronta para entregar; clique nao move o personagem.
- `MapasWU8` voltou a ANSI para o minimapa; ImGui converte com `ToUtf8()`.
- Experimento pergaminho/bordas revertido.
- Pasta nova no vault: `10-Processos/` (template + este recap).

## Decisoes tomadas

- Visual de janela nova de jogador = cromado de Desafios, sem
  `StyleColorArmageddon()` (ver `.cursor/rules/15-imgui-windows.mdc`).
- Confirmacao de cancelar fica no ImGui, nao no `cMessageBox`.
- Q abre a janela grande; overlay e por "Visualizar progressao".
- Array de nomes de mapa nao pode ser UTF-8: o minimapa usa `DrawTextA`.

## Problemas encontrados

- PNG 1274x832 no titulo encolhia o texto ate ficar ilegivel.
- UTF-8 em `MapasWU8` gerou `IlusÃµes` no minimapa.
- Clique na taskbar vazava para o mapa (personagem andava).

## Proximos passos

- [x] Copiar o cromado para Shop/Ranking (feito 2026-09-08 — ver sessao
  `11-Evolucao`)
- [ ] Nao retomar pergaminho/bordas sem recorte e tamanho de asset certos

## Notas soltas

- Nao mexeu em `Shared/` nem no servidor. Logica de quest continua a mesma.
- Encerramos o bloco de quests window neste dia; proximas sessoes em outro
  assunto ou recap em `10-Processos/`.
