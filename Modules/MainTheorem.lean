/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Frohman, Benjamin Stanley
-/
module

public import NS_Millennium_Proof.Modules.HighSetDepletionAndBKM

/-!
# Main theorem: conditional uniform-envelope reduction

The accurately named `clay_reduces_to_uniform_vorticity_envelope` retains the
explicit periodic BKM continuation premise. Historical theorem/assumption names
are preserved. The assumed envelope is not a differential inequality; the actual
compact-interval differential predicate and its conditional comparison live in
`HighSetDepletionAndBKM`. No general PDE estimate is supplied by this reduction.
-/

@[expose] public section

namespace FrohmanianTether.HighSetDepletionAndBKM

open FrohmanianTether.ClayStatements

/-- Historical alias for the assumed uniform envelope, NOT a differential inequality. -/
abbrev DirectionCurvatureBound (ν : ℝ) : Prop := UniformVorticityEnvelopeBound ν

/-- **Main Theorem (proved reduction).** -/
theorem clay_reduces_to_direction_curvature_bound
    (hBKM : ∀ ν > (0 : ℝ), PeriodicBKMContinuation ν) :
    (∀ ν > (0 : ℝ), DirectionCurvatureBound ν) → Clay_B_exact :=
  fun hDCB => clay_B_exact_of_torus_direction_depletion hDCB hBKM

/-- Explicitly named version of the historical conditional reduction. The envelope
and the classical BKM continuation principle remain hypotheses. -/
theorem clay_reduces_to_uniform_vorticity_envelope
    (hBKM : ∀ ν > (0 : ℝ), PeriodicBKMContinuation ν) :
    (∀ ν > (0 : ℝ), UniformVorticityEnvelopeBound ν) → Clay_B_exact :=
  fun hEnvelope => clay_B_exact_of_torus_direction_depletion hEnvelope hBKM

end FrohmanianTether.HighSetDepletionAndBKM

end
