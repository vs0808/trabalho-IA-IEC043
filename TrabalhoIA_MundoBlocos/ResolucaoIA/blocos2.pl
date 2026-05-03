% ============================================================
% Situacao 2 do Trabalho de IA - Mundo dos Blocos
%
% Este arquivo complementa blocos.pl.
% - mantem os estados, transicoes e plano manual;
% - adiciona teste direto do planejador por regressao com plano/3;
% - tambem testa o alias planos/3 e a estrutura plano_parcial/4.
% ============================================================

:- ensure_loaded('blocos.pl').


% ============================================================
% 1. Estados da Situacao 2
% ============================================================

estado_sit2_s0([
    pos(c,0,0),
    pos(a,0,1),
    pos(b,1,1),
    pos(d,3,0)
]).

estado_sit2_s1([
    pos(c,0,0),
    pos(a,0,1),
    pos(b,2,0),
    pos(d,3,0)
]).

estado_sit2_s2([
    pos(c,0,0),
    pos(b,2,0),
    pos(a,2,1),
    pos(d,3,0)
]).

estado_sit2_s3([
    pos(b,2,0),
    pos(a,2,1),
    pos(d,3,0),
    pos(c,4,1)
]).

estado_sit2_s4([
    pos(b,2,0),
    pos(d,3,0),
    pos(c,4,1),
    pos(a,4,2)
]).

estado_sit2_s5([
    pos(d,3,0),
    pos(c,4,1),
    pos(a,4,2),
    pos(b,5,2)
]).

estado_sit2(s0, S) :- estado_sit2_s0(S).
estado_sit2(s1, S) :- estado_sit2_s1(S).
estado_sit2(s2, S) :- estado_sit2_s2(S).
estado_sit2(s3, S) :- estado_sit2_s3(S).
estado_sit2(s4, S) :- estado_sit2_s4(S).
estado_sit2(s5, S) :- estado_sit2_s5(S).


% ============================================================
% 2. Transicoes manuais da Situacao 2
% ============================================================

transicao_sit2(s0, s1, move(b, p(1,1), p(2,0))).
transicao_sit2(s1, s2, move(a, p(0,1), p(2,1))).
transicao_sit2(s2, s3, move(c, p(0,0), p(4,1))).
transicao_sit2(s3, s4, move(a, p(2,1), p(4,2))).
transicao_sit2(s4, s5, move(b, p(2,0), p(5,2))).


% ============================================================
% 3. Plano manual completo da Situacao 2
% ============================================================

plano_manual_sit2_s0_s5([
    move(b, p(1,1), p(2,0)),
    move(a, p(0,1), p(2,1)),
    move(c, p(0,0), p(4,1)),
    move(a, p(2,1), p(4,2)),
    move(b, p(2,0), p(5,2))
]).


% ============================================================
% 4. Testes da Situacao 2
% ============================================================

:- begin_tests(situacao2).

test(sit2_s0_valido) :-
    once((user:estado_sit2_s0(S), user:estado_valido(S))).

test(sit2_s1_valido) :-
    once((user:estado_sit2_s1(S), user:estado_valido(S))).

test(sit2_s2_valido) :-
    once((user:estado_sit2_s2(S), user:estado_valido(S))).

test(sit2_s3_valido) :-
    once((user:estado_sit2_s3(S), user:estado_valido(S))).

test(sit2_s4_valido) :-
    once((user:estado_sit2_s4(S), user:estado_valido(S))).

test(sit2_s5_valido) :-
    once((user:estado_sit2_s5(S), user:estado_valido(S))).

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

test(plano_manual_sit2_s0_ate_s5_funciona) :-
    once((
        user:estado_sit2_s0(S0),
        user:estado_sit2_s5(Objetivo),
        user:plano_manual_sit2_s0_s5(Plano),
        user:aplica_plano(S0, Plano, Final),
        user:igual_estado(Final, Objetivo)
    )).

test(planejador_regressivo_gera_plano_sit2_s0_ate_s5) :-
    once((
        user:estado_sit2_s0(S0),
        user:estado_sit2_s5(Objetivo),
        user:plano(S0, Objetivo, PlanoGerado),
        user:aplica_plano(S0, PlanoGerado, Final),
        user:igual_estado(Final, Objetivo)
    )).

test(alias_planos_gera_plano_sit2_s0_ate_s5) :-
    once((
        user:estado_sit2_s0(S0),
        user:estado_sit2_s5(Objetivo),
        user:planos(S0, Objetivo, PlanoGerado),
        user:aplica_plano(S0, PlanoGerado, Final),
        user:igual_estado(Final, Objetivo)
    )).

test(plano_parcial_sit2_possui_passos_e_ordem) :-
    once((
        user:estado_sit2_s0(S0),
        user:estado_sit2_s5(Objetivo),
        user:plano_parcial(S0, Objetivo, pop(Passos, Ordem), PlanoGerado),
        PlanoGerado \= [],
        member(passo(0, inicio), Passos),
        member(antes(0, 1), Ordem),
        user:aplica_plano(S0, PlanoGerado, Final),
        user:igual_estado(Final, Objetivo)
    )).

:- end_tests(situacao2).