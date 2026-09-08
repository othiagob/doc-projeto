---
tags: [cliente, servidor, imgui, loja, banco, feature]
data: 2026-09-08
---

# 2026-09-08 - Sessao especial: HUD ImGui, loja e painel

> Relato completo (falhas, acertos, decisoes):
> [[2026-09-08 - HUD ImGui lojas ranking mix e painel do servidor]].
> Pasta nova no vault: `11-Evolucao/`.

## O que foi feito

- Padrao visual de janela de jogador aplicado a Loja, Ranking, Mix,
  Configuracoes (alem de Desafios).
- Cromado extraido para `ImGuiWindowChrome.h`.
- Loja alinhada ao SQL real + pacotes em chunks.
- Painel ImGui do `Server.exe` (tema claro).
- Regras Cursor 15, 16, 40; ADRs 0002–0004.
- Commit e push do codigo (`Source-Priston`) e desta documentacao
  (`doc-projeto`).

## Decisoes tomadas

- Jogador != ferramenta desktop (ADR 0002).
- Catalogo SQL vs BMP no client (ADR 0003).
- Encoding na borda (ADR 0004).
- Nao versionar PNG de 9-slice (`game/images/ui/`).

## Problemas encontrados

- Ver tabela de falhas na sessao `11-Evolucao` (tema global, UTF-8 no
  minimapa, Discount, PainelDB, socket 8192, ouro no Server.exe).

## Proximos passos

- Party e outras janelas ImGui ainda fora do padrao.
- Nao migrar `sinbaram/` sem pedido.
- Preferir commits menores por tela da proxima vez.

## Notas soltas

- Vault vivo neste PC: `C:\Users\carol\Desktop\doc-projeto`.
- Cliente full: `C:\Cliente Full` (working directory do F5).
- Copiar PNG de `game/images/` da source para o cliente full se o titulo
  cair em texto.
