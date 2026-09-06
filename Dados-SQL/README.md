---
tags: [sql, dados, referencia]
data: 2026-09-06
---

# Dados-SQL — Conteúdo do banco extraído em Markdown

> Estes arquivos são **exportações feitas de leitura** do banco SQL Server
> já em produção na VPS. Não são a fonte de verdade: se você alterar as
> tabelas no banco, atualize manualmente o `.md` correspondente aqui.
>
> Fontes ligadas à documentação:
> - Arquitetura do banco: `02-Arquitetura/Banco-de-Dados.md`
> - Guia de prática com esses dados: `03-Aprendizado-SQL/Exercicios-SQL-Guiados.md`

---

## Índice dos arquivos

| Arquivo | Tabela no banco | O que guarda |
|---|---|---|
| `ListaItens_Drop.md` | junção de várias tabelas | Resumo de ~1200 itens com `code` e nome, prontos para usar com `/drop` |
| `Weapons.md` | `Weapons` | Armas (todo o código `WA`/`WC`/`WH`/`WM`/`WP`/`WS1`/`WS2`/`WT`) |
| `Armor.md` | `Armor` | Armaduras (`DA*`) |
| `Robes.md` | `Robes` | Vestes/manto (`DR*`) |
| `Shields.md` | `Shields` | Escudos (`DS*`) |
| `Gloves.md` | `Gloves` | Luvas (`DG*`) |
| `Boots.md` | `Boots` | Botas (`DB*`) |
| `Bracelets.md` | `Bracelets` | Pulseiras/braçadeiras |
| `Rings.md` | `Rings` | Anéis |
| `Amuletos.md` | `Amuletos` | Amuletos |
| `Brincos.md` | `Brincos` | Brincos |
| `Potions.md` | `Potions` | Poções (vida/mana, `HPRecovery`/`MPRecovery`) |
| `Forces.md` | `Forces` | Itens de força/orbs |
| `Costumes.md` | `Costumes` | Cosméticos (skin sobre o personagem) |
| `Skins.md` | `Skins` | Skins de arma/equipamento |
| `Premiuns.md` | `PremiumData` | Pacotes premium/VIP |
| `Craft.md` | `Craft` | Materiais e regras de craft |
| `QuestItem.md` | `Quest` | Itens usados em missões |
| `DropItem.md` | `DropItem` | Quais itens saem em cada `DropID` + chance + ouro |
| `DropList.md` | `DropList` | Qual `DropID` cada monstro usa |
| `MonsterList.md` | `MonsterList` | Todos os monstros: nivel, boss, HP, dano... |
| `NpcList.md` | `NpcList` | NPCs: modelo, tamanho, mensagem associada |
| `NpcMessaOK.md` | `NpcMessage` | Falas dos NPCs por `MessageID` |
| `NpcSellList.md` | `NpcSellList` | O que cada NPC vende |
| `FieldIndicator.md` | `FieldIndicators` | Portais/indicadores de mapa |

---

## Colunas que aparecem em quase todo lugar

| Coluna | Significado |
|---|---|
| `Seq` | Ordem de exibição (raramente usada) |
| `ID` | Identificador numérico da linha |
| `Code` | Código curto do item — usado em comandos (`/drop`, `/item`) |
| `Name` | Nome exibido no jogo |
| `Active` | 1 = aparece/dropa normalmente; 0 = desativado |
| `ItemLevel` | Nível mínimo para equipar |
| `Weight` | Peso do item (inventário tem limite de peso) |
| `Price` | Preço base no NPC |
| `DurabilityMin/Max` | Durabilidade inicial (item novo sorteia entre os dois) |

Colunas específicas por categoria estão documentadas no próprio arquivo
(ex: `DefenseMin/DefenseMax` só em armaduras, `HPRecoveryMin/Max` só em poções).

---

## Onde usar

| Situação | Arquivo pra abrir |
|---|---|
| Quero o código de um item pra usar no `/drop` | `ListaItens_Drop.md` |
| Quero ver o que um NPC vende | `NpcSellList.md` + `NpcList.md` |
| Quero saber o que um monstro dropa | `DropList.md` (monstro -> `DropID`) -> `DropItem.md` (`DropID` -> itens) |
| Quero balancear defesa de armadura | `Armor.md` |
| Quero planejar tabela nova ou alteração no banco | `02-Arquitetura/Banco-de-Dados.md` + os detalhes da tabela aqui |
