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

% FAIL car l'arité n'est pas respecté dans le membre de droite.
test(decompose6, [fail]) :-
    regle(f(X) ?= f(X, Y), decompose).

% FAIL car l'arité n'est pas respecté dans le membre de gauche.
test(decompose7, [fail] ) :-
    regle(f(X, Y) ?= f(X), decompose).

% FAIL car la constante est un terme composé avec 0 argument, le test d'arité n'est pas respecté. 
test(decompose8, [fail] ) :-
    regle(x ?= f(X), decompose).

% FAIL car la constante est un terme composé avec 0 argument, le test d'arité n'est pas respecté. 
test(decompose9, [fail] ) :-
    regle(f(X) ?= x, decompose).

% OK car f(a, g(X), Z) et f(b, h(Y), W) ont le même nom et la même arité en plus d'être des termes composés.
test(decompose10) :-
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

:- end_tests(reduit).

:- begin_tests(unifie).

:- end_tests(unifie).