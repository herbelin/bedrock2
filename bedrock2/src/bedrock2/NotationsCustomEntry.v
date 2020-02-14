Require Import Coq.ZArith.BinIntDef.
Require Import coqutil.Macros.subst coqutil.Macros.unique bedrock2.Syntax.

(** Grammar for expressions *)

Import bopname.
Declare Custom Entry bedrock_expr.
Notation "bedrock_expr:( e )"   := e   (e custom bedrock_expr,
                                        format "'bedrock_expr:(' e ')'").
Notation "constr:( e )"         := e   (in custom bedrock_expr, e constr,
                                        format "'constr:(' e ')'").
Notation  "( e )" := e                 (in custom bedrock_expr at level 0).
Notation "x" := x (in custom bedrock_expr at level 0, x global).

Infix  "<<" := (expr.op slu)  (in custom bedrock_expr at level 3, left associativity). (* DRAFT level *)
Infix  ">>" := (expr.op sru)  (in custom bedrock_expr at level 3, left associativity). (* DRAFT level *)
Infix ".>>" := (expr.op srs)  (in custom bedrock_expr at level 3, left associativity). (* DRAFT *)

Infix "+"   := (expr.op add)  (in custom bedrock_expr at level 6, left associativity).
Infix "-"   := (expr.op sub)  (in custom bedrock_expr at level 6, left associativity).

Infix "&"   := (expr.op and)  (in custom bedrock_expr at level 7, left associativity).

Infix "^"   := (expr.op xor)  (in custom bedrock_expr at level 8, left associativity).

Infix "|"   := (expr.op or)   (in custom bedrock_expr at level 9, left associativity).

Infix  "<"  := (expr.op ltu)  (in custom bedrock_expr at level 10, no associativity).
Infix ".<"  := (expr.op lts)  (in custom bedrock_expr at level 10, no associativity). (* DRAFT *)
Infix "=="  := (expr.op  eq)  (in custom bedrock_expr at level 10, no associativity).

(* DRAFT *)
Notation "load1( a )" := (expr.load access_size.one a)
                              (in custom bedrock_expr at level 0, a custom bedrock_expr).
Notation "load2( a )" := (expr.load access_size.two a)
                              (in custom bedrock_expr at level 0, a custom bedrock_expr).
Notation "load4( a )" := (expr.load access_size.four a)
                              (in custom bedrock_expr at level 0, a custom bedrock_expr).
Notation  "load( a )" := (expr.load access_size.word a)
                              (in custom bedrock_expr at level 0, a custom bedrock_expr).

(** Grammar for commands *)

Import cmd.
Declare Custom Entry bedrock_cmd.
Declare Scope bedrock_nontail.
Delimit Scope bedrock_nontail with bedrock_nontail.
Notation "bedrock_cmd:( c )"   := c   (c custom bedrock_cmd at level 0,
                                       format "'bedrock_cmd:(' c ')'").
Notation "constr:( c )"        := c   (in custom bedrock_cmd, c constr,
                                       format "'constr:(' c ')'").
Notation  "{ c }" := c                 (in custom bedrock_cmd at level 0).
Notation "x" := x (in custom bedrock_cmd at level 0, x global).

Declare Custom Entry bedrock_else.
Notation "bedrock_else:( c )"   := c   (c custom bedrock_else at level 0,
                                       format "'bedrock_else:(' c ')'").
Notation "constr:( c )"        := c   (in custom bedrock_else, c constr,
                                       format "'constr:(' c ')'").
Notation  "{ c }" := c                 (in custom bedrock_else at level 0, c custom bedrock_cmd at level 0,
                                       format "{  '/  ' c '/' }").
Notation "x" := x (in custom bedrock_else at level 0, x global).

Notation "'if' e { c1 }" := (cond e c1 skip)
  (in custom bedrock_else at level 0, no associativity, e custom bedrock_expr, c1 custom bedrock_cmd at level 0,
  format "'[v' 'if'  e  {  '/  ' c1 '/' } ']'").
Notation "'if' '!' e { c1 }" := (cond e skip c1)
  (in custom bedrock_else at level 0, no associativity, e custom bedrock_expr, c1 custom bedrock_cmd at level 0,
      format "'[v' 'if'  '!' e   {  '/  ' c1 '/' } ']'").
Notation "'if' e { c1 } 'else' c2" := (cond e c1 c2)
  (in custom bedrock_else at level 0, no associativity, e custom bedrock_expr, c1 custom bedrock_cmd at level 0, c2 custom bedrock_else at level 0,
  format "'[v' 'if'  e  {  '/  ' c1 '/' }  'else'  c2 ']'").
Notation "'if' '!' e { c1 } 'else' c2" := (cond e c2 c1)
  (in custom bedrock_else at level 0, no associativity, e custom bedrock_expr, c1 custom bedrock_cmd at level 0, c2 custom bedrock_else at level 0,
  format "'[v' 'if'  '!' e  {  '/  ' c1 '/' }  'else'  c2 ']'").

Notation "c1 ; c2" := (seq c1%bedrock_nontail c2) (in custom bedrock_cmd at level 0, right associativity,
                                   format "'[v' c1 ; '/' c2 ']'").
Notation "'if' e { c1 } 'else' c2" := (cond e c1 c2)
  (in custom bedrock_cmd at level 0, no associativity, e custom bedrock_expr, c1 custom bedrock_cmd at level 0, c2 custom bedrock_else at level 0,
  format "'[v' 'if'  e  {  '/  ' c1 '/' }  'else'  c2 ']'").
Notation "'if' '!' e { c1 } 'else' c2" := (cond e c2 c1)
  (in custom bedrock_cmd at level 0, no associativity, e custom bedrock_expr, c1 custom bedrock_cmd at level 0, c2 custom bedrock_else at level 0,
  format "'[v' 'if'  '!' e  {  '/  ' c1 '/' }  'else'  c2 ']'").
Notation "'if' e { c }" := (cond e c skip)
  (in custom bedrock_cmd at level 0, no associativity, e custom bedrock_expr, c at level 0,
  format "'[v' 'if'  e  {  '/  ' c '/' } ']'").
Notation "'if' '!' e { c }" := (cond e skip c)
  (in custom bedrock_cmd at level 0, no associativity, e custom bedrock_expr, c at level 0,
  format "'[v' 'if'  '!' e  {  '/  ' c '/' } ']'").
Notation "'while' e { c }" := (while e c%bedrock_nontail)
  (in custom bedrock_cmd at level 0, no associativity, e custom bedrock_expr, c at level 0,
  format "'[v' 'while'  e  {  '/  ' c '/' } ']'").

Notation "x = ( e )" := (set x e) (in custom bedrock_cmd at level 0, x custom bedrock_cmd, e custom bedrock_expr).
(* DRAFT: *)
Notation "/*skip*/" := skip (in custom bedrock_cmd).
Notation "store1( a , v )" := (store access_size.one a v)
                              (in custom bedrock_cmd at level 0, a custom bedrock_expr, v custom bedrock_expr).
Notation "store2( a , v )" := (store access_size.two a v)
                              (in custom bedrock_cmd at level 0, a custom bedrock_expr, v custom bedrock_expr).
Notation "store4( a , v )" := (store access_size.four a v)
                              (in custom bedrock_cmd at level 0, a custom bedrock_expr, v custom bedrock_expr).
Notation  "store( a , v )" := (store access_size.word a v)
                              (in custom bedrock_cmd at level 0, a custom bedrock_expr, v custom bedrock_expr).

Declare Custom Entry bedrock_call_lhs.
Notation "bedrock_call_lhs:( e )"   := e   (e custom bedrock_call_lhs,
                                            format "'bedrock_call_lhs:(' e ')'").
Notation "constr:( e )"         := e   (in custom bedrock_call_lhs, e constr,
                                        format "'constr:(' e ')'").
Notation "x" := (@cons String.string x nil) (in custom bedrock_call_lhs at level 0, x global).
Notation "x , y , .. , z" := (@cons String.string x (@cons String.string y .. (@cons String.string z (@nil String.string)) ..))
  (in custom bedrock_call_lhs at level 0, x global, y constr at level 0, z constr at level 0).

(* COQBUG(9532) *)
(* functions of up to 6 arguments *)
Notation "f ( )" :=  (call nil f nil) (in custom bedrock_cmd at level 0, f global).
Notation "f ()" :=  (call nil f nil) (in custom bedrock_cmd at level 0, f global).
Notation "f ( x )" :=  (call nil f (@cons expr x nil)) (in custom bedrock_cmd at level 0, f global, x custom bedrock_expr).
Notation "f ( x , y )" :=  (call nil f (@cons expr x (@cons expr y nil))) (in custom bedrock_cmd at level 0, f global, x custom bedrock_expr, y custom bedrock_expr).
Notation "f ( x , y , z )" :=  (call nil f (@cons expr x (@cons expr y (@cons expr z (@nil expr))))) (in custom bedrock_cmd at level 0, f global, x custom bedrock_expr, y custom bedrock_expr, z custom bedrock_expr).
Notation "f ( x , y , z , a )" :=  (call nil f (@cons expr x (@cons expr y (@cons expr z (@cons expr a (@nil expr)))))) (in custom bedrock_cmd at level 0, f global, x custom bedrock_expr, y custom bedrock_expr, z custom bedrock_expr, a custom bedrock_expr).
Notation "f ( x , y , z , a , b )" :=  (call nil f (@cons expr x (@cons expr y (@cons expr z (@cons expr a (@cons expr b (@nil expr))))))) (in custom bedrock_cmd at level 0, f global, x custom bedrock_expr, y custom bedrock_expr, z custom bedrock_expr, a custom bedrock_expr, b custom bedrock_expr).
Notation "f ( x , y , z , a , b , c )" :=  (call nil f (@cons expr x (@cons expr y (@cons expr z (@cons expr a (@cons expr b (@cons expr c (@nil expr)))))))) (in custom bedrock_cmd at level 0, f global, x custom bedrock_expr, y custom bedrock_expr, z custom bedrock_expr, a custom bedrock_expr, b custom bedrock_expr, c custom bedrock_expr).

Notation "unpack! lhs = f ( )" :=  (call lhs f nil) (in custom bedrock_cmd at level 0, lhs custom bedrock_call_lhs, f global).
Notation "unpack! lhs = f ()" :=  (call lhs f nil) (in custom bedrock_cmd at level 0, lhs custom bedrock_call_lhs, f global).
Notation "unpack! lhs = f ( x )" :=  (call lhs f (@cons expr x nil)) (in custom bedrock_cmd at level 0, lhs custom bedrock_call_lhs, f global, x custom bedrock_expr).
Notation "unpack! lhs = f ( x , y )" :=  (call lhs f (@cons expr x (@cons expr y nil))) (in custom bedrock_cmd at level 0, lhs custom bedrock_call_lhs, f global, x custom bedrock_expr, y custom bedrock_expr).
Notation "unpack! lhs = f ( x , y , z )" :=  (call lhs f (@cons expr x (@cons expr y (@cons expr z (@nil expr))))) (in custom bedrock_cmd at level 0, lhs custom bedrock_call_lhs, f global, x custom bedrock_expr, y custom bedrock_expr, z custom bedrock_expr).
Notation "unpack! lhs = f ( x , y , z , a )" :=  (call lhs f (@cons expr x (@cons expr y (@cons expr z (@cons expr a (@nil expr)))))) (in custom bedrock_cmd at level 0, lhs custom bedrock_call_lhs, f global, x custom bedrock_expr, y custom bedrock_expr, z custom bedrock_expr, a custom bedrock_expr).
Notation "unpack! lhs = f ( x , y , z , a , b )" :=  (call lhs f (@cons expr x (@cons expr y (@cons expr z (@cons expr a (@cons b (@nil expr))))))) (in custom bedrock_cmd at level 0, lhs custom bedrock_call_lhs, f global, x custom bedrock_expr, y custom bedrock_expr, z custom bedrock_expr, a custom bedrock_expr, b custom bedrock_expr).
Notation "unpack! lhs = f ( x , y , z , a , b , c )" :=  (call lhs f (@cons expr x (@cons expr y (@cons expr z (@cons expr a (@cons expr b (@cons expr c (@nil expr)))))))) (in custom bedrock_cmd at level 0, lhs custom bedrock_call_lhs, f global, x custom bedrock_expr, y custom bedrock_expr, z custom bedrock_expr, a custom bedrock_expr, b custom bedrock_expr, c custom bedrock_expr).

Notation "output! f ( )" :=  (interact nil f nil) (in custom bedrock_cmd at level 0, f global).
Notation "output! f ( x )" :=  (interact nil f (@cons expr x nil)) (in custom bedrock_cmd at level 0, f global, x custom bedrock_expr).
Notation "output! f ( x , y )" :=  (interact nil f (@cons expr x (@cons expr y nil))) (in custom bedrock_cmd at level 0, f global, x custom bedrock_expr, y custom bedrock_expr).
Notation "output! f ( x , y , z )" :=  (interact nil f (@cons expr x (@cons expr y (@cons expr z (@nil expr))))) (in custom bedrock_cmd at level 0, f global, x custom bedrock_expr, y custom bedrock_expr, z custom bedrock_expr).
Notation "output! f ( x , y , z , a )" :=  (interact nil f (@cons expr x (@cons expr y (@cons expr z (@cons expr a (@nil expr)))))) (in custom bedrock_cmd at level 0, f global, x custom bedrock_expr, y custom bedrock_expr, z custom bedrock_expr, a custom bedrock_expr).
Notation "output! f ( x , y , z , a , b )" :=  (interact nil f (@cons expr x (@cons expr y (@cons expr z (@cons expr a (@cons expr b (@nil expr))))))) (in custom bedrock_cmd at level 0, f global, x custom bedrock_expr, y custom bedrock_expr, z custom bedrock_expr, a custom bedrock_expr, b custom bedrock_expr).
Notation "output! f ( x , y , z , a , b , c )" :=  (interact nil f (@cons expr x (@cons expr y (@cons expr z (@cons expr a (@cons expr b (@cons expr c (@nil expr)))))))) (in custom bedrock_cmd at level 0, f global, x custom bedrock_expr, y custom bedrock_expr, z custom bedrock_expr, a custom bedrock_expr, b custom bedrock_expr, c custom bedrock_expr).

Notation "io! lhs = f ( )" :=  (interact lhs f nil) (in custom bedrock_cmd at level 0, lhs custom bedrock_call_lhs, f global).
Notation "io! lhs = f ( x )" :=  (interact lhs f (@cons expr x nil)) (in custom bedrock_cmd at level 0, lhs custom bedrock_call_lhs, f global, x custom bedrock_expr).
Notation "io! lhs = f ( x , y )" :=  (interact lhs f (@cons expr x (@cons expr y nil))) (in custom bedrock_cmd at level 0, lhs custom bedrock_call_lhs, f global, x custom bedrock_expr, y custom bedrock_expr).
Notation "io! lhs = f ( x , y , z )" :=  (interact lhs f (@cons expr x (@cons expr y (@cons expr z (@nil expr))))) (in custom bedrock_cmd at level 0, lhs custom bedrock_call_lhs, f global, x custom bedrock_expr, y custom bedrock_expr, z custom bedrock_expr).
Notation "io! lhs = f ( x , y , z , a )" :=  (interact lhs f (@cons expr x (@cons expr y (@cons expr z (@cons expr a (@nil expr)))))) (in custom bedrock_cmd at level 0, lhs custom bedrock_call_lhs, f global, x custom bedrock_expr, y custom bedrock_expr, z custom bedrock_expr, a custom bedrock_expr).
Notation "io! lhs = f ( x , y , z , a , b )" :=  (interact lhs f (@cons expr x (@cons expr y (@cons expr z (@cons expr a (@cons b (@nil expr))))))) (in custom bedrock_cmd at level 0, lhs custom bedrock_call_lhs, f global, x custom bedrock_expr, y custom bedrock_expr, z custom bedrock_expr, a custom bedrock_expr, b custom bedrock_expr).
Notation "io! lhs = f ( x , y , z , a , b , c )" :=  (interact lhs f (@cons expr x (@cons expr y (@cons expr z (@cons expr a (@cons expr b (@cons expr c (@nil expr)))))))) (in custom bedrock_cmd at level 0, lhs custom bedrock_call_lhs, f global, x custom bedrock_expr, y custom bedrock_expr, z custom bedrock_expr, a custom bedrock_expr, b custom bedrock_expr, c custom bedrock_expr).

Declare Scope bedrock_tail.
Delimit Scope bedrock_tail with bedrock_tail.
Notation "bedrock_func_body:( c )"   := (c%bedrock_tail) (c custom bedrock_cmd at level 0,
                                                          format "'bedrock_func_body:(' c ')'").
Definition require_is_not_available_inside_conditionals_and_loops := I.
Notation "'require' e ; c2" := (cond e c2 skip)
  (in custom bedrock_cmd at level 1, no associativity, e custom bedrock_expr, c2 at level 0,
  format "'[v' 'require'  e ; '//' c2 ']'") : bedrock_tail.
Notation "'require' '!' e ; c2" := (cond e skip c2)
  (in custom bedrock_cmd at level 1, no associativity, e custom bedrock_expr, c2 at level 0,
  format "'[v' 'require' '!'  e ; '//' c2 ']'") : bedrock_tail.
Notation "'require' e 'else' { c1 } ; c2" := (cond e c2 c1)
  (in custom bedrock_cmd at level 1, no associativity, e custom bedrock_expr, c1 at level 0, c2 at level 0,
  format "'[v' 'require'  e  'else'  {  '/  ' c1 '/' } ; '//' c2 ']'") : bedrock_tail.
Notation "'require' '!' e 'else' { c1 } ; c2" := (cond e c1 c2)
  (in custom bedrock_cmd at level 1, no associativity, e custom bedrock_expr, c1 at level 0, c2 at level 0,
  format "'[v' 'require' '!'  e  'else'  {  '/  ' c1 '/' } ; '//' c2 ']'") : bedrock_tail.
Notation "'require' e 'else' { c1 } ; c2" := (require_is_not_available_inside_conditionals_and_loops)
  (only parsing, in custom bedrock_cmd at level 1, no associativity, e custom bedrock_expr, c1 at level 0, c2 at level 0,
  format "'[v' 'require'  e  'else'  {  '/  ' c1 '/' } ; '//' c2 ']'") : bedrock_nontail.
Notation "'require' '!' e 'else' { c1 } ; c2" := (require_is_not_available_inside_conditionals_and_loops)
  (only parsing, in custom bedrock_cmd at level 1, no associativity, e custom bedrock_expr, c1 at level 0, c2 at level 0,
  format "'[v' 'require' '!'  e  'else'  {  '/  ' c1 '/' } ; '//' c2 ']'") : bedrock_nontail.
Undelimit Scope bedrock_tail.
Undelimit Scope bedrock_nontail.


Module test.
  Local Notation "1" := (expr.literal 1) (in custom bedrock_expr).

  Goal True.
  epose (fun x => bedrock_cmd:( store1(1<<(1+1+1), 1+1) ; if 1 { store1(1,1) } ; constr:(_) = (1) )).
  epose (fun a => bedrock_cmd:( if 1 { constr:(_) = (1);  constr:(_) = (a) } )).
  epose (fun a => bedrock_cmd:( a (1+1 , 1+1,1, 1 ) )).
  epose (fun a => bedrock_cmd:( a (1+1 , 1+1,1, 1 ,1 ) )).
  epose (fun a => bedrock_cmd:( a (1+1 , 1+1,1, 1,1,1 ) )).
  epose (fun (a b c d: String.string) (f: String.string) =>
           bedrock_cmd:( unpack! a,b,c,d = f ( 1 + 1 , 1 + 1 ) )).
  epose (fun (a b:String.string) (f:String.string) => bedrock_cmd:( unpack! a = f ( 1 + 1 , 1 + 1 ) ; a = (1) )).
  epose (fun (a b:String.string) (f:String.string) => bedrock_cmd:( if constr:(_) { constr:(_) } else if constr:(_) { constr:(_) } )).

  epose (bedrock_cmd:(
      if constr:(_) { constr:(_) }
      else if constr:(_) { constr:(_) }
      else if constr:(_) { constr:(_) }
      else if constr:(_) { constr:(_) };
      constr:(_))).

  epose bedrock_func_body:( require constr:(_) else { constr:(_) } ; constr:(_) ).
  epose bedrock_func_body:( require constr:(_) ; constr:(_) ).

  epose bedrock_func_body:(
   require (1 ^ 1) else {
       require (1 ^ 1) else { constr:(_) };
       constr:(_)
   };
    constr:(_)
  ).

  assert_fails (epose bedrock_func_body:(
    if (1) { require (1 ^ 1) else { constr:(_) }; constr:(_)  } ;
    { constr:(_) = (constr:(_))}
  )).

  assert_fails (epose bedrock_func_body:(
    if (1) { require !(1 ^ 1) else { constr:(_) }; constr:(_)  }
    else { constr:(_) };
    constr:(_) = (constr:(_))
  )).

  assert_fails (epose bedrock_func_body:(
    if (1) { constr:(_)  } else { require (1 ^ 1) else { constr:(_) }; constr:(_) };
    { constr:(_) = (constr:(_))}
  )).

  assert_fails (epose bedrock_func_body:(
    while (1) { require (1 ^ 1) else { constr:(_) }; constr:(_) };
    { constr:(_) = (constr:(_))}
  )).

  assert_fails (epose bedrock_func_body:(
    while (1) { require (1 ^ 1) else { constr:(_) }; constr:(_) = (constr:(_)) }
  )).

  let lhs := open_constr:( bedrock_func_body:(
    require 1 else { store1(1,1) } ;
    require !1 else { store2(1,1) } ;
    store4(1,1)
  )) in
  let rhs := open_constr:( bedrock_func_body:(
    if 1 {
      if !1 {
        store4(1,1)
      }
      else {
        store2(1,1)
      }
    }
    else {
      store1(1,1)
    }
  )) in
  assert (lhs = rhs) by exact eq_refl.

  epose (fun W a b e x y f read write => bedrock_func_body:(
    require (load(1) ^ constr:(expr.literal 231321) ) else { constr:(_) };
    require (1 ^ load4(1+1+1+load(1))) else { constr:(_) };
    { a = (1+1 == 1) } ;
    require (1 ^ 1) else { constr:(_) };
    store1(e, load2(1)+load4(1)+load1(load(1))) ;
    store2(e, 1+1+1);
    store4(e, 1+1+1) ;
    store(e, load(load(load(1))));
    require (1 ^ 1) else { constr:(_) };
    if (W+1<<(1+1)-(1+1) ^ (1+1+1)) {
      a = (constr:(expr.var x))
    } else {
      while (W+1<<(1+1)-(1+1) ^ (1+1+1)) {
        a = (1);
        x = (constr:(expr.var a));
        unpack! x = f(1,W,1, 1,1,1);
        unpack! x,a = f(1,W,1, 1,1,1);
        io! a, x = read(1,W,1, 1,1,1);
        io! a = read(1, 1);
        output! write(1,W,1, 1,1,1);
        store(1,1)
      }
    }
  )).

  Abort.
End test.
