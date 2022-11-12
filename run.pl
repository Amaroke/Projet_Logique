% Permet de retirer les Warnings liés au Singleton
:- style_check(-singleton).

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
regle(X ?= T, rename) :- var(X), var(T), !.

% Définition de la règle Simplify
regle(X ?= T, simplify) :- var(X), atomic(T), !.

% Définition de la règle Expand
regle(X ?= T, expand) :- compound(T), var(X), not(occur_check(X, T)), !.

% Défintion de la règle Check
regle(X ?= T, check) :- X \== T, var(X), occur_check(X, T), !. 

% Définition de la règle Orient
regle(T ?= X, orient) :- nonvar(T), var(X), !.

% Définition de la règle Decompose
regle(X ?= Y, decompose) :- compound(X), compound(Y), compound_name_arity(X, NAME1, ARITY1), compound_name_arity(Y, NAME2, ARITY2),  NAME1 == NAME2, ARITY1 == ARITY2, !.

% Définition de la règle Clash
regle(X ?= Y, clash) :- compound(X), compound(Y), compound_name_arity(X, NAME1, ARITY1), compound_name_arity(Y, NAME2, ARITY2), not((NAME1 == NAME2, ARITY1 == ARITY2)), !.


% Définition de occur_check
occur_check(V, T) :- var(V), compound(T), arg(_, T, X), V == X, !.


% Définition des réductions
% Définition de réduction de Rename
reduit(rename, X ?= T, P, Q) :- X = T, Q = P, !.

% Définition de réduction de Simplify
reduit(simplify, X ?= T, P, Q) :- X = T, Q = P, !.

% Définition de réduction de Expand 
reduit(expand, X ?= T, P, Q) :- X = T, Q = P, !.

% Définition de réduction de Check
reduit(check, X ?= T, P, Q) :- fail, !.

% Définition de réduction de Orient
reduit(orient, T ?= X, P, Q) :- append([X ?= T], P, Q), !.

% Définition de réduction de Decompose
reduit(decompose, X ?= Y, P, Q) :- compound_name_arguments(X, NAME1, ARGS1), compound_name_arguments(Y, NAME2, ARGS2), remplace(ARGS1, ARGS2, RESULT), append(RESULT, P, Q).

% Définition de réduction de Clash
reduit(clash, X ?= Y, P, Q) :- fail, !.

% Définition de remplace qui pose récursivement l'unification de tous les termes un à un
remplace([], [], []). % Condition d'arrêt si les paramètres sont vides (pour éviter une boucle infinie)
remplace([A|ARGS1], [B|ARGS2], RESULT) :- remplace(ARGS1, ARGS2, TEMP), append([A ?= B], TEMP, RESULT).