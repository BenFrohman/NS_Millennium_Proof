/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

module

public import NS_Millennium_Proof.Modules.NS_Equations

open NavierStokes3D

namespace AnalyticPipeline

/-- Ceiling hypothesis, stated before any theorem that consumes it.
This is an input. It is not derived from the bracket or the vorticity equation. -/
public abbrev RiccatiCeilingHyp (y : ℝ → ℝ) (C κ'' : ℝ) : Prop :=
  ∀ s ≥ (0 : ℝ), deriv y s ≤ C * (y s) ^ 2 - κ'' * (y s) ^ 3

/-- Differentiability, `RiccatiCeilingHyp`, and continuity of `M`.
The `hDI` package is an existence of `C`, `κ''` with this `Prop`. -/
public abbrev VorticitySupDI (u : ℝ → VelocityField) (C κ'' : ℝ) : Prop :=
  (∀ s ≥ (0 : ℝ),
      DifferentiableAt ℝ (fun τ => vorticity_sup_norm (vorticity (u τ))) s) ∧
    RiccatiCeilingHyp (fun τ => vorticity_sup_norm (vorticity (u τ))) C κ'' ∧
    Continuous fun τ : ℝ => vorticity_sup_norm (vorticity (u τ))

end AnalyticPipeline
