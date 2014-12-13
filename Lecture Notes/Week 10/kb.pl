/* wolf goat cabbage

goal: get you and them from west bank to east bank
constraints:
boat fits you plus one
can't leave the wolf with the goat
can't leave the goat with the cabbage

what's a state of the world:
a list of four elements
start: [west,west,west,west]
in general: [Person, Wolf, Goat, Cabbage]

what are the actions in the world?
wolf, goat, cabbage, nothing
*/

/* move(State1, Action, State2) */



% https://www.csupomona.edu/~jrfisher/www/prolog_tutorial/contents.html#intro

flip(west,east).
flip(east,west).

move([P,W,G,C], wolf, [O,O,G,C]) :-
  P=W, G\=C, flip(P,O).
move([P,W,G,C], goat, [O,W,O,C]) :-
    P=G, flip(P,O).
move([P,W,G,C],cabbage, [O,W,G,O]) :-
      P=C, W\=G, flip(P,O).
move([P,W,G,C], nothing, [O,W,G,C]) :-
        W\=G, G\=C, flip(P,O).

/* moves(Start, Actions, End) */
moves(Start, [], Start).
moves(Start, [A|As], End) :-
move(Start, A, Mid), moves(Mid, As, End).

abs(0, 0).
abs(X, Y) :- X > 0, X = Y.
abs(X, Y) :- Z is 0 - Y, X = Z.

% Using if-else
abs2(0, 0).
abs2(X, Y) :- X > 0 -> X = Y; X = Z, Z is 0 - Y.

factorial(0,1).
factorial(A,B) :-
  A > 0,
  C is A-1,
  factorial(C,D),
  B is A*D.

factorial2(0,F,F).
factorial2(N,A,F) :-
  N > 0,
  A1 is N*A,
  N1 is N -1,
  factorial2(N1,A1,F).

not(P) :- (call(P) -> fail ; true).
bachelor(P) :- male(P), not(married(P)).
male(henry).
male(tom).
married(tom).

% List Methods
max([],M,M).
max([X|R],M,A) :- (X > M -> max(R,X,A) ; max(R,M,A)).

max2([X], X).
max2([H | T], H) :- max(T, Z), H >= Z.
max2([H | T], Z) :- max(T, Z).

takeout(A,[A|B],B).
takeout(A,[B|C],[B|D]) :- takeout(A,C,D).

member2(X,[X|_]).
member2(X,[_|R]) :- member2(X,R).

append2([X|Y],Z,[X|W]) :- append2(Y,Z,W).
append2([],X,X).

reverse([X|Y],Z,W) :- reverse(Y,[X|Z],W).
reverse([],X,X).

perm([X|Y],Z) :- perm(Y,W), takeout(X,Z,W).
perm([],[]).

subset([X|R],S) :- member(X,S), subset(R,S).
subset([],_).

union([X|Y],Z,W) :- member(X,Z),  union(Y,Z,W).
union([X|Y],Z,[X|W]) :- \+ member(X,Z), union(Y,Z,W).
union([],Z,Z).

intersection([X|Y],M,[X|Z]) :- member(X,M), intersection(Y,M,Z).
intersection([X|Y],M,Z) :- \+ member(X,M), intersection(Y,M,Z).
intersection([],M,[]).

% Merge Sort
mergesort([],[]).    /* covers special case */
mergesort([A],[A]).
mergesort([A,B|R],S) :-
  split([A,B|R],L1,L2),
  mergesort(L1,S1),
  mergesort(L2,S2),
  merge(S1,S2,S).

split([],[],[]).
split([A],[A],[]).
split([A,B|R],[A|Ra],[B|Rb]) :-  split(R,Ra,Rb).

merge(A,[],A).
merge([],B,B).
merge([A|Ra],[B|Rb],[A|M]) :-  A =< B, merge(Ra,[B|Rb],M).
merge([A|Ra],[B|Rb],[B|M]) :-  A > B,  merge([A|Ra],Rb,M).

% Change of a Dollar
change([H,Q,D,N,P]) :-
  member(H,[0,1,2]),                      /* Half-dollars */
  member(Q,[0,1,2,3,4]),                  /* quarters     */
  member(D,[0,1,2,3,4,5,6,7,8,9,10]) ,    /* dimes        */
  member(N,[0,1,2,3,4,5,6,7,8,9,10,       /* nickels      */
  11,12,13,14,15,16,17,18,19,20]),
  S is 50*H + 25*Q +10*D + 5*N,
  S =< 100,
  P is 100-S.

% N-Queens
solve(P) :-
  perm([1,2,3,4,5,6,7,8],P),
  combine([1,2,3,4,5,6,7,8],P,S,D),
  all_diff(S),
  all_diff(D).

combine([X1|X],[Y1|Y],[S1|S],[D1|D]) :-
  S1 is X1 +Y1,
  D1 is X1 - Y1,
  combine(X,Y,S,D).
  combine([],[],[],[]).

all_diff([X|Y]) :-  \+member(X,Y), all_diff(Y).
all_diff([X]).
