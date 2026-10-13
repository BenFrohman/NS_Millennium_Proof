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

The transport identity at a point, written and not rewritten, is
`⟨ω, ∂ₜω⟩ + ⟨ω, (u · ∇)ω⟩ = ⟨ω, (ω · ∇)u⟩ + ν ⟨ω, Δω⟩`.
The pairing in `ReducedStrain` is the stretching term `ω · ((ω · ∇) u)`.
At a spatial maximum the proved bound on that pairing is `C_CZ M³`.
`ReducedStrain` replaces it by `(C_CZ M - κ M²) M²`. That replacement is not proved.

`C_CZ` is the Calderón–Zygmund parameter used in `NS_Equations`.
It is not a fixed numerical value in this file.

Do not import this file from `GlobalRegularity`, `TetheredLyapunov`,
`IndependentMajorant`, or the discharge of `hRiccati`.
-/

namespace Frohmanian.CubicSourceAudit

/-- Transport identity at a point. This is the equation. It is not a bound.
`innerDt` is `⟨ω, ∂ₜω⟩`, `transport` is `⟨ω, (u · ∇)ω⟩`,
`pairing` is `⟨ω, (ω · ∇)u⟩`, `viscous` is `ν ⟨ω, Δω⟩`. -/
@[expose] public def TransportIdentity
    (innerDt transport pairing viscous : ℝ) : Prop :=
  innerDt + transport = pairing + viscous

/-- Rate already assumed to carry the strain subtraction `C_CZ M - κ M²`.
Not derived from `ω · ∂ₜω`. -/
public def CorrectedMaxRate (rate M C_CZ κ : ℝ) : Prop :=
  rate ≤ M * (C_CZ * M - κ * M ^ 2)

/-- Classical pairing bound at a spatial maximum: a cubic source.
`C_CZ` is the Calderón–Zygmund parameter. -/
@[expose] public def ClassicalStretchingSource (pairing M C_CZ : ℝ) : Prop :=
  pairing ≤ C_CZ * M ^ 3

/-- Missing identity, recorded and not proved.
`pairing = ω · ((ω · ∇) u)` at a spatial maximum.
The transport identity writes this pairing on the right-hand side.
It does not replace the pairing by `(C_CZ M - κ M²) M²`. -/
@[expose] public def ReducedStrain (pairing M C_CZ κ : ℝ) : Prop :=
  pairing ≤ (C_CZ * M - κ * M ^ 2) * M ^ 2

/-- Algebra only. The hypothesis is not a theorem about `B_F`. -/
public theorem cubic_sink_of_corrected_rate
    (rate M C_CZ κ : ℝ) (h : CorrectedMaxRate rate M C_CZ κ) :
    rate ≤ C_CZ * M ^ 2 - κ * M ^ 3 := by
  have hmul : M * (C_CZ * M - κ * M ^ 2) = C_CZ * M ^ 2 - κ * M ^ 3 := by ring
  simpa [CorrectedMaxRate, hmul] using h

/-- Rate-level gap. -/
public theorem source_rate_sub_sink (M C_CZ κ : ℝ) :
    C_CZ * M ^ 2 - (C_CZ * M ^ 2 - κ * M ^ 3) = κ * M ^ 3 := by ring

/-- Pairing-level gap. The subtracted term is `κ M⁴`. -/
public theorem reduced_pairing_gap (M C_CZ κ : ℝ) :
    C_CZ * M ^ 3 - ((C_CZ * M - κ * M ^ 2) * M ^ 2) = κ * M ^ 4 := by ring

/-- Expanding the hypothesized rate gives the sink polynomial. -/
public theorem corrected_rate_polynomial (M C_CZ κ : ℝ) :
    M * (C_CZ * M - κ * M ^ 2) = C_CZ * M ^ 2 - κ * M ^ 3 := by ring

/-- The `M⁵` term is the weighted source, not the sink. -/
public theorem weighted_source_polynomial (M C_CZ κ : ℝ) :
    C_CZ * M ^ 3 * (1 + κ * M ^ 2) = C_CZ * M ^ 3 + C_CZ * κ * M ^ 5 := by ring

/-- The comparison field factors. -/
public theorem cubic_field_factor (y C_CZ κ : ℝ) :
    C_CZ * y ^ 2 - κ * y ^ 3 = y ^ 2 * (C_CZ - κ * y) := by ring

end Frohmanian.CubicSourceAudit
