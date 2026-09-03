---
tags: [equipe, onboarding]
---

# Onboarding — Lucas

Bem-vindo ao projeto. Este documento é pra você conseguir ficar produtivo
sem precisar perguntar tudo pra Carol toda hora — e pra ela lembrar o que
já te mostrou.

## 1. O que é este projeto

Um MMO cliente-servidor em C++ (baseado/inspirado em Priston Tale), com:
- **Cliente** (`SrcGame/`) — o jogo que roda na tela do jogador
- **Servidor** (`SrcServer/`) — a "verdade" do jogo, onde tudo é validado
- **Shared** (`Shared/`) — código que os dois lados usam, incluindo o
  protocolo de rede entre eles

Leia [[Arquitetura]] inteira antes de tocar em qualquer código. Não precisa
decorar, só ter uma ideia de onde cada coisa mora.

## 2. Ferramentas que você vai usar

- **Visual Studio 2022** — pra abrir e compilar (`Game.sln` e `server.sln`
  são soluções separadas)
- **Cursor** — editor com IA (baseado no VS Code) para editar código com
  ajuda de IA. É complementar ao Visual Studio, não substitui pra compilar/
  debugar no Windows.
- **Obsidian** — este vault. Onde documentamos decisões, aprendemos C++
  juntos e registramos o progresso.
- **Git** — controle de versão. Ver [[Workflow-Git]] antes do seu primeiro
  commit.

## 3. Primeiros passos práticos

1. Clone o repositório do jogo.
2. Abra este vault no Obsidian (pasta separada ou dentro do repo — combinem
   isso, ver [[Como-Usar-Este-Vault]] seção 5).
3. Consiga compilar o projeto localmente **antes** de mudar qualquer linha
   de código — isso valida que seu ambiente está certo.
4. Leia [[Trilha-de-Aprendizado]] e faça o primeiro exercício de
   [[Exercicios-Seguros]] — é uma tarefa pequena e sem risco, feita pra você
   se orientar no código real sem poder quebrar nada importante.
5. Crie seu registro de aprendizado: copie `TEMPLATE-Registro-de-Aprendizado`
   e renomeie para `Registro - Lucas.md`.

## 4. Como pedimos ajuda de IA aqui

Não é "chat livre pedindo qualquer coisa". Ver
[[Trabalhando-com-Multiplas-IAs]] pro fluxo completo, mas resumindo:
- Tarefa pequena → pede direto no Cursor.
- Tarefa que mexe em `Shared/` ou mais de um módulo → escreve uma spec
  primeiro (`05-Specs/TEMPLATE-Spec`), depois pede pra IA.
- A IA (qualquer uma) **nunca** deve editar `dependencies/`.

## 5. Divisão de trabalho — combinem isso já no início

Antes de codar junto, decidam e anotem em [[Combinados-da-Equipe]]:
- Quem cuida mais de quê (ex: Carol foca em servidor/segurança, Lucas em
  cliente/UI — ou dividam por feature, não por "camada", como preferirem)
- Como evitam os dois mexerem no mesmo arquivo ao mesmo tempo (branches!)
- Quando e como avisam um ao outro sobre mudança em `Shared/` — isso é o
  ponto mais fácil de gerar conflito/bug entre vocês dois

## 6. Onde tirar dúvida

- Dúvida de C++ em geral → [[Trilha-de-Aprendizado]] tem recursos
- Dúvida "onde fica X no código" → [[Arquitetura]] e [[Glossario-Tecnico]]
- Dúvida "por que fizemos assim" → pasta `06-Decisoes/`
- Dúvida "o que já foi feito recentemente" → [[CHANGELOG]] e
  `04-Diario-do-Projeto/`
