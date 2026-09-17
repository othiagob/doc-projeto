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

> **Atenção:** A lista de tabelas de cada banco ainda não foi mapeada por
> completo — tarefa futura (SSMS). Descobertas pontuais abaixo.

Atualizado 2026-09-08 (codigo + regra `.cursor/rules/40-database.mdc`):

- Nome ausente no boot = `exit(0)`. SQL Server ignora maiusculas
  (`userdb` = `UserDB`). `UserDB_VIP` e a **mesma** `UserDB`.
- **Nao remova `PainelDB`.** GM grava bans em `PainelDB.dbo.Banneds`. Se o
  banco foi dropado, o C++ tenta criar vazio via `master`
  (`EnsurePainelDatabase` em `SQLConnection.cpp`). Script manual:
  `09-Guias/sql/Create-PainelDB.sql`.
- Falha de conexao agora loga o **nome** do banco.
- Inventar catalogo de `GameServer` no C++ nao recupera dados zerados —
  precisa restore `.bak`.
- Loja de Coins: `ShopCoin.dbo.ShopItems` — colunas reais `ID`,
  `CategoryID`, `SubCategoryID`, `ItemCode`, `ItemName`, `Price`,
  `DiscountPercent`. No C++ o campo ainda se chama `Discount`. `ItemCode`
  e o codigo do item (`OR129`), nao o caminho da imagem. Icone:
  `image\sinImage\Items\<pasta>\itCODIGO.bmp` no cliente full.
- Credenciais: `Server\Config\SQL.ini` (`Host`, `User`, `Password`) junto
  ao executavel, fora do git.
- **Distribuidor (auditoria):** `ITEMLogDB.dbo.PostBoxLog` — livro de
  eventos (DEPOSIT / SEND / CLAIM / REFUSE / EXPIRE). A caixa viva do
  jogador **nao** esta no SQL: fica em `Data\PostBox\<usercode>\<login>.dat`
  (magica `PB02`). `Quest.dbo.PostBox` (e qualquer `UserDB.Postbox`) e
  tabela antiga/nao usada pelo C++ atual. Script:
  `09-Guias/sql/Create-PostBoxLog.sql`.
- **Armazem (2026-09-17):** `UserDB.dbo.Warehouse` + `WarehouseItem`.
  Nao e um database novo no boot. O C++ **nao** cria as tabelas;
  script `09-Guias/sql/Create-Warehouse.sql`. Unique filtrado
  `(AccountID, Head, ChkSum)` onde Head/ChkSum != 0. Planta: [[Armazem]].

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