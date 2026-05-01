# 05 - Testes e Resultados Esperados

## 1. Testar a base principal

Comando:

```bash
swipl -q -s blocos.pl -g run_tests -t halt
```

Saída esperada:

```text
% PL-Unit: situacao1 ............. done
% All 13 tests passed
```

## 2. Testar Situações 2 e 3

Comando:

```bash
swipl -q -s situacoes_2_3.pl -g run_tests -t halt
```

Saída esperada:

```text
% PL-Unit: situacao1 ............. done
% PL-Unit: situacoes_2_3 ............................ done
% All 41 tests passed
```

## 3. Testar somente Situações 2 e 3

Comando:

```bash
swipl -q -s situacoes_2_3.pl -g "run_tests(situacoes_2_3)" -t halt
```

Saída esperada:

```text
% PL-Unit: situacoes_2_3 ............................ done
% All 28 tests passed
```

## 4. Consultar um estado

Abrir o Prolog:

```bash
swipl -q -s situacoes_2_3.pl
```

Consultar:

```prolog
estado_sit3_s7(S), mostra_estado(S).
```

Saida esperada:

```prolog
pos(a,0,1)
pos(b,1,1)
pos(c,0,0)
pos(d,3,0)
S = [pos(c, 0, 0), pos(d, 3, 0), pos(a, 0, 1), pos(b, 1, 1)].
```

## 5. Validar plano manual da Situação 2

Consulta:

```prolog
once((
    estado_sit2_s0(S0),
    estado_sit2_s5(Objetivo),
    plano_manual_sit2_s0_s5(Plano),
    aplica_plano(S0, Plano, Final),
    igual_estado(Final, Objetivo)
)).
```

Saída esperada:

```prolog
true.
```

## 6. Validar plano manual da Situação 3

Consulta:

```prolog
once((
    estado_sit3_s0(S0),
    estado_sit3_s7(Objetivo),
    plano_manual_sit3_s0_s7(Plano),
    aplica_plano(S0, Plano, Final),
    igual_estado(Final, Objetivo)
)).
```

Saída esperada:

```prolog
true.
```

## 7. Mostrar um plano

Consulta:

```prolog
plano_manual_sit3_s0_s7(Plano), mostra_plano(Plano).
```

Saída esperada:

```prolog
move(d,p(3,1),p(0,1))
move(a,p(3,0),p(5,1))
move(d,p(0,1),p(2,0))
move(a,p(5,1),p(0,1))
move(b,p(5,0),p(1,1))
move(d,p(2,0),p(3,0))
```

## 8. Gerar plano automático

Consulta:

```prolog
estado_sit3_s0(S0),
estado_sit3_s7(Objetivo),
plano(S0, Objetivo, Plano).
```

A saída pode ser o plano manual ou outro plano valido. O importante e que, ao aplicar o plano retornado, o estado final seja igual ao objetivo.
