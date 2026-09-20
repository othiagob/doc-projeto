---
tags: [evolucao]
status: ativo
data: 2026-09-17
---

# Evolucao: do `.war` ao SQL no armazem

> **Depois desta nota:** o SQL **nao fechou no jogo**. Em 2026-09-18 o
> save voltou para arquivo WH03. Leia
> [[2026-09-18 - Armazem WH03 e falhas SQL]] e a ADR
> [[0009 - Armazem arquivo WH03, SQL revertido]]. Esta pagina fica
> como historia do bloco 17/09, nao como planta atual.

Bloco 2026-09-15 (UI) + 2026-09-17 (capacidade/SQL). Nao apaga a nota
[[2026-09-15 - Recap Armazem ImGui paginas e busca]]; esta e a memoria
do **porquê** da segunda virada.

## Linha do tempo

1. **Classico** — `cWAREHOUSE` pinta e arrasta; 100 slots; `.war`.
2. **15/09** — pintura ImGui; 3 paginas WH02; busca; drag intocado.
3. **Dor** — 9×9 × 22 px. Pedido de mais slots + anti-dupe + SQL.
4. **Descartes** — so zoom visual; WH03 com 300 `sITEM` no pacote;
   database extra no boot; 5 abas no dia 1.
5. **17/09** — UserDB, 300×5/3, `wVersion=3` ocupados, unique Head+ChkSum.

## O que falhou / nao voltar sem ADR

| Tentativa | Por que nao |
|---|---|
| Drag 100% ImGui | Falhas 15/09; dupe se overlap errar |
| `Data[]` = 300 `sITEM` | Socket 8192; stack |
| Novo `smTRANSCODE_*` | Contrato; 0006 ja prova o mesmo codigo |
| `WarehouseDB` no boot | `exit(0)` se o nome faltar |
| Schema no `server.exe` | Convencao: SSMS + vault |

## O que ficou

Hibrido 0006 + persistencia 0008. Paginas 4–5 so no SQL/RAM ate o
Thiago pedir unlock.

## Testar daqui a meses

Personagem com `.war` WH02 antigo ainda importa uma vez?
Dois PCs mesma conta: o segundo save perde por Revision?
Unique SQL segura item copiado (Head != 0)?
