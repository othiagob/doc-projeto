---
tags: [inicio, obsidian]
---

# Como usar este vault

## 1. Abrindo o vault

No Obsidian: **Abrir cofre -> Abrir pasta como cofre** -> selecione a pasta
`priston-documents` (a raiz deste vault). Todo o conteúdo abaixo assume que
esse é o cofre raiz.

> Caminho completo: `C:\Users\carol\Desktop\OTHIAGOB PROJETO\source-priston\priston-documents`

## 2. Plugins recomendados (todos gratuitos)

| Plugin | Por quê |
|---|---|
| **Templater** (comunidade) | criar novas entradas de diário/spec/decisão já com data e estrutura prontas |
| **Dataview** (comunidade) | listar automaticamente, ex: "todas as specs abertas" ou "últimas 5 entradas de diário" |
| **Obsidian Git** (comunidade) | sincronizar o vault com um repositório git próprio de documentação |
| **Excalidraw** (comunidade) | desenhar diagramas de fluxo (ex: fluxo de pacote client->server) na nota |
| Notas diárias (núcleo) | ative em Configurações -> Notas diárias, aponte a pasta pra `04-Diario-do-Projeto/` |

Não precisa instalar tudo de uma vez — comece só com Templater e Dataview.

## 3. Convenção de nomes

- Pastas numeradas (`00-`, `01-`...) só pra controlar a ordem visual na
 barra lateral — não significam prioridade.
- Notas de diário: `AAAA-MM-DD - título curto.md`
- Decisões (ADR): `NNNN - título curto.md` (número sequencial, sempre 4 dígitos)
- Specs: `AAAA-MM-DD - nome-da-feature.md`
- Registro de aprendizado: `Registro-de-Aprendizado.md` — log contínuo, não
 crie um por dia

## 4. Tags

Use tags no frontmatter (topo do arquivo, entre `---`) pra facilitar busca:
- `#cliente` `#servidor` `#shared` — qual parte do código a nota toca
- `#bug` `#feature` `#aprendizado` `#decisao` `#ideia`
- `#thiago` — quando quiser filtrar suas próprias anotações

Exemplo de frontmatter:
```yaml
---
tags: [servidor, feature]
data: 2026-08-31
---
```

## 5. Sincronizando com git

O código do jogo tem seu próprio repositório git
(`C:\Source Priston\Source Priston`). Este vault de documentação pode:

**Opção A — repo separado só de docs** (recomendado): crie um repositório
`priston-docs` para esta pasta, com `.gitignore` ignorando
`.obsidian/workspace*.json` (config local do Obsidian, não deve ser
compartilhada). Use o plugin Obsidian Git pra push/pull automático.

**Opção B — docs dentro do repo do jogo:** simples, mas mistura o
histórico de código (que você quer limpo — ver [[Workflow-Git]]) com o de
notas soltas. Só vale se você não se importar com isso.

## 6. Regra de ouro do vault

Este vault é **fonte de verdade legível por humano**. As regras que a IA
(Cursor) usa automaticamente ficam em `.cursor/rules/` — mas o conteúdo
delas deve sempre estar alinhado com o que está aqui. Se mudar uma decisão
de arquitetura, atualize os dois lugares. Ver
[[Trabalhando-com-Multiplas-IAs]] para o porquê disso importar quando você
usar outras IAs além do Cursor (ex: o Hermes).