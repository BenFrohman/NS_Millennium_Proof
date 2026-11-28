/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

module

public import NS_Millennium_Proof.Semantics
public import NS_Millennium_Proof.Modules.HighSetDepletionAndBKM

/-!
# Main theorems: conditional reductions, exported only through the semantics lock

Each public theorem here has type exactly the locked `paper_claim` of a lock in
`NS_Millennium_Proof.Semantics` and is proved only as
`intended_correspondence.mp <formal proof>`. The `_formal` theorems are the statements Lean
proves directly; they keep the historical curried argument order.

The assumed envelope is not a differential inequality; the actual compact-interval
differential predicate and its conditional comparison live in `HighSetDepletionAndBKM`.
Every hypothesis (the envelope or closing bound, and periodic BKM continuation) is open and
stays explicit. No unconditional Clay statement is claimed.
-/

@[expose] public section

namespace FrohmanianTether.HighSetDepletionAndBKM

open FrohmanianTether.ClayStatements

/-- Formal side of lock `DirectionCurvatureReduction` (historical curried API). -/
theorem clay_reduces_to_direction_curvature_bound_formal
    (hBKM : ∀ ν > (0 : ℝ), PeriodicBKMContinuation ν) :
    (∀ ν > (0 : ℝ), DirectionCurvatureBound ν) → Clay_B_exact :=
  fun hDCB => clay_B_exact_of_torus_direction_depletion hDCB hBKM

/-- **Main Theorem (conditional reduction), `main.tex` Abstract.** Type:
`NS_Millennium_Proof.Semantics.DirectionCurvatureReduction.paper_claim`. -/
theorem clay_reduces_to_direction_curvature_bound :
    NS_Millennium_Proof.Semantics.DirectionCurvatureReduction.paper_claim :=
  NS_Millennium_Proof.Semantics.DirectionCurvatureReduction.intended_correspondence.mp
    clay_reduces_to_direction_curvature_bound_formal

/-- Formal side of lock `EnvelopeReduction` (historical curried API). -/
theorem clay_reduces_to_uniform_vorticity_envelope_formal
    (hBKM : ∀ ν > (0 : ℝ), PeriodicBKMContinuation ν) :
    (∀ ν > (0 : ℝ), UniformVorticityEnvelopeBound ν) → Clay_B_exact :=
  fun hEnvelope => clay_B_exact_of_torus_direction_depletion hEnvelope hBKM

/-- **Conditional reduction, `docs/VorticityEnvelopeCorrection.tex` §2.** Type:
`NS_Millennium_Proof.Semantics.EnvelopeReduction.paper_claim`. -/
theorem clay_reduces_to_uniform_vorticity_envelope :
    NS_Millennium_Proof.Semantics.EnvelopeReduction.paper_claim :=
  NS_Millennium_Proof.Semantics.EnvelopeReduction.intended_correspondence.mp
    clay_reduces_to_uniform_vorticity_envelope_formal

end FrohmanianTether.HighSetDepletionAndBKM

namespace FrohmanianTether.ClayStatements

/-- **Conditional reduction, `main.tex` §sec:clay.** Type:
`NS_Millennium_Proof.Semantics.PeriodicTetherReduction.paper_claim`. -/
theorem clay_B_exact_of_periodic_tether_bound :
    NS_Millennium_Proof.Semantics.PeriodicTetherReduction.paper_claim :=
  NS_Millennium_Proof.Semantics.PeriodicTetherReduction.intended_correspondence.mp
    clay_B_exact_of_periodic_tether_bound_formal

end FrohmanianTether.ClayStatements

end
