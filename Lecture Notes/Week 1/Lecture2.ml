(* Lecture 2, Oct 7, 2014 *)

(* Acquamacs HackerRank *)

let rec sumList l =
	match l with
		[] -> 0
	| first::rest -> first+ (sumList rest)


(* grammar for the language

E ::= C | X | let X=E in E | if E then E else E
	| match E with P -> E '|' P -> E ...
	| (E,E,E...) 

C ::= C | _ | X | P::P
C ::= interger, boolean, string constants 
X ::= varaible names

example: pattern to represnet lists with at least 2 elements
	first::(second::rest) 
*)

(* everySecond [1;2;3;4;5] should return [2;4]*)
let rec everySecond l = 
	match l with 
		first::(second::rest) -> second::(everySecond rest)
		| _->[]


let rec everySecond l = 
	match l with 
		[] -> []
		| [_] -> []
		| _::second::rest -> second::(everySecond rest)

(* what does this pattern match? []::first::rest
	3::second::rest only matches [3;4;5]
	[]::[3;_]::rest
	[[];[3;4]]
	left argument is an elemetns of the list and the right argument is always the rest of the list(which can be an empty list)
*)

(* how to write a recursive fn:
	- one or more base cases

	- one r more recursive cases
		- make a recrusive call
		- assume the result of the recursive call does what you want
		- use that result to build the answer for the entire thing
*)

(* example: find the prime numbers upto n 
	top-down what do we need? 
	1. check whether each element in {2..n} is prime
	2. check whether a given n is divisible by any number in {2..sqrt(n)}
*)

(* assume isPrime n exists *)
let rec preimesUpTo n =
	if n=1 then []
	else
		if isPrime n then n::(preimesUpTo(n-1))
		else preimesUpTo(n-1)
	
let rec preimesUpTo2 n =
	match n with
	1 -> []
	| _ when isPrime n -> n::(preimesUpTo2(n-1))
	| _ -> preimesUpTo2(n-1)


(* helper fucntion *)
let isPrimeHelper (n,i) =
	match n with
	1 -> false
	| 2 -> true
	| _ when i=n -> true
	| _ when (n mod i=0) -> false
	| _ -> isPrimeHelper(n,i+1)

let isPrime n = isPrimeHelper(n,2)

(* use it as nested function *)
let isPrime n =
	let isPrimeHelper (n,i) =
		match n with
		1 -> false
		| 2 -> true
		| _ when i=n -> true
		| _ when (n mod i=0) -> false
		| _ -> isPrimeHelper(n,i+1)
	in isPrimeHelper(n,2)

(* tuples can be size 2 or more
Every fn takes only 1 argument. The argument can be a tuple or a tuple pattern
Every function take a single arhument and returns a single arguement

Function with no arguments
empty tuple

really useful can be multiple return values
 *)

let add(x,y) = x+y

let three()= 3

(* zip([1;2;3], [4;5;6]) = [(1,4); (2,5); (3,6)] *)
let rec zip (l1,l2) = 
	match  (l1,l2) with
	| ([],[]) -> []
	| (h1::t1, h2::t2) -> (h1,h2):: (zip(t1,t2))
	

(* unzip [(1,4); (2,5); (3,6)] = ([1;2;3], [4;5;6]) *)
let rec unzip2  l =
	match l with
	[] -> ([],[])
	| (x,y)::rest -> 
		match (unzip2 rest) with
		(l1,l2) -> (x::l1, y::l2)

let rec unzip3  l =
	match l with
	[] -> ([],[])
	| (x,y)::rest -> 
		let (l1,l2) = (unzip3 rest)[]
		in (x::l1, y::l2)

(* This is similar to C and then translating it to Ocaml
	The @ operation is linear
 *)
let rec unzipHelper(zipped,unzipped) = 
	match (zipped,unzipped) with
	((x,y)::rest, (li,l2)) -> unzipHelper(rest,(l1@[x], l2@[y])
	| ([], l) -> l

let unzip l = unzipHelper(l, ([],[]))
