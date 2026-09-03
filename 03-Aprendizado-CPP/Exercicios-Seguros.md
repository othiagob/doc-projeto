---
tags: [aprendizado, cpp]
---

# Exercícios Seguros

Tarefas pequenas, de baixo risco, pra se orientar no código real sem poder
causar dano sério. "Seguro" aqui significa: fácil de reverter, não toca
`Shared/` nem `dependencies/`, e o efeito é visível/testável rapidinho.

Peça pra IA ajudar a **encontrar** onde fazer a mudança, mas tente
escrever a mudança em si você mesmo primeiro.

## 1. Adicionar um log de debug

Escolha uma função pequena em `SrcGame/src/Game/HUD/` ou similar, e
adicione uma linha de log (usando o que já existe em
`Shared/Utils/Debug.h`) quando ela for chamada. Compile, rode, confirme que
o log aparece. Reverta depois.

**O que isso ensina:** como o projeto compila, onde ficam logs, como uma
função pequena se conecta ao resto.

## 2. Mudar um texto de UI

Encontre uma string de interface (ex: título de janela, texto de botão) em
`WinInt/` ou `HUD/` e mude só o texto. Compile, veja a mudança no jogo.

**O que isso ensina:** onde ficam textos, ciclo compilar->testar, como achar
"onde no código isso aparece na tela" (grep pelo texto atual costuma
funcionar bem).

## 3. Ler (sem editar) o fluxo de uma skill

Escolha uma skill em `Shared/Skills/fighter.h` (ou outra classe). Peça pra
IA (Cursor, com o repo aberto) mostrar: onde essa skill é referenciada no
client, onde é validada no server, qual(is) `smTRANSCODE_*` está envolvido.
Não edite nada — só documente o que descobriu no seu
[[Registro-de-Aprendizado]].

## 4. Ajustar um valor numérico isolado (não em Shared)

Encontre uma constante que **não** esteja em `Shared/` (ex: um cooldown de
UI, uma distância de câmera em `Engine/`) e mude o valor. Compile, teste,
confirme visualmente o efeito. Reverta.

**Por que não em Shared:** valores em `Shared/LevelTable.h` ou
`Shared/Skills/*.h` afetam balanceamento real de jogo e exigem cuidado
extra (ver regra em [[Arquitetura]]) — bons pra fase 3 de aprendizado, não
pro primeiro exercício.

## 5. Adicionar um comando de GM simples (servidor)

Se já tiver confiança básica: olhe `SrcServer/src/Server/GM/` e tente
entender como um comando existente funciona, depois duplique um comando
simples com nome/efeito diferente (ex: um comando que só imprime uma
mensagem). Bom exercício pra entender `GM/` sem tocar em nada que
afete jogadores.

---

Depois de cada exercício: reverta a mudança (`git checkout` no arquivo) a
menos que valha a pena manter, e registre 2-3 linhas no seu registro de
aprendizado sobre o que ficou claro e o que ainda confunde.