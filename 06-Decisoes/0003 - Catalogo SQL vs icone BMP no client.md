---
tags: [decisao, loja, banco, cliente]
status: aceita
data: 2026-09-08
---

# 0003 - Catalogo da loja vem do SQL; icone e arquivo no client

## Contexto

A Loja de Coins le `ShopCoin.dbo.ShopItems`. Houve confusao entre:

- o **codigo do item** (`ItemCode` / `LastCategory`, ex.: `OR129`);
- o **caminho da imagem** no disco do client;
- o nome da coluna de desconto no SQL vs o campo em memoria no C++.

Tambem houve a ideia de "consertar" item sem icone mudando o codigo no
banco, e a ideia de inventar catálogo de `GameServer` no C++ quando o
banco local estava vazio.

## Opcoes consideradas

1. **Mudar `ItemCode` no SQL para bater com um BMP que existe** — quebra
   `CreateItemPerf` / entrega do item real. O jogador compra um codigo e
   recebe outro (ou nada).
2. **Gerar catálogo no C++ quando o SQL esta vazio** — mascara restore
   faltando. Dados de mundo (`GameServer` e outros) nao voltam assim.
3. **SQL manda identidade e preco; client so desenha.** BMP ausente =
   placeholder `NO IMAGE` e trava o clique ("A imagem do item nao esta
   pronta"). Completar icone copiando um BMP generico no client, sem
   alterar o codigo no banco.

## Decisao

Opcao 3.

Colunas reais de `ShopCoin.dbo.ShopItems`:

`ID`, `CategoryID`, `SubCategoryID`, `ItemCode`, `ItemName`, `Price`,
`DiscountPercent`.

No C++ o campo de memoria ainda se chama `Discount`. O SELECT usa
`ISNULL(DiscountPercent, 0)`. Nunca assumir coluna `Discount` no SQL.

Icone no disco do **cliente full** (`C:\Cliente Full`):

`image\sinImage\Items\<Weapon|Defense|Accessory|Premium|Event>\itCODIGO.bmp`

`ItemCode` identifica o item. Nao e path.

Bancos obrigatorios no boot: ver regra `.cursor/rules/40-database.mdc`.
`PainelDB` nao e opcional — GM grava bans em `PainelDB.dbo.Banneds`. Se o
banco foi dropado, o servidor tenta criar vazio via `master`
(`EnsurePainelDatabase`). Inventar dados de `GameServer` no codigo nao
substitui restore `.bak`.

## Consequencias

- Loja "sem imagem" e problema de asset, nao de protocolo.
- Schema novo = SQL no SSMS + atualizar `02-Arquitetura/Banco-de-Dados.md`.
  Sem migracao formal.
- Credenciais em `Server\Config\SQL.ini` (junto ao exe, fora do git).
