(* Datatypes allow users to define their own datastructures
	generalization of:
	- enums
	- structs
	- unions
*)

(* a new type with a finite set of values
*)
type sign = Positive | Negative | Zero

let signOf n = 
	match n with
		0 -> Zero
	| _ when n>0 -> Positive
	| _ -> Negative

let signToInt s = 
	match s with
		Zero -> 0
	| Negative -> -1
	| Positive -> 1

type point = Cartesian of (float * float)
(* Cartesian(3.0,4.4);;
point = Cartesian(3,4.4)
*)

(* Declare a type 
	type has to be lowercase ; tags have to be unique across all different datatypes; tag has to be uppercase
this is similar to java classes, instance variables and methods
*)
type point = 
	Cartesian of (float * float)
	| Polar of (float * float) 

let negate p =
	match p with
		Cartesian(x,y) -> (-.x,-.y)
		| Polar (rho,theta) -> Polar(rho,theta + .180.0)

let normalize p = 
	match p with
	| Cartesian -> p
	| Polar (rho, theta) -> 

let toPolar = 
	match p with
	| Polar - -> p
	| Cartesian (x,y)-> Polar( sqrt (x*.x +. y*.y), atan(y / .x))

(* Ocaml doesnt have notion of null *)
type optionalInt = None | Some of int 

let safeDiv (x,y) = 
	if y = 0 then None else Some(x/y)
	match result with
	None -> (-1)
	| Some res -> res;;
	(*ans will be int=1 *)

(*All these are notions of datatypes
These are similar to generics. here it is called parametric polymorphism
 *)
type 'a option = None | Some of 'a 

(* final extension of a datatype 
stack, hasmap, tree?
*)
(* recursive *)
type intList = Nil | Cons of (int * intList)

(* (Cons(1, Cons(2, Cons(3, Nil)))) *)

let rec length l = 
	match l with
	| Nil -> 0
	| Cons(_, rest) -> 1 + (length rest)

(* data only at internal nodes*)
type binaryTreeInt = Leaf | Node of (int * binaryTreeInt * binaryTreeInt)
(* Node(1, Node (2, Leaf, Leaf), Node(3, (Node(4, Leaf, Leaf)))) 
		1
	2		3
		(left of 3)4
*)


(* data only at leaves *)
type 'a binTree = Leaf of 'a | Node of 'a binTree * 'a binTree

(* preorder traversal 
	on the one above would be 1 2 3 4
*)
let rec preorder tree = 
	match tree with
	| Node(n,left,right) -> [n]@(preorder left) @(preorder right)
	| Leaf -> []

(* insert number into binary search tree 
	smaller values go to left subtree
	bigger or equal values go to right subtree
*)
let rec insert (n,t) = 
	match t with
	| Node(n,left,right) -> 
		if left < n  then Node(x, insert(n, left), right)
		else Node(n, left, insert(n,right))
	| Leaf -> Node(n, Leaf, Leaf) 


(*Functions*)

(* functions are *first-class*:
	- they are full-fledged expressions in the language
	- you can pass them to other functions
	- you can return them from other functions
*)

let sqaure x = x*x

let toThe4th x= sqaure(sqaure x)

let fourthRoot x = sqrt(sqrt x)

(* twice is an example of a *higher-order* function:
	function that takes another function as an argument 
 *)
let twice(f,x) = f(f x)

let rec ncalls(f,x,n) =
	match n with
	0 -> x
	| _ -> f(ncalls(f,x,n-1))

let rec ncalls2(f,x,n) =
	match n with
	0 -> x
	| _ -> 
		let rest = ncalls2(f,x,n-1))
		in f rest

(* Fucntions can be anonymous (lambda functions, closures)

	syntax: function pat -> exp
			function x -> x*x

They are closing over the environment; so are called closures
lambdas cuz they r like calculus fns. own little logical language
 *)
ncalls ((function x -> x*x),2,4)


let f y = y*y 
(*is equivalent to*)
let f = (function y -> y*y);;

(* function names are not special. They are just like variables. They are just values
	let f x = x*x is shorthand for
	let f = (function x -> x*x)
 *)

let swap = (function (x,y) -> (y,x))
let swap (x,y) = (y,x) ;;

(* Factorial *)
let rec fact n = 
	match n with
	| 0 -> 1
	| _ -> n * fact (n-1)

let rec fact = 
	(function n ->
		match n with
		0 -> 1
		| _ -> n* fact (n-1)) ;;

