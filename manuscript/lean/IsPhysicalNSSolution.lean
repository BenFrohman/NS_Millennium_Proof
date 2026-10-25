/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
-- NS_Millennium_Proof/Modules/NS_Equations.lean
@[expose] public def IsPhysicalNSSolution (u : TimeDependentVelocity) : Prop :=
  (∀ t ≥ 0, ∀ x, DifferentiableAt ℝ (fun s => u s x) t) ∧
  (∀ t ≥ 0, Continuous (u t)) ∧
  (∀ t ≥ 0, Integrable (fun x => ‖u t x‖ ^ 2)) ∧
  (∀ t ≥ 0, (∫ x, ‖u t x‖ ^ 2 ∂volume) ≤ ∫ x, ‖u 0 x‖ ^ 2 ∂volume) ∧
  (∀ t ≤ 0, u t = u 0)
