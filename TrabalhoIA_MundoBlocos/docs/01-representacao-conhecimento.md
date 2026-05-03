# 01 - Representação do Conhecimento

## 1. Objetivo da representação

O trabalho trata do **Mundo dos Blocos com blocos de dimensões diferentes**. Por isso, uma representação baseada apenas em relações simbólicas simples, como `sobre(a,b)`, não é suficiente.

A solução adotada usa:

- coordenadas horizontais e verticais;
- dimensões dos blocos;
- ocupação espacial por retângulos;
- verificação de colisão;
- verificação de apoio;
- equilíbrio por centro geométrico;
- ações de movimento;
- planejador automático por regressão de objetivos com uma estrutura de plano parcialmente ordenado.

A lógica principal está em:

```text
ResolucaoIA/blocos.pl
```

Esse arquivo define os blocos, as dimensões, os predicados espaciais, a ação `move`, a aplicação de planos, o planejador `plano/3`, o alias `planos/3`, a estrutura de plano parcialmente ordenado e os testes gerais.

As situações específicas estão em:

```text
ResolucaoIA/blocos1.pl
ResolucaoIA/blocos2.pl
ResolucaoIA/blocos3.pl
```

---

## 2. Blocos e dimensões

Foram definidos quatro blocos:

```prolog
bloco(a).
bloco(b).
bloco(c).
bloco(d).
```

As larguras são:

```prolog
largura(a, 1).
largura(b, 1).
largura(c, 2).
largura(d, 3).
```

Também foi definido o predicado:

```prolog
tamanho(B, T) :-
    largura(B, T).
```

`tamanho/2` funciona como sinônimo conceitual de `largura/2`, mantendo a leitura próxima ao enunciado, que trata de blocos de tamanhos diferentes.

As alturas atuais são:

```prolog
altura(a, 1).
altura(b, 1).
altura(c, 1).
altura(d, 1).
```

Embora todas as alturas sejam 1 nos cenários do trabalho, a representação permite alterar a altura de blocos futuramente sem mudar a lógica de ocupação espacial.

---

## 3. Representação de estado

Um estado é uma lista de posições:

```prolog
[
    pos(c,0,0),
    pos(a,3,0),
    pos(b,5,0),
    pos(d,3,1)
]
```

Cada termo tem a forma:

```prolog
pos(Bloco, X, Y)
```

Onde:

- `Bloco` identifica o bloco;
- `X` é a coordenada horizontal inicial do bloco;
- `Y` é a altura da base do bloco.

Exemplo:

```prolog
pos(d,3,1)
```

Como `d` tem largura 3 e altura 1, ele ocupa:

```text
horizontalmente: [3,6)
verticalmente:   [1,2)
```

---

## 4. Intervalos semiabertos

A modelagem usa intervalos semiabertos:

```text
[Inicio, Fim)
```

Assim:

```text
[0,2) e [2,3)
```

encostam, mas não colidem.

Essa escolha evita ambiguidades em situações nas quais blocos estão lado a lado.

---

## 5. Mesa

A mesa vai da coordenada 0 até a coordenada 6:

```prolog
limite_mesa(0, 6).
```

Um bloco está dentro da mesa quando:

```text
X >= 0
X + largura <= 6
```

Essa verificação é feita por:

```prolog
dentro_da_mesa(Bloco, X)
```

---

## 6. Coordenadas candidatas

O planejador precisa gerar posições possíveis para os blocos. Para isso, são usados:

```prolog
coord_x(Bloco, X)
coord_y(Y)
```

`coord_x/2` gera coordenadas horizontais possíveis respeitando a largura do bloco e os limites da mesa.

`coord_y/1` gera alturas candidatas. Na versão refatorada, a altura máxima não é mais fixa. Ela é calculada automaticamente pela soma das alturas de todos os blocos:

```prolog
altura_maxima(MaxY) :-
    findall(H, (bloco(B), altura(B, H)), Alturas),
    sum_list(Alturas, MaxY).
```

Impacto da refatoração: se as alturas dos blocos forem alteradas futuramente, o planejador continuará gerando alturas compatíveis com o domínio, sem exigir ajuste manual de `altura_maxima/1`.

---

## 7. Ocupação espacial

O predicado:

```prolog
ocupa(Bloco, Estado, X1, X2, Y1, Y2)
```

calcula o retângulo ocupado por um bloco em determinado estado.

Exemplo:

```prolog
estado_sit1_s0(S),
ocupa(d, S, X1, X2, Y1, Y2).
```

Resultado esperado:

```prolog
X1 = 3,
X2 = 6,
Y1 = 1,
Y2 = 2.
```

---

## 8. Colisão

Dois blocos colidem quando seus intervalos horizontais e verticais se sobrepõem ao mesmo tempo.

Predicados envolvidos:

```prolog
intervalos_sobrepoem/4
retangulos_sobrepoem/2
sem_colisoes/1
```

`retangulos_sobrepoem/2` exige que os blocos comparados sejam diferentes:

```prolog
B1 \= B2
```

Isso evita comparar um bloco consigo mesmo.

---

## 9. Apoio e equilíbrio

Um bloco está apoiado quando:

1. está diretamente na mesa (`Y = 0`); ou
2. possui um ou mais blocos imediatamente abaixo dele e seu centro geométrico horizontal está dentro do intervalo total de apoio.

Predicados envolvidos:

```prolog
segmento_apoio/5
limites_dos_segmentos/3
centro_bloco/3
centro_dentro_intervalo/3
apoio_valido/4
```

O centro geométrico é calculado sem números decimais:

```prolog
centro_bloco(B, X, Centro2) :-
    largura(B, L),
    Centro2 is 2*X + L.
```

A comparação usa o dobro do centro real. Isso evita problemas de ponto flutuante.

Esse modelo permite representar casos como o `S0` da Situação 1, em que `d` está apoiado em `a` e `b`, mesmo existindo um vão entre os dois apoios.

A interpretação adotada é que o bloco superior está equilibrado quando seu centro geométrico cai dentro do intervalo convexo formado pelos apoios inferiores.

---

## 10. Bloco livre

Um bloco está livre quando não existe outro bloco diretamente acima dele.

```prolog
bloco_livre(Bloco, Estado)
```

Esse predicado é obrigatório para `acao/3`, pois somente blocos livres podem ser movidos.

---

## 11. Estado válido

Um estado é válido quando:

```prolog
estado_valido(Estado) :-
    todos_blocos_presentes(Estado),
    coordenadas_estado_validas(Estado),
    sem_colisoes(Estado),
    forall(
        member(pos(B, X, Y), Estado),
        apoio_valido(B, X, Y, Estado)
    ).
```

Assim, um estado precisa:

1. conter todos os blocos;
2. usar coordenadas válidas;
3. manter todos os blocos dentro da mesa;
4. não conter colisões;
5. garantir que todos os blocos estejam apoiados.

---

## 12. Ação

A ação tem a forma:

```prolog
move(Bloco, p(X0,Y0), p(X,Y))
```

Ela é executada por:

```prolog
acao(Acao, Estado, NovoEstado)
```

Um movimento só é aceito se:

1. o bloco existir no estado;
2. o bloco estiver livre;
3. a nova coordenada horizontal for válida;
4. a nova altura for candidata;
5. a nova posição for diferente da posição original;
6. o estado resultante for válido.

A ação usa a representação geométrica para impedir movimentos que gerem colisão, falta de apoio ou saída da mesa.

---

## 13. Pré-condições explicativas

A solução também define:

```prolog
precondicoes_move(Acao, Estado, Precondicoes)
```

Esse predicado tem função documental e explicativa. Ele lista as condições conceituais associadas a um movimento, como:

```prolog
bloco_no_estado(B, X0, Y0)
bloco_livre(B)
coordenada_x_valida(B, X)
coordenada_y_candidata(Y)
movimento_altera_posicao(p(X0,Y0), p(X,Y))
estado_resultante_valido
```

A execução real da ação continua sendo feita por:

```prolog
acao/3
```

---

## 14. Normalização de estados

Estados são listas, e a ordem dos termos pode variar. Por isso, foram criados:

```prolog
normaliza_estado/2
igual_estado/2
```

`normaliza_estado/2` usa `sort/2`.

`igual_estado/2` compara estados normalizados.

Assim, duas listas com os mesmos blocos nas mesmas posições são consideradas equivalentes mesmo que os termos estejam em ordem diferente.

---

## 15. Planejamento por regressão de objetivos

Na versão refatorada, o planejador deixou de ser uma busca progressiva simples no espaço de estados.

O planejador principal continua sendo chamado por:

```prolog
plano(Inicio, Objetivo, Plano)
```

Também foi adicionado o alias:

```prolog
planos(Inicio, Objetivo, Plano) :-
    plano(Inicio, Objetivo, Plano).
```

A ideia agora é partir do objetivo e buscar estados predecessores:

```text
Objetivo -> predecessor -> predecessor -> ... -> Estado inicial
```

Esse processo é feito por predicados como:

```prolog
regressao_limite/5
predecessor_por_regressao/3
```

Ao encontrar o estado inicial, as ações regressivas são invertidas para produzir uma sequência executável do início até o objetivo.

---

## 16. Plano parcialmente ordenado

A refatoração também introduziu uma estrutura explícita de plano parcialmente ordenado:

```prolog
pop(Passos, Ordem)
```

Os passos têm a forma:

```prolog
passo(0, inicio)
passo(1, Acao1)
passo(2, Acao2)
...
passo(N, objetivo)
```

As relações de ordem são representadas por:

```prolog
antes(I, J)
```

A consulta principal é:

```prolog
plano_parcial(Inicio, Objetivo, POP, PlanoLinear)
```

`PlanoLinear` é a sequência executável de ações. `POP` registra a estrutura de passos e precedências.

No contexto desta solução, a ordem parcial é representada como restrições de precedência entre os passos encontrados pela regressão. Isso prepara a documentação e o código para uma comparação posterior entre plano manual e plano gerado.

---

## 17. Relação entre conhecimento e ações

| Elemento | Função | Predicados/ações associados |
|---|---|---|
| `bloco/1` | Define os blocos existentes | `todos_blocos_presentes/1`, `estado_valido/1`, `acao/3` |
| `largura/2` | Define ocupação horizontal | `dentro_da_mesa/2`, `coord_x/2`, `ocupa/6`, colisão, apoio |
| `tamanho/2` | Sinônimo conceitual de largura | documentação e consultas conceituais |
| `altura/2` | Define ocupação vertical | `altura_maxima/1`, `ocupa/6`, `bloco_livre/2`, apoio |
| `altura_maxima/1` | Calcula limite vertical geral | `coord_y/1`, planejador |
| `pos/3` | Localiza blocos | todos os predicados espaciais |
| `limite_mesa/2` | Define limites horizontais | `dentro_da_mesa/2`, `coord_x/2` |
| `ocupa/6` | Calcula retângulo ocupado | colisão, apoio, bloco livre |
| `sem_colisoes/1` | Impede sobreposição | `estado_valido/1`, `acao/3` |
| `centro_bloco/3` | Calcula centro geométrico | `apoio_valido/4` |
| `centro_dentro_intervalo/3` | Verifica equilíbrio | `apoio_valido/4` |
| `apoio_valido/4` | Garante sustentação | `estado_valido/1`, `acao/3` |
| `bloco_livre/2` | Verifica se pode mover | `acao/3` |
| `precondicoes_move/3` | Explica as condições do movimento | documentação e análise do domínio |
| `estado_valido/1` | Valida estado completo | `acao/3`, `plano/3`, `planos/3` |
| `normaliza_estado/2` | Padroniza listas de estado | `igual_estado/2`, planejador |
| `igual_estado/2` | Compara estados | testes, planos e planejador |
| `acao/3` | Executa movimento válido | planos manuais, regressão e testes |
| `plano/3` | Gera plano automático | planejador por regressão |
| `planos/3` | Alias de `plano/3` | testes e consultas alternativas |
| `plano_parcial/4` | Gera estrutura POP e plano linear | planejamento parcialmente ordenado |
