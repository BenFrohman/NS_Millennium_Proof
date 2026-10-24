/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
-- NS_Millennium_Proof/Modules/SymplecticTether.lean
public def FrohmanianTetherBound (u₀ : VelocityField) (ν : ℝ) : Prop :=
  ∃ Y : ℝ, ∀ (u : TimeDependentVelocity) (p : PressureField),
    u 0 = u₀ → NS_PDE u p ν → (∀ t ≥ 0, ContDiff ℝ ⊤ (u t)) →
    IsPhysicalNSSolution u →
    Continuous (fun s => vorticity_sup_norm (vorticity (u s))) ∧
    ∀ t ≥ 0, vorticity_sup_norm (vorticity (u t)) ≤ Y
