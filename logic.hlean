/-
Copyright (c) 2017 Jeremy Avigad. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Jeremy Avigad
-/
import types.trunc
open funext eq trunc is_trunc prod sum

--reserve prefix `¬`:40
--reserve prefix `~`:40
--reserve infixr ` ∧ `:35
--reserve infixr ` /\ `:35
--reserve infixr ` \/ `:30
--reserve infixr ` ∨ `:30
--reserve infix ` <-> `:20
--reserve infix ` ↔ `:20

namespace logic

section
open trunc_index

definition propext {p q : Prop} (h : p ↔ q) : p = q :=
tua (equiv_of_iff_of_is_prop h)

end

definition false : Prop := trunctype.mk empty _

definition false.elim {A : Type} (h : false) : A := empty.elim h

definition true : Prop := trunctype.mk unit _

definition true.intro : true := unit.star

definition trivial : true := unit.star

definition and (p q : Prop) : Prop := tprod p q

infixr ` ∧ ` := and
infixr ` /\ ` := and

definition and.intro {p q : Prop} (h₁ : p) (h₂ : q) : and p q := prod.mk h₁ h₂

definition and.left {p q : Prop} (h : p ∧ q) : p := prod.pr1 h

definition and.right {p q : Prop} (h : p ∧ q) : q := prod.pr2 h

definition not (p : Prop) : Prop := trunctype.mk (p → empty) _

prefix `~` := not

definition or.inl := @or.intro_left

definition or.inr := @or.intro_right

end logic
