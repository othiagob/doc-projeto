---
tags: [moc, analise, ex-machina, source]
---

# 13 - Análise Completa: Source & Arquivos Ex-Machina

Mapa central da auditoria e leitura técnica realizada nos diretórios:
- **Arquivos do Cliente e Servidor:** `D:\Cliente e Server Arquivos` (7.97 GB)
- **Código-Fonte (Source Code):** `D:\Source Cliente e Server` (priston-ex-machina)

---

## 🎯 Resumo Executivo da Leitura

1. **A Source (`D:\Source Cliente e Server`):**
   - **Projeto:** `priston-ex-machina` desenvolvido por Igor Segalla (`igorsegallafa`), último commit `f85d712` (Setembro de 2021).
   - **Objetivo central:** Modernização profunda da engine clássica do Priston Tale para **C++17/20**, compilação limpa em **x64 (64-bit)** sem nenhum assembly inline (`__asm = 0`), renderizador nativo em **DirectX 11 / DirectXTK**, rede UDP moderna com **SlikeNet / RPC**, e interface gráfica HTML/CSS usando **RmlUi**.
   - **Realidade sobre Assassin, Shaman e Tier 5 no C++:** **NÃO estão implementados no código C++ desta source.** O código possui apenas as 8 classes originais (`JOBCODE_1` a `JOBCODE_8`) e limite de Tier 4 (`SKILL_POINT_COLUM_MAX = 16`, `CHANGE_JOB1` a `CHANGE_JOB4`).

2. **O Cliente e Servidor (`D:\Cliente e Server Arquivos`):**
   - **Cliente:** Contém **100% dos assets** de Assassin, Shaman e Tier 5 de todas as classes!
     - Modelos 3D completos de corpo e cabeça (`CtfbD` para Assassin e `CmmbD` para Shaman).
     - Tabelas de animações de combate, corrida e descanso (`tfh-D01..04.inx` e `Mmh-D01..04.inx`).
     - Ícones de skills de todas as 5 tiers (TA14..TS90 e MS10..MS90).
     - Efeitos de partículas (`.part`) de todas as habilidades de T5 e das classes novas.
     - Efeitos visuais modernos em scripts Lua (`Skill5_Fighter_BloodyBerserker.lua`, etc.).
     - Efeitos sonoros completos em `.wav` (`wav\Effects\Player\Assassin` e `Shaman`).
   - **Servidor:** Base RZPT clássica (flat-file DataServer em `userdata`, `userinfo`, `warehouse`).

3. **Diagnóstico Crucial para o Projeto Fallen:**
   - O nosso cliente ativo (`C:\Cliente Full`) **já possui os mesmos assets** presentes nessa base!
   - O motivo de Assassin, Shaman e Tier 5 não estarem ativos no Fallen **não é falta de arquivos visuais/sonoros**, mas sim a **ausência da lógica no código-fonte C++** (packet structs, jobcodes, criação de personagem, tabela de skills no client/server e fórmulas de dano).
   - A source Ex-Machina nos dá a arquitetura moderna de ponta (especialmente RmlUi, x64 sem `__asm`, Logger assíncrono e SlikeNet) que podemos herdar para acelerar a evolução técnica do Fallen.

---

## 📚 Índice de Documentos da Pasta

| Documento | Descrição |
|---|---|
| [[01-Raio-X-da-Source-ExMachina]] | Análise detalhada do código-fonte, branches, arquitetura x64, DX11 e rede |
| [[02-Diagnostico-Assassin-e-Shaman]] | Mapeamento completo de assets 3D, áudio, partículas e o que falta no C++ |
| [[03-Diagnostico-Tier-5]] | Levantamento das 4 skills T5 de cada classe, scripts Lua/.part e expansão da engine |
| [[04-Tesouros-Arquiteturais-para-o-Fallen]] | As melhores inovações do Ex-Machina prontas para serem trazidas ao Fallen |
| [[05-Roteiro-de-Integracao-Fallen]] | Passo a passo prático e seguro para implementar Assassin, Shaman e T5 no Fallen |

---

## 🧭 Diagrama de Relação entre os Ambientes

```mermaid
flowchart TD
    subgraph D_DRIVE["Disco D: (Pacote Baixado)"]
        D_SRC["D:\Source Cliente e Server\n(priston-ex-machina / Igor Segalla)\n- C++17/x64 / DX11 / RmlUi\n- 8 Classes / Tier 4"]
        D_CLIENT["D:\Cliente e Server Arquivos\client\n- Quase 8 GB de Assets\n- Assets Assassin & Shaman (100%)\n- Assets Tier 5 (100%)\n- Assets Martial Artist"]
        D_SVR["D:\Cliente e Server Arquivos\server\n- Base RZPT / Flat-file DataServer"]
    end

    subgraph FALLEN_ACTIVE["Projeto Ativo (Fallen)"]
        F_SRC["C:\Source Priston\Source Priston\n- C++ / Win32 / DX9\n- ImGui HUD / Armazém SQL / GM Security\n- 8 Classes / Tier 4"]
        F_CLIENT["C:\Cliente Full\n- Cliente do Jogo\n- Já contém os assets de Assa, Sha e T5!"]
    end

    D_SRC -.->|Herança Arquitetural\n(Logger, RmlUi, Zero __asm)| F_SRC
    D_CLIENT -.->|Validação de Assets| F_CLIENT
    F_SRC ==>|Implementação C++ Requerida\n(Jobcodes 9/10, SKILL_MAX 20)| F_CLIENT
```