/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import Mathlib.Analysis.Calculus.MeanValue
import Mathlib.Analysis.Calculus.Deriv.Mul

/-!
# The independent comparison majorant `y' = C y² - κ'' y³`

Pure ODE facts, proved in full, about the autonomous majorant equation
`y' = C y² - κ'' y³ = y² (C - κ'' y)` with constants `C > 0`, `κ'' > 0`, whose equilibria are
`0` and `y* = C / κ''`.

* `le_max_of_subsolution`: every differentiable **sub**solution
  `M' ≤ C M² - κ'' M³` on `[0, T)` satisfies `M(t) ≤ max (M 0) (C / κ'')` on `[0, T)`.
* `nonneg_of_solution`: a solution with `y 0 ≥ 0` stays `≥ 0`.
* `comparison_majorant_global_bound`: a solution with `y 0 ≥ 0` satisfies
  `0 ≤ y(t) ≤ max (y 0) (C / κ'')` on `[0, T)`, with a bound independent of `T`.

These statements are about every solution; the existence of a global solution of the ODE
is not used and not claimed here. The earlier version of this file declared the solution
`ComparisonODE` and several other functions with `sorry` bodies, and its
`uniform_majorant_bound` quantified over the two-element list `[0, T]` instead of the interval.
-/

open Set

namespace IndependentMajorant

/-- Barrier lemma: if `f(0) ≤ A` and, for every `ε > 0`, `f' < ε` wherever `f = A + ε (1 + x)`,
then `f ≤ A` on `[0, T)`. -/
theorem le_of_barrier {T A : ℝ} {f f' : ℝ → ℝ} (hf : ∀ t ∈ Ico 0 T, HasDerivAt f (f' t) t)
    (h0 : f 0 ≤ A)
    (hbar : ∀ ε > 0, ∀ x ∈ Ico 0 T, f x = A + ε * (1 + x) → f' x < ε) :
    ∀ t ∈ Ico 0 T, f t ≤ A := by
  intro t ht
  have key : ∀ ε > 0, f t ≤ A + ε * (1 + t) := by
    intro ε hε
    have hcont : ContinuousOn f (Icc 0 t) := fun s hs =>
      (hf s ⟨hs.1, hs.2.trans_lt ht.2⟩).continuousAt.continuousWithinAt
    have hderiv : ∀ x ∈ Ico 0 t, HasDerivWithinAt f (f' x) (Ici x) x := fun x hx =>
      (hf x ⟨hx.1, hx.2.trans ht.2⟩).hasDerivWithinAt
    have hstart : f 0 ≤ A + ε * (1 + 0) := by nlinarith
    have hB : ∀ x, HasDerivAt (fun s => A + ε * (1 + s)) ε x := by
      intro x
      simpa using (((hasDerivAt_id x).const_add 1).const_mul ε).const_add A
    exact image_le_of_deriv_right_lt_deriv_boundary hcont hderiv hstart hB
      (fun x hx hfx => hbar ε hε x ⟨hx.1, hx.2.trans ht.2⟩ hfx) ⟨ht.1, le_rfl⟩
  by_contra h
  push_neg at h
  have h1t : 0 < 1 + t := by linarith [ht.1]
  have hδ : 0 < (f t - A) / 2 := by linarith
  have := key ((f t - A) / 2 / (1 + t)) (div_pos hδ h1t)
  rw [div_mul_cancel₀ _ h1t.ne'] at this
  linarith

/-- Every subsolution of `y' = C y² - κ'' y³` on `[0, T)` stays below `max (M 0) (C / κ'')`. -/
theorem le_max_of_subsolution {C κ'' T : ℝ} (hC : 0 < C) (hκ : 0 < κ'') {M M' : ℝ → ℝ}
    (hM : ∀ t ∈ Ico 0 T, HasDerivAt M (M' t) t)
    (hineq : ∀ t ∈ Ico 0 T, M' t ≤ C * M t ^ 2 - κ'' * M t ^ 3) :
    ∀ t ∈ Ico 0 T, M t ≤ max (M 0) (C / κ'') := by
  refine le_of_barrier hM (le_max_left _ _) fun ε hε x hx hMx => ?_
  have hY : C / κ'' ≤ max (M 0) (C / κ'') := le_max_right _ _
  have hpos : 0 < ε * (1 + x) := mul_pos hε (by linarith [hx.1])
  have hgt : C / κ'' < M x := by rw [hMx]; linarith
  have hMpos : 0 < M x := lt_trans (div_pos hC hκ) hgt
  have hκM : C < κ'' * M x := by
    rw [div_lt_iff₀ hκ] at hgt; linarith
  have hneg : C * M x ^ 2 - κ'' * M x ^ 3 < 0 := by
    have : C * M x ^ 2 - κ'' * M x ^ 3 = M x ^ 2 * (C - κ'' * M x) := by ring
    rw [this]; exact mul_neg_of_pos_of_neg (by positivity) (by linarith)
  linarith [hineq x hx]

/-- A solution of `y' = C y² - κ'' y³` with `y 0 ≥ 0` stays nonnegative on `[0, T)`. -/
theorem nonneg_of_solution {C κ'' T : ℝ} (hC : 0 < C) (hκ : 0 < κ'') {y y' : ℝ → ℝ}
    (hy : ∀ t ∈ Ico 0 T, HasDerivAt y (y' t) t)
    (hode : ∀ t ∈ Ico 0 T, y' t = C * y t ^ 2 - κ'' * y t ^ 3) (h0 : 0 ≤ y 0) :
    ∀ t ∈ Ico 0 T, 0 ≤ y t := by
  have hneg : ∀ t ∈ Ico 0 T, -y t ≤ 0 := by
    refine le_of_barrier (f := fun s => -y s) (f' := fun s => -y' s)
      (fun t ht => (hy t ht).neg) (show -y 0 ≤ 0 by linarith) fun ε hε x hx hyx => ?_
    have hpos : 0 < ε * (1 + x) := mul_pos hε (by linarith [hx.1])
    have hyx' : -y x = 0 + ε * (1 + x) := hyx
    have hyneg : y x < 0 := by linarith
    have : 0 < C * y x ^ 2 - κ'' * y x ^ 3 := by
      have : C * y x ^ 2 - κ'' * y x ^ 3 = y x ^ 2 * (C - κ'' * y x) := by ring
      rw [this]
      exact mul_pos (by positivity) (by nlinarith)
    show -y' x < ε
    linarith [hode x hx]
  intro t ht
  linarith [hneg t ht]

/-- **Phase-plane bound.** A solution of `y' = C y² - κ'' y³` with `y 0 ≥ 0` satisfies
`0 ≤ y(t) ≤ max (y 0) (C / κ'')` on `[0, T)`; the bound does not depend on `T`. -/
theorem comparison_majorant_global_bound {C κ'' T : ℝ} (hC : 0 < C) (hκ : 0 < κ'')
    {y y' : ℝ → ℝ} (hy : ∀ t ∈ Ico 0 T, HasDerivAt y (y' t) t)
    (hode : ∀ t ∈ Ico 0 T, y' t = C * y t ^ 2 - κ'' * y t ^ 3) (h0 : 0 ≤ y 0) :
    ∀ t ∈ Ico 0 T, 0 ≤ y t ∧ y t ≤ max (y 0) (C / κ'') :=
  fun t ht => ⟨nonneg_of_solution hC hκ hy hode h0 t ht,
    le_max_of_subsolution hC hκ hy (fun s hs => (hode s hs).le) t ht⟩

end IndependentMajorant
