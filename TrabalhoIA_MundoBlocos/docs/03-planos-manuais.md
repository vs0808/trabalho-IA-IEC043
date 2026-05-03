# 03 - Planos Manuais

## 1. Forma dos planos

Um plano é uma lista de ações:

```prolog
[
    move(Bloco, PosicaoInicial, PosicaoFinal),
    move(Bloco, PosicaoInicial, PosicaoFinal)
]
```

Cada posição é representada por:

```prolog
p(X,Y)
```

Exemplo:

```prolog
move(d, p(3,1), p(0,1))
```

Essa ação significa: mover o bloco `d` da posição `(3,1)` para a posição `(0,1)`.

A ação é apenas um termo. Quem executa a ação sobre um estado é:

```prolog
acao(Acao, Estado, NovoEstado)
```

---

## 2. Situação 1: S0 até Sf4

Arquivo:

```text
ResolucaoIA/blocos1.pl
```

Plano:

```prolog
plano_manual_sit1_s0_sf4([
    move(d, p(3,1), p(0,1)),
    move(a, p(3,0), p(5,1)),
    move(d, p(0,1), p(2,0)),
    move(a, p(5,1), p(0,1))
]).
```

Também existe o alias:

```prolog
plano_manual_s0_sf4(Plano) :-
    plano_manual_sit1_s0_sf4(Plano).
```

Explicação:

1. `d` é movido para cima de `c`, liberando `a` e `b`.
2. `a` é colocado sobre `b`.
3. `d` é colocado na base, entre `c` e `b`.
4. `a` é colocado sobre `c`, chegando a `Sf4`.

Validação esperada:

```prolog
once((
    estado_sit1_s0(S0),
    estado_sit1_sf4(Objetivo),
    plano_manual_sit1_s0_sf4(Plano),
    aplica_plano(S0, Plano, Final),
    igual_estado(Final, Objetivo)
)).
```

Resultado esperado:

```prolog
true.
```

---

## 3. Situação 2: S0 até S5

Arquivo:

```text
ResolucaoIA/blocos2.pl
```

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

Transições associadas:

```prolog
transicao_sit2(s0, s1, move(b, p(1,1), p(2,0))).
transicao_sit2(s1, s2, move(a, p(0,1), p(2,1))).
transicao_sit2(s2, s3, move(c, p(0,0), p(4,1))).
transicao_sit2(s3, s4, move(a, p(2,1), p(4,2))).
transicao_sit2(s4, s5, move(b, p(2,0), p(5,2))).
```

Explicação:

1. `b` sai de cima de `c` e vai para a base.
2. `a` é colocado sobre `b`.
3. `c` é colocado sobre `d`.
4. `a` é movido para cima de `c`.
5. `b` é movido para cima de `c`, formando `S5`.

Validação esperada:

```prolog
once((
    estado_sit2_s0(S0),
    estado_sit2_s5(Objetivo),
    plano_manual_sit2_s0_s5(Plano),
    aplica_plano(S0, Plano, Final),
    igual_estado(Final, Objetivo)
)).
```

Resultado esperado:

```prolog
true.
```

---

## 4. Situação 3: S0 até S7

Arquivo:

```text
ResolucaoIA/blocos3.pl
```

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

Transições associadas:

```prolog
transicao_sit3(s0, s1, move(d, p(3,1), p(0,1))).
transicao_sit3(s1, s2, move(a, p(3,0), p(5,1))).
transicao_sit3(s2, s3, move(d, p(0,1), p(2,0))).
transicao_sit3(s3, s4, move(a, p(5,1), p(0,1))).
transicao_sit3(s4, s5, move(b, p(5,0), p(1,1))).
transicao_sit3(s6, s7, move(d, p(2,0), p(3,0))).
```

Explicação:

1. `d` sai de cima de `a` e `b` e vai para cima de `c`.
2. `a` é colocado sobre `b`.
3. `d` é movido para a base em `X = 2`.
4. `a` é colocado sobre `c`.
5. `b` é colocado ao lado de `a`, também sobre `c`.
6. `d` é deslocado para `X = 3`, chegando a `S7`.

Como `S5` e `S6` aparecem iguais na representação adotada, a transição final parte de `S6`, que possui a mesma configuração de `S5`.

Validação esperada:

```prolog
once((
    estado_sit3_s0(S0),
    estado_sit3_s7(Objetivo),
    plano_manual_sit3_s0_s7(Plano),
    aplica_plano(S0, Plano, Final),
    igual_estado(Final, Objetivo)
)).
```

Resultado esperado:

```prolog
true.
```

---

## 5. Validação dos planos manuais

Os planos manuais são validados com:

```prolog
aplica_plano(EstadoInicial, Plano, EstadoFinal),
igual_estado(EstadoFinal, Objetivo)
```

`aplica_plano/3` executa as ações em sequência.

`igual_estado/2` compara estados normalizados, de modo que a ordem dos termos na lista não afete o resultado.

Nos testes, as consultas positivas usam:

```prolog
once(( ... ))
```

Isso evita avisos de `choicepoint` sem alterar a lógica dos predicados.

---

## 6. Relação com o planejador automático

Os planos manuais servem como referência humana para os cenários do trabalho.

Na versão refatorada, o planejador automático é chamado por:

```prolog
plano(EstadoInicial, Objetivo, PlanoGerado)
```

ou pelo alias:

```prolog
planos(EstadoInicial, Objetivo, PlanoGerado)
```

O plano gerado automaticamente pode ser igual ao plano manual ou diferente. O critério principal é que, ao ser aplicado com `aplica_plano/3`, ele produza um estado final equivalente ao objetivo.

A comparação formal entre o plano manual e o plano gerado será tratada posteriormente em documentação própria.
