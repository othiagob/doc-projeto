---
tags: [analise, assassin, shaman, classes, assets, cpp]
---

# 02 - Diagnóstico: Classes Assassin e Shaman

Relatório técnico completo sobre o estado das classes **Assassin** e **Shaman** nos arquivos e no código-fonte.

---

## 1. O Veredito Inicial

- **Nos Arquivos do Cliente (`D:\Cliente e Server Arquivos\client` e `C:\Cliente Full`):** As duas classes estão **100% presentes**. Todos os modelos 3D, texturas, arquivos de esqueleto/animação, ícones de habilidades (Tiers 1 a 5), vozes, efeitos sonoros e scripts de partículas já existem no disco!
- **Na Source Code (`D:\Source Cliente e Server` e `C:\Source Priston`):** Ambas as classes estão **100% ausentes no C++**. Nenhuma das duas bases de código tem os códigos de classe definidos, os manipuladores de pacotes ou as fórmulas de dano/efeito das habilidades.

---

## 2. Inventário Completo de Assets Encontrados

### 2.1. Assassin (Tempskron Feminino - Código D)

| Tipo de Asset | Localização no Cliente | Descrição dos Arquivos |
|---|---|---|
| **Modelos 3D de Corpo** | `char\tmABCD\` | `CtfbD01.smd` a `CtfbD29.smd` (todos os sets de armadura) |
| **Modelos 3D de Cabeça** | `char\tmABCD\` | `Tfh-D01.smd` a `Tfh-D04.smd` (evoluções de classe 1 a 4) |
| **Tabelas de Animação** | `char\tmABCD\` | `tfh-D01.inx`, `tfh-D02.inx`, `tfh-D03.inx`, `tfh-D04.inx` (combat, run, walk, rest) |
| **Títulos de Classe** | `image\Sinimage\skill\Assassin\JobTitle\` | `1.dds` a `5.dds` (Ranks 1 a 5) |
| **Efeitos Sonoros (SFX)** | `wav\Effects\Player\Assassin\` | Vozes, gemidos de dano, passos e ataques |
| **Partículas de Habilidades** | `Effect\Particle\Script\` | `Alas.part`, `Wisp1.part`, `Wisp2.part`, `PastingShadowAttack.part`, `PastingShadowBegin.part`, `PollutedAttack.part`, `PollutedBegin.part`, `ShadowBomb.part`, `ViolenceStab1..3.part`, `Storm.part` |

#### Habilidades da Assassin Mapeadas no Cliente (20 skills = 5 Tiers):
- **Tier 1:** `TA14 D_Mastery` (Dagger Mastery), `TA17 Wisp`, `TA20 V_Throne` (Violent Throne), `TA23 Alas`
- **Tier 2:** `TA26 S_Shock` (Soul Shock), `TA30 A_Mastery` (Alas Mastery), `TA40 S_Sword` (Shadow Sword), `TA43 B_Up` (Bleed Up)
- **Tier 3:** `TA46 Inpes` (Inpes), `TA50 Blind`, `TA60 F_Wind` (Frost Wind), `TA63 F_Mastery` (Frost Mastery)
- **Tier 4:** `TA66 Polluted`, `TA70 P_Shadow` (Pasting Shadow), `TS80 J_Bomb` (Shadow Bomb), `TS83 R_Slash` (Running Slash)
- **Tier 5:** `TS86 V_Stab` (Violence Stab), `TS90 Storm`

---

### 2.2. Shaman (Morayion Masculino - Código D)

| Tipo de Asset | Localização no Cliente | Descrição dos Arquivos |
|---|---|---|
| **Modelos 3D de Corpo** | `char\tmABCD\` | `CmmbD01.smd` a `CmmbD29.smd` (todos os robes/armaduras) |
| **Modelos 3D de Cabeça** | `char\tmABCD\` | `Mmh-D01.smd` a `Mmh-D04.smd` (evoluções de classe 1 a 4) |
| **Tabelas de Animação** | `char\tmABCD\` | `Mmh-D01.inx`, `Mmh-D02.inx`, `Mmh-D03.inx`, `Mmh-D04.inx` |
| **Títulos de Classe** | `image\Sinimage\skill\Shaman\JobTitle\` | `1.dds` a `5.dds` (Ranks 1 a 5) |
| **Efeitos Sonoros (SFX)** | `wav\Effects\Player\Shaman\` | Vozes, conjuração de magias, dano e passos |
| **Partículas de Habilidades** | `Effect\Particle\Script\` | `DarkBolt.part`, `DarkBoltHit.part`, `DarkWave1..2.part`, `CurseLazy1..2.part`, `MigalStart..End.part`, `MidrandaStart..End.part`, `CreedStart..Keep.part`, `LandOfGhost1..2.part`, `Haunt1..2.part`, `Scratch1..2.part`, `JudgementStart..Hit.part`, `PressOfDeity1..2.part`, `GhostyNail1..2.part` |

#### Habilidades do Shaman Mapeadas no Cliente (20 skills = 5 Tiers):
- **Tier 1:** `MS10 Darkbolt`, `MS12 Darkwave`, `MS14 Curselazy`, `MS17 I_peace` (Inner Peace)
- **Tier 2:** `MS20 S_Flare` (Soul Flare), `MS23 S_Manacle` (Spiritual Manacle), `MS26 C_Hunt` (Chasing Hunt), `MS30 A_Migal` (Advent Migal)
- **Tier 3:** `MS40 R_Maker` (Rain Maker), `MS43 L_Ghost` (Land of Ghost), `MS46 Haunt`, `MS50 Scratch`
- **Tier 4:** `MS60 R_Knight` (Recall Knight), `MS63 Judge` (Judgement), `MS66 A_Midranda` (Advent Midranda), `MS70 M_pray` (Mourning Pray)
- **Tier 5:** `MS80 Creed`, `MS83 P_Deity` (Press of Deity), `MS86 G_Nail` (Ghostly Nail), `MS90 H_Regene` (High Regeneration)

---

## 3. O que Falta no Código C++ para Ativar as Duas Classes

Para que um jogador consiga criar, evoluir e jogar com Assassin e Shaman, os seguintes pontos precisam ser implementados no C++ do **Fallen**:

### 3.1. Identificadores de Classe (`smPacket.h` - Shared)
Atualmente o enum de classes termina na classe 8:
```cpp
#define JOBCODE_MECHANICIAN  2
#define JOBCODE_FIGHTER      1
#define JOBCODE_PIKEMAN      4
#define JOBCODE_ARCHER       3
#define JOBCODE_KNIGHT       6
#define JOBCODE_ATALANTA     5
#define JOBCODE_PRIESTESS    8
#define JOBCODE_MAGICIAN     7

// NECESSÁRIO ADICIONAR:
#define JOBCODE_ASSASSIN     9
#define JOBCODE_SHAMAN       10
```

### 3.2. Mapeamento de Tribo e Seleção de Personagem (`cSelect`)
- No Priston Tale clássico, a tela de criação tem 2 tribos com 4 personagens cada:
  - **Tempskron:** Fighter, Mech, Archer, Pike ➔ Deve receber o 5º botão: **Assassin**.
  - **Morayion:** Knight, Atalanta, Mage, Priestess ➔ Deve receber o 5º botão: **Shaman**.
- A lógica de renderização 3D na tela de seleção precisa carregar `tfh-D01.inx` para Assassin e `Mmh-D01.inx` para Shaman.

### 3.3. Tabela de Modelos 3D (`playmodel.h` / `character.cpp`)
- Configurar as matrizes de corpos e cabeças para as classes 9 e 10 apontando para os prefixos de arquivos `CtfbD` (corpo) / `Tfh-D` (cabeça) e `CmmbD` (corpo) / `Mmh-D` (cabeça).

### 3.4. Tabela de Atributos Base e Evolução
- Definir em `sinSkill_Info.cpp` ou tabela de jobs os atributos iniciais:
  - **Assassin:** Alta Agilidade, Médio Talento/Força, Baixa Inteligência.
  - **Shaman:** Alta Inteligência, Média Agilidade/Talento, Baixa Força.
- Fórmulas de ganho de HP, Mana, Estamina e Poder de Ataque a cada Level Up.

### 3.5. Grupos de Habilidades (`sinSkill.h`)
```cpp
#define GROUP_ASSASSIN   0x0A000000
#define GROUP_SHAMAN     0x0B000000
```
- E as definições hexadecimais para as 20 habilidades de cada classe.
- Criação dos loops de cálculo de dano e efeito em `Damage.cpp` (cliente) e `Svr_Damge.cpp` (servidor).