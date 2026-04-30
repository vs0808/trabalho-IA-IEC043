% Arquivo: prolog/teste.pl
% Teste inicial de SWI-Prolog

bloco(a).
bloco(b).
bloco(c).
bloco(d).

sobre(b, a).
sobre(a, mesa).

% X está acima de Y se X está diretamente sobre Y.
acima(X, Y) :-
    sobre(X, Y).

% X está acima de Y se X está sobre Z,
% e Z está acima de Y.
acima(X, Y) :-
    sobre(X, Z),
    acima(Z, Y).

:- begin_tests(basico).

test(existe_bloco_a) :-
    bloco(a).

test(b_sobre_a) :-
    sobre(b, a).

test(b_acima_da_mesa) :-
    once(acima(b, mesa)).

:- end_tests(basico).
