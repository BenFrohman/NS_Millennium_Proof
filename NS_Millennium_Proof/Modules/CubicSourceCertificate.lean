/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
SPDX-License-Identifier: Apache-2.0
Authors: Benjamin Stanley Frohman
-/

module

public import Mathlib.Data.Real.Basic
public import Mathlib.Tactic.Ring

/-!
# Cubic source versus hypothesized cubic sink

Audit module. It does not discharge `hRiccati`, `global_regularity_for_NS`,
or `frohmanian_tether_theorem`.

At a spatial maximum the proved pairing is `C M³`, so `M' ≤ C M²` for `M > 0`.
The missing identity is the reduced pairing `(C M - κ M²) M²`.
That expands to `C M³ - κ M⁴`, and the corresponding rate is `C M² - κ M³`.
The `M⁵` term is only the weighted source `C M³ (1 + κ M²)`.
It is not a sink.

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
@[expose] public def ClassicalStretchingSource (pairing M C : ℝ) : Prop :=
  pairing ≤ C * M ^ 3

/-- Missing identity, recorded and not proved.
`pairing = ω · ((ω · ∇) u)` at a spatial maximum. -/
@[expose] public def ReducedStrain (pairing M C κ : ℝ) : Prop :=
  pairing ≤ (C * M - κ * M ^ 2) * M ^ 2

/-- Algebra only. The hypothesis is not a theorem about `B_F`. -/
public theorem cubic_sink_of_corrected_rate
    (rate M C κ : ℝ) (h : CorrectedMaxRate rate M C κ) :
    rate ≤ C * M ^ 2 - κ * M ^ 3 := by
  have hmul : M * (C * M - κ * M ^ 2) = C * M ^ 2 - κ * M ^ 3 := by ring
  simpa [CorrectedMaxRate, hmul] using h

/-- Rate-level gap. A pairing cubic is not subtracted from a rate polynomial. -/
public theorem source_rate_sub_sink (M C κ : ℝ) :
    C * M ^ 2 - (C * M ^ 2 - κ * M ^ 3) = κ * M ^ 3 := by ring

/-- Pairing-level gap. The subtracted term is `κ M⁴`, not `κ M⁵`.
This equality assumes the reduced factor is already on the pairing. -/
public theorem reduced_pairing_gap (M C κ : ℝ) :
    C * M ^ 3 - ((C * M - κ * M ^ 2) * M ^ 2) = κ * M ^ 4 := by ring

/-- Expanding the hypothesized rate gives the sink polynomial.
The subtraction is in the hypothesis `CorrectedMaxRate`, not in `NS_PDE`. -/
public theorem corrected_rate_polynomial (M C κ : ℝ) :
    M * (C * M - κ * M ^ 2) = C * M ^ 2 - κ * M ^ 3 := by ring

/-- The `M⁵` term is the weighted source, not the sink. -/
public theorem weighted_source_polynomial (M C κ : ℝ) :
    C * M ^ 3 * (1 + κ * M ^ 2) = C * M ^ 3 + C * κ * M ^ 5 := by ring

/-- The comparison field factors. Negative above the ceiling is not proved here. -/
public theorem cubic_field_factor (y C κ : ℝ) :
    C * y ^ 2 - κ * y ^ 3 = y ^ 2 * (C - κ * y) := by ring

end Frohmanian.CubicSourceAudit
