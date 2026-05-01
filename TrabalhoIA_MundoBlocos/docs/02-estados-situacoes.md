# 02 - Estados das Situações

## 1. Convenção usada

Cada estado é uma lista de termos:

```prolog
pos(Bloco, X, Y)
```

Onde:

- `X` e o inicio horizontal do bloco;
- `Y` e a altura da base do bloco.

As larguras são:

| Bloco | Largura | Altura |
|---|---:|---:|
| `a` | 1 | 1 |
| `b` | 1 | 1 |
| `c` | 2 | 1 |
| `d` | 3 | 1 |

## 2. Situação 1

### S0

```prolog
estado_sit1_s0([
    pos(c,0,0),
    pos(a,3,0),
    pos(b,5,0),
    pos(d,3,1)
]).
```

### Sf4

```prolog
estado_sit1_sf4([
    pos(c,0,0),
    pos(d,2,0),
    pos(b,5,0),
    pos(a,0,1)
]).
```

O estado `Sf4` foi usado como destino escolhido para o plano manual da Situação 1.

## 3. Situação 2

### S0

```prolog
estado_sit2_s0([
    pos(c,0,0),
    pos(a,0,1),
    pos(b,1,1),
    pos(d,3,0)
]).
```

### S1

```prolog
estado_sit2_s1([
    pos(c,0,0),
    pos(a,0,1),
    pos(b,2,0),
    pos(d,3,0)
]).
```

### S2

```prolog
estado_sit2_s2([
    pos(c,0,0),
    pos(b,2,0),
    pos(a,2,1),
    pos(d,3,0)
]).
```

### S3

```prolog
estado_sit2_s3([
    pos(b,2,0),
    pos(a,2,1),
    pos(d,3,0),
    pos(c,4,1)
]).
```

### S4

```prolog
estado_sit2_s4([
    pos(b,2,0),
    pos(d,3,0),
    pos(c,4,1),
    pos(a,4,2)
]).
```

### S5

```prolog
estado_sit2_s5([
    pos(d,3,0),
    pos(c,4,1),
    pos(a,4,2),
    pos(b,5,2)
]).
```

## 4. Situação 3

### S0

```prolog
estado_sit3_s0([
    pos(c,0,0),
    pos(a,3,0),
    pos(b,5,0),
    pos(d,3,1)
]).
```

### S1

```prolog
estado_sit3_s1([
    pos(c,0,0),
    pos(d,0,1),
    pos(a,3,0),
    pos(b,5,0)
]).
```

### S2

```prolog
estado_sit3_s2([
    pos(c,0,0),
    pos(d,0,1),
    pos(b,5,0),
    pos(a,5,1)
]).
```

### S3

```prolog
estado_sit3_s3([
    pos(c,0,0),
    pos(d,2,0),
    pos(b,5,0),
    pos(a,5,1)
]).
```

### S4

```prolog
estado_sit3_s4([
    pos(c,0,0),
    pos(d,2,0),
    pos(b,5,0),
    pos(a,0,1)
]).
```

### S5

```prolog
estado_sit3_s5([
    pos(c,0,0),
    pos(d,2,0),
    pos(a,0,1),
    pos(b,1,1)
]).
```

### S6

```prolog
estado_sit3_s6([
    pos(c,0,0),
    pos(d,2,0),
    pos(a,0,1),
    pos(b,1,1)
]).
```

Na imagem do enunciado, `S5` e `S6` aparecem com a mesma configuração. Por isso foram representados da mesma forma.

### S7

```prolog
estado_sit3_s7([
    pos(c,0,0),
    pos(d,3,0),
    pos(a,0,1),
    pos(b,1,1)
]).
```
