---
tags: [aprendizado, cpp, exercicios]
data: 2026-09-06
---

# Exercícios Guiados — C++ com o código REAL do jogo

> Diferente do [[Exercicios-Seguros]] (que é "o que fazer"), este documento é
> "como pensar" — cada exercício tem o código real na frente, uma
> **introdução explicando o conceito** e depois as perguntas. A dificuldade
> cresce em etapas:
>
> - **Nível 0 — Básico Introdutório** (comece aqui, sem pressa)
> - **Nível 1 — Intermediário Aprofundado** (quando o 0 estiver confortável)
> - **Níveis 2 a 5 — Avançados** (em construção; abra só quando sentir
>   segurança — quem apressa essa parte derruba o jogo)
>
> Regra de estudo: pra cada exercício, escreva no
> [[Registro-de-Aprendizado]] as respostas **antes** de perguntar pra IA.
> Errou? Ótimo — é exatamente aí que se fixa.

Os caminhos abaixo são do repositório do jogo (cópia de leitura no vault:
`Arquivos do Jogo/01 - Source Priston/Source Priston/`).

---

## Nível 0 — Básico Introdutório (comece por aqui)

Objetivo destes exercícios: você ler código **e entender o que as palavras
significam**, sem editar nada. Nenhum deles exige saber programar — exigem
saber *ler* com paciência.

### E0.1 — Uma constante de ouro (arquivo real, 19 linhas)

**Contexto.** Todo código precisa de números fixos que nunca mudam durante
o jogo: limite de ouro, tempo de um item premium. Em C++, esses valores
"congelados" recebem um NOME e ficam num header (um arquivo `.h`), pra que
qualquer parte do programa use o MESMO número — se um dia muda, muda em
um lugar só. Isso é uma **constante**. A linguagem faz isso com a palavra
`#define`, que diz ao compilador: "onde eu ler este nome, substitua pelo
valor". No arquivo `Shared/GlobalsShared.h` — chamado assim porque é
compartilhado entre o cliente e o servidor — esse limite de ouro aparece
assim (trecho real):

```cpp
#define MAX_GOLD_LOW_LEVEL 2000000
#define MAX_GOLD_TIER2     10000000
#define MAX_GOLD_TIER3     500000000
```

Perceba o nome: `MAX` (máximo) `_GOLD` (ouro) `_TIER2` (faixa 2). Nomes em
C++ são escritos em "camelos com underscore" e são *documentação que o
compilador entende*. O número tem 9 dígitos sem separador — em C++, números
grandes aparecem "sujos" mesmo (um espaço entre dígitos, ex. `10000000`,
não é permitido).

Perguntas:
1. Sem olhar tabela nenhuma: qual desses três é o limite de ouro de quem
   está na "faixa 3"?
2. Por que os nomes usam caixa alta (`MAX_GOLD_...`) e não `MaxGold...`?
   *(dica: olhe se há outra constante com caixa mista no mesmo arquivo)*
3. Se um jogador tem 600.000.000 de ouro e tenta ganhar mais, o que deveria
   acontecer segundo o código? *(dica: na sessão de Nível 1 você vai
   descobrir que a resposta está em `ServerCommand.cpp` — valendo!)*

### E0.2 — Uma função que toma uma decisão (arquivo real, 5 linhas)

**Contexto.** O coração de qualquer programa é fazer perguntas de sim/não
e agir conforme a resposta — isso é o `if` ("se"). Em funções (blocos de
código com nome, que recebem valores entre parênteses e entregam um
resultado com `return`), o `if` aparece a todo momento. A função abaixo é
**real**, do arquivo `Shared/Utils/strings.cpp`:

```cpp
int low(int a, int b)
{
	if (a < b)
		return a;

	return b;
}
```

Traduzindo pra português: "`low` recebe dois números, `a` e `b`. SE `a`
for menor que `b`, devolva `a`. Senão, chegue ao final e devolva `b`."
É isso: uma função de 5 linhas que devolve o MENOR dos dois números
(é o que em outros lugares se chama de `min`).

Perguntas:
1. O que `low(10, 3)` devolve? E `low(3, 10)`? E `low(7, 7)`?
2. Logo abaixo, existe uma gêmea `high(int a, int b)` — escreva você,
   no papel, como ela deve ser (só o corpo entre `{ }`).
3. No jogo, quando você "quer saber se o jogador tem ouro OU não para
   comprar", qual das duas se encaixaria? *(dica: compare os dois valores
   e veja o que sobra)*

### E0.3 — Formatar número bonito (arquivo real)

**Contexto.** No banco, o ouro do jogador é um número "cru": `500000000`.
Pro jogador ver na tela, é melhor aparecer formatado (`500.000.000`). A
linguagem não faz isso de graça — alguém escreveu uma função pra isso, e
ela é real: em `Shared/Utils/strings.cpp` existe

```cpp
const char* FormatNumber(__int64 iNumber)
{
	static char szValue[128] = { 0 };
	ZeroMemory(szValue, sizeof(szValue));

	FormatNumber(iNumber, szValue, _countof(szValue));

	return szValue;
}
```

Lições dessa função sem terror:
- `__int64` significa "número inteiro grande" (64 bits — cabe ouro de o milhão
  a bilhões com folga).
- `char szValue[128]` é um "pote" de 128 posições de texto onde a resposta
  vai ser montada letra por letra.
- `static` na frente faz o pote ser ÚNICO na memória, sempre o mesmo —
  conveniente e também perigoso (se duas pessoas formatarem ao mesmo tempo...
  isso é um bug de raça em código de jogo; guarde a dúvida).
- A última linha devolve esse texto pra quem chamou a função.

Perguntas:
1. Alguém chama `FormatNumber(500000000)`. O que espera receber de volta?
   *(dica: ele provavelmente insere separadores — confira na implementação
   da versão de cima, com 4 argumentos, também real no mesmo arquivo)*
2. O "pote" tem 128 posições. Se faltasse memória e fosse 12, o
   `500.000.000` caberia? *(dica: conto os caracteres)*
3. Por que a função devolve `const char*` e não deve deixar quem recebe
   mexer no texto? *(a resposta "porque mexer quebraria os próximos que
   lerem" já é suficiente — é o conceito de `const` na prática)*

### E0.4 — Um item "prime" tem prazo (o mesmo arquivo)

**Contexto.** O projeto gosta de calcular tempo em SEGUNDOS ao invés de
escrever "1 hora". Em `Shared/GlobalsShared.h` (real):

```cpp
#define PRIME_ITEM_TIME_1H  (60*60*1)
#define PRIME_ITEM_TIME_3H  (60*60*3)
#define PRIME_ITEM_TIME_7D  (60*60*24*7)
```

A conta `60*60*1` = uma hora em segundos (60 segundos, 60 vezes). Escrever
`(60*60*1)` em vez de `3600` parece burro, e é proposital: o programador
ESCREVEU a sua intenção ("60 seg × 60 seg × 1 hora") pra não ter que se
lembrar depois. Os parênteses garantem que a máquina não soma errado com
algo do lado.

Perguntas:
1. Quanto vale cada uma das três constantes de cima (faça a conta)?
2. `PRIME_ITEM_TIME_7D` significa 7 dias. Quantos segundos tem uma
   semana *em segundos*? Escreva a expressão do jeito do projeto.
3. Se você quisesse um "prime" de 2 horas, escreveria
   `(60*60*2)` ou `PRIME_ITEM_TIME_1H * 2`? Qual dos dois é mais
   "legível para o próximo que ler"? *(não tem resposta certa — é uma
   conversa sobre estilo)*

### E0.5 — Dois arquivos, um papel cada (com estrutura real)

**Contexto.** Em C++, cada "não-executável" `X` vive em DUPLA de arquivos:
o `.h` (header) declara O QUE existe ("existe uma função chamada `low`
que recebe dois int e devolve um int"), e o `.cpp` (código fonte
implementado) diz COMO ela faz. Isso separa o "o que tem" do "como faz",
e deixa outros arquivos usarem a função lendo só o `.h`. Compare os dois
dados reais do projeto:

`Shared/Utils/strings.h` (declaração — o que existe):

```cpp
int low(int a, int b);
int high(int a, int b);
```

`Shared/Utils/strings.cpp` (como faz — já mostrado no E0.2).

Perguntas:
1. No `.h` termina com `;` enquanto no `.cpp` abre `{ }`. Por quê
   *(resposta amigável: no header você só CONTA que a função existe; no
   cpp ela existe de verdade)*
2. Um outro arquivo do jogo escreve `low(x, y)` e inclui `strings.h`. Isso
   compila mesmo sem o compilador ter lido o `strings.cpp`? *Sim* — mas
  qual camada liga as duas pontas? *(dica: pesquise "linker")*
3. Este projeto usa esse padrão o tempo todo. Escolha um arquivo
   qualquer em `Shared/Skills/` (ex: `fighter.h`) e veja se ele segue
   o mesmo padrão (não precisa entender o conteúdo — só confirmar é
   suficiente por enquanto).

---

## Nível 1 — Intermediário Aprofundado (sequência natural do nível 0)

### E1.1 — As macros de log (`Shared/Utils/Debug.h`, 39 linhas)

Código real (resumo fiel do arquivo):

```cpp
#define __FILENAME__ (strrchr(__FILE__, '\\') ? strrchr(__FILE__, '\\') + 1 : __FILE__)

#define WRITEERR( msg, ... ) Debug::GetInstance()->WriteLine( __FILENAME__, __LINE__, msg, ##__VA_ARGS__ )
#define WRITEDBG( msg, ... ) { Debug::GetInstance()->WriteLine( __FILENAME__, __LINE__, msg, ##__VA_ARGS__ ); }
```

Perguntas (responda por escrito):
1. O que `__FILENAME__` faz que `__FILE__` sozinho não faz? Por que
   `strrchr` com `'\\'` e não `'/'`? *(dica: em que SO o projeto compila?)*
2. `WRITEERR` sempre funciona. `WRITEDBG` só existe em uma configuração de
   build — qual, e como o arquivo decide isso? *(dica: procure `#ifdef` no
   arquivo)*
3. Por que existe um `Debug::GetInstance()` que devolve `static Debug d;`
   em vez de criar `new Debug` toda vez?

**O que isso ensina:** macros vs funções, `#ifdef` de build, padrão
singleton — os três aparecem no projeto inteiro.

### E1.2 — Por que wrappers de string? (`Shared/Utils/strings.h`)

```cpp
#define STRINGCOPY( dest, src )  StringCchCopyA( dest, _countof( dest ), src )
#define STRINGCOMPARE( str1, str2 )  (lstrcmpA( str1, str2 ) == 0)
```

1. `strcpy(dest, src)` copia sem saber o tamanho de `dest`. O que
   `_countof(dest)` traz que `strcpy` não tem, e por que isso é uma
   proteção de segurança num jogo online? *(dica: buffer overflow)*
2. `STRINGCOMPARE` devolve `bool`. `lstrcmpA` sozinho devolve o quê?
   Por que esconder isso numa macro?
3. Várias funções têm duas versões (`STRINGCOPY` e `STRINGCOPYW`). O que o
   `W` significa, e existe uso real das versões `W` no projeto?

### E1.3 — Constantes que valem por uma feature (`Shared/GlobalsShared.h`)

```cpp
#define MAX_GOLD_LOW_LEVEL 2000000
#define MAX_GOLD_TIER2 10000000
#define MAX_GOLD_TIER3 500000000
#define PRIME_ITEM_TIME_1H (60*60*1)
#define PRIME_ITEM_TIME_7D (60*60*24*7)
```

1. Qual a unidade de `PRIME_ITEM_TIME_1H`? Como você confirmaria isso sem
   chutar? *(dica: procure onde é usado: grep por `PRIME_ITEM_TIME_1H`)*
2. Por que `(60*60*1)` com parênteses se a conta é simples?
3. Esse arquivo é `Shared/` — o que acontece com client e server se você
   mudar `MAX_GOLD_TIER2` e recompilar só o servidor? *(essa resposta vale
   ouro — é a regra de ouro nº 2 na prática)*

---

## Nível 2 — Mudanças pequenas, efeito visível

### E2.1 — Um log seu dentro do jogo

Escolha uma função pequena (que comece com letra minúscula e tenha menos de
20 linhas) em `SrcGame/src/Game/` ou `SrcServer/src/Server/`. Exemplo de
como chamar, no estilo do projeto:

```cpp
WRITEERR("minha marca: func rodou, valor=%d", algumaVariavel);
```

Tarefa: faça o log aparecer, confira, e **reverta depois**
(`git checkout -- arquivo`). Registre como o projeto compilou.

### E2.2 — Mexer numa constante (`Shared/GlobalsShared.h`)

Aumente `PRIME_ITEM_TIME_1H` pra 2 horas **nos dois lados** (a regra de
ouro nº 2). Questões antes de compilar:
1. Quais dois `.sln` você precisa recompilar?
2. Onde no jogo um item "prime de 1 hora" aparece pro jogador? (quer dizer:
   qual o artefato que você precisa observar pra provar que funcionou?)

---

## Nível 3 — Escrever código novo pequeno

### E3.1 — Entender o formato de uma função real

Em `strings.h` existe este par (declaração):

```cpp
int low(int a, int b);
int high(int a, int b);
```

Tarefa: abra `strings.cpp` e confira o que fazem (spoiler: min/max com
nomes do projeto). Depois escreva **você mesmo**, num arquivo `.cpp` de
teste fora do projeto, uma função:

```cpp
int clamp(int valor, int minimo, int maximo);
```

Regra: se `valor` estiver abaixo do mínimo, devolve o mínimo; se acima do
máximo, devolve o máximo; senão, devolve ele mesmo. Teste com 5 casos:
abaixo, no limite, dentro, no outro limite, acima.

**O que isso ensina:** ler a implementação dos outros, reproduzir o estilo,
e o conceito de "casos de teste de fronteira" — o mesmo raciocínio do plano
de teste manual do projeto, aplicado a uma função.

### E3.2 — Os níveis de XP são só uma tabela (`Shared/LevelTable.h`)

A tabela real começa assim:

```cpp
0, 1000, 2500, 5000, 9500, 17100, 29925, 51471, ...
```

1. Qual o significado do índice `0` valendo `0`? (dica: nível 1 = quanto XP
   acumulado?)
2. Calcule de cabeça/planilha: quanto XP vai do nível 4 pro 5? (9500-5000)
3. A curva acelera ou desacelera? Por que isso importa pro balanceamento?
4. (`Shared/`! reflita) Se você dobrar todos os valores pra onerar o up,
   o que acontece com o `.exe` do cliente que **não** foi recompilado?

### E3.3 — Usar `FormatNumber`

`FormatNumber(__int64 iNumber)` devolve `const char*` formatado (provavelmente
com separador de milhar). Tarefa: encontre a implementação em
`strings.cpp`, explique em voz alta o que ela faz (regra pessoal da
[[Trilha-de-Aprendizado]]), e depois encontre duas chamadas reais dela no
código (`Ctrl+Shift+F` no Visual Studio ou grep).

---

## Nível 4 — Rastrear um fluxo de ponta a ponta

### E4.1 — O caminho de um GM command

Arquivos: `SrcServer/src/Server/GM/GM.cpp` e `GM.h` (+ `ServerCommand.cpp`).

Tarefa: escolha um comando GM simples que existe hoje. Sem editar nada,
documente no [[Registro-de-Aprendizado]]:
1. Como o texto digitado pelo jogador vira `code`/opcode?
2. Qual função no server fizer o `switch`/dispatch?
3. Que dados o comando lê/escreve (banco? memória de jogador?)
4. Qual `smTRANSCODE_*` (se houver) vai de volta pro cliente?

Esse é o formato de pergunta que a [[Trilha-de-Aprendizado]] chama de
"rastrear um fluxo completo" — e é o que mais ensina no projeto.

### E4.2 — E depois: adicionar um comando GM (espec!)

Com o mapa da E4.1 feito, adicione um comando novo (ex: `/infoitem <code>`
que imprime no log os dados do item — e aí você usa a
`Dados-SQL/ListaItens_Drop.md` como referência do que responder).
**Esta parte é não-trivial: exige spec** — ver [[Processo-Spec-Driven]].

---

## Nível 5 — (futuro) Tocar em `Shared/` e protocolo

Quando E1 a E4 estiverem confortáveis:

1. Ler uma struct de pacote em `smPacket.h` (2.789 linhas — comece pelas
   primeiras structs) e explicar cada campo.
2. Escolher **um** `smTRANSCODE_*` do cliente (`RecvMessage` de
   `netplay.cpp`) e rastreá-lo até a resposta do server.
3. Só então conversar sobre uma feature pequena que adicione um pacote.

**Não pule pra cá com pressa.** Todos os tropeços desse nível são caros
(jogo dessincronizado), e todos são evitáveis com o processo spec-driven.

---

## Como fechar cada exercício

No [[Registro-de-Aprendizado]], sempre as mesmas 3 linhas:
- **Entendi que:** (uma frase)
- **Ainda confunde:** (uma pergunta concreta — essa pergunta vira o briefing
  pra próxima sessão com a IA)
- **Próximo passo:** (qual exercício vem agora)
