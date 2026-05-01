% ============================================================
% Situacao 3 do Trabalho de IA - Mundo dos Blocos
%
% Este arquivo complementa blocos.pl.
% Ele nao redefine a logica principal.
%
% Ele adiciona:
% - estados da Situacao 3
% - transicoes manuais da Situacao 3
% - plano manual de referencia da Situacao 3
% - testes especificos da Situacao 3
% ============================================================

:- ensure_loaded('blocos.pl').


% ============================================================
% 1. Estados da Situacao 3
% ============================================================
%
% A Situacao 3 aparece na pagina 6 do enunciado.
%
% O S0 da Situacao 3 e o mesmo S0 da Situacao 1:
%
% c na base em [0,2)
% a na base em [3,4)
% b na base em [5,6)
% d sobre a e b, ocupando [3,6)
%
% Cada estado e uma lista de posicoes:
%
%   pos(Bloco, X, Y)
%
% X = inicio horizontal do bloco.
% Y = altura da base do bloco.
% ============================================================


% ------------------------------------------------------------
% Situacao 3 - S0
% ------------------------------------------------------------

estado_sit3_s0([
    pos(c,0,0),
    pos(a,3,0),
    pos(b,5,0),
    pos(d,3,1)
]).


% ------------------------------------------------------------
% Situacao 3 - S1
%
% d foi movido para cima de c.
% ------------------------------------------------------------

estado_sit3_s1([
    pos(c,0,0),
    pos(d,0,1),
    pos(a,3,0),
    pos(b,5,0)
]).


% ------------------------------------------------------------
% Situacao 3 - S2
%
% a foi movido para cima de b.
% d continua sobre c.
% ------------------------------------------------------------

estado_sit3_s2([
    pos(c,0,0),
    pos(d,0,1),
    pos(b,5,0),
    pos(a,5,1)
]).


% ------------------------------------------------------------
% Situacao 3 - S3
%
% d foi movido para a base em X=2.
% a continua sobre b.
% ------------------------------------------------------------

estado_sit3_s3([
    pos(c,0,0),
    pos(d,2,0),
    pos(b,5,0),
    pos(a,5,1)
]).


% ------------------------------------------------------------
% Situacao 3 - S4
%
% a foi movido para cima de c em X=0.
% ------------------------------------------------------------

estado_sit3_s4([
    pos(c,0,0),
    pos(d,2,0),
    pos(b,5,0),
    pos(a,0,1)
]).


% ------------------------------------------------------------
% Situacao 3 - S5
%
% b foi movido para cima de c em X=1.
% Agora a e b estao lado a lado sobre c.
% ------------------------------------------------------------

estado_sit3_s5([
    pos(c,0,0),
    pos(d,2,0),
    pos(a,0,1),
    pos(b,1,1)
]).


% ------------------------------------------------------------
% Situacao 3 - S6
%
% No desenho da pagina 6, S5 e S6 aparecem com a mesma configuracao.
% Portanto, representamos S6 igual a S5.
% ------------------------------------------------------------

estado_sit3_s6([
    pos(c,0,0),
    pos(d,2,0),
    pos(a,0,1),
    pos(b,1,1)
]).


% ------------------------------------------------------------
% Situacao 3 - S7
%
% d foi movido de X=2 para X=3.
% Assim, d fica separado da pilha c-a-b.
% ------------------------------------------------------------

estado_sit3_s7([
    pos(c,0,0),
    pos(d,3,0),
    pos(a,0,1),
    pos(b,1,1)
]).


% ------------------------------------------------------------
% Predicado auxiliar para consultar estados da Situacao 3.
%
% Exemplos:
%
%   estado_sit3(s0, S).
%   estado_sit3(s7, S).
% ------------------------------------------------------------

estado_sit3(s0, S) :- estado_sit3_s0(S).
estado_sit3(s1, S) :- estado_sit3_s1(S).
estado_sit3(s2, S) :- estado_sit3_s2(S).
estado_sit3(s3, S) :- estado_sit3_s3(S).
estado_sit3(s4, S) :- estado_sit3_s4(S).
estado_sit3(s5, S) :- estado_sit3_s5(S).
estado_sit3(s6, S) :- estado_sit3_s6(S).
estado_sit3(s7, S) :- estado_sit3_s7(S).


% ============================================================
% 2. Transicoes manuais da Situacao 3
% ============================================================
%
% transicao_sit3(EstadoOrigem, EstadoDestino, Acao).
%
% A acao sempre tem a forma:
%
%   move(Bloco, p(XAntigo,YAntigo), p(XNovo,YNovo))
%
% A sequencia manual considerada e:
%
%   S0 -> S1 -> S2 -> S3 -> S4 -> S5/S6 -> S7
% ============================================================

transicao_sit3(s0, s1, move(d, p(3,1), p(0,1))).
transicao_sit3(s1, s2, move(a, p(3,0), p(5,1))).
transicao_sit3(s2, s3, move(d, p(0,1), p(2,0))).
transicao_sit3(s3, s4, move(a, p(5,1), p(0,1))).
transicao_sit3(s4, s5, move(b, p(5,0), p(1,1))).
transicao_sit3(s6, s7, move(d, p(2,0), p(3,0))).


% ============================================================
% 3. Plano manual completo da Situacao 3
% ============================================================
%
% Plano:
%
%   S0 -> S1 -> S2 -> S3 -> S4 -> S5/S6 -> S7
%
% Ideia geral:
% 1. mover d para cima de c;
% 2. mover a para cima de b;
% 3. mover d para a base;
% 4. mover a para cima de c;
% 5. mover b para cima de c;
% 6. mover d para a direita, separando-o da pilha.
% ============================================================

plano_manual_sit3_s0_s7([
    move(d, p(3,1), p(0,1)),
    move(a, p(3,0), p(5,1)),
    move(d, p(0,1), p(2,0)),
    move(a, p(5,1), p(0,1)),
    move(b, p(5,0), p(1,1)),
    move(d, p(2,0), p(3,0))
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
% 5. Testes da Situacao 3
% ============================================================

:- begin_tests(situacao3).


% ------------------------------------------------------------
% Testes de validade dos estados da Situacao 3
% ------------------------------------------------------------

test(sit3_s0_valido) :-
    once((
        user:estado_sit3_s0(S),
        user:estado_valido(S)
    )).

test(sit3_s1_valido) :-
    once((
        user:estado_sit3_s1(S),
        user:estado_valido(S)
    )).

test(sit3_s2_valido) :-
    once((
        user:estado_sit3_s2(S),
        user:estado_valido(S)
    )).

test(sit3_s3_valido) :-
    once((
        user:estado_sit3_s3(S),
        user:estado_valido(S)
    )).

test(sit3_s4_valido) :-
    once((
        user:estado_sit3_s4(S),
        user:estado_valido(S)
    )).

test(sit3_s5_valido) :-
    once((
        user:estado_sit3_s5(S),
        user:estado_valido(S)
    )).

test(sit3_s6_valido) :-
    once((
        user:estado_sit3_s6(S),
        user:estado_valido(S)
    )).

test(sit3_s7_valido) :-
    once((
        user:estado_sit3_s7(S),
        user:estado_valido(S)
    )).


% ------------------------------------------------------------
% Testes das transicoes da Situacao 3
% ------------------------------------------------------------

test(sit3_s0_para_s1) :-
    once((
        user:estado_sit3_s0(S0),
        user:estado_sit3_s1(S1),
        user:transicao_sit3(s0, s1, Acao),
        user:acao(Acao, S0, Resultado),
        user:igual_estado(Resultado, S1)
    )).

test(sit3_s1_para_s2) :-
    once((
        user:estado_sit3_s1(S1),
        user:estado_sit3_s2(S2),
        user:transicao_sit3(s1, s2, Acao),
        user:acao(Acao, S1, Resultado),
        user:igual_estado(Resultado, S2)
    )).

test(sit3_s2_para_s3) :-
    once((
        user:estado_sit3_s2(S2),
        user:estado_sit3_s3(S3),
        user:transicao_sit3(s2, s3, Acao),
        user:acao(Acao, S2, Resultado),
        user:igual_estado(Resultado, S3)
    )).

test(sit3_s3_para_s4) :-
    once((
        user:estado_sit3_s3(S3),
        user:estado_sit3_s4(S4),
        user:transicao_sit3(s3, s4, Acao),
        user:acao(Acao, S3, Resultado),
        user:igual_estado(Resultado, S4)
    )).

test(sit3_s4_para_s5) :-
    once((
        user:estado_sit3_s4(S4),
        user:estado_sit3_s5(S5),
        user:transicao_sit3(s4, s5, Acao),
        user:acao(Acao, S4, Resultado),
        user:igual_estado(Resultado, S5)
    )).

test(sit3_s5_e_s6_sao_iguais_no_desenho) :-
    once((
        user:estado_sit3_s5(S5),
        user:estado_sit3_s6(S6),
        user:igual_estado(S5, S6)
    )).

test(sit3_s6_para_s7) :-
    once((
        user:estado_sit3_s6(S6),
        user:estado_sit3_s7(S7),
        user:transicao_sit3(s6, s7, Acao),
        user:acao(Acao, S6, Resultado),
        user:igual_estado(Resultado, S7)
    )).


% ------------------------------------------------------------
% Teste do plano manual completo da Situacao 3
% ------------------------------------------------------------

test(plano_manual_sit3_s0_ate_s7_funciona) :-
    once((
        user:estado_sit3_s0(S0),
        user:estado_sit3_s7(Objetivo),
        user:plano_manual_sit3_s0_s7(Plano),
        user:aplica_plano(S0, Plano, Final),
        user:igual_estado(Final, Objetivo)
    )).


:- end_tests(situacao3).