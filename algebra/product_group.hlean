/-
Copyright (c) 2015 Floris van Doorn. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Floris van Doorn, Egbert Rijke

Constructions with groups
-/

import algebra.group_theory hit.set_quotient types.list types.sum .subgroup .quotient_group

open eq algebra is_trunc set_quotient relation sigma sigma.ops prod prod.ops sum list trunc function
     equiv
namespace group

  variables {G G' : Group} (H : subgroup_rel G) (N : normal_subgroup_rel G) {g g' h h' k : G}
            {A B : AbGroup}

  /- Binary products (direct product) of Groups -/
  definition product_one [constructor] : G × G' := (one, one)
  definition product_inv [unfold 3] : G × G' → G × G' :=
  λv, (v.1⁻¹, v.2⁻¹)
  definition product_mul [unfold 3 4] : G × G' → G × G' → G × G' :=
  λv w, (v.1 * w.1, v.2 * w.2)

  section
  local notation 1 := product_one
  local postfix ⁻¹ := product_inv
  local infix * := product_mul

  theorem product_mul_assoc (g₁ g₂ g₃ : G × G') : g₁ * g₂ * g₃ = g₁ * (g₂ * g₃) :=
  prod_eq !mul.assoc !mul.assoc

  theorem product_one_mul (g : G × G') : 1 * g = g :=
  prod_eq !one_mul !one_mul

  theorem product_mul_one (g : G × G') : g * 1 = g :=
  prod_eq !mul_one !mul_one

  theorem product_mul_left_inv (g : G × G') : g⁻¹ * g = 1 :=
  prod_eq !mul.left_inv !mul.left_inv

  theorem product_mul_comm {G G' : AbGroup} (g h : G × G') : g * h = h * g :=
  prod_eq !mul.comm !mul.comm

  end

  variables (G G')
  definition group_prod [constructor] : group (G × G') :=
  group.mk _ product_mul product_mul_assoc product_one product_one_mul product_mul_one
           product_inv product_mul_left_inv

  definition product [constructor] : Group :=
  Group.mk _ (group_prod G G')

  definition ab_group_prod [constructor] (G G' : AbGroup) : ab_group (G × G') :=
  ⦃ab_group, group_prod G G', mul_comm := product_mul_comm⦄

  definition ab_product [constructor] (G G' : AbGroup) : AbGroup :=
  AbGroup.mk _ (ab_group_prod G G')

  infix ` ×g `:60 := group.product
  infix ` ×ag `:60 := group.ab_product

  definition product_functor [constructor] {G G' H H' : Group} (φ : G →g H) (ψ : G' →g H') :
    G ×g G' →g H ×g H' :=
  homomorphism.mk (λx, (φ x.1, ψ x.2)) (λx y, prod_eq !to_respect_mul !to_respect_mul)

  infix ` ×→g `:60 := group.product_functor

  definition product_isomorphism [constructor] {G G' H H' : Group} (φ : G ≃g H) (ψ : G' ≃g H') :
    G ×g G' ≃g H ×g H' :=
  isomorphism.mk (φ ×→g ψ) !is_equiv_prod_functor

  infix ` ×≃g `:60 := group.product_isomorphism

end group
