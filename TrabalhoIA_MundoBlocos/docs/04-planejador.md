# 04 - Planejador em Prolog

## 1. Ideia geral

A lógica do planejador está em:

```text
ResolucaoIA/blocos.pl
```

Na versão refatorada, o planejador automático foi alterado para seguir uma lógica de **regressão de objetivos**.

Em vez de partir do estado inicial e avançar até o objetivo, a busca parte do objetivo e procura estados predecessores até encontrar o estado inicial.

Representação conceitual:

```text
Objetivo -> predecessor -> predecessor -> ... -> Estado inicial
```

Ao final, as ações encontradas na regressão são invertidas para formar o plano executável:

```text
Estado inicial -> ação 1 -> ação 2 -> ... -> Objetivo
```

---

## 2. Ação

A ação é representada por:

```prolog
move(Bloco, p(X0,Y0), p(X,Y))
```

O predicado que aplica uma ação é:

```prolog
acao(Acao, Estado, NovoEstado)
```

Exemplo:

```prolog
acao(move(d, p(3,1), p(0,1)), EstadoAtual, NovoEstado).
```

---

## 3. Condições para mover

Para uma ação ser válida:

1. o bloco deve estar no estado;
2. o bloco deve estar livre;
3. a nova posição horizontal deve estar dentro da mesa;
4. a nova altura deve ser candidata;
5. o movimento não pode manter o bloco na mesma posição;
6. o novo estado deve ser válido.

A regra usa `select/3` para retirar a posição antiga do bloco, gera uma posição candidata e valida o estado resultante.

A execução real é feita por:

```prolog
acao/3
```

A explicação documental das pré-condições é feita por:

```prolog
precondicoes_move/3
```

---

## 4. Aplicação de plano

```prolog
aplica_plano(Estado, [], Estado).

aplica_plano(Estado, [Acao|Resto], Final) :-
    acao(Acao, Estado, Proximo),
    aplica_plano(Proximo, Resto, Final).
```

A primeira regra é o caso base.

A segunda aplica a primeira ação da lista e continua recursivamente com o próximo estado.

Esse predicado é usado tanto para validar planos manuais quanto planos gerados automaticamente.

---

## 5. Interface principal do planejador

O planejador é chamado por:

```prolog
plano(Inicio, Objetivo, Plano)
```

A versão refatorada também adiciona:

```prolog
planos(Inicio, Objetivo, Plano)
```

`planos/3` é um alias de `plano/3`, criado para facilitar consultas e testes quando se deseja usar o nome no plural.

---

## 6. Planejamento por regressão

O núcleo do planejador por regressão trabalha de trás para frente.

A ideia é:

1. começar no estado objetivo;
2. procurar uma ação que poderia ter produzido esse estado;
3. obter um estado predecessor;
4. repetir o processo até chegar ao estado inicial.

A estrutura geral é:

```prolog
plano(Inicio, Objetivo, Plano) :-
    normaliza_estado(Inicio, I),
    normaliza_estado(Objetivo, G),
    max_profundidade(Max),
    between(0, Max, Limite),
    regressao_limite(I, G, [G], Limite, PlanoReverso),
    reverse(PlanoReverso, Plano),
    !.
```

A busca usa limite crescente de profundidade, o que evita uma busca infinita.

---

## 7. Predicado de regressão com limite

O caso base ocorre quando o estado corrente da regressão já é igual ao estado inicial:

```prolog
regressao_limite(Inicio, EstadoAtual, _Visitados, _Limite, []) :-
    igual_estado(Inicio, EstadoAtual).
```

O caso recursivo procura um predecessor:

```prolog
regressao_limite(Inicio, EstadoAtual, Visitados, Limite, [Acao|PlanoReverso]) :-
    Limite > 0,
    predecessor_por_regressao(EstadoAnterior, Acao, EstadoAtual),
    \+ memberchk(EstadoAnterior, Visitados),
    Limite1 is Limite - 1,
    regressao_limite(Inicio, EstadoAnterior, [EstadoAnterior|Visitados], Limite1, PlanoReverso).
```

A lista `Visitados` evita ciclos durante a regressão.

---

## 8. Predecessor por regressão

O predicado:

```prolog
predecessor_por_regressao(EstadoAnterior, Acao, EstadoAtual)
```

procura um estado anterior que, ao executar `Acao`, gere o estado atual.

A ideia conceitual é:

```prolog
acao(Acao, EstadoAnterior, EstadoAtual)
```

Ou seja, em vez de procurar sucessores a partir do início, o planejador pergunta:

> Que estado anterior poderia ter produzido este estado atual?

Esse predicado reaproveita a própria semântica de `acao/3`, garantindo que as ações regressivas sejam ações válidas do domínio.

---

## 9. Plano parcialmente ordenado

A refatoração também adiciona uma representação de plano parcialmente ordenado.

O predicado principal é:

```prolog
plano_parcial(Inicio, Objetivo, POP, PlanoLinear)
```

Ele retorna:

- `PlanoLinear`: uma lista executável de ações;
- `POP`: uma estrutura de plano parcialmente ordenado.

A estrutura usada é:

```prolog
pop(Passos, Ordem)
```

Os passos são representados por:

```prolog
passo(Numero, Acao)
```

Exemplo:

```prolog
passo(0, inicio)
passo(1, move(d, p(3,1), p(0,1)))
passo(2, move(a, p(3,0), p(5,1)))
passo(3, objetivo)
```

As restrições de ordem são representadas por:

```prolog
antes(I, J)
```

Exemplo:

```prolog
antes(0, 1)
antes(1, 2)
antes(2, 3)
```

No estágio atual do projeto, o plano parcialmente ordenado registra as precedências entre os passos gerados pela regressão. Isso mantém uma estrutura compatível com a ideia de partial ordering e permite futuras extensões, como comparação entre planos, análise de independência entre ações e identificação de ameaças.

---

## 10. Normalização de estados

Como estados são listas, a ordem dos termos pode variar.

Por isso existem:

```prolog
normaliza_estado/2
igual_estado/2
```

Assim, listas com os mesmos blocos nas mesmas posições são consideradas iguais, mesmo que estejam em ordem diferente.

Esse recurso é usado tanto pela aplicação dos planos quanto pela regressão.

---

## 11. Relação com os arquivos das situações

Os arquivos das situações carregam `blocos.pl` com:

```prolog
:- ensure_loaded('blocos.pl').
```

Assim:

```text
ResolucaoIA/blocos1.pl
ResolucaoIA/blocos2.pl
ResolucaoIA/blocos3.pl
```

reutilizam:

```prolog
acao/3
estado_valido/1
aplica_plano/3
igual_estado/2
plano/3
planos/3
plano_parcial/4
```

Os arquivos das situações ficam responsáveis apenas por:

- estados específicos;
- planos manuais;
- transições manuais;
- testes específicos.

---

## 12. Impacto da refatoração do planejador

A refatoração altera o sentido da busca:

| Antes | Depois |
|---|---|
| Busca progressiva no espaço de estados | Regressão a partir do objetivo |
| `Estado inicial -> Objetivo` | `Objetivo -> Estado inicial`, depois inverte o plano |
| Planejador linear simples | Planejador com estrutura `pop(Passos, Ordem)` |
| Altura máxima fixa | Altura máxima calculada pela soma das alturas |

Essa mudança aproxima o código do critério do trabalho, que pede um planejador baseado em regressão de objetivos com ordenação parcial.
