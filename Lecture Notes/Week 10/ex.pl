
p(f(Y)) :- q(Y), r(Y).   /* 1 */

p(b).	   	 	    /* 5 */

q(h(Z)) :- t(Z).         /* 2 */

r(h(a)).                   /* 3 */

t(a).                       /* 4 */

/* query: p(X) */


u(a).
u(X) :- u(X).
/* query: u(X) */


app([], L2, L2).
app([H|T], L2, [H|Z]) :- app(T, L2, Z).

rev([],[]).
rev([H|T],R) :- app(X,[H],R), rev(T,X).
