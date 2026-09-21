---
tags: [analise, arquitetura, melhorias, rmlui, logger, x64, slikenet]
---

# 04 - Tesouros Arquiteturais do Ex-Machina para o Fallen

Embora a source Ex-Machina não contenha o conteúdo de jogabilidade de Assassin/Shaman/T5, ela contém **avanços de engenharia de software de altíssimo nível** que podem transformar a estabilidade e o futuro do projeto **Fallen**.

Abaixo estão os 5 maiores tesouros técnicos que podemos portar ou adaptar.

---

## 1. Logger Multithread Assíncrono (`Logger.cpp` e `AsyncWorker.cpp`)

### O Problema no Priston Clássico
No código tradicional, toda vez que o servidor grava um log (drop, login, transação, comando GM) ou o cliente reporta um erro, é feito um `fopen()`, `fprintf()` e `fclose()` direto na thread principal. Quando há muitos jogadores ou eventos simultâneos, isso gera micro-travamentos (stutters) no cliente e gargalos de I/O no servidor.

### A Solução do Ex-Machina
- Implementou uma fila assíncrona com `std::thread` e `std::condition_variable` (`AsyncWorker.cpp`).
- A gravação de logs é instantânea na memória (Lock-free/Mutex rápido) e uma thread de fundo descarrega os dados no disco de forma contínua.
- **Ganho para o Fallen:** Zero impacto de desempenho em disco, eliminando gargalos no servidor e no cliente.

---

## 2. Eliminação Completa de `__asm` (Caminho para x64)

### O Problema no Priston Clássico
O uso de blocos como `__asm { mov eax, ... }` no cálculo de seno/cosseno (`smsin.cpp`), matrizes e criptografia impede que o projeto seja compilado como aplicativo nativo de **64 bits (x64)**. Em 32 bits, o servidor fica limitado a no máximo 2 GB (ou 3 GB com `/LARGEADDRESSAWARE`) de memória RAM.

### A Solução do Ex-Machina
- Todas as rotinas em assembly foram substituídas por código C++ moderno e funções intrínsecas da CPU.
- A solução compila nativamente em **x64**.
- **Ganho para o Fallen:** No futuro, poderemos compilar o Servidor do Fallen em x64 nativo, acabando com quaisquer riscos de estouro de memória por mapas e monstros carregados.

---

## 3. Interface de Usuário com RmlUi (HTML/CSS Nativo)

### O Problema no Priston Clássico
Criar uma janela bonita no Priston Tale tradicional exige:
- Cortar dezenas de pedaços de BMP/TGA.
- Fazer dezenas de chamadas manuais a `DrawSprite` ou `sinDrawTexImage`.
- Calcular coordenadas absolutas de botões pixel por pixel (`x, y, w, h`).
- Manutenção extremamente dolorosa e difícil de responsividade.

### A Solução do Ex-Machina
- Integrou a biblioteca **RmlUi** (sucessora do libRocket).
- A engine compila e renderiza arquivos `.rml` (HTML) estilizados com `.rcss` (CSS) diretamente na tela usando aceleração de hardware GPU (`RenderInterface.cpp`).
- Permite criar janelas modernas com CSS flexbox, bordas arredondadas, sombras, fontes TrueType (`.ttf`) e animações.
- **Ganho para o Fallen:** Criar janelas ricas (ex: Painel de Eventos, Passe de Batalha, Loja de Itens, Painel de Ranking, Guias para Novos Jogadores) usando código web padrão em vez de código C++ manual.

---

## 4. Rede Moderna com SlikeNet e RPC (`RemoteProcedureCall.hpp`)

### O Problema no Priston Clássico
- O sistema de rede clássico usa estruturas de bytes estáticas (`smPACKET`) enviadas por socket bruto.
- Se o cliente enviar um pacote com tamanho ou campos desalinhados por 1 byte sequer, o servidor lê memória corrompida ou sofre crash.

### A Solução do Ex-Machina
- Camada de rede baseada em **SlikeNet** (RakNet atualizada).
- Implementação de `MessageStream` derivada de `SLNet::BitStream`:
  ```cpp
  template<typename T>
  T ReadValue() {
      T Value;
      Read<T>(Value);
      return Value;
  }
  ```
- **Remote Procedure Call (RPC):** Possibilidade de registrar funções do servidor e invocá-las diretamente a partir do cliente com parâmetros tipados usando tuplas do C++ moderno.
- **Ganho para o Fallen:** Segurança avançada contra manipulação de pacotes, compressão automática de dados de rede e maior estabilidade em conexões instáveis.

---

## 5. Padrão de Subsistemas (`Shared::Subsystem`)

### O Problema no Priston Clássico
O Priston Tale tem mais de 2.000 variáveis globais compartilhadas (ex: `lpCurPlayer`, `smStage`, `cInvenTory`, `cSkill`, `StageField`). Se uma função altera uma dessas variáveis por engano, todo o restante do sistema se comporta de forma imprevisível.

### A Solução do Ex-Machina
- Criação de uma classe base `Shared::Subsystem` com registro centralizado e resolução de dependências em tempo de execução:
  ```cpp
  auto& logger = Shared::GetSubsystem<Shared::Logger>();
  auto& graphics = Shared::GetSubsystem<Graphics::GraphicsDevice>();
  ```
- Ciclos de vida definidos (`Initialize()`, `Shutdown()`).
- **Ganho para o Fallen:** Facilidade em plugar e desplugar novos módulos sem criar variáveis globais espalhadas por múltiplos arquivos `.h`.