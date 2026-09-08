---
tags: [evolucao, cliente, servidor, imgui, loja, banco]
status: feita
data: 2026-09-08
---

# 2026-09-08 - HUD ImGui, lojas, ranking, mix e painel do servidor

Sessao especial de evolucao. Cobre o bloco que comeca na janela **Desafios**
(2026-09-06) e fecha neste commit do codigo (2026-09-08): cromado unico de
jogador, Loja de Coins / Loja de Tempo, Ranking, Mix, Configuracoes, captura
de mouse, SQL da loja, PainelDB, encoding, e o painel ImGui do `Server.exe`.

Leia isto **antes** de redesenhar qualquer janela ou de "simplificar" bancos.

Recaps por tela: [[2026-09-06 - Recap Desafios ImGui]],
[[2026-09-08 - Recap janelas ImGui de jogador]],
[[2026-09-08 - Recap loja SQL e painel Server]].

ADRs: [[0002 - Duas identidades visuais jogador vs ferramenta]],
[[0003 - Catalogo SQL vs icone BMP no client]],
[[0004 - Encoding ImGui UTF-8 vs HUD legado Windows-1252]].

Repositorio de codigo: `https://github.com/othiagob/Source-Priston` (branch
`main`). Vault: `https://github.com/othiagob/doc-projeto`.

---

## Resumo em 30 segundos

Padronizamos as janelas **novas** do jogador em ImGui (fundo escuro, bezel
dourado fino, titulo em PNG recortado). A logica de jogo quase nao mudou:
o servidor continua autoridade. A loja passou a respeitar o schema real
(`DiscountPercent`, `ItemCode` = codigo do item, icone = BMP no client).
O `Server.exe` ganhou um painel claro com acento azul — **nao** o cromado
do jogo. Aprendemos na pratica que tema global do ImGui, UTF-8 no lugar
errado, PNG enorme de titulo, 9-slice e "sumir" com o `PainelDB` quebram
o produto de formas silenciosas.

`Shared/` **nao** ganhou transcode novo. Pacotes ja existentes da loja
passaram a ir em **chunks** porque o socket tem 8192 bytes.

---

## Linha do tempo (evolucao ate aqui)

### 2026-08-31 — Base de trabalho

Setup do repo, analise do codigo, vault como caderno. ADR [[0001 - Uso de Cursor Rules e estrutura de docs]].
Regras de ouro: nao editar `dependencies/`, `Shared/` e contrato dos dois
lados, nao inventar `smTRANSCODE_*`, escopo pequeno, teste manual.

### 2026-09-03 — Vault didatico

Home, trilhas, fluxo de trabalho. Git do vault `othiagob/doc-projeto`.

### 2026-09-06 — Primeira janela de jogador "de verdade"

Desafios (tecla Q). Cromado proprio, lista agrupada, popup de cancelar,
taskbar de progresso, `WantCaptureMouse`. Experimento de pergaminho/bordas
PNG **revertido**. UTF-8 em `MapasWU8` **revertido** (minimap). Nasce a
regra `15-imgui-windows.mdc` e a pasta `10-Processos/`. Diario:
[[2026-09-06 - Janela de Desafios ImGui]].

### 2026-09-06 a 2026-09-08 — Este bloco

Copiar o padrao para Loja de Coins, Loja de Tempo, Ranking, Mix,
Configuracoes. Extrair `ImGuiWindowChrome.h`. Corrigir catálogo SQL da
loja e pacote em chunks. Painel do servidor (ImGui + DX9) com tema de
ferramenta. Regras `16-desktop-tools.mdc` e `40-database.mdc`. PNG de
titulo no repo do jogo em `game/images/...` (alem da copia no cliente
full).

---

## O que o jogador ve agora

- **Desafios (Q):** janela grande padronizada; overlay de progresso
  arrastavel; clique na overlay nao anda o personagem.
- **Loja de Coins / Loja de Tempo:** mesmo cromado; titulo
  `loja-de-coins.png` / `loja-de-tempo.png`; lista + detalhe; icone BMP
  do item; se o arquivo nao existe, `NO IMAGE` e o clique nao compra.
- **Ranking e Mix:** mesmo cromado; titulos `ranking.png` e
  `lista-de-mix.png`.
- **Configuracoes:** referencia do cromado polido (abas, X, bezel);
  titulo `configuracoes.png`.
- HUD classico (inventario, HP, pedra BMP) **igual ao legado**.

O operador do servidor ve o `Server.exe` com janela Windows redimensionavel,
sidebar (Status, Jogadores, Eventos, Arquivos, Log, Acoes), tema claro,
acento azul. Fechar pelo X **minimiza**. Desligar/sair pede confirmacao.
Se o DirectX nao sobe, o servidor ainda roda no console.

---

## O que implementei (por area)

### Cliente (`SrcGame`)

Cromado compartilhado em `SrcGame/src/Game/HUD/ImGuiWindowChrome.h`:
fundo `IM_COL32(10,12,16,248)`, bezel de duas camadas no `ImDrawList`,
`WindowRounding` nativo **0** (no DirectX o rounding grande do ImGui nao
aparece bem), rounding desenhado ~3.5. Sem PNG 9-slice, sem losango, sem
barra grossa.

Janelas que chamam `DrawPlayerWindowChrome`:

- `Quest/QuestWindow.cpp`
- `Settings.cpp`
- `Shop/NewShop.cpp` e `Shop/NewShopTime.cpp`
- `HUD/RankingWindow.cpp`
- `HUD/MixWindow.cpp`

Estilo **so na janela**: `PushStyleColor` / `PushStyleVar` com Pop na mesma
contagem. Proibido `StyleColorArmageddon()` nessas telas.

Titulos em PNG recortado (texto dourado, fundo transparente), copiados
tambem para o git em `game/images/...`. O exe le a partir do working
directory do cliente (`C:\Cliente Full` no F5 — `game.vcxproj.user`).

Mouse: `IsBlockingMouse` nas janelas + `WantCaptureMouse` em `GameCore.cpp`
e `Winmain.cpp` para o clique nao vazar para o chao (personagem andava).

Loja: structs de pacote alinhadas com o servidor (`pCompressedData[7800]`,
`chunkIndex`, `totalChunks`). Stats de ataque so em arma — escudo/armadura
nao mostram ATK/velocidade.

### Servidor (`SrcServer`)

- `Shop/NewShop.cpp`: SELECT com `DiscountPercent`; lista grande enviada em
  chunks (~200 itens) no pacote `NewShopItems_ReceiveItems` (`0x252031`).
  `CreateItemPerf` continua achando o item pelo `ItemCode`.
- `Database/SQLConnection.cpp`: log com **nome do banco** que falhou;
  checagem de `SQLDriverConnect`; `EnsurePainelDatabase` cria `PainelDB` +
  `dbo.Banneds` via `master` se o banco nao existe.
- `Quest/Quest.cpp`: acentos de `Alert()` em Windows-1252 (`\xNN`), com
  quebra de string quando o proximo char e hex.
- Painel: `HUD/ServerPanel.cpp`, `ServerConfigPages.cpp`, `ToolTheme.h`.
  ImGui do client e **compilado no server.vcxproj** (mesmos `imgui*.cpp`).
  Extra: DirectX falhou = so console. X = minimizar.
- `AdminChrome.h` existe como leftover da tentativa de ouro no servidor —
  identidade adotada e `ToolTheme.h`.

### Shared / protocolo

- Tocou em `Shared/`? **nao** (nenhum struct novo em `smPacket.h`).
- Codigos **ja existentes**, nao inventados:

| Codigo | Uso |
|---|---|
| `0x252030` `NewShopItems_OPENNPC` | abrir loja de coins |
| `0x252031` `NewShopItems_ReceiveItems` | lista (agora em chunks) |
| `0x252032` `NewShopItems_FinishPurchase` | compra |
| `0x252040` / `0x252041` / `0x252042` | nick / classe (loja) |
| `0x51800010` `OPEN_RANKING_NPC` | ranking |
| `0x51800012` `OPEN_MIXLIST_NPC` | lista de mix |

Socket `smSOCKBUFF_SIZE` = 8192. Por isso a lista da loja **nao cabe** num
pacote so; chunks sao obrigatorios, nao "otimizacao".

### Banco

Obrigatórios no boot (SQL Server ignora maiusculas): `UserDB`, `ServerDB`,
`ClanDB`, `SoDDB`, `LogDB`, `EventosDB`, `ShopCoin`, `Quest`, `GameServer`,
`ITEMLogDB`, `PainelDB`. `UserDB_VIP` e a **mesma** `UserDB`.

Script manual: `09-Guias/sql/Create-PainelDB.sql`.

### Regras Cursor (repo do jogo)

- `00-project-overview.mdc` — janela de jogador = regra 15; Server.exe = 16.
- `10-client-game.mdc` — cliente full, icones BMP, encoding, loja.
- `20-server.mdc` — DiscountPercent, chunks, ItemCode.
- `15-imgui-windows.mdc` — contrato visual do jogador.
- `16-desktop-tools.mdc` — contrato visual do Server.exe.
- `40-database.mdc` — bancos obrigatorios, PainelDB, colunas da loja.

---

## Acertos (manter)

1. **Cromado por janela, nunca tema global.** Push/Pop isolado.
2. **Uma funcao de bezel** (`DrawPlayerWindowChrome`) em vez de copiar
   quatro retangulos em cada `.cpp`.
3. **Layout lista + detalhe** copiado de Desafios; cromado fino copiado de
   Configuracoes quando o usuario pediu o visual mais polido.
4. **PNG de titulo recortado.** O codigo escala a imagem inteira. Canvas
   1274x832 com fundo vazio vira selo ilegivel.
5. **Clique e do ImGui** (`WantCaptureMouse` + retangulo da janela).
6. **Catalogo no SQL, icone no disco.** Nao misturar.
7. **Chunks no pacote da loja** alinhados client/server (`NewShop.h` dos
   dois lados identicos nos campos do compress).
8. **Nome do banco no erro de conexao.** Antes era um log generico e o
   `exit(0)` nao dizia qual database faltava.
9. **Painel do servidor degradavel.** Jogo (mundo) nao depende do D3D.
10. **Duas identidades visuais** escritas em regra, nao so no codigo.
11. **Nao migrar `sinbaram/`** ate pedido. Escopo pequeno.

---

## Falhas e experimentos revertidos (nao repetir)

| Tentativa | O que quebrou | O que ficou |
|---|---|---|
| `StyleColorArmageddon()` nas janelas novas | Tema global suja Shop/Ranking/HUD | Push/Pop so na janela |
| Pergaminho + divisores PNG (Desafios) | Visual pesado, assets errados | Cromado desenhado no `ImDrawList` |
| Moldura 9-slice (`frame-corner`, `frame-edge-*`, `frame-pip`) | Nao adotado; arquivos locais nao entram no padrao | Bezel de duas camadas em codigo. **Nao commitar** esses PNG como "UI oficial" |
| PNG de titulo enorme com fundo vazio | Texto some na faixa de ~50 px | Recorte ~400x64, transparente |
| UTF-8 em `MapasWU8` | Minimapa `IlusÃµes` (`DrawTextA`) | Array ANSI; ImGui usa `ToUtf8()` |
| Editar `imGui/` ou `STRCLASS` para acento | Risco em tudo que usa o helper | Converter na borda da janela |
| `Alert()` UTF-8 no servidor | Chat legado mostra lixo | `\xNN` Windows-1252; `"\xED" "do"` no MSVC |
| Coluna SQL `Discount` | Query falha / desconto sempre 0 | `DiscountPercent`; campo C++ ainda `Discount` |
| Trocar `ItemCode` porque faltava BMP | Item errado na entrega | Placeholder + copiar BMP generico |
| `ItemCode` como path de imagem | Catalogo e icone viram a mesma coisa | Codigo `OR129`; path `itOR129.bmp` |
| Inventar catálogo `GameServer` no C++ | Banco vazio continua vazio | Restore `.bak` |
| Remover `PainelDB` da lista de conexao | Server nao sobe; bans GM sem tabela | `EnsurePainelDatabase` + regra 40 |
| Cromado de ouro no `Server.exe` (`AdminChrome`) | Ferramenta parece HUD de jogo | `ToolTheme` claro + azul |
| `WindowRounding` nativo grande no DX | Cantos nao aparecem como no mockup | Rounding so no `AddRect` (~3.5) |
| Child com `ChildBorder` + moldura da janela | Dois quadros, visual sujo | Uma moldura; split de coluna fino |
| Pacote unico da loja > 8192 | Lista nao chega / socket estoura | chunks `chunkIndex` / `totalChunks` |
| Vermelho no nome inteiro da lista | Parece erro, nao status | Vermelho = destrutivo ou fora da regra (nivel) |

Se a proxima sessao "melhorar a borda" com PNG, reler esta tabela primeiro.

---

## Decisoes importantes para o futuro

1. **Janela de jogador nova = ler `15-imgui-windows.mdc` inteiro.** Nao
   desenhar um visual so desta tela.
2. **Server.exe = `16-desktop-tools.mdc`.** Nunca levar ouro/PNG de titulo
   de jogador para la.
3. **HUD de pedra fica.** Inventario/HP/sinbaram so mudam com pedido
   explicito.
4. **Nao inventar `smTRANSCODE_*`.** Procurar em `Shared/smPacket.h`.
5. **Schema = SSMS + vault.** Sem migracao automatica.
6. **Working directory do client = `C:\Cliente Full`.** Imagens nao sao
   lidas da pasta da source, a menos que voce copie `game/` para la.
7. **Atualizar a regra 15 so quando o usuario adotar um detalhe ja polido.**
   O cromado "oficial" hoje e o bezel fino (Settings), nao um experimento
   da semana.
8. Vault humano manda se divergir das rules — mas as rules precisam ser
   atualizadas na mesma sessao (ADR 0001). Caminho atual do vault neste
   PC: `C:\Users\carol\Desktop\doc-projeto` (repo `othiagob/doc-projeto`).
   Houve um caminho antigo
   `C:\Users\carol\Desktop\OTHIAGOB PROJETO\source-priston\priston-documents`
   citado nas rules; tratar `doc-projeto` como fonte viva daqui pra frente.

---

## Arquivos tocados (codigo)

Repo `C:\Source Priston\Source Priston`:

- `.cursor/rules/00-project-overview.mdc`, `10-client-game.mdc`,
  `20-server.mdc`, `15-imgui-windows.mdc`, `16-desktop-tools.mdc`,
  `40-database.mdc`
- `SrcGame/.../HUD/ImGuiWindowChrome.h` (novo)
- Quest, Settings, NewShop, NewShopTime, RankingWindow, MixWindow,
  InstancesFlag, GameCore, Winmain, LoginScreen, IniFiles, sinbaram
  (inventario/item/main/sub — captura de mouse / integracao, nao redesign
  de pedra)
- `SrcServer/.../SQLConnection.cpp`, `Shop/NewShop.*`, `Quest/Quest.cpp`,
  `GM/ServerCommand.cpp`, `OnSever.cpp`, `Winmain.cpp`, `server.vcxproj`
- `SrcServer/.../HUD/*` (novo painel)
- Assets versionados: `game/images/quest/desafios.png`,
  `shop/loja-de-coins.png`, `shop/loja-de-tempo.png`,
  `ranking/ranking.png`, `mix/lista-de-mix.png`,
  `settings/configuracoes.png`

Copiar os PNG tambem para `C:\Cliente Full\game\images\...` se o F5 nao
enxergar o `game/` da source.

Nao versionar: `SrcServer/.vs/`, `*.vcxproj.user` extra do server,
credenciais `SQL.ini`, PNG de 9-slice em `game/images/ui/` (experimento).

---

## O que testar (manual — nao ha teste automatizado)

### Cliente (build Win32, `Game.exe` no cliente full)

1. Q — Desafios abre/fecha; overlay nao anda o personagem; minimapa com
   acento (Ilusoes, nao `IlusÃµes`).
2. Loja de Coins — lista chega completa (muitos itens = varios chunks);
   desconto bate com o SQL; comprar item com BMP ok; item sem BMP nao
   clica e mostra aviso.
3. Loja de Tempo — mesmo cromado; titulo certo.
4. Ranking e Mix — NPC abre janela padronizada; clique nao anda.
5. Configuracoes — abas, X, salvar; titulo PNG.
6. Inventario/HP — iguais ao legado (regressao).

### Servidor

1. Subida: console lista cada banco; se `PainelDB` faltava, aparece
   "Verificando banco PainelDB" e sobe.
2. Falha proposital de um banco: log **com o nome**.
3. Painel: Status, lista de players, eventos EXP/DROP, log capturado do
   cout, desligar com confirmacao, X minimiza.
4. Sem D3D (maquina sem device): mundo ainda no console.
5. Compra na loja: item entregue e o `ItemCode` do SQL, nao o nome do BMP.
6. Ban GM: linha em `PainelDB.dbo.Banneds`.
7. Quest `Alert` com acento no chat do client.

Pacotes para observar (loja): `0x252030`, `0x252031` (varios), `0x252032`.

---

## O que ficou de fora / proximo bloco

- Migrar Party e outras telas ImGui ainda no tema antigo.
- Migrar HUD de pedra (`sinbaram/`) — **nao** sem pedido.
- Migracao UTF-8 global do client.
- Testes automatizados.
- Mapeamento completo de tabelas por banco (ainda em
  `02-Arquitetura/Banco-de-Dados.md`).
- `AdminChrome.h`: apagar ou deixar como referencia do que nao fazer.
- Persistencia da posicao da taskbar de quests.
- Som ao concluir objetivo.

---

## Aprendizado (C++ e produto)

- **ImGui nao e magica de layout.** Voce desenha: DrawList, Push/Pop,
  clip, rounding no device errado some.
- **Tamanho de struct e contrato de rede.** Se client e server discordam
  de `pCompressedData[N]` ou esquecem `chunkIndex`, a loja "abre vazia"
  sem crash obvio.
- **SQL e o save do mundo.** Codigo nao reconstitui `.bak`.
- **Encoding e borda.** Converta onde desenha, nao no array compartilhado.
- **Escopo.** O bloco cresceu (loja + SQL + painel). Da proxima vez,
  preferir commits menores por tela — o historico do git fica mais facil
  de reverter. Este commit e grande porque o usuario pediu subir tudo
  junto depois de varias sessoes.

O que ainda pode confundir: `Discount` (C++) vs `DiscountPercent` (SQL);
`openFlag` vs overlay de quest; `ItemCode` vs `itCODIGO.bmp`; dois
`NewShop.h` (client e server) que precisam continuar iguais nos pacotes.
