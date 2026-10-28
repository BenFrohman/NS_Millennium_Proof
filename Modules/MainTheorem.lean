/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
module

public import NS_Millennium_Proof.Modules.HighSetDepletionAndBKM

/-!
# Main Theorem (reduction), synced with `fefferman-clay-navier-stokes`

`clay_reduces_to_direction_curvature_bound`: assuming the classical periodic Beale–Kato–Majda
continuation principle (published theorem, not formalized here, so an explicit hypothesis), the
single named OPEN estimate `DirectionCurvatureBound ν` for all `ν > 0` implies `Clay_B_exact`.
This is a reduction, not a resolution. The converse is NOT proved.
-/

@[expose] public section

namespace FrohmanianTether.HighSetDepletionAndBKM

open FrohmanianTether.ClayStatements

/-- The single named open estimate (conjecture). OPEN. -/
abbrev DirectionCurvatureBound (ν : ℝ) : Prop := PeriodicDirectionDepletionBound ν

/-- **Main Theorem (proved reduction).** -/
theorem clay_reduces_to_direction_curvature_bound
    (hBKM : ∀ ν > (0 : ℝ), PeriodicBKMContinuation ν) :
    (∀ ν > (0 : ℝ), DirectionCurvatureBound ν) → Clay_B_exact :=
  fun hDCB => clay_B_exact_of_torus_direction_depletion hDCB hBKM

end FrohmanianTether.HighSetDepletionAndBKM

end
