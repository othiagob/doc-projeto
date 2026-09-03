# Priston — Base de Documentação (leia isto primeiro)

Este vault do Obsidian é a **documentação viva** do projeto Source Priston:
arquitetura, protocolo de rede, banco de dados, decisões, diário de
trabalho, aprendizado de C++ e backlog de ideias. Ele existe pra você
(Thiago) e pra qualquer IA que você usar (Cursor, Hermes) partirem sempre
do mesmo entendimento do projeto.

> **Importante:** esta pasta (`priston-documents`) é **só a documentação**.
> O código do jogo fica em `C:\Source Priston\Source Priston` (com `SrcGame/`,
> `SrcServer/`, `Shared/`). As duas coisas são separadas — docs aqui, código lá.

## Como usar

1. Abra esta pasta no Obsidian: **Abrir cofre -> Abrir pasta como cofre**.
2. Comece por `Home.md` — é o mapa de tudo.
3. Se for mexer no código: leia `02-Arquitetura/Arquitetura.md` antes
 (é a planta baixa, verificada no código real em 2026-08-31).

## Onde cada coisa mora

| Pasta | O que tem |
|---|---|
| `00-Inicio/` | Como usar o vault, primeiros passos |
| `01-Projeto/` | Sobre o projeto, como trabalhar com múltiplas IAs |
| `02-Arquitetura/` | Arquitetura verificada, protocolo de rede, banco de dados, glossário |
| `03-Aprendizado-CPP/` | Trilha de estudos, exercícios seguros, registro de aprendizado |
| `04-Diario-do-Projeto/` | Log diário de trabalho (o que fez, o que decidiu) |
| `05-Specs/` | Specs de features + **SDD** (documento de design) |
| `06-Decisoes/` | ADRs — decisões de arquitetura e o porquê |
| `07-Git-e-Workflow/` | Convenções de git e fluxo de trabalho |
| `08-Ideias/` | **Backlog de ideias** — tudo que você quer fazer um dia |
| `09-Guias/` | Guias passo a passo (compilar, rodar, configurar) |
| `.cursor/rules/` | Regras que o Cursor carrega automaticamente (mantidas alinhadas com o vault) |

## Regra de ouro do vault

O vault é **fonte de verdade legível por humano**. As regras que a IA
(Cursor) usa ficam em `.cursor/rules/` — e devem estar sempre alinhadas
com o que está aqui. Se mudar uma decisão de arquitetura, atualize os dois
lugares. Para conversar com o Hermes sobre este projeto, o conteúdo do
vault é o contexto a ser colado (ou você pode pedir pro Hermes ler o vault
direto).

## Código-fonte

- **Local:** `C:\Source Priston\Source Priston`
- **Git:** repositório já inicializado (`git log` mostra o histórico)
- **Estrutura:** `SrcGame/` (cliente) · `SrcServer/` (servidor) ·
 `Shared/` (código compartilhado) · `dependencies/` (bibliotecas de terceiros)