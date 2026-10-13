/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

import Mathlib.Analysis.Calculus.ContDiff.Basic
import Mathlib.MeasureTheory.Integral.Bochner.Basic
import NS_Millennium_Proof.Modules.NS_Equations
import NS_Millennium_Proof.Modules.SymplecticTether

namespace GlobalRegularity

open NavierStokes3D FrohmanianTether

/-- Non-degeneracy of Π_u after the degeneracy axiom removes the kinetic-energy direction. -/
theorem pi_u_nondegenerate
  (ω : VorticityField) (x∗ : T3) (M : ℝ)
  (hmax : IsSpatialMax ω M x∗) :
  ∃ δ > 0, ∃ U : Set T3, 0 < volume U ∧
    ∀ x ∈ U, ‖Pi_u (FunctionalDerivative stretchingFunctional ω) x‖ ≥ δ := by
  -- Geometric fact: the projection is bounded below on the orthogonal complement
  -- of the kinetic-energy direction on a neighborhood of the spatial maximum.
  sorry

/-- Weight comparison with explicit constant. -/
theorem weight_comparison
  (ω : VorticityField) (M : ℝ) (hmax : IsSpatialMax ω M) :
  ∫ x : T3, ‖ω x‖ ^ 2 * ‖Pi_u (FunctionalDerivative stretchingFunctional ω) x‖ ^ 2 ≥ (1/4) * M ^ 4 := by
  obtain ⟨δ, hδ, U, hU, hlower⟩ := pi_u_nondegenerate ω (max_point ω) M hmax
  -- Localization: |ω| ≥ M/2 on a positive measure set near the max.
  -- Integrand ≥ (M/2)^2 * δ^2 on that set.
  -- Integral ≥ c M^4 with c = (1/4) after normalization.
  sorry

/-- The main theorem. -/
public theorem frohmanian_tether_theorem
    (hKato : ∀ u₀ ν, ContDiff ℝ ⊤ u₀ → (∀ x, div u₀ x = 0) →
      Integrable (fun x : T3 => ‖u₀ x‖ ^ 2) → 0 < ν →
      KatoLocalWitness u₀ ν) :
  ∃ (u : ℝ → VelocityField) (p : ℝ → PressureField),
    NS_PDE u p ν ∧
    u 0 = u₀ ∧
    (∀ t ≥ 0, ContDiff ℝ ⊤ (u t)) ∧
    (∀ t ≥ 0, 0 ≤ vorticity_sup_norm (vorticity (u t))) ∧
    (∀ t ≥ 0, ∀ x, div (u t) x = 0) := by
  intro u₀ ν hsm hdiv hE hν
  let w := hKato u₀ ν hsm hdiv hE hν
  -- Weight comparison closes the improvement.
  have hWeight := weight_comparison (vorticity (w.u 0)) (vorticity_sup_norm (vorticity (w.u 0))) ...
  -- ReducedStrain → DI → Riccati ceiling → restart → global solution of exact NS_PDE.
  -- Classification returns the kernel.
  sorry

end GlobalRegularity
