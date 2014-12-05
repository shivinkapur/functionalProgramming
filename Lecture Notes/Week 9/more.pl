/* arithmetic constraints
    - "one-way" constraints
    - a designated set of inputs, which must be constants
    - a designated output, which can be variable

    why?

    X*Y = Z

    given X and Y, computing Z is easy
    given Z, recovering X and Y is hard

    X is C
    - C is some arithmetic expression; must be constant
    - X can be a variable
    - evaluates C and then unifies the result with X

    X > Y, X < Y
    - both X and Y have to be constants
    
*/

temp(C,F) :- F is 1.8*C + 32.0.
temp2(C,F) :- C is (F - 32.0)*5.0/9.0.

len([],0).
len([_|T],N) :- len(T,Y), N is Y+1.

/* linear constraint:

    c1*x1 + c2*x2 + ... cn*xn + c <= 0

    solvable in polynomial time

    idea of *constraint logic programming*
    - augments Prolog with support for constraints from some
       domain

    CLP(R)
    - logic programming with linear arithmetic over the reals
    
*/    

/*

n-queens

queen(X,Y) represents a queen in row X, column Y

*/

notAttack(_,[]).
notAttack(Q1,[Q2|Qs]) :-
  notAttack(Q1,Qs),
  Q1 = queen(X1,Y1),
  Q2 = queen(X2,Y2),
  X1 \= X2,
  Y1 \= Y2,
  Slope is (Y2-Y1)/(X2-X1),
  Slope \= 1.0,
  Slope \= -1.0.

nqueens([]).
nqueens([Q|Qs]) :-
   Q = queen(X,Y),
   member(X,[1,2,3,4,5,6,7,8]),
   member(Y,[1,2,3,4,5,6,7,8]),
   nqueens(Qs), notAttack(Q, Qs).

