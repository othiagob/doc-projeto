---
tags: [inicio, moc, evolucao]
status: ativo
data: 2026-09-13
---

# O livro de evolucao

Este vault e o **livro** do Source Priston / Fallen Tale: a historia do
que ja fizemos, as regras que nao queremos esquecer, e o caminho que
vamos seguir. Nao e um dump de arquivos. Cada pasta tem um papel. Se
nao souber onde escrever, use [[Onde-Escrever]].

Os tres mundos fora do livro: [[Tres-Diretorios]].

## Quatro partes do livro

```
MUNDO      o que o projeto e, onde mora, como o codigo se parte
HISTORIA   o que ja aconteceu (dia, recap, bloco, changelog)
REGRAS     o que decidimos e nao queremos repetir o erro
CAMINHO    o que vem (ideia, spec, roadmap) e ainda nao e codigo
```

| Parte | Pastas | Quando abrir |
|---|---|---|
| **Mundo** | `01-Projeto/`, `02-Arquitetura/`, `09-Guias/`, `Dados-SQL/` | "como isso funciona hoje?" |
| **Historia** | `04-Diario/`, `10-Processos/`, `11-Evolucao/`, `CHANGELOG.md` | "ja fizemos? o que quebramos?" |
| **Regras** | `06-Decisoes/`, `.cursor/rules/` (no repo do jogo) | "por que e assim?" |
| **Caminho** | `08-Ideias/`, `05-Specs/`, `12-UI-e-Artes/` | "o que falta? qual a proxima tela?" |

Aprendizado (`03-Aprendizado-CPP/`, `03-Aprendizado-SQL/`) e o caderno
de estudo **ao lado** do livro — nao mistura com recap de feature.

## Como a historia se empilha (nao duplique)

Do mais curto para o mais longo:

1. **CHANGELOG** — uma linha. "O que mudou desde o ultimo build."
2. **Diario** (`04-`) — o rascunho do dia. Honesto, curto.
3. **Recap** (`10-Processos/`) — uma tela ou um processo que o jogador
   percebe. Como era / o que ve agora / por que.
4. **Sessao** (`11-Evolucao/`) — um **bloco** de dias: varias areas,
   falhas revertidas, decisoes. Reler daqui a meses.
5. **Planta de feature** (`02-Arquitetura/<Nome>.md`) — fluxograma
   mermaid quando o fluxo mudou (rede, save, hibrido UI/logica).
   Modelo: [[Armazem]]. Convencao: [[Como-documentar-funcionalidade]].

UI e artes tem um **mapa** em `12-UI-e-Artes/` que aponta para recaps e
specs; o mapa nao substitui a historia.

## Como o caminho anda

```
ideia (08) -> spec (05) -> Cursor lista arquivos -> codigo na source
         -> arte no Cliente Full (Antigravity/Gemini, se PNG)
         -> teste no jogo -> diario + changelog + recap
```

Ciclo oficial: [[Processo-Spec-Driven]] e [[Fluxo-de-Trabalho]].

## Regras do livro

- Sem emoji, sem enfeite. Texto que da para reler.
- Spec **antes** de feature que toca `Shared/`, banco ou comportamento
  visivel grande.
- Vault e Cursor rules **alinhados**. Se divergirem, o vault manda —
  atualize a `.mdc` na mesma sessao ([[Trabalhando-com-Multiplas-IAs]]).
- Nao renomeie pasta numerada sem atualizar Home, AGENTS e este arquivo.

Capa do dia a dia: [[Home]].

## Habito: consultar e atualizar

- **Antes de codigo:** o Cursor le o livro (regra
  `.cursor/rules/01-consult-vault.mdc`) para nao repetir o que ja
  fizemos ou o que ja falhou.
- **Depois, no ritmo:** Thiago pede no chat o ritual diario ou semanal.
  Checklist: [[Ritual-Documentacao]].

