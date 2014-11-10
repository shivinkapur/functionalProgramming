(*
Map is useful if u need to change each element on the list in some way
*)

let contains3 e l = 
	List.fold_left
		(fun recursiveList x -> x=e || recursiveList)
		false l

(* In this case, it is not selective 
	Sometimes you have to pick one.
	Look at indexOf from last lecture.
*)


let indexOf e l = 
	let (_,result) =
	List.fold_left
		(fun  (i,res) x -> 
			match res with
				None -> if x=e then (i+1, Some(i+1)) else (i+1,None)
				| Some _ -> (i,res)
		(0,None) l 
	in result

(* Lecture 5
	Scoping
	Types
	Static Type Checking
	Dynamic Type Checking
*)

(* Scoping 
	when a varaible is used (or referenced), which variable declration does it refer to?

Look outside the view, look for the nearest definition

Lexical or static scoping:
The variable referred to is always the declaration of that varaible that textualy is nearest in the enclosing scope
*)

let x = 5
(* x is now in scope for the rest of the file 
All the functions are similar. They are also global.
*)

let double n = n*2
(* double in scope for the rest of the file
	n is in scope just in the body of double
 *)

let rec fact n = 
	match n with
	| 0 -> 1
	| i -> i*fact(i-1)
(* i is in scope just for that case of pattern match *)
(* fact is in scope in its own definition and for the rest of the file *)

let x = x+1 (* here on right side(x+1) it will look outside, lexical; 5+1 *)
in x + 54
(* x is in scope just in the expression after "in" *)

(* let rec x = x+1 will throw an error
 functions are lazy, they arent called the moment they are declared, and when u do call a function, you know that it has already been declared *)

(* variables can sometimes go out of scope, but still remain in memory for function definitions *)             

(* TYPES *)

(* 
	What is a value?
	- its is any legal result of a program or an expression

	What is type?
	- a set of values that have a shared set of operations 
	example: int is the set of 32-bit integers
		they share operations like +,-,*,> etc

	int list
	[], [1;2;3]
	::, @

	int * bool
	(1,true)
	access components (by pattern matching)

	int -> bool
	(function x -> x>3)
	call it

	Several dimensions on which to evaluate type systems:

	1. Static vs Dynamic typechecking
		- static means at compile time or before execution
		- give each expression E in the program a type T
			- guarantee: if E has type T then
				at run time the value of E (if E's evaluation terminates normally) will be a memeber of the set T

		advantages: 
		- catch errors early
			- checking all possible execution of a funtion
		- faster at runtime
			- no need to re-check types at runtime
			- allows some compiler optimizations
		- program documentation

		disadvantages
		- slower compilation
		- restrictive (conservative)
			- can reject ur program even if its not buggy
		[1;"hi";34;"bye"];;
Error: This expression has type bytes but an expression was expected of type int
Python will let u do this. Python is more lighweight. and dynamic typechecking

	OCaml has type inference too!


	Dynamic typechecking:
		Pythong, JS, Lisp, Perl, php, bash
		it checks the operands to see if its the right type. checks values at runtime.

		Just run the code
		but, before every primitive operation, 
			- check that the operation ius being passed the values of the right type


	2. Strong vs Weak typechecking
		- stronly typed means that the language never allows an operation to be invoked with operands of the wrong type
		- never allows undefnied behavior
		eg: Python is strongly typed

		Casting
		Language C

		- weakly typed means u can get into an undefined state (and keep executing)
		the only weakly typed languages are C and C++
			- cast
				(int) e
			- weakly types lanuages are not memory safe
				- a memory safe language is one that only allows the program to access memory that is allocated
				- access elements of an array out of bounds
				- treat int as a pointer
				- dangling pointers

			how do strongly typed langs deal with this?
				- runtime checks (array bound)
				- hide the pointers
				- garbage collection

		stronly and static are kind of orthogonal
		strong/static : Java, OCaml
		stong/dynamic: Python, php, js, lisp, smalltalk
		weak/static: c,c++
		weak/dynamic: ??

	KEY IDEA:



*)
