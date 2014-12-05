/* TSP

   travelling salesperson problem

   find a tour through all cities that minimizes distance

   NP-complete


*/

dist(ucla, ucsd, 124).
dist(ucla, uci, 45).
dist(ucla, ucsb, 97).
dist(ucla, ucb, 338).
dist(ucla, ucd, 392).
dist(ucla, ucsc, 346).
dist(ucsd, uci, 72).
dist(ucsd, ucsb, 203).
dist(ucsd, ucb, 446).
dist(ucsd, ucd, 505).
dist(ucsd, ucsc, 460).
dist(uci, ucsb, 148).
dist(uci, ucb, 382).
dist(uci, ucd, 440).
dist(uci, ucsc, 395).
dist(ucsb, ucb, 323).
dist(ucsb, ucd, 378).
dist(ucsb, ucsc, 260).
dist(ucb, ucd, 64).
dist(ucb, ucsc, 79).
dist(ucd, ucsc, 135).

sdist(X,Y,D) :- dist(X,Y,D).
sdist(X,Y,D) :- dist(Y,X,D).

sumDist([],0).
sumDist([_],0).
sumDist([C1,C2|Rest], Sum) :-
   sdist(C1,C2,D), sumDist([C2|Rest], S),
   Sum is D + S.

/* succeeds if Tour is a valid tour of Cities
    and Tour has total distance Length */
tsp(Cities, [Head|Ts], Length) :-
  permutation(Cities,Ts),
  length(Ts,K),
  nth(K, Ts, Head),
  sumDist([Head|Ts], Length).
