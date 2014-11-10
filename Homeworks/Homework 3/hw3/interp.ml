(* Name: Shivin Kapur

   UID: 404259526

   Others With Whom I Discussed Things: Ashwini Bhatkhande

   Other Resources I Consulted:
   
*)

(* EXCEPTIONS *)

(* This is a marker for places in the code that you have to fill in.
   Your completed assignment should never raise this exception. *)
exception ImplementMe of string

(* This exception is thrown when a type error occurs during evaluation
   (e.g., attempting to invoke something that's not a function).
*)
exception DynamicTypeError

(* This exception is thrown when pattern matching fails during evaluation. *)  
exception MatchFailure  

(* EVALUATION *)

(* See if a value matches a given pattern.  If there is a match, return
   an environment for any name bindings in the pattern.  If there is not
   a match, raise the MatchFailure exception.
*)
let rec patMatch (pat:mopat) (value:movalue) : moenv =
  match (pat, value) with
      (* an integer pattern matches an integer only when they are the same constant;
	 no variables are declared in the pattern so the returned environment is empty *)
      | (IntPat(i), IntVal(j)) when i=j -> Env.empty_env()
      | (BoolPat(b1), BoolVal(b2)) when b1=b2 -> Env.empty_env()
      | (WildcardPat, _) -> Env.empty_env()
      (* | (VarPat(item), v) -> Env.add_binding item v (Env.empty_env()) *)
      | (VarPat(item), _) -> (match value with
                        | IntVal(i) -> (Env.add_binding item value (Env.empty_env()))
                        | BoolVal(i) -> (Env.add_binding item value (Env.empty_env()))
                        | FunctionVal(opt, pat1, epr, env) -> (Env.add_binding item value (Env.empty_env()))
                        | ListVal(lst) -> (match lst with
                                                | NilVal -> (Env.add_binding item value (Env.empty_env()))
                                                | ConsVal(moval,lst) -> (Env.add_binding item value (Env.empty_env()))))
      | (NilPat, ListVal(NilVal)) -> Env.empty_env()
      | (ConsPat(p1,p2), ListVal(ConsVal(v,l1))) -> Env.combine_envs (patMatch p1 v) (patMatch p2 (ListVal l1))
      | _ -> raise MatchFailure


(* Match Helper function - which will match the pattern or raise a match failure *)
let rec matchHelper l v = 
  match l with
  | [] -> raise MatchFailure
  | (p, body)::rest -> try
                        let updatedEnv = patMatch p v in (body,updatedEnv) 
                      with
                        MatchFailure -> matchHelper rest v

(* Evaluate an expression in the given environment and return the
   associated value.  Raise a MatchFailure if pattern matching fails.
   Raise a DynamicTypeError if any other kind of error occurs (e.g.,
   trying to add a boolean to an integer) which prevents evaluation
   from continuing.
*)
let rec evalExpr (e:moexpr) (env:moenv) : movalue =
  match e with
      (* an integer constant evaluates to itself *)
      | IntConst(i) -> IntVal(i)
      | BoolConst(b) -> BoolVal(b)
      | Nil -> ListVal(NilVal)
      | Var(s) ->
                  (try
                    Env.lookup s env
                  with
                    Env.NotBound -> raise DynamicTypeError)
      | BinOp(e1,op,e2) -> 
                            (let x = evalExpr e1 env and
                             y = evalExpr e2 env in 
                            (match (x,y) with 
                                | (IntVal(int1), IntVal(int2)) -> 
                                    (match op with 
                                        | Plus -> IntVal(int1 + int2)
                                        | Minus -> IntVal(int1 - int2)
                                        | Times -> IntVal(int1 * int2)
                                        | Gt -> if (int1>int2) then BoolVal(true) else BoolVal(false)
                                        | Eq -> if (int1=int2) then BoolVal(true) else BoolVal(false)
                                        | Cons -> raise DynamicTypeError) (* For case 3::5  *)
                                        (* | _ -> raise MatchFailure) *)
                                (* | (IntVal(i1), ListVal(l1)) -> 
                                      (match op with
                                      | Cons -> ListVal(ConsVal(IntVal(i1),l1))
                                      | _ -> raise DynamicTypeError)
                                | (BoolVal(b1), ListVal(l1)) -> 
                                      (match op with
                                      | Cons -> ListVal(ConsVal(BoolVal(b1),l1))
                                      | _ -> raise DynamicTypeError)
                                | (ListVal(l1), ListVal(l2)) ->
                                      (match op with
                                      | Cons -> ListVal(ConsVal(ListVal(l1),l2))
                                      | _ -> raise DynamicTypeError) *)
                                (* | _,Cons,ListVal(l1) -> ListVal(ConsVal(x,l1)) *)
                                | (_, ListVal(l1)) -> 
                                      (match op with 
                                        | Cons -> ListVal(ConsVal(x,l1))
                                        | _ -> raise DynamicTypeError)
                                | _ -> raise DynamicTypeError))
      | Negate(e1) ->  (match (evalExpr e1 env) with 
                        | IntVal(i) -> IntVal(-i) 
                        | _ -> raise DynamicTypeError)
      | If(cond,thn,els) -> 
                              (match (evalExpr cond env) with
                              | BoolVal(true) -> (evalExpr thn env)
                              | BoolVal(false) -> (evalExpr els env)
                              | _ -> raise DynamicTypeError) 
      | Function(p1,e1) -> FunctionVal(None, p1, e1, env) (* Do I have to evaluate e1? *)
      | FunctionCall(funct,arg) -> 
                                let functval = (evalExpr funct env) and
                                  argval = (evalExpr arg env) in 
                                  (match functval with 
                                    | FunctionVal(funcOpt, funcPat, funcExpr, funcEnv) -> 
                                                                                      (let var1 = 
                                                                                        (match funcOpt with
                                                                                          | None -> funcEnv
                                                                                          | Some item -> Env.add_binding item functval funcEnv) in 
                                                                                      (let updatedEnv = 
                                                                                        patMatch funcPat argval in 
                                                                                          evalExpr funcExpr (Env.combine_envs var1 updatedEnv)))
                                    | _ -> raise DynamicTypeError) 
      | Match(mexp, pmeList) -> 
                                (let matchVal = evalExpr mexp env in 
                                  (let (body, updatedEnv) = matchHelper pmeList matchVal in 
                                    evalExpr body (Env.combine_envs env updatedEnv)))
    (* | _ -> raise (ImplementMe "expression evaluation not implemented") *)


(* Evaluate a declaration in the given environment.  Evaluation
   returns the name of the variable declared (if any) by the
   declaration along with the value of the declaration's expression.
*)
let rec evalDecl (d:modecl) (env:moenv) : moresult =
  match d with
      Expr(e) -> (None, evalExpr e env)
      | Let(x,e) -> (Some x, evalExpr e env)
      | LetRec(f,x,e) -> (Some f, FunctionVal(Some f, x, e, env))
    (* | _ -> raise (ImplementMe "let and let rec not implemented") *)

