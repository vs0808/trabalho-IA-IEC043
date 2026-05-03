# 05 - Testes e Resultados Esperados

## 1. Organização dos testes

| Arquivo | Conteúdo testado |
|---|---|
| `ResolucaoIA/blocos.pl` | base principal, predicados gerais, regras espaciais e planejador |
| `ResolucaoIA/blocos1.pl` | Situação 1, plano manual, `plano/3`, `planos/3` e `plano_parcial/4` |
| `ResolucaoIA/blocos2.pl` | Situação 2, plano manual, `plano/3`, `planos/3` e `plano_parcial/4` |
| `ResolucaoIA/blocos3.pl` | Situação 3, plano manual, `plano/3`, `planos/3` e `plano_parcial/4` |

`blocos1.pl`, `blocos2.pl` e `blocos3.pl` carregam `blocos.pl`. Por isso, ao executar os testes das situações, os testes gerais também podem ser carregados.

---

## 2. Testar a Situação 1

Pela raiz do projeto:

```bash
swipl -q -s "ResolucaoIA/blocos1.pl" -g run_tests -t halt
```

Ou, dentro da pasta `ResolucaoIA`:

```bash
swipl -q -s blocos1.pl -g run_tests -t halt
```

Saída esperada aproximada:

```text
% PL-Unit: regras_gerais .....
% PL-Unit: situacao1 ............
% All tests passed
```

Para rodar apenas a unidade da Situação 1:

```bash
swipl -q -s "ResolucaoIA/blocos1.pl" -g "run_tests(situacao1)" -t halt
```

---

## 3. Testar a Situação 2

Pela raiz do projeto:

```bash
swipl -q -s "ResolucaoIA/blocos2.pl" -g run_tests -t halt
```

Ou, dentro da pasta `ResolucaoIA`:

```bash
swipl -q -s blocos2.pl -g run_tests -t halt
```

Saída esperada aproximada:

```text
% PL-Unit: regras_gerais .....
% PL-Unit: situacao2 ..............
% All tests passed
```

Para rodar apenas a unidade da Situação 2:

```bash
swipl -q -s "ResolucaoIA/blocos2.pl" -g "run_tests(situacao2)" -t halt
```

---

## 4. Testar a Situação 3

Pela raiz do projeto:

```bash
swipl -q -s "ResolucaoIA/blocos3.pl" -g run_tests -t halt
```

Ou, dentro da pasta `ResolucaoIA`:

```bash
swipl -q -s blocos3.pl -g run_tests -t halt
```

Saída esperada aproximada:

```text
% PL-Unit: regras_gerais .....
% PL-Unit: situacao3 ..................
% All tests passed
```

Para rodar apenas a unidade da Situação 3:

```bash
swipl -q -s "ResolucaoIA/blocos3.pl" -g "run_tests(situacao3)" -t halt
```

---

## 5. Observação sobre warnings de redefinição

Se aparecerem avisos como:

```text
Redefined static procedure mostra_estado/1
Redefined static procedure mostra_plano/1
```

isso significa que esses predicados foram definidos em mais de um arquivo.

A correção adotada na versão refatorada é manter:

```prolog
mostra_estado/1
mostra_plano/1
```

somente em:

```text
ResolucaoIA/blocos.pl
```

e removê-los de:

```text
ResolucaoIA/blocos1.pl
ResolucaoIA/blocos2.pl
ResolucaoIA/blocos3.pl
```

Esses avisos não significam que os testes falharam, mas indicam duplicação desnecessária.

---

## 6. Consultar estado da Situação 1

```bash
swipl -q -s "ResolucaoIA/blocos1.pl"
```

Consulta:

```prolog
estado_sit1_sf4(S), mostra_estado(S).
```

Saída esperada:

```prolog
pos(a,0,1)
pos(b,5,0)
pos(c,0,0)
pos(d,2,0)
```

---

## 7. Consultar estado da Situação 2

```bash
swipl -q -s "ResolucaoIA/blocos2.pl"
```

Consulta:

```prolog
estado_sit2_s5(S), mostra_estado(S).
```

Saída esperada:

```prolog
pos(a,4,2)
pos(b,5,2)
pos(c,4,1)
pos(d,3,0)
```

---

## 8. Consultar estado da Situação 3

```bash
swipl -q -s "ResolucaoIA/blocos3.pl"
```

Consulta:

```prolog
estado_sit3_s7(S), mostra_estado(S).
```

Saída esperada:

```prolog
pos(a,0,1)
pos(b,1,1)
pos(c,0,0)
pos(d,3,0)
```

---

## 9. Validar plano manual da Situação 1

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

## 10. Validar plano manual da Situação 2

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

## 11. Validar plano manual da Situação 3

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

## 12. Gerar plano automático com `plano/3`

### Situação 1

```prolog
estado_sit1_s0(S0),
estado_sit1_sf4(Objetivo),
plano(S0, Objetivo, Plano).
```

Para validar:

```prolog
estado_sit1_s0(S0),
estado_sit1_sf4(Objetivo),
plano(S0, Objetivo, Plano),
aplica_plano(S0, Plano, Final),
igual_estado(Final, Objetivo).
```

Resultado esperado:

```prolog
true.
```

### Situação 2

```prolog
estado_sit2_s0(S0),
estado_sit2_s5(Objetivo),
plano(S0, Objetivo, Plano).
```

Validação:

```prolog
estado_sit2_s0(S0),
estado_sit2_s5(Objetivo),
plano(S0, Objetivo, Plano),
aplica_plano(S0, Plano, Final),
igual_estado(Final, Objetivo).
```

Resultado esperado:

```prolog
true.
```

### Situação 3

```prolog
estado_sit3_s0(S0),
estado_sit3_s7(Objetivo),
plano(S0, Objetivo, Plano).
```

Validação:

```prolog
estado_sit3_s0(S0),
estado_sit3_s7(Objetivo),
plano(S0, Objetivo, Plano),
aplica_plano(S0, Plano, Final),
igual_estado(Final, Objetivo).
```

Resultado esperado:

```prolog
true.
```

---

## 13. Gerar plano automático com `planos/3`

`planos/3` é um alias de `plano/3`.

Exemplo para a Situação 3:

```prolog
estado_sit3_s0(S0),
estado_sit3_s7(Objetivo),
planos(S0, Objetivo, Plano).
```

Validação:

```prolog
estado_sit3_s0(S0),
estado_sit3_s7(Objetivo),
planos(S0, Objetivo, Plano),
aplica_plano(S0, Plano, Final),
igual_estado(Final, Objetivo).
```

Resultado esperado:

```prolog
true.
```

---

## 14. Gerar plano parcialmente ordenado

Exemplo para a Situação 3:

```prolog
estado_sit3_s0(S0),
estado_sit3_s7(Objetivo),
plano_parcial(S0, Objetivo, POP, PlanoLinear).
```

A saída esperada terá a forma:

```prolog
POP = pop(Passos, Ordem),
PlanoLinear = [...]
```

Onde `Passos` contém:

```prolog
passo(0, inicio)
passo(1, ...)
...
passo(N, objetivo)
```

e `Ordem` contém relações:

```prolog
antes(0, 1)
antes(1, 2)
...
antes(N-1, N)
```

---

## 15. Mostrar plano manual da Situação 3

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

---

## 16. Observação sobre `once/1`

Os testes positivos usam:

```prolog
once(( ... ))
```

Isso evita avisos como:

```text
Test succeeded with choicepoint
```

Essa escolha afeta apenas os testes. A busca do planejador continua podendo explorar alternativas.
