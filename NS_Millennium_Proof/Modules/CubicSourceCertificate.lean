/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
SPDX-License-Identifier: Apache-2.0
Authors: Benjamin Stanley Frohman
-/

module

public import Mathlib.Tactic.Ring

/-!
# Cubic source versus hypothesized cubic sink

Audit module. It does not discharge `hRiccati`, `global_regularity_for_NS`,
or `frohmanian_tether_theorem`.

Identity (2) at a spatial maximum is a cubic source: the pairing is at most
`C_CZ M³`, so `M' ≤ C_CZ M²` for `M > 0`. The factor `1 + κ M²` is
nonnegative and preserves that source. It does not produce `-κ M³`.

`cubic_sink_of_corrected_rate` is `ring` applied to `CorrectedMaxRate`.
The subtraction of `κ M²` from the strain is a hypothesis, not a theorem
about `B_F`. `B(F,H) ≡ 0` does not insert the minus.

Do not import this file from `GlobalRegularity`, `TetheredLyapunov`,
`IndependentMajorant`, or the discharge of `hRiccati`.
-/

namespace Frohmanian.CubicSourceAudit

/-- Rate already assumed to carry the strain subtraction `C M - κ M²`.
Not derived from `ω · ∂ₜω`. -/
public def CorrectedMaxRate (rate M C κ : ℝ) : Prop :=
  rate ≤ M * (C * M - κ * M ^ 2)

/-- Classical pairing bound at a spatial maximum: a cubic source. -/
public def ClassicalStretchingSource (pairing M C : ℝ) : Prop :=
  pairing ≤ C * M ^ 3

/-- Algebra only. The hypothesis is not a theorem about `B_F`. -/
public theorem cubic_sink_of_corrected_rate
    (rate M C κ : ℝ) (h : CorrectedMaxRate rate M C κ) :
    rate ≤ C * M ^ 2 - κ * M ^ 3 := by
  have hmul : M * (C * M - κ * M ^ 2) = C * M ^ 2 - κ * M ^ 3 := by ring
  simpa [CorrectedMaxRate, hmul] using h

/-- Identity (2) gives only the quadratic majorant. -/
public theorem quadratic_rate_of_classical_source
    (rate M C : ℝ) (hM : 0 < M)
    (h : ClassicalStretchingSource (M * rate) M C) :
    rate ≤ C * M ^ 2 := by
  have hrewrite : C * M ^ 3 = M * (C * M ^ 2) := by ring
  have hmul : M * rate ≤ M * (C * M ^ 2) := by
    simpa [ClassicalStretchingSource, hrewrite] using h
  exact le_of_mul_le_mul_left hmul hM

/-- The product rule multiplies by a nonnegative factor and preserves the source. -/
public theorem weighted_source_of_pairing
    (pairing M C κ : ℝ) (hκ : 0 ≤ κ)
    (h : ClassicalStretchingSource pairing M C) :
    pairing * (1 + κ * M ^ 2) ≤ C * M ^ 3 + C * κ * M ^ 5 := by
  have hfac : 0 ≤ 1 + κ * M ^ 2 := by
    have : 0 ≤ κ * M ^ 2 := mul_nonneg hκ (sq_nonneg M)
    linarith
  have hmul := mul_le_mul_of_nonneg_right h hfac
  calc
    pairing * (1 + κ * M ^ 2) ≤ (C * M ^ 3) * (1 + κ * M ^ 2) := by
      simpa [ClassicalStretchingSource] using hmul
    _ = C * M ^ 3 + C * κ * M ^ 5 := by ring

/-- ODE fact about the hypothesized field. Not a theorem about `ω · ∂ₜω`. -/
public theorem cubic_field_negative_above_ceiling
    (y C κ : ℝ) (hy : 0 < y) (hκ : 0 < κ) (hceil : C / κ < y) :
    C * y ^ 2 - κ * y ^ 3 < 0 := by
  have hfac : C * y ^ 2 - κ * y ^ 3 = y ^ 2 * (C - κ * y) := by ring
  rw [hfac]
  refine mul_neg_of_pos_of_neg (pow_pos hy 2) ?_
  have hky : C < κ * y := by
    have := mul_lt_mul_of_pos_left hceil hκ
    rwa [mul_div_cancel₀ C hκ.ne'] at this
  linarith

end Frohmanian.CubicSourceAudit
