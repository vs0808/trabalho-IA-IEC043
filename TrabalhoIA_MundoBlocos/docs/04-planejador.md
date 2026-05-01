# 04 - Planejador em Prolog

## 1. Ideia geral

O problema foi modelado como busca em grafo:

- cada estado é um nó;
- cada ação `move/3` e uma aresta;
- o plano é um caminho entre o estado inicial e o estado objetivo.

## 2. Ação

A ação é representada por:

```prolog
move(Bloco, p(X0,Y0), p(X,Y))
```

O predicado que aplica uma ação é:

```prolog
acao(Acao, Estado, NovoEstado)
```

## 3. Condições para mover

Para uma ação ser valida:

1. o bloco deve estar no estado;
2. o bloco deve estar livre;
3. a nova coordenada deve estar dentro da mesa;
4. o movimento não pode deixar o bloco na mesma posição;
5. o novo estado deve ser válido.

Essas condições impedem movimentos impossíveis, como mover um bloco preso embaixo de outro, colocar um bloco fora da mesa ou criar sobreposição.

## 4. Aplicação de plano manual

```prolog
aplica_plano(Estado, [], Estado).

aplica_plano(Estado, [Acao|Resto], Final) :-
    acao(Acao, Estado, Proximo),
    aplica_plano(Proximo, Resto, Final).
```

A primeira regra diz que, se não ha mais ações, o estado final e o próprio estado atual.

A segunda regra aplica a primeira ação, gera um novo estado e continua recursivamente.

## 5. Planejador automático

O planejador e chamado por:

```prolog
plano(Inicio, Objetivo, Plano)
```

Ele normaliza os estados e tenta encontrar um plano com profundidade crescente.

## 6. Busca com limite

A busca usa limite de profundidade para evitar caminhos infinitos.

Ideia:

```text
se EstadoAtual = Objetivo:
    Plano = []
senao:
    escolha uma acao valida
    gere ProximoEstado
    evite estados ja visitados
    continue buscando ate o objetivo
```

## 7. Evitando repetição de estados

O predicado recebe uma lista de estados visitados:

```prolog
plano_limite(Estado, Objetivo, Visitados, Limite, Plano)
```

Antes de continuar, ele verifica se o próximo estado ainda não foi visitado:

```prolog
\+ memberchk(Proximo, Visitados)
```

Isso evita ciclos como:

```text
mover d para a esquerda
mover d para a direita
mover d para a esquerda
...
```

## 8. Normalização de estados

Como estados são listas, a ordem dos termos poderia variar.

Estes estados representam a mesma configuração:

```prolog
[pos(a,0,0), pos(b,1,0)]
[pos(b,1,0), pos(a,0,0)]
```

Por isso foi criado:

```prolog
normaliza_estado/2
igual_estado/2
```

Isso permite comparar configurações independentemente da ordem da lista.
