/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import Mathlib
import NS_Millennium_Proof.Modules.ClayStatements
import NS_Millennium_Proof.Modules.AnalyticPipeline
import NS_Millennium_Proof.Semantics

/-!
# Conditional global regularity with the explicit vorticity ceiling, from the single-datum rate

`global_regularity_for_NS` assumes the time-uniform bound `FrohmanianTetherBound` and its
conclusion has no explicit ceiling. This file proves the version closer to the original
Theorem 1.1 of `main.tex`: from the **single-datum** cubic rate (R) `FrohmanianTetherRate (u0 0) ν`
(not the all-data rate, which `TetherRateCounterexample.frohmanian_tether_theorem_hDI_unsatisfiable`
proves unsatisfiable), a Kato witness, the BKM criterion (C) and uniqueness (U), the conclusion of
`global_regularity_for_NS` holds together with the ceiling `M(t) ≤ max (M 0) (C / κ'')`.

Scope (honest): (R) for a given nonzero datum is OPEN; (R), (C), (U) and the witness are proved
jointly satisfiable only at `u0 = 0` (`hypotheses_jointly_satisfiable_at_zero`). This is not a
regularity theorem for Navier–Stokes.
-/

open MeasureTheory NavierStokes3D FrohmanianTether FrohmanianTether.ClayStatements

namespace CeilingFromRate

/-- The single-datum rate (R) yields the single-datum bound (B), with the explicit ceiling
`max (M 0) (C / κ'')` along every physical solution from the datum. -/
theorem frohmanianTetherBound_of_rate (u₀ : VelocityField) (ν : ℝ) (hν : 0 < ν)
    (hR : FrohmanianTetherRate u₀ ν) : FrohmanianTetherBound u₀ ν := by
  intro u p hpde hu0 hphys
  obtain ⟨C, k, hC, hk, hdiff, hDI, hcont, hbdd⟩ := hR u p hν hpde hu0 hphys
  exact ⟨max (vorticity_sup_norm (vorticity (u 0))) (C / k),
    fun τ hτ => AnalyticPipeline.comparison_ode_stability C k hC hk _ hdiff hDI τ hτ,
    hcont, hbdd⟩

/-- **Conditional global regularity with the explicit ceiling** (single-datum rate (R)). -/
theorem conditional_global_regularity_with_ceiling
    (u0 : TimeDependentVelocity) (h_div_free : ∀ t x, div (u0 t) x = 0)
    (h_smooth : GlobalRegularity.IsSmooth (u0 0))
    (h_finite_energy : Integrable (fun x : T3 => ‖u0 0 x‖ ^ 2))
    (ν : ℝ) (h_ν_pos : ν > 0)
    (w : KatoLocalWitness (u0 0) ν)
    (hR : FrohmanianTetherRate (u0 0) ν)
    (hcrit : TetheredLyapunov.PhysicalBKMContinuationCriterionFor (u0 0) ν)
    (huniq : TetheredLyapunov.KatoUniquenessOnExistenceTimes (u0 0) ν w) :
    ∃ u : TimeDependentVelocity,
      (∀ t ≥ (0 : ℝ), GlobalRegularity.IsSmooth (u t)) ∧
      u 0 = u0 0 ∧
      (∀ t ≥ (0 : ℝ), GlobalRegularity.satisfies_NavierStokes u ν) ∧
      (∃ C κ'' : ℝ, 0 < C ∧ 0 < κ'' ∧ ∀ t ≥ (0 : ℝ),
        vorticity_sup_norm (vorticity (u t)) ≤
          max (vorticity_sup_norm (vorticity (u 0))) (C / κ'')) ∧
      (∀ v : TimeDependentVelocity,
        (∀ t ≥ (0 : ℝ), GlobalRegularity.IsSmooth (v t)) →
        v 0 = u0 0 →
        (∀ t ≥ (0 : ℝ), GlobalRegularity.satisfies_NavierStokes v ν) →
        ∀ t ≥ (0 : ℝ), v t = u t) := by
  obtain ⟨u, hs, h0, hns, _, hun⟩ :=
    GlobalRegularity.global_regularity_for_NS u0 h_div_free h_smooth h_finite_energy ν h_ν_pos
      w (frohmanianTetherBound_of_rate (u0 0) ν h_ν_pos hR) hcrit huniq
  obtain ⟨hphys, p, heq⟩ := (GlobalRegularity.satisfies_NavierStokes_iff u ν).1 (hns 0 le_rfl)
  obtain ⟨C, k, hC, hk, hdiff, hDI, _, _⟩ := hR u p h_ν_pos heq h0 hphys
  exact ⟨u, hs, h0, hns, ⟨C, k, hC, hk, fun t ht =>
    AnalyticPipeline.comparison_ode_stability C k hC hk _ hdiff hDI t ht⟩, hun⟩

/-- **Non-vacuity.** Every hypothesis of `conditional_global_regularity_with_ceiling` holds,
simultaneously, for the zero datum. (Satisfiability for any nonzero datum is not known.) -/
theorem hypotheses_jointly_satisfiable_at_zero (ν : ℝ) (_hν : 0 < ν) :
    (∀ (t : ℝ) (x : T3), div ((fun _ : ℝ => (0 : VelocityField)) t) x = 0) ∧
    GlobalRegularity.IsSmooth (0 : VelocityField) ∧
    Integrable (fun x : T3 => ‖(0 : VelocityField) x‖ ^ 2) ∧
    ∃ w : KatoLocalWitness 0 ν,
      FrohmanianTetherRate 0 ν ∧
      TetheredLyapunov.PhysicalBKMContinuationCriterionFor 0 ν ∧
      TetheredLyapunov.KatoUniquenessOnExistenceTimes 0 ν w := by
  refine ⟨fun _ x => div_zero_field x, contDiff_const, by simp, kato_witness_zero ν,
    frohmanianTetherRate_zero ν, ?_, repaired_huniq_at_zero ν (kato_witness_zero ν)⟩
  intro u p _ hu0 _ T hT
  rw [hu0, Tstar_zero_eq_top] at hT
  exact absurd hT.symm (EReal.coe_ne_top T)

/-- The theorem applied at the zero datum (all hypotheses discharged). -/
theorem conditional_global_regularity_with_ceiling_at_zero (ν : ℝ) (hν : 0 < ν) :
    ∃ u : TimeDependentVelocity,
      (∀ t ≥ (0 : ℝ), GlobalRegularity.IsSmooth (u t)) ∧ u 0 = 0 ∧
      (∀ t ≥ (0 : ℝ), GlobalRegularity.satisfies_NavierStokes u ν) ∧
      (∃ C κ'' : ℝ, 0 < C ∧ 0 < κ'' ∧ ∀ t ≥ (0 : ℝ),
        vorticity_sup_norm (vorticity (u t)) ≤
          max (vorticity_sup_norm (vorticity (u 0))) (C / κ'')) ∧
      (∀ v : TimeDependentVelocity,
        (∀ t ≥ (0 : ℝ), GlobalRegularity.IsSmooth (v t)) → v 0 = 0 →
        (∀ t ≥ (0 : ℝ), GlobalRegularity.satisfies_NavierStokes v ν) →
        ∀ t ≥ (0 : ℝ), v t = u t) := by
  obtain ⟨hdiv, hsm, hE, w, hR, hC, hU⟩ := hypotheses_jointly_satisfiable_at_zero ν hν
  exact conditional_global_regularity_with_ceiling (fun _ : ℝ => (0 : VelocityField)) hdiv hsm hE ν hν w hR hC hU

/-- **Theorem 1.1 of `main.tex`.** Type: `NS_Millennium_Proof.Semantics.ConditionalGlobalRegularity.paper_claim`;
obtained only by transport across the Truth Gate lock `ConditionalGlobalRegularity`. -/
theorem theorem_1_1 : NS_Millennium_Proof.Semantics.ConditionalGlobalRegularity.paper_claim :=
  NS_Millennium_Proof.Semantics.ConditionalGlobalRegularity.intended_correspondence.mp
    conditional_global_regularity_with_ceiling

end CeilingFromRate

#print axioms CeilingFromRate.frohmanianTetherBound_of_rate
#print axioms CeilingFromRate.conditional_global_regularity_with_ceiling
#print axioms CeilingFromRate.hypotheses_jointly_satisfiable_at_zero
#print axioms CeilingFromRate.conditional_global_regularity_with_ceiling_at_zero
#print axioms CeilingFromRate.theorem_1_1
