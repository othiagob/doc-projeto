---
tags: [guias, sql, vps, ops]
data: 2026-09-06
---

# VPS e SQL Server — operação do banco em produção

> Situação atual: **SQL Server já está no ar na VPS** e o jogo roda contra
> ele. Este guia documenta o setup, a rotina de manutenção e os pontos
> que ainda precisam de atenção.
>
> **Espaços `<assim>`:** preencha com os dados reais da sua VPS (não coloque
> senha em doc nenhuma!).

## Inventário do ambiente

| Item | Valor |
|---|---|
| VPS (provedor) | `<provedor>` |
| IP / hostname | `<ip da vps>` |
| Instância SQL Server | `<NOME\INSTANCIA>` |
| Porta TCP do SQL | `<1433 ou outra>` |
| Versão (ex: 2019 Express) | `<versao>` |
| Como você conecta (SSMS) | `<usuario e como>` |
| Bancos | UserDB, UserDB(VIP), ServerDB, LogDB, ClanDB, SoDDB, EventosDB, ShopCoin, Quest, GameServer, ITEMLogDB, PainelDB (ver [[Banco-de-Dados]]) |

As 12 bases acima são as que o código do servidor conhece
(`SrcServer/src/Server/Database/`, `Server\Config\SQL.ini`).

## O que já está funcionando

- [ ] SQL Server instalado e acessível
- [ ] Bancos criados e o servidor do jogo conecta neles
- [ ] Dao de tabelas extraídas no vault (`Dados-SQL/`)

## Checklist de segurança (pendências — em ordem de prioridade)

- [ ] **Porta 1433 exposta?** só as máquinas que precisam do banco (o
  servidor do jogo, e a sua máquina pro SSMS) devem alcançar a porta. No
  firewall da VPS, libere o IP de origem, não o mundo.
- [ ] **A aplicação conecta com `sa`?** usuário de aplicação deve ser outro,
  com permissão só nos bancos do jogo, sem acesso a outros servidores. É a
  melhoria 1.2 de [[Melhorias-Sugeridas]].
- [ ] **Senhas de conta em texto puro** na tabela `Users` — prioridade alta.
  Ver [[Melhorias-Sugeridas]] 1.1 e discuta antes de mexer.
- [ ] **SQL.ini com credenciais em claro no servidor** — proteja o arquivo
  (permissões de leitura só do usuário do serviço).

## Rotina de backup (fazer antes de qualquer UPDATE/DELETE em produção!)

Mínimo viável: backup diário automático + teste de restore.

Opção A — **nativa do SQL Server** (recomendada, sem agente externo):

1. No SSMS: `Banco -> Tarefas -> Backup` (gera o script do comando
   `BACKUP DATABASE ... TO DISK`).
2. Transforme em job agendado (SQL Server Agent em versão paga, ou tarefa
   agendada do Windows chamando o `sqlcmd` na versão Express).

Comando-base (adicione os caminhos reais):

```sql
BACKUP DATABASE [ServerDB]
TO DISK = N'C:\Backups\ServerDB-diario.bak'
WITH COMPRESSION, INIT;
```

Opção B — **script na VPS** (`.ps1` chamando o comando acima pra cada um
dos 12 bancos), agendado pra rodar toda madrugada.

**Teste de restore (faça uma vez):** num banco de teste, restaure um backup
e confira que as tabelas voltam. Backup não testado não é backup.

Rotina de retenção: mantenha no mínimo os últimos 7 backups diários
(copie pra fora da VPS se for possível).

## Banco de teste local (recomendado)

Pra praticar os [[Exercicios-SQL-Guiados]] sem tocar em produção:

1. Crie um banco local (na sua máquina ou um segundo banco na VPS).
2. Reimporte as tabelas a partir das exportações `Dados-SQL/` (ou faça
   `BACKUP`/`RESTORE` de um banco de produção, se o tamanho permitir).
3. Registre aqui como foi feito — vira o guia da próxima vez.

## Referências

- Arquitetura das 12 bases: [[Banco-de-Dados]]
- Dicionário de colunas: `Dados-SQL/README.md`
- Melhorias pendentes: [[Melhorias-Sugeridas]] (seção Segurança + Banco de dados)
- Trilha de estudo: [[Trilha-SQL-Server]]
