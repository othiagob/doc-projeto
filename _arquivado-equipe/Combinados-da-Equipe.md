---
tags: [equipe]
---

# Combinados da Equipe

Preencham e atualizem juntos — isso não é pra IA decidir por vocês, é um
contrato entre vocês dois. O que está aqui embaixo é um ponto de partida
sugerido; editem à vontade.

## Divisão de responsabilidade (sugestão inicial — ajustem)

| Área | Responsável principal | Observação |
|---|---|---|
| Cliente / UI / gameplay visual | ? | |
| Servidor / segurança / banco | ? | |
| Shared / protocolo | **os dois sempre revisam junto** | nunca é "de um só" |
| Documentação do vault | os dois, cada um atualiza o que mexeu | |

"Responsável principal" não significa "só essa pessoa mexe" — significa
"essa pessoa é quem decide em caso de dúvida/conflito naquela área".

## Regras de branch e merge (complementa [[Workflow-Git]])

- Antes de começar uma tarefa, avisem um ao outro qual branch/pasta vão
  tocar (mensagem rápida basta) — evita dois mexendo no mesmo arquivo.
- Ninguém faz merge na `main` sem o outro saber que aquilo está indo pra lá,
  especialmente se tocar `Shared/`.
- Se rolar conflito de merge: parem, conversem, não resolvam no automático
  sem entender o que cada lado mudou — em C++ um conflito mal resolvido
  compila e quebra em runtime silenciosamente.

## Ritual de sincronização

Sugestão: uma conversa rápida (call ou texto) a cada sessão de trabalho —
"o que eu fiz", "o que vou fazer agora", "alguma coisa que quebrou pra
mim". Registrem o resumo no `04-Diario-do-Projeto/` do dia — isso vira
histórico útil daqui a meses.

## Como decidir quando os dois discordam

1. Escrevam os dois pontos de vista numa nota em `06-Decisoes/` (mesmo que
   informal).
2. Se for uma decisão técnica com trade-offs, testem os dois lados quando
   der (protótipo rápido) antes de decidir só na conversa.
3. Registrem a decisão final e o motivo — mesmo decisões erradas, quando
   documentadas, poupam vocês de repetir a mesma discussão em 3 meses.
