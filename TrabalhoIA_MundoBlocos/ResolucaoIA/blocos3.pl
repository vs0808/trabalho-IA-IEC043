% ============================================================
% Situacao 3 do Trabalho de IA - Mundo dos Blocos
%
% Este arquivo complementa blocos.pl.
% - mantem os estados, transicoes e plano manual;
% - adiciona teste direto do planejador por regressao com plano/3.
% ============================================================

:- ensure_loaded('blocos.pl').


% ============================================================
% 1. Estados da Situacao 3
% ============================================================

estado_sit3_s0([
    pos(c,0,0),
    pos(a,3,0),
    pos(b,5,0),
    pos(d,3,1)
]).


estado_sit3_s1([
    pos(c,0,0),
    pos(d,0,1),
    pos(a,3,0),
    pos(b,5,0)
]).


estado_sit3_s2([
    pos(c,0,0),
    pos(d,0,1),
    pos(b,5,0),
    pos(a,5,1)
]).


estado_sit3_s3([
    pos(c,0,0),
    pos(d,2,0),
    pos(b,5,0),
    pos(a,5,1)
]).


estado_sit3_s4([
    pos(c,0,0),
    pos(d,2,0),
    pos(b,5,0),
    pos(a,0,1)
]).


estado_sit3_s5([
    pos(c,0,0),
    pos(d,2,0),
    pos(a,0,1),
    pos(b,1,1)
]).


% No desenho da pagina 6, S5 e S6 aparecem com a mesma configuracao.
% Por isso, neste modelo, S6 e representado igual a S5.
estado_sit3_s6([
    pos(c,0,0),
    pos(d,2,0),
    pos(a,0,1),
    pos(b,1,1)
]).


estado_sit3_s7([
    pos(c,0,0),
    pos(d,3,0),
    pos(a,0,1),
    pos(b,1,1)
]).


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

transicao_sit3(s0, s1, move(d, p(3,1), p(0,1))).
transicao_sit3(s1, s2, move(a, p(3,0), p(5,1))).
transicao_sit3(s2, s3, move(d, p(0,1), p(2,0))).
transicao_sit3(s3, s4, move(a, p(5,1), p(0,1))).
transicao_sit3(s4, s5, move(b, p(5,0), p(1,1))).
transicao_sit3(s6, s7, move(d, p(2,0), p(3,0))).


% ============================================================
% 3. Plano manual completo da Situacao 3
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


% ------------------------------------------------------------
% Teste direto do planejador automatico por regressao
% ------------------------------------------------------------

test(planejador_regressivo_gera_plano_sit3_s0_ate_s7) :-
    once((
        user:estado_sit3_s0(S0),
        user:estado_sit3_s7(Objetivo),
        user:plano(S0, Objetivo, PlanoGerado),
        user:aplica_plano(S0, PlanoGerado, Final),
        user:igual_estado(Final, Objetivo)
    )).


test(plano_parcial_sit3_possui_passos_e_ordem) :-
    once((
        user:estado_sit3_s0(S0),
        user:estado_sit3_s7(Objetivo),
        user:plano_parcial(S0, Objetivo, pop(Passos, Ordem), PlanoGerado),
        PlanoGerado \= [],
        member(passo(0, inicio), Passos),
        member(antes(0, 1), Ordem),
        user:aplica_plano(S0, PlanoGerado, Final),
        user:igual_estado(Final, Objetivo)
    )).


:- end_tests(situacao3).