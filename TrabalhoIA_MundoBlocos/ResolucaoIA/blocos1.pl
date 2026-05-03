% ============================================================
% Situacao 1 do Trabalho de IA - Mundo dos Blocos
%
% Este arquivo complementa blocos.pl.
% - mantem os estados e o plano manual da Situacao 1;
% - adiciona testes diretos do planejador por regressao com plano/3;
% - adiciona teste do alias planos/3.
% ============================================================

:- ensure_loaded('blocos.pl').


% ============================================================
% 1. Estados da Situacao 1
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


estado_sit1(s0, S)  :- estado_sit1_s0(S).
estado_sit1(sf1, S) :- estado_sit1_sf1(S).
estado_sit1(sf2, S) :- estado_sit1_sf2(S).
estado_sit1(sf3, S) :- estado_sit1_sf3(S).
estado_sit1(sf4, S) :- estado_sit1_sf4(S).


% ============================================================
% 2. Plano manual da Situacao 1
% ============================================================
%
% Plano escolhido:
%
%   S0 -> Sf4
%
% Ideia:
% 1. Tirar d de cima de a e b, colocando d temporariamente sobre c.
% 2. Mover a para cima de b.
% 3. Colocar d na base entre c e b.
% 4. Colocar a sobre c.
% ============================================================

plano_manual_sit1_s0_sf4([
    move(d, p(3,1), p(0,1)),
    move(a, p(3,0), p(5,1)),
    move(d, p(0,1), p(2,0)),
    move(a, p(5,1), p(0,1))
]).


plano_manual_s0_sf4(Plano) :-
    plano_manual_sit1_s0_sf4(Plano).

% ============================================================
% 4. Testes da Situacao 1
% ============================================================

:- begin_tests(situacao1).


% ------------------------------------------------------------
% Testes de validade dos estados da Situacao 1
% ------------------------------------------------------------

test(sit1_s0_valido) :-
    once((
        user:estado_sit1_s0(S),
        user:estado_valido(S)
    )).

test(sit1_sf1_valido) :-
    once((
        user:estado_sit1_sf1(S),
        user:estado_valido(S)
    )).

test(sit1_sf2_valido) :-
    once((
        user:estado_sit1_sf2(S),
        user:estado_valido(S)
    )).

test(sit1_sf3_valido) :-
    once((
        user:estado_sit1_sf3(S),
        user:estado_valido(S)
    )).

test(sit1_sf4_valido) :-
    once((
        user:estado_sit1_sf4(S),
        user:estado_valido(S)
    )).


% ------------------------------------------------------------
% Testes de ocupacao espacial no S0
% ------------------------------------------------------------

test(d_ocupa_intervalo_correto_no_s0) :-
    once((
        user:estado_sit1_s0(S),
        user:ocupa(d, S, 3, 6, 1, 2)
    )).

test(c_ocupa_intervalo_correto_no_s0) :-
    once((
        user:estado_sit1_s0(S),
        user:ocupa(c, S, 0, 2, 0, 1)
    )).


% ------------------------------------------------------------
% Testes de blocos livres no S0
% ------------------------------------------------------------

test(d_livre_no_s0) :-
    once((
        user:estado_sit1_s0(S),
        user:bloco_livre(d, S)
    )).

test(c_livre_no_s0) :-
    once((
        user:estado_sit1_s0(S),
        user:bloco_livre(c, S)
    )).

test(a_nao_livre_no_s0, [fail]) :-
    user:estado_sit1_s0(S),
    user:bloco_livre(a, S).

test(b_nao_livre_no_s0, [fail]) :-
    user:estado_sit1_s0(S),
    user:bloco_livre(b, S).


% ------------------------------------------------------------
% Teste de existencia de movimento valido
% ------------------------------------------------------------

test(existe_acao_movendo_d_no_s0) :-
    once((
        user:estado_sit1_s0(S),
        user:acao(move(d, p(3,1), p(_,_)), S, _)
    )).


% ------------------------------------------------------------
% Teste das precondicoes explicativas
% ------------------------------------------------------------

test(precondicoes_de_move_sao_consultaveis) :-
    once((
        user:estado_sit1_s0(S),
        user:precondicoes_move(
            move(d, p(3,1), p(0,1)),
            S,
            Precondicoes
        ),
        member(bloco_livre(d), Precondicoes),
        member(estado_resultante_valido, Precondicoes)
    )).


% ------------------------------------------------------------
% Teste do centro geometrico
% ------------------------------------------------------------

test(centro_geometrico_de_d_em_x3) :-
    user:centro_bloco(d, 3, 9).


% ------------------------------------------------------------
% Teste do plano manual completo
% ------------------------------------------------------------

test(plano_manual_sit1_s0_ate_sf4_funciona) :-
    once((
        user:estado_sit1_s0(S0),
        user:estado_sit1_sf4(Objetivo),
        user:plano_manual_sit1_s0_sf4(Plano),
        user:aplica_plano(S0, Plano, Final),
        user:igual_estado(Final, Objetivo)
    )).


% ------------------------------------------------------------
% Testes diretos do planejador automatico por regressao
% ------------------------------------------------------------

test(planejador_regressivo_gera_plano_sit1_s0_ate_sf4) :-
    once((
        user:estado_sit1_s0(S0),
        user:estado_sit1_sf4(Objetivo),
        user:plano(S0, Objetivo, PlanoGerado),
        user:aplica_plano(S0, PlanoGerado, Final),
        user:igual_estado(Final, Objetivo)
    )).


test(alias_planos_gera_plano_sit1_s0_ate_sf4) :-
    once((
        user:estado_sit1_s0(S0),
        user:estado_sit1_sf4(Objetivo),
        user:planos(S0, Objetivo, PlanoGerado),
        user:aplica_plano(S0, PlanoGerado, Final),
        user:igual_estado(Final, Objetivo)
    )).


test(plano_parcial_sit1_possui_passos_e_ordem) :-
    once((
        user:estado_sit1_s0(S0),
        user:estado_sit1_sf4(Objetivo),
        user:plano_parcial(S0, Objetivo, pop(Passos, Ordem), PlanoGerado),
        PlanoGerado \= [],
        member(passo(0, inicio), Passos),
        member(antes(0, 1), Ordem),
        user:aplica_plano(S0, PlanoGerado, Final),
        user:igual_estado(Final, Objetivo)
    )).


:- end_tests(situacao1).