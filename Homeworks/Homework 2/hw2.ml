
(* Name: Shivin Kapur

   UID: 404259526

   Others With Whom I Discussed Things: Ashwini Bhatkhande

   Other Resources I Consulted: https://ocaml.org/learn/tutorials/ ; http://try.ocamlpro.com
   
*)

(* Problem 1a
   doubleAllPos : int list -> int list *)

(* 
let doubleAllPos l = List.map (fun x -> if x>0 then x*2 else x) l
*)

let doubleAllPos l = List.map (fun x -> match x with
                                  | _ when x>0 -> x*2
                                  | _ -> x) l

(* Problem 1b
   unzip : ('a * 'b) list -> 'a list * 'b list *)
let unzip l = List.fold_right (fun (a,b) (l1, l2) ->
                                 (a::l1, b::l2)) l ([],[])   

(* Problem 1c
   encode : 'a list -> (int * 'a) list *)
let encode l = List.fold_right (fun x y -> match y with
                                          [] -> [(1,x)]
                                          | (n,e)::rest -> if x=e then (n+1,e)::rest
                                                            else (1,x)::y) l []

(* Problem 1d
   intOfDigits : int list -> int *)
let intOfDigits l = List.fold_left (fun x y -> 10*x + y) 0 l

(* Problem 2a
   map2 : ('a -> 'b -> 'c) -> 'a list -> 'b list -> 'c list *)
let rec map2 f l1 l2 =
  match (l1,l2) with
      [],[] -> []
    | (x::restx,y::resty) -> (f x y)::(map2 f restx resty)

(* Problem 2b
   zip : 'a list * 'b list -> ('a * 'b) list *)
let zip (a, b)= map2(fun x y -> (x,y)) a b

(* Problem 2c
   foldn : (int -> 'a -> 'a) -> int -> 'a -> 'a *)
let rec foldn f n b = 
  match n with
  | 0 -> b
  | 1 -> f 1 b
  | _ -> f n (foldn f (n-1) b)

(* Problem 2d
   clone : 'a * int -> 'a list *)
let clone(e,n) = foldn(fun n x -> e::x) n []

(* Problem 3a
   empty1: unit -> ('a * 'b) list
   put1: 'a -> 'b -> ('a * 'b) list -> ('a * 'b) list
   get1: 'a -> ('a * 'b) list -> 'b option
*)  

type 'a option = None | Some of 'a 

let empty1() = []

let put1 key value dict = (key,value)::dict

let rec get1 key dict =
  match dict with
      [] -> None
    | (k',v')::dict' -> if key=k' then Some v' else get1 key dict'

(* Problem 3b
   empty2: unit -> ('a,'b) dict2
   put2: 'a -> 'b -> ('a,'b) dict2 -> ('a,'b) dict2
   get2: 'a -> ('a,'b) dict2 -> 'b option
*)  
    
type ('a,'b) dict2 = Empty | Entry of 'a * 'b * ('a,'b) dict2

let empty2() = Empty
  
let put2 key value dict = Entry (key,value,dict)

let rec get2 key dict =
  match dict with
      Empty -> None
    | Entry (k', v', d') ->
      if k'=key then Some v' else (get2 key d')
	
(* Problem 3c
   empty3: unit -> ('a,'b) dict3
   put3: 'a -> 'b -> ('a,'b) dict3 -> ('a,'b) dict3
   get3: 'a -> ('a,'b) dict3 -> 'b option
*)  

type ('a,'b) dict3 = ('a -> 'b option)

let empty3() _ = None

(*
let empty3() = (function s -> 
                  match s with 
                     | _ -> None)    
*)

let put3 key value dict =
  (fun k' -> if key=k' then Some value else (dict k'))

let get3 key dict = dict key

