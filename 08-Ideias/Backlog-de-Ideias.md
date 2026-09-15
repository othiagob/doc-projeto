---
tags: [ideias, backlog]
---

# Backlog de Ideias — o que fazer a seguir

> Este é o lugar pra anotar **tudo** que você quer implementar, testar ou
> brincar no projeto — não precisa ser perfeito, só anotar. Quando for
> começar uma ideia, mova-a para uma spec (`05-Specs/`) e marque aqui como
> "em andamento".

## Status possíveis

| Status | Significado |
|---|---|
| ideia | só uma anotação, sem plano ainda |
| estudar | precisa investigar o código antes de planejar |
| spec | virou spec em `05-Specs/` |
| em andamento | sendo implementado agora |
| feito | implementado e testado (link pro diário/changelog) |
| descartada | decidiu não fazer (anote o porquê!) |

---

## Para aprender programação (primeiros passos sugeridos)

> Ordenadas da mais simples pra mais avançada. Todas reversíveis
> (`git checkout` desfaz). Veja também [[Exercicios-Seguros]].

### 1. Trocar a mensagem de boas-vindas do servidor
**Área:** servidor · **Dificuldade:** 1/5
Achar onde o servidor mostra mensagem ao logar (ex: anúncio, boas-vindas,
aviso) e mudar o texto. Ensina: como achar strings no código, recompilar,
testar.

### 2. Mudar o IP/porta de conexão pra teste local
**Área:** cliente · **Dificuldade:** 1/5
Revisar o `game.ini` (seção `[ConnectServer]`) — hoje aponta pra
`189.46.228.170:31620`. Trocar pra `127.0.0.1` e entender como o cliente
usa essa config (`smConfig.h`). Ensina: config de rede, ciclo build->teste.

### 3. Ajustar valores de skill via arquivos .ini do servidor
**Área:** servidor · **Dificuldade:** 2/5
O servidor lê `Server\Skills\*.ini` por classe (Mecanico.ini, Lutador.ini,
Pike.ini, Arqueira.ini, Cavaleiro.ini, Atalanta.ini, Sacerdotisa.ini) —
dano, cooldown etc. são dados configuráveis. Mudar um valor e testar no
jogo. Ensina: dados vs código, balanceamento, como o servidor carrega config.

### 4. Adicionar um comando de GM simples
**Área:** servidor (GM) · **Dificuldade:** 3/5
Duplicar um comando GM existente (ex: um que só envia mensagem) com nome e
efeito próprios. Ensina: como comandos funcionam, como o servidor trata
entrada de admin.

### 5. Mudar o limite de ouro ou ouro inicial
**Área:** shared · **Dificuldade:** 2/5
`Shared/GlobalsShared.h` define os limites (`MAX_GOLD_*`). Cuidado: é
`Shared/` — mexe nos dois lados. Ensina: a regra de ouro do projeto na
prática.

### 6. Ajustar a curva de XP
**Área:** shared · **Dificuldade:** 3/5
`Shared/LevelTable.h` é a tabela de XP por nível. Mudar valores altera a
velocidade de leveling. Ótimo pra entender balanceamento — mas afeta todo
mundo. Ensina: Shared, impacto global, testes manuais de balanceamento.

### 7. Adicionar um log de debug numa função pequena
**Área:** cliente ou servidor · **Dificuldade:** 1/5
Escolher uma função pequena e logar quando ela roda. Ensina: como logs
funcionam (`Shared/Utils/Debug.h`), como confirmar que o código rodou.

---

## UI visível ao jogador (2026-09-13)

Mapa e ordem sugerida: [[Roadmap-UI]] em `12-UI-e-Artes/`.
ADR: [[0005 - Distribuidor ImGui, armazem e inventario em pedra, artes no Cliente Full]].

### Botão organizar inventário
**Área:** cliente (`sinInvenTory`) · **Dificuldade:** 2/5 · **Status:** spec
HUD de pedra. Agrupa/compacta a bag; não mexe no equipamento.
Spec: [[2026-09-13-inventario-organizar]].

### Armazém: busca, páginas e janela ImGui
**Área:** cliente + servidor (save `.war`) · **Dificuldade:** 3/5 (páginas 4/5)
**Status:** feito (2026-09-15)
Janela ImGui (`WarehouseWindow`), 3×100 slots, busca local, mesmo
transcode. Spec: [[2026-09-13-armazem-paginas-busca]]. Recap:
[[2026-09-15 - Recap Armazem ImGui paginas e busca]]. Planta: [[Armazem]].
ADR: [[0006 - Armazem ImGui, paginas no mesmo transcode]].

### Distribuidor ImGui + correio 168h
**Área:** cliente + servidor + Shared · **Dificuldade:** 5/5 · **Status:** spec
Lista + detalhe estilo Desafios. Jogador envia item real para outro
personagem; destinatário tem 168h para aceitar.
Spec: [[2026-09-13-distribuidor-correio]].

### Char select Fallen Tale (TGA)
**Área:** arte no Cliente Full (`StartImage\login\`) · **Dificuldade:** arte
**Status:** estudar
C++ já aponta os arquivos. Brief:
`Source-Priston/docs/prompt-antigravity-charselect-ui.md`. Não é
redesign de login de conta (já PNG).

### Sincronizar PNG de login source vs Cliente Full
**Área:** operacional · **Status:** ideia
Mesmos nomes, tamanhos diferentes. O exe lê o cliente. Ver
[[Onde-vivem-as-imagens]].

---

## Melhorias de jogo (ideias futuras)

### Novo sistema de drop/recompensa de evento
**Área:** servidor (Eventos, AutoDropItem.h) · **Dificuldade:** 4/5
Criar um evento com drops exclusivos. Precisa entender o sistema de eventos
e de drops primeiro (estudar).

### Item exclusivo "feito por mim"
**Área:** servidor + cliente · **Dificuldade:** 5/5
Criar um item novo do zero (dados + sprite/ícone + uso). É o projeto grande
clássico. Precisa de spec antes ( quando for começar).

### Integração com Discord
**Área:** cliente + servidor · **Dificuldade:** 3/5
Já existe integração Discord (`Shared/Discord/`, `discord-rpc.lib`) no
cliente. Estudar o que faz hoje e o que dá pra adicionar (ex: webhook de
log do servidor).

### Melhorar o anti-cheat
**Área:** servidor (Security/) + cliente (AntiCheat.cpp) · **Dificuldade:** 4/5
Estudar o que existe e adicionar validação simples (ex: limite de dano por
skill — o próprio código-fonte comenta esse caso). primeiro.

---

## Ideias de documentação/processo

### Mapear as tabelas do banco de dados
**Área:** docs · **Dificuldade:** 2/5
Rodar o SQL Server, abrir no SSMS e documentar as tabelas principais de
cada banco em `02-Arquitetura/Banco-de-Dados.md`.

### Rastrear um pacote de ponta a ponta
**Área:** docs/aprendizado · **Dificuldade:** 3/5
Escolher um fluxo (ex: chat, ataque) e documentar o caminho completo do
pacote: cliente -> servidor -> banco -> resposta. Vira uma página de
referência incrível (e é o melhor exercício de aprendizado).

### Script de backup do banco
**Área:** processo · **Dificuldade:** 2/5
Criar um `.bat`/`.ps1` que faz backup dos `.mdf` antes de cada sessão de
teste. Ensina: automação, e evita perder progresso.

---

## Como usar este backlog

1. Adicione ideias aqui **a qualquer momento** (o Hermes pode anotar por você).
2. Toda sessão de trabalho: escolha 1 ideia pequena ou 1 exercício, faça, e
 registre no diário + CHANGELOG.
3. Ideias grandes viram **spec** (`05-Specs/TEMPLATE-Spec.md`) antes de
 implementar.