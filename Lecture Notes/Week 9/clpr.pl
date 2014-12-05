
:- use_module(library(clpr)).

temp(C,F) :- {F = 1.8*C+32.0}.

myLength([], 0).
myLength([_|T], L) :- myLength(T, L2), {L = L2 + 1}.

quicksort([],[]).
quicksort([X|Xs],Sorted) :-
  partition(X,Xs,Smalls,Bigs),
  quicksort(Smalls,SortedSmalls),
  quicksort(Bigs,SortedBigs),
  append(SortedSmalls,[X|SortedBigs],Sorted).

partition(_,[],[],[]).
partition(Pivot,[X|Xs],[X|Ys],Zs) :-
   {X =< Pivot},  /* note that this is a constraint */
   partition(Pivot,Xs,Ys,Zs).
partition(Pivot,[X|Xs],Ys,[X|Zs]) :-
   {X > Pivot},   /* the other constraint */
   partition(Pivot,Xs,Ys,Zs).
