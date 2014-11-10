
(* A simple test harness for the MOCaml interpreter. *)

(* put your tests here:
   each test is a pair of a MOCaml declaration and the expected
   result, both expressed as strings.
   use the string "dynamic type error" if a DynamicTypeError is expected to be raised.
   use the string "match failure" if a MatchFailure is expected to be raised.
   use the string "implement me" if an ImplementMe exception is expected to be raised

   call the function runtests() to run these tests
*)
let tests = [
    ("3", "3");                                   (* IntConst of int *)   
    ("true", "true");                               (* BoolConst of bool *)          
    ("false", "false");                             (* BoolConst of bool *)
    ("[]", "[]");                                   (* Nil *)
    ("let x = 34", "val x = 34");                   (* Let of string * moexpr *)
    ("x", "34");                                    (* Var of string *)
    ("y", "dynamic type error");                    (* Var of string *)
    ("3 + 4", "7");                                 (* BinOp of moexpr * Plus * moexpr *)
    ("x + 4", "38");                                (* BinOp of moexpr * Plus * moexpr *)
    ("3 * 4", "12");                                (* BinOp of moexpr * Minus * moexpr *)
    ("3 + 4", "7");                                 (* BinOp of moexpr * Times * moexpr *)
    ("3 = 4", "false");                             (* BinOp of moexpr * Eq * moexpr *)
    ("5 = 5", "true");                              (* BinOp of moexpr * Eq * moexpr *)
    ("3 > 4", "false");                             (* BinOp of moexpr * Gt * moexpr *)
    ("4 > 3", "true");                              (* BinOp of moexpr * Gt * moexpr *)
    ("4::[]", "[4]");                               (* BinOp of moexpr * Cons * moexpr *)
    ("4::[5]", "[4; 5]");                           (* BinOp of moexpr * Cons * moexpr *)
    ("4::[5;6]", "[4; 5; 6]");                      (* BinOp of moexpr * Cons * moexpr *)
    ("-x", "-34");                                  (* Negate of moexpr *)
    ("-8", "-8");                                   (* Negate of moexpr *)
    ("-(8+9)", "-17");                              (* Negate of moexpr *)
    ("let y = 50", "val y = 50");                   (* Let of string * moexpr *)
    ("if x > y then true else false", "false");     (* If of moexpr * moexpr * moexpr *)
    ("if y > x then true else false", "true");       (* If of moexpr * moexpr * moexpr *)

    (* My test cases, check if correct *)
    (* simple tests *)
    ("x + 4", "38");
    ("x - 4", "30");
    ("x * 4", "136");
    ("x = 34", "true");
    ("x = 0", "false");
    ("x > 33", "true");
    ("35 > x", "true");
    ("x > 35", "false");
    ("5::3", "dynamic type error");
    ("-x", "-34");
    ("33 > -x", "true");
    ("-[]", "dynamic type error");
    ("(if x = 34 then 2 else 3)::[2; 3]", "[2; 2; 3]");
    ("if 1 then 2 else 3", "dynamic type error");
    ("if [2; 3] then 5 else 10", "dynamic type error");
    ("if 2 > 5 then 20 else 3", "3");

    (* non-recursive function testing *)
    ("let newfunc = function x -> x * x", "val newfunc = <fun>");
    ("newfunc 2", "4");
    ("newfunc(2)", "4");
    ("let timesThreeNums = function a -> function b -> function c -> a * b * c", "val timesThreeNums = <fun>");
    ("timesThreeNums 2 3 4", "24");
    ("let multSix = timesThreeNums 2 3", "val multSix = <fun>");
    ("multSix 2", "12");
    ("let a = function true -> false", "val a = <fun>");
    ("a 1", "match failure"); (* not sure about this one *)
    ("let b = function _ -> true", "val b = <fun>");
    ("b 1", "true");
    ("b [1; 2; 3]", "true");
    ("let decapitate = function head::tail -> tail", "val decapitate = <fun>");
    ("decapitate [1; 2; 3]", "[2; 3]");
    ("decapitate [1]", "[]");
    ("decapitate []", "match failure");
    ("(function _ -> x) 42", "34");

    (* pattern matching *)
    ("let l = [1; 2; 3]", "val l = [1; 2; 3]");
    ("match l with 1::2::[] -> true | _ -> false", "false");
    ("match l with 1::2::rest -> rest", "[3]");
    ("match 5 with s -> s", "5");
    ("match 10 with _ -> x", "34");
    ("(function s -> match s with head::tail -> head = x) [34; 2]", "true");
    ("match 20 with x -> x", "20");
    ("match 1 with 1 -> (match 2 with 1 -> false) | _ -> true", "match failure");

    (* recursive function testing *)
    ("let rec recTest num = match num with 0 -> 0 | s -> 1 + (if s > 0 then recTest(s-1) else recTest(s+1))", "val recTest = <fun>");
    ("recTest 10", "10");
    ("recTest (-10)", "10");
    ("let rec recTest2 _ = recTest2", "val recTest2 = <fun>");
    ("recTest2", "<fun>");
    ("recTest2 1 2 3 4 5 6 7 8 9 10 11 12", "<fun>");
    ("let rec fact n = if n > 0 then n * fact (n - 1) else 1", "val fact = <fun>");
    ("fact 5", "120");
    ("let rec map f = function l -> match l with [] -> [] | x::xs -> (f x)::(map f xs)", "val map = <fun>");
    ("(map fact) [1;2;3;4;5]", "[1; 2; 6; 24; 120]");

    (* Scope testing *)
    ("let f = function x -> x", "val f = <fun>");
    ("let g = function x -> x + (f x)", "val g = <fun>");
    ("let f = function x -> x * 23", "val f = <fun>");
    ("g 5", "10");
    ("f 5", "115");
    ("let rec f l = function v -> match l with [] -> v | x::xs -> (f xs v+1)", "val f = <fun>");
    ("f [5;3;2] 0", "3");
    ("let rec f g = match g with f -> f 0", "val f = <fun>");
    ("f (function _ -> 5)", "5"); (* recursive name shadowed by match. *)
    ("let rec f l = match l with [] -> 0 | x::xs -> x + f xs", "val f = <fun>");
    ("f [1;2;3]", "6"); (* Recursive name shadowing other f *)

  (* Testing Errors *)
  ("false + false", "dynamic type error");
  ("1 + false", "dynamic type error");
  ("1 - false", "dynamic type error");
  ("1 * false", "dynamic type error");
  ("1 > false", "dynamic type error");
  ("1 = false", "dynamic type error");
  ("4::5", "dynamic type error");

    (* 
    Tricky with env variable, not sure if our mocaml need to support this.
    It relate to the sequence that add_binding 'function f' first or add_binding 'variable f' first
    *)

    ("let l = [1; 2; 3]", "val l = [1; 2; 3]");
    ("match l with x::x::x::[] -> x", "3");
    (* ("match l with x::x::x::[] -> x", "1"); *)

    ("let f = 2", "val f = 2");
    ("let rec f f = match f with 0 -> f | _ -> (f+1)", "val f = <fun>");
    ("f 1","2");

    ("3", "3"); 
    ("false", "false");
    ("let x = 34", "val x = 34");
    ("aa", "dynamic type error");
    ("x + 4", "38");
    ("let z = function y -> y +4 + nonexistingfunc var","val z = <fun>"); (*make func with nonexisting variable and function *)
    ("z 2", "dynamic type error"); (*test our non working function*)
    ("let z = function y -> y +4 + x","val z = <fun>"); (*make one that works*)
    ("z 2","40"); (*use it*)(*why is it 40 and not 44? we didn't use "let x = x + 4" *)
    ("let count = function list -> match list with [] -> 0 | x::xs -> 1 + count xs","val count = <fun>");
    ("let count = function list -> match list with [] -> 0 | x::xs -> 1 + count xs","val count = <fun>"); (*should still not work as first count still has no count to reference*)
    ("let rec count list = match list with [] -> 0 | x::xs -> 1 + count xs","val count = <fun>");(*make one that works*)
    ("let mylist2 = [4;5;true]","val mylist2 = [4; 5; true]"); (*make a list*)
    ("count mylist2","3"); (*count the list*)
    
    (* Declarations *)
    ("let  i1 = 10", "val i1 = 10");
    ("let  i2 = 34", "val i2 = 34");
    ("let  b1 = false", "val b1 = false");
    ("let  b2 = true", "val b2 = true");
    ("let x = 34", "val x = 34");
    ("x" , "34");
    ("aa", "dynamic type error");
    ("x + 4", "38");
    ("let b = true" ,"val b = true");
    ("x + b", "dynamic type error");

    (* BinOp *)
    ("let  i3 = i1 * i2", "val i3 = 340");
    ("let i3double = i3 + i3", "val i3double = 680");
    ("i3 > i1", "true");
    ("i1 = 10", "true");
    ("b1 = b2", "dynamic type error");
    ("5 + 6", "11");
    ("13 - 3", "10");
    ("15 * 2", "30");
    ("5 = 1" , "false");
    ("5 = 5" , "true");
    ("5 > 1" , "true");
    ("5 > 5" , "false");
    ("5 > false" , "dynamic type error");
    ("i3 > false" , "dynamic type error");
    ("5 > b1" , "dynamic type error");
    ("true > false" , "dynamic type error");
    ("true = true" , "dynamic type error");
    ("false = true" , "dynamic type error");
    ("1 = true" , "dynamic type error");
    ("true = 10" , "dynamic type error");
    ("true + false" , "dynamic type error");
    ("true - false" , "dynamic type error");
    ("true * false" , "dynamic type error");
    ("5 + false", "dynamic type error");
    ("[5] > 7" , "dynamic type error");
    ("[5] = 5" , "dynamic type error");
    ("[17] * 40" , "dynamic type error");
    ("30 - [15]" , "dynamic type error");

    (* Basic list syntax *)
    ("let l1 = [1;2;3;4]" , "val l1 = [1; 2; 3; 4]");
    ("[]" , "[]");
    ("[5]" , "[5]");
    ("[5; true]" , "[5; true]");
    ("5::true::[]" , "[5; true]");
    ("1::2::3::4::[]" , "[1; 2; 3; 4]");
    ("[]::5" , "dynamic type error");
    ("[50]::10" , "dynamic type error");
    ("[]::false" , "dynamic type error");
    ("[50]::true" , "dynamic type error");
    ("true::1" , "dynamic type error");
    ("2::false" , "dynamic type error");
    ("true::true" , "dynamic type error");
    ("5::7" , "dynamic type error");
    ("5::garbage" , "dynamic type error");

    (* Nested Lists *)
    ("[[[[1]]]]" , "[[[[1]]]]");
    ("[[1];[2;3;4];[];[];[5;6]]", "[[1]; [2; 3; 4]; []; []; [5; 6]]");
    ("[(21-1)]::[[1];[2;3;4];[];[];[5;6]]" , "[[20]; [1]; [2; 3; 4]; []; []; [5; 6]]");
    ("((10+10)::[])::[[1];(2::(3*1)::4::[]);[5;6]]" ,"[[20]; [1]; [2; 3; 4]; [5; 6]]" );

    (* If statements *)
    ("if true then 5 else false" , "5");
    ("if false then 5 else false" , "false");
    ("if i1>5 then i1 else 5" , "10");
    ("if i3=i1 then b1 else b2" , "true");
    ("if (5+10)>(12 -1) then (if b2 then 100 else true) else false" , "100");
    ("if (5+10)=(12 -1) then (if b2 then 100 else true) else false" , "false");
    ("if 1 then 5 else 10" , "dynamic type error");
    ("if i1 then 15 else 10" , "dynamic type error");
    ("if true then true + false else 14 " , "dynamic type error");
    ("if 1::2::3::[] then 5 else 10" , "dynamic type error");
    ("if true = 1 then 10 else 1" , "dynamic type error");


    (* Pattern Matching *)
    ("match true  with  10 -> 100" , "match failure");
    ("match 10 with 14  -> true " , "match failure");
    ("match (10+5) with 0 -> false | 15 -> true" , "true");
    ("match (i3*2) with i2 -> (i2 + 1) | i3double -> i1  " , "681");
    ("match (function x->x) with  14 ->  10" , "match failure");
    ("match [] with  10 -> 14 " , "match failure");
    ("match true with  [] ->  1" , "match failure");
    ("match [] with  true -> 0 " , "match failure");
    ("match 10 with []  -> 1  " , "match failure");
    ("match 10 with true  -> 0  " , "match failure");
    ("match l1 with a::b::c::d::ds -> a + b + c + d", "10");
    ("match l1 with  x::xs -> x*7  ", "7");
    ("match [1;2] with a::b::c::d -> false | x::y::z -> z", "[]");
    ("match [1;2] with x::xs -> x+1", "2");
    ("match [] with x::xs -> false | [] -> true  ", "true");
    ("match [] with x::xs -> false | l -> true  ", "true");
    ("match [1;2] with x::y::z::xs -> false | [] -> true | _ -> 10", "10");

    (* Non-Recursive Functions *)
    ("let f = (function x -> x + 1)" , "val f = <fun>");
    ("f 100" , "101");
    ("f true", "dynamic type error");
    ("f x", "35");
    ("let add = (function x ->  (function y -> x + y) )" ,"val add = <fun>");
    ("add 4 5" , "9");
    ("let head = (function x -> (match x with y::ys -> y | _ -> false))", "val head = <fun>");
    ("head [5;6;7]", "5");
    ("head []", "false");
    ("head 5", "false");

    (* Recursive Functions *)
    ("let rec mapi l = match l with [] -> [] | x::xs -> (x+1)::(mapi xs)", "val mapi = <fun>");
    ("mapi [1;2;3;4]", "[2; 3; 4; 5]");
    ("let inc = function a -> a + 1", "val inc = <fun>");
    ("inc 5", "6");
    ("let rec map l = (function f -> match l with [] -> [] | x::xs -> (f x)::(map xs f) )", "val map = <fun>");
    ("map [1;2;3;4] inc" , "[2; 3; 4; 5]");
    ("map [1;2;3;4] (function x -> x * 2)" , "[2; 4; 6; 8]");

    (*Using functions as parameters *)
   ("let rec sumListH l = (function k -> (match l with [] -> k 0 | x::xs -> sumListH xs (function result -> k(result+x) )))" ,"val sumListH = <fun>");
   ("sumListH [1;2;3;4;5] (function x -> x)", "15");
   ("let sumList = (function l -> sumListH l (function x -> x) )", "val sumList = <fun>");
   ("sumList [1;2;3;4;5]" , "15" );
   ("let a = 50" ,"val a = 50");
   ("let inc2 = (function a -> (a + 1))", "val inc2 = <fun>");
   ("let rec inc2r a = a + 1", "val inc2r = <fun>");
   ("(inc2 ( inc2r (10 + 1) ) - 11 )= 2", "true");
   ("let funcDec = (function f -> (function a -> (f a) - 1) )", "val funcDec = <fun>");
   ("let rec fact2 n = match n with 0 -> 1 | _ -> n*(fact2 (n-1))", "val fact2 = <fun>");  (* fixed some typo *)
   ("let c1 = funcDec fact2 5" , "val c1 = 119");
   ("let c2 = funcDec fact2 (funcDec fact2 3)" , "val c2 = 119");
   ("let factDec = funcDec fact2", "val factDec = <fun>");
   ("let c3 = factDec 5", "val c3 = 119");
   ("c1 = c2", "true");
   ("(c1 - c3) = 0", "true");
   ("funcDec inc2r 17", "17");
    
  (* Functions Parameter Pattern Matching *)
  ("let fw = (function _ -> 5)", "val fw = <fun>");
  ("let rec gw _ = 5", "val gw = <fun>");
  ("gw 17 = fw []", "true");
  ("let fn = (function [] -> true)", "val fn = <fun>");
  ("let rec gn [] = 100", "val gn = <fun>");
  ("if (fn []) then (gn []) else false", "100");
  ("gn [1]", "match failure");
  ("fn [5]", "match failure");
  ("let fc = (function x::xs -> x)", "val fc = <fun>");
  ("fc []", "match failure");
  ("fc [1;2;3]", "1");
  ("fc [[1;2;3];[4;5]]", "[1; 2; 3]");

  ("3", "3");
  ("false", "false");
  ("let x = 34", "val x = 34");
  ("www", "dynamic type error");
  ("x + 4", "38");
  ("let z = function y -> y +4 + n", "val z = <fun>");
  ("z 2", "dynamic type error");
  ("let z = function y -> y +4 + x","val z = <fun>");
  ("z 2","40");
  ("let count10 = function list -> match list with [] -> 0 | x::xs -> 1 + count10 xs","val count10 = <fun>");
  ("let mylist = [1; 2; true]","val mylist = [1; 2; true]");
  ("count10 mylist", "dynamic type error");
  ("let rec count2 list = match list with [] -> 0 | x::xs -> 1 + count2 xs","val count2 = <fun>");
  ("let emptylist = []", "val emptylist = []");
  ("count2 emptylist", "0");
  ("count2 mylist","3");
  ("let rec fact n = if n = 0 then 1 else n * (fact(n-1))", "val fact = <fun>");
  ("fact 5", "120");
  ("let mylist = 3::mylist", "val mylist = [3; 1; 2; true]");
  ("count2 mylist", "4");
  ("let a = fact 3", "val a = 6");
  ("2 > a", "false");
  ("fact emptylist", "dynamic type error");
  ("let x = 10", "val x = 10");
  ("z 2", "40"); (* Still use the old value of x *)
  ("x + 4", "14");
  ("let meow = match (z 2) with 1 -> 2 | false -> 3 | _ -> true", "val meow = true");
  ("meow", "true");
  ("true + 1", "dynamic type error");
  ("let x = 1 + 2 + []", "dynamic type error");
  ("x", "10");
  ("2::3::true::[1]::[]", "[2; 3; true; [1]]");
  ("2::(3::[false])", "[2; 3; false]");

  ("false > false", "dynamic type error");
  ("true > false", "dynamic type error");
  ("false > true", "dynamic type error");
  ("true > true", "dynamic type error");
  ("false = false", "dynamic type error");
  ("false = true", "dynamic type error"); 
  ("true = false", "dynamic type error");
  ("true = true", "dynamic type error");
    ]

(* The Test Harness
   You don't need to understand the code below.
*)
  
let testOne test env =
  let decl = main token (Lexing.from_string (test^";;")) in
  let res = evalDecl decl env in
  let str = print_result res in
  match res with
      (None,v) -> (str,env)
    | (Some x,v) -> (str, Env.add_binding x v env)
      
let test tests =
  let (results, finalEnv) =
    List.fold_left
      (fun (resultStrings, env) (test,expected) ->
	let (res,newenv) =
	  try testOne test env with
	      Parsing.Parse_error -> ("parse error",env)
	    | DynamicTypeError -> ("dynamic type error",env)
	    | MatchFailure -> ("match failure",env)
	    | ImplementMe s -> ("implement me",env) in
	(resultStrings@[res], newenv)
      )
      ([], Env.empty_env()) tests
  in
  List.iter2
      (fun (t,er) r ->
  let out = if er=r then "" else  
  t ^ "....................." ^ "expected " ^ er ^ " but got " ^ r ^ "\n" in 
  print_string out
 )
    (* (fun (t,er) r ->
      let out = if er=r then "ok" else "expected " ^ er ^ " but got " ^ r in
      print_endline
	(t ^ "....................." ^ out)) *)
      tests results

(* CALL THIS FUNCTION TO RUN THE TESTS *)
let runtests() = test tests
  
