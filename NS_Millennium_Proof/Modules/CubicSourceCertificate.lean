/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
SPDX-License-Identifier: Apache-2.0
Authors: Benjamin Stanley Frohman
-/

module

public import Mathlib.Tactic.Ring
public import Mathlib.Tactic.Linarith
public import Mathlib.Algebra.Order.Ring.Defs

/-!
# Cubic source versus hypothesized cubic sink

Audit module. It does not discharge `hRiccati`, `global_regularity_for_NS`,
or `frohmanian_tether_theorem`. Do not import it from `GlobalRegularity`,
`TetheredLyapunov`, `IndependentMajorant`, or `ClosureBlueprint`.

Identity (2) at a spatial maximum is a cubic source: the pairing is at most
`C_CZ M³`, so `M' ≤ C_CZ M²` for `M > 0`. The factor `1 + κ M²` is
nonnegative and preserves that source.

`cubic_sink_of_corrected_rate` is `ring` applied to `CorrectedMaxRate`.
The subtraction of `κ M²` from the strain is a hypothesis, not a theorem
about `B_F`. `B(F,H) ≡ 0` does not insert the minus.

The strict ceiling inequality needs `0 < y`. At `y = 0` the field is zero,
not strictly negative.
-/

namespace Frohmanian.CubicSourceAudit

/-- Hypothesized corrected rate. The subtraction is not a theorem about `B_F`. -/
def CorrectedMaxRate (rate M C κ : ℝ) : Prop :=
  rate ≤ M * (C * M - κ * M ^ 2)

/-- Classical stretching pairing at a spatial maximum: a source, not a sink. -/
def ClassicalStretchingSource (pairing M C : ℝ) : Prop :=
  pairing ≤ C * M ^ 3

theorem cubic_sink_of_corrected_rate
    (rate M C κ : ℝ) (h : CorrectedMaxRate rate M C κ) :
    rate ≤ C * M ^ 2 - κ * M ^ 3 := by
  have hmul : M * (C * M - κ * M ^ 2) = C * M ^ 2 - κ * M ^ 3 := by ring
  simpa [CorrectedMaxRate, hmul] using h

theorem quadratic_rate_of_classical_source
    (rate M C : ℝ) (hM : 0 < M)
    (h : ClassicalStretchingSource (M * rate) M C) :
    rate ≤ C * M ^ 2 := by
  have hrewrite : C * M ^ 3 = M * (C * M ^ 2) := by ring
  have hmul : M * rate ≤ M * (C * M ^ 2) := by
    simpa [ClassicalStretchingSource, hrewrite] using h
  exact le_of_mul_le_mul_left hmul hM

theorem weighted_source_of_pairing
    (pairing M C κ : ℝ) (hκ : 0 ≤ κ)
    (h : ClassicalStretchingSource pairing M C) :
    pairing * (1 + κ * M ^ 2) ≤ C * M ^ 3 + C * κ * M ^ 5 := by
  have hineq : pairing ≤ C * M ^ 3 := by simpa [ClassicalStretchingSource] using h
  have hfac : 0 ≤ 1 + κ * M ^ 2 := by
    have : 0 ≤ κ * M ^ 2 := mul_nonneg hκ (sq_nonneg M)
    linarith
  have hmul := mul_le_mul_of_nonneg_right hineq hfac
  calc
    pairing * (1 + κ * M ^ 2) ≤ (C * M ^ 3) * (1 + κ * M ^ 2) := hmul
    _ = C * M ^ 3 + C * κ * M ^ 5 := by ring

/-- Strict negativity above the ceiling needs `0 < y`. This is ODE algebra
about the hypothesized field, not a theorem about `ω · ∂ₜω`. -/
theorem cubic_field_negative_above_ceiling
    (y C κ : ℝ) (hy : 0 < y) (hκ : 0 < κ) (hceil : C / κ < y) :
    C * y ^ 2 - κ * y ^ 3 < 0 := by
  have hfac : C * y ^ 2 - κ * y ^ 3 = y ^ 2 * (C - κ * y) := by ring
  rw [hfac]
  refine mul_neg_of_pos_of_neg (pow_pos hy 2) ?_
  have hky : C < κ * y := by
    have := mul_lt_mul_of_pos_left hceil hκ
    rwa [mul_div_cancel₀ C hκ.ne'] at this
  linarith

/-- A rate sitting on the classical source bound is not a cubic sink
when `κ M³ > 0`. -/
theorem source_does_not_imply_sink
    (M C κ : ℝ) (hM : 0 < M) (hκ : 0 < κ) :
    ¬ (C * M ^ 2 ≤ C * M ^ 2 - κ * M ^ 3) := by
  intro h
  have hle : κ * M ^ 3 ≤ 0 := by linarith
  have hpos : 0 < κ * M ^ 3 := by positivity
  exact not_lt_of_ge hle hpos

end Frohmanian.CubicSourceAudit
