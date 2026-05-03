# 02 - Estados das Situações

## 1. Convenção usada

Cada estado é uma lista de termos:

```prolog
pos(Bloco, X, Y)
```

Onde:

- `Bloco` identifica o bloco;
- `X` é o início horizontal do bloco;
- `Y` é a altura da base do bloco.

| Bloco | Largura | Altura |
|---|---:|---:|
| `a` | 1 | 1 |
| `b` | 1 | 1 |
| `c` | 2 | 1 |
| `d` | 3 | 1 |

A mesa vai da coordenada `0` até a coordenada `6`.

Os estados estão distribuídos assim:

| Situação | Arquivo |
|---|---|
| Situação 1 | `ResolucaoIA/blocos1.pl` |
| Situação 2 | `ResolucaoIA/blocos2.pl` |
| Situação 3 | `ResolucaoIA/blocos3.pl` |

O arquivo `ResolucaoIA/blocos.pl` contém a base geral do domínio: blocos, dimensões, regras espaciais, ações, planejador e testes gerais.

---

## 2. Situação 1

Arquivo:

```text
ResolucaoIA/blocos1.pl
```

A Situação 1 parte de `S0` e considera os estados finais `Sf1`, `Sf2`, `Sf3` e `Sf4`. Para o plano manual e os testes principais, foi escolhido o objetivo `Sf4`.

### S0

```prolog
estado_sit1_s0([
    pos(c,0,0),
    pos(a,3,0),
    pos(b,5,0),
    pos(d,3,1)
]).
```

Interpretação:

- `c` está na base em `[0,2)`;
- `a` está na base em `[3,4)`;
- `b` está na base em `[5,6)`;
- `d` está sobre `a` e `b`, ocupando `[3,6)` na altura `Y = 1`.

### Sf1

```prolog
estado_sit1_sf1([
    pos(d,3,0),
    pos(a,4,1),
    pos(b,5,1),
    pos(c,4,2)
]).
```

Interpretação:

- `d` está na base;
- `a` e `b` estão sobre `d`;
- `c` está sobre `a` e `b`.

### Sf2

```prolog
estado_sit1_sf2([
    pos(d,3,0),
    pos(c,3,1),
    pos(a,3,2),
    pos(b,4,2)
]).
```

Interpretação:

- `d` está na base;
- `c` está sobre `d`;
- `a` e `b` estão sobre `c`.

### Sf3

```prolog
estado_sit1_sf3([
    pos(c,0,0),
    pos(a,2,0),
    pos(b,5,0),
    pos(d,0,1)
]).
```

Interpretação:

- `c` e `a` estão na base;
- `d` está sobre `c` e `a`;
- `b` está separado na base.

### Sf4

```prolog
estado_sit1_sf4([
    pos(c,0,0),
    pos(d,2,0),
    pos(b,5,0),
    pos(a,0,1)
]).
```

Interpretação:

- `c`, `d` e `b` estão na base;
- `a` está sobre `c`.

`Sf4` foi o destino escolhido para o plano manual da Situação 1.

### Consulta auxiliar

O arquivo também define:

```prolog
estado_sit1(Rotulo, Estado)
```

Exemplos:

```prolog
estado_sit1(s0, S).
estado_sit1(sf4, S).
```

---

## 3. Situação 2

Arquivo:

```text
ResolucaoIA/blocos2.pl
```

A Situação 2 representa uma sequência de estados de `S0` até `S5`.

### S0

```prolog
estado_sit2_s0([
    pos(c,0,0),
    pos(a,0,1),
    pos(b,1,1),
    pos(d,3,0)
]).
```

Interpretação:

- `c` está na base em `[0,2)`;
- `a` e `b` estão sobre `c`;
- `d` está separado na base em `[3,6)`.

### S1

```prolog
estado_sit2_s1([
    pos(c,0,0),
    pos(a,0,1),
    pos(b,2,0),
    pos(d,3,0)
]).
```

Interpretação:

- `b` saiu de cima de `c` e foi para a base em `X = 2`;
- `a` continua sobre `c`;
- `d` continua na base.

### S2

```prolog
estado_sit2_s2([
    pos(c,0,0),
    pos(b,2,0),
    pos(a,2,1),
    pos(d,3,0)
]).
```

Interpretação:

- `a` foi colocado sobre `b`;
- `c`, `b` e `d` estão na base.

### S3

```prolog
estado_sit2_s3([
    pos(b,2,0),
    pos(a,2,1),
    pos(d,3,0),
    pos(c,4,1)
]).
```

Interpretação:

- `c` foi colocado sobre `d`, em `X = 4`;
- `a` continua sobre `b`.

### S4

```prolog
estado_sit2_s4([
    pos(b,2,0),
    pos(d,3,0),
    pos(c,4,1),
    pos(a,4,2)
]).
```

Interpretação:

- `a` foi colocado sobre `c`;
- `b` está na base em `X = 2`;
- `d` está na base e apoia `c`.

### S5

```prolog
estado_sit2_s5([
    pos(d,3,0),
    pos(c,4,1),
    pos(a,4,2),
    pos(b,5,2)
]).
```

Interpretação:

- `d` está na base;
- `c` está sobre `d`;
- `a` e `b` estão sobre `c`.

### Consulta auxiliar

O arquivo também define:

```prolog
estado_sit2(Rotulo, Estado)
```

Exemplos:

```prolog
estado_sit2(s0, S).
estado_sit2(s5, S).
```

---

## 4. Situação 3

Arquivo:

```text
ResolucaoIA/blocos3.pl
```

A Situação 3 representa uma sequência de `S0` até `S7`.

### S0

```prolog
estado_sit3_s0([
    pos(c,0,0),
    pos(a,3,0),
    pos(b,5,0),
    pos(d,3,1)
]).
```

Interpretação:

- é a mesma configuração inicial da Situação 1;
- `d` está sobre `a` e `b`;
- `c` está separado à esquerda.

### S1

```prolog
estado_sit3_s1([
    pos(c,0,0),
    pos(d,0,1),
    pos(a,3,0),
    pos(b,5,0)
]).
```

Interpretação:

- `d` foi movido para cima de `c`;
- `a` e `b` ficaram livres na base.

### S2

```prolog
estado_sit3_s2([
    pos(c,0,0),
    pos(d,0,1),
    pos(b,5,0),
    pos(a,5,1)
]).
```

Interpretação:

- `a` foi colocado sobre `b`;
- `d` continua sobre `c`.

### S3

```prolog
estado_sit3_s3([
    pos(c,0,0),
    pos(d,2,0),
    pos(b,5,0),
    pos(a,5,1)
]).
```

Interpretação:

- `d` foi movido para a base em `X = 2`;
- `a` continua sobre `b`.

### S4

```prolog
estado_sit3_s4([
    pos(c,0,0),
    pos(d,2,0),
    pos(b,5,0),
    pos(a,0,1)
]).
```

Interpretação:

- `a` foi movido para cima de `c`;
- `d` e `b` permanecem na base.

### S5

```prolog
estado_sit3_s5([
    pos(c,0,0),
    pos(d,2,0),
    pos(a,0,1),
    pos(b,1,1)
]).
```

Interpretação:

- `a` e `b` estão lado a lado sobre `c`;
- `d` está na base em `X = 2`.

### S6

```prolog
estado_sit3_s6([
    pos(c,0,0),
    pos(d,2,0),
    pos(a,0,1),
    pos(b,1,1)
]).
```

`S5` e `S6` foram representados igualmente porque aparecem com a mesma configuração no desenho do enunciado. Assim, a diferença entre eles é considerada apenas uma etapa visual/intermediária do diagrama, sem mudança nas posições representadas.

### S7

```prolog
estado_sit3_s7([
    pos(c,0,0),
    pos(d,3,0),
    pos(a,0,1),
    pos(b,1,1)
]).
```

Interpretação:

- `a` e `b` permanecem sobre `c`;
- `d` foi deslocado para a direita, ficando separado da pilha.

### Consulta auxiliar

O arquivo também define:

```prolog
estado_sit3(Rotulo, Estado)
```

Exemplos:

```prolog
estado_sit3(s0, S).
estado_sit3(s7, S).
```
