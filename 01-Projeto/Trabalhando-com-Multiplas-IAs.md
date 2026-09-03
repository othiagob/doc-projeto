---
tags: [projeto, ia]
---

# Trabalhando com múltiplas IAs (Cursor + Hermes + opencode)

Você vai usar mais de uma IA: o **Cursor** (edição de código com o
repositório indexado, no Windows), o **Hermes** (análises, documentação,
diário) e o **opencode** (mesma coisa que o Hermes, mas rodando no Linux —
análise, documentação, planejamento e git). Eventualmente outras (pesquisa,
revisão). Isso é ótimo, mas cada IA "esquece" tudo entre sessões e nenhuma
lê a mente da outra — então **este vault é o que garante que todas
trabalhem com o mesmo entendimento do projeto.**

## O problema que isso evita

Sem uma fonte única de verdade, o risco é: você pede uma coisa pro Cursor,
outra coisa parecida pro Hermes, cada IA "inventa" uma solução um pouco
diferente pro mesmo problema (nomes de função diferentes, abordagens
diferentes pra mesma feature) — e você só descobre a inconsistência na hora
de compilar ou no meio de um teste.

## Regra central

**Antes de pedir qualquer coisa não-trivial pra uma IA (qualquer uma),
dê a ela o mesmo contexto:**
1. Link ou cole o conteúdo de [[Arquitetura]]
2. Se a tarefa tocar `Shared/`: cole também [[Glossario-Tecnico]] e
 [[Protocolo-de-Rede]]
3. Se for uma feature maior: escreva a spec primeiro (`05-Specs/`) e cole a
 spec inteira

Isso vale tanto pro Cursor (que já carrega `.cursor/rules/` sozinho) quanto
pra qualquer outra IA que não tenha esse mecanismo automático — nesse caso,
**colar manualmente é o substituto das rules**.

## Divisão de papel sugerida entre ferramentas

| Ferramenta | Bom para |
|---|---|
| **Cursor** | edição direta de código no repositório (Windows), com contexto automático via `.cursor/rules/` e indexação do projeto; é onde o código é aplicado e compilado |
| **Hermes** | análise do código em profundidade, documentação, diário, backlog de ideias, estudos de C++ |
| **opencode** (Linux) | o mesmo papel do Hermes, mas na sua máquina Linux: análise, documentação, planejamento de specs e git. Carrega o contexto via `AGENTS.md` na raiz do vault |
| **Outras IAs de chat** | pesquisa, explicação de conceitos, "segunda opinião" sobre decisão de arquitetura |

Se uma IA de chat (fora do Cursor) gerar código, **tragam esse código pro
Cursor pra revisão** antes de aplicar — o Cursor tem o projeto inteiro
indexado e consegue apontar se algo já existe, se o nome conflita, etc.
Uma IA sem acesso ao repositório está sempre "adivinhando" a arquitetura.

## Sempre que uma IA sugerir mudar `Shared/`

Trate a sugestão como um rascunho, nunca como pronta. Verifique manualmente
(ou peça pro Cursor verificar, que tem o repo indexado) se:
- o valor de `smTRANSCODE_*` sugerido já não existe com outro propósito
- os dois lados (client e server) foram considerados na sugestão

## Mantendo o vault e as `.cursor/rules/` alinhados

Sempre que uma decisão de arquitetura mudar (nova convenção, novo módulo,
mudança de responsabilidade), atualize **os dois lugares**:
- a nota correspondente aqui no vault (fonte legível por humano)
- o arquivo `.mdc` correspondente em `.cursor/rules/` (fonte que a IA no
 Cursor lê automaticamente)

Se algum dia divergirem, o vault manda — as rules do Cursor devem ser
atualizadas para bater com o vault, não o contrário.