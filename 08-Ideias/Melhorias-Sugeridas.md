---
tags: [ideias, backlog, melhorias]
data: 2026-09-06
---

# Melhorias Sugeridas — o que dá pra fazer no jogo, por área

> Lista concreta de melhorias já viáveis na source atual. Não é "wish list"
> de servidor profissional — é o que realmente dá pra executar sozinho (ou
> com IA) no estágio atual do projeto, ordenado por **custo x benefício**.
>
> - **Dificuldade:** 1 (config/trocar valor) a 5 (mexer em protocolo)
> - **Risco:** baixo/médio/alto de quebrar algo existente
> - **Status:** acompanha [[Backlog-de-Ideias]] — quando for começar, use
>   o Processo Spec-Driven ([[Processo-Spec-Driven]])

---

## 1. Segurança (fazer primeiro)

### 1.1 Tirar senhas do banco de texto puro
**Dificuldade:** 4/5 · **Risco:** médio · já documentado como pendência alta
Hoje a tabela `Users` guarda senha sem hash. `SELECT * FROM Users` expõe
todas as senhas. Passos: escolher um hash (bcrypt/SHA-512 com salt por
usuário), mudar coluna pra tamanho compatível com o hash, alterar o proc ou
query de login pra comparar hash, e migrar as contas existentes (o usuário
troca de senha no primeiro login depois da virada, ou migra na hora usando
hash da senha atual). **Obstáculo:** hash nativo precisa de biblioteca
extra ou implementação própria — especifique isso na spec.

### 1.2 Trancar credenciais do banco fora do código
**Dificuldade:** 1/5 · **Risco:** baixo · item 2 do SDD seção 12
`SrcServer/src/Server/gameSQL.cpp` tem credenciais hardcoded como fallback.
Movê-las pra `Server\Config\SQL.ini` (seção `[Database]`) e remover o
fallback ou substituir por um erro claro ("configure SQL.ini!").

### 1.3 Ativar/fortalecer validações server-side
**Dificuldade:** 3/5 · **Risco:** baixo (só aumenta validação)
O SDD cita "validações client-side podem ser contornadas — sempre validar
no servidor". Levantar onde o servidor confia em valor vindo do cliente sem
checar (quantidade de item, distância de uso de skill, valor de dano pedido)
e adicionar checagem plausível (ex: "esse jogador consegue mesmo estar nessa
distância?").

### 1.4 Decidir o destino do XignCode/XTrap
**Dificuldade:** 2/5 · **Risco:** baixo · pendência listada
O código tem anti-cheat desativado por `#ifdef`. Documentar a decisão (ADR):
manter desativado, reativar, ou substituir por algo mais leve. De qualquer
forma, o status atual deve estar documentado.

---

## 2. Banco de dados

### 2.1 Versionar o schema do banco em SQL/
**Dificuldade:** 2/5 · **Risco:** baixo
Hoje a pasta `SQL/` do repositório do jogo está vazia — o schema existe
só dentro do banco. Exportar os DDLs das 12 bases (uma-e-uma, começando
pelas menores) e manter em `SQL/`. Isso permite: recriar banco de testes,
auditar "o que mudou no banco", e comparar produção vs desenvolvimento.
Ver [[Banco-de-Dados]].

### 2.2 Documentar colunas incompletas de cada tabela
**Dificuldade:** 1/5 · **Risco:** nenhum · entrelaça com Dados-SQL
As exportações em `Dados-SQL/` flagram colunas vazias (ver "Obs:" no final
de cada arquivo, ex: `ItemType`, `ItemSpirit`, `BlockMin` sempre zero).
Decidir se são colunas obsoletas ou se faltam dados, e registrar. Vira o
dicionário de dados do projeto.

### 2.3 Criar procs padronizados pra rotinas repetitivas
**Dificuldade:** 2/5 · **Risco:** baixo
O cliente consulta tabelas via queries montadas em código C++. Levantar as
queries mais usadas (login, save de personagem, ranking) e virar procedures
com nome padrão. Facilita manutenção e evita SQL injetável — a query fica
dentro do banco, não na string do código.

### 2.4 Política de backup do banco (ver guia VPS)
**Dificuldade:** 1/5 · **Risco:** nenhum
Agendar backup diário automático na VPS (`manutenção -> backup nativo`
ou script `.bat`/PowerShell). Ver `09-Guias/VPS-e-SQL-Server.md`.

---

## 3. Estrutura de código

### 3.1 Planejar a partição do OnSever.cpp (não fazer ainda — planejar)
**Dificuldade:** 5/5 · **Risco:** alto (se mexer em código)
O servidor tem um arquivo de 34 mil+ linhas (`OnSever.cpp`). Não é pra
refatorar agora — mas dá pra **começar a medir**: criar um ADR "por que
não refatoramos", e, a cada feature nova, adicionar código novo em arquivos
separados em vez de aumentar OnSever.cpp. A regra: "novo código não entra
no gigante" reduz a taxa de crescimento até o dia em que cortar vira
seguro.

### 3.2 Corrigir build Debug
**Dificuldade:** 2/5 · **Risco:** baixo
O build Debug está quebrado por caminhos absolutos do dev original (item 4
do SDD seção 12). Corrigir pra `Debug|Win32` compilar permite debugar com
breakpoint e assert, o que acelera muito a caça a bugs. Provavelmente são
caminhos em `.vcxproj` — mexer com cuidado (regra 6 das regras de ouro).

### 3.3 Emagrecer o repositório git
**Dificuldade:** 2/5 · **Risco:** baixo
O `.git` do repositório do jogo tem ~61 MB sem pack, e bibliotecas
pré-compiladas (~79 MB) rastreadas pelo git. Rodar `git gc --aggressive`
e avaliar se essas libs deveriam ir pro `.gitignore` + pasta local (o que
exige um script de setup pra quem clona). Isso só encolhe; não muda código.

### 3.4 Retirar chamadas hardcoded de IP porta e credenciais
**Dificuldade:** 2/5 · **Risco:** baixo
Levantar no código todo lugar com IP/porta/credencial fixo (além do
`game.ini` que já aponta pra IP externo) e unificar em config. O cliente
deveria ler **só** do `game.ini`.

---

## 4. Dados e ferramentas pra GMs

### 4.1 Comando GM de consulta rápida ao banco
**Dificuldade:** 3/5 · **Risco:** baixo
Comando `/busca <nome>` que retorna o código do item (a partir dos dados
de `Dados-SQL/`). Evita precisar abrir o SSMS ou o `ListaItens_Drop.md`
toda vez que for dar item. Entrelaça com o sistema de comandos GM (~50) já
existente.

### 4.2 Comando GM de dar item por nome, não por código
**Dificuldade:** 3/5 · **Risco:** baixo
Hoje `/drop` exige o código (`wa101`). Aceitar nome parcial ("machado
de pedra") melhora a vida do GM. Precisa de busca case-insensitive na
tabela — talvez um proc.

### 4.3 Exportar saída de comandos GM pra arquivo
**Dificuldade:** 2/5 · **Risco:** baixo
Se os comandos GM já imprimem no console/log, adicionar opção de jogar a
saída pra um arquivo (`.log` ao lado do `.exe`). Auditar cheat e testar
balanceamento sem copiar de um terminal.

### 4.4 documentação viva dos comandos GM
**Dificuldade:** 1/5 · **Risco:** nenhum · docs
Os ~50 comandos GM existem mas não há lista central no vault. Criar
`09-Guias/Comandos-GM.md` com cada comando, sintaxe e o que faz — a partir
do `SrcServer/src/Server/GM/`. (Este é um bom exercício pra IA com repo
indexado.)

---

## 5. Qualidade de jogo (visível pro jogador)

### 5.1 Padronizar apresentação de preços
**Dificuldade:** 2/5 · **Risco:** baixo
Há ~1200 itens com preço na coluna `Price`. Levantar se os preços de venda
estão consistentes (ex: não tem item de nível 1 valendo mais que o de 100),
e documentar a curva pra poder ajustar sem medo.

### 5.2 Checar se os nomes de item batem com o que o jogador vê
**Dificuldade:** 2/5 · **Risco:** baixo
Os `Dados-SQL/` têm os nomes em português, mas o que o cliente mostra
vem de recurso do cliente (`.dat`/localização), não do banco. Levantar
inconsistências (nome diferente entre drop e tela) e resolver pela raiz
certa (banco ou cliente).

### 5.3 Balancear taxas de drop por mapa/nível
**Dificuldade:** 3/5 · **Risco:** médio
Com `DropList.md` + `DropItem.md` + `MonsterList.md` exportados dá pra
simular: qual a chance de um jogador de nível X ver o item Y? Documentar
a curva real antes de mexer. Depois, ajustar via tabela no banco (sem tocar
em código).

### 5.4 Client: consolidar os 3 sistemas de UI
**Dificuldade:** 5/5 · **Risco:** alto · longo prazo
O cliente tem UI clássica (sin), UI nova (`Engine/UI`) e Dear ImGui em
paralelo. Padrão: **não mexer nos sistemas que funcionam** — UI nova só em
um dos sistemas, documentado em ADR qual é o "sistema oficial" pra novas
features. Isso interrompe o espalhamento até o dia em que consolidar vira
possível.

---

## 6. Ferramentas e automação

### 6.1 Script de geração de release
**Dificuldade:** 2/5 · **Risco:** baixo
`.bat`/PowerShell que, após compilar no Release, copia `Game.exe`/`Server.exe`
pra pasta de release com carimbo de data e roda `git tag`. Substitui o
passo manual propício a erro.

### 6.2 Ferramenta de diff de personagem (.dat)
**Dificuldade:** 3/5 · **Risco:** baixo
Personagens são salvos em `.dat` binário (ver SDD 5.2). Ferramenta em linha
de comando que despeja os campos principais (nome, nível, ouro, inventário)
ajuda a debugar save corrompido sem precisar abrir o jogo.

### 6.3 Alerta de servidor caído
**Dificuldade:** 2/5 · **Risco:** baixo
Script externo (outra máquina) que conecta na porta do jogo de tempos em
tempos e, se falhar, manda alerta (Discord webhook já é usado pelo cliente).
Mínimo de observabilidade pra produção.

---

## Como priorizar

Critério do projeto: **o que destrava mais aprendizado com menos risco
primeiro.** Ordem recomendada pra este arquivo:

1. 2.4 e 2.1 (backup + schema no git) — proteção, sem risco
2. 1.2 e 3.4 (credenciais hardcoded) — segurança, dificuldade 1
3. 4.4 (docs de comandos GM) — docs, ajuda no dia a dia
4. 1.1 (hash de senha) — segurança alta, exige spec
5. resto conforme o aprendizado e a vontade na hora
