# Trabalho IA - Mundo dos Blocos com Dimensoes Diferentes

Este repositorio documenta e implementa um planejador em Prolog para o Mundo dos Blocos com blocos de larguras diferentes.

O problema foi modelado como busca entre estados. Cada estado representa a posicao espacial dos blocos, e cada acao `move(B, Pi, Pj)` transforma um estado em outro.

## Objetivo

Construir uma representacao de conhecimento capaz de lidar com:

- blocos de dimensoes diferentes;
- espacos horizontais e verticais;
- verificacao de colisao;
- verificacao de apoio;
- verificacao de bloco livre;
- validacao de movimento;
- geracao de planos por meio do predicado `plano/3`.

## Estrutura do projeto

```text
TrabalhoIA_MundoBlocos/
├── README.md
├── RELATORIO.md
├── blocos.pl
├── situacoes_2_3.pl
├── teste.pl
└── docs/
    ├── 01-representacao-conhecimento.md
    ├── 02-estados-situacoes.md
    ├── 03-planos-manuais.md
    ├── 04-planejador.md
    ├── 05-testes-resultados.md
    └── 06-como-executar.md
```

## Arquivos principais

| Arquivo | Funcao |
|---|---|
| `blocos.pl` | Contem a base geral do dominio: blocos, dimensoes, ocupacao, colisao, apoio, bloco livre, movimento e `plano/3`. |
| `situacoes_2_3.pl` | Contem os estados formais das Situacoes 2 e 3, os planos manuais e os testes adicionais. |
| `RELATORIO.md` | Relatorio comparando planos manuais com os resultados esperados dos testes e do planejador. |
| `docs/01-representacao-conhecimento.md` | Explica a representacao escolhida. |
| `docs/02-estados-situacoes.md` | Lista os estados representados em Prolog. |
| `docs/03-planos-manuais.md` | Explica os planos manuais. |
| `docs/04-planejador.md` | Explica o planejador automatico. |
| `docs/05-testes-resultados.md` | Mostra como executar testes e quais saidas esperar. |
| `docs/06-como-executar.md` | Guia de instalacao e execucao. |

## Requisitos

- Linux Ubuntu 24.04 LTS ou similar.
- SWI-Prolog instalado.

Instalacao:

```bash
sudo apt update
sudo apt install swi-prolog
```

Verificacao:

```bash
swipl --version
```

## Como executar

Entrar na pasta do projeto:

```bash
cd TrabalhoIA_MundoBlocos
```

Executar os testes da base principal:

```bash
swipl -q -s blocos.pl -g run_tests -t halt
```

Executar os testes das Situacoes 2 e 3:

```bash
swipl -q -s situacoes_2_3.pl -g run_tests -t halt
```

Abrir o modo interativo:

```bash
swipl -q -s situacoes_2_3.pl
```

Exemplo de consulta:

```prolog
estado_sit3_s7(S), mostra_estado(S).
```

Sair do Prolog:

```prolog
halt.
```

## Consulta importante

Testar o plano manual da Situacao 3:

```prolog
once((
    estado_sit3_s0(S0),
    estado_sit3_s7(Objetivo),
    plano_manual_sit3_s0_s7(Plano),
    aplica_plano(S0, Plano, Final),
    igual_estado(Final, Objetivo)
)).
```

Saida esperada:

```prolog
true.
```

## Observacao sobre o nome da pasta

O enunciado solicita uma pasta para a entrega no GitHub. Neste projeto foi usado o nome `TrabalhoIA_MundoBlocos`, pois ele descreve diretamente o dominio do problema.
