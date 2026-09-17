---
tags: [evolucao, moc]
status: ativo
data: 2026-09-08
---

# Evolucao do projeto — sessoes especiais

Esta pasta e a **memoria longa** do Source Priston: nao e o rascunho do dia
(`04-Diario-do-Projeto/`) nem o recap de uma tela so (`10-Processos/`). Aqui
fica o relato completo de um **bloco de trabalho** — o que deu certo, o que
falhou e foi revertido, as decisoes que nao podem se perder, e o que testar
daqui a meses.

Use quando um periodo de dias (ou uma sprint) mudou varias areas ao mesmo
tempo e voce quer um unico documento pra reler.

## Relacao com o resto do vault

```
ideia          -> 08-Ideias/
planejar       -> 05-Specs/
mapa de UI     -> 12-UI-e-Artes/
fazer          -> codigo no Windows (Source-Priston)
anotar o dia   -> 04-Diario-do-Projeto/
resumo 30s     -> CHANGELOG.md
recap de tela  -> 10-Processos/
decisao "por que" -> 06-Decisoes/ (ADR)
bloco inteiro  -> 11-Evolucao/   (esta pasta)
```

## Como criar uma sessao

1. Copie `TEMPLATE-Sessao.md`.
2. Nomeie `AAAA-MM-DD - titulo-curto.md`.
3. Seja honesto nas falhas. Experimento revertido vale mais que sucesso
   enfeitado — e exatamente o que a proxima IA (ou voce daqui a 3 meses)
   precisa para nao repetir o mesmo erro.
4. Linke ADRs e recaps de processo. Nao duplique tabelas enormes se ja
   existem em `02-Arquitetura/` — aponte e complete o que mudou.

## Indice

| Data | Sessao | Escopo |
|---|---|---|
| 2026-09-08 | [[2026-09-08 - HUD ImGui lojas ranking mix e painel do servidor]] | cliente HUD ImGui, loja, SQL, painel Server.exe, regras Cursor |
| 2026-09-15 | [[2026-09-15 - Armazem ImGui paginas e save]] | bau ImGui, 3 paginas, `.war` WH02, ADR 0006 |
| 2026-09-16 | [[2026-09-16 - Distribuidor ImGui, correio e painel Server]] | PostBox PB02, transcodes 0x48478A81-85, splash Server.exe, ADR 0007 |
| 2026-09-17 | [[2026-09-17 - Armazem SQL e capacidade]] | UserDB Warehouse, 300 slots, wVersion 3, ADR 0008 |

Artes e roadmap de telas (hub, nao sessao especial): `12-UI-e-Artes/index`
(2026-09-13). ADR [[0005 - Distribuidor ImGui, armazem e inventario em pedra, artes no Cliente Full]].

Sessoes anteriores (ainda no diario/processos, antes desta pasta existir):

- [[2026-08-31 - Setup inicial do projeto e documentacao]]
- [[2026-08-31 - Analise completa do codigo e reestruturacao da documentacao]]
- [[2026-09-06 - Reorganizacao do vault e novos trilhos de estudo]]
- [[2026-09-06 - Recap Desafios ImGui]]
