---
tags: [git, workflow, equipe]
---

# Workflow de Git — Source Priston

Objetivo: um histórico que você (ou qualquer pessoa, daqui a 1 ano) consiga
ler e entender "o que mudou e por quê" sem abrir o diff inteiro, e que
permita reverter uma feature isolada sem levar outras junto.

## 1. Branches

Trabalhando sozinho, não precisa de um fluxo pesado, mas precisa de
**isolamento por tarefa**:

- `main` — sempre compila, sempre "jogável". Nunca commit direto aqui.
- `feature/<nome-curto>` — uma feature ou melhoria (ex: `feature/roleta-drop-rate`)
- `fix/<nome-curto>` — correção de bug (ex: `fix/party-exp-split`)
- `chore/<nome-curto>` — build, docs, limpeza, sem mudar comportamento

Regra prática: **se a tarefa toca em `Shared/`, o nome da branch deve deixar
isso óbvio** (ex: `feature/shared-new-skill-packet`), porque você vai querer
lembrar de testar client E server antes de mergear.

Fluxo:
```
git checkout main
git pull
git checkout -b feature/nome-da-tarefa
# ... trabalha, commita em pedaços pequenos ...
git checkout main
git merge --no-ff feature/nome-da-tarefa # --no-ff preserva o agrupamento no log
git branch -d feature/nome-da-tarefa
```

## 2. Convenção de commit

Formato: [Conventional Commits](https://www.conventionalcommits.org/), adaptado:

```
<tipo>(<escopo>): <resumo curto no imperativo>

<corpo opcional: por quê, não o quê — o diff já mostra o quê>

<rodapé opcional: refs, breaking changes>
```

**Tipos:**
| Tipo | Quando usar |
|---|---|
| `feat` | nova funcionalidade de jogo |
| `fix` | correção de bug |
| `refactor` | muda estrutura sem mudar comportamento |
| `perf` | melhoria de performance |
| `docs` | só documentação |
| `chore` | build, dependências, config |
| `net` | mudança que toca protocolo (`Shared/smPacket.h` ou handlers) — **use sempre que aplicável, além do tipo acima**, ex: `feat(net)` |

**Escopo:** use a pasta principal afetada — `client`, `server`, `shared`,
`skills`, `party`, `shop`, `security`, `db`, etc.

**Exemplos bons:**
```
feat(shared): adiciona smTRANSCODE_OPEN_ROLETA para novo sistema de roleta

fix(server/security): valida limite de dano de skill de longo alcance

O client conseguia enviar smTRANSCODE_SKIL_ATTACKDATA com dano acima do
máximo da skill sem o server rejeitar. Adiciona clamp no handler.

refactor(client/hud): extrai barra de vida para componente reutilizável
```

**Regra dura:** se o commit mexe em `Shared/`, o corpo do commit **precisa**
dizer explicitamente se o lado client e o lado server foram atualizados
juntos, ou se é intencionalmente incremental (ex: "server ainda não trata
o pacote novo, próximo commit").

## 3. Tamanho de commit

- Um commit = uma mudança logicamente completa e (idealmente) que compila.
- Evite commits "checkpoint" tipo `wip`, `ajustes`, `fix 2`. Se precisar
 salvar progresso no meio de algo quebrado, use `git commit --amend` ou
 `git stash`, não polua o histórico principal.
- Exceção aceitável: commits de exploração numa branch de feature podem ser
 mais soltos — mas ao mergear em `main`, considere `git merge --squash`
 para consolidar em 1 commit limpo por feature, se o histórico intermediário
 não tiver valor.

## 4. Tags e releases

Quando você fizer um build que vai para jogadores/testers, marque:
```
git tag -a v0.3.0 -m "Sistema de roleta + fix de exp em party"
git push origin v0.3.0
```
Isso te dá um ponto de retorno confiável ("volta pra última versão que
rodava em produção") sem depender de lembrar qual commit era.

## 5. .gitignore — pontos de atenção

Seu `.gitignore` atual já cobre binários de build (`/OutDir`, `/bin`, `.vs`).
Vale adicionar, se ainda não tiver:
```
*.pdb
*.ilk
*.aps
*.user
```
E confirmar que **nenhum arquivo de `dependencies/*/Lib/*.lib` gigante** está
sendo versionado sem necessidade — libs pré-compiladas grandes deveriam
idealmente estar em um release/artefato separado, não no histórico do git
(elas já infuflam MUITO o tamanho do repositório e do índice do Cursor).