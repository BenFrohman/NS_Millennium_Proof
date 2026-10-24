/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
-- NS_Millennium_Proof/Modules/ClosureBlueprint.lean
public theorem global_regularity_for_NS
    (u0 : TimeDependentVelocity) (ν : ℝ)
    (h_smooth : ContDiff ℝ ⊤ (u0 0))
    (h_div : ∀ x, div (u0 0) x = 0)
    (h_energy : Integrable (fun x => ‖u0 0 x‖ ^ 2))
    (hν : ν > 0)
    (w : KatoLocalWitness (u0 0) ν)
    (hInt : ∀ (v : TimeDependentVelocity) (q : PressureField) (T : ℝ),
      0 < T →
      v 0 = u0 0 → NS_PDE v q ν →
      (∀ t ∈ Set.Icc 0 T, ContDiff ℝ ⊤ (v t)) →
      IsPhysicalNSSolution v →
      IntegrableOn (fun s => ‖v s - (w.u) s‖ ^ 2) (Set.Icc 0 T) ∧
      ∀ t ∈ Set.Icc 0 T, IntegrableOn (fun s => 2 * 1 * ‖v s - (w.u) s‖ ^ 2) (Set.Icc 0 t))
    (huniq_shift : ∀ (t : ℝ) (v : TimeDependentVelocity) (q : PressureField),
      v 0 = u0 0 → NS_PDE v q ν →
      (∀ s ∈ Set.Icc 0 (t + katoRestartTime (u0 0) ν), ContDiff ℝ ⊤ (v s)) →
      IsPhysicalNSSolution v →
      ∀ s ∈ Set.Icc 0 (katoRestartTime (u0 0) ν),
        v (t + s) = (kato_witness_at_slice (u0 0) ν w t).u s)
    (hRiccati : FrohmanianTetherBound (u0 0) ν) :
    ∃ (u : TimeDependentVelocity) (p : PressureField),
      satisfies_NavierStokes u p u0 ν ∧
      (∀ t ≥ 0, ContDiff ℝ ⊤ (u t)) ∧
      (∀ (v : TimeDependentVelocity) (q : PressureField),
        v 0 = u0 0 → NS_PDE v q ν →
        (∀ t ≥ 0, ContDiff ℝ ⊤ (v t)) →
        IsPhysicalNSSolution v →
        ∀ t ≥ 0, v t = u t) := ...
