/- various groups of maps. Most importantly we define a group structure on trunc 0 (A →* Ω B),
   which is used in the definition of cohomology -/

--author: Floris van Doorn

import algebra.group_theory ..pointed ..pointed_pi eq2
open pi pointed algebra group eq equiv is_trunc trunc susp
namespace group

  /- We first define the group structure on A →* Ω B (except for truncatedness).
     Instead of Ω B, we could also choose any infinity group. However, we need various 2-coherences,
     so it's easier to just do it for the loop space. -/
  definition pmap_mul [constructor] {A B : Type*} (f g : A →* Ω B) : A →* Ω B :=
  pmap.mk (λa, f a ⬝ g a) (respect_pt f ◾ respect_pt g ⬝ !idp_con)

  definition pmap_inv [constructor] {A B : Type*} (f : A →* Ω B) : A →* Ω B :=
  pmap.mk (λa, (f a)⁻¹ᵖ) (respect_pt f)⁻²

  /- we prove some coherences of the multiplication. We don't need them for the group structure, but they
     are used to show that cohomology satisfies the Eilenberg-Steenrod axioms -/
  definition ap1_pmap_mul {X Y : Type*} (f g : X →* Ω Y) :
    Ω→ (pmap_mul f g) ~* pmap_mul (Ω→ f) (Ω→ g) :=
  begin
    fconstructor,
    { intro p, esimp,
      refine ap1_gen_con_left (respect_pt f) (respect_pt f)
               (respect_pt g) (respect_pt g) p ⬝ _,
      refine !whisker_right_idp ◾ !whisker_left_idp2, },
    { refine !con.assoc ⬝ _,
      refine _ ◾ idp ⬝ _, rotate 1,
      rexact ap1_gen_con_left_idp (respect_pt f) (respect_pt g), esimp,
      refine !con.assoc ⬝ _,
      apply whisker_left, apply inv_con_eq_idp,
      refine !con2_con_con2 ⬝ ap011 concat2 _ _:
        refine eq_of_square (!natural_square ⬝hp !ap_id) ⬝ !con_idp }
  end

  definition pmap_mul_pcompose {A B C : Type*} (g h : B →* Ω C) (f : A →* B) :
    pmap_mul g h ∘* f ~* pmap_mul (g ∘* f) (h ∘* f) :=
  begin
    fconstructor,
    { intro p, reflexivity },
    { esimp, refine !idp_con ⬝ _, refine !con2_con_con2⁻¹ ⬝ whisker_right _ _,
      refine !ap_eq_ap011⁻¹ }
  end

  definition pcompose_pmap_mul {A B C : Type*} (h : B →* C) (f g : A →* Ω B) :
    Ω→ h ∘* pmap_mul f g ~* pmap_mul (Ω→ h ∘* f) (Ω→ h ∘* g) :=
  begin
    fconstructor,
    { intro p, exact ap1_con h (f p) (g p) },
    { refine whisker_left _ !con2_con_con2⁻¹ ⬝ _, refine !con.assoc⁻¹ ⬝ _,
      refine whisker_right _ (eq_of_square !ap1_gen_con_natural) ⬝ _,
      refine !con.assoc ⬝ whisker_left _ _, apply ap1_gen_con_idp }
  end

  definition loop_psusp_intro_pmap_mul {X Y : Type*} (f g : psusp X →* Ω Y) :
    loop_psusp_intro (pmap_mul f g) ~* pmap_mul (loop_psusp_intro f) (loop_psusp_intro g) :=
  pwhisker_right _ !ap1_pmap_mul ⬝* !pmap_mul_pcompose

  definition inf_group_pmap [constructor] [instance] (A B : Type*) : inf_group (A →* Ω B) :=
  begin
    fapply inf_group.mk,
    { exact pmap_mul },
    { intro f g h, fapply pmap_eq,
      { intro a, exact con.assoc (f a) (g a) (h a) },
      { rexact eq_of_square (con2_assoc (respect_pt f) (respect_pt g) (respect_pt h)) }},
    { apply pconst },
    { intros f, fapply pmap_eq,
      { intro a, exact one_mul (f a) },
      { esimp, apply eq_of_square, refine _ ⬝vp !ap_id, apply natural_square_tr }},
    { intros f, fapply pmap_eq,
      { intro a, exact mul_one (f a) },
      { reflexivity }},
    { exact pmap_inv },
    { intro f, fapply pmap_eq,
      { intro a, exact con.left_inv (f a) },
      { exact !con_left_inv_idp⁻¹ }},
  end

  definition group_trunc_pmap [constructor] [instance] (A B : Type*) : group (trunc 0 (A →* Ω B)) :=
  !trunc_group

  definition Group_trunc_pmap [reducible] [constructor] (A B : Type*) : Group :=
  Group.mk (trunc 0 (A →* Ω B)) _

  definition Group_trunc_pmap_homomorphism [constructor] {A A' B : Type*} (f : A' →* A) :
    Group_trunc_pmap A B →g Group_trunc_pmap A' B :=
  begin
    fapply homomorphism.mk,
    { apply trunc_functor, intro g, exact g ∘* f},
    { intro g h, induction g with g, induction h with h, apply ap tr,
      fapply pmap_eq,
      { intro a, reflexivity },
      { refine _ ⬝ !idp_con⁻¹,
        refine whisker_right _ !ap_con_fn ⬝ _, apply con2_con_con2 }}
  end

  definition Group_trunc_pmap_isomorphism [constructor] {A A' B : Type*} (f : A' ≃* A) :
    Group_trunc_pmap A B ≃g Group_trunc_pmap A' B :=
  begin
    apply isomorphism.mk (Group_trunc_pmap_homomorphism f),
    apply @is_equiv_trunc_functor,
    exact to_is_equiv (pequiv_ppcompose_right f),
  end

  definition Group_trunc_pmap_isomorphism_refl (A B : Type*) (x : Group_trunc_pmap A B) :
    Group_trunc_pmap_isomorphism (pequiv.refl A) x = x :=
  begin
    induction x, apply ap tr, apply eq_of_phomotopy, apply pcompose_pid
  end

  definition Group_trunc_pmap_pid [constructor] {A B : Type*} (f : Group_trunc_pmap A B) :
    Group_trunc_pmap_homomorphism (pid A) f = f :=
  begin
    induction f with f, apply ap tr, apply eq_of_phomotopy, apply pcompose_pid
  end

  definition Group_trunc_pmap_pconst [constructor] {A A' B : Type*} (f : Group_trunc_pmap A B) :
    Group_trunc_pmap_homomorphism (pconst A' A) f = 1 :=
  begin
    induction f with f, apply ap tr, apply eq_of_phomotopy, apply pcompose_pconst
  end

  definition Group_trunc_pmap_pcompose [constructor] {A A' A'' B : Type*} (f : A' →* A)
    (f' : A'' →* A') (g : Group_trunc_pmap A B) : Group_trunc_pmap_homomorphism (f ∘* f') g =
    Group_trunc_pmap_homomorphism f' (Group_trunc_pmap_homomorphism f g) :=
  begin
    induction g with g, apply ap tr, apply eq_of_phomotopy, exact !passoc⁻¹*
  end

  definition Group_trunc_pmap_phomotopy [constructor] {A A' B : Type*} {f f' : A' →* A}
    (p : f ~* f') : @Group_trunc_pmap_homomorphism _ _ B f ~ Group_trunc_pmap_homomorphism f' :=
  begin
    intro g, induction g, exact ap tr (eq_of_phomotopy (pwhisker_left a p))
  end

  definition Group_trunc_pmap_phomotopy_refl {A A' B : Type*} (f : A' →* A)
    (x : Group_trunc_pmap A B) : Group_trunc_pmap_phomotopy (phomotopy.refl f) x = idp :=
  begin
    induction x,
    refine ap02 tr _,
    refine ap eq_of_phomotopy _ ⬝ !eq_of_phomotopy_refl,
    apply pwhisker_left_refl
  end

  definition ab_inf_group_pmap [constructor] [instance] (A B : Type*) :
    ab_inf_group (A →* Ω (Ω B)) :=
  ⦃ab_inf_group, inf_group_pmap A (Ω B), mul_comm :=
    begin
      intro f g, fapply pmap_eq,
      { intro a, exact eckmann_hilton (f a) (g a) },
      { rexact eq_of_square (eckmann_hilton_con2 (respect_pt f) (respect_pt g)) }
    end⦄

  definition ab_group_trunc_pmap [constructor] [instance] (A B : Type*) :
    ab_group (trunc 0 (A →* Ω (Ω B))) :=
  !trunc_ab_group

  definition AbGroup_trunc_pmap [reducible] [constructor] (A B : Type*) : AbGroup :=
  AbGroup.mk (trunc 0 (A →* Ω (Ω B))) _

  /- Group of dependent functions whose codomain is a group -/
  definition group_pi [instance] [constructor] {A : Type} (P : A → Type) [Πa, group (P a)] :
    group (Πa, P a) :=
  begin
    fapply group.mk,
    { apply is_trunc_pi },
    { intro f g a, exact f a * g a },
    { intros, apply eq_of_homotopy, intro a, apply mul.assoc },
    { intro a, exact 1 },
    { intros, apply eq_of_homotopy, intro a, apply one_mul },
    { intros, apply eq_of_homotopy, intro a, apply mul_one },
    { intro f a, exact (f a)⁻¹ },
    { intros, apply eq_of_homotopy, intro a, apply mul.left_inv }
  end

  definition Group_pi [constructor] {A : Type} (P : A → Group) : Group :=
  Group.mk (Πa, P a) _

  /- we use superscript in the following notation, because otherwise we can never write something
     like `Πg h : G, _` anymore -/

  notation `Πᵍ` binders `, ` r:(scoped P, Group_pi P) := r

  definition Group_pi_intro [constructor] {A : Type} {G : Group} {P : A → Group} (f : Πa, G →g P a)
    : G →g Πᵍ a, P a :=
  begin
    fconstructor,
    { intro g a, exact f a g },
    { intro g h, apply eq_of_homotopy, intro a, exact respect_mul (f a) g h }
  end

  /- Group of dependent functions into a loop space -/
  definition ppi_mul [constructor] {A : Type*} {B : A → Type*} (f g : Π*a, Ω (B a)) : Π*a, Ω (B a) :=
  proof ppi.mk (λa, f a ⬝ g a) (ppi_resp_pt f ◾ ppi_resp_pt g ⬝ !idp_con) qed

  definition ppi_inv [constructor] {A : Type*} {B : A → Type*} (f : Π*a, Ω (B a)) : Π*a, Ω (B a) :=
  proof ppi.mk (λa, (f a)⁻¹ᵖ) (ppi_resp_pt f)⁻² qed

  definition inf_group_ppi [constructor] [instance] {A : Type*} (B : A → Type*) :
    inf_group (Π*a, Ω (B a)) :=
  begin
    fapply inf_group.mk,
    { exact ppi_mul },
    { intro f g h, fapply ppi_eq,
      { intro a, exact con.assoc (f a) (g a) (h a) },
      { rexact eq_of_square (con2_assoc (ppi_resp_pt f) (ppi_resp_pt g) (ppi_resp_pt h)) }},
    { apply ppi_const },
    { intros f, fapply ppi_eq,
      { intro a, exact one_mul (f a) },
      { esimp, apply eq_of_square, refine _ ⬝vp !ap_id, apply natural_square_tr }},
    { intros f, fapply ppi_eq,
      { intro a, exact mul_one (f a) },
      { reflexivity }},
    { exact ppi_inv },
    { intro f, fapply ppi_eq,
      { intro a, exact con.left_inv (f a) },
      { exact !con_left_inv_idp⁻¹ }},
  end

  definition group_trunc_ppi [constructor] [instance] {A : Type*} (B : A → Type*) :
    group (trunc 0 (Π*a, Ω (B a))) :=
  !trunc_group

  definition Group_trunc_ppi [reducible] [constructor] {A : Type*} (B : A → Type*) : Group :=
  Group.mk (trunc 0 (Π*a, Ω (B a))) _

  definition ab_inf_group_ppi [constructor] [instance] {A : Type*} (B : A → Type*) :
    ab_inf_group (Π*a, Ω (Ω (B a))) :=
  ⦃ab_inf_group, inf_group_ppi (λa, Ω (B a)), mul_comm :=
    begin
      intro f g, fapply ppi_eq,
      { intro a, exact eckmann_hilton (f a) (g a) },
      { rexact eq_of_square (eckmann_hilton_con2 (ppi_resp_pt f) (ppi_resp_pt g)) }
    end⦄

  definition ab_group_trunc_ppi [constructor] [instance] {A : Type*} (B : A → Type*) :
    ab_group (trunc 0 (Π*a, Ω (Ω (B a)))) :=
  !trunc_ab_group

  definition AbGroup_trunc_ppi [reducible] [constructor] {A : Type*} (B : A → Type*) : AbGroup :=
  AbGroup.mk (trunc 0 (Π*a, Ω (Ω (B a)))) _


end group
