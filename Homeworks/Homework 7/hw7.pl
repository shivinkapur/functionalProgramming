/*
  Homework 7

  Name: Shivin Kapur

  UID: 404259526

*/



/* Question 1 */
duplist([], []).
duplist([X], [X, X]).
duplist([XH | XT], [YH1, YH2 | YT]) :- duplist(XT, YT), XH = YH1, XH = YH2, YH1 = YH2.



/* Question 2 */
put(K, V, [], [[K, V]]).
put(K, V, [[K, _] | D],[[K, V] | D]).
put(K, V, [[K1, V1] | D1], [[K1, V1] | D2]) :- K \= K1, put(K, V, D1, D2).

get(K, [[K, V] | _], V).
get(K, [[_, _] | D], V) :- get(K, D, V).



/* Question 3 */
eval(intconst(I), _, intval(I)).
eval(boolconst(B), _, boolval(B)).

eval(var(X), [[var(K), V]], V) :- X = K.
eval(var(X), [[var(K), V] | _], V) :- X = K.
eval(var(X), [[var(K), _] | R], V1) :- X \= K, eval(var(X), R, V1).

eval(geg(E1, E2), ENV, boolval(true)) :- eval(E1, ENV, intval(V1)), eval(E2, ENV, intval(V2)), V1 > V2.
eval(geg(E1, E2), ENV, boolval(false)) :- eval(E1, ENV, intval(V1)), eval(E2, ENV, intval(V2)), V1 < V2.

eval(if(E1, E2, _), ENV, V) :- eval(E1, ENV, boolval(true)), eval(E2, ENV, V).
eval(if(E1, _, E3), ENV, V) :- eval(E1, ENV, boolval(false)), eval(E3, ENV, V).

eval(function(X, E), ENV, funval(X, E, [[var(X), V] | ENV])) :- eval(E, ENV, V).
% eval(function(X, E), ENV, _) :- eval(E, ENV, V), put(var(X), V, ENV, ENV_NEW), ENV = ENV_NEW.

eval(funcall(E1, E2), ENV, V) :- eval(E1, ENV, funval(X, E, NEW_ENV)), eval(E2, NEW_ENV, V).
