---
tags: [inicio, processo]
status: ativo
data: 2026-09-13
---

# Onde escrever cada nota

Uma pergunta, um destino. Evita diario virar spec e spec virar recap.

## Acabei de fazer algo

| O que foi | Onde |
|---|---|
| Um dia de trabalho (qualquer tamanho) | `04-Diario-do-Projeto/AAAA-MM-DD - titulo.md` |
| Uma linha "o que mudou no build" | `CHANGELOG.md` secao `[Unreleased]` |
| Tela/processo que o **jogador percebe** | `10-Processos/` (copie o TEMPLATE) |
| Bloco de varios dias, falhas, decisoes | `11-Evolucao/` |
| Arte / "ja temos esse PNG?" | `12-UI-e-Artes/Inventario-de-Artes.md` (atualize a tabela) |
| "Por que escolhemos A e nao B" | `06-Decisoes/NNNN - titulo.md` (proximo numero) |
| Mudanca grande de fluxo (rede, save, janela + logica) | `02-Arquitetura/<Nome>.md` com mermaid — [[Como-documentar-funcionalidade]]. Modelo: [[Armazem]] |

## Quero fazer algo

| O que e | Onde |
|---|---|
| Ideia solta | `08-Ideias/Backlog-de-Ideias.md` |
| Melhoria concreta ja viavel | `08-Ideias/Melhorias-Sugeridas.md` |
| Tela / UI / correio / armazem | `12-UI-e-Artes/Roadmap-UI.md` **e** o backlog |
| Feature nao-trivial (Shared, banco, fluxo novo) | spec em `05-Specs/AAAA-MM-DD-nome.md` |
| PNG novo | Antigravity + Gemini -> `C:\Cliente Full` — [[Como-gerar-artes]] |

## Quero entender o codigo

| Pergunta | Onde |
|---|---|
| Visao geral | [[Mapa-Geral-do-Projeto]] |
| Planta, pacote, banco | `02-Arquitetura/` |
| Como compilar / SQL / VPS | `09-Guias/` |
| Exercicio de C++ ou SQL | `03-Aprendizado-*/` |
| Tres pastas no disco | [[Tres-Diretorios]] |

## Nao crie nota nova se

- Ja existe recap daquela tela — **atualize** o recap ou o inventario.
- E so um path de PNG — vai em [[Onde-vivem-as-imagens]] / inventario.
- E uma decisao ja tomada — linke a ADR, nao reescreva.

Nomes: diario e recap `AAAA-MM-DD - titulo curto.md`. Spec
`AAAA-MM-DD-nome-curto.md`. ADR `NNNN - titulo.md` (4 digitos).

Livro: [[Livro-de-Evolucao]]. Capa: [[Home]].

Fim do dia / fim da semana: [[Ritual-Documentacao]] (o usuario pede no
chat; a IA atualiza o livro a partir do codigo e da conversa).
