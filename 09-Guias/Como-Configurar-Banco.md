---
tags: [guias, banco, sql]
---

# Como Configurar o Banco (SQL Server)

> Guia para iniciantes. O servidor do jogo NÃO funciona sem o SQL Server
> acessível — se você vê "Falha ao conectar-se ao banco de dados!" no
> console do servidor, este guia resolve.

## O que você precisa

- **SQL Server** instalado e rodando (ex.: SQL Server Express — aparece
 como `LOCALHOST\SQLEXPRESS`)
- **SQL Server Management Studio (SSMS)** — o programa pra mexer no banco
 (grátis, baixe do site da Microsoft)

## Como o servidor sabe onde está o banco

O servidor lê o arquivo `Server\Config\SQL.ini` (relativo ao executável),
seção `[Database]`:

```ini
[Database]
Host=LOCALHOST\SQLEXPRESS
User=sa
Password=sua_senha_aqui
```

- **`Host`** — onde está o SQL Server (ex.: `LOCALHOST\SQLEXPRESS`)
- **`User`** / **`Password`** — usuário e senha do banco (ex.: `sa` + a senha
 que você definiu na instalação)

> **Atenção:** Se o `SQL.ini` não existir ou estiver vazio, o servidor usa **valores
> padrão que estão no código** (`gameSQL.cpp`) — por isso ele pode conectar
> mesmo sem o arquivo. Se a sua instalação usa outra senha, crie o `SQL.ini`.

## Bancos que o servidor espera encontrar

| Banco | Para quê (provável) |
|---|---|
| `UserDB` | contas e personagens (o principal) |
| `ServerDB` | dados gerais |
| `LogDB` | logs |
| `ClanDB` | clãs |
| `SoDDB`, `EventosDB`, `ShopCoin`, `Quest`, `GameServer`, `ITEMLogDB`, `PainelDB` | sistemas específicos |

O servidor tenta conectar em **todos** eles. Se um falhar, ele loga o erro
e fecha (`exit(0)`).

## Passo a passo rápido

1. Instale o SQL Server (Express serve) e anote a senha do usuário `sa`
 (ou crie um usuário próprio).
2. Abra o SSMS e conecte no servidor.
3. Crie os bancos que ainda não existem (botão direito em "Bancos de
 dados" -> **Novo banco de dados** -> nome exato, ex.: `UserDB`).
4. Crie o arquivo `Server\Config\SQL.ini` com os dados certos (ou ajuste
 a senha padrão no código se preferir — não recomendado).
5. Rode o `Server.exe` e confira no console: deve mostrar "connected with
 sucess!" para cada banco.

## Dicas

- **Backup antes de experimentos:** botão direito no banco -> Tarefas ->
 Fazer backup. Os personagens ficam em arquivos `.dat`, mas contas/itens
 do banco não — backup protege tudo.
- **Onde estão as tabelas?** O projeto **não tem scripts `.sql`** — as
 tabelas precisam ser criadas manualmente (ou copiadas de um banco já
 montado). A lista de tabelas que o código usa está em
 [[Banco-de-Dados]] — use-a como referência do que criar.
- **Senhas:** o login compara a senha em **texto puro** — não é seguro
 pra um servidor público (pendência anotada no SDD).

## Ver também

- [[Banco-de-Dados]] — detalhes técnicos e lista de tabelas
- [[Como-Rodar]] — ordem completa de subir o servidor