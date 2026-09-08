---
tags: [processos, cliente, quest, imgui, feature]
status: feito
data: 2026-09-06
modulo: cliente
---

# 2026-09-06 - Recap Desafios ImGui

Recap da redesign da aba de quests (tecla Q). Logica de aceitar/cancelar/
entregar no **servidor nao mudou**. So a tela do cliente e o jeito de
mostrar progresso. Protocolo: nenhum `smTRANSCODE_*` novo.

Changelog curto: `CHANGELOG.md` -> Unreleased -> Quest (cliente).

---

## Como era

- A janela de quests ja era ImGui, mas o visual se misturava com o tema
  global (`StyleColorArmageddon()`), as tres abas repetiam o mesmo painel
  e a lista nao agrupava status (entregar / andamento / disponivel /
  concluida).
- Confirmar cancelamento usava caixa legado (`cMessageBox`), fora do
  cromado da janela nova.
- A tecla **Q** abria sobretudo o overlay de progresso, nao a janela grande.
- Nao havia titulo em imagem (`DESAFIOS` / `EM ANDAMENTO`).
- Nao havia taskbar arrastavel na tela de jogo com clique no nome da quest.
- Clique na caixa de progresso furava o mapa: o personagem andava.
- Nomes de mapa na janela precisavam de UTF-8 (ImGui). Uma tentativa de
  colocar UTF-8 no array compartilhado `MapasWU8` quebrou o **minimapa**
  (`F. das Ilusoes` virava `IlusÃµes`) — o minimapa ainda desenha com
  `DrawTextA` (ANSI Windows-1252).

Houve um experimento visual (pergaminho, divisores PNG) que **nao ficou
bom e foi revertido**. Ficou o cromado escuro + dourado e so duas imagens
de titulo recortadas.

---

## O que o jogador ve agora

- **Q** abre/fecha a janela **Desafios** (720x500, centralizada, sem
  arrastar/redimensionar).
- Titulo e a imagem `game\images\quest\desafios.png`. Se o arquivo faltar,
  cai no texto `DESAFIOS`.
- Abas: Unicas / Diarias / Repetitivas. Lista a esquerda, detalhe a
  direita. Grupos: prontas para entregar, em andamento, disponiveis,
  concluidas. Na aba Repetitivas, fora da faixa `minLevel`/`maxLevel` o
  item fica apagado (nivel do personagem = `sinChar->Level`).
- Rodape: Aceitar / Cancelar / Visualizar progressao / Concluir. Cancelar
  abre um popup ImGui no mesmo cromado; o resto da tela escurece mais
  (`ModalWindowDimBg` ~0.80). VOLTAR e dourado; CONFIRMAR e vermelho.
- **Visualizar progressao** abre a taskbar (canto superior direito na
  primeira vez): arrastavel, minimizar/fechar em icones quadrados, cantos
  retos, linha dourada do cabecalho um pouco mais grossa. Titulo:
  `emandamento.png`.
- Clique no **nome** da quest na taskbar abre Desafios ja nessa missao
  (e na aba certa). Clique na taskbar **nao** move o personagem.
- Quest pronta para entregar na taskbar: nome e texto em verde, barra
  cheia verde com `20/20`. Sem check e sem `OK` (era redundante).

---

## O que implementei (e por que)

1. **Cromado isolado** (`PushStyleColor` / `Pop` so nesta janela).
   Por que: `StyleColorArmageddon()` pinta o tema **global** do ImGui e
   suja Shop/Ranking/HUD. Cada janela nova de jogador copia este cromado
   (regra `.cursor/rules/15-imgui-windows.mdc`).

2. **Uma lista parametrizada**, estado na classe `QuestWindow`.
   Por que: tres copias da mesma aba divergem na primeira correcao.

3. **Popup de cancelar em ImGui**, mesmo `DrawWindowChrome`.
   Por que: a caixa legado nao combina com a janela nova. O destaque e o
   fundo escuro, nao uma moldura extra (adornos extras ficaram estranhos
   e sairam).

4. **Taskbar (`questOverlay`)** + `FocusQuest` + `IsBlockingMouse`.
   Por que: acompanhar kill count sem abrir a janela inteira. O jogo
   antigo trata clique no chao como movimento; se o ImGui nao "segurar"
   o mouse, o personagem anda. `WantCaptureMouse` no `GameCore` /
   `WinMain` + retangulo da overlay resolvem isso.

5. **Imagens de titulo recortadas** (~380x63 e ~420x49, PNG 32-bit,
   fundo transparente).
   Por que: um PNG 1274x832 com muito fundo vazio, encaixado numa faixa
   de ~200x40, vira um selo minusculo. O codigo escala **a imagem
   inteira**; o desenho precisa ja vir recortado.

6. **`MapasWU8` de volta ao ANSI; ImGui usa `ToUtf8()`.**
   Por que: dois sistemas de texto no mesmo client. ImGui quer UTF-8.
   Minimapa quer o encoding antigo. Um array so nao serve os dois sem
   conversao na hora de desenhar.

---

## Arquivos tocados

Repo do jogo (`C:\Source Priston\Source Priston`):

- `SrcGame/src/Game/Quest/QuestWindow.cpp` — janela, overlay, popup, UTF-8
- `SrcGame/src/Game/Quest/QuestWindow.h` — estado, `FocusQuest`, `IsBlockingMouse`
- `SrcGame/src/Game/HUD/InstancesFlag.cpp` — chama `openWindow` / `questOverlay`
- `SrcGame/src/Game/sinbaram/sinMain.cpp` — tecla Q -> `openFlag`
- `SrcGame/src/Game/GameCore.cpp` — clique nao vaza pro mapa se ImGui
  capturou o mouse ou a overlay esta embaixo do cursor
- `SrcGame/src/Game/WinMain.cpp` — `WM_LBUTTONDOWN` respeita `WantCaptureMouse`
- `.cursor/rules/15-imgui-windows.mdc` — padrao visual pra copiar em
  outras janelas novas
- `.cursor/rules/10-client-game.mdc` — aponta o cromado de Desafios

**Nao mudou:** `Shared/`, `SrcServer/` (logica de quest), `dependencies/`.

Assets no cliente (nao vao no git do jogo):

- `C:\Cliente Full\game\images\quest\desafios.png`
- `C:\Cliente Full\game\images\quest\emandamento.png`

Simbolos que **nao podem ser removidos** de `QuestWindow.cpp` (outros
modulos linkam): `WChar_to_UTF82`, `MapasWU8`.

---

## Shared / protocolo

- Tocou em `Shared/`? nao
- `smTRANSCODE_*` novos ou alterados? nenhum

---

## O que testar

1. Tecla Q — abre/fecha Desafios; titulo em imagem.
2. Trocar Unicas / Diarias / Repetitivas — lista agrupa; repetitivas fora
   do nivel aparecem apagadas.
3. Aceitar um desafio — vai para Em andamento; Visualizar progressao abre
   a taskbar.
4. Arrastar a taskbar — personagem **nao** anda. Clicar no nome abre
   Desafios nessa quest.
5. Completar o objetivo — barra verde, `n/n`, texto Pronto para entregar;
   sem check e sem OK.
6. Cancelar — popup no cromado da janela, fundo mais escuro; VOLTAR nao
   cancela; CONFIRMAR cancela de verdade.
7. Minimapa em mapa com acento (ex.: Floresta das Ilusoes) — `Ilusoes`,
   nao `IlusÃµes`. Na janela Desafios o nome do mapa no objetivo tambem
   com acento certo.

Build: recompilar o **client** (Win32) e copiar `Game.exe` para
`C:\Cliente Full\`. Imagens ja ficam na pasta `game\images\quest\` do
cliente.

---

## O que ficou de fora / proximos passos

- Pergaminho / bordas ornamentais PNG — experimentado e revertido.
- Shop e Ranking ainda nao copiaram este cromado (a regra existe para
  quando for a vez deles). **Atualizacao 2026-09-08:** copiaram — ver
  [[2026-09-08 - Recap janelas ImGui de jogador]].
- Sem testes automatizados (regra do projeto).
- Servidor / tabelas `Quest` no SQL: fora deste bloco.

Ideias futuras (nao feitas): som ao concluir objetivo; persistir posicao
da taskbar; 9-slice se voltar a usar moldura PNG.

---

## Aprendizado

- **ImGui nao e o HUD de pedra.** Push/Pop de estilo e por janela, senao
  o tema vaza.
- **UTF-8 e ANSI no mesmo exe.** O que o ImGui mostra certo pode quebrar
  `DrawTextA`. Converta na borda (quem desenha), nao no array compartilhado.
- **Clique em overlay.** Se o jogo trata clique no mundo como andar,
  a UI precisa marcar `WantCaptureMouse` / um retangulo "isso e meu".
- **Tamanho de PNG de titulo.** Recorte o desenho. Canvas enorme com
  fundo vazio nao "fica nítido" — fica minusculo.

O que ainda pode confundir: `QUEST_BODY` vs `QUEST_INFO` (catalogo vs
progresso do personagem); `openFlag` (janela grande) vs `openOverlay`
(taskbar).
