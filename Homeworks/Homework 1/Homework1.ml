(* Write a function clone of type 'a * int -> 'a list. 
The function takes an item e and a nonnegative integer n and returns a list containing n copies of e. For example, clone("hi", 4) returns ["hi"; "hi"; "hi"; "hi"].
*)
let rec clone ((e, n) : 'a * int) : 'a list =
match n with
0 -> []
| _ -> e::(clone(e,n-1))


(*
	Write a function rev that reverses the elements in a list.

Examples:
# rev [1;2;3];;
- : int list = [3; 2; 1]
# rev ['z'];;
- : char list = ['z']
*)
let rec rev (l: 'a list) : 'a list =
match l with 
[] -> l 
| x::rest -> rev(rest)@[x]

(*
	The naive algorithm for reversing a list takes time that is quadratic in the size of the argument list. In this problem, you will implement a more efficient algorithm for reversing a list: your solution should only take linear time. Call this function fastRev. The key to fastRev is that it builds the reversed list as we recurse over the input list, rather than as we return from each recursive call. This is similar to how an iterative version of list reversal, as implemented in a language like C, would naturally work.

	To get the right behavior, your fastRev function should use a local helper function revHelper to do most of the work. The helper function should take two arguments: (1) the suffix of the input list that remains to be reversed; (2) the reversal of the first part of the input list. The helper function should return the complete reversed list. Therefore the reversal of an input list l can be performed via the invocation revHelper(l, []). I've already provided this setup for you, so all you have to do is provide the implementation of revHelper (which is defined as a nested function within fastRev) and invoke it as listed above. The call (fastRev (clone(0, 10000))) should be noticeably faster than (rev (clone(0, 10000))).
*)

let fastRev (l : 'a list) : 'a list =
    let rec revHelper (remain, sofar) =
    match remain with
    [] -> sofar
    | x::rest -> revHelper(rest, x:: sofar)

in revHelper(l, [])

(*
	Write a function tails of type 'a list -> 'a list list that takes a list and returns a list of lists containing the original list along with all tails of the list, from longest to shortest. For example, tails [1;2;3] is [[1;2;3];[2;3];[3];[]].
*)

let rec tails (l : 'a list) : 'a list list =
match l with
[] -> [[]]
| _::rest -> l::(tails rest)


(*
	Write a function to return the second-to-last element of a list. To deal with the case when the list has fewer than two elements, the function should return a value of the built-in option type, defined as follows:

	type 'a option = None | Some of 'a 

	Example:
	# penultimate [1;2;3];;
	- : int option = Some 2
	# penultimate ["a"];;
	- : string option = None
*)

let rec penultimate (l: 'a list) : 'a option =
match l with 
[] -> None
| [a] -> None
| [a;b] -> Some a
| x::rest -> penultimate rest

let rec penultimate1 (l: 'a list) : 'a option =
    match l with
    | [] -> None
    | [x] -> None
    | [x;y] -> Some x
    | x::xs -> penultimate1(xs);;

let rec penultimate2 (l: 'a list) : 'a option =
match l with 
[] -> None
| [a;b] -> Some(a) (* Handling only 2 elements case*)
| x::rest -> penultimate2 rest

(*
	Flatten a list of lists.

	Example:
	# flatten [[2]];;
	- : int list = [2]
	# flatten [[2]; []; [3;2]];;
	- : int list = [2; 3; 2]
*)

let rec flatten (l: 'a list list) : 'a list =
match l with 
[] -> []
| x::rest -> x @ (flatten rest)

(*
	Convert a list of digits (assumed to be numbers between 0 and 9) into an integer. You may assume that the first element of the list is not 0.

	Example:
	# intOfDigits []
	- : int = 0
	# intOfDigits [3;1;0;2]
	- : int = 3102
*)

let intOfDigits (l: int list) : int =
    let rec reverse (l: 'a list) : 'a list =
    match l with
    | [] -> []
    | x::rest -> reverse(rest)@[x]
    in let lRevInt = reverse (l) in
        let rec intOfRevDigits l2 = 
        match l2 with
        | [] -> 0
        | [x] -> x
        | x::rest -> x+(intOfRevDigits(rest)*10)
    in intOfRevDigits(lRevInt);;

let rec intOfDigits2 (l: int list) : int =
let rec helpToInt(l,n) =
      match l with
       [] -> n
     | x::rest -> helpToInt(rest,(n*10 + x))
in helpToInt(l,0)

(*
	Merge two sorted lists of integers into a single sorted list. You may assume that the given lists are both sorted already.

	Example:
	# merge ([1;3;5], [2;4])
	- : int list = [1;2;3;4;5]

    utop # merge([3;6;76],[4;5;6;4;3]);;
- : int list = [3; 4; 5; 6; 4; 3; 6; 76]  
In this above example, the list is not sorted! So it didn't work
*)

let rec merge ((l1, l2): int list * int list) : int list =
    match (l1,l2) with
    ([],[]) -> []
    | (x::rest,[]) -> x::merge(rest,[])
    | ([],x::rest) -> x::merge([],rest)
    | (x::restx,y::resty) when x < y -> x::merge(restx, l2) 
    | (_,y::resty) -> y::merge(l1,resty)

let rec merge1 ((l1, l2): int list * int list) : int list = 
	match (l1, l2) with
    | ([], []) -> []
    | ([], x::xs) -> x::merge1([], xs)
    | (x::xs, []) -> x::merge1(xs, [])
    | (x1::xs1, x2::xs2) -> 
    if (x1 <= x2) then x1::merge1(xs1, l2)
    else x2::merge1(l1, xs2);;

let rec merge2 ((l1,l2) : int list * int list) : int list =
    match (l1, l2) with
      ([], _) -> l2
    | (_, []) -> l1
    | (x::xs, y::ys) when x<y -> x::(merge2(xs, l2))
    | (_, y::ys) -> y::(merge2(l1, ys))


(*
Implement the so-called run-length encoding data compression method. Consecutive duplicates of elements are encoded as lists (N, E) where N is the number of duplicates of the element E. Don't define any helper functions.

Examples:
# encode [];;
- : (int * 'a) list = []
# encode ["a"];;
- : (int * string) list = [(1, "a")]
# encode ["a";"a"];;
- : (int * string) list = [(2, "a")]
# encode ["a";"b";"b"];;
- : (int * string) list = [(1, "a"); (2, "b")]
# encode ["a";"b";"b";"a";"a"];; 
- : (int * string) list = [(1, "a"); (2, "b"); (2, "a")]

*)
let rec encode (l: 'a list) : (int * 'a) list =
    match l with
    [] -> []
    | [x] -> [(1,x)]
    | x::restx -> let (n,y)::resty = encode restx in 
        if x=y then (n+1,x)::resty
    else (1,x)::(n,y)::resty
    
(*
let rec pack (l: 'a list) : 'a list list =
  match l with
      [] -> []
    | [_] -> [l]
    | x::xs ->
	let (y::ys)::rest = pack xs in
	  if x=y then (x::y::ys)::rest
	  else [x]::(y::ys)::rest
*)	    
(* 
Rotate a list n places (i.e., take n elements off the front and move them to the back). You may assume n is between 0 and the length of the list, inclusively. Do not define any helper functions.

Examples:
# rotate ([1;2;3;4], 3);;
- : int list = [4; 1; 2; 3]
# rotate ([1;2;3;4;5;6;7;8], 2);;
- : int list = [3; 4; 5; 6; 7; 8; 1; 2]

*)

let rec rotate ((l, n) : 'a list * int) : 'a list = 
    match n with
    | 0 -> l
    | _ -> match l with
            [] -> []
            | x::rest -> rotate(rest@[x],n-1)


(*
Convert a (decimal) integer into binary by encoding it as a list of integers. You may use the builtin modulo operator mod : int * int -> int. Don't define any helper functions.

Examples:
# dec2bin 0;;
- : int list = [0]
# dec2bin 1;;
- : int list = [1]
# dec2bin 2;;
- : int list = [1; 0]
# dec2bin 3;;
- : int list = [1; 1]
# dec2bin 4;;
- : int list = [1; 0; 0]
# dec2bin 15;;
- : int list = [1; 1; 1; 1]
*)
let rec dec2bin (n: int) : int list = 
    match n with
     | 0 -> [0]
     | 1 -> [1]
     | _ -> dec2bin(n/2) @ [n mod 2]
(* Need to check for negative value *)

(*
Write a function pairify of type 'a list -> ('a * 'a) list that takes a list and pairs up consecutive elements of the list. If the list has an odd length, then the last element should be dropped from the result. Do not define any helper functions.

Examples:

# pairify [1;2;3;4];;
- : (int * int) list = [(1, 2); (3, 4)]
# pairify [1;2;3;4;5];;
- : (int * int) list = [(1, 2); (3, 4)]
*)

let rec pairify (l : 'a list) : ('a * 'a) list =
    match l with
    | [] -> []
    | [x] -> []
    | h1::h2::rest -> [(h1,h2)] @ pairify(rest)



