% ============================================================
% Trabalho de IA - Mundo dos Blocos com Dimensoes Diferentes
% Arquivo principal: regras gerais do dominio
%
% Versao corrigida do planejador:
% - mantem planejamento por regressao;
% - evita travamento por explosao combinatoria;
% - ordena predecessores por proximidade com o estado inicial;
% - limita a busca por profundidade;
% - mantem plano/3, planos/3 e plano_parcial/4;
% - calcula altura maxima pela soma das alturas dos blocos.
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

tamanho(B, T) :-
    largura(B, T).

altura(a, 1).
altura(b, 1).
altura(c, 1).
altura(d, 1).

limite_mesa(0, 6).

max_profundidade(12).


% ============================================================
% 2. Geometria basica
% ============================================================

altura_maxima(MaxY) :-
    findall(H, (bloco(B), altura(B, H)), Alturas),
    sum_list(Alturas, MaxY).

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
    intervalos_sobrepoem(Y1, Y1Fim, X2Fim, Y2Fim),
    fail.

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
% 3. Apoio e equilibrio
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

centro_bloco(B, X, Centro2) :-
    largura(B, L),
    Centro2 is 2*X + L.

centro_dentro_intervalo(Centro2, Min, Max) :-
    Centro2 >= 2*Min,
    Centro2 =< 2*Max.

apoio_valido(_B, _X, 0, _Estado) :- !.

apoio_valido(B, X, Y, Estado) :-
    Y > 0,

    findall(Seg, segmento_apoio(B, X, Y, Estado, Seg), Segmentos),
    Segmentos \= [],

    limites_dos_segmentos(Segmentos, MinApoio, MaxApoio),

    centro_bloco(B, X, Centro2),
    centro_dentro_intervalo(Centro2, MinApoio, MaxApoio).


% ============================================================
% 4. Validade de estado
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
% 5. Bloco livre
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
% 6. Movimento
% ============================================================

precondicoes_move(move(B, p(X0,Y0), p(X,Y)), Estado, Precondicoes) :-
    Precondicoes = [
        bloco_no_estado(B, X0, Y0),
        bloco_livre(B),
        coordenada_x_valida(B, X),
        coordenada_y_candidata(Y),
        movimento_altera_posicao(p(X0,Y0), p(X,Y)),
        estado_resultante_valido
    ],
    member(pos(B, X0, Y0), Estado),
    bloco_livre(B, Estado),
    coord_x(B, X),
    coord_y(Y),
    (X =\= X0 ; Y =\= Y0).

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
% 7. Normalizacao e comparacao de estados
% ============================================================

normaliza_estado(Estado, EstadoNormalizado) :-
    sort(Estado, EstadoNormalizado).

igual_estado(E1, E2) :-
    normaliza_estado(E1, N),
    normaliza_estado(E2, N).


% ============================================================
% 8. Aplicacao de planos
% ============================================================

aplica_plano(Estado, [], Final) :-
    normaliza_estado(Estado, Final).

aplica_plano(Estado, [Acao|Resto], Final) :-
    acao(Acao, Estado, Proximo),
    aplica_plano(Proximo, Resto, Final).


% ============================================================
% 9. Planejador automatico por regressao controlada
% ============================================================

plano(Inicio, Objetivo, Plano) :-
    normaliza_estado(Inicio, I),
    normaliza_estado(Objetivo, G),

    max_profundidade(Max),
    between(0, Max, Limite),

    regressao_limite(I, G, [G], Limite, PlanoReverso),
    reverse(PlanoReverso, Plano),
    !.

planos(Inicio, Objetivo, Plano) :-
    plano(Inicio, Objetivo, Plano).

plano_com_limite(Inicio, Objetivo, Limite, Plano) :-
    normaliza_estado(Inicio, I),
    normaliza_estado(Objetivo, G),
    regressao_limite(I, G, [G], Limite, PlanoReverso),
    reverse(PlanoReverso, Plano).

regressao_limite(Inicio, EstadoAtual, _Visitados, _Limite, []) :-
    igual_estado(Inicio, EstadoAtual).

regressao_limite(Inicio, EstadoAtual, Visitados, Limite, [Acao|PlanoReverso]) :-
    Limite > 0,

    predecessores_ordenados(Inicio, EstadoAtual, Visitados, Candidatos),
    member(candidato(EstadoAnterior, Acao), Candidatos),

    Limite1 is Limite - 1,
    regressao_limite(Inicio, EstadoAnterior, [EstadoAnterior|Visitados], Limite1, PlanoReverso).


% ------------------------------------------------------------
% predecessores_ordenados(+Inicio, +EstadoAtual, +Visitados, ?Candidatos)
%
% Gera todos os predecessores imediatos possiveis de EstadoAtual,
% remove estados ja visitados e ordena os candidatos por proximidade
% com Inicio.
%
% Isso evita o comportamento de "parece loop infinito", pois o Prolog
% nao tenta explorar cegamente predecessores pouco promissores antes
% dos predecessores que realmente se aproximam do estado inicial.
% ------------------------------------------------------------

predecessores_ordenados(Inicio, EstadoAtual, Visitados, CandidatosOrdenados) :-
    findall(
        Score-candidato(EstadoAnterior, Acao),
        (
            predecessor_por_regressao(EstadoAnterior, Acao, EstadoAtual),
            \+ memberchk(EstadoAnterior, Visitados),
            pontuacao_proximidade(EstadoAnterior, Inicio, Score)
        ),
        Pares
    ),
    sort(Pares, ParesOrdenadosCrescentes),
    reverse(ParesOrdenadosCrescentes, ParesOrdenadosDecrescentes),
    extrai_candidatos(ParesOrdenadosDecrescentes, CandidatosOrdenados).


extrai_candidatos([], []).

extrai_candidatos([_Score-Candidato|Resto], [Candidato|Outros]) :-
    extrai_candidatos(Resto, Outros).


% ------------------------------------------------------------
% predecessor_por_regressao(?EstadoAnterior, ?Acao, +EstadoAtual)
%
% Gera predecessor alterando exatamente um bloco por vez.
% EstadoAtual deve estar suficientemente instanciado.
% ------------------------------------------------------------

predecessor_por_regressao(EstadoAnterior, Acao, EstadoAtual) :-
    normaliza_estado(EstadoAtual, AtualNorm),

    select(pos(B, X, Y), AtualNorm, Restante),

    coord_x(B, X0),
    coord_y(Y0),

    (X0 =\= X ; Y0 =\= Y),

    EstadoAnteriorTentativo = [pos(B, X0, Y0)|Restante],

    estado_valido(EstadoAnteriorTentativo),

    normaliza_estado(EstadoAnteriorTentativo, EstadoAnterior),

    Acao = move(B, p(X0,Y0), p(X,Y)),

    acao(Acao, EstadoAnterior, Resultado),

    igual_estado(Resultado, AtualNorm).


% ------------------------------------------------------------
% pontuacao_proximidade(+Estado, +Inicio, ?Score)
%
% Quanto maior o score, mais posicoes do Estado coincidem com Inicio.
% A regressao deve preferir predecessores mais parecidos com Inicio.
% ------------------------------------------------------------

pontuacao_proximidade(Estado, Inicio, Score) :-
    normaliza_estado(Estado, E),
    normaliza_estado(Inicio, I),
    findall(
        Pos,
        (
            member(Pos, E),
            member(Pos, I)
        ),
        Iguais
    ),
    length(Iguais, Score).


% ============================================================
% 10. Plano parcialmente ordenado
% ============================================================

plano_parcial(Inicio, Objetivo, pop(Passos, Ordem), PlanoLinear) :-
    plano(Inicio, Objetivo, PlanoLinear),
    constroi_passos_pop(PlanoLinear, Passos),
    constroi_ordem_pop(Passos, Ordem).

constroi_passos_pop(PlanoLinear, Passos) :-
    PassoInicio = passo(0, inicio),
    constroi_passos_acoes(PlanoLinear, 1, PassosAcoes, ProximoIndice),
    PassoObjetivo = passo(ProximoIndice, objetivo),
    append([PassoInicio|PassosAcoes], [PassoObjetivo], Passos).

constroi_passos_acoes([], Indice, [], Indice).

constroi_passos_acoes([Acao|Resto], Indice, [passo(Indice, Acao)|Passos], ProximoIndice) :-
    Indice1 is Indice + 1,
    constroi_passos_acoes(Resto, Indice1, Passos, ProximoIndice).

constroi_ordem_pop(Passos, Ordem) :-
    findall(
        antes(I, J),
        (
            member(passo(I, _), Passos),
            J is I + 1,
            member(passo(J, _), Passos)
        ),
        Ordem
    ).


% ============================================================
% 11. Visualizacao
% ============================================================

mostra_estado(Estado) :-
    normaliza_estado(Estado, Ordenado),
    forall(
        member(Pos, Ordenado),
        (write(Pos), nl)
    ).

mostra_plano([]).

mostra_plano([Acao|Resto]) :-
    write(Acao),
    nl,
    mostra_plano(Resto).


% ============================================================
% 12. Testes das regras gerais
% ============================================================

:- begin_tests(regras_gerais).

test(tamanho_e_sinonimo_de_largura) :-
    tamanho(d, 3).

test(d_cabe_na_mesa_em_x3) :-
    dentro_da_mesa(d, 3).

test(d_nao_cabe_na_mesa_em_x4, [fail]) :-
    dentro_da_mesa(d, 4).

test(altura_maxima_calculada_pela_soma_das_alturas) :-
    altura_maxima(4).

test(centro_geometrico_de_d_em_x3) :-
    centro_bloco(d, 3, 9).

test(configuracao_generica_valida) :-
    once((
        Estado = [
            pos(c,0,0),
            pos(d,3,0),
            pos(a,0,1),
            pos(b,1,1)
        ],
        estado_valido(Estado)
    )).

:- end_tests(regras_gerais).