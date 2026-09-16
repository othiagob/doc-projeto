---
tags: [inicio, caminhos]
status: ativo
data: 2026-09-13
---

# Tres diretorios (Windows)

Este projeto **nao cabe numa pasta so**. Sao tres mundos. Toda nota, toda
arte e todo `.cpp` mora em um deles.

| Papel | Caminho | Repo git | Quem usa |
|---|---|---|---|
| **Cliente do jogo** | `C:\Cliente Full` | nao (pasta de runtime) | `game.exe`, F5 do Visual Studio |
| **Source code** | `C:\Source Priston\Source Priston` | `othiagob/Source-Priston` | Cursor + VS 2022 |
| **Documentacao** | `C:\Users\carol\Desktop\doc-projeto` | `othiagob/doc-projeto` | voce + IAs (este vault) |

A pasta pai do codigo e `C:\Source Priston`. O repositorio compilavel e
a subpasta `Source Priston`.

Caminho antigo do vault
(`C:\Users\carol\Desktop\OTHIAGOB PROJETO\source-priston\priston-documents`)
nao e mais a fonte viva.

No Linux (opencode) os caminhos sao outros — ver `AGENTS.md`.

## O que vai em cada um

**Cliente Full** — tudo que o jogador ve em disco: PNG, TGA, BMP, mapas,
sons, `game.ini`. Sem o arquivo aqui, a tela falha mesmo com o C++ certo.

**Source** — C++, `.cursor/rules/`, `Shared/smPacket.h`. Compilar **nao**
copia arte para o cliente. Pasta `game/images` na source e **espelho
opcional**, nao o runtime.

**Vault** — historia, regras, specs, roadmap. Nao compile daqui. Nao
jogue daqui.

## Artes

PNG/TGA novos nascem no **Antigravity (Gemini)** e caem no Cliente Full.
Detalhe: [[Como-gerar-artes]] e regra Cursor `05-directories-and-art.mdc`.

Livro: [[Livro-de-Evolucao]]. Capa: [[Home]].
