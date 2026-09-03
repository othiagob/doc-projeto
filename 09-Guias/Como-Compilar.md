---
tags: [guias, compilar, build]
---

# Como Compilar (cliente e servidor)

> Guia para iniciantes. Se algo aqui não funcionar ou estiver desatualizado,
> corrija o guia — ele é seu.

## O que você precisa

- **Visual Studio 2022** com o workload **Desenvolvimento para desktop com C++**
- O código em `C:\Source Priston\Source Priston` (pode estar em outro lugar,
 só ajuste os caminhos)

## Conceito rápido: o que é compilar

O código-fonte (arquivos `.cpp`/`.h`) é **texto** que você lê. O compilador
transforma esse texto em **instruções de máquina** (o `.exe` que roda).
"Compilar" = transformar. Se houver erro de sintaxe ou algo faltando, o
Visual Studio mostra erros — é normal no começo, todo erro tem mensagem e
a maioria é resolvida com uma busca no Google/Cursor.

## O projeto tem 2 soluções

| Solução | O que compila | Onde abre |
|---|---|---|
| `SrcGame\Game.sln` | **Cliente** (o jogo) | `SrcGame\` |
| `SrcServer\server.sln` | **Servidor** | `SrcServer\` |

> O `Shared/` não é uma solução própria — ele é **compartilhado** entre as
> duas soluções (um "projeto de itens" que as duas referenciam). Você não
> precisa compilar Shared separadamente.

## Passo a passo (cliente ou servidor — o fluxo é igual)

1. Abra o Visual Studio 2022.
2. **Arquivo -> Abrir -> Projeto/Solução** -> escolha `Game.sln` (cliente) ou
 `server.sln` (servidor).
3. No topo da janela, na barra de configurações, escolha:
  - **Release** (recomendado pra jogar — mais rápido) ou **Debug** (pra
 debugar com breakpoints — mais lento mas dá pra inspecionar variáveis)
  - **x86** / **Win32** (o projeto é 32-bit)
4. **Compilar -> Compilar Solução** (ou Ctrl+Shift+B).
5. O resultado aparece na janela "Saída". Terminou com sucesso quando não
 há erros (warnings/avisos são ok na maioria das vezes).
6. O executável é gerado **fora do repositório**: `C:\Source Priston\Game.exe`
 (cliente) e `C:\Source Priston\Server.exe` (servidor). A pasta `OutDir\`
 dentro do repo só guarda os arquivos intermediários (.obj) da compilação.

## Ordem recomendada

Compile o **servidor** primeiro e depois o **cliente** — ou compile só o
que você mudou. Cada solução compila sozinha (Shared é incluído
automaticamente).

## Erros comuns de iniciante

| Erro | Causa provável | Solução |
|---|---|---|
| "não foi possível abrir o arquivo .vcxproj" | abriu o arquivo errado | abra o `.sln`, não o `.vcxproj` |
| "falha ao abrir arquivo de inclusão: xxx.h" | caminho de include quebrado (pasta movida) | confirme que o projeto está no mesmo lugar de sempre |
| "LNK..." (erro de link) | biblioteca faltando ou config errada | não mexa em `dependencies/`; peça ajuda com o erro exato |
| build muito lento | normal em projeto grande | use Release, evite Debug quando não precisar |

## Regras importantes

- **Não crie novos `.vcxproj`/`.sln`** e não mude pastas de saída sem
 precisar — quebra o build de um jeito difícil de diagnosticar.
- Se mexer em `Shared/`, compile **as duas** soluções (cliente e servidor)
 antes de testar.
- O `.gitignore` já ignora `/OutDir` e `.vs` — binários não vão pro git.

## Se precisar de ajuda

Pergunte ao Cursor (com o repo aberto) ou ao Hermes: cole o erro exato da
janela "Saída". Os dois conseguem ler o projeto e apontar o arquivo certo.