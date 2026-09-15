---
tags: [ui, roadmap, ideias]
status: ativo
data: 2026-09-13
---

# Roadmap de UI

Lista viva. Status segue o backlog (`ideia` / `estudar` / `spec` /
`em andamento` / `feito`). Este arquivo nao substitui a spec — aponta
para ela.

Decisao de identidade: [[0005 - Distribuidor ImGui, armazem e inventario em pedra, artes no Cliente Full]].
Cromado ImGui: regra `15-imgui-windows.mdc` + layout de Desafios.

## Ordem sugerida (custo x risco)

Voce pode inverter. A ordem abaixo prioriza o que quebra menos o
protocolo primeiro.

1. **Organizar inventario** — menor. Client, HUD de pedra, provavelmente
   sem transcode novo. Spec: [[2026-09-13-inventario-organizar]].
2. **Armazem** — **feito** (2026-09-15). ImGui + 3 paginas + busca.
   Recap: [[2026-09-15 - Recap Armazem ImGui paginas e busca]]. Planta:
   [[Armazem]]. Spec: [[2026-09-13-armazem-paginas-busca]].
3. **Distribuidor ImGui + correio 168h** — maior. `Shared/`, anti-dupe,
   TTL. Spec: [[2026-09-13-distribuidor-correio]].

Paralelo (arte, nao C++): char select Fallen Tale — trocar TGA no
Cliente Full. Ver [[Inventario-de-Artes]].

## Quadro

| Item | UI | Shared / protocolo | Status |
|---|---|---|---|
| Titulos ImGui + cromado jogador | ImGui | nao | feito |
| Login de conta PNG | Engine/UI | nao | feito (sync source/cliente pendente) |
| Char select TGA Fallen Tale | StartImage | nao | estudar / arte |
| Botao organizar inventario | pedra | provavelmente nao | spec |
| Armazem busca por nome | ImGui | nao (filtro local) | feito |
| Armazem titulo PNG | ImGui 400x64 | nao | feito |
| Armazem mais paginas | ImGui | **sim** (3 pacotes / `.war` WH02) | feito |
| Distribuidor lista + detalhe | ImGui | **sim** (lista, nao um item por vez) | spec |
| Enviar item a outro personagem | ImGui | **sim** (transcode novo ou extensao) | spec |
| Pendencia 168h | servidor | **sim** (timestamp na struct / arquivo) | spec |

## O que cada frente e (em uma frase)

### Organizar inventario

Um botao no inventario classico que agrupa por tipo e fecha buracos.
Nao mexe nos 16 slots de equipamento. Nao e redesign da janela.

### Armazem

**Feito.** Janela ImGui (`WarehouseWindow`) no cromado 15; logica
`cWAREHOUSE`. 3 paginas x 100, busca por nome, titulo
`game/images/warehouse/armazem.png`. Mesmo transcode
`smTRANSCODE_WAREHOUSE` (`0x48470047`), `wVersion=2`, uma pagina por
pacote. Arquivo `.war` magica `WH02`. Inventario ao lado continua
pedra. ADR [[0006 - Armazem ImGui, paginas no mesmo transcode]].
Planta: [[Armazem]].

### Distribuidor (NPC correio)

Hoje: so **receber**, um item por vez (Yes/No), sem prazo.
`smTRANSCODE_ITEM_EXPRESS` (`0x48478A80`), `POST_ITEM_MAX` 500, arquivo
`Data\PostBox\<usercode>\<id>.dat`. Quest/loja/GM ja depositam; o
jogador **nao envia**.

Apos a spec: janela ImGui no estilo Desafios (lista + detalhe); enviar
item real do inventario para **outro personagem**; destinatario tem
**168 horas** para aceitar (proposta: expirado devolve ao remetente).
Autoridade no servidor (tira o item antes de gravar no PostBox).

Nao reutilizar `ITEM_EXPRESS` para outra coisa. Procurar em
`Shared/smPacket.h` antes de criar transcode. Socket 8192 — lista grande
vai em chunks (mesmo aprendizado da loja).

## Fora deste roadmap (de proposito)

- Migrar **inventario** para ImGui (o armazem ja migrou, ADR 0006)
- Party e outras janelas ImGui antigas (ainda fora do cromado 15)
- Redesign do cenario 3D da selecao (`game\maps\chrselect\`)
- Tema do `Server.exe` (continua `16-desktop-tools.mdc`)

## Como marcar progresso

1. Quando comecar a codar: status `em andamento` aqui e no
   [[Backlog-de-Ideias]].
2. Quando testar no jogo: spec `feita`, recap em `10-Processos/`, linha
   no `CHANGELOG.md`, atualizar a tabela deste arquivo para `feito`.
3. PNG novo: Cliente Full primeiro; source so se quiser versionar.
   Ver [[Onde-vivem-as-imagens]].

Hub: [[index]].
