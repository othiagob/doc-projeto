---
tags: [inicio, obsidian]
---

# Como usar este vault

Este cofre e o **livro de evolucao** do projeto. Capa no dia a dia:
[[Home]]. Como o livro se parte: [[Livro-de-Evolucao]]. Onde criar a
proxima nota: [[Onde-Escrever]]. Tres pastas no Windows:
[[Tres-Diretorios]]. Sync codigo -> livro: [[Ritual-Documentacao]]
(voce pede no chat; regra Cursor `01-consult-vault.mdc`).

## 1. Abrindo o vault

No Obsidian: **Abrir cofre -> Abrir pasta como cofre** ->
`C:\Users\carol\Desktop\doc-projeto` (repo `github.com/othiagob/doc-projeto`).

Caminho antigo (`OTHIAGOB PROJETO\source-priston\priston-documents`) nao
e a fonte viva.

## 2. Tres diretorios (nao misturar)

| Papel | Caminho |
|---|---|
| Cliente do jogo | `C:\Cliente Full` |
| Source code | `C:\Source Priston\Source Priston` |
| Este vault | `C:\Users\carol\Desktop\doc-projeto` |

Artes PNG/TGA: **Antigravity + Gemini** -> Cliente Full. Ver
[[Como-gerar-artes]] e a regra Cursor `05-directories-and-art.mdc`.

## 3. Plugins recomendados (todos gratuitos)

| Plugin | Por quê |
|---|---|
| **Templater** (comunidade) | criar diario/spec/decisao com data pronta |
| **Dataview** (comunidade) | listar specs abertas ou ultimos diarios |
| **Obsidian Git** (comunidade) | sync com `othiagob/doc-projeto` |
| **Excalidraw** (comunidade) | diagrama de fluxo de pacote |
| Notas diarias (nucleo) | apontar para `04-Diario-do-Projeto/` |

Comece so com Templater e Dataview.

## 4. Convencao de nomes

- Pastas `00-`...`12-` so ordenam a barra — nao sao prioridade.
- Diario / recap / sessao: `AAAA-MM-DD - titulo curto.md`
- Spec: `AAAA-MM-DD-nome-curto.md`
- ADR: `NNNN - titulo curto.md` (4 digitos)
- Aprendizado: um `Registro-de-Aprendizado.md` continuo, nao um por dia

Papel de cada pasta: tabela em [[Home]] e [[Livro-de-Evolucao]].

## 5. Tags (frontmatter)

- `#cliente` `#servidor` `#shared`
- `#bug` `#feature` `#aprendizado` `#decisao` `#ideia`
- `#ui` `#artes`
- `#thiago` — anotacao pessoal

```yaml
---
tags: [servidor, feature]
data: 2026-09-13
---
```

## 6. Git

Codigo: `C:\Source Priston\Source Priston` (`othiagob/Source-Priston`).
Este vault: `othiagob/doc-projeto`, branch `main`. `.gitignore` ignora
`.obsidian/workspace*.json`. Commits: [[Workflow-Git]]. Nao commitar
sem pedido.

## 7. Vault manda, rules acompanham

Fonte humana = este vault. Cursor le `.cursor/rules/` no repo do jogo.
Decisao nova: atualize **os dois**. Se divergirem, o vault manda.
[[Trabalhando-com-Multiplas-IAs]].
