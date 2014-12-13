happy(yolanda). 
listens2Music(mia). 
listens2Music(yolanda):-  happy(yolanda). 
playsAirGuitar(mia):-  listens2Music(mia). 
playsAirGuitar(yolanda):-  listens2Music(yolanda).

app([], L2, L2).
app([H|T], L2, Result) :- Result = [H|Z], app(T, L2, Z).
rev([],[]).
rev([H|T],R) :- rev(T,X), app(X,[H],R).

temp(C,F) :- F is 1.8*C + 32.0.
temp2(C,F) :- C is (F - 32.0)*5.0/9.0.

len([],0).
len([_|T],N) :- len(T,Y), N is Y+1.