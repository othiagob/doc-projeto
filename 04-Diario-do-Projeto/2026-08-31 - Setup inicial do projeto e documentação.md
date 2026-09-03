---
tags: [documentacao]
data: 2026-08-31
---

# 2026-08-31 - Setup inicial do projeto e documentação

> Nota: esta entrada documenta o início do projeto (quando a documentação
> era pensada pra ser usada em dupla). Em 2026-08-31 a documentação foi
> reestruturada para uso individual — ver
> [[2026-08-31 - Análise completa do código e reestruturação da documentação]].

## O que foi feito

- Análise da estrutura completa do source (client `SrcGame/`, server
 `SrcServer/`, `Shared/`, `dependencies/`)
- Criação da primeira versão de `docs/ARCHITECTURE.md` mapeando os módulos
 encontrados (Caravana, Eventos, VIP, Roleta, Skills por classe, etc.)
- Criação das regras do Cursor (`.cursor/rules/*.mdc`) com foco no maior
 risco identificado: dessincronia entre client e server em código
 `Shared/` (protocolo de rede `smPacket.h`, `LevelTable.h`, skills)
- Criação do workflow de git (branches, convenção de commit, tags de
 release) e template de spec leve (SDD)
- Migração de tudo para um vault de Obsidian estruturado, pensado pra
 funcionar como fonte de contexto pra qualquer IA, não só o Cursor

## Decisões tomadas

Ver [[0001 - Uso de Cursor Rules e estrutura de docs]]

## Problemas encontrados

Vários módulos (`sinbaram`, `smLib3d`, `HoBaram`, `TJBOY`, `Aging`) ainda
sem função confirmada — só hipótese pelo nome da pasta. Fica marcado como
pendência em [[Arquitetura]] e [[Glossario-Tecnico]].

## Próximos passos

- Confirmar, aos poucos, os "(a validar)" em [[Arquitetura]]
- Decidir: vault dentro do repo do jogo ou em repositório separado (ver
 [[Como-Usar-Este-Vault]] seção 5)

## Notas soltas

Repositório está com libs de terceiros pré-compiladas grandes versionadas
(`dependencies/*/Lib/*.lib`, uma delas ~35MB) — vale reavaliar se isso
precisa estar no histórico do git ou pode virar um artefato baixado à
parte.