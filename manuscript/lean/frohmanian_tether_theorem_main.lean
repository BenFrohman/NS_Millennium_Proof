/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
-- NS_Millennium_Proof/Modules/GlobalRegularity.lean
public theorem frohmanian_tether_theorem
    (hKato : ∀ (u₀ : VelocityField) (ν : ℝ),
      ContDiff ℝ ⊤ u₀ → (∀ x, div u₀ x = 0) →
      Integrable (fun x => ‖u₀ x‖ ^ 2) → ν > 0 →
      KatoLocalWitness u₀ ν)
    (hDI : ∀ (u₀ : VelocityField) (ν : ℝ), FrohmanianTetherRate u₀ ν) :
    ∃ (𝔗_F : VorticityField → FunctionalOnOrbit → FunctionalOnOrbit → ℝ),
      (∀ F G, 𝔗_F = fun ω => TetherKernel ω F G) →
      (∀ (u0 : TimeDependentVelocity) (ν : ℝ),
        ContDiff ℝ ⊤ (u0 0) →
        (∀ x, div (u0 0) x = 0) →
        Integrable (fun x => ‖u0 0 x‖ ^ 2) →
        ν > 0 →
        ∀ (τ : ℝ), 0 < τ →
        (∀ t : ℝ, 0 ≤ t → (t : ℝ≥0∞) < Tstar (u0 0) ν →
          ∃ T' ∈ existenceTimes (u0 0) ν, t + τ ≤ T') →
        (∀ T (hT : T ∈ existenceTimes (u0 0) ν) (v : TimeDependentVelocity) (q : PressureField),
          v 0 = u0 0 → NS_PDE v q ν →
          (∀ t ∈ Set.Icc 0 T, ContDiff ℝ ⊤ (v t)) →
          IsPhysicalNSSolution v →
          ∀ t ∈ Set.Icc 0 T, v t = (Classical.choose hT).1 t) →
        ∃ (u : TimeDependentVelocity) (p : PressureField),
          NS_PDE u p ν ∧ u 0 = u0 0 ∧
          (∀ t ≥ 0, ContDiff ℝ ⊤ (u t)) ∧
          IsPhysicalNSSolution u ∧
          (∀ t ≥ 0, 0 ≤ vorticity_sup_norm (vorticity (u t))) ∧
          (∀ t ≥ 0, ∀ x, div (u t) x = 0) ∧
          (∀ (v : TimeDependentVelocity) (q : PressureField),
            v 0 = u0 0 → NS_PDE v q ν →
            (∀ t ≥ 0, ContDiff ℝ ⊤ (v t)) →
            IsPhysicalNSSolution v →
            ∀ t ≥ 0, v t = u t)) := ...
