---
tags: [guias, rodar, servidor, cliente]
---

# Como Rodar (servidor + cliente no seu PC)

> Você já consegue logar — este guia registra **como**, pra nunca mais
> precisar descobrir de novo. Corrija/complete com o que você fizer de
> diferente na prática.

## Visão geral do que acontece

1. **SQL Server** precisa estar rodando (o servidor do jogo fala com ele).
2. **Servidor do jogo** (`Server.exe`) conecta no banco e abre a porta de
 rede (padrão: **8185** — constante `TCP_GAMEPORT` em `smwsock.h`).
3. **Cliente** (`Game.exe`) conecta no servidor usando o IP/porta que estão
 no `game.ini` (seção `[ConnectServer]`).

> **Atenção:** O `game.ini` do seu cliente tem `IP=189.46.228.170, Port=31620`.
> Isso parece ser config de um servidor externo antigo — **confira se é
> isso que você quer** ou troque para `127.0.0.1` (localhost) pra testar
> localmente. Detalhes de como o cliente usa isso: ver [[Protocolo-de-Rede]].

## Passo a passo

> **Atenção:** Importante: os executáveis são gerados **fora do repositório**, em
> `C:\Source Priston\` (`Game.exe` e `Server.exe`). É lá que você roda.

### 1. Banco de dados (SQL Server)

- O servidor usa **SQL Server** via ODBC.
- Configuração de conexão: `Server\Config\SQL.ini` (seções `Host`, `User`,
 `Password`) — se o arquivo não existir ou estiver vazio, o código usa um
 fallback com valores padrão (ver `SrcServer/src/Server/SrcServer/gameSQL.cpp`).
- Bancos usados: `UserDB`, `ServerDB`, `LogDB`, `ClanDB`, `SoDDB`,
 `EventosDB`, `ShopCoin`, `Quest`, `GameServer`, `ITEMLogDB`, `PainelDB`.
- Sem o SQL Server certo no ar, o servidor mostra
 `Falha ao conectar-se ao banco de dados!` e fecha.

### 2. Servidor

1. Compile (`server.sln`, Release) — ver [[Como-Compilar]].
2. Rode `C:\Source Priston\Server.exe`.
3. No console, veja as mensagens de conexão com o banco.
4. O servidor fica escutando na porta de jogo (8185) e na de login (32299).

### 3. Cliente

1. Compile (`Game.sln`, Release) — ver [[Como-Compilar]].
2. Ajuste `game.ini` (na pasta do cliente) com o IP/porta certos.
3. Rode `C:\Source Priston\Game.exe`.
4. Faça login e entre no jogo.

## Testando depois de uma alteração

1. Compile o lado que mudou (ou os dois, se mexeu em `Shared/`).
2. Suba o servidor, espere o banco conectar.
3. Abra o cliente, logue, e teste a mudança.
4. Anote o resultado no [[CHANGELOG]] e no diário (`04-Diario-do-Projeto/`).

## Dicas

- Pra testar sozinho, use `127.0.0.1` como IP no `game.ini`.
- Feche o servidor antes de recompilar (o `.exe` em uso não pode ser
 sobrescrito no Windows).
- Crie uma conta de teste no banco se precisar — pergunte ao Cursor/Hermes
 como as contas são criadas (login usa `UserDB`).