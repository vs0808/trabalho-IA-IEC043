# 03 - Planos Manuais

## 1. Forma dos planos

Um plano é uma lista de ações:

```prolog
[
    move(Bloco, PosicaoInicial, PosicaoFinal),
    move(Bloco, PosicaoInicial, PosicaoFinal)
]
```

Cada posição e representada por:

```prolog
p(X,Y)
```

## 2. Situacao 1: S0 até Sf4

Plano:

```prolog
plano_manual_s0_sf4([
    move(d, p(3,1), p(0,1)),
    move(a, p(3,0), p(5,1)),
    move(d, p(0,1), p(2,0)),
    move(a, p(5,1), p(0,1))
]).
```

Explicação:

1. `d` e movido para cima de `c`, liberando `a` e `b`.
2. `a` e colocado sobre `b`, liberando espaço na base.
3. `d` e colocado na base, entre `c` e `b`.
4. `a` e colocado sobre `c`, chegando ao estado `Sf4`.

## 3. Situação 2: S0 ate S5

Plano:

```prolog
plano_manual_sit2_s0_s5([
    move(b, p(1,1), p(2,0)),
    move(a, p(0,1), p(2,1)),
    move(c, p(0,0), p(4,1)),
    move(a, p(2,1), p(4,2)),
    move(b, p(2,0), p(5,2))
]).
```

Explicação:

1. `b` sai de cima de `c` e vai para a base.
2. `a` e colocado sobre `b`.
3. `c` e colocado sobre `d`.
4. `a` e movido para cima de `c`.
5. `b` e movido para cima de `c`, formando o objetivo `S5`.

## 4. Situação 3: S0 ate S7

Plano:

```prolog
plano_manual_sit3_s0_s7([
    move(d, p(3,1), p(0,1)),
    move(a, p(3,0), p(5,1)),
    move(d, p(0,1), p(2,0)),
    move(a, p(5,1), p(0,1)),
    move(b, p(5,0), p(1,1)),
    move(d, p(2,0), p(3,0))
]).
```

Explicação:

1. `d` sai de cima de `a` e `b` e vai para cima de `c`.
2. `a` e colocado sobre `b`.
3. `d` e movido para a base em `X = 2`.
4. `a` e colocado sobre `c`.
5. `b` e colocado ao lado de `a`, também sobre `c`.
6. `d` e deslocado para `X = 3`, chegando ao estado `S7`.

## 5. Validação dos planos

Os planos manuais não ficam apenas descritos no texto. Eles são executados por:

```prolog
aplica_plano(EstadoInicial, Plano, EstadoFinal)
```

Depois o estado final é comparado com o objetivo usando:

```prolog
igual_estado(Final, Objetivo)
```
