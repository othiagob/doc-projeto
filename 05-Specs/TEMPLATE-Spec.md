---
tags: [specs, sdd]
---

# Como usar specs neste projeto (SDD leve)

Ideia central: **antes de pedir pro Cursor implementar algo não-trivial,
escreva uma spec curta.** Isso não é burocracia — é o que evita que o
Cursor "adivinhe" a arquitetura errada e produza 500 linhas que você precisa
jogar fora.

Regra prática: **specs para features/mudanças que tocam `Shared/` ou mais de
uma pasta de módulo. Bugs pontuais e ajustes pequenos não precisam de spec —
só uma instrução clara no chat já basta.**

> Para a visão geral do projeto (o documento de design completo), veja
> [[SDD-Source-Priston]].

## Fluxo

1. Copie o template abaixo para `05-Specs/AAAA-MM-DD-nome-curto.md`.
2. Preencha as seções — pode ser em texto corrido, não precisa ser perfeito.
3. Cole a spec no chat do Cursor e peça: *"leia essa spec e a
 `02-Arquitetura/Arquitetura.md`, depois me diga quais arquivos você
 pretende tocar ANTES de editar qualquer coisa"*. Revise a lista antes de
 deixar ele codar.
4. Depois de implementado, volte na spec e marque o checklist de teste manual.
5. Guarde a spec no repo (não apague) — vira documentação histórica de por
 que aquela decisão foi tomada.

---

## Template

```markdown
# Spec: <nome da feature/mudança>

## Contexto
Por que isso está sendo feito. (bug reportado? feature nova pedida por quem?
melhoria de performance notada onde?)

## Escopo
O que ESTÁ incluído nesta mudança.

## Fora de escopo
O que NÃO deve ser tocado (evita que o Cursor "melhore" coisas ao lado).

## Impacto em Shared / protocolo
- Toca em `Shared/`? [sim/não]
- Se sim: quais arquivos, e o client e server precisam mudar juntos ou
 incrementalmente?
- Novo(s) smTRANSCODE_* necessário(s)? Liste nome e propósito.

## Módulos afetados
- [ ] SrcGame: <pastas>
- [ ] SrcServer: <pastas>
- [ ] Shared: <arquivos>

## Comportamento esperado
Descreva o "antes" e o "depois" do ponto de vista do jogador/admin.

## Plano de teste manual
(sem testes automatizados ainda — seja específico)
1. Passo a passo de como reproduzir/validar
2. O que observar no client
3. O que observar no server (log, banco)

## Riscos conhecidos
O que pode quebrar de colateral (ex: "mexe em LevelTable.h, pode afetar
XP de outras classes além da pretendida").
```

---

## Por que isso funciona bem com o Cursor

- O Cursor não tem memória entre sessões — a spec vira o "estado" que você
 reaproveita em conversas diferentes sem reexplicar tudo.
- Forçar "liste os arquivos antes de editar" evita o problema mais comum em
 código legado grande: a IA editar um arquivo errado que *parece* certo
 pelo nome, mas não é o que está de fato em uso.
- Specs guardadas em `05-Specs/` viram, com o tempo, a documentação de
 arquitetura que o projeto nunca teve — sem esforço extra de "documentar
 depois".