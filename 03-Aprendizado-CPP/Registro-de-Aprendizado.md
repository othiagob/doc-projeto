---
tags: [aprendizado, cpp]
---

# Registro de Aprendizado — Thiago

> Log contínuo — vá adicionando entradas no topo (mais recente primeiro) ou
> no fim, o que for mais natural pra você. Não precisa ser bonito, precisa
> ser honesto sobre o que você entendeu e o que não entendeu.

## Formato sugerido por entrada

```markdown
### AAAA-MM-DD

**O que estudei/fiz:**


**O que ficou claro:**


**O que ainda não entendi:**


**Pergunta pra próxima sessão (pra mim ou pra IA):**

```

---

## Entradas

### 2026-08-31

**O que estudei/fiz:**
Análise completa do código-fonte (servidor, cliente, protocolo, banco) feita
pelo Hermes; reestruturação do vault de documentação para uso individual.

**O que ficou claro:**
A diferença entre `Shared/`, `SrcGame/` e `SrcServer/`, e por que mudanças
em `Shared/` são as mais arriscadas. Como o cliente conecta no servidor
(`game.ini` -> IP/porta) e como o servidor fala com o banco (SQL Server via
ODBC, config em `Server\Config\SQL.ini`).

**O que ainda não entendi:**
Como exatamente `sinbaram` e `smLib3d` se relacionam com a Delta3D — parece
haver duas camadas de engine, preciso investigar.

**Pergunta pra próxima sessão:**
Rastrear o fluxo completo de um pacote simples (ex: chat) do client até o
server, pra entender a mecânica de rede na prática.