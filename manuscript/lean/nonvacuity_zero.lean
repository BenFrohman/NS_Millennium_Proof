/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
-- NS_Millennium_Proof/Modules/ClayStatements.lean
public theorem stepField_not_physical : ¬ IsPhysicalNSSolution stepField := ...
public theorem repaired_huniq_at_zero (ν : ℝ) (w : KatoLocalWitness 0 ν) : ... := ...
public theorem frohmanianTetherBound_zero (ν : ℝ) : FrohmanianTetherBound 0 ν := ...
public theorem frohmanianTetherRate_zero (ν : ℝ) : FrohmanianTetherRate 0 ν := ...

public theorem global_regularity_for_NS_nonvacuous_at_zero (ν : ℝ) (hν : 0 < ν) :
    ∃ (u : TimeDependentVelocity) (p : PressureField),
      GlobalRegularity.satisfies_NavierStokes u p 0 ν ∧
      (∀ t ≥ 0, ContDiff ℝ ⊤ (u t)) ∧
      (∀ (v : TimeDependentVelocity) (q : PressureField),
        v 0 = (0 : TimeDependentVelocity) 0 → NS_PDE v q ν →
        (∀ t ≥ 0, ContDiff ℝ ⊤ (v t)) →
        IsPhysicalNSSolution v →
        ∀ t ≥ 0, v t = u t) := ...
