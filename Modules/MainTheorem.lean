/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
module

public import NS_Millennium_Proof.Modules.HighSetDepletionAndBKM
public import NS_Millennium_Proof.Modules.SymplecticConstraint

/-!
# Main Theorem (reduction), synced with `fefferman-clay-navier-stokes` (Mathlib 4 style)
-/

@[expose] public section

namespace FrohmanianTether.HighSetDepletionAndBKM

open FrohmanianTether.ClayStatements Symplectori.SymplecticConstraint

/-- Single named open estimate (`HasDirectionCurvatureCoercivity` / `DirectionCurvatureBound`). OPEN. -/
abbrev HasDirectionCurvatureCoercivity (ν : ℝ) : Prop := PeriodicDirectionDepletionBound ν

abbrev DirectionCurvatureBound (ν : ℝ) : Prop := HasDirectionCurvatureCoercivity ν

/-- Dot-notation projection from `HasDirectionCurvatureCoercivity` to `PeriodicTetherClosingBound`. -/
theorem HasDirectionCurvatureCoercivity.periodicTetherClosingBound {ν : ℝ}
    (h : HasDirectionCurvatureCoercivity ν) : PeriodicTetherClosingBound ν :=
  periodicTetherClosingBound_of_directionDepletion h

/-- Mathlib `conclusion_of_hypothesis` name for the reduction theorem. -/
theorem clay_B_exact_of_hasDirectionCurvatureCoercivity
    (hBKM : ∀ ν > (0 : ℝ), PeriodicBKMContinuation ν)
    (hDCB : ∀ ν > (0 : ℝ), HasDirectionCurvatureCoercivity ν) :
    Clay_B_exact :=
  clay_B_exact_of_torus_direction_depletion hDCB hBKM

/-- **Headline Main Theorem (`clay_reduces_to_direction_curvature_bound`).** -/
theorem clay_reduces_to_direction_curvature_bound
    (hBKM : ∀ ν > (0 : ℝ), PeriodicBKMContinuation ν) :
    (∀ ν > (0 : ℝ), DirectionCurvatureBound ν) → Clay_B_exact :=
  clay_B_exact_of_hasDirectionCurvatureCoercivity hBKM

/-- Mathlib `conclusion_of_hypothesis` alias for `bochner_laplacian_3d_identity`. -/
alias inner_laplacian_eq_laplacian_half_norm_sq_sub_norm_grad_sq := bochner_laplacian_3d_identity

/-- Mathlib `conclusion_of_hypothesis` alias for `polar_pythagoras_3d_sum`. -/
alias norm_polar_grad_sq_eq := polar_pythagoras_3d_sum

/-- Mathlib `conclusion_of_hypothesis` alias for `vorticity_sup_norm_eq_of_isSpatialMax`. -/
alias vorticity_sup_norm_eq_of_attainedSpatialMaximum := vorticity_sup_norm_eq_of_isSpatialMax

end FrohmanianTether.HighSetDepletionAndBKM

end
