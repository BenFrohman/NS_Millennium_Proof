/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

/-!
# manuscript.lean.IsEnstrophyAccumulation

Machine-checked Lean 4 module.
-/

public def IsEnstrophyAccumulation (u : ℝ → VelocityField) (ω : ℝ → VorticityField)
    (φ : ℝ → T3 → ℝ) : Prop :=
  ∀ t ≥ (0 : ℝ), ∀ x, MaterialDerivative u φ t x = ‖ω t x‖ ^ 2
