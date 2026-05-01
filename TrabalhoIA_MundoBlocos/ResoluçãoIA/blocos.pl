% ============================================================
% Trabalho de IA - Mundo dos Blocos com Dimensoes Diferentes
% Arquivo principal do projeto
% ============================================================

:- use_module(library(lists)).

% ============================================================
% 1. Base de conhecimento fixa
% ============================================================

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

limite_mesa(0, 6).

altura_maxima(4).

max_profundidade(10).


% ============================================================
% 2. Estados da Situacao 1
% ============================================================

estado_sit1_s0([
    pos(c,0,0),
    pos(a,3,0),
    pos(b,5,0),
    pos(d,3,1)
]).

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


% ============================================================
% 3. Geometria basica
% ============================================================

dentro_da_mesa(B, X) :-
    limite_mesa(XMin, XMax),
    largura(B, L),
    X >= XMin,
    X + L =< XMax.


coord_x(B, X) :-
    limite_mesa(XMin, XMax),
    largura(B, L),
    UltimoX is XMax - L,
    between(XMin, UltimoX, X).


coord_y(Y) :-
    altura_maxima(MaxY),
    between(0, MaxY, Y).


ocupa(B, Estado, X1, X2, Y1, Y2) :-
    member(pos(B, X1, Y1), Estado),
    largura(B, L),
    altura(B, H),
    X2 is X1 + L,
    Y2 is Y1 + H.


intervalos_sobrepoem(A1, A2, B1, B2) :-
    A1 < B2,
    B1 < A2.


retangulos_sobrepoem(pos(B1,X1,Y1), pos(B2,X2,Y2)) :-
    B1 \= B2,

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


sem_colisoes([]).

sem_colisoes([P|Resto]) :-
    \+ (
        member(Q, Resto),
        retangulos_sobrepoem(P, Q)
    ),
    sem_colisoes(Resto).


% ============================================================
% 4. Apoio e equilibrio
% ============================================================

intersecao_intervalos(A1, A2, B1, B2, I1, I2) :-
    I1 is max(A1, B1),
    I2 is min(A2, B2),
    I1 < I2.


segmento_apoio(B, X, Y, Estado, seg(Apoio, I1, I2)) :-
    Y > 0,

    largura(B, LB),
    BX2 is X + LB,

    ocupa(Apoio, Estado, AX1, AX2, _AY1, AY2),

    AY2 =:= Y,

    intersecao_intervalos(X, BX2, AX1, AX2, I1, I2).


limites_dos_segmentos(Segmentos, Min, Max) :-
    findall(I1, member(seg(_, I1, _), Segmentos), Inicios),
    findall(I2, member(seg(_, _, I2), Segmentos), Fins),
    min_list(Inicios, Min),
    max_list(Fins, Max).


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


% ============================================================
% 5. Validade de estado
% ============================================================

todos_blocos_presentes(Estado) :-
    findall(B, bloco(B), Blocos),
    length(Blocos, N),
    length(Estado, N),
    forall(
        member(B, Blocos),
        member(pos(B, _, _), Estado)
    ).


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


estado_valido(Estado) :-
    todos_blocos_presentes(Estado),
    coordenadas_estado_validas(Estado),
    sem_colisoes(Estado),
    forall(
        member(pos(B, X, Y), Estado),
        apoio_valido(B, X, Y, Estado)
    ).


% ============================================================
% 6. Bloco livre
% ============================================================

bloco_livre(B, Estado) :-
    ocupa(B, Estado, X1, X2, _Y1, Y2),
    \+ (
        ocupa(Outro, Estado, OX1, OX2, OY1, _OY2),
        Outro \= B,
        OY1 =:= Y2,
        intervalos_sobrepoem(X1, X2, OX1, OX2)
    ).


% ============================================================
% 7. Movimento
% ============================================================

acao(move(B, p(X0,Y0), p(X,Y)), Estado, NovoEstado) :-
    select(pos(B, X0, Y0), Estado, Restante),

    bloco_livre(B, Estado),

    coord_x(B, X),
    coord_y(Y),

    (X =\= X0 ; Y =\= Y0),

    EstadoTentativo = [pos(B, X, Y)|Restante],

    estado_valido(EstadoTentativo),

    normaliza_estado(EstadoTentativo, NovoEstado).


% ============================================================
% 8. Normalizacao e comparacao de estados
% ============================================================

normaliza_estado(Estado, EstadoNormalizado) :-
    sort(Estado, EstadoNormalizado).


igual_estado(E1, E2) :-
    normaliza_estado(E1, N),
    normaliza_estado(E2, N).


% ============================================================
% 9. Aplicacao de plano manual
% ============================================================

aplica_plano(Estado, [], Estado).

aplica_plano(Estado, [Acao|Resto], Final) :-
    acao(Acao, Estado, Proximo),
    aplica_plano(Proximo, Resto, Final).


plano_manual_s0_sf4([
    move(d, p(3,1), p(0,1)),
    move(a, p(3,0), p(5,1)),
    move(d, p(0,1), p(2,0)),
    move(a, p(5,1), p(0,1))
]).


% ============================================================
% 10. Planejador automatico
% ============================================================

plano(Inicio, Objetivo, Plano) :-
    normaliza_estado(Inicio, I),
    normaliza_estado(Objetivo, G),

    max_profundidade(Max),
    between(0, Max, Limite),

    plano_limite(I, G, [I], Limite, Plano),
    !.


plano_com_limite(Inicio, Objetivo, Limite, Plano) :-
    normaliza_estado(Inicio, I),
    normaliza_estado(Objetivo, G),
    plano_limite(I, G, [I], Limite, Plano).


plano_limite(Estado, Objetivo, _Visitados, _Limite, []) :-
    igual_estado(Estado, Objetivo).


plano_limite(Estado, Objetivo, Visitados, Limite, [Acao|Plano]) :-
    Limite > 0,

    acao(Acao, Estado, Proximo),

    \+ memberchk(Proximo, Visitados),

    Limite1 is Limite - 1,

    plano_limite(Proximo, Objetivo, [Proximo|Visitados], Limite1, Plano).


% ============================================================
% 11. Testes da Situacao 1
% ============================================================

:- begin_tests(situacao1).


test(s0_valido) :-
    once((
        estado_sit1_s0(S),
        estado_valido(S)
    )).

test(d_ocupa_intervalo_correto) :-
    once((
        estado_sit1_s0(S),
        ocupa(d, S, 3, 6, 1, 2)
    )).

test(c_ocupa_intervalo_correto) :-
    once((
        estado_sit1_s0(S),
        ocupa(c, S, 0, 2, 0, 1)
    )).

test(d_livre_no_s0) :-
    once((
        estado_sit1_s0(S),
        bloco_livre(d, S)
    )).

test(c_livre_no_s0) :-
    once((
        estado_sit1_s0(S),
        bloco_livre(c, S)
    )).

test(a_nao_livre_no_s0, [fail]) :-
    estado_sit1_s0(S),
    bloco_livre(a, S).

test(b_nao_livre_no_s0, [fail]) :-
    estado_sit1_s0(S),
    bloco_livre(b, S).

test(sf1_valido) :-
    once((
        estado_sit1_sf1(S),
        estado_valido(S)
    )).

test(sf2_valido) :-
    once((
        estado_sit1_sf2(S),
        estado_valido(S)
    )).

test(sf3_valido) :-
    once((
        estado_sit1_sf3(S),
        estado_valido(S)
    )).

test(sf4_valido) :-
    once((
        estado_sit1_sf4(S),
        estado_valido(S)
    )).

test(existe_acao_movendo_d_no_s0) :-
    once((
        estado_sit1_s0(S),
        acao(move(d, p(3,1), p(_,_)), S, _)
    )).

test(plano_manual_s0_ate_sf4_funciona) :-
    once((
        estado_sit1_s0(S0),
        estado_sit1_sf4(Objetivo),
        plano_manual_s0_sf4(Plano),
        aplica_plano(S0, Plano, Final),
        igual_estado(Final, Objetivo)
    )).


:- end_tests(situacao1).