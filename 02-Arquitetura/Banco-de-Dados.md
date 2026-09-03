---
tags: [arquitetura, banco, servidor]
---

# Banco de Dados — SQL Server

> Verificado no código em 2026-08-31. O servidor do jogo guarda tudo que é
> permanente (contas, personagens, itens, rankings) no banco de dados.

## Resumo

- **Banco:** Microsoft **SQL Server**
- **Acesso:** via **ODBC** (uma API padrão do Windows pra falar com bancos)
- **Configuração:** `Server\Config\SQL.ini` (relativo à pasta do servidor)
- **Fallback:** se o `SQL.ini` não existir ou estiver vazio, o código usa
 valores padrão hardcoded em `SrcServer/src/Server/SrcServer/gameSQL.cpp`
 (host `LOCALHOST\SQLEXPRESS` etc.) — **troque essas credenciais** se
 for expor o servidor; elas estão no código-fonte.

## Como o servidor conecta (código real)

1. `gameSQL.cpp` lê o `Server\Config\SQL.ini` (seções `Database`: `Host`,
 `User`, `Password`).
2. `Database/SQLConnection.cpp` monta a string de conexão ODBC:
 `DRIVER={SQL Server};SERVER=<host>;DATABASE=<banco>;UID=<user>;PWD=<pwd>`
 e conecta via `SQLDriverConnect` (ODBC 3).
3. `CreateSQLConnection()` é chamado pra **cada banco** listado abaixo.
4. Se um banco não conectar: o servidor loga e **fecha** (`exit(0)`).

## Bancos de dados usados

| Banco | Uso provável (confirmar no código) |
|---|---|
| `UserDB` | contas de usuário, personagens (o principal) |
| `ServerDB` | dados gerais do servidor |
| `LogDB` | logs |
| `ClanDB` | clãs/guildas |
| `SoDDB` | sistema "SoD" (não confirmado — nome coreano) |
| `EventosDB` | eventos |
| `ShopCoin` | moeda/cash shop |
| `Quest` | missões |
| `GameServer` | estado do servidor de jogo |
| `ITEMLogDB` | log de itens (economia/rastreio) |
| `PainelDB` | painel/website (provável) |

> **Atenção:** A lista de tabelas de cada banco ainda não foi mapeada — tarefa futura
> (rodar o SQL Server local e inspecionar com o SSMS, ou procurar scripts
> `.sql` no projeto). Anote descobertas aqui.

## Onde isso importa na prática

- **Criar conta/testes:** contas ficam em `UserDB` (ver [[Como-Rodar]]).
- **Backup:** os `.mdf` do SQL Server são o "save do mundo" — faça backup
 antes de experiências grandes.
- **Mudança de schema** (nova tabela/coluna): não existe migração formal —
 você roda o SQL manualmente no SSMS. Documente a mudança no diário.

## Ver também

- [[Como-Configurar-Banco]] (guia passo a passo — a criar)
- [[Arquitetura]] — onde o banco é usado no servidor
- [[SDD-Source-Priston]] — documento de design