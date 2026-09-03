---
tags: [processo, workflow, inicio]
---

# Fluxo de Trabalho — o ciclo padrão de uma tarefa

> Este é o **processo único e central** de como uma tarefa anda dentro do
> projeto, do início ao fim. Ele junta o que antes estava espalhado em vários
> lugares (Backlog, Templates, Workflow-Git, Home). Em caso de dúvida de
> "o que eu faço agora?", consulte este documento.

---

## Visão geral do ciclo

```
1. ESCOLHER  -> 2. (SPEC)  -> 3. ESTUDAR  -> 4. IMPLEMENTAR  -> 5. TESTAR  -> 6. REGISTRAR
   (Backlog)    (05-Specs)    (código)       (no Windows)     (jogo)       (diário+changelog)
```

Cada passo tem um "onde" e um "como". Os detalhes abaixo.

---

## 1. Escolher

- Tudo que você quer fazer um dia vive no **`08-Ideias/Backlog-de-Ideias.md`**.
- Antes de começar, escolha **uma** tarefa pequena. Regra do projeto:
  **escopo pequeno por tarefa** — nada de refactor gigante "de brinde".
- Se ainda estiver aprendendo, prefira os `03-Aprendizado-CPP/Exercicios-Seguros.md`
  (baixo risco, fáceis de reverter).

## 2. Spec (só se for não-trivial)

- **Quando precisa de spec:** feature/mudança que toca `Shared/` ou mais de
  uma pasta de módulo. Ver `05-Specs/TEMPLATE-Spec.md` (é um "SDD leve").
- **Quando NÃO precisa:** bug pontual, ajuste pequeno, exercício seguro —
  basta uma instrução clara no chat da IA.
- Copie o template para `05-Specs/AAAA-MM-DD-nome-curto.md`, preencha, e use
  como contexto na hora de pedir pra IA implementar.

## 3. Estudar

Antes de eu (ou você) tocar no código, entenda o sistema envolvido:
- Localize a pasta no `01-Projeto/Mapa-Geral-do-Projeto.md` ou na
  `02-Arquitetura/Arquitetura.md`.
- Se envolve rede/`Shared/`, leia `02-Arquitetura/Protocolo-de-Rede.md`,
  `02-Arquitetura/Glossario-Tecnico.md`, e cite os `smTRANSCODE_*`.
- Peça pra IA **listar os arquivos que pretende tocar ANTES de editar nada.**

## 4. Implementar

- **Onde:** no **Windows**, com o Cursor + Visual Studio. Nada se compila ou
  roda aqui no Linux (o opencode só faz análise/documentação/estudo).
- Siga as regras de ouro (ver `01-Projeto/Sobre-o-Projeto.md` e o
  `AGENTS.md`): não mexa em `dependencies/`, revise os dois lados do
  `Shared/`, não invente `smTRANSCODE_*`, não crie `.vcxproj`/`.sln`.
- Se a IA de chat gerar código, **passe pelo Cursor pra revisar** (ele tem o
  repo indexado) antes de aplicar.

## 5. Testar

- O projeto **não tem testes automatizados** — toda mudança de lógica exige
  um **plano de teste manual** (o que testar no jogo: tela, ação, pacote).
- O plano sai da spec (se houver) ou você o escreve antes de testar.
- Se mexeu em `Shared/`, testa client **e** server.

## 6. Registrar

- **Diário:** crie/anexe no `04-Diario-do-Projeto/` o que foi feito, o que
  decidiu, problemas e próximos passos (ver `TEMPLATE-Entrada-Diario`).
- **Decisão:** se houve escolha de arquitetura, registre um ADR em
  `06-Decisoes/` (o "porquê" importa mais que o "qual").
- **Aprendizado:** registre no `03-Aprendizado-CPP/Registro-de-Aprendizado.md`
  o que entendeu e o que ainda confunde.
- **CHANGELOG:** adicione uma linha em `CHANGELOG.md` na seção `[Unreleased]`.
- **Git:** faça o commit seguindo `07-Git-e-Workflow/Workflow-Git.md`
  (branch + conventional commits). Não commitar sem pedido explícito.

---

## Ferramentas envolvidas e seus papéis

| Ferramenta | Papel no ciclo |
|---|---|
| **Obsidian** | visualizar/editar este vault (fonte de verdade legível por humano) |
| **Cursor (Windows)** | implementar código no repo, com contexto via `.cursor/rules/` |
| **Visual Studio (Windows)** | compilar e testar o jogo |
| **opencode (Linux)** | estudar/analisar/documentar/planejar neste vault; cuidar do git aqui |
| **Hermes (Windows)** | análise profunda, documentação, diário |

> **Regra de ouro do ecossistema:** o **vault manda**. As `.cursor/rules/`
> e este AGENTS.md devem estar alinhados com o vault — não o contrário. Ver
> `01-Projeto/Trabalhando-com-Multiplas-IAs.md`.

---

## Referências

- Trabalho de git em si: `07-Git-e-Workflow/Workflow-Git.md`
- Divsão de papéis das IAs: `01-Projeto/Trabalhando-com-Multiplas-IAs.md`
- Como compilar/rodar: `09-Guias/`
