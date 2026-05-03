# 06 - Como Executar o Projeto

## 1. Instalar o SWI-Prolog

No Ubuntu 24.04 LTS:

```bash
sudo apt update
sudo apt install swi-prolog
```

Verifique:

```bash
swipl --version
```

---

## 2. Estrutura esperada

```text
TrabalhoIA_MundoBlocos/
├── ComparacaoManualvsIA/
├── docs/
│   ├── 01-representacao-conhecimento.md
│   ├── 02-estados-situacoes.md
│   ├── 03-planos-manuais.md
│   ├── 04-planejador.md
│   ├── 05-testes-resultados.md
│   └── 06-como-executar.md
├── ResolucaoIA/
│   ├── blocos.pl
│   ├── blocos1.pl
│   ├── blocos2.pl
│   └── blocos3.pl
├── ResolucaoManual/
├── README.md
├── Relatorio.md
└── Trabalho1-IA.pdf
```

Observação: recomenda-se usar nomes sem acento em pastas e arquivos, como `ResolucaoIA`, para evitar problemas em comandos de terminal.

---

## 3. Entrar na pasta do projeto

Exemplo:

```bash
cd /home/viniciussousa/Documentos/IA-EC034/TrabalhoIA_1/TrabalhoIA_MundoBlocos
```

---

## 4. Executar testes pela raiz

Situação 1:

```bash
swipl -q -s "ResolucaoIA/blocos1.pl" -g run_tests -t halt
```

Situação 2:

```bash
swipl -q -s "ResolucaoIA/blocos2.pl" -g run_tests -t halt
```

Situação 3:

```bash
swipl -q -s "ResolucaoIA/blocos3.pl" -g run_tests -t halt
```

Também é possível carregar apenas a base geral:

```bash
swipl -q -s "ResolucaoIA/blocos.pl" -g run_tests -t halt
```

Esse comando executa os testes gerais definidos em `blocos.pl`.

---

## 5. Executar testes dentro da pasta `ResolucaoIA`

Entre na pasta:

```bash
cd ResolucaoIA
```

Depois execute:

```bash
swipl -q -s blocos1.pl -g run_tests -t halt
swipl -q -s blocos2.pl -g run_tests -t halt
swipl -q -s blocos3.pl -g run_tests -t halt
```

Também funciona:

```bash
swipl -q -l blocos1.pl -t run_tests
swipl -q -l blocos2.pl -t run_tests
swipl -q -l blocos3.pl -t run_tests
```

---

## 6. Rodar somente uma unidade de teste

Situação 1:

```bash
swipl -q -s "ResolucaoIA/blocos1.pl" -g "run_tests(situacao1)" -t halt
```

Situação 2:

```bash
swipl -q -s "ResolucaoIA/blocos2.pl" -g "run_tests(situacao2)" -t halt
```

Situação 3:

```bash
swipl -q -s "ResolucaoIA/blocos3.pl" -g "run_tests(situacao3)" -t halt
```

Regras gerais:

```bash
swipl -q -s "ResolucaoIA/blocos.pl" -g "run_tests(regras_gerais)" -t halt
```

---

## 7. Usar modo interativo

Situação 1:

```bash
swipl -q -s "ResolucaoIA/blocos1.pl"
```

Consulta:

```prolog
estado_sit1_sf4(S), mostra_estado(S).
```

Situação 2:

```bash
swipl -q -s "ResolucaoIA/blocos2.pl"
```

Consulta:

```prolog
estado_sit2_s5(S), mostra_estado(S).
```

Situação 3:

```bash
swipl -q -s "ResolucaoIA/blocos3.pl"
```

Consulta:

```prolog
estado_sit3_s7(S), mostra_estado(S).
```

---

## 8. Validar plano manual

Situação 1:

```prolog
once((
    estado_sit1_s0(S0),
    estado_sit1_sf4(Objetivo),
    plano_manual_sit1_s0_sf4(Plano),
    aplica_plano(S0, Plano, Final),
    igual_estado(Final, Objetivo)
)).
```

Situação 2:

```prolog
once((
    estado_sit2_s0(S0),
    estado_sit2_s5(Objetivo),
    plano_manual_sit2_s0_s5(Plano),
    aplica_plano(S0, Plano, Final),
    igual_estado(Final, Objetivo)
)).
```

Situação 3:

```prolog
once((
    estado_sit3_s0(S0),
    estado_sit3_s7(Objetivo),
    plano_manual_sit3_s0_s7(Plano),
    aplica_plano(S0, Plano, Final),
    igual_estado(Final, Objetivo)
)).
```

Resultado esperado nos três casos:

```prolog
true.
```

---

## 9. Gerar plano automático com `plano/3`

Abra a Situação 3:

```bash
swipl -q -s "ResolucaoIA/blocos3.pl"
```

Consulta:

```prolog
estado_sit3_s0(S0),
estado_sit3_s7(Objetivo),
plano(S0, Objetivo, Plano).
```

O plano retornado pode ser igual ou diferente do plano manual, desde que seja válido.

Para validar o plano gerado:

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

## 10. Gerar plano automático com `planos/3`

`planos/3` é um alias de `plano/3`.

Exemplo:

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

## 11. Gerar plano parcialmente ordenado

Exemplo:

```prolog
estado_sit3_s0(S0),
estado_sit3_s7(Objetivo),
plano_parcial(S0, Objetivo, POP, PlanoLinear).
```

A saída tem a forma:

```prolog
POP = pop(Passos, Ordem),
PlanoLinear = [...]
```

`Passos` lista o início, as ações e o objetivo.

`Ordem` lista as relações de precedência:

```prolog
antes(0,1)
antes(1,2)
...
```

---

## 12. Erro comum: digitar `move` sozinho

Errado:

```prolog
move(d, p(3,1), p(0,1)).
```

Certo:

```prolog
estado_sit3_s0(S0),
acao(move(d, p(3,1), p(0,1)), S0, S1).
```

`move(...)` é apenas um termo. Quem executa a ação é `acao/3`.

---

## 13. Erro comum: esquecer vírgulas

Errado:

```prolog
estado_sit3_s0(S0)
estado_sit3_s7(G)
plano(S0, G, P).
```

Certo:

```prolog
estado_sit3_s0(S0),
estado_sit3_s7(G),
plano(S0, G, P).
```

---

## 14. Caminhos com acento

Se a pasta estiver chamada `ResoluçãoIA`, use aspas:

```bash
swipl -q -s "ResoluçãoIA/blocos.pl" -g run_tests -t halt
```

Recomendação:

```bash
mv "ResoluçãoIA" ResolucaoIA
```

---

## 15. Warnings de redefinição

Se aparecerem mensagens como:

```text
Redefined static procedure mostra_estado/1
Redefined static procedure mostra_plano/1
```

significa que esses predicados foram definidos em mais de um arquivo.

Na versão corrigida, eles devem ficar apenas em:

```text
ResolucaoIA/blocos.pl
```

Remova definições duplicadas de:

```text
ResolucaoIA/blocos1.pl
ResolucaoIA/blocos2.pl
ResolucaoIA/blocos3.pl
```

---

## 16. Sair do Prolog

```prolog
halt.
```
