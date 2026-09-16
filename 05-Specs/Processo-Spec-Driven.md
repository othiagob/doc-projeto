---
tags: [specs, processo, workflow]
status: ativo
data: 2026-09-06
---

# Processo Spec-Driven — como toda mudança não-trivial nasce e morre

> Este é o **processo oficial** do projeto. Não é burocracia: é o que
> impede que uma ideia esquecida vire 500 linhas de código ilegível que
> ninguém sabe por que está ali.
>
> **Regra central:** antes de o Cursor escrever código novo ou mexer em algo
> que já funciona, existe um documento curto descrevendo o quê, por quê e
> como testar. Se depois de uma semana o projeto quebrar, a spec diz por quê.

---

## Via rápida (não precisa de spec)

Ajustes que **não** mexem em `Shared/`, **não** criam comportamento novo visível
ao jogador e **não** tocam banco de dados — bug pontual, tradução, ajuste de
log — vão direto pro chat do Cursor com uma instrução clara. Exige apenas:
instrução clara + plano de teste manual curto + registro no diário.

Se em algum momento parecer que está "crescendo", **pare e vire spec**.

---

## Ciclo completo (spec obrigatória)

```
 1. IDEIA          2. BACKLOG          3. SPEC           4. REVISÃO DO PLANO
 (anotar onde      (08-Ideias/          (05-Specs/        (Cursor lista arquivos
  surgiu)           Backlog)              TEMPLATE)        ANTES de editar)

 5. IMPLEMENTAR    6. TESTAR           7. REGISTRAR      8. ARQUIVAR
 (Windows/Cursor)  (manual,            (diário +        (spec fica no repo,
  conforme spec)    conforme spec)      CHANGELOG + ADR)  marcada como feita)
```

### 1. Ideia

Anotou no momento em que surgiu, com duas linhas: o quê + por quê.
Qualquer lugar serve, mas o destino final é sempre o backlog.

### 2. Backlog

`08-Ideias/Backlog-de-Ideias.md` — tudo em um lugar só, com status.
Telas e artes (feito vs falta) também no mapa `12-UI-e-Artes/` — não
comece uma janela pelo chat se já existir spec lá.
Antes de começar, a ideia precisa ter **status** claro lá:

| Status | Significado |
|---|---|
| `ideia` | só anotação |
| `estudar` | precisa entender o código antes de planejar |
| `spec` | virou spec em `05-Specs/` |
| `em andamento` | Cursor está implementando agora |
| `feito` | implementado e testado (link pro diário) |
| `descartada` | decidiu não fazer — anote por quê |

### 3. Spec

Copia `TEMPLATE-Spec.md` pra `05-Specs/AAAA-MM-DD-nome-curto.md` e preenche.
Regra prática: **se você não consegue escrever "fora de escopo", a spec
não está pronta** — é sinal de que o escopo está mal definido.

### 4. Revisão do plano (porta de entrada do Cursor)

Antes de o Cursor tocar em qualquer arquivo:

> "Leia essa spec, o CHANGELOG/recap/evolucao do assunto, e
> `02-Arquitetura/Arquitetura.md`. Liste **todos** os arquivos que você
> pretende tocar, em ordem, antes de editar qualquer um.
> Se algum arquivo fora da lista for necessário, peça antes."

O Cursor deve consultar o livro sozinho (regra `01-consult-vault.mdc`):
ja fizemos isso? o que foi revertido?

Se a lista vier com arquivo de `Shared/`, confira os pontos de impacto nos
dois lados (`SrcGame` + `SrcServer`) **você mesmo**, sem delegar.
Se vier com `smTRANSCODE_*` novo, verifique em `Shared/smPacket.h` que o
número não existe ainda.

### 5. Implementar

Cursor no Windows, com o plano aprovado. Uma feature = uma branch
(`feature/nome-curto`). Sem refactor de brinde: se a IA notar algo que
merece limpar, lista no fim da resposta como sugestão — não aplica junto.

### 6. Testar

Sem testes automatizados. O plano sai da spec. Toda feature nova precisa de:
- [ ] testar no cliente (o que aparece na tela, se aparece)
- [ ] testar no servidor (log, banco, NO banco)
- [ ] se tocou `Shared/`: testar client **e** server juntos

### 7. Registrar

Três artefatos, sempre:
1. **Diário** em `04-Diario-do-Projeto/` — o que fez e o que testou
2. **CHANGELOG** — uma linha na seção `[Unreleased]`
3. **ADR** em `06-Decisoes/` — só se houve escolha de arquitetura
   ("por que fizemos assim e não de outro jeito")

### 8. Arquivar

Spec ganha `status: feito` no frontmatter e o backlog muda pra `feito` com
link pro diário. **Não apague a spec** — ela vira documentação histórica.

---

## Status de uma spec (frontmatter)

```yaml
---
tags: [specs]
status: rascunho | ativa | implementando | feito | descartada
data: AAAA-MM-DD
---
```

Fuja do costume de "escrever spec pra ficar bonito". Spec sem status correto
é pior que spec nenhuma, porque dá a ilusão de que a feature está gerenciada.

---

## Regras práticas (resumo colável)

1. Ideia: anote no momento, em qualquer lugar.
2. Ideia que sobrevive a 2 dias: vai pro Backlog.
3. Feature vindo do backlog ou mexendo em `Shared/`/banco: spec.
4. Cursor só escreve código depois de listar os arquivos.
5. Uma feature = uma branch = um plano de teste = um item no diário.
6. Spec sobrevive à feature — vira documentação.
