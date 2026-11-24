/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

import Mathlib
import NS_Millennium_Proof.Modules.ClayStatements
import NS_Millennium_Proof.Modules.AnalyticPipeline
import NS_Millennium_Proof.Semantics

/-!
# Comparison ceiling on a classical periodic smooth solution

If one unforced `IsPeriodicSmoothSolution` has vorticity sup-norm `M` obeying
`M' ≤ C M² − κ'' M³`, then `comparison_ode_stability` gives
`M(t) ≤ max(M(0), C/κ'')`. The differential inequality is an assumption.
This does not produce a solution, and it does not prove Clay (B) or (D).
-/

open MeasureTheory NavierStokes3D FrohmanianTether FrohmanianTether.ClayStatements

namespace CeilingFromRate

/-- Along one classical periodic smooth solution of the unforced equations, the cubic
differential inequality implies the comparison ceiling. -/
theorem classical_vorticity_ceiling
    (ν : ℝ) (hν : 0 < ν)
    (u₀ : VelocityField)
    (u : TimeDependentVelocity) (p : TimeDependentPressure)
    (hsol : IsPeriodicSmoothSolution ν u₀ (fun _ _ => (0 : EuclideanSpace ℝ (Fin 3))) u p)
    (C κ'' : ℝ) (hC : 0 < C) (hκ : 0 < κ'')
    (hdiff : ∀ s ≥ (0 : ℝ),
      DifferentiableAt ℝ (fun τ => vorticity_sup_norm (vorticity (u τ))) s)
    (hDI : ∀ s ≥ (0 : ℝ),
      deriv (fun τ => vorticity_sup_norm (vorticity (u τ))) s ≤
        C * vorticity_sup_norm (vorticity (u s)) ^ 2 -
          κ'' * vorticity_sup_norm (vorticity (u s)) ^ 3) :
    ∀ t ≥ (0 : ℝ),
      vorticity_sup_norm (vorticity (u t)) ≤
        max (vorticity_sup_norm (vorticity (u 0))) (C / κ'') := by
  have _hu0 : u 0 = u₀ := hsol.2.2.2.1
  have _hν : ν ≠ 0 := hν.ne'
  intro t ht
  exact AnalyticPipeline.comparison_ode_stability C κ'' hC hκ _ hdiff hDI t ht

/-- **Theorem 1.1 of `main.tex`.** Type:
`NS_Millennium_Proof.Semantics.ConditionalGlobalRegularity.paper_claim`;
obtained only by transport across the Truth Gate lock `ConditionalGlobalRegularity`. -/
theorem theorem_1_1 : NS_Millennium_Proof.Semantics.ConditionalGlobalRegularity.paper_claim :=
  NS_Millennium_Proof.Semantics.ConditionalGlobalRegularity.intended_correspondence.mp
    classical_vorticity_ceiling

end CeilingFromRate

#print axioms CeilingFromRate.classical_vorticity_ceiling
#print axioms CeilingFromRate.theorem_1_1
