
/* A set of facts about the CS department courses

 lowercase variable names are *atoms*
  - an uninterpreted constant
  - cs31 is a constant

 prereq is a *predicate*
   - an uninterpreted function that returns a boolean

*/

/* it is true that cs31 is a prerequisite of cs32 */
prereq(cs31, cs32).

prereq(cs32, cs33).
prereq(cs31, cs35L).
prereq(cs32, cs111).
prereq(cs33, cs111).
prereq(cs35L, cs111).
prereq(cs32, cs118).
prereq(cs33, cs118).
prereq(cs35L, cs118).
prereq(cs111, cs118).
prereq(cs32, cs131).
prereq(cs33, cs131).
prereq(cs35L, cs131).
prereq(cs32, cs132).
prereq(cs35L, cs132).
prereq(cs131, cs132).
prereq(cs181, cs132).

/* rules are ways to define new predicates in terms of old
    predicates */

/* another view: a query with a name */

/* head */     /* body */
/* rule: head is true if the body is true */
pOfp(X,Y) :- prereq(X,Z), prereq(Z,Y).

pTrans(X,Y) :- prereq(X,Y).
pTrans(X,Y) :- prereq(X,Z), pTrans(Z,Y).


app([], L2, L2).
app([H|T], L2, Result) :- Result = [H|Z], app(T, L2, Z).

/* reverse a list
  Ocaml:
   let rec rev l =
     match l with
       [] -> []
     | x::xs -> (rev xs)@[x]
*/

rev([],[]).
rev([H|T],R) :- rev(T,X), app(X,[H],R).

/* data structures are uninterpreted functions */

/* node(1,node(2,node(3,empty)))

in Ocaml:

type mylist = Empty | Node of ...

*/

app2(empty, L2, L2).
app2(node(H,T), L2, node(H,Z)) :- app2(T, L2, Z).

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
