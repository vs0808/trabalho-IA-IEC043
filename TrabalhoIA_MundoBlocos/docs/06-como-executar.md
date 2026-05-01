# 06 - Como Executar o Projeto

## 1. Instalar o SWI-Prolog

No Ubuntu 24.04 LTS:

```bash
sudo apt update
sudo apt install swi-prolog
```

Verificar a instalacao:

```bash
swipl --version
```

## 2. Entrar na pasta do projeto

```bash
cd /home/viniciussousa/Documentos/IA-EC034/TrabalhoIA_1/TrabalhoIA_MundoBlocos
```

## 3. Executar os testes

Base principal:

```bash
swipl -q -s blocos.pl -g run_tests -t halt
```

Situacoes 2 e 3:

```bash
swipl -q -s situacoes_2_3.pl -g run_tests -t halt
```

## 4. Usar o modo interativo

```bash
swipl -q -s situacoes_2_3.pl
```

O prompt sera:

```prolog
?-
```

Exemplo de consulta:

```prolog
estado_sit2_s5(S), mostra_estado(S).
```

## 5. Erro comum: digitar `move` sozinho

Errado:

```prolog
move(d, p(3,1), p(0,1)).
```

Certo:

```prolog
estado_sit3_s0(S0),
acao(move(d, p(3,1), p(0,1)), S0, S1).
```

`move(...)` e apenas um termo que representa uma ação. Quem executa a ação é `acao/3`.

## 6. Erro comum: esquecer virgulas

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

Em Prolog, a virgula significa "e depois". O ponto finaliza a consulta.

## 7. Sair do Prolog

```prolog
halt.
```
