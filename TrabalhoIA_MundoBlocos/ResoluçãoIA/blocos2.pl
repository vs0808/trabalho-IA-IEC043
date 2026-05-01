% ============================================================
% Situacao 2 do Trabalho de IA - Mundo dos Blocos
%
% Este arquivo complementa blocos.pl.
% Ele nao redefine a logica principal.
%
% Ele adiciona:
% - estados da Situacao 2
% - transicoes manuais da Situacao 2
% - plano manual de referencia da Situacao 2
% - testes especificos da Situacao 2
% ============================================================

:- ensure_loaded('blocos.pl').


% ============================================================
% 1. Estados da Situacao 2
% ============================================================
%
% A Situacao 2 aparece na pagina 5 do enunciado.
%
% Blocos:
% a: largura 1
% b: largura 1
% c: largura 2
% d: largura 3
%
% Mesa:
% coordenadas horizontais de 0 ate 6.
%
% Cada estado e uma lista de posicoes:
%
%   pos(Bloco, X, Y)
%
% X = inicio horizontal do bloco.
% Y = altura da base do bloco.


% ------------------------------------------------------------
% Situacao 2 - S0
%
% Visualmente:
%
%   a b
%   c   d
%
% c ocupa [0,2) na base.
% a ocupa [0,1) sobre c.
% b ocupa [1,2) sobre c.
% d ocupa [3,6) na base.
% ------------------------------------------------------------

estado_sit2_s0([
    pos(c,0,0),
    pos(a,0,1),
    pos(b,1,1),
    pos(d,3,0)
]).


% ------------------------------------------------------------
% Situacao 2 - S1
%
% Visualmente:
%
%   a
%   c b d
%
% b saiu de cima de c e foi para a base em X=2.
% ------------------------------------------------------------

estado_sit2_s1([
    pos(c,0,0),
    pos(a,0,1),
    pos(b,2,0),
    pos(d,3,0)
]).


% ------------------------------------------------------------
% Situacao 2 - S2
%
% Visualmente:
%
%     a
%   c b d
%
% a foi colocado sobre b.
% ------------------------------------------------------------

estado_sit2_s2([
    pos(c,0,0),
    pos(b,2,0),
    pos(a,2,1),
    pos(d,3,0)
]).


% ------------------------------------------------------------
% Situacao 2 - S3
%
% Visualmente:
%
%     a   c
%     b d
%
% c foi colocado sobre d, em X=4.
% a continua sobre b.
% ------------------------------------------------------------

estado_sit2_s3([
    pos(b,2,0),
    pos(a,2,1),
    pos(d,3,0),
    pos(c,4,1)
]).


% ------------------------------------------------------------
% Situacao 2 - S4
%
% Visualmente:
%
%       a
%       c
%     b d
%
% a foi colocado sobre c.
% b continua na base em X=2.
% ------------------------------------------------------------

estado_sit2_s4([
    pos(b,2,0),
    pos(d,3,0),
    pos(c,4,1),
    pos(a,4,2)
]).


% ------------------------------------------------------------
% Situacao 2 - S5
%
% Visualmente:
%
%       a b
%       c
%     d
%
% d esta na base em [3,6).
% c esta sobre d em [4,6).
% a e b estao sobre c.
% ------------------------------------------------------------

estado_sit2_s5([
    pos(d,3,0),
    pos(c,4,1),
    pos(a,4,2),
    pos(b,5,2)
]).


% ------------------------------------------------------------
% Predicado auxiliar para consultar estados da Situacao 2.
%
% Exemplos:
%
%   estado_sit2(s0, S).
%   estado_sit2(s5, S).
% ------------------------------------------------------------

estado_sit2(s0, S) :- estado_sit2_s0(S).
estado_sit2(s1, S) :- estado_sit2_s1(S).
estado_sit2(s2, S) :- estado_sit2_s2(S).
estado_sit2(s3, S) :- estado_sit2_s3(S).
estado_sit2(s4, S) :- estado_sit2_s4(S).
estado_sit2(s5, S) :- estado_sit2_s5(S).


% ============================================================
% 2. Transicoes manuais da Situacao 2
% ============================================================
%
% transicao_sit2(EstadoOrigem, EstadoDestino, Acao).
%
% A acao sempre tem a forma:
%
%   move(Bloco, p(XAntigo,YAntigo), p(XNovo,YNovo))
%
% Estas transicoes descrevem o caminho manual:
%
%   S0 -> S1 -> S2 -> S3 -> S4 -> S5
% ============================================================

transicao_sit2(s0, s1, move(b, p(1,1), p(2,0))).
transicao_sit2(s1, s2, move(a, p(0,1), p(2,1))).
transicao_sit2(s2, s3, move(c, p(0,0), p(4,1))).
transicao_sit2(s3, s4, move(a, p(2,1), p(4,2))).
transicao_sit2(s4, s5, move(b, p(2,0), p(5,2))).


% ============================================================
% 3. Plano manual completo da Situacao 2
% ============================================================
%
% Plano:
%
%   S0 -> S1 -> S2 -> S3 -> S4 -> S5
%
% Ideia geral:
% 1. tirar b de cima de c;
% 2. colocar a sobre b;
% 3. mover c para cima de d;
% 4. colocar a sobre c;
% 5. colocar b sobre c.
% ============================================================

plano_manual_sit2_s0_s5([
    move(b, p(1,1), p(2,0)),
    move(a, p(0,1), p(2,1)),
    move(c, p(0,0), p(4,1)),
    move(a, p(2,1), p(4,2)),
    move(b, p(2,0), p(5,2))
]).


% ============================================================
% 4. Predicados auxiliares de visualizacao
% ============================================================

% ------------------------------------------------------------
% mostra_estado(+Estado)
%
% Mostra um estado em ordem padronizada.
% ------------------------------------------------------------

mostra_estado(Estado) :-
    user:normaliza_estado(Estado, Ordenado),
    forall(
        member(Pos, Ordenado),
        (write(Pos), nl)
    ).


% ------------------------------------------------------------
% mostra_plano(+Plano)
%
% Mostra cada acao do plano em uma linha.
% ------------------------------------------------------------

mostra_plano([]).

mostra_plano([Acao|Resto]) :-
    write(Acao),
    nl,
    mostra_plano(Resto).


% ============================================================
% 5. Testes da Situacao 2
% ============================================================

:- begin_tests(situacao2).


% ------------------------------------------------------------
% Testes de validade dos estados da Situacao 2
% ------------------------------------------------------------

test(sit2_s0_valido) :-
    once((
        user:estado_sit2_s0(S),
        user:estado_valido(S)
    )).

test(sit2_s1_valido) :-
    once((
        user:estado_sit2_s1(S),
        user:estado_valido(S)
    )).

test(sit2_s2_valido) :-
    once((
        user:estado_sit2_s2(S),
        user:estado_valido(S)
    )).

test(sit2_s3_valido) :-
    once((
        user:estado_sit2_s3(S),
        user:estado_valido(S)
    )).

test(sit2_s4_valido) :-
    once((
        user:estado_sit2_s4(S),
        user:estado_valido(S)
    )).

test(sit2_s5_valido) :-
    once((
        user:estado_sit2_s5(S),
        user:estado_valido(S)
    )).


% ------------------------------------------------------------
% Testes das transicoes da Situacao 2
% ------------------------------------------------------------

test(sit2_s0_para_s1) :-
    once((
        user:estado_sit2_s0(S0),
        user:estado_sit2_s1(S1),
        user:transicao_sit2(s0, s1, Acao),
        user:acao(Acao, S0, Resultado),
        user:igual_estado(Resultado, S1)
    )).

test(sit2_s1_para_s2) :-
    once((
        user:estado_sit2_s1(S1),
        user:estado_sit2_s2(S2),
        user:transicao_sit2(s1, s2, Acao),
        user:acao(Acao, S1, Resultado),
        user:igual_estado(Resultado, S2)
    )).

test(sit2_s2_para_s3) :-
    once((
        user:estado_sit2_s2(S2),
        user:estado_sit2_s3(S3),
        user:transicao_sit2(s2, s3, Acao),
        user:acao(Acao, S2, Resultado),
        user:igual_estado(Resultado, S3)
    )).

test(sit2_s3_para_s4) :-
    once((
        user:estado_sit2_s3(S3),
        user:estado_sit2_s4(S4),
        user:transicao_sit2(s3, s4, Acao),
        user:acao(Acao, S3, Resultado),
        user:igual_estado(Resultado, S4)
    )).

test(sit2_s4_para_s5) :-
    once((
        user:estado_sit2_s4(S4),
        user:estado_sit2_s5(S5),
        user:transicao_sit2(s4, s5, Acao),
        user:acao(Acao, S4, Resultado),
        user:igual_estado(Resultado, S5)
    )).


% ------------------------------------------------------------
% Teste do plano manual completo da Situacao 2
% ------------------------------------------------------------

test(plano_manual_sit2_s0_ate_s5_funciona) :-
    once((
        user:estado_sit2_s0(S0),
        user:estado_sit2_s5(Objetivo),
        user:plano_manual_sit2_s0_s5(Plano),
        user:aplica_plano(S0, Plano, Final),
        user:igual_estado(Final, Objetivo)
    )).


:- end_tests(situacao2).