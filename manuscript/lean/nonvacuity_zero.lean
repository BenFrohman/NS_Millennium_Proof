/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

-- NS_Millennium_Proof/Modules/ClayStatements.lean

/-!
# manuscript.lean.nonvacuity_zero

Machine-checked Lean 4 module.
-/

public theorem stepField_not_physical : ¬ IsPhysicalNSSolution stepField := ...
public theorem repaired_huniq_at_zero (ν : ℝ) (w : KatoLocalWitness 0 ν) : ... := ...
public theorem frohmanianTetherBound_zero (ν : ℝ) : FrohmanianTetherBound 0 ν := ...

-- One classical periodic smooth solution. Not `FrohmanianTetherRate 0 ν`,
-- which quantifies over every such solution and is open.
public theorem zero_isPeriodicSmoothSolution (ν : ℝ) :
    IsPeriodicSmoothSolution ν (0 : VelocityField)
      (fun _ _ => (0 : EuclideanSpace ℝ (Fin 3)))
      (fun _ => (0 : VelocityField))
      (fun _ => (0 : PressureField)) := ...

public theorem conditional_regularity_nonvacuous_at_zero (ν : ℝ) (hν : 0 < ν) :
    ∃ (u : TimeDependentVelocity),
      (∀ t ≥ (0 : ℝ), ConditionalRegularity.IsSmooth (u t)) ∧
      (u 0 = 0) ∧
      (∀ t ≥ (0 : ℝ), ConditionalRegularity.satisfies_NavierStokes u ν) ∧
      (∀ t ≥ (0 : ℝ), ConditionalRegularity.vorticity_sup_norm (vorticity (u t)) ≥ 0) ∧
      (∀ v : TimeDependentVelocity,
        (∀ t ≥ (0 : ℝ), ConditionalRegularity.IsSmooth (v t)) →
        v 0 = 0 →
        (∀ t ≥ (0 : ℝ), ConditionalRegularity.satisfies_NavierStokes v ν) →
        ∀ t ≥ (0 : ℝ), v t = u t) := ...
