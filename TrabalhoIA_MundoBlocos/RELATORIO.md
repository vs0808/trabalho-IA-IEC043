# Relatorio - Testes e Comparacao de Planos

## 1. Objetivo do relatorio

Este relatorio documenta a validacao da solucao para o Mundo dos Blocos com dimensoes diferentes. A comparacao principal e feita entre:

1. planos manuais descritos a partir das situacoes do enunciado;
2. validacao dos planos por meio dos predicados Prolog;
3. geracao automatica de planos por `plano/3`, quando aplicavel.

## 2. Criterios de validade

Um estado e considerado valido quando satisfaz simultaneamente:

- todos os blocos do problema estao presentes;
- todos os blocos estao dentro dos limites da mesa;
- nao ha colisao entre blocos;
- cada bloco esta apoiado na mesa ou em outro bloco;
- blocos em altura maior que zero respeitam a regra de apoio e equilibrio simplificado.

Um movimento e considerado valido quando:

- o bloco existe no estado atual;
- o bloco esta livre;
- a nova posicao esta dentro da mesa;
- o novo estado nao gera colisao;
- todos os blocos continuam apoiados;
- a nova posicao e diferente da posicao antiga.

## 3. Planos manuais avaliados

| Cenario | Origem | Destino | Predicado do plano manual | Numero de acoes |
|---|---|---|---|---:|
| Situacao 1 | `S0` | `Sf4` | `plano_manual_s0_sf4/1` | 4 |
| Situacao 2 | `S0` | `S5` | `plano_manual_sit2_s0_s5/1` | 5 |
| Situacao 3 | `S0` | `S7` | `plano_manual_sit3_s0_s7/1` | 6 |

## 4. Plano manual da Situacao 1

Destino escolhido: `Sf4`.

```prolog
[
    move(d, p(3,1), p(0,1)),
    move(a, p(3,0), p(5,1)),
    move(d, p(0,1), p(2,0)),
    move(a, p(5,1), p(0,1))
]
```

A ideia do plano e retirar `d` de cima de `a` e `b`, liberar `a`, mover `d` para a base e finalmente colocar `a` sobre `c`.

Consulta de validacao:

```prolog
estado_sit1_s0(S0),
estado_sit1_sf4(Objetivo),
plano_manual_s0_sf4(Plano),
aplica_plano(S0, Plano, Final),
igual_estado(Final, Objetivo).
```

Resultado esperado:

```prolog
true.
```

## 5. Plano manual da Situacao 2

Plano de `S0` ate `S5`:

```prolog
[
    move(b, p(1,1), p(2,0)),
    move(a, p(0,1), p(2,1)),
    move(c, p(0,0), p(4,1)),
    move(a, p(2,1), p(4,2)),
    move(b, p(2,0), p(5,2))
]
```

Consulta de validacao:

```prolog
estado_sit2_s0(S0),
estado_sit2_s5(Objetivo),
plano_manual_sit2_s0_s5(Plano),
aplica_plano(S0, Plano, Final),
igual_estado(Final, Objetivo).
```

Resultado esperado:

```prolog
true.
```

## 6. Plano manual da Situacao 3

Plano de `S0` ate `S7`:

```prolog
[
    move(d, p(3,1), p(0,1)),
    move(a, p(3,0), p(5,1)),
    move(d, p(0,1), p(2,0)),
    move(a, p(5,1), p(0,1)),
    move(b, p(5,0), p(1,1)),
    move(d, p(2,0), p(3,0))
]
```

Consulta de validacao:

```prolog
estado_sit3_s0(S0),
estado_sit3_s7(Objetivo),
plano_manual_sit3_s0_s7(Plano),
aplica_plano(S0, Plano, Final),
igual_estado(Final, Objetivo).
```

Resultado esperado:

```prolog
true.
```

## 7. Testes automatizados

Comando:

```bash
swipl -q -s situacoes_2_3.pl -g run_tests -t halt
```

Saida esperada:

```text
% PL-Unit: situacao1 ............. done
% PL-Unit: situacoes_2_3 ............................ done
% All 41 tests passed
```

## 8. Comparacao entre manual e automatico

| Cenario | Plano manual validado? | O planejador pode buscar plano? | Observacao |
|---|---|---|---|
| Situacao 1: S0 ate Sf4 | Sim | Sim | O plano manual tem 4 movimentos. |
| Situacao 2: S0 ate S5 | Sim | Sim | O plano manual segue a sequencia da figura. |
| Situacao 3: S0 ate S7 | Sim | Sim | O plano manual passa por S5/S6 e finaliza movendo `d`. |

O predicado `plano/3` realiza busca recursiva com limite de profundidade. Ele pode encontrar um plano igual ao manual ou outro plano valido, pois a ordem de geracao das acoes pode produzir caminhos diferentes.

## 9. Conclusao

A representacao por coordenadas permite tratar blocos de larguras diferentes, verificar ocupacao espacial e validar movimentos. Os planos manuais foram formalizados como listas de acoes e validados por `aplica_plano/3`. Os testes automatizados garantem que os estados e transicoes principais das Situacoes 1, 2 e 3 sao coerentes com a modelagem adotada.
