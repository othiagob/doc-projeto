---
tags: [aprendizado, sql]
data: 2026-09-06
---

# Trilha de Aprendizado — SQL Server através do projeto

> Você já colocou o SQL Server no ar numa VPS e até extraiu dados dele
> (ver `Dados-SQL/`). Esta trilha transforma isso em **conhecimento
> estruturado**: de SELECTs simples até entender como o servidor do jogo
> conversa com o banco — sempre usando as tabelas reais do projeto.

## Por que SQL vale o investimento neste projeto

O servidor Priston é movido a banco: itens, monstros, NPCs, drops e contas
saem de lá (ver [[Banco-de-Dados]]). Quem domina SQL no projeto consegue:
- balancear o jogo **sem recompilar nada** (mexer em tabela = mexer no jogo)
- debugar problema de conta/log/clone direto na fonte
- planejar as melhorias de segurança (ex: hash de senha — ver
  [[Melhorias-Sugeridas]])

---

## Fase 1 — Lendo dados (SELECT básico)

**Conceitos:** `SELECT`, `FROM`, `WHERE`, `ORDER BY`, `TOP`, operadores
de comparação, `AND`/`OR`.

**Material:** as tabelas já exportadas em `Dados-SQL/` e, quando puder,
o SSMS conectado na VPS.

Comece pela [[Exercicios-SQL-Guiados]] (S1 a S3).

## Fase 2 — Data shaping (agregar, agrupar, juntar)

**Conceitos:** `COUNT`, `SUM`, `MIN/MAX`, `AVG`, `GROUP BY`, `HAVING`,
`JOIN` (começando pelo `INNER JOIN`), chave primária/estrangeira.

É a fase mais útil pro dia a dia do projeto: "quantos itens existem por
tipo?", "qual monstro tem o melhor drop?" — as respostas saem daqui.
Exercícios S4 a S6.

## Fase 3 — Escrevendo com segurança (INSERT, UPDATE, DELETE)

**Conceitos:** inserir/atualizar/apagar, transações (`BEGIN TRAN`/
`COMMIT`/`ROLLBACK`), a regra de ouro **"SELECT antes de todo UPDATE"**
(sempre verifique o filtro antes de aplicar a mudança).

Aqui começa o cuidado real: nessa fase você já pode quebrar dados de
produção. Exercícios S7 a S9 — e antes deles, leia o guia de backup
(`09-Guias/VPS-e-SQL-Server.md`).

## Fase 4 — Como o JOGO usa o banco

**Conceitos:** stored procedures, ODBC (a ponte que o C++ usa pra falar
com o SQL Server), queries parametrizadas vs SQL montado por string.

1. Abra `SrcServer/src/Server/Database/` (no repo do jogo) e localize onde
   as queries são montadas. `gameSQL.cpp` é um bom ponto de partida.
2. Identifique uma query que o servidor roda e encontre (ou crie no banco
   de testes) a tabela correspondente.
3. Entenda o que é ODBC: o código C++ não "fala SQL Server" direto — fala
   ODBC, que traduz pro servidor. É por isso que `Server\Config\SQL.ini`
   tem `Host/User/Password`.

Esse estudo entrelaça com as melhorias 2.1 e 2.3 de [[Melhorias-Sugeridas]]
(schema no git, procedures padronizadas).

## Fase 5 — (futuro) Operar banco de servidores de jogo

Backup/restore, jobs agendados, dimensionamento (índices nas tabelas mais
consultadas), e segurança (usuários com permissões mínimas, nada de `sa`
na aplicação). Material: `09-Guias/VPS-e-SQL-Server.md` + Microsoft Learn
(trilha gratuita de SQL Server).

---

## Regras de ouro do SQL neste projeto

1. **NUCA rode UPDATE/DELETE sem o SELECT correspondente antes** — confirme
   as linhas afetadas.
2. **Só mexa em produção depois que existir o backup automático do dia**
   (ver guia VPS).
3. **`sa` não é usuário de aplicação** — a conexão do jogo usa usuário
   próprio com menos permissões (pendência listada em
   [[Melhorias-Sugeridas]]).

## Recursos

- Microsoft Learn — módulos gratuitos de T-SQL (busque "consultas T-SQL")
- Prática real: os arquivos de `Dados-SQL/` (dá pra criar um banco de
  teste local e reimportar essas tabelas)
- Referência: [[Banco-de-Dados]] (arquitetura) e `Dados-SQL/README.md`
  (dicionário de colunas)
