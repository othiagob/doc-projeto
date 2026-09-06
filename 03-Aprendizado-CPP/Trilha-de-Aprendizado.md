---
tags: [aprendizado, cpp]
---

# Trilha de Aprendizado — C++ através deste projeto

Objetivo: aprender C++ de verdade **usando o próprio jogo como material de
estudo**, com ajuda de IA como tutor — não só como "gerador de código que eu
não entendo". Regra pessoal recomendada: **se a IA gerou um código que você
não consegue explicar em voz alta sozinho (como se estivesse ensinando
alguém), pare e peça pra IA explicar linha por linha antes de aceitar.**

## Fase 0 — Fundamentos mínimos (antes de tocar no projeto)

Não precisa dominar C++ inteiro, só o suficiente pra ler código sem se
perder:
- Sintaxe básica: variáveis, tipos, funções, `if`/`for`/`while`
- Ponteiros e referências (`*`, `&`) — essencial, esse projeto usa muito
- Classes, herança, `struct` vs `class`
- `#include`, headers (`.h`) vs implementação (`.cpp`), `#pragma once`
- O que é compilar/linkar (pra entender erros do Visual Studio)

Recursos: [learncpp.com](https://www.learncpp.com/) (gratuito, referência
muito usada) até o módulo de classes/herança já é suficiente pra começar a
ler o código deste projeto.

**Use a IA como tutor aqui**: peça pra ela explicar um conceito e depois te
dar um exercício pequeno e isolado (fora do projeto) pra praticar — não
precisa aprender C++ genérico só lendo, precisa escrever também.

## Fase 1 — Ler antes de escrever

Antes da primeira mudança real no jogo:
1. Abra `Shared/Utils/` e leia `Debug.h`, `strings.h`, `common.h` — são
 pequenos, usados em todo lugar, e ensinam o "estilo" do projeto.
2. Escolha um `.h` de `Shared/Skills/` (ex: `fighter.h`) e leia inteiro.
 Não precisa entender 100% — anote no seu registro de aprendizado o que
 não entendeu, e pergunte pra IA especificamente sobre aquilo.
3. Faça o **Nível 0** de [[Exercicios-Guiados]] — é o degrau mais baixo,
  feito pra quem está começando do absoluto zero com o código real do
  projeto. Depois siga pro nível 1 do mesmo arquivo e para os
  [[Exercicios-Seguros]] #1 e #2.

## Fase 2 — Rastrear um fluxo completo

Escolha **um** fluxo simples de jogo (ex: "jogador ataca com skill") e
rastreie do início ao fim:
- Onde no client a ação é iniciada (input do jogador)
- Qual `smTRANSCODE_*` é enviado (ver [[Glossario-Tecnico]])
- Onde no server esse pacote é recebido e validado
- O que o server manda de volta

Isso ensina mais sobre a arquitetura real do que ler documentação — e é
exatamente o tipo de tarefa que uma IA com o repo indexado (Cursor) ajuda
bem, pedindo "me mostra o caminho completo desse pacote, client e server,
sem editar nada, só listar os arquivos e funções envolvidas".

## Fase 3 — Primeira mudança real

Só depois das fases acima: escolha algo pequeno em [[Exercicios-Seguros]]
com risco baixo, escreva a mudança você mesmo primeiro (mesmo que errada),
**depois** peça pra IA revisar/corrigir — não peça pra IA escrever do zero.
Você aprende no ato de tentar, não em copiar a resposta pronta.

## Ritmo sugerido

Não tente aprender C++ inteiro antes de começar a mexer no jogo — você
vai aprender mais rápido misturando teoria pequena + prática guiada no
código real. Documente no [[Registro-de-Aprendizado]] o que aprendeu a cada
sessão, mesmo que seja uma linha.

## Recursos de apoio

- [learncpp.com](https://www.learncpp.com/) — referência geral de C++
- [cppreference.com](https://en.cppreference.com/) — referência técnica
 (biblioteca padrão, sintaxe) — bom pra consultar, não pra aprender do zero
- Documentação da **Delta3D** em `dependencies/Delta3D/Include/` — os
 próprios headers têm comentários explicando parâmetros