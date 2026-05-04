# Relatório - Testes e Comparação de Planos

## 1. Objetivo do relatório

Este relatório documenta a validação da solução para o Mundo dos Blocos com dimensões diferentes. A comparação principal é feita entre:

1. planos manuais descritos a partir das situações do enunciado;
2. validação dos planos por meio dos predicados Prolog;
3. geração automática de planos por `plano/3`, quando aplicável.

---

## 2. Critérios de validade

Um estado é considerado válido quando satisfaz simultaneamente:

- todos os blocos do problema estão presentes;
- todos os blocos estão dentro dos limites da mesa;
- não há colisão entre blocos;
- cada bloco está apoiado na mesa ou em outro bloco;
- blocos em altura maior que zero respeitam a regra de apoio e equilíbrio simplificado.

Um movimento é considerado válido quando:

- o bloco existe no estado atual;
- o bloco está livre;
- a nova posição está dentro da mesa;
- o novo estado não gera colisão;
- todos os blocos continuam apoiados;
- a nova posição é diferente da posição antiga.

---

## 3. Planos manuais avaliados

| Cenário | Origem | Destino | Predicado do plano manual | Número de ações |
|---|---|---|---|---:|
| Situação 1 | `S0` | `Sf4` | `plano_manual_s0_sf4/1` | 4 |
| Situação 2 | `S0` | `S5` | `plano_manual_sit2_s0_s5/1` | 5 |
| Situação 3 | `S0` | `S7` | `plano_manual_sit3_s0_s7/1` | 6 |

---

## 4. Plano manual da Situação 1

Destino escolhido: `Sf4`.

```prolog
[
    move(d, p(3,1), p(0,1)),
    move(a, p(3,0), p(5,1)),
    move(d, p(0,1), p(2,0)),
    move(a, p(5,1), p(0,1))
]
```

A ideia do plano é retirar `d` de cima de `a` e `b`, liberar `a`, mover `d` para a base e finalmente colocar `a` sobre `c`.

Consulta de validação:

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

---

## 5. Plano manual da Situação 2

Plano de `S0` até `S5`:

```prolog
[
    move(b, p(1,1), p(2,0)),
    move(a, p(0,1), p(2,1)),
    move(c, p(0,0), p(4,1)),
    move(a, p(2,1), p(4,2)),
    move(b, p(2,0), p(5,2))
]
```

Consulta de validação:

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

---

## 6. Plano manual da Situação 3

Plano de `S0` até `S7`:

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

Consulta de validação:

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

---

## 7. Testes automatizados

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

---

## 8. Comparação entre manual e automático

| Cenário | Plano manual validado? | O planejador pode buscar plano? | Observação |
|---|---|---|---|
| Situação 1: S0 até Sf4 | Sim | Sim | O plano manual tem 4 movimentos. |
| Situação 2: S0 até S5 | Sim | Sim | O plano manual segue a sequência da figura. |
| Situação 3: S0 até S7 | Sim | Sim | O plano manual passa por S5/S6 e finaliza movendo `d`. |

O predicado `plano/3` realiza busca recursiva com limite de profundidade. Ele pode encontrar um plano igual ao manual ou outro plano válido, pois a ordem de geração das ações pode produzir caminhos diferentes.

---

## 9. Como executar os testes

### 9.1. Estrutura de arquivos

A partir da pasta `ResolucaoIA`, os arquivos disponíveis são:

```text
ResolucaoIA/
├── blocos.pl
├── blocos1.pl
├── blocos2.pl
└── blocos3.pl
```

### 9.2. Verificar carregamento dos arquivos

Antes de testar lógica, o primeiro passo é verificar se o arquivo carrega sem erros:

```bash
swipl -q -s blocos1.pl
```

Se aparecer o prompt `?-`, o arquivo foi carregado com sucesso. Para sair:

```prolog
halt.
```

### 9.3. Roteiro completo de testes automatizados

Execute na seguinte ordem dentro de `ResolucaoIA`:

```bash
# Regras gerais do domínio
swipl -q -s blocos.pl -g run_tests -t halt

# Situação 1
swipl -q -s blocos1.pl -g run_tests -t halt

# Situação 2
swipl -q -s blocos2.pl -g run_tests -t halt

# Situação 3
swipl -q -s blocos3.pl -g run_tests -t halt
```

Saída esperada para cada arquivo:

```text
% PL-Unit: regras_gerais ..... done
% PL-Unit: situacaoN .............. done
% All tests passed
```

Para executar somente os testes de uma situação específica:

```bash
swipl -q -s blocos1.pl -g "run_tests(situacao1)" -t halt
swipl -q -s blocos2.pl -g "run_tests(situacao2)" -t halt
swipl -q -s blocos3.pl -g "run_tests(situacao3)" -t halt
```

### 9.4. Interpretação dos símbolos de saída

| Saída | Significado | O que fazer |
|---|---|---|
| `.` | Um teste passou | Tudo certo |
| `.....` | Vários testes passaram | Tudo certo |
| `All tests passed` | Todos passaram | Tudo certo |
| `false.` | A consulta não é verdadeira | Verificar se era esperado falhar |
| `ERROR` | Erro de sintaxe, caminho ou lógica | Ler a linha indicada |
| `failed` | Teste falhou | Ver qual teste falhou |
| `choicepoint` | Teste deixou alternativas abertas | Usar `once((...))` no teste |
| `Redefined static procedure` | Predicado duplicado | Remover duplicação |

> **Atenção:** nem todo `false` é problema. Quando se tenta mover um bloco que não está livre, gerar colisão ou deixar um bloco sem apoio, `false` é o resultado esperado.

---

## 10. Testes manuais no modo interativo

### 10.1. Situação 1

Abrir o modo interativo:

```bash
swipl -q -s blocos1.pl
```

**Ver o estado inicial:**

```prolog
estado_sit1_s0(S), mostra_estado(S).
```

Saída esperada:

```
pos(a,3,0)
pos(b,5,0)
pos(c,0,0)
pos(d,3,1)
```

Como `d` tem largura 3, ele ocupa o intervalo `[3,6)` e está sobre `a` e `b`.

**Verificar validade do estado:**

```prolog
estado_sit1_s0(S), estado_valido(S).
```

Saída esperada: `true.`

**Verificar se um bloco está livre:**

```prolog
estado_sit1_s0(S), bloco_livre(d, S).   % esperado: true.
estado_sit1_s0(S), bloco_livre(a, S).   % esperado: false.
```

**Testar uma ação individual:**

```prolog
estado_sit1_s0(S0),
acao(move(d, p(3,1), p(0,1)), S0, S1),
mostra_estado(S1).
```

**Validar o plano manual completo:**

```prolog
estado_sit1_s0(S0),
estado_sit1_sf4(Objetivo),
plano_manual_sit1_s0_sf4(Plano),
aplica_plano(S0, Plano, Final),
igual_estado(Final, Objetivo).
```

Saída esperada: `true.`

**Gerar plano automático:**

```prolog
estado_sit1_s0(S0),
estado_sit1_sf4(Objetivo),
plano(S0, Objetivo, Plano),
aplica_plano(S0, Plano, Final),
igual_estado(Final, Objetivo).
```

Saída esperada: `true.`

**Testar o plano parcialmente ordenado:**

```prolog
estado_sit1_s0(S0),
estado_sit1_sf4(Objetivo),
plano_parcial(S0, Objetivo, POP, PlanoLinear).
```

---

### 10.2. Situação 2

Abrir o modo interativo:

```bash
swipl -q -s blocos2.pl
```

**Ver estado inicial:**

```prolog
estado_sit2_s0(S), mostra_estado(S).
```

Saída esperada:

```
pos(a,0,1)
pos(b,1,1)
pos(c,0,0)
pos(d,3,0)
```

`a` e `b` estão sobre `c`; `d` está separado na base.

**Ver estado final:**

```prolog
estado_sit2_s5(S), mostra_estado(S).
```

Saída esperada:

```
pos(a,4,2)
pos(b,5,2)
pos(c,4,1)
pos(d,3,0)
```

`d` na base, `c` sobre `d`, `a` e `b` sobre `c`.

**Validar e gerar plano:**

```prolog
estado_sit2_s0(S0),
estado_sit2_s5(Objetivo),
plano(S0, Objetivo, Plano),
aplica_plano(S0, Plano, Final),
igual_estado(Final, Objetivo).
```

Saída esperada: `true.`

---

### 10.3. Situação 3

Abrir o modo interativo:

```bash
swipl -q -s blocos3.pl
```

**Ver estado inicial:**

```prolog
estado_sit3_s0(S), mostra_estado(S).
```

Saída esperada:

```
pos(a,3,0)
pos(b,5,0)
pos(c,0,0)
pos(d,3,1)
```

**Ver estado final:**

```prolog
estado_sit3_s7(S), mostra_estado(S).
```

Saída esperada:

```
pos(a,0,1)
pos(b,1,1)
pos(c,0,0)
pos(d,3,0)
```

`a` e `b` sobre `c`; `d` separado na base à direita.

**Validar plano manual:**

```prolog
estado_sit3_s0(S0),
estado_sit3_s7(Objetivo),
plano_manual_sit3_s0_s7(Plano),
aplica_plano(S0, Plano, Final),
igual_estado(Final, Objetivo).
```

Saída esperada: `true.`

**Gerar e validar plano automático:**

```prolog
estado_sit3_s0(S0),
estado_sit3_s7(Objetivo),
plano(S0, Objetivo, Plano),
aplica_plano(S0, Plano, Final),
igual_estado(Final, Objetivo).
```

Saída esperada: `true.`

---

## 11. Testes de restrições físicas

### 11.1. Movimento inválido (bloco não livre)

```prolog
estado_sit1_s0(S0),
acao(move(a, p(3,0), p(0,1)), S0, S1).
```

Saída esperada: `false.` — `a` não está livre porque `d` está sobre ele.

### 11.2. Movimento inválido (colisão)

```prolog
estado_sit1_s0(S0),
acao(move(d, p(3,1), p(0,0)), S0, S1).
```

Saída esperada: `false.` — `d` em `X=0, Y=0` ocuparia `[0,3)`, mas `c` já ocupa `[0,2)`.

### 11.3. Movimento inválido (apoio ausente)

```prolog
estado_sit1_s0(S0),
acao(move(d, p(3,1), p(2,2)), S0, S1).
```

Saída esperada: `false.` — `d` em `Y=2` não teria apoio imediatamente abaixo.

---

## 12. Altura máxima automática

```prolog
altura_maxima(H).
```

Saída esperada: `H = 4.`

Como todos os blocos têm altura 1 (a, b, c, d), a altura máxima calculada automaticamente é `1 + 1 + 1 + 1 = 4`. O valor não é fixo no código: ele é computado a partir das dimensões declaradas.

---

## 13. Conclusão

A representação por coordenadas permite tratar blocos de larguras diferentes, verificar ocupação espacial e validar movimentos. Os planos manuais foram formalizados como listas de ações e validados por `aplica_plano/3`. Os testes automatizados garantem que os estados e transições principais das Situações 1, 2 e 3 são coerentes com a modelagem adotada.

Os testes foram organizados em quatro grupos. O primeiro grupo valida as regras gerais do domínio — dimensões, limites da mesa, colisão, apoio, centro geométrico e validade de estados. Os demais grupos validam as Situações 1, 2 e 3 do enunciado, verificando a validade dos estados, a aplicabilidade das transições manuais, a execução dos planos manuais e a geração automática de planos por regressão.

Na Situação 1, os testes mostram que é possível sair de `S0` e chegar a `Sf4`. Na Situação 2, os testes validam a sequência `S0 → S1 → S2 → S3 → S4 → S5`. Na Situação 3, os testes validam a sequência `S0 → S1 → S2 → S3 → S4 → S5/S6 → S7`. Em todos os casos, os movimentos respeitam as restrições de bloco livre, ausência de colisão, limites da mesa e apoio por centro geométrico.
