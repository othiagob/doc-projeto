---
tags: [evolucao]
status: ativo
data: 2026-09-18
---

# Evolucao: SQL do armazem falhou; save voltou para arquivo WH03

Bloco 2026-09-17 (SQL) + 2026-09-18 (arquivo). Nao apaga a nota
[[2026-09-17 - Armazem SQL e capacidade]]; esta e a memoria do **por
que nao repetir SQL neste ODBC** e do estado que **funcionou** no jogo.

UI hibrida (ADR 0006) **nao** foi desfeita. Grade 300 / 3 abas / fio
`wVersion=3` **permanecem**. So a gravacao mudou.

## Linha do tempo

1. **Classico** — `cWAREHOUSE` pinta e arrasta; 100 slots; `.war`.
2. **15/09** — pintura ImGui; 3 paginas WH02; busca; drag intocado.
   Funcionou no jogo.
3. **Dor** — grade 9×9 × 22 px. Pedido: mais slots + anti-dupe + SQL.
4. **17/09** — UserDB, 300×5/3, `wVersion=3` ocupados (ADR 0008).
   Codigo escrito; **teste de jogo nao fechou**.
5. **17–18/09** — varias correcoes SQL (ODBC, mensagem, RESULT).
   Sintoma estavel: 1 anel no bau vazio, fecha, item volta.
6. **18/09** — Thiago pergunta se ha opcao alem de SQL. Escolha:
   `.war` WH03. Teste: **deu certo**. ADR 0009.

## O que falhou / nao voltar sem ADR

Esta tabela e a regra para a proxima IA (e para voce daqui a meses).

| Tentativa | Quando | Por que nao |
|---|---|---|
| Drag 100% ImGui (reescrito overlap no ImGui) | 15/09 | Tabela de falhas da sessao; dupe se overlap errar. ADR 0006. |
| `Data[]` = 300 `sITEM` no pacote | 17/09 (planejado) | Socket 8192; stack. Fio so de ocupados. |
| Novo `smTRANSCODE_*` so para pagina | 15–17/09 | Contrato; 0006 prova o mesmo codigo. |
| Database `WarehouseDB` no boot | 17/09 | `exit(0)` se o nome faltar. |
| Schema criado pelo `server.exe` | 17/09 | Convencao: SSMS + vault. Agora o bau nem usa SQL. |
| Persistencia SQL `UserDB.Warehouse` via `SQLConnection` | 17–18/09 | **Nao fechou no jogo.** ODBC leftover bind (`SQL_CLOSE` sem `RESET_PARAMS`), `GetRowCount==-1`, blob, transacao, RESULT ausente. Corrigir um buraco revelava outro. |
| Tratar falha de save como `MESSAGE_OVER_ITEM_NUM` | 17/09 | Mentia "Muitos Itens". Agora: "Falha ao salvar o armazem." + `RestoreInvenItem`. |
| Voltar WH02 100 slots para "simplificar" | 18/09 (recusado) | Perde a grade 20×15 que ja esta no cliente. |
| SQLite / outro motor "so para o bau" | 18/09 (nao feito) | Terceiro tipo de save. So com ADR nova. |

### Detalhe do atoleiro SQL (para nao repetir o diagnostico)

Sintoma: bau vazio + 1 anel depositado (inventario 4/203 → 3/203);
ao fechar, o anel volta. **Nao era peso nem slot.**

O que tentamos no SQL e **nao bastou**:

- Script `Create-Warehouse.sql` (ItemBlob 4096, GridW/H, ItemClass).
- `SQLConnection::Prepare`: `SQL_CLOSE` + `SQL_UNBIND` + `SQL_RESET_PARAMS`.
- Commit sempre envia `WAREHOUSE_WIRE_RESULT` (`dwTemp[4]=2`).
- Mensagem honesta no client + rollback.

Ainda assim o save SQL falhava. Conclusao: o desenho de tabelas ate
pode estar certo; **este wrapper ODBC + transacao de blob nao e
caminho confiavel agora**.

Nao reabrir ADR 0008 persistencia sem: (1) pedido explicito, (2) ADR
nova, (3) outro acesso a banco (nao o mesmo padrao de binds).

## O que ficou (2026-09-18, testado)

Hibrido 0006 + persistencia 0009 (arquivo WH03). Paginas 4–5 so na RAM
ate o Thiago pedir unlock.

Log do servidor: `Warehouse FILE commit OK` / `Warehouse FILE load`.
Arquivo: `Data\DataServer\warehouse\<n>\<conta>.war`.

## Testar daqui a meses

Personagem com `.war` WH02 antigo ainda importa e gera `.wh02`?
Primeiro save de conta nova cria WH03?
Falha de disco ainda devolve o item (`RestoreInvenItem`)?
Dois clientes mesma conta: o ultimo arquivo ganha (esperado, sem SQL)?
