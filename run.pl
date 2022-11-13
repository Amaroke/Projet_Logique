:- dynamic echo_on/0. % On informe l'interpréteur que la définition du prédicat change durant l'execution (pour éviter un warning de l'éditeur)

% Prédicats d'affichage fournis
% set_echo: ce prédicat active l'affichage par le prédicat echo
set_echo :- assert(echo_on).

% clr_echo: ce prédicat inhibe l'affichage par le prédicat echo
clr_echo :- retractall(echo_on).

% echo(T): si le flag echo_on est positionné, echo(T) affiche le terme T
%          sinon, echo(T) réussit simplement en ne faisant rien.
echo(T) :- echo_on, !, write(T).
echo(_).


% Définition de l'opérateur ?=
:- op(20, xfy, ?=).


% Question 1
% Définition des règles
% Définiton de la règle Rename
regle(X ?= T, rename) :- var(X), var(T).

% Définition de la règle Simplify
regle(X ?= T, simplify) :- var(X), atomic(T).

% Définition de la règle Expand
regle(X ?= T, expand) :- var(X), compound(T), \+occur_check(X, T).

% Défintion de la règle Check
regle(X ?= T, check) :- X \== T, var(X), compound(T), occur_check(X, T), !. 

% Définition de la règle Orient
regle(T ?= X, orient) :- nonvar(T), var(X).

% Définition de la règle Decompose
regle(X ?= Y, decompose) :- nonvar(X), nonvar(Y), functor(X, Name1, Arity1), functor(Y, Name2, Arity2),  Name1 == Name2, Arity1 == Arity2.

% Définition de la règle Clash
regle(X ?= Y, clash) :- nonvar(X), nonvar(Y), functor(X, Name1, Arity1), functor(Y, Name2, Arity2), (Name1 \== Name2; Arity1 \== Arity2), !.

% Définition de occur_check
occur_check(V, T) :- var(V), compound(T), arg(_, T, X), (V == X ; (compound(X), occur_check(V, X))), !.


% Définition des réductions
% Définition de réduction de Rename
reduit(rename, X ?= T, P, Q) :- X = T, Q = P.

% Définition de réduction de Simplify
reduit(simplify, X ?= T, P, Q) :- X = T, Q = P.

% Définition de réduction de Expand 
reduit(expand, X ?= T, P, Q) :- X = T, Q = P.

% Définition de réduction de Check
reduit(check, _, _, _) :- !, fail.

% Définition de réduction de Orient
reduit(orient, T ?= X, P, [X ?= T | P]).    

% Définition de réduction de Decompose
reduit(decompose, X ?= Y, P, Q) :- X =.. [_ | Args1], Y =.. [_ | Args2], remplace(Args1, Args2, Result), append(Result, P, Q).

% Définition de réduction de Clash
reduit(clash, _, _, _) :- !, fail.

% Définition de remplace qui pose récursivement l'unification de tous les termes un à un
remplace([], [], []). % Condition d'arrêt si les paramètres sont vides (pour éviter une boucle infinie)
remplace([A|Args1], [B|Args2], [A ?= B | Temp]) :- remplace(Args1, Args2, Temp).


% Définition de Unifie
unifie([]). % Condition d'arrêt
unifie([E|P]):- set_echo, trace_systeme([E|P]), regle(E, R),  trace_regle(E, R), reduit(R, E, P, Q), !, unifie(Q).


% Question 2
% Définition de Unifie
unifie([], _) :- echo('\n'), !. % Condition d'arrêt

% Définition de Unifie avec choix_premier
unifie([E|P], choix_premier) :- trace_systeme([E|P]), regle(E, R), trace_regle(E, R), reduit(R, E, P, Q), !, unifie(Q, _).

% Définition de Unifie avec choix_pondere_1
unifie(P, choix_pondere_1) :- ponderation_max(P, Q, _, _, [], ponderation1), !, unifie(Q, _).

% Définition de Unifie avec choix_pondere_2
unifie(P, choix_pondere_2) :- ponderation_max(P, Q, _, _, [], ponderation2), !, unifie(Q, _).

% Définition de Unifie avec choix_pondere_3
unifie(P, choix_pondere_3) :- ponderation_max(P, Q, _, _, [], ponderation3), !, unifie(Q, _).

% Définition de Unifie avec choix_aleatoire
unifie(P, choix_aleatoire) :-
    length(P, Len), random(0, Len, Random), nth0(Random, P, Equation, Reste),
    trace_systeme(P), regle(Equation, R), trace_regle(Equation, R), reduit(R, Equation, Reste, Q), !,
    unifie(Q, choix_aleatoire).

% Définition de ponderation_1 (clash, check > rename, simplify > orient > decompose > expand)
ponderation(ponderation1, E, 4, clash) :- regle(E, clash).
ponderation(ponderation1, E, 4, check) :- regle(E, check).
ponderation(ponderation1, E, 3, rename) :- regle(E, rename).
ponderation(ponderation1, E, 3, simplify) :- regle(E, simplify).
ponderation(ponderation1, E, 2, orient) :- regle(E, orient).
ponderation(ponderation1, E, 1, decompose) :- regle(E, decompose).
ponderation(ponderation1, E, 0, expand) :- regle(E, expand).

% Définition de ponderation_2 (clash, check > orient > decompose > rename, simplify > expand)
ponderation(ponderation2, E, 4, clash) :- regle(E, clash).
ponderation(ponderation2, E, 4, check) :- regle(E, check).
ponderation(ponderation2, E, 3, orient) :- regle(E, orient).
ponderation(ponderation2, E, 2, decompose) :- regle(E, decompose).
ponderation(ponderation2, E, 2, rename) :- regle(E, rename).
ponderation(ponderation2, E, 1, simplify) :- regle(E, simplify).
ponderation(ponderation2, E, 0, expand) :- regle(E, expand).

% Définition de ponderation_3 (clash, check > orient > decompose > expand > rename, simplify)
ponderation(ponderation3, E, 4, clash) :- regle(E, clash).
ponderation(ponderation3, E, 4, check) :- regle(E, check).
ponderation(ponderation3, E, 3, orient) :- regle(E, orient).
ponderation(ponderation3, E, 2, decompose) :- regle(E, decompose).
ponderation(ponderation3, E, 1, expand) :- regle(E, expand).
ponderation(ponderation3, E, 0, rename) :- regle(E, rename).
ponderation(ponderation3, E, 0, simplify) :- regle(E, simplify).


% On compare le poids des règles pouvant être appliqué sur les deux formules E et F, et on ajoute la forumle avec le poids le plus fort dans une liste L
ponderation_max([F|P], Q, E, RegleE, Result, Ponderation) :-
    ponderation(Ponderation, E, PoidsE, RegleE), ponderation(Ponderation, F, PoidsF, RegleF),
    (PoidsE > PoidsF -> (X = E, Reste = F, Regle = RegleE); (X = F, Reste = E, Regle = RegleF)), !,
    ponderation_max(P, Q, X, Regle, [Reste|Result], Ponderation).


% Une fois ordonné on lance la réduction.
ponderation_max([], Q, E, R, L, _) :- trace_systeme([E|L]), trace_regle(E, R), reduit(R, E, L, Q), !.


% Question 3
% Inhibe l'affichage.
unif(P, S) :- clr_echo, unifie(P, S).
% Active la trace d'affichage des règles appliquées à chaque étape.
trace_unif(P,S) :- set_echo, unifie(P, S).

% Affiche l'état de P.
trace_systeme(P) :- echo('system: ['), trace_arg_systeme(P), echo(']\n').

% Affiche les différents arguments d'un système, avec des espaces après les ','.
trace_arg_systeme([]). % Condition d'arrêt.
trace_arg_systeme([A ?= B]) :- trace_terme(A), echo(' = '), trace_terme(B). % Affichage du dernuer argument.
trace_arg_systeme([A ?= B|P]) :-
    trace_terme(A), echo(' = '), trace_terme(B), echo(', '), trace_arg_systeme(P). % Affichage d'un argument.

% Affichage des termes (pour les espaces après les ',' des termes composés).
trace_terme(). % Condition d'arrêt.
trace_terme(A) :- (var(A); atomic(A)), echo(A). % Affichage des variables et constantes.
trace_terme(A) :- compound(A), A =.. [Name | Args], echo(Name), echo('('), trace_list(Args), echo(')').

% Affichage de liste (pour les listes d'arguments des termes composés).
trace_list(). % Condition d'arrêt.
trace_list([A|[]]) :- echo(A). % Affichage du dernier argument.
trace_list([A|List]) :- echo(A), echo(', '), trace_list(List). % Affichage d'un argument.

% Affiche la règle utilisée.
trace_regle(A ?= B, R) :-
    echo(R), echo(': '), trace_terme(A), echo(' = '), trace_terme(B), echo('\n'). % Remplace les ?= par des = entouré d'espace.