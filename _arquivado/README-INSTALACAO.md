# Como instalar este kit no seu repositório

1. Copie as pastas `.cursor/` e `docs/` e o arquivo `CHANGELOG.md` para a
   raiz de `Source Priston/` (mesmo nível do `.gitignore`).
2. Crie a pasta `docs/specs/` (vazia por enquanto, é onde as specs futuras
   vão morar).
3. Revise `docs/ARCHITECTURE.md` — os "(a validar)" são meus melhores
   palpites olhando só a estrutura de pastas. Corrija o que você já sabe
   estar errado.
4. Commit inicial sugerido:
   ```
   git add .cursor docs CHANGELOG.md
   git commit -m "docs: adiciona arquitetura, regras do Cursor, workflow de git e template de spec"
   ```
5. Abra o Cursor nesse repo — as regras em `.cursor/rules/*.mdc` já vão
   carregar automaticamente (a `00-project-overview.mdc` sempre; as outras
   quando você estiver editando arquivo dentro do glob correspondente).
6. Teste: abra um chat no Cursor e pergunte "que regras de projeto você tem
   carregadas agora?" — ele deve citar o conteúdo de `00-project-overview.mdc`.

Nada aqui é definitivo — é um ponto de partida. Ajuste as regras conforme
o Cursor for errando de um jeito específico e repetido (esse é o sinal mais
confiável de que falta uma regra, não de que você "explicou mal" no chat).
