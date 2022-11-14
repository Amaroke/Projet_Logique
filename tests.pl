:- ['run'].
% Disable warnings about singleton variables
:- style_check(-singleton).


% Tests des règles
:- begin_tests(regle).


% Tests de Rename
% OK car X et Y variables.
test(rename) :- 
    regle(X ?= Y, rename).

% FAIL car f(A) n'est pas une variable.
test(rename2, [fail]) :-
    regle(X ?= f(A), rename).

% FAIL car a n'est pas une variable.
test(rename3, [fail]) :-
    regle(X ?= a, rename).

% FAIL car a n'est pas une variable.
test(rename4, [fail]) :-
    regle(a ?= Y, rename).

% FAIL car f(A) n'est pas une variable.
test(rename5, [fail]) :-
    regle(f(A) ?= Y, rename).

% OK car X est une variable.
test(rename6) :-
    regle(X ?= X, rename).

% Tests de Simplify
% FAIL car Y n'est pas une constante.
test(simplify, [fail]) :-
    regle(X ?= Y, simplify).

% FAIL car Y n'est pas une constante.
test(simplify2, [fail]) :-
    regle(X ?= f(A), simplify).

% FAIL car Y n'est pas une constante.
test(simplify3) :-
    regle(X ?= a, simplify).

% FAIL car a n'est pas une variable.
test(simplify4, [fail]) :-
    regle(a ?= a, rename).

% FAIL car f(A) n'est pas une variable.
test(simplify5, [fail]) :-
    regle(f(A) ?= a, rename).


% Tests de Expand
% FAIL car Y n'est pas un terme composé
test(expand, [fail]) :-
    regle(X ?= Y, expand).

% OK car X est une variable et Y est un terme composé
test(expand2, []) :-
    regle(X ?= f(A), expand).

% FAIL car f(Y) n'est pas un terme composé
test(expand3, [fail]) :-
    regle(X ?= a, expand).

% FAIL car a n'est pas une variable.
test(expand4, [fail]) :-
    regle(a ?= f(Y), expand).

% FAIL car f(A) n'est pas une variable.
test(expand5, [fail]) :-
    regle(f(A) ?= f(Y), expand).


% Tests de Check
% FAIL car Y n'est pas un terme composé.
test(check, [fail]) :-
    regle(X ?= Y, check).

% FAIL car A n'est pas dans f(Y).
test(check, [fail]) :-
    regle(X ?= f(A), check).

% FAIL car X n'est pas différent de X (en réalité que le deuxième X n'est pas un terme composé).
test(check, [fail]) :-
    regle(X ?= X, check).

% OK car X est présent dans f(X).
test(check) :-
    regle(X ?= f(X), check).

% FAIL car a n'est pas un terme composé.
test(check, [fail]) :-
    regle(X ?= a, check).

% FAIL car f(X) n'est pas une variable.
test(check, [fail]) :-
    regle(f(X) ?= f(X), check).

% FAIL car x n'est pas une variable.
test(check, [fail]) :-
    regle(x ?= f(X), check).


% Tests de Orient
% FAIL car X est une variable.
test(orient, [fail]) :-
    regle(X ?= Y, orient).

% FAIL car X est une variable.
test(orient2, [fail]) :-
    regle(X ?= f(A), orient).

% FAIL car X est une variable.
test(orient3, [fail]) :-
    regle(X ?= f(X), orient).

% OK car f(X) est une terme composé et A une variable.
test(orient4) :-
    regle(f(X) ?= A, orient).

% FAIL car f(a) est un terme composé.
test(orient5, [fail]) :-
    regle(f(X) ?= f(A), orient).

% FAIL car a est une constante.
test(orient6, [fail]) :-
    regle(f(X) ?= a, orient).

% OK car x est un terme composé (d'arité 0) et A une variable.
test(orient7) :-
    regle(x ?= A, orient).

% FAIL car f(X) est un terme composé.
test(orient8, [fail]) :-
    regle(x ?= f(X), orient).

% FAIL car a une constante.
test(orient9, [fail]) :-
    regle(x ?= a, orient).


% Tests de Decompose
% OK car les deux noms de termes composés sont identiques.
test(decompose) :-
    regle(f(X) ?= f(Y), decompose).

% FAIL car X est une variable.
test(decompose2, [fail]) :-
    regle(X ?= f(X), decompose).

% FAIL car Y est une variable.
test(decompose3, [fail]) :-
    regle(f(X) ?= Y, decompose).

% FAIL car le nom des termes composés sont différents.
test(decompose4, [fail]) :-
    regle(f(X) ?= g(X), decompose).

% OK car même arité (de 0) et même nom, règle du nettoyage.
test(decompose5) :-
    regle(x ?= x, decompose).

% OK car même arité (de 0) et même nom, règle du nettoyage.
test(decompose6) :-
    regle(x() ?= x(), decompose).

% FAIL car l'arité n'est pas respecté dans le membre de droite.
test(decompose7, [fail]) :-
    regle(f(X) ?= f(X, Y), decompose).

% FAIL car l'arité n'est pas respecté dans le membre de gauche.
test(decompose8, [fail] ) :-
    regle(f(X, Y) ?= f(X), decompose).

% FAIL car la constante est un terme composé avec 0 argument, le test d'arité n'est pas respecté. 
test(decompose9, [fail] ) :-
    regle(x ?= f(X), decompose).

% FAIL car la constante est un terme composé avec 0 argument, le test d'arité n'est pas respecté. 
test(decompose10, [fail] ) :-
    regle(f(X) ?= x, decompose).

% OK car f(a, g(X), Z) et f(b, h(Y), W) ont le même nom et la même arité en plus d'être des termes composés.
test(decompose11) :-
    regle(f(a, g(X), Z) ?= f(b, h(Y), W), decompose).


% Tests de Clash
% FAIL car X n'est pas un terme composé ou une constante.
test(clash, [fail]) :-
    regle(X ?= f(Y), clash).

% FAIL car Y n'est pas un terme composé ou une constante.
test(clash2, [fail]) :-
    regle(f(X) ?= Y, clash).

% FAIL car X et Y ne sont pas des termes composés ou des constantes.
test(clash3, [fail]) :-
    regle(X ?= Y, clash).

% OK car f et g n'ont pas le même nom.
test(clash4) :-
    regle(f(X) ?= g(Y), clash).

% OK car f n'a pas la même arité.
test(clash5) :-
    regle(f(X) ?= f(Y, Z), clash).

% FAIL car a et a ont le même nom et la même arité (de 0).
test(clash6, [fail]) :-
    regle(x ?= x, clash).


% Tests de Occur-check
% OK car X est une variable, f(X) un terme composé et que f(X) contient X.
test(occur_check) :-
    occur_check(X, f(X)).

% FAIL car f(X) n'est pas une variable.
test(occur_check2, [fail]) :-
    occur_check(f(X), f(X)).

% FAIL car x n'est pas une variable.
test(occur_check3, [fail]) :-
    occur_check(x, f(X)).

% FAIL car Y n'est pas un terme composé.
test(occur_check4, [fail]) :-
    occur_check(X, Y).

% FAIL car y n'est pas un terme composé.
test(occur_check5, [fail]) :-
    occur_check(X, y).

% FAIL car f(Y) ne contient pas X.
test(occur_check6, [fail]) :-
    occur_check(X, f(Y)).

% OK car X est une variable, f(f(X)) un terme composé et que f(f(X)) contient X.
test(occur_check7) :-
    occur_check(X, f(f(X))).

% OK car tous les termes sont distincts. 
test(occur_check8) :- 
    occur_check(X, f(g(h(b, c, Y), W, A, Z, k(X)))).

:- end_tests(regle).


% Tests des réduits
:- begin_tests(reduit).

% Tests de Rename
% Si on applique rename sur A ?= B rien n'en résulte, rename n'ajoutant pas d'équation.
test(rename) :-
    reduit(rename, A ?= B, [], []).

% Si on applique A ?= B sur A ?= a, A est substitué par B.
test(rename2) :-
	reduit(rename, A ?= B, [A ?= a], [B ?= a]).

% Si on applique A ?= B sur A ?= a et A ?= f(A), A est substitué par B, en résulte B ?= a, B ?= f(B).
test(rename3) :-
    reduit(rename, A ?= B, [A ?= a, A ?= f(A)], [B ?= a, B ?= f(B)]).

% Tests de Simplify
% Si on applique simplify sur X ?= a rien n'en résulte, rename n'ajoutant pas d'équation.
test(simplify) :-
    reduit(simplify, X ?= a, [], []).

% Si on applique simplify sur X ?= b, on obtient a ?= b, X est simplifié.
test(simplify2) :-
	reduit(simplify, X ?= a, [X ?= b], [a ?= b]).

% Tests de Expand
% Si on applique Expand sur X ?= a rien n'en résulte, rename n'ajoutant pas d'équation.
test(expand) :-
    reduit(expand, X ?= a, [], []).

% Si on applique simplify sur X ?= f(A), on obtient X ?= A, X est expand.
test(expand2) :-
	reduit(expand, X ?= f(A), [X ?= a], [X ?= a]).

% Tests de Check
% Check renvoit bottom peut-importe ce qu'on lui donne.
test(check, [fail]) :-
    reduit(check, X ?= f(X), [], []).

% Check renvoit bottom peut-importe ce qu'on lui donne.
test(check2, [fail]) :-
	reduit(check, X ?= f(A), [], []).

% Check renvoit bottom peu-importe ce qu'on lui donne.
test(check3, [fail]) :-
	reduit(check, _, [], []).

% Tests de Orient
% Orient renvoit bien A ?= f(X) à partir de f(X) ?= A.
test(orient) :-
    reduit(orient, f(X) ?= A, [], [A ?= f(X)]).

% Orient renvoit bien A ?= x à partir de x ?= A.
test(orient2) :-
	reduit(orient, x ?= A, [], [A ?= x]).

% Orient renvoit bien A ?= f(X) à partir de f(X) ?= A, sans perdre Z ?= Y présent dans P.
test(orient3) :-
	reduit(orient, x ?= A, [Z ?= Y], [A ?= x, Z ?= Y]).

% Tests de Decompose
% Decompose effectue un nettoyage sur deux constantes.
test(decompose) :-
    reduit(decompose, f ?= f, [], []).

% Decompose effectue un nettoyage sur deux constantes sans perdre le reste de P.
test(decompose2) :-
    reduit(decompose, f ?= f, [X ?= Y], [X ?= Y]).

% Decompose effectue un nettoyage sur deux constantes (terme composé de 0 argument).
test(decompose3) :-
    reduit(decompose, f() ?= f(), [], []).

% Decompose effectue un nettoyage sur deux constantes (terme composé de 0 argument) sans perdre le reste de P.
test(decompose4) :-
    reduit(decompose, f() ?= f(), [X ?= Y], [X ?= Y]).

% Decompose f(X) ?= f(Y) en X ?= Y.
test(decompose5) :-
    reduit(decompose, f(X) ?= f(Y), [], [X ?= Y]).

% Decompose f(X) ?= f(g(Y)) en X = g(Y).
test(decompose6) :-
	reduit(decompose, f(X) ?= f(g(Y)), [], [X ?= g(Y)]).

% Decompose f(A, B, C, D, E, F) ?= f(G, H, I, J, K, L) en A ?= G, B ?= H, C ?= I, D ?= J, E ?= K, F ?= L.
test(decompose7) :-
	reduit(decompose, f(A, B, C, D, E, F) ?= f(G, H, I, J, K, L), [], [A ?= G, B ?= H, C ?= I, D ?= J, E ?= K, F ?= L]).

% Tests de Clash
% Clash renvoit bottom peut-importe ce qu'on lui donne.
test(clash, [fail]) :-
    reduit(clash, X ?= f(X), [], []).

% Clash renvoit bottom peut-importe ce qu'on lui donne.
test(clash2, [fail]) :-
	reduit(clash, X ?= f(A), [], []).

% Clash renvoit bottom peu-importe ce qu'on lui donne.
test(clash3, [fail]) :-
	reduit(clash, _, [], []).

:- end_tests(reduit).


% Test de Unifie
:- begin_tests(unifie, [setup(clr_echo)]).

test(unifie) :-
    unifie([f(X, X, Y) ?= f(f(Y, Y, Z), f(Y, Y, Z), a)]).

test(unifie2, [fail]) :-
    unifie([f(X, X, Y) ?= f(f(Y, Y, Z), f(Y, X, Z), a)]).

test(unifie3) :-
    unifie([p(g(U, Z), X, Z) ?= p(X, g(Y, Z), b)]).

test(unifie4, [fail]) :-
    unifie([p(X, f(X), h(f(X), X)) ?= p(Z, f(f(a)), h(f(g(a, Z)), V))]).

test(unifie5) :-
    unifie([f(X, X, Y) ?= f(f(Y, Y, Z), f(Y, Y, Z), a)]).

test(unifie6, [fail]) :-
    unifie([f(X, X, Y) ?= f(f(Y, Y, Z), f(Y, X, Z), a)]).

test(unifie7) :-
    unifie([f(X, g(Y, Z), a) ?= f(g(V, Z), X, Z)]).

:- end_tests(unifie).