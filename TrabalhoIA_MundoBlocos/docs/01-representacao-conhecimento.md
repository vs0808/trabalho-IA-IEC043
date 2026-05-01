# 01 - Representacao do Conhecimento

## 1. Motivacao

No Mundo dos Blocos tradicional, todos os blocos costumam ter tamanho unitário. Nesse caso, uma relação como `sobre(a,b)` pode ser suficiente para varios problemas simples.

Neste trabalho, os blocos possuem larguras diferentes. Por isso, a representação precisa informar onde cada bloco esta no espaço.

## 2. Blocos e dimensoes

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

Nesta modelagem, todos os blocos possuem altura 1:

```prolog
altura(a, 1).
altura(b, 1).
altura(c, 1).
altura(d, 1).
```

## 3. Representacao de estado

Um estado e uma lista de posições:

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

- `Bloco` e o identificador do bloco;
- `X` e a coordenada horizontal inicial;
- `Y` e a altura da base do bloco.

## 4. Intervalos semiabertos

Foi usada a convenção de intervalos semiabertos:

```text
[XInicio, XFim)
```

Exemplo:

```prolog
pos(c,0,0)
```

Como `c` tem largura 2, ele ocupa horizontalmente:

```text
[0,2)
```

Essa escolha evita ambiguidades. Um bloco em `[0,2)` e outro em `[2,3)` encostam, mas não colidem.

## 5. Mesa

A mesa vai da coordenada 0 ate a coordenada 6:

```prolog
limite_mesa(0, 6).
```

Um bloco esta dentro da mesa quando:

```text
X >= 0
X + largura <= 6
```

## 6. Ocupação

O predicado `ocupa/6` calcula o retângulo ocupado por um bloco:

```prolog
ocupa(B, Estado, X1, X2, Y1, Y2)
```

Exemplo:

```prolog
estado_sit1_s0(S), ocupa(d, S, X1, X2, Y1, Y2).
```

Resultado esperado:

```prolog
X1 = 3,
X2 = 6,
Y1 = 1,
Y2 = 2.
```

## 7. Colisão

Dois blocos colidem quando seus intervalos horizontais e verticais se sobrepoem ao mesmo tempo.

Predicados principais:

```prolog
intervalos_sobrepoem/4
retangulos_sobrepoem/2
sem_colisoes/1
```

A existência de `sem_colisoes/1` impede estados fisicamente impossíveis, por exemplo, dois blocos ocupando o mesmo lugar.

## 8. Apoio

Um bloco esta apoiado quando:

1. esta na mesa, ou seja, `Y = 0`; ou
2. existe algum bloco imediatamente abaixo dele.

No caso de blocos largos, foi adicionada uma regra de equilíbrio simplificado pelo centro geométrico.

A ideia é:

```text
centro horizontal do bloco deve cair dentro do intervalo total de apoio
```

Isso permite representar casos como o estado inicial da Situação 1, em que `d` fica apoiado em `a` e `b`, mesmo existindo um vão entre eles.

## 9. Bloco livre

Um bloco esta livre quando não existe outro bloco apoiado diretamente sobre ele.

Predicado:

```prolog
bloco_livre(B, Estado)
```

Esse predicado é essencial para a ação `move`, pois somente blocos livres podem ser movidos.

## 10. Estado valido

Um estado é valido quando passa por todas as verificações:

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

## 11. Relacao entre conhecimento e ações

| Elemento novo | Funcao | Acao associada |
|---|---|---|
| `largura/2` | Calcula espaco horizontal ocupado | `move/3`, colisao, apoio |
| `altura/2` | Calcula espaco vertical ocupado | `move/3`, bloco livre |
| `pos/3` | Localiza o bloco no estado | todas as acoes |
| `ocupa/6` | Calcula retangulo ocupado | colisao, apoio, bloco livre |
| `sem_colisoes/1` | Impede sobreposicao | validacao de movimento |
| `apoio_valido/4` | Garante sustentacao fisica | validacao de movimento |
| `bloco_livre/2` | Verifica se bloco pode ser retirado | `move/3` |
| `estado_valido/1` | Valida o estado completo | `acao/3` e `plano/3` |
