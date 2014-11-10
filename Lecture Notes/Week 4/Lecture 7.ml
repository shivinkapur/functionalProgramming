(* Lecture 7 *)

(* Midterm exam
closed book
closed notes

Ocaml programming problems

recursion
first-class functions(map,fold,etc)
pattern matching
datatypes

No excpetions, dynamic scoping on Midterm

Concepts: 
static vs dynamic typechecking
static scoping
parametric polymorphism
overloading


Overloading is less in OCaml
= and < are overloaded in Ocaml
Ocaml cheats with overloading by doing parametric polymorphism 
(=) can operate on ints, floats, lists

Cons is polymorphic

MOCaml
if true then 0 else false - Test

Remove begin and end
 *)
(* 
... try e1 + e2
	with Exp1 -> 
 ...

 (try e1 
 	with Exp1 -> 0) + e2
  *)

(* Exceptions
	- implicitly propogate erros up the call stack
		- good: simplifies your code
			- only the code that needs to handle the exception does something special
			- all other code just deals with the normal case
			- can use them to fail eearly
		- bad: easy to foget to check for an exception

 *)

let inc x = x + 1

exception NegativeError
let incIfNonNeg l = List.map(fun x -> if x<0 then raise NegativeError else (inc x)) l

exception NegativeError2 of int 
let incIfNonNeg2 l = List.map(fun x -> if x<0 then raise (NegativeError2 x) else (inc x)) l

let incIfNonNeg3 l = 
	try
		List.map(fun x -> if x<0 then raise (NegativeError2 x) else (inc x)) l
	with
		NegativeError2 n -> []


(* Modules 
Can be used for namespace management

Is also called a structure

You could also nest modules
*)
module Dict = struct

type ('a, 'b) t = ('a * 'b) list

let empty = []
  
let put k v d = (k,v)::d

let rec get k d =
  match d with
      [] -> None
    | (k', v')::d' ->
      if k'=k then Some v' else get k d'
end


(* We'd like to separate *interface* from *implementation* 
	
	Above, we're using lists as our implementation of dictionaries 
	Why is this undersiarable? 
	- maintainability / software evolution
		- the implmenter wants flexibility to change the implmentation without breaking clients
		- should not expose all details to user. Basically wanna built an interface
	- security and privacy - wanna be able to hide things
	- might be necessary for correctness
		- examle: consider a set implmented as a list
		- can't ensure the invariant that the list has no duplicates

*)

module type DICT = sig
(* t is abstract *)
	type ('a, 'b) t
	val empty : ('a , 'b)t
  	val put : 'a -> 'b -> ('a, 'b)t -> ('a, 'b)t
  	val get : 'a -> ('a, 'b)t -> 'b option
end
(* 
module Dict:DICT

let d = Dict.empty;;

let d2= Dict.	 *)

module Dict:DICT = struct

type ('a, 'b) t = ('a * 'b) list

let empty = []
  
let put k v d = (k,v)::d

let rec get k d =
  match d with
      [] -> None
    | (k', v')::d' ->
      if k'=k then Some v' else get k d'
end

