/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
-- NS_Millennium_Proof/Modules/GlobalRegularity.lean
public theorem global_regularity_for_NS
    (u0 : TimeDependentVelocity) (ν : ℝ)
    (h_smooth : ContDiff ℝ ⊤ (u0 0))
    (h_div : ∀ x, div (u0 0) x = 0)
    (h_energy : Integrable (fun x => ‖u0 0 x‖ ^ 2))
    (hν : ν > 0)
    (w : KatoLocalWitness (u0 0) ν)
    (τ : ℝ) (hτ : 0 < τ)
    (hrestart : ∀ t : ℝ, 0 ≤ t → (t : ℝ≥0∞) < Tstar (u0 0) ν →
      ∃ T' ∈ existenceTimes (u0 0) ν, t + τ ≤ T')
    (hRiccati : FrohmanianTetherBound (u0 0) ν)
    (huniq : ∀ T (hT : T ∈ existenceTimes (u0 0) ν) (v : TimeDependentVelocity) (q : PressureField),
      v 0 = u0 0 → NS_PDE v q ν →
      (∀ t ∈ Set.Icc 0 T, ContDiff ℝ ⊤ (v t)) →
      IsPhysicalNSSolution v →
      ∀ t ∈ Set.Icc 0 T, v t = (Classical.choose hT).1 t) :
    ∃ (u : TimeDependentVelocity) (p : PressureField),
      satisfies_NavierStokes u p u0 ν ∧
      (∀ t ≥ 0, ContDiff ℝ ⊤ (u t)) ∧
      (∀ (v : TimeDependentVelocity) (q : PressureField),
        v 0 = u0 0 → NS_PDE v q ν →
        (∀ t ≥ 0, ContDiff ℝ ⊤ (v t)) →
        IsPhysicalNSSolution v →
        ∀ t ≥ 0, v t = u t) := by
  exact TetheredLyapunov.global_regularity_of_restart
    u0 ν h_smooth h_div h_energy hν w τ hτ hrestart hRiccati huniq
