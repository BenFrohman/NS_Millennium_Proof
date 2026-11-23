/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import MetriplecticTetherModel.Dynamics
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Deriv
import Mathlib.Analysis.Calculus.Deriv.Prod

/-!
# MetriplecticTetherModel.Example

Non-vacuity of the tether on a physical state. For the Beltrami field
`u(x) = (0, sin 2πx₀, cos 2πx₀)` on `𝕋³` (smooth, periodic, divergence-free, `curl u = 2πu`,
`|curl u|² = 4π²`) and the constant test field `e₀ = (1,0,0)`, the tether evaluates to
`B(e₀, e₀) = −4π²κ` (`tether_beltrami`). Hence for `κ > 0` the tether is not identically zero and
has a strictly negative diagonal value (`tether_diag_neg_somewhere`), so it is not positive
semidefinite (`tether_not_psd`): it cannot serve as the metric bracket of a metriplectic system in
the convention `(F,F) ≥ 0`.
-/
open MeasureTheory Real
open scoped ContDiff
namespace MetriplecticTetherModel

theorem pd_comp_coord0 {h : ℝ → R3} {h' : ℝ → R3} (hh : ∀ t, HasDerivAt h (h' t) t)
    (j : Fin 3) (x : R3) :
    pd (fun y => h (y 0)) j x = (Pi.single j (1 : ℝ) : R3) 0 • h' (x 0) := by
  have hf : HasFDerivAt (fun y : R3 => h (y 0))
      ((ContinuousLinearMap.smulRight (1 : ℝ →L[ℝ] ℝ) (h' (x 0))).comp
        (ContinuousLinearMap.proj 0)) x :=
    (hh (x 0)).hasFDerivAt.comp x (hasFDerivAt_apply 0 x)
  unfold pd
  rw [hf.fderiv]
  simp

noncomputable def beltramiProfile (t : ℝ) : R3 := ![0, sin (2 * π * t), cos (2 * π * t)]
noncomputable def beltramiProfile' (t : ℝ) : R3 :=
  ![0, 2 * π * cos (2 * π * t), -(2 * π * sin (2 * π * t))]

theorem hasDerivAt_beltramiProfile (t : ℝ) :
    HasDerivAt beltramiProfile (beltramiProfile' t) t := by
  rw [hasDerivAt_pi]
  intro i
  have hl : HasDerivAt (fun s : ℝ => 2 * π * s) (2 * π) t := by
    simpa using (hasDerivAt_id t).const_mul (2 * π)
  fin_cases i
  · simpa [beltramiProfile, beltramiProfile'] using hasDerivAt_const t (0 : ℝ)
  · convert HasDerivAt.sin hl using 1
    simp [beltramiProfile', mul_comm]
  · convert HasDerivAt.cos hl using 1
    simp [beltramiProfile', mul_comm]


theorem beltramiProfile_add_one (t : ℝ) : beltramiProfile (t + 1) = beltramiProfile t := by
  funext i
  fin_cases i <;> simp [beltramiProfile, mul_add, Real.sin_add_two_pi, Real.cos_add_two_pi]

theorem contDiff_beltramiProfile : ContDiff ℝ ∞ beltramiProfile := by
  rw [contDiff_pi]
  intro i
  fin_cases i <;> simp [beltramiProfile] <;> fun_prop

theorem pd_beltrami (j : Fin 3) (x : R3) :
    pd (fun y => beltramiProfile (y 0)) j x = (Pi.single j (1 : ℝ) : R3) 0 • beltramiProfile' (x 0) :=
  pd_comp_coord0 hasDerivAt_beltramiProfile j x

/-- The Beltrami field `u(x) = (0, sin 2πx₀, cos 2πx₀)` on `𝕋³`. -/
noncomputable def beltrami : FlowField where
  u := fun y => beltramiProfile (y 0)
  smooth := contDiff_beltramiProfile.comp (contDiff_apply ℝ ℝ 0)
  periodic := by
    intro i x
    fin_cases i
    · simp [beltramiProfile_add_one]
    · simp
    · simp
  divFree := by
    intro x
    simp [div, pd_beltrami, Fin.sum_univ_three, beltramiProfile']

theorem curl_beltrami (x : R3) :
    curl beltrami.u x = ![0, 2 * π * sin (2 * π * x 0), 2 * π * cos (2 * π * x 0)] := by
  have h : beltrami.u = fun y => beltramiProfile (y 0) := rfl
  rw [h]
  simp [curl, pd_beltrami, beltramiProfile']

theorem dot_curl_beltrami (x : R3) : dot (curl beltrami.u x) (curl beltrami.u x) = 4 * π ^ 2 := by
  rw [curl_beltrami]
  simp only [dot, Fin.sum_univ_three]
  simp
  have := Real.sin_sq_add_cos_sq (2 * π * x 0)
  nlinarith [this]

/-- The constant divergence-free test field `e₀ = (1, 0, 0)`. -/
noncomputable def e0 : TestField where
  v := fun _ => ![1, 0, 0]
  smooth := contDiff_const
  periodic := fun _ _ => rfl
  divFree := by
    intro x
    simp [div, pd]

theorem l2_e0_beltrami : l2 e0.v beltrami.u = 0 := by
  unfold l2
  have : ∀ x, dot (e0.v x) (beltrami.u x) = 0 := by
    intro x
    simp [dot, Fin.sum_univ_three, e0, beltrami, beltramiProfile]
  simp [this]

theorem proj_beltrami_e0 : proj beltrami.u e0.v = e0.v := by
  funext x
  simp [proj, l2_e0_beltrami]

theorem mu_univ : μ Set.univ = 1 := by
  rw [μ, Measure.restrict_apply_univ, cell, volume_pi_pi]
  simp [Real.volume_Icc]

theorem tether_beltrami (κ : ℝ) :
    tether κ (curl beltrami.u) beltrami.u e0.v e0.v = -(4 * π ^ 2 * κ) := by
  unfold tether
  rw [proj_beltrami_e0]
  have h1 : ∀ x, dot (curl beltrami.u x) (curl beltrami.u x) * dot (e0.v x) (e0.v x) = 4 * π ^ 2 := by
    intro x
    rw [dot_curl_beltrami]
    simp [dot, Fin.sum_univ_three, e0]
  simp only [h1, integral_const, smul_eq_mul, measureReal_def, mu_univ, ENNReal.toReal_one, one_mul]
  ring

/-- For `κ > 0` the tether is strictly negative at a physical state and test field. -/
theorem tether_diag_neg_somewhere {κ : ℝ} (hκ : 0 < κ) :
    ∃ (u : FlowField) (a : TestField), tether κ (curl u.u) u.u a.v a.v < 0 := by
  refine ⟨beltrami, e0, ?_⟩
  rw [tether_beltrami]
  have : 0 < 4 * π ^ 2 * κ := by positivity
  linarith

/-- For `κ > 0` the tether is not positive semidefinite on physical states. -/
theorem tether_not_psd {κ : ℝ} (hκ : 0 < κ) :
    ¬ ∀ (u : FlowField) (a : TestField), 0 ≤ tether κ (curl u.u) u.u a.v a.v := by
  intro h
  obtain ⟨u, a, hlt⟩ := tether_diag_neg_somewhere hκ
  exact absurd (h u a) (not_le.2 hlt)

end MetriplecticTetherModel
