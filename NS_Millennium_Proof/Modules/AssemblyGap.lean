/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
SPDX-License-Identifier: Apache-2.0
Authors: Benjamin Stanley Frohman
-/

module

public import NS_Millennium_Proof.Modules.CubicSourceCertificate
public import NS_Millennium_Proof.Modules.NS_Equations
public import Mathlib.Tactic.Ring

/-!
# Assembly gap

This file does not discharge `hRiccati`, `global_regularity_for_NS`,
or `frohmanian_tether_theorem`.

`hRiccati` is a label for the package `∃ C κ'' y` with
`y' ≤ C y² - κ'' y³` and `M ≤ y`. The checked input from the unmodified
equation is the cubic source `⟨ω, (ω·∇)u⟩ ≤ C_CZ M³`, hence
`pairing / M ≤ C_CZ M²` when `M > 0`. The continuation code does not
consume that inequality. It unpacks the package and sends it to
`global_regularity`.

`conditional_riccati` expands `CorrectedMaxRate`. `conditional_ceiling`
is the phase line of that hypothesized field. Neither constructs `y`,
neither sets `y(t) = ‖ω(t)‖_∞`, and neither derives
`ω · ((ω · ∇) u) ≤ (C_CZ M - κ M²) M²` from the unmodified vorticity equation.

`unmodified_max_pairing_is_classical_source` is that proved cubic source.
`classical_source_not_reduced_strain` shows it does not imply `ReducedStrain`.
Statement (B) — deriving `ReducedStrain` from the vorticity equation — stays open.
Dropping the `hRiccati` binder is not a proof of it.
-/

namespace Frohmanian.AssemblyGap

open NavierStokes3D CubicSourceAudit

/-- Name of the open package. Not a proof that the package holds. -/
public def hRiccatiName : String := "hRiccati"

/-- The unmodified spatial-maximum pairing is the classical cubic source
`⟨ω, (ω·∇)u⟩ ≤ C_CZ M³`. This is `stretching_inner_le_at_max`. -/
public theorem unmodified_max_pairing_is_classical_source
    (ω u : VelocityField) (x : T3) (C_CZ : ℝ)
    (hu : DifferentiableAt ℝ u x)
    (hCZ : ‖fderiv ℝ u x‖ ≤ C_CZ * vorticity_sup_norm ω)
    (hmax : ‖ω x‖ = vorticity_sup_norm ω) :
    ClassicalStretchingSource
      (inner ℝ (ω x) (convective ω u x))
      (vorticity_sup_norm ω) C_CZ := by
  simpa [ClassicalStretchingSource] using
    stretching_inner_le_at_max ω u x C_CZ hu hCZ hmax

/-- Divide the cubic source by `M > 0`: `pairing / M ≤ C M²`.
This is the checked input. It is not the reduced strain. -/
public theorem classical_max_rate_of_cubic_source
    (pairing M C : ℝ) (hM : 0 < M)
    (h : ClassicalStretchingSource pairing M C) :
    pairing / M ≤ C * M ^ 2 := by
  simp only [ClassicalStretchingSource] at h
  rw [div_le_iff₀ hM]
  have hpow : C * M ^ 2 * M = C * M ^ 3 := by ring
  rw [hpow]
  exact h

/-- The proved cubic source does not imply the reduced pairing.
`pairing = C M³` satisfies `ClassicalStretchingSource` and fails
`ReducedStrain` as soon as `M` and `κ` are positive. -/
public theorem classical_source_not_reduced_strain :
    ∃ pairing M C κ : ℝ,
      0 < M ∧ 0 < κ ∧
        ClassicalStretchingSource pairing M C ∧
        ¬ ReducedStrain pairing M C κ := by
  refine ⟨1, 1, 1, 1, zero_lt_one, zero_lt_one, ?_, ?_⟩
  · simp only [ClassicalStretchingSource]
    exact le_of_eq (show (1 : ℝ) = 1 * 1 ^ 3 by ring)
  · intro h
    simp only [ReducedStrain] at h
    have h0 : (1 * 1 - 1 * 1 ^ 2) * 1 ^ 2 = (0 : ℝ) := by ring
    rw [h0] at h
    exact not_le_of_gt zero_lt_one h

/-- At a positive spatial maximum the unmodified pairing yields the cubic
rate `⟨ω,(ω·∇)u⟩ / M ≤ C_CZ M²`, and nothing stronger. -/
public theorem unmodified_max_rate_of_cubic_source
    (ω u : VelocityField) (x : T3) (C_CZ : ℝ)
    (hu : DifferentiableAt ℝ u x)
    (hCZ : ‖fderiv ℝ u x‖ ≤ C_CZ * vorticity_sup_norm ω)
    (hmax : ‖ω x‖ = vorticity_sup_norm ω)
    (hM : 0 < vorticity_sup_norm ω) :
    inner ℝ (ω x) (convective ω u x) / vorticity_sup_norm ω ≤
      C_CZ * vorticity_sup_norm ω ^ 2 :=
  classical_max_rate_of_cubic_source _ _ _ hM
    (unmodified_max_pairing_is_classical_source ω u x C_CZ hu hCZ hmax)

end Frohmanian.AssemblyGap
