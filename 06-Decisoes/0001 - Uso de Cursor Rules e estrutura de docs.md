---
tags: [decisao, documentacao]
status: aceita
---

# 0001 - Uso de Cursor Rules + vault do Obsidian como documentação viva

## Contexto

O projeto é um MMO cliente-servidor grande (client ~1.150 arquivos, server
~260, shared ~330) em C++ legado, sem testes automatizados, com protocolo
de rede compartilhado entre client e server. Vai ser desenvolvido a longo
prazo por uma pessoa (Thiago), aprendendo C++ no processo, usando Cursor
e outras IAs (Hermes). Precisávamos de uma forma de documentar que não vire
peso morto e que sirva tanto pra IA quanto pra humano.

## Opções consideradas

1. **Só um README grande** — simples, mas não escala: vira um arquivo
 gigante difícil de manter e sem estrutura pra decisões/aprendizado.
2. **Wiki externa (Notion, Confluence)** — boa pra times maiores, mas
 desconectada do repositório de código e do editor de fato usado.
3. **`.cursor/rules/` (IA) + vault de Obsidian (humano) como fonte de
 verdade, mantidos alinhados manualmente** — mais setup inicial, mas
 escala bem, funciona offline, versiona em git, e serve de contexto pra
 qualquer IA (não só Cursor).

## Decisão

Opção 3. `.cursor/rules/*.mdc` carrega automaticamente no Cursor; o vault
de Obsidian é a fonte legível por humano (arquitetura, decisões,
aprendizado, diário) e serve de "contexto pra colar" em qualquer outra IA
(ex: Hermes). As duas fontes devem ser mantidas alinhadas manualmente — o
vault manda em caso de divergência.

Nota (2026-08-31): o vault foi reestruturado para uso individual (Thiago) e
a documentação de arquitetura foi **verificada no código real**, removendo
as hipóteses "(a validar)" que existiam na primeira versão.

## Consequências

- Ganho: histórico de decisões e aprendizado não se perde; qualquer IA
 usada consegue receber o mesmo contexto; retomar o trabalho depois de um
 tempo longe fica muito mais rápido.
- Custo: exige disciplina de atualizar dois lugares quando uma decisão de
 arquitetura muda. Se isso não for mantido, as `.cursor/rules/` ficam
 desatualizadas silenciosamente — risco a monitorar.