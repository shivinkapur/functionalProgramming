
let rec fact n =
  (* pattern matching *)
  match n with
      0 -> 1
    | _ -> n * (fact(n-1))

(* local variables:
   let x=e1 in e2 *)
let rec isEven n =
  let n = if n<0 then -n else n
  in
    match n with
	0 -> true
      | 1 -> false
      | _ -> isEven(n-2)

let rec isEven2 n =
  match n with
      0 -> true
    | 1 -> false
    | _ -> if n<0 then isEven2(n+2) else isEven2(n-2)

let rec isEven3 n =
  match n with
      0 -> true
    | 1 -> false
    | _ when n<0 -> isEven3(n+2)
    | _ -> isEven3(n-2)
	
let rec sumList l =
  match l with
      [] -> 0
    | first::rest -> first + (sumList rest)

(* grammar for the language

 E ::= C | X | let P=E in E | if E then E else E
     | match E with P -> E '|' P -> E ...
     | (E,E,E,...)

 P ::= C | _ | X | P::P | (P,P,...)
   
 C ::= integer, boolean, string constants
 X ::= variable names

 example: pattern to represent lists with at least 2 elements
     first::(second::rest)
   
*)   

(* everySecond [1;2;3;4;5] should return [2;4] *)	
let rec everySecond l =
  match l with
      [] -> []
    | [_] -> []
    | _::second::rest -> second::(everySecond rest)

(* how to write a recursive function:

   - one or more base cases

   - one or more recursive cases
      - make a recursive call
      - assume the result of the recursive call does what you want
      - use that result to build the answer for the entire thing   

*)
	
let rec everySecond2 l =
  match l with
      _::second::rest -> second::(everySecond rest)
    | _ -> []

(* what does this pattern match?  []::second::rest

   3::second::rest only matches [3;4;5]

   []::[3;_]::rest
   
   [[]; [3;4]]
   
*)

(* example: find the primes up to n

   top-down what do we need?

   1. check whether each element in {2..n} is prime

   2. check whether a given n is divisible by any number in
      {2..n}
   
*)


let isPrime n =
  let rec isPrimeHelper (n,i) =
    match n with
	    | 1 -> false
      | 2 -> true
      | _ when i=n -> true
      | _ when (n mod i = 0) -> false
      | _ -> isPrimeHelper(n,i+1)
  in isPrimeHelper(n,2)
	
(* assume isPrime n exists *)	
let rec primesUpTo n =
  match n with
      1 -> []
    | _ when isPrime n -> n::(primesUpTo(n-1))
    | _ -> primesUpTo(n-1)
    

let add(x,y) = x+y
  
let three() = 3

(* zip([1;2;3], [4;5;6]) = [(1,4); (2,5); (3,6)] *)
let rec zip (l1,l2) =
  match (l1,l2) with
    | ([], []) -> []
    | (h1::t1, h2::t2) -> (h1,h2)::(zip(t1,t2))


(* unzip [(1,4); (2,5); (3,6)] = ([1;2;3], [4;5;6]) *)	

(* The following is an iterative version
   - not a typical ML style
   - more like a translation of a C program to ML
   - (but this style can be useful sometimes, as we'll see later *)
	
let rec unzipHelper (zipped, unzipped) =
  match (zipped, unzipped) with
      ((x,y)::rest, (l1,l2)) -> unzipHelper (rest, (l1@[x], l2@[y]))
    | ([], l) -> l

let unzip l = unzipHelper(l, ([],[]))  
  

(* This is the natural recursive algorithm in ML *)
let rec unzip2 l =
  match l with
      [] -> ([], [])
    | (x,y)::rest -> let (l1,l2) = (unzip2 rest)
	                   in (x::l1, y::l2)    
