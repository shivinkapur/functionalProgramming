Remove Duplicates
rmDup([],[]).
rmDup([X],[X]).
rmDup([H, H|T], Z):- rmDup([H|T],Z).
rmDup([H,X|T],[H|T]):-H\=X, rmDup([X|T],Z).

%Get the unique elements - version 1 will not work
unique(L1,L2).
unique([],[]).
unique([X],[X]).

%version 2...
unique(L1,L2):-helper(L1,L2, []).
unique([1,2,1,2,2], X).

= unification
== equivalence.

not(member(H,Z)).


helper(R, U, S).
helper([],U, U):- helper([H|T], U, S):-member(H,S)->helper(T, U, S); helper(T, V, [H|S])

-----------------------------------------------------
remove kth element
r_kth(R,L1, K, L2).
R is the element we remove from L1 to get L2.
r_kth(H, [H|T], 0, T).
r_kth(R, [H|T], K, L2):-K1 is K-1, r_kth(R,T,K1,L2).
----------------------------------------------
(* BST - check if the tree is a bst! *)
    T
 L      R

 type btree = Leaf 
              | Node of (int * btree * btree)
 let isBST (b : btree) : bool = 

 check that root of left is < original tree.
 root of right is > original tree.
(*OPTIMIZED SOLUTION: *)
do inorder traversal and check if the generated list is in sorted order!!

let rec inOrder(b): int list = 
    match b with
       Leaf -> []
       | Node(i,l,v)->(inOrder []@(i::(inOrder r))

let isSorted(l : int list): bool =
	List.fold_left (fun (b,p) -> 
	  (b && p <= e, e))

	  (true, List_hd L) (List.tl L)

-----------------------------------
Knight's Tour.
knight visits every square on the board exactly once.

S is from 1 to N. Keep track of the offsets.
move(X,Y,Xn, Yn, S):-
    member(X, S), member(Y,S),
    member(Xd, [-2,-1,1,2]),
    member(Yd, [-2,-1,1,2]),
    abs(Xd,Za), abs(Yd,Ya), Xa\=Ya,
    Xa is X + Xd, Yn is Y + Yd,
    member(Xa, S), member(Ya,S)
 
range(1, [1]).
range(N, [N|T]):-N1 is N-1 range(N1, T).



 knights_toug(N,A):-
     range(N,S),
     member(Sx, S),
     member(Sy,S),
     L is N&N,
     tour([[Sx,Sy]], A, L, S)

(X,Y) is the current position of the knight, P is the positions the knight has been.
L is needed to see if you are done with the tour.
R: moves remaining
 tour([[X,Y]|P],  R,  L, S):-
 length([[X,Y]|P], K), K = L -> R= []; 
 move(X,V,Xn,Yn, S), 
 not (member([Xn,Yn], P)),
 R= [[Xn,Yn] | Q],
 tour([[Xn,Yn],[X,Y]|P], Q, L, S).