---
tags: [aprendizado, sql, exercicios]
data: 2026-09-06
---

# Exercícios SQL Guiados — nas tabelas reais do jogo

> Todos os exercícios usam tabelas que **existem de verdade** no banco do
> projeto (colunas verificadas nas exportações em `Dados-SQL/`). Sintaxe:
> **SQL Server (T-SQL)** — é o motor do projeto.
>
> Regra de estudo: **escreva a query primeiro, confira depois.** Se errar,
> registre no [[Registro-de-Aprendizado]] o porquê do erro — erro de SQL
> ensina mais que acerto.

Ambiente sugerido: banco de **teste** (local na sua máquina ou uma copia
restaurada na VPS), nunca o de produção. Guia de setup e backup:
`09-Guias/VPS-e-SQL-Server.md`.

Prefixos de item do projeto (ver `Dados-SQL/ListaItens_Drop.md`):
`WA` machados, `DA` armaduras, `DB` botas, `DG` luvas, `DS` escudos,
`WS2` espadas, `pl` poções, etc.

---

## S0 — Básico Introdutório (comece por aqui)

> Esta seção pressupõe que você **nunca escreveu SQL**. Se os exercícios
> S1+ parecerem difíceis, faça o S0 inteiro primeiro antes de voltar pra eles.

### S0.1 — O que é uma tabela (e por que SQL)

**Contexto.** Um banco de dados guarda informação em **tabelas** — pense
numa planilha do Excel: as colunas são os "tipos de informação" e cada
linha é "um item de verdade". A tabela `Armor` do jogo é exatamente isso:
cada linha é uma armadura, e as colunas dizem o nome, o nível e o preço
dela (ver `Dados-SQL/Armor.md` — `DA102` é a "Armadura de Batalha",
nível 0, preço 400).

A linguagem SQL é a forma de **conversar** com esse banco: você escreve
uma frase, o banco faz o trabalho pesado e devolve a resposta. A frase
mais básica é o `SELECT` — em português, "mostre-me". Ela tem duas
partes:

```sql
SELECT Name, Price      -- QUais colunas quero ver
FROM Armor;             -- DE QUAL tabela
```

Duas observações didáticas:
- Escrever SQL em caixa alta (`SELECT`, `FROM`) é costume, não regra — o
  banco entende minúscula igual. Caixa alta ajuda a olhar e separar o
  comando do resto.
- O ponto e vírgula `;` fecha cada frase de SQL, como o ponto final encerra
  uma frase em português.

Perguntas:
1. A tabela `Armor` tem as colunas `Name`, `ItemLevel` e `Price`. Escreva
   uma frase que mostre SÓ o nome e o preço das armaduras.
2. E se você quiser TODAS as colunas, sem citar uma por uma? *(dica: existe
   um símbolo que significa "tudo")*
3. Na planilha que você imagina, quem são as "linhas"? *(dica: quantas
   armaduras existem? — olhe o `Dados-SQL/Armor.md`)*

**Gabarito da 1:**

```sql
SELECT Name, Price FROM Armor;
```

### S0.2 — Ordenar o resultado (ORDER BY)

**Contexto.** Quando o `SELECT` devolve 30 linhas, elas vêm "na ordem em
que estão guardadas" — quase nunca a ordem que você quer. O `ORDER BY`
pede: "organize essa resposta". Duas direções: `ASC` (crescente — do menor
pro maior) e `DESC` (decrescente — do maior pro menor). Se você não
escreve nada, o padrão é `ASC`.

```sql
SELECT Name, ItemLevel, Price
FROM Armor
ORDER BY Price DESC;
```

Tradução: "mostre nome, nível e preço das armaduras, da mais CARA pra mais
barata." Tendência no jogo: preço acompanha nível — a armadura do topo da
lista deve ter o `ItemLevel` maior também.

Perguntas:
1. A mais cara das armaduras é também a de maior nível? (compare as duas
   primeiras linhas do resultado)
2. Se você tirar o `DESC`, o que muda no resultado? Deve continuar
   "coerente" (caro = alto nível)? Por quê?
3. Escreva a frase que mostra a armadura mais BARATA em ordem crescente de
   preço, e coloque em cima da lista (a primeira linha).

### S0.3 — Escolher linhas (WHERE)

**Contexto.** Uma tabela do jogo tem centenas de linhas; você quase nunca
quer ver todas. O `WHERE` é o filtro: "DESSAS linhas, mostre só as que
cumprem uma condição". É o `if` das funções de C++ (E0.2): uma comparação
que devolve verdadeiro ou falso por linha.

```sql
SELECT Name, ItemLevel, Price
FROM Armor
WHERE ItemLevel >= 50;
```

Tradução: "dentre as armaduras, mostre só as que são usáveis a partir do
nível 50". Operadores que você vai usar o tempo todo: `>=` (maior ou
igual), `<=`, `=`, `<>` (diferente — não use `!=` por costume de outra
linguagem).

Perguntas:
1. Quantas armaduras de nível abaixo de 30 existem? *(rascunho de WHERE e
   depois conte)*
2. A linha `Armadura Leve` tem `ItemLevel = 6`. Ela aparece num filtro
   de `WHERE ItemLevel >= 10`? E num `WHERE ItemLevel < 10`?
3. Uma armadura está com `Active = 0` (desativada). Escaparia no filtro
   `WHERE Active = 1 ... AND ItemLevel >= 50`? Responda em uma frase
   porque a palavra `AND` mudou o resultado em relação ao filtro sem
   `AND`.

**Gabarito da 1:**

```sql
SELECT Name, ItemLevel FROM Armor WHERE ItemLevel < 30;
```

### S0.4 — TOP: me mostre só os primeiros

**Contexto.** Num servidor de jogo de verdade, uma tabela pode ter
milhões de linhas (LogDB guarda evento por evento). Pedir "TODAS" travaria
a tela. `TOP N` diz: "me traga somente as N primeiras linhas do resultado".
Combinar com `ORDER BY` muda o conjunto a ser mostrado, pois primeiro
ordena e depois corta.

```sql
SELECT TOP 5 Name, Price
FROM Armor
ORDER BY Price DESC;
```

Perguntas:
1. O que essa frase devolve: os cinco itens mais baratos ou mais caros?
2. Agora escreva a mais usada no projeto: "o item com preço mais ALTO do
   jogo inteiro". *(dica: `TOP 1` + ordenar pelo preço da forma certa)*
3. Por que o projeto é SQL Server e não MySQL? *(réplica curta: limitações
   históricas do código-legado — na sintaxe SQL Server usa `TOP`; MySQL
   usaria `LIMIT 5`; ora o TOP é a primeira coisa que mostra que você ESTÁ
   realmente no dialeto certo)*

**Gabarito da 2:**

```sql
SELECT TOP 1 Name, Price FROM Armor ORDER BY Price DESC;
```

---

## S1 — SELECT básico (tabela `Weapons`)

Objetivo: escolher linhas e colunas.

```sql
SELECT TOP 10 Code, Name, ItemLevel, Price
FROM Weapons
ORDER BY ItemLevel DESC;
```

1. O que `TOP 10` limita? E o que o `ORDER BY ItemLevel DESC` decide sobre
   *quais* 10 aparecem?
2. Reescreva pra devolver as 10 armas **mais baratas** de nível 20+.
   *(dica: `WHERE ItemLevel >= 20 ORDER BY Price ASC`)*
3. Por que o projeto usa `TOP` e não `LIMIT`? *(dica: LIMIT é MySQL/Postgres)*

**Gabarito da 2:**

```sql
SELECT TOP 10 Code, Name, ItemLevel, Price
FROM Weapons
WHERE ItemLevel >= 20
ORDER BY Price ASC;
```

---

## S2 — Filtros textuais (tabela `Weapons`)

```sql
SELECT Code, Name, ItemLevel
FROM Weapons
WHERE Name LIKE '%Machado%'
ORDER BY ItemLevel;
```

1. O que o `%` faz no `LIKE`? E se o servidor for instalado com nomes com
   acento/maiúscula diferente — `LIKE 'machado%'` traz os mesmos resultados?
   *(dica: pesquise "collation SQL Server")*
2. Traga todo item cujo código comece com `WA` (machado). *(dica: `Code LIKE 'WA%'`)*
3. Traga itens cujo nome **não** contenha "Machado".
   *(dica: `NOT LIKE`)*

---

## S3 — Faixas e conjuntos (tabela `Armor`, ver `Dados-SQL/Armor.md`)

A peça com código `DA130` (Armadura Flamejante) tem `ItemLevel = 130`,
`Price = 1000000`.

1. Traga todas as armaduras de nível entre 80 e 120:
   *(dica: `WHERE ItemLevel BETWEEN 80 AND 120`)*
2. Traga todas as armaduras cujo preço **não** esteja entre 100000 e 500000.
   *(dica: `NOT BETWEEN`)*
3. Traga armaduras que custam exatamente um dos valores: 47000, 54000, 62000.
   *(dica: `Price IN (47000, 54000, 62000)`)*
4. Reflexão: a coluna `Price` da `Armor` tem valores até 1,1 milhão.
   Em que tipo de coluna (`int`, `bigint`, `money`?) você esperaria que ela
   fosse? Por quê? *Verifique no schema real (clique direito -> Design no SSMS).*

---

## S4 — Agregação (tabela `MonsterList`, ver `Dados-SQL/MonsterList.md`)

Objetivo: `COUNT`, `MIN`, `MAX`, `AVG`, `GROUP BY`.

```sql
SELECT MonsterLevel, COUNT(*) AS quantidade
FROM MonsterList
WHERE Active = 1
GROUP BY MonsterLevel
ORDER BY MonsterLevel;
```

1. Em uma frase: o que a query acima responde sobre o jogo?
2. Quantos **bosses** existem no total? *(dica: `WHERE Boss = 1` ou
   o valor que a coluna usa — confira na exportação)*
3. Qual o nível médio dos monstros ativos? *(dica: `AVG(MonsterLevel)`)*
4. Agrupe por `Boss` (0/1) e diga quantos monstros existem em cada grupo.

**Gabarito da 4:**

```sql
SELECT Boss, COUNT(*) AS total
FROM MonsterList
GROUP BY Boss;
```

---

## S5 — JOIN de duas tabelas (`DropList` + `DropItem`)

Este é **o** exercício do projeto: responder "o que o monstro X dropa".

Estrutura (ver `Dados-SQL/DropList.md` e `DropItem.md`):

- `DropList`: `ID`, `DropID`, `MonsterName`, `PublicDrop`, `Quantity`
- `DropItem`: `DropID`, `Items`, `Chance`, `GoldMin`, `GoldMax`

```sql
SELECT dl.MonsterName, di.Items, di.Chance
FROM DropList dl
INNER JOIN DropItem di ON dl.DropID = di.DropID
WHERE dl.MonsterName = 'NomeDeUmMonstro';
```

1. Qual coluna "amarram" as duas tabelas? (É a chave do JOIN.)
2. O que acontece com um monstro que existe na `DropList` mas cujo `DropID`
   não existe na `DropItem`, se usarmos `INNER JOIN`? E com `LEFT JOIN`?
   *(dica: rode as duas versões e compare o resultado)*
3. Qual o valor médio da coluna `Chance` dos drops? Está em porcentagem
   (0-100) ou fração (0-1)? *Confirme olhando os dados.*

**Gabarito da 3:**

```sql
SELECT AVG(CAST(Chance AS FLOAT)) AS chanceMedia
FROM DropItem;
```

---

## S6 — JOIN triplo: monstro -> drop -> item

Monte você mesmo, usando o S5 como tábua:

1. Junte `MonsterList` (que tem `ID` e `MonsterName`) com `DropList` (que
   tem `MonsterName`) pra chegar até `DropItem`.
2. Desafio: devolva `MonsterName, Items, Chance` ordenado por `Chance DESC`,
   apenas as 20 melhores drops do jogo.
   *(dica: `TOP 20 ... ORDER BY Chance DESC`)*

> Reflexão: pra fazer isso direto no servidor (comando GM "me diga o drop
> desse monstro"), essa query precisaria existir dentro do jogo. É
> exatamente a melhoria 4.1 de [[Melhorias-Sugeridas]].

---

## S7 — INSERT (em banco de TESTE!)

Objetivo: inserir linhas, entendendo cada coluna.

1. Abra o schema da tabela `Craft` (`ID, Code, Name, Active, Weight, Price`)
   e escreva um `INSERT` de uma linha com valores fictícios.
2. Agora insira a **mesma linha de novo**. O que aconteceu? Por quê?
   *(dica: chave primária duplicada)*
3. Delete a linha de teste: *(dica: `DELETE FROM Craft WHERE Code = 'XX999'`)*

---

## S8 — UPDATE: a regra de ouro

**Contexto.** Update é o comando que muda o valor de linhas existentes.
É o comando que mais **destrói dados por erro de digitação**, e por isso
tem uma regra de ouro no projeto (e em qualquer empresa séria):

> **Nunca rode UPDATE sem antes rodar um SELECT idêntico.**

O SELECT prova quais linhas o filtro pega; se o SELECT mostrar as linhas
certas, o UPDATE com o MESMO `WHERE` vai mudar exatamente elas. Se o
SELECT mostrar 300 linhas quando você esperava 1, é sinal de que seu
filtro está errado — e o UPDATE ainda não aconteceu, nada se perdeu.
É o "simulador de impacto" da mudança.

```sql
-- 1. VEJA o que vai mudar:
SELECT Code, Name, Price FROM Weapons WHERE Code = 'WA101';

-- 2. só então MUDE:
UPDATE Weapons SET Price = 12345 WHERE Code = 'WA101';
```

1. O que acontece se você esquecer o `WHERE` num `UPDATE`? Sintetize em uma
   frase. *(resposta esperada: muda TODAS as linhas da tabela)*
2. Ajuste o preço de **todas** as botas (`Boots`) de nível < 10 pra 100.
   Primeiro o SELECT, depois o UPDATE.
3. Se o UPDATE der errado em produção, o que você faz? (resposta curta:
   nada — daí a importância do backup de [[VPS-e-SQL-Server]] e de
   praticar S7/S8 **só em banco de teste**).

---

## S9 — Transações (o "Ctrl+Z" do banco)

```sql
BEGIN TRAN;

UPDATE Weapons SET Price = 1 WHERE ItemLevel > 100;

-- algo deu ruim? ROLLBACK desfaz:
ROLLBACK;

-- ou confirmou que tá certo (rode numa seção separada):
-- COMMIT;
```

1. Rode o bloco acima num banco de teste (depois faça `SELECT` pra conferir
   se algo foi alterado). O que o `ROLLBACK` evitou?
2. Reescreva pra, **dentro da mesma transação**, atualizar o preço de 2
   tabelas diferentes (`Weapons` e `Armor`) — e só então comitar.

**O que isso ensina:** é isso que o servidor do jogo usa pra "salvar
personagem sem perder metade" num crash. Conceito central de qualquer
persistence.

---

## Gabarito-resumo (pra conferir rápido)

| Ex. | Conceito central |
|---|---|
| S0 | conceito de tabela, SELECT básico, ORDER BY, WHERE, TOP |
| S1-S3 | SELECT/WHERE/ORDER BY/LIKE/BETWEEN/IN |
| S4 | agregação + GROUP BY |
| S5-S6 | JOIN (INNER/LEFT) entre tabelas do projeto |
| S7 | INSERT + chave primária |
| S8 | UPDATE seguro (SELECT antes) |
| S9 | BEGIN TRAN/COMMIT/ROLLBACK |

Quando S1-S9 estiverem confortáveis, siga pra fase 4 da
[[Trilha-SQL-Server]] (como o código C++ do jogo chega nessas tabelas).
