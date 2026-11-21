/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

/-!
# manuscript.lean.IsPeriodicSmoothSolution

Machine-checked Lean 4 module.
-/

-- Defined in NS_Millennium_Proof/Modules/NS_Equations.lean (namespace NavierStokes3D).
-- `ContDiffOn ℝ (⊤ : ℕ∞)` is the joint smoothness Fefferman (B) and (D) require.
-- `NS_PDE` and `IsPhysicalNSSolution` are not this predicate.

@[expose] public def IsPeriodicSmoothSolution (ν : ℝ) (u₀ : VelocityField)
    (f : ℝ → T3 → EuclideanSpace ℝ (Fin 3))
    (u : TimeDependentVelocity) (p : TimeDependentPressure) : Prop :=
  ContDiffOn ℝ (⊤ : ℕ∞) (fun q : ℝ × T3 => u q.1 q.2) (Set.Ici (0 : ℝ) ×ˢ Set.univ) ∧
  ContDiffOn ℝ (⊤ : ℕ∞) (fun q : ℝ × T3 => p q.1 q.2) (Set.Ici (0 : ℝ) ×ˢ Set.univ) ∧
  navier_stokes_eq_Ici u p ν f ∧
  u 0 = u₀ ∧
  ∀ t ≥ (0 : ℝ), IsZ3Periodic (u t) ∧ IsZ3Periodic (p t)
