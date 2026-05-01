% ============================================================
% Situacoes 2 e 3 do Trabalho de IA - Mundo dos Blocos
%
% Este arquivo complementa blocos.pl.
% Ele nao redefine a logica principal.
% Ele apenas adiciona:
% - estados da Situacao 2
% - estados da Situacao 3
% - transicoes manuais
% - planos manuais de referencia
% - testes
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


% Predicado auxiliar para consultar estados da Situacao 2 por rotulo.
% Exemplo:
%
%   estado_sit2(s3, S).

estado_sit2(s0, S) :- estado_sit2_s0(S).
estado_sit2(s1, S) :- estado_sit2_s1(S).
estado_sit2(s2, S) :- estado_sit2_s2(S).
estado_sit2(s3, S) :- estado_sit2_s3(S).
estado_sit2(s4, S) :- estado_sit2_s4(S).
estado_sit2(s5, S) :- estado_sit2_s5(S).


% ============================================================
% 2. Estados da Situacao 3
% ============================================================
%
% A Situacao 3 aparece na pagina 6 do enunciado.
%
% O S0 da Situacao 3 e o mesmo S0 que ja usamos na Situacao 1:
%
% c na base em [0,2)
% a na base em [3,4)
% b na base em [5,6)
% d sobre a e b, ocupando [3,6)
%
% Mesmo assim, vamos declarar estado_sit3_s0/1 explicitamente
% para deixar o arquivo completo e facil de ler.


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


% Predicado auxiliar para consultar estados da Situacao 3 por rotulo.
% Exemplo:
%
%   estado_sit3(s7, S).

estado_sit3(s0, S) :- estado_sit3_s0(S).
estado_sit3(s1, S) :- estado_sit3_s1(S).
estado_sit3(s2, S) :- estado_sit3_s2(S).
estado_sit3(s3, S) :- estado_sit3_s3(S).
estado_sit3(s4, S) :- estado_sit3_s4(S).
estado_sit3(s5, S) :- estado_sit3_s5(S).
estado_sit3(s6, S) :- estado_sit3_s6(S).
estado_sit3(s7, S) :- estado_sit3_s7(S).


% ============================================================
% 3. Transicoes manuais da Situacao 2
% ============================================================
%
% Estas transicoes representam uma leitura manual possivel
% do caminho mostrado na Situacao 2.
%
% transicao_sit2(EstadoOrigem, EstadoDestino, Acao).
%
% A acao sempre tem a forma:
%
%   move(Bloco, p(XAntigo,YAntigo), p(XNovo,YNovo))


transicao_sit2(s0, s1, move(b, p(1,1), p(2,0))).
transicao_sit2(s1, s2, move(a, p(0,1), p(2,1))).
transicao_sit2(s2, s3, move(c, p(0,0), p(4,1))).
transicao_sit2(s3, s4, move(a, p(2,1), p(4,2))).
transicao_sit2(s4, s5, move(b, p(2,0), p(5,2))).


% Plano manual completo da Situacao 2:
% S0 -> S1 -> S2 -> S3 -> S4 -> S5

plano_manual_sit2_s0_s5([
    move(b, p(1,1), p(2,0)),
    move(a, p(0,1), p(2,1)),
    move(c, p(0,0), p(4,1)),
    move(a, p(2,1), p(4,2)),
    move(b, p(2,0), p(5,2))
]).


% ============================================================
% 4. Transicoes manuais da Situacao 3
% ============================================================
%
% Na Situacao 3, S5 e S6 aparecem iguais no desenho.
% Por isso nao existe uma transicao move(...) entre S5 e S6.
%
% O plano que vai ate S7 passa pela configuracao de S5/S6
% e depois move d de X=2 para X=3.


transicao_sit3(s0, s1, move(d, p(3,1), p(0,1))).
transicao_sit3(s1, s2, move(a, p(3,0), p(5,1))).
transicao_sit3(s2, s3, move(d, p(0,1), p(2,0))).
transicao_sit3(s3, s4, move(a, p(5,1), p(0,1))).
transicao_sit3(s4, s5, move(b, p(5,0), p(1,1))).
transicao_sit3(s6, s7, move(d, p(2,0), p(3,0))).


% Plano manual completo da Situacao 3:
% S0 -> S1 -> S2 -> S3 -> S4 -> S5/S6 -> S7

plano_manual_sit3_s0_s7([
    move(d, p(3,1), p(0,1)),
    move(a, p(3,0), p(5,1)),
    move(d, p(0,1), p(2,0)),
    move(a, p(5,1), p(0,1)),
    move(b, p(5,0), p(1,1)),
    move(d, p(2,0), p(3,0))
]).


% ============================================================
% 5. Predicados auxiliares para visualizacao no terminal
% ============================================================

% mostra_estado(+Estado)
%
% Mostra o estado em uma ordem padronizada.
% Isso facilita a leitura no terminal.

mostra_estado(Estado) :-
    user:normaliza_estado(Estado, Ordenado),
    forall(
        member(Pos, Ordenado),
        (write(Pos), nl)
    ).


% mostra_plano(+Plano)
%
% Mostra cada acao do plano em uma linha.

mostra_plano([]).

mostra_plano([Acao|Resto]) :-
    write(Acao),
    nl,
    mostra_plano(Resto).


% ============================================================
% 6. Testes das Situacoes 2 e 3
% ============================================================

:- begin_tests(situacoes_2_3).


% ------------------------------------------------------------
% Testes de validade dos estados da Situacao 2
% ------------------------------------------------------------

test(sit2_s0_valido) :-
    once((
        estado_sit2_s0(S),
        user:estado_valido(S)
    )).

test(sit2_s1_valido) :-
    once((
        estado_sit2_s1(S),
        user:estado_valido(S)
    )).

test(sit2_s2_valido) :-
    once((
        estado_sit2_s2(S),
        user:estado_valido(S)
    )).

test(sit2_s3_valido) :-
    once((
        estado_sit2_s3(S),
        user:estado_valido(S)
    )).

test(sit2_s4_valido) :-
    once((
        estado_sit2_s4(S),
        user:estado_valido(S)
    )).

test(sit2_s5_valido) :-
    once((
        estado_sit2_s5(S),
        user:estado_valido(S)
    )).


% ------------------------------------------------------------
% Testes de validade dos estados da Situacao 3
% ------------------------------------------------------------

test(sit3_s0_valido) :-
    once((
        estado_sit3_s0(S),
        user:estado_valido(S)
    )).

test(sit3_s1_valido) :-
    once((
        estado_sit3_s1(S),
        user:estado_valido(S)
    )).

test(sit3_s2_valido) :-
    once((
        estado_sit3_s2(S),
        user:estado_valido(S)
    )).

test(sit3_s3_valido) :-
    once((
        estado_sit3_s3(S),
        user:estado_valido(S)
    )).

test(sit3_s4_valido) :-
    once((
        estado_sit3_s4(S),
        user:estado_valido(S)
    )).

test(sit3_s5_valido) :-
    once((
        estado_sit3_s5(S),
        user:estado_valido(S)
    )).

test(sit3_s6_valido) :-
    once((
        estado_sit3_s6(S),
        user:estado_valido(S)
    )).

test(sit3_s7_valido) :-
    once((
        estado_sit3_s7(S),
        user:estado_valido(S)
    )).


% ------------------------------------------------------------
% Testes das transicoes da Situacao 2
% ------------------------------------------------------------

test(sit2_s0_para_s1) :-
    once((
        estado_sit2_s0(S0),
        estado_sit2_s1(S1),
        transicao_sit2(s0, s1, Acao),
        user:acao(Acao, S0, Resultado),
        user:igual_estado(Resultado, S1)
    )).

test(sit2_s1_para_s2) :-
    once((
        estado_sit2_s1(S1),
        estado_sit2_s2(S2),
        transicao_sit2(s1, s2, Acao),
        user:acao(Acao, S1, Resultado),
        user:igual_estado(Resultado, S2)
    )).

test(sit2_s2_para_s3) :-
    once((
        estado_sit2_s2(S2),
        estado_sit2_s3(S3),
        transicao_sit2(s2, s3, Acao),
        user:acao(Acao, S2, Resultado),
        user:igual_estado(Resultado, S3)
    )).

test(sit2_s3_para_s4) :-
    once((
        estado_sit2_s3(S3),
        estado_sit2_s4(S4),
        transicao_sit2(s3, s4, Acao),
        user:acao(Acao, S3, Resultado),
        user:igual_estado(Resultado, S4)
    )).

test(sit2_s4_para_s5) :-
    once((
        estado_sit2_s4(S4),
        estado_sit2_s5(S5),
        transicao_sit2(s4, s5, Acao),
        user:acao(Acao, S4, Resultado),
        user:igual_estado(Resultado, S5)
    )).


% ------------------------------------------------------------
% Testes das transicoes da Situacao 3
% ------------------------------------------------------------

test(sit3_s0_para_s1) :-
    once((
        estado_sit3_s0(S0),
        estado_sit3_s1(S1),
        transicao_sit3(s0, s1, Acao),
        user:acao(Acao, S0, Resultado),
        user:igual_estado(Resultado, S1)
    )).

test(sit3_s1_para_s2) :-
    once((
        estado_sit3_s1(S1),
        estado_sit3_s2(S2),
        transicao_sit3(s1, s2, Acao),
        user:acao(Acao, S1, Resultado),
        user:igual_estado(Resultado, S2)
    )).

test(sit3_s2_para_s3) :-
    once((
        estado_sit3_s2(S2),
        estado_sit3_s3(S3),
        transicao_sit3(s2, s3, Acao),
        user:acao(Acao, S2, Resultado),
        user:igual_estado(Resultado, S3)
    )).

test(sit3_s3_para_s4) :-
    once((
        estado_sit3_s3(S3),
        estado_sit3_s4(S4),
        transicao_sit3(s3, s4, Acao),
        user:acao(Acao, S3, Resultado),
        user:igual_estado(Resultado, S4)
    )).

test(sit3_s4_para_s5) :-
    once((
        estado_sit3_s4(S4),
        estado_sit3_s5(S5),
        transicao_sit3(s4, s5, Acao),
        user:acao(Acao, S4, Resultado),
        user:igual_estado(Resultado, S5)
    )).

test(sit3_s5_e_s6_sao_iguais_no_desenho) :-
    once((
        estado_sit3_s5(S5),
        estado_sit3_s6(S6),
        user:igual_estado(S5, S6)
    )).

test(sit3_s6_para_s7) :-
    once((
        estado_sit3_s6(S6),
        estado_sit3_s7(S7),
        transicao_sit3(s6, s7, Acao),
        user:acao(Acao, S6, Resultado),
        user:igual_estado(Resultado, S7)
    )).


% ------------------------------------------------------------
% Testes dos planos manuais completos
% ------------------------------------------------------------

test(plano_manual_sit2_s0_ate_s5_funciona) :-
    once((
        estado_sit2_s0(S0),
        estado_sit2_s5(Objetivo),
        plano_manual_sit2_s0_s5(Plano),
        user:aplica_plano(S0, Plano, Final),
        user:igual_estado(Final, Objetivo)
    )).

test(plano_manual_sit3_s0_ate_s7_funciona) :-
    once((
        estado_sit3_s0(S0),
        estado_sit3_s7(Objetivo),
        plano_manual_sit3_s0_s7(Plano),
        user:aplica_plano(S0, Plano, Final),
        user:igual_estado(Final, Objetivo)
    )).


:- end_tests(situacoes_2_3).