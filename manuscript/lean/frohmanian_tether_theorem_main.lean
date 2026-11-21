/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

-- NS_Millennium_Proof/Modules/ConditionalRegularity.lean

/-!
# manuscript.lean.frohmanian_tether_theorem_main

The analytic conjunct is the comparison ceiling along a classical periodic smooth
solution of the unforced equations. `hDI` is `FrohmanianTetherRate` on
`IsPeriodicSmoothSolution` with force 0. That rate is open. This is not a proof
that a solution exists, and it is not Clay (B) or (D).
-/

public theorem frohmanian_tether_theorem
    (hDI : ∀ u₀ ν, FrohmanianTetherRate u₀ ν) :
  ∃ (𝔗_F : CoadjointOrbit → Functional → Functional → ℝ),
    (∀ F ω,
      FunctionalDerivative KineticEnergyHamiltonian ω =
          velocity_from_vorticity ω →
      (∀ x, div (velocity_from_vorticity ω) x = 0) →
      Integrable (fun y => ‖velocity_from_vorticity ω y‖ ^ 2) →
      TetheredBracket F KineticEnergyHamiltonian ω =
        ClassicalBracket F KineticEnergyHamiltonian ω) ∧
    (∀ (SDiff : Type) [Group SDiff] [MulAction SDiff CoadjointOrbit] (B : CoadjointOrbit → Functional → Functional → ℝ),
      (∀ ω F G, B ω F G = -B ω G F) →
      InvariantUnderCoadjointAction SDiff B →
      DegenerateWRTKineticEnergy B →
      ProducesControllableNegativeFeedback B →
      SaturatesTetherQuadratic B →
      Polarizes B →
      Polarizes TetherKernel →
      ∀ ω F G, B ω F G = 𝔗_F ω F G) ∧
    (∀ (B : CoadjointOrbit → Functional → Functional → ℝ)
      (α : CoadjointOrbit → T3 → ℝ),
      HasTetherKernelDensity B α →
      (∀ ω x, α ω x = canonicalTetherDensity ω x) →
      ∀ ω F G, B ω F G = 𝔗_F ω F G) ∧
    (∀ (u₀ : VelocityField) (ν : ℝ) (u : TimeDependentVelocity) (p : TimeDependentPressure),
      0 < ν →
      IsPeriodicSmoothSolution ν u₀ (fun _ _ => 0) u p →
      ∃ C κ'' : ℝ, 0 < C ∧ 0 < κ'' ∧
        ∀ t ≥ (0 : ℝ),
          vorticity_sup_norm (vorticity (u t)) ≤
            max (vorticity_sup_norm (vorticity (u 0))) (C / κ'')) := ...
