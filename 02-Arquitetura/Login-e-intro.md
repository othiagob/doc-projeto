---
tags: [arquitetura, cliente, login]
status: ativo
data: 2026-09-19
---

# Login e intro

Como o cliente chega ate o formulario de conta.

## Uma frase

Antes do login PNG Fallen Tale, `IntroSplash` tenta video DirectShow;
se faltar, PNG; se faltar, texto. Clique ou tecla pula. Sem pacote
de rede.

```mermaid
flowchart LR
  boot[WinMain] --> intro[IntroSplash]
  intro -->|login.asf| vid[DirectShow]
  intro -->|intro.png| png[cover fade]
  intro -->|nada| txt[OTHIAGOB DEV]
  vid --> login[HoOpening]
  png --> login
  txt --> login
  login --> ds[DataServer]
```

```mermaid
sequenceDiagram
  participant W as WinMain
  participant I as IntroSplash
  participant H as HoOpening
  W->>I: Load BeginCinematic
  Note over I: Skip a qualquer momento
  I->>H: formulario window.png
  H->>H: smTRANSCODE_ID_GETUSERINFO
```

Arquivos: `SrcGame/.../Login/IntroSplash.*`,
`Engine/Directx/DXVideoRenderer.*`, `HoBaram/HoOpening.cpp`.
Brief: source `docs/prompt-antigravity-intro-ui.md`.
Runtime: `C:\Cliente Full`.

Char select continua TGA classico (`HoLogin`) — outra frente.
