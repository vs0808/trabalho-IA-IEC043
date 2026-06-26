# Trabalho IA - Mundo dos Blocos com Dimensões Diferentes

> **Observação:** Este README foi reconstruído a partir do conteúdo fornecido na conversa. Caso alguma parte tenha sido perdida devido ao limite de caracteres da plataforma, basta enviá-la posteriormente para complementar este arquivo.

## Descrição

Este repositório documenta e implementa um planejador em Prolog para o clássico problema do **Mundo dos Blocos**, adaptado para um cenário em que os blocos possuem diferentes larguras e alturas.

O planejador utiliza **Goal Regression Planning** com **Partial Ordering**, considerando restrições geométricas, colisões e equilíbrio dos blocos.

## Objetivos

- Gerenciar blocos com diferentes dimensões.
- Modelar o ambiente como um grid bidimensional.
- Evitar colisões e sobreposições.
- Validar regras de apoio e equilíbrio.
- Gerar planos automaticamente.

## Estrutura do Projeto

```text
TrabalhoIA_MundoBlocos/
├── ComparacaoManualvsIA/
├── docs/
├── ResolucaoIA/
│   ├── blocos.pl
│   ├── blocos1.pl
│   ├── blocos2.pl
│   └── blocos3.pl
├── ResolucaoManual/
├── README.md
├── RELATORIO.md
└── trabalho1-IA.pdf
```

## Requisitos

Instale o SWI-Prolog:

```bash
sudo apt update
sudo apt install swi-prolog
```

Verifique:

```bash
swipl --version
```

## Executando os testes

### Regras gerais

```bash
swipl -q -g run_tests -t halt ResolucaoIA/blocos.pl
```

### Situação 1

```bash
swipl -q -g run_tests -t halt ResolucaoIA/blocos1.pl
```

### Situação 2

```bash
swipl -q -g run_tests -t halt ResolucaoIA/blocos2.pl
```

### Situação 3

```bash
swipl -q -g run_tests -t halt ResolucaoIA/blocos3.pl
```

## Execução interativa

```bash
cd ResolucaoIA/
swipl
```

Situação 1:

```bash
swipl -q -s "blocos1.pl"
```

Consulta:

```prolog
estado_sit1_sf4(S), mostra_estado(S).
```

Saída esperada:

pos(a,0,1)
pos(b,5,0)
pos(c,0,0)
pos(d,2,0)
S = [pos(c, 0, 0), pos(d, 2, 0), pos(b, 5, 0), pos(a, 0, 1)].

Situação 2:

```bash
swipl -q -s "blocos2.pl"
```

Consulta:

```prolog
estado_sit2_s5(S), mostra_estado(S).
```

Saída esperada:

pos(a,4,2)
pos(b,5,2)
pos(c,4,1)
pos(d,3,0)
S = [pos(d, 3, 0), pos(c, 4, 1), pos(a, 4, 2), pos(b, 5, 2)].

Situação 3:

```bash
swipl -q -s "blocos3.pl"
```

Consulta:

```prolog
estado_sit3_s7(S), mostra_estado(S).
```

Saída esperada:

pos(a,0,1)
pos(b,1,1)
pos(c,0,0)
pos(d,3,0)
S = [pos(c, 0, 0), pos(d, 3, 0), pos(a, 0, 1), pos(b, 1, 1)].

Carregando uma situação:

```prolog
?- consult('blocos1.pl')
```

### Validar plano manual

```prolog
?- estado_sit1_s0(S0),
   estado_sit1_sf4(Objetivo),
   plano_manual_sit1_s0_sf4(Plano),
   aplica_plano(S0, Plano, Final),
   igual_estado(Final, Objetivo).
```

### Executar o planejador

```prolog
?- estado_sit1_s0(S0),
   estado_sit1_sf4(Objetivo),
   plano(S0, Objetivo, PlanoGerado).
```

### Plano parcial (POP)

```prolog
?- estado_sit1_s0(S0),
   estado_sit1_sf4(Objetivo),
   plano_parcial(S0, Objetivo, pop(Passos, Ordem), PlanoLinear).
```

### Visualizar um estado

```prolog
?- consult('blocos3.pl').
?- estado_sit3_s7(S), mostra_estado(S).
```

Encerrar:

```prolog
?- halt.
```

Em docs/06-como-executar.md também temos uma documentação de outros testes.
