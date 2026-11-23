/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import Mathlib

/-!
# Layer 2: sign of the φ-term and the constants verdict

Full_Living_May24 §3: `S_ε = ∫ (½|ω_ε|² + (κ/4)|ω_ε|⁴ φ_ε)`, `∂ₜφ + u·∇φ = |ω|²`, `φ(0)=0`.
Along a particle path put `a(t) = |ω|²` and `φ' = a`. Then
`d/dt[(κ/4) a² φ] = (κ/2) a a' φ + (κ/4) a³`, which at `t = 0` (φ = 0) is `(κ/4) a(0)³ > 0`:
the |ω|⁶ term produced by the φ-weight is a SOURCE, not the sink `−(κ/2)∫|ω_ε|⁶` claimed there.
-/

namespace TwoLayerT3.LayerTwo

/-- Product-rule identity for the φ-weighted quartic term along a particle path. -/
theorem phi_term_deriv (κ : ℝ) {a φ : ℝ → ℝ} {a' : ℝ} {t : ℝ}
    (ha : HasDerivAt a a' t) (hφ : HasDerivAt φ (a t) t) :
    HasDerivAt (fun s => κ / 4 * a s ^ 2 * φ s)
      (κ / 2 * a t * a' * φ t + κ / 4 * a t ^ 3) t := by
  have h := ((ha.pow 2).const_mul (κ / 4)).mul hφ
  convert h using 1
  simp; ring

/-- At `t = 0` with `φ(0) = 0`: the φ-term has derivative `(κ/4) a(0)³`, strictly positive
when κ > 0 and |ω|² = a(0) > 0. -/
theorem phi_term_source (κ : ℝ) (hκ : 0 < κ) {a φ : ℝ → ℝ} {a' : ℝ}
    (ha : HasDerivAt a a' 0) (hφ : HasDerivAt φ (a 0) 0) (hφ0 : φ 0 = 0) (ha0 : 0 < a 0) :
    ∃ d, HasDerivAt (fun s => κ / 4 * a s ^ 2 * φ s) d 0 ∧ 0 < d := by
  refine ⟨_, phi_term_deriv κ ha hφ, ?_⟩
  rw [hφ0]; simp; positivity

/-- **Sup-norm, ν-only constants refuted (algebra).** With M(0) = 6A and touching-function
slope 6A(A−ν) (Nov 9 family, KeyEstimateRefutation.rhs_origin / omega_norm_bound),
for every ν, C and κ'' > 0 some amplitude A > ν violates `M' ≤ C M² − κ'' M³`. -/
theorem cubic_rate_amplitude (ν C k : ℝ) (hν : 0 < ν) (hk : 0 < k) :
    ∃ A : ℝ, ν < A ∧ C * (6 * A) ^ 2 - k * (6 * A) ^ 3 < 6 * A * (A - ν) := by
  refine ⟨ν + 1 + |C| / k, by have := div_nonneg (abs_nonneg C) hk.le; linarith, ?_⟩
  set A := ν + 1 + |C| / k with hA
  have hq : 0 ≤ |C| / k := div_nonneg (abs_nonneg C) hk.le
  have hA0 : 0 < A := by rw [hA]; linarith
  have hCk : |C| ≤ k * A := by
    have : |C| / k ≤ A := by rw [hA]; linarith
    have := (div_le_iff₀ hk).mp this; linarith
  have hC : C ≤ |C| := le_abs_self C
  have h6 : 6 * A * (C - k * 6 * A) < A - ν := by
    have e1 : 6 * A * C ≤ 6 * A * (k * A) := by
      have := le_trans hC hCk; nlinarith
    have : 0 < A - ν := by rw [hA]; linarith
    nlinarith [mul_pos hk (mul_pos hA0 hA0)]
  have e : C * (6 * A) ^ 2 - k * (6 * A) ^ 3 = (6 * A) * ((6 * A) * (C - k * 6 * A)) := by ring
  rw [e]
  have h6A : 0 < 6 * A := by linarith
  exact mul_lt_mul_of_pos_left h6 h6A

/-- **Enstrophy, ν-only constants refuted (algebra).** With E(0) = 40π³A², E'(0) = −88π³νA²
(sympy, `sympy/checks.log`; NOT kernel-checked), some amplitude violates
`E' ≤ C E² − κ'' E³`. -/
theorem enstrophy_rate_amplitude (ν C k : ℝ) (hν : 0 < ν) (hk : 0 < k) :
    ∃ A : ℝ, 0 < A ∧
      C * (40 * Real.pi ^ 3 * A ^ 2) ^ 2 - k * (40 * Real.pi ^ 3 * A ^ 2) ^ 3
        < -88 * Real.pi ^ 3 * ν * A ^ 2 := by
  set p := 40 * Real.pi ^ 3 with hp
  have hp0 : 0 < p := by rw [hp]; positivity
  set Et := 1 + (|C| + 3 * ν) / k with hEt
  have hq : 0 ≤ (|C| + 3 * ν) / k := div_nonneg (by positivity) hk.le
  have hEt1 : 1 ≤ Et := by rw [hEt]; linarith
  have hEt0 : 0 < Et := by linarith
  have hpos : 0 < Et / p := div_pos hEt0 hp0
  refine ⟨Real.sqrt (Et / p), Real.sqrt_pos.mpr hpos, ?_⟩
  have hsq : Real.sqrt (Et / p) ^ 2 = Et / p := Real.sq_sqrt hpos.le
  have hE : 40 * Real.pi ^ 3 * Real.sqrt (Et / p) ^ 2 = Et := by
    rw [hsq, ← hp]; field_simp
  have h88 : -88 * Real.pi ^ 3 * ν * Real.sqrt (Et / p) ^ 2 = -(88 / 40 * ν * Et) := by
    linear_combination (-(88 / 40) * ν) * hE
  rw [h88, hE]
  have hkE : |C| + 3 * ν ≤ k * Et := by
    have : (|C| + 3 * ν) / k ≤ Et := by rw [hEt]; linarith
    have := (div_le_iff₀ hk).mp this; linarith
  have hC : C ≤ |C| := le_abs_self C
  have hE2 : 0 < Et ^ 2 := by positivity
  have s1 : (|C| + 3 * ν) * Et ^ 2 ≤ k * Et * Et ^ 2 := mul_le_mul_of_nonneg_right hkE hE2.le
  have s2 : C * Et ^ 2 ≤ |C| * Et ^ 2 := mul_le_mul_of_nonneg_right hC hE2.le
  have s3 : Et ≤ Et ^ 2 := by nlinarith
  nlinarith

end TwoLayerT3.LayerTwo
