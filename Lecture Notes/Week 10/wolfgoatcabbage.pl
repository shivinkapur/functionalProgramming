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
