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
reduit(decompose, X ?= Y, P, Q) :- compound_name_arguments(X, _, Args1), compound_name_arguments(Y, _, Args2), remplace(Args1, Args2, Result), append(Result, P, Q).

% Définition de réduction de Clash
reduit(clash, _, _, _) :- !, fail.

% Définition de remplace qui pose récursivement l'unification de tous les termes un à un
remplace([], [], []). % Condition d'arrêt si les paramètres sont vides (pour éviter une boucle infinie)
remplace([A|Args1], [B|Args2], [A ?= B | Temp]) :- remplace(Args1, Args2, Temp).


% Définition de Unifie
unifie([E|P]):- regle(E, R), reduit(R, E, P, Q), !, unifie(Q).
unifie([]).