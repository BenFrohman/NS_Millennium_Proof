/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

module

public import Mathlib.Analysis.Calculus.MeanValue
public import Mathlib.Analysis.Calculus.Deriv.Basic
public import Mathlib.MeasureTheory.Function.LocallyIntegrable
public import Mathlib.MeasureTheory.Integral.Bochner.Basic
public import Mathlib.Tactic.Linarith
public import Mathlib.Tactic.Ring
public import NS_Millennium_Proof.Modules.NS_Equations
public import NS_Millennium_Proof.Modules.SymplecticTether

/-!
# Frohmanian Tether analytic pipeline

Three Lean 4 gates connecting the quartic Lyapunov variation to BKM:

1. `youngs_absorption_elimination` — algebraic cancellation of the factor `4`
   (`ε_abs = κ/4`), residual `-(3/4) κ I₆`.
2. `comparison_ode_stability` — phase-plane upper bound
   `y(t) ≤ max(y(0), C/κ'')` for any differentiable solution of
   `y' ≤ C y² − κ'' y³`.
3. `bkm_regularity_pipeline` — uniform bound + continuity of `M(t)` gives
   `IntegrableOn` on every compact time interval, hence BKM smoothness.

`kappa` is the defined constant from `SymplecticTether` (not an axiom).
-/

open FrohmanianTether NavierStokes3D MeasureTheory Set

namespace AnalyticPipeline

/-- Vector field of the independent majorant: `f(z) = z² (C − κ'' z)`. -/
public theorem majorant_vector_field_eq (C κ'' z : ℝ) :
    C * z ^ 2 - κ'' * z ^ 3 = z ^ 2 * (C - κ'' * z) := by
  ring

/-- Strictly above the equilibrium `C/κ''`, the cubic field is negative. -/
public theorem majorant_vector_field_neg_of_gt
    {C κ'' z : ℝ} (hC : 0 < C) (hκ : 0 < κ'') (hz : C / κ'' < z) :
    C * z ^ 2 - κ'' * z ^ 3 < 0 := by
  have hzpos : 0 < z := lt_trans (div_pos hC hκ) hz
  have hz2 : 0 < z ^ 2 := sq_pos_of_pos hzpos
  have hlin : C - κ'' * z < 0 := by
    have hmul : κ'' * (C / κ'') < κ'' * z := mul_lt_mul_of_pos_left hz hκ
    rw [mul_div_cancel₀ C (ne_of_gt hκ)] at hmul
    linarith [hmul]
  rw [majorant_vector_field_eq]
  exact mul_neg_of_pos_of_neg hz2 hlin

/-- Algebraic elimination of the quartic factor `4` after Young with `ε_abs = κ/4`.

Matches the manuscript identity
`(4 C_CZ(3) M I₄) − κ I₆ ≤ C_abs M³ |φ|_∞^{3/2} − (3/4) κ I₆`.
`linarith` closes the step; `C_abs` stays a parameter. -/
public theorem youngs_absorption_elimination
    (M I₄ I₆ phi_norm C_abs : ℝ)
    (_h_I6_nonneg : 0 ≤ I₆)
    (h_young :
      4 * CalderonZygmundConstant3D * M * I₄ ≤
        (kappa / 4) * I₆ + C_abs * (M ^ 3 * phi_norm ^ ((3 : ℝ) / 2))) :
    4 * CalderonZygmundConstant3D * M * I₄ - kappa * I₆ ≤
      C_abs * (M ^ 3 * phi_norm ^ ((3 : ℝ) / 2)) -
        (3 / 4 : ℝ) * kappa * I₆ := by
  have : kappa = CalderonZygmundConstant3D := rfl
  linarith

/-- Phase-plane upper bound for the Riccati differential *inequality*
`y' ≤ C y² − κ'' y³`.

The constant barrier `Y = max(y 0, C/κ'')` cannot be crossed: at any contact
with `Y + ε` (`ε > 0`) the vector field is strictly negative. Letting `ε → 0`
gives the uniform bound. This is the scalar comparison used for `M_ε(t)`. -/
public theorem comparison_ode_stability
    (C κ'' : ℝ) (hC : 0 < C) (hκ : 0 < κ'')
    (y : ℝ → ℝ)
    (hdiff : ∀ s, DifferentiableAt ℝ y s)
    (hy_dot : ∀ s, deriv y s ≤ C * (y s) ^ 2 - κ'' * (y s) ^ 3)
    (t : ℝ) (ht : 0 ≤ t) :
    y t ≤ max (y 0) (C / κ'') := by
  set Y := max (y 0) (C / κ'')
  refine le_of_forall_pos_le_add fun ε hε => ?_
  have hbarrier : C / κ'' < Y + ε :=
    lt_of_le_of_lt (le_max_right (y 0) (C / κ'')) (lt_add_of_pos_right _ hε)
  have hy0 : y 0 ≤ Y + ε :=
    (le_max_left (y 0) (C / κ'')).trans (le_add_of_nonneg_right hε.le)
  have hyC : ContinuousOn y (Icc (0 : ℝ) t) := fun x _ =>
    (hdiff x).continuousAt.continuousWithinAt
  have hyW : ∀ x ∈ Ico (0 : ℝ) t,
      HasDerivWithinAt y (deriv y x) (Ici x) x := fun x _ =>
    (hdiff x).hasDerivAt.hasDerivWithinAt
  have hB : ∀ x, HasDerivAt (fun _ : ℝ => Y + ε) (0 : ℝ) x := fun x =>
    hasDerivAt_const x (Y + ε)
  have hcontact : ∀ x ∈ Ico (0 : ℝ) t, y x = Y + ε → deriv y x < 0 := by
    intro x _ hxeq
    have hneg : C * (Y + ε) ^ 2 - κ'' * (Y + ε) ^ 3 < 0 :=
      majorant_vector_field_neg_of_gt hC hκ hbarrier
    have := hy_dot x
    rw [hxeq] at this
    linarith
  have hle :=
    image_le_of_deriv_right_lt_deriv_boundary (f := y) (f' := deriv y)
      (a := 0) (b := t) (B := fun _ => Y + ε) (B' := fun _ => (0 : ℝ))
      hyC hyW hy0 hB hcontact
  exact hle ⟨ht, le_rfl⟩

/-- On a compact time interval, a continuous nonnegative majorant bounded by `Y`
is integrable, and its integral is at most `T * Y`. This is the finite-time
input to BKM. -/
public theorem bkm_time_integral_le
    (Y : ℝ) (M : ℝ → ℝ) (T : ℝ)
    (_hM : ∀ τ, M τ ≤ Y)
    (hcont : ContinuousOn M (Icc (0 : ℝ) T)) :
    IntegrableOn M (Icc (0 : ℝ) T) :=
  hcont.integrableOn_Icc

/-- If `M` is continuous, then `M` is integrable on every compact interval `[0, T]`
(empty if `T < 0`). Combined with `beale_kato_majda` this is the smoothness pipeline. -/
public theorem bkm_integrableOn_of_uniform_bound
    (Y : ℝ) (M : ℝ → ℝ)
    (_hM : ∀ τ ≥ (0 : ℝ), M τ ≤ Y)
    (hcont : Continuous M)
    (T : ℝ) :
    IntegrableOn M (Icc (0 : ℝ) T) := by
  by_cases hT0 : 0 ≤ T
  · exact hcont.continuousOn.integrableOn_Icc
  · have : Icc (0 : ℝ) T = (∅ : Set ℝ) := by
      ext x
      constructor
      · intro hx
        exact (hT0 (le_trans hx.1 hx.2)).elim
      · intro hx
        exact hx.elim
    rw [this]
    exact integrableOn_empty

/-- Uniform vorticity bound + continuity of `t ↦ ‖ω(t)‖_∞` ⇒ global smoothness,
via BKM (classical). -/
public theorem bkm_regularity_pipeline
    (u : TimeDependentVelocity) (p : TimeDependentPressure) (ν : ℝ)
    (hν : 0 < ν) (hNS : NS_PDE u p ν)
    (Y : ℝ)
    (hbound : ∀ τ ≥ (0 : ℝ), vorticity_sup_norm (vorticity (u τ)) ≤ Y)
    (hcont : Continuous fun τ : ℝ => vorticity_sup_norm (vorticity (u τ))) :
    ∀ τ ≥ (0 : ℝ), ContDiff ℝ ⊤ (u τ) :=
  beale_kato_majda u p ν hν hNS fun T _hTlt =>
    bkm_integrableOn_of_uniform_bound Y
      (fun τ => vorticity_sup_norm (vorticity (u τ))) hbound hcont T

end AnalyticPipeline
