---
tags: [analise, tier5, skills, engine, packet]
---

# 03 - Diagnóstico: Sistema de Tier 5 (5º Avanço de Classe)

Relatório técnico completo sobre o estado da **Tier 5** nos arquivos e no código-fonte.

---

## 1. O Veredito Inicial

- **Nos Arquivos do Cliente (`D:\Cliente e Server Arquivos\client` e `C:\Cliente Full`):** A Tier 5 está **pronta e completa em termos visuais e sonoros** para todas as classes existentes (e inclusive para a classe extra Martial Artist).
- **Na Source Code (`D:\Source Cliente e Server` e `C:\Source Priston`):** O sistema de Tier 5 **não está implementado no C++**. O código-fonte de ambas as bases está estruturado estritamente para suportar até 4 Tiers (16 habilidades por personagem).

---

## 2. Inventário de Assets da Tier 5 Encontrados no Cliente

### 2.1. Ícones e Títulos
- **Títulos de 5º Rank:** Em `image\Sinimage\skill\<Classe>\JobTitle\5.dds` presente para:
  - Fighter, Mechanician, Archer, Pikeman, Knight, Atalanta, Priestess, Magician, Assassin, Shaman e Martial Artist.
- **Gráficos da Janela de Habilidades:**
  - `Gage-5.dds` (a barra de progresso da 5ª aba de skills).
  - `Skil25.dds` (a moldura e botões da 5ª aba).

### 2.2. Habilidades de Tier 5 Mapeadas por Classe

| Classe | Habilidades de Tier 5 Encontradas | Scripts de Partícula (`.part`) / Lua (`.lua`) |
|---|---|---|
| **Fighter** | Destructive Hit, Power Dash, Mortal Blow, Bloody Berserker | `Skill5_Fighter_BloodyBerserker.lua`, `Skill5_Fighter_DownHit.part`, `PowerDash.smd` |
| **Mechanician** | Hyper Sonic, Land Mining, Power Enhance, Rolling Smash | `Skill5_Mecanician_HyperSonic.lua`, `Skill5_Mecanician_HyperSonic1..2.part`, `Skill5_HyperSonic.smd` |
| **Archer** | Circle Trap, Thunder Loop Shot, Evade Shot | `Skill5ArcherCircleTrap1.part`, `Skill5ArcherThubderRoopShot1..2.part`, `Skill5_Acher_EvadeShot2..4.part` |
| **Pikeman** | Amplified, Final Spear | `Skill5PikemanAmplified.part`, `Skill5_PikeMan_FinalSpear1..4.part` |
| **Knight** | Crescent Moon, Holy Benediction, Saint Blade | `Skill5_Knight_CrescentMoon1..2.part`, `Skill5KnightHolyBenedic.part`, `Skill5_Knight_SaintBlade1..2.part` |
| **Atalanta** | Galaxy Coup, Snippy Fear Shot, Summon Arcuda, Talaria | `Skill5AtalantaGalaxyCoup.part`, `Skill5AtalantaSnippyFearShot.part`, `Skill5_Atalanta_Talaria_Start..Keep..End.part` |
| **Magician** | Prima Ignis, Meteo Ext | `Skill5MagicianPrimaIgnisShot.part` |
| **Priestess** | Piercing Ice, Ramiel | `Skill5PriestessPiercingIce1..2.part`, `Skill5PriestessRamielStart..End.part` |
| **Assassin** | Violence Stab, Storm | `ViolenceStab1..3.part`, `Storm.part` |
| **Shaman** | Creed, Press of Deity, Ghostly Nail, High Regeneration | `CreedStart..Keep.part`, `PressOfDeity1..2.part`, `GhostyNail1..2.part` |
| **Martial Artist** | Hard Training, Hunting Hawk, Line Breaking | `Skill5_MartialArtist_HardTrainingKeep.part`, `Skill5_MartialArtist_HuntingHawkHit1..3.part` |

---

## 3. Alterações Críticas Necessárias no Código C++ para Suportar a Tier 5

A transição de um servidor Tier 4 para Tier 5 mexe com a espinha dorsal de rede e persistência do jogo:

### 3.1. Expansão do Vetor de Habilidades do Personagem (`smPacket.h`)
Atualmente, o Priston Tale aloca exatamente 16 slots de habilidade por personagem (4 skills x 4 tiers):
```cpp
// ATUAL (Tier 4):
#define SKILL_POINT_COLUM_MAX   16

// NECESSÁRIO PARA TIER 5 (4 skills x 5 tiers):
#define SKILL_POINT_COLUM_MAX   20
```
> [!WARNING]
> Alterar `SKILL_POINT_COLUM_MAX` de 16 para 20 altera o tamanho das structs de dados do jogador (`smCHAR_INFO`, `TRANS_RECORD_DATA`, buffers de save). Cliente e Servidor **precisam obrigatoriamente ser compilados juntos com o mesmo valor**.

### 3.2. Constante de Mudança de Classe (`sinSkill.h`)
```cpp
#define CHANGE_JOB1             0x00010000
#define CHANGE_JOB2             0x00020000
#define CHANGE_JOB3             0x00040000
#define CHANGE_JOB4             0x00080000

// NECESSÁRIO ADICIONAR:
#define CHANGE_JOB5             0x00100000
```

### 3.3. Interface de Habilidades (`sinSkill.cpp`)
- A função `cSKILL::DrawSkill()` hoje controla 4 abas (1 a 4).
- Precisa ser ajustada para:
  1. Adicionar o 5º botão de seleção de aba.
  2. Carregar a textura `Gage-5.dds` quando a 5ª classe for atingida.
  3. Renderizar os 4 novos botões correspondentes à Tier 5 na grade de habilidades.
  4. Exibir os pontos de habilidade de T5 e aplicar requisitos de nível (geralmente Level 100+ ou 102+).

### 3.4. Quest do 5º Avanço de Classe (Servidor e NPCs)
- No servidor (`GameServer\NPC`), criar ou atualizar a lógica do NPC Mestre de Habilidades (`Teacher01..03.npc` ou `Force-master.npc`) para conduzir a Quest da Tier 5.
- Atualizar a validação de rank no servidor para permitir que `JobCode` atinja o Rank 5.

### 3.5. Persistência no Banco de Dados / Arquivos de Save
- No banco SQL do Fallen ou no formato de gravação de personagem:
  - Garantir que o campo de habilidades (`Skills` / `SkillData`) comporte os 20 bytes ou colunas correspondentes aos níveis das novas habilidades.