---
tags: [projeto, visao]
---

# Sobre o Projeto — Source Priston

## O que é

Um servidor privado de **Priston Tale**, um MMORPG clássico coreano dos
anos 2000. Este repositório contém o **código-fonte completo** do servidor
e do cliente, em **C++** (projeto Visual Studio 2022, 32-bit). A base de
código é a **WDPT** (uma das bases conhecidas de servidor de Priston),
modernizada com várias melhorias (novo acesso a banco, Discord, JSON, etc.).

> Uma nota importante sobre a origem: código de Priston Tale circula há
> anos na comunidade de servidores privados. A base veio de forks públicos.
> Não é um produto comercial — é um projeto de estudo/prazer.

## O que você quer com ele

- **Aprender programação de verdade** (C++, redes, banco de dados, jogos),
 usando o projeto real como material de estudo.
- **Editar e melhorar o jogo** com ajuda de IA (Cursor) — você não precisa
 digitar código, mas quer **entender** o que está sendo feito e saber
 **pedir as coisas direito**.
- **Documentar tudo** — por isso existe este vault (ver `Home.md`).

## Estado atual

- [x] Cliente e servidor **compilam** (Debug/Release, Win32)
- [x] Você **consegue logar** no jogo (servidor + cliente rodando na sua máquina)
- [x] Repositório git inicializado (`C:\Source Priston\Source Priston`)
- [x] Documentação de arquitetura verificada no código real (2026-08-31)
- [x] Aprender os sistemas um a um (ver [[Trilha-de-Aprendizado]])
- [x] Primeiras alterações reais (ver [[Backlog-de-Ideias]] e [[Exercicios-Seguros]])

## Regras de ouro do projeto (não negociáveis)

1. **Nunca edite `dependencies/`** — são bibliotecas de terceiros
 (Delta3D, zlib, rapidjson...). Se um problema parecer vir de lá,
 contorne no código do jogo/servidor.
2. **Toda mudança em `Shared/` implica revisar os dois lados** — cliente E
 servidor usam o mesmo código compartilhado (protocolo, tabelas de
 skill/nível). Mudar só de um lado dessincroniza o jogo.
3. **Não invente códigos de pacote (`smTRANSCODE_*`)** — são o contrato de
 rede. Número duplicado ou errado quebra a comunicação silenciosamente.]
4. **Escopo pequeno por tarefa** — não faça refactors gigantes "de brinde".
5. **Não há testes automatizados** — toda mudança de lógica precisa de um
 plano de teste manual claro (o que testar no jogo).

## Configurações atuais conhecidas

| Item | Valor |
|---|---|
| Código-fonte | `C:\Source Priston\Source Priston` |
| Documentação | `C:\Users\carol\Desktop\OTHIAGOB PROJETO\source-priston\priston-documents` |
| Cliente (solução) | `SrcGame\Game.sln` -> `game.vcxproj` |
| Servidor (solução) | `SrcServer\server.sln` -> `server.vcxproj` |
| Código compartilhado | `Shared\` (projeto `Shared.vcxitems`) |
| Banco de dados | SQL Server via ODBC (config: `Server\Config\SQL.ini`) |
| Conexão do cliente | `game.ini` -> seção `[ConnectServer]` (IP + porta) |

## Ferramentas

| Ferramenta | Para quê |
|---|---|
| **Visual Studio 2022** | compilar e debugar (obrigatório — os `.sln` são dele) |
| **Cursor** | editar código com IA (carrega `.cursor/rules/` automaticamente) |
| **Hermes** | análises, documentação, diário — este vault é o contexto compartilhado |
| **Obsidian** | este vault — documentação viva |
| **Git / GitHub** | versionamento (ver [[Workflow-Git]]) |
| **SQL Server Management Studio** | administrar o banco (usuários, tabelas) |

## Links rápidos

- [[Arquitetura]] — planta baixa do código
- [[SDD-Source-Priston]] — documento de design completo
- [[Backlog-de-Ideias]] — o que fazer a seguir
- [[2026-08-31 - Análise completa do código e reestruturação da documentação]] — o que foi analisado