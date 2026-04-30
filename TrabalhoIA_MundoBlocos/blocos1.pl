% ============================================================
% Trabalho de IA - Mundo dos Blocos com Dimensoes Diferentes
% Primeira versao: representacao espacial + movimentos + plano/3
% ============================================================

:- use_module(library(lists)).

% ------------------------------------------------------------
% 1. Base de conhecimento fixa
% ------------------------------------------------------------
% Temos quatro blocos: a, b, c, d.
% Os blocos a e b possuem largura 1.
% O bloco c possui largura 2.
% O bloco d possui largura 3.
%
% Todos terao altura 1 nesta primeira modelagem.

bloco(a).
bloco(b).
bloco(c).
bloco(d).

largura(a, 1).
largura(b, 1).
largura(c, 2).
largura(d, 3).

altura(a, 1).
altura(b, 1).
altura(c, 1).
altura(d, 1).

% A mesa vai da coordenada horizontal 0 ate a coordenada 6.
% Usaremos intervalos semiabertos: [XInicio, XFim).
% Portanto, um bloco de largura 3 em X=3 ocupa [3,6).
limite_mesa(0, 6).

% Limite usado para gerar tentativas de posicoes verticais.
% Com 4 blocos de altura 1, uma pilha completa teria bases em Y=0,1,2,3.
% Deixamos 4 como folga para experimentos.
altura_maxima(4).

% Limite padrao de profundidade para o planejador automatico.
% Pode aumentar depois, se necessario.
max_profundidade(10).


% ------------------------------------------------------------
% 2. Estados da Situacao 1
% ------------------------------------------------------------
% Representamos um estado como uma lista de termos:
%
%   pos(Bloco, X, Y)
%
% X = coordenada horizontal inicial do bloco.
% Y = altura da base do bloco.
%
% O estado S0 vem da Situacao 1, pagina 4 do enunciado.

estado_sit1_s0([
    pos(c,0,0),
    pos(a,3,0),
    pos(b,5,0),
    pos(d,3,1)
]).

% Alguns estados finais da Situacao 1.
% Eles serao uteis para testar o planejador depois.

estado_sit1_sf1([
    pos(d,3,0),
    pos(a,4,1),
    pos(b,5,1),
    pos(c,4,2)
]).

estado_sit1_sf2([
    pos(d,3,0),
    pos(c,3,1),
    pos(a,3,2),
    pos(b,4,2)
]).

estado_sit1_sf3([
    pos(c,0,0),
    pos(a,2,0),
    pos(b,5,0),
    pos(d,0,1)
]).

estado_sit1_sf4([
    pos(c,0,0),
    pos(d,2,0),
    pos(b,5,0),
    pos(a,0,1)
]).


% ------------------------------------------------------------
% 3. Predicados de geometria basica
% ------------------------------------------------------------

% dentro_da_mesa(+Bloco, +X)
%
% Verdadeiro se o bloco, colocado em X, nao ultrapassa os limites da mesa.
%
% Exemplo:
% d tem largura 3.
% Se d estiver em X=3, ele ocupa [3,6), entao cabe.
% Se d estiver em X=4, ele ocuparia [4,7), entao nao cabe.

dentro_da_mesa(B, X) :-
    limite_mesa(XMin, XMax),
    largura(B, L),
    X >= XMin,
    X + L =< XMax.


% coord_x(+Bloco, ?X)
%
% Gera ou verifica coordenadas horizontais possiveis para um bloco.
%
% Exemplo:
% d tem largura 3 e a mesa vai ate 6.
% Entao d so pode comecar em X=0,1,2,3.

coord_x(B, X) :-
    limite_mesa(XMin, XMax),
    largura(B, L),
    UltimoX is XMax - L,
    between(XMin, UltimoX, X).


% coord_y(?Y)
%
% Gera ou verifica alturas candidatas.
% Esta altura nao garante que o bloco esteja apoiado.
% Ela apenas cria possibilidades; depois apoio_valido/4 filtra.

coord_y(Y) :-
    altura_maxima(MaxY),
    between(0, MaxY, Y).


% ocupa(+Bloco, +Estado, ?X1, ?X2, ?Y1, ?Y2)
%
% Calcula o retangulo ocupado por um bloco em um estado.
%
% X1 = inicio horizontal
% X2 = fim horizontal
% Y1 = inicio vertical
% Y2 = fim vertical
%
% Usamos intervalos semiabertos:
%
%   [X1, X2)
%   [Y1, Y2)

ocupa(B, Estado, X1, X2, Y1, Y2) :-
    member(pos(B, X1, Y1), Estado),
    largura(B, L),
    altura(B, H),
    X2 is X1 + L,
    Y2 is Y1 + H.


% intervalos_sobrepoem(+A1, +A2, +B1, +B2)
%
% Verdadeiro se dois intervalos semiabertos se sobrepoem.
%
% [0,2) e [2,3) NAO se sobrepoem.
% [0,2) e [1,3) se sobrepoem.

intervalos_sobrepoem(A1, A2, B1, B2) :-
    A1 < B2,
    B1 < A2.


% retangulos_sobrepoem(+Pos1, +Pos2)
%
% Verifica se dois blocos, dados por suas posicoes, ocupam algum espaco comum.

retangulos_sobrepoem(pos(B1,X1,Y1), pos(B2,X2,Y2)) :-
    largura(B1, L1),
    altura(B1, H1),
    largura(B2, L2),
    altura(B2, H2),

    X1Fim is X1 + L1,
    Y1Fim is Y1 + H1,
    X2Fim is X2 + L2,
    Y2Fim is Y2 + H2,

    intervalos_sobrepoem(X1, X1Fim, X2, X2Fim),
    intervalos_sobrepoem(Y1, Y1Fim, Y2, Y2Fim).


% sem_colisoes(+Estado)
%
% Verdadeiro se nenhum par de blocos ocupa o mesmo espaco.

sem_colisoes([]).
sem_colisoes([P|Resto]) :-
    \+ (
        member(Q, Resto),
        retangulos_sobrepoem(P, Q)
    ),
    sem_colisoes(Resto).


% ------------------------------------------------------------
% 4. Apoio e equilibrio
% ------------------------------------------------------------
% Esta parte e importante.
%
% No estado S0, o bloco d esta em cima de a e b, mas existe um vao entre eles.
% Se exigissemos apoio continuo em toda a base, S0 seria invalido.
%
% Entao usamos uma regra de equilibrio simplificada:
%
%   Um bloco esta apoiado se:
%   1. esta na mesa, ou
%   2. existe pelo menos um contato abaixo dele, e
%   3. o centro geometrico horizontal do bloco cai dentro do intervalo total
%      coberto pelos apoios.
%
% Isso permite que d fique sobre a e b em S0.

% intersecao_intervalos(+A1, +A2, +B1, +B2, ?I1, ?I2)
%
% Calcula a intersecao entre dois intervalos.
% So e verdadeiro se a intersecao tiver tamanho positivo.

intersecao_intervalos(A1, A2, B1, B2, I1, I2) :-
    I1 is max(A1, B1),
    I2 is min(A2, B2),
    I1 < I2.


% segmento_apoio(+Bloco, +X, +Y, +Estado, ?Segmento)
%
% Encontra segmentos de apoio para Bloco se ele fosse colocado em (X,Y).
%
% Um bloco Apoio apoia Bloco se:
% - o topo de Apoio esta exatamente na altura Y;
% - Apoio possui intersecao horizontal com Bloco.

segmento_apoio(B, X, Y, Estado, seg(Apoio, I1, I2)) :-
    Y > 0,
    largura(B, LB),
    BX2 is X + LB,

    ocupa(Apoio, Estado, AX1, AX2, _AY1, AY2),
    AY2 =:= Y,

    intersecao_intervalos(X, BX2, AX1, AX2, I1, I2).


% limites_dos_segmentos(+Segmentos, ?Min, ?Max)
%
% Dada uma lista de segmentos de apoio, calcula o menor inicio
% e o maior fim. Isso representa o intervalo total de apoio.

limites_dos_segmentos(Segmentos, Min, Max) :-
    findall(I1, member(seg(_, I1, _), Segmentos), Inicios),
    findall(I2, member(seg(_, _, I2), Segmentos), Fins),
    min_list(Inicios, Min),
    max_list(Fins, Max).


% apoio_valido(+Bloco, +X, +Y, +Estado)
%
% Verdadeiro se Bloco colocado em (X,Y) esta apoiado.
%
% Caso 1:
% Se Y = 0, o bloco esta sobre a mesa.
%
% Caso 2:
% Se Y > 0, o bloco precisa ter apoios embaixo.
% Alem disso, seu centro geometrico horizontal precisa cair dentro
% do intervalo total dos apoios.
%
% Para evitar numeros decimais, usamos o dobro do centro:
%
%   centro = X + L/2
%   centro2 = 2*X + L

apoio_valido(_B, _X, 0, _Estado) :- !.

apoio_valido(B, X, Y, Estado) :-
    Y > 0,

    findall(Seg, segmento_apoio(B, X, Y, Estado, Seg), Segmentos),
    Segmentos \= [],

    limites_dos_segmentos(Segmentos, MinApoio, MaxApoio),

    largura(B, L),
    Centro2 is 2*X + L,

    Centro2 >= 2*MinApoio,
    Centro2 =< 2*MaxApoio.


% ------------------------------------------------------------
% 5. Validade de estado
% ------------------------------------------------------------

% todos_blocos_presentes(+Estado)
%
% Garante que o estado contem exatamente os blocos do problema.

todos_blocos_presentes(Estado) :-
    findall(B, bloco(B), Blocos),
    length(Blocos, N),
    length(Estado, N),
    forall(
        member(B, Blocos),
        member(pos(B, _, _), Estado)
    ).


% coordenadas_estado_validas(+Estado)
%
% Garante que todos os blocos possuem coordenadas inteiras,
% nao ficam abaixo da mesa e nao ultrapassam a mesa horizontalmente.

coordenadas_estado_validas(Estado) :-
    forall(
        member(pos(B, X, Y), Estado),
        (
            bloco(B),
            integer(X),
            integer(Y),
            Y >= 0,
            dentro_da_mesa(B, X)
        )
    ).


% estado_valido(+Estado)
%
% Um estado e valido se:
% - contem todos os blocos;
% - todas as coordenadas sao validas;
% - nao ha colisao;
% - todos os blocos estao apoiados.

estado_valido(Estado) :-
    todos_blocos_presentes(Estado),
    coordenadas_estado_validas(Estado),
    sem_colisoes(Estado),
    forall(
        member(pos(B, X, Y), Estado),
        apoio_valido(B, X, Y, Estado)
    ).


% ------------------------------------------------------------
% 6. Bloco livre
% ------------------------------------------------------------
% Um bloco esta livre se nao existe outro bloco diretamente em cima dele.
%
% Outro bloco esta em cima se:
% - a base do outro bloco esta exatamente no topo deste bloco;
% - ha sobreposicao horizontal entre eles.

bloco_livre(B, Estado) :-
    ocupa(B, Estado, X1, X2, _Y1, Y2),
    \+ (
        ocupa(Outro, Estado, OX1, OX2, OY1, _OY2),
        Outro \= B,
        OY1 =:= Y2,
        intervalos_sobrepoem(X1, X2, OX1, OX2)
    ).


% ------------------------------------------------------------
% 7. Movimento
% ------------------------------------------------------------
% acao(?Acao, +Estado, ?NovoEstado)
%
% A acao tem a forma:
%
%   move(Bloco, p(XAntigo,YAntigo), p(XNovo,YNovo))
%
% Um movimento e valido se:
% - o bloco existe no estado;
% - o bloco esta livre;
% - a nova posicao e candidata;
% - a nova posicao e diferente da antiga;
% - o novo estado e valido.

acao(move(B, p(X0,Y0), p(X,Y)), Estado, NovoEstado) :-
    select(pos(B, X0, Y0), Estado, Restante),

    bloco_livre(B, Estado),

    coord_x(B, X),
    coord_y(Y),

    (X =\= X0 ; Y =\= Y0),

    EstadoTentativo = [pos(B, X, Y)|Restante],

    estado_valido(EstadoTentativo),

    normaliza_estado(EstadoTentativo, NovoEstado).


% ------------------------------------------------------------
% 8. Normalizacao e comparacao de estados
% ------------------------------------------------------------
% Como um estado e uma lista, a ordem dos elementos nao deveria importar.
%
% Estes dois estados representam a mesma coisa:
%
%   [pos(a,0,0), pos(b,1,0)]
%   [pos(b,1,0), pos(a,0,0)]
%
% Por isso usamos sort/2 antes de comparar.

normaliza_estado(Estado, EstadoNormalizado) :-
    sort(Estado, EstadoNormalizado).


igual_estado(E1, E2) :-
    normaliza_estado(E1, N),
    normaliza_estado(E2, N).


% ------------------------------------------------------------
% 9. Aplicacao de plano manual
% ------------------------------------------------------------
% aplica_plano(+EstadoInicial, +ListaDeAcoes, ?EstadoFinal)
%
% Serve para testar um plano escrito manualmente.
%
% Exemplo:
%
%   aplica_plano(S0, [move(...), move(...)], Final).

aplica_plano(Estado, [], Estado).

aplica_plano(Estado, [Acao|Resto], Final) :-
    acao(Acao, Estado, Proximo),
    aplica_plano(Proximo, Resto, Final).


% Um plano manual possivel de S0 ate Sf4.
%
% Ideia:
% 1. Tirar d de cima de a e b, colocando d temporariamente sobre c.
% 2. Mover a para cima de b.
% 3. Colocar d na base entre c e b.
% 4. Colocar a sobre c.

plano_manual_s0_sf4([
    move(d, p(3,1), p(0,1)),
    move(a, p(3,0), p(5,1)),
    move(d, p(0,1), p(2,0)),
    move(a, p(5,1), p(0,1))
]).


% ------------------------------------------------------------
% 10. Planejador automatico: plano/3
% ------------------------------------------------------------
% plano(+EstadoInicial, +EstadoObjetivo, ?Plano)
%
% Esta e uma busca recursiva com limite de profundidade.
%
% Ela tenta planos de tamanho 0, depois 1, depois 2, etc.,
% ate max_profundidade/1.
%
% Isso evita loops infinitos.

plano(Inicio, Objetivo, Plano) :-
    normaliza_estado(Inicio, I),
    normaliza_estado(Objetivo, G),

    max_profundidade(Max),
    between(0, Max, Limite),

    plano_limite(I, G, [I], Limite, Plano),
    !.


% plano_com_limite(+Inicio, +Objetivo, +Limite, ?Plano)
%
% Versao util para testes, pois permite escolher manualmente o limite.

plano_com_limite(Inicio, Objetivo, Limite, Plano) :-
    normaliza_estado(Inicio, I),
    normaliza_estado(Objetivo, G),
    plano_limite(I, G, [I], Limite, Plano).


% Caso base:
% Se o estado atual ja e o objetivo, o plano restante e vazio.

plano_limite(Estado, Objetivo, _Visitados, _Limite, []) :-
    igual_estado(Estado, Objetivo).


% Caso recursivo:
% Escolhe uma acao valida, gera Proximo estado,
% evita repetir estados visitados e continua buscando.

plano_limite(Estado, Objetivo, Visitados, Limite, [Acao|Plano]) :-
    Limite > 0,

    acao(Acao, Estado, Proximo),

    \+ memberchk(Proximo, Visitados),

    Limite1 is Limite - 1,

    plano_limite(Proximo, Objetivo, [Proximo|Visitados], Limite1, Plano).


% ------------------------------------------------------------
% 11. Testes
% ------------------------------------------------------------

:- begin_tests(situacao1).

test(s0_valido) :-
    estado_sit1_s0(S),
    estado_valido(S).

test(d_ocupa_intervalo_correto) :-
    estado_sit1_s0(S),
    ocupa(d, S, 3, 6, 1, 2).

test(c_ocupa_intervalo_correto) :-
    estado_sit1_s0(S),
    ocupa(c, S, 0, 2, 0, 1).

test(d_livre_no_s0) :-
    estado_sit1_s0(S),
    bloco_livre(d, S).

test(c_livre_no_s0) :-
    estado_sit1_s0(S),
    bloco_livre(c, S).

test(a_nao_livre_no_s0, [fail]) :-
    estado_sit1_s0(S),
    bloco_livre(a, S).

test(b_nao_livre_no_s0, [fail]) :-
    estado_sit1_s0(S),
    bloco_livre(b, S).

test(sf1_valido) :-
    estado_sit1_sf1(S),
    estado_valido(S).

test(sf2_valido) :-
    estado_sit1_sf2(S),
    estado_valido(S).

test(sf3_valido) :-
    estado_sit1_sf3(S),
    estado_valido(S).

test(sf4_valido) :-
    estado_sit1_sf4(S),
    estado_valido(S).

test(existe_acao_movendo_d_no_s0) :-
    estado_sit1_s0(S),
    once(acao(move(d, p(3,1), p(_,_)), S, _)).

test(plano_manual_s0_ate_sf4_funciona) :-
    estado_sit1_s0(S0),
    estado_sit1_sf4(Objetivo),
    plano_manual_s0_sf4(Plano),
    aplica_plano(S0, Plano, Final),
    igual_estado(Final, Objetivo).

:- end_tests(situacao1).
