/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import Mathlib

/-!
# The tether metric form B_F and its degeneracy (Layer 1)

`B_F(F,G) = -κ ∫ |ω|² (Π_u δF · Π_u δG) dV` (ns-proof-written.tex, eq. (bf);
Conversation_Summary §2.3), with `Π_u` the L²-orthogonal projection onto the complement
of span{u}. Here the phase space is any real inner product space `E`; the weight
"multiplication by |ω|²" is an arbitrary continuous linear operator `W` (every theorem
holds for all such `W`, in particular for the multiplication operator). The instance on
the actual space L²((ℝ/2πℤ)³; ℝ³) is recorded at the end.
-/

open scoped InnerProductSpace

namespace TwoLayerT3

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]

/-- `Π_u f = f − (⟪f,u⟫/⟪u,u⟫) u`: L²-orthogonal projection onto (span{u})^⊥. -/
noncomputable def projPerp (u f : E) : E := f - (⟪f, u⟫_ℝ / ⟪u, u⟫_ℝ) • u

/-- The tether form `B_F(f,g) = -κ ⟪Π_u f, W (Π_u g)⟫`. -/
noncomputable def tetherForm (κ : ℝ) (W : E →L[ℝ] E) (u f g : E) : ℝ :=
  -κ * ⟪projPerp u f, W (projPerp u g)⟫_ℝ

theorem projPerp_self (u : E) : projPerp u u = 0 := by
  by_cases hu : u = 0
  · simp [projPerp, hu]
  · have h : ‖u‖ ^ 2 ≠ 0 := pow_ne_zero 2 (norm_ne_zero_iff.mpr hu)
    rw [projPerp, real_inner_self_eq_norm_sq, div_self h, one_smul, sub_self]

theorem inner_projPerp_u (u f : E) : ⟪projPerp u f, u⟫_ℝ = 0 := by
  by_cases hu : u = 0
  · simp [hu]
  · have h : ‖u‖ ^ 2 ≠ 0 := pow_ne_zero 2 (norm_ne_zero_iff.mpr hu)
    rw [projPerp, inner_sub_left, real_inner_smul_left, real_inner_self_eq_norm_sq,
      div_mul_cancel₀ _ h, sub_self]

theorem projPerp_idem (u f : E) : projPerp u (projPerp u f) = projPerp u f := by
  show projPerp u f - (⟪projPerp u f, u⟫_ℝ / ⟪u, u⟫_ℝ) • u = projPerp u f
  rw [inner_projPerp_u, zero_div, zero_smul, sub_zero]

/-- **Degeneracy (A3), momentum reading** (δH/δμ = u): `B_F(f, u) = 0` for every `f`,
every κ and every weight operator `W`. -/
theorem tether_degenerate (κ : ℝ) (W : E →L[ℝ] E) (u f : E) : tetherForm κ W u f u = 0 := by
  simp [tetherForm, projPerp_self]

/-- Metriplectic rate `dF/dt = {F,H} + B_F(F,H) + [F,H]_diss` (Full_Living_May24 §5) with
`δH = u`: the tether term drops out identically, for arbitrary bracket `LP` and
dissipative part `D`. -/
theorem metriplectic_rate_tether_drops (LP D : E → E → ℝ) (κ : ℝ) (W : E →L[ℝ] E) (u f : E) :
    LP f u + tetherForm κ W u f u + D f u = LP f u + D f u := by
  rw [tether_degenerate]; ring

/-- Hence the tether contributes no strictly negative term to any rate along the H-flow. -/
theorem tether_no_feedback (κ : ℝ) (W : E →L[ℝ] E) (u f : E) : ¬ tetherForm κ W u f u < 0 := by
  rw [tether_degenerate]; exact lt_irrefl 0

/-- **Vorticity reading** (δH/δω = g arbitrary): for κ > 0 and positive-definite `W`,
`B_F(·, g) ≡ 0` iff `Π_u g = 0`. -/
theorem tether_degenerate_iff (κ : ℝ) (hκ : 0 < κ) (W : E →L[ℝ] E)
    (hW : ∀ x : E, x ≠ 0 → 0 < ⟪x, W x⟫_ℝ) (u g : E) :
    (∀ f, tetherForm κ W u f g = 0) ↔ projPerp u g = 0 := by
  constructor
  · intro h
    by_contra hne
    have h1 := h (projPerp u g)
    simp only [tetherForm, projPerp_idem] at h1
    have h2 := hW _ hne
    have : -κ * ⟪projPerp u g, W (projPerp u g)⟫_ℝ < 0 := by nlinarith
    linarith
  · intro h f
    simp [tetherForm, h]

/-- `Π_u g = 0` forces `g` to be a scalar multiple of `u`. -/
theorem projPerp_eq_zero_imp (u g : E) (h : projPerp u g = 0) : ∃ c : ℝ, g = c • u :=
  ⟨⟪g, u⟫_ℝ / ⟪u, u⟫_ℝ, sub_eq_zero.mp h⟩

/-- **(A1) antisymmetry fails**: if κ > 0, `W` is positive definite and `Π_u v ≠ 0`,
then `B_F(v,v) < 0`, so `B_F` is not antisymmetric. -/
theorem tether_not_antisymm (κ : ℝ) (hκ : 0 < κ) (W : E →L[ℝ] E)
    (hW : ∀ x : E, x ≠ 0 → 0 < ⟪x, W x⟫_ℝ) (u v : E) (hv : projPerp u v ≠ 0) :
    ¬ (∀ f g, tetherForm κ W u f g = - tetherForm κ W u g f) := by
  intro h
  have h1 := h v v
  have h2 := hW _ hv
  have h3 : tetherForm κ W u v v < 0 := by
    simp only [tetherForm]; nlinarith
  linarith

/-! ## The actual phase space: L²((ℝ/2πℤ)³; ℝ³) -/

noncomputable section

instance fact_two_pi_pos : Fact (0 < 2 * Real.pi) := ⟨by positivity⟩

/-- The 3-torus `(ℝ/2πℤ)³`. -/
abbrev Torus3 := Fin 3 → AddCircle (2 * Real.pi)

/-- Square-integrable ℝ³-valued fields on the 3-torus. -/
abbrev L2Field := MeasureTheory.Lp (EuclideanSpace ℝ (Fin 3)) 2
  (MeasureTheory.volume : MeasureTheory.Measure Torus3)

example : InnerProductSpace ℝ L2Field := inferInstance

/-- Degeneracy on the actual L²(𝕋³; ℝ³) phase space. -/
theorem tether_degenerate_L2 (κ : ℝ) (W : L2Field →L[ℝ] L2Field) (u f : L2Field) :
    tetherForm κ W u f u = 0 := tether_degenerate κ W u f

end

end TwoLayerT3
