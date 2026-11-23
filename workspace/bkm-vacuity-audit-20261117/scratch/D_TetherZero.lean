/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import FrohmanianTetherConditional.FrohmanianTripleArchitecture

namespace TetherAudit
open FrohmanianTripleArchitecture

/-- `curlGradVar_H` is stated for EVERY functional `H`, so in every `MetriplecticSystem`
the tether term vanishes for ALL `F, G`, not only for the Hamiltonian. -/
theorem tether_always_zero {State V : Type*} [NormedAddCommGroup V] [InnerProductSpace ℝ V]
    (sys : MetriplecticSystem State V) (F G : State → ℝ) (ω : State) :
    tetherMetricCorrection sys.κ (sys.enstrophy ω) (sys.velField ω)
      (sys.curlGradVar F ω) (sys.curlGradVar G ω) = 0 := by
  rw [sys.curlGradVar_H F ω, sys.curlGradVar_H G ω]
  exact tether_degenerate_H _ _ _ _

theorem total_eq_diss {State V : Type*} [NormedAddCommGroup V] [InnerProductSpace ℝ V]
    (sys : MetriplecticSystem State V) (F G : State → ℝ) (ω : State) :
    totalMetriplecticBracket sys F G ω = sys.morrisonDiss F G ω := by
  unfold totalMetriplecticBracket; rw [tether_always_zero, add_zero]

end TetherAudit
#print axioms TetherAudit.tether_always_zero
#print axioms TetherAudit.total_eq_diss
