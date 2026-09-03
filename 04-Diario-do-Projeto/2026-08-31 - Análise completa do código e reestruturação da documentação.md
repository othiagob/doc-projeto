---
tags: [documentacao, analise, arquitetura]
data: 2026-08-31
---

# 2026-08-31 - Análise completa do código e reestruturação da documentação

## O que foi feito

- **Análise profunda do código-fonte** (feita pelo Hermes, com 3 frentes
 paralelas): servidor (`SrcServer/`), cliente (`SrcGame/`) e
 build/dependências (Delta3D, zlib, rapidjson, Discord, Lua...).
- **Verificação da arquitetura**: os "(a validar)" da primeira versão da
 documentação foram substituídos por fatos confirmados no código real.
- **Reestruturação do vault para uso individual** (Thiago):
  - removidas as referências ao trabalho em dupla (arquivos antigos da
 equipe movidos para `_arquivado-equipe/`)
  - `01-Equipe/` -> `01-Projeto/` com [[Sobre-o-Projeto]]
  - novas pastas: `08-Ideias/` (backlog), `09-Guias/`
  - arquivos legados do starter kit movidos para `_arquivado/`
- **Novos documentos**: [[Protocolo-de-Rede]], [[Banco-de-Dados]],
 [[SDD-Source-Priston]], [[Backlog-de-Ideias]], guias
 ([[Como-Compilar]], [[Como-Rodar]]).
- **Regras do Cursor atualizadas e instaladas** dentro do repositório do
 jogo (`C:\Source Priston\Source Priston\.cursor\rules\`) — antes só
 existiam no vault, o Cursor não carregava.

## Descobertas principais

- Servidor conecta em **SQL Server via ODBC**, config em
 `Server\Config\SQL.ini`, com 11 bancos (UserDB, ServerDB, LogDB...).
- Porta do jogo: **8185** (`TCP_GAMEPORT` em `smwsock.h`, igual nos 2 lados).
- Protocolo: `Shared/smPacket.h` (~2.800 linhas de `smTRANSCODE_*` +
 structs) — o contrato entre cliente e servidor.
- O `game.ini` do cliente aponta para `189.46.228.170:31620` — conferir se
 é a config desejada (para teste local, usar `127.0.0.1`).

## Decisões tomadas

- Documentação passa a ser **pessoal** (Thiago) — ver [[0001 - Uso de Cursor Rules e estrutura de docs]]
- Vault = fonte de verdade legível por humano; `.cursor/rules/` = contexto
 da IA no Cursor; ambos alinhados (vault manda).

## Problemas encontrados

- `game.ini` com IP de servidor externo — precisa revisar.
- Credenciais padrão de banco hardcoded em `gameSQL.cpp` (fallback) —
 trocar se expor o servidor.
- Mapa de tabelas do banco ainda não feito.

## Próximos passos

- Ler a [[Arquitetura]] verificada e o [[SDD-Source-Priston]]
- Escolher o primeiro exercício em [[Exercicios-Seguros]] ou ideia do
 [[Backlog-de-Ideias]]
- Mapear as tabelas do banco (SSMS + inspeção)
- Revisar `game.ini` / config de conexão

## Notas soltas

O Hermes salvou um skill de projeto ("priston-tale-project") e memória
sobre o projeto — próximas conversas já começam com o contexto carregado.