l(* twice((function x -> x*X),4);; *)

(*It is a shorthand for *)
let square = (function x-> x*x) ;;

(* functions can return other functions *)
let returnsAdd () =
let add (x,y) = x + y
in add

let myadd = returnsAdd();;

let returnsAdd2 () =
	function (x,y) -> x + y

let twice' f =
	(function x -> f(f x))
(* This can let u pass the argument twice
	You can get a function back
	You can call it partially and with all arguments
	Passing multiple arguments
	This is called currying
	It is a natural style in OCaml
*)

(* shorthand for: *)
let twice'' f =
	function f ->
		function x -> f (f x)
(*equivalent*)
let twice3 =
	fun f x -> f (f x)

let twice4 f x = f (f x)

let toThe4thPower = twice' (function x -> x*x);;


let add (x,y) = x + y ;;

let add x y = x + y ;;
(* Curried version
	See interpreter for difference
 *)

let addTo3 =  add 3;;
(* addTo3 45;; *)

add 3 4;;
(* ans: int = 7*)

(* add(3,4);;
 error

let p -> (3,4) ;;


(function (x,y) -> add x y) p;;
	ans int = 7 *)


(* Where would you use a first class function ?
	For Map-Reduce; parallel programming
	For ansync programming
*)


(* Use case: iterating over collections *)
(*
you can also pattern match directly with function
let rec incLst l =
	function
		[] -> []
*)

let rec incLst l =
	match l with
	| [] -> []
	| x::xs -> (x+1) :: (incLst xs)

(* Swap the components in a list of pairs *)
let rec swapLst l =
	match l with
	[] -> []
	| (x,y)::rest -> (y,x)::(swapLst rest)


(* See List.map
it takes 2 arguments in curried style
*)

List.map(function x -> (x+1)) [1;2;3;4];;

List.map(function (x,y) -> (y,x)) [(1,2);(3,4)];;

let incLst2 l = List.map ( function x -> x+1 ) l ;;

let incLst3 = List.map ( function x -> x+1);;

(* Writing the map function
Takes a function and a list and applies the function on each element of the list
*)

let map f l =
	match l with
	 [] -> []
	 | first::rest -> (f first)::(map f rest)

(* OCaml doesn't have threads *)

let incByN n l = List.map ( function x -> x+n) l
(*
incByN 3 [1;2;3];;
*)

List.filter (function x-> x>0) [1;2;-1;0];;
(* ans int list = [1;2]
*)

(* Reduce list / Fold a list
	aggregation
	Map always returns a list
*)

let rec sumLst4 l =
	match l with
	[] -> 0
	| x::xs -> x + (sumLst4 xs)

let sumLst5 l =
	List.fold_right(fun x y -> x+y) l 0;;

let rec contains e l =
	match l with
	[] -> false
	| x::xs when x=e -> true
	| _::xs -> contains e xs

let contains2 e l =
	List.fold_right
		(fun x recursiveResult -> x=e || recursiveResult)
		l false
(* This will go through whole list *)

(* Return index at which
Fold will need to carry around a tuple
*)

let indexOf e l =
	List.fold_right
		(fun x recursiveResult ->
			if x=e then Some 1 else
			match recursiveResult with
				None -> None
				| Some i -> Some (i+1))
		l None

(*
 List.fold_right;;
- : ('a -> 'b -> 'b) -> 'a list -> 'b -> 'b = <fun>

'a is the type of the given list
'b is the result type of the fold operation

fold_right f [x1;x2;...xn] b =
	(f x1(f x2 (f x3 ... )))


List.fold_right(fun x y -> x+y) [1;2;3;4;5] 0;;
- : int = 15
*)


(* Implement fold_right *)
let rec fold_right f l b =
	match l with
	[] -> b
	|  first::rest -> (f first) (fold_right f rest b)

(*
Any operator, u can turn it into a function by putting parenthesis around it
fold_right (+) [1;2;3;4;5] 0

Can't put (*) since it is for comments
So, u can put ( * )
*)

List.fold_right( * ) [1;2;3;4;5] 1;;
- : int = 120

List.fold_left( * ) 1 [1;2;3;4;5] ;;
- : int = 120

List.fold_left f b [x1;x2;..;xn] =
(f(f(f... (f b x1)...)))
*)
(*
let indexOf e l =
	List.fold_left
		(fun  (i,res) x ->
			if x=e then Some 1 else
			match recursiveResult with
				None -> None
				| Some i -> Some (i+1))
		(0,None) l  *)

(* utop # List.fold_right(fun x y -> x::y) [1;2;3;4;5] [];;
- : int list = [1; 2; 3; 4; 5]                                                                                                                                                       ─( 13:25:43 )─< command 27 >──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────{ counter: 0 }─utop # List.fold_left(fun x y -> x::y) [] [1;2;3;4;5];;
Error: This expression has type 'a list                                                                                                                                                     but an expression was expected of type 'a                                                                                                                                            The type variable 'a occurs inside 'a list
─( 13:33:52 )─< command 28 >──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────{ counter: 0 }─
utop # List.fold_left(fun y x -> x::y) [] [1;2;3;4;5];;
- : int list = [5; 4; 3; 2; 1]
 *)

(*
fold_left vs fold_right -> left is better cuz it can run faster
*)

utop # List.fold_right(fun x y-> x-y) [1;2;3] 0;;
- : int = 2
utop # List.fold_left(fun x y-> x-y) 0 [1;2;3];;
- : int = -6
