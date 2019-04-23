Require Import Coq.ZArith.ZArith.
Require Import bedrock2.Syntax bedrock2.BasicCSyntax bedrock2.Semantics.
Require coqutil.Datatypes.String coqutil.Map.SortedList coqutil.Map.SortedListString.
Require Import coqutil.Word.Interface coqutil.Map.SortedListWord.
Require coqutil.Word.Naive.

Instance parameters : parameters :=
  let word := Word.Naive.word 64 eq_refl in
  let byte := Word.Naive.word 8 eq_refl in
  {|
  width := 64;
  syntax := StringNamesSyntax.make BasicCSyntax.StringNames_params;
  mem := SortedListWord.map _ _;
  locals := SortedListString.map _;
  funname_env := SortedListString.map;
  funname_eqb := String.eqb;
  ext_spec := fun _ _ _ _ _ => False;
|}.

Global Instance ok trace m0 act args :
  Morphisms.Proper
    (Morphisms.respectful
       (Morphisms.pointwise_relation Interface.map.rep
          (Morphisms.pointwise_relation (list Semantics.word) Basics.impl))
       Basics.impl) (Semantics.ext_spec trace m0 act args).
Proof.
  cbn in *.
  unfold Morphisms.Proper, Morphisms.respectful, Morphisms.pointwise_relation, Basics.impl.
  intros.
  assumption.
Qed.

Instance mapok: coqutil.Map.Interface.map.ok mem := SortedListWord.ok (Naive.word 64 eq_refl) _.
Instance wordok: coqutil.Word.Interface.word.ok Semantics.word := coqutil.Word.Naive.ok _ _.
Instance byteok: coqutil.Word.Interface.word.ok Semantics.byte := coqutil.Word.Naive.ok _ _.
 