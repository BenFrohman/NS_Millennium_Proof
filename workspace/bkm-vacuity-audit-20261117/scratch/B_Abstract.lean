/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import FrohmanianTetherConditional.ClassicalNS
import FrohmanianTetherConditional.FrohmanianTripleArchitectureLifespan
import FrohmanianTetherConditional.FrohmanianTripleArchitecture
import FrohmanianTetherConditional.ClassicalEstimatePieces

open Set MeasureTheory

namespace AbstractAudit

/-! (1) Original `NavierStokesUnifiedData`: `clayStatementB` is provable for EVERY instance,
with no Hypothesis B, so `hypothesisB_implies_clayStatementB` has a trivially true conclusion. -/
open FrohmanianTripleArchitecture in
theorem orig_clay_always (sol : NavierStokesUnifiedData) : sol.clayStatementB := by
  rw [sol.bkm_vorticity_criterion]
  intro T hT
  obtain ⟨_, hVC, _, _⟩ := sol.differential_bounds T hT
  obtain ⟨C, hC⟩ := FrohmanianTripleArchitectureLifespan.primitive_bounded hT hVC
  exact ⟨C, hC⟩

/-- An instance of the original structure with `clayStatementB := 1 = 1` and data that has
nothing to do with any fluid (`vorticitySup t = t²+1`). -/
noncomputable def orig_junk : FrohmanianTripleArchitecture.NavierStokesUnifiedData where
  vorticitySup := fun _ => 0
  enstrophySq := fun _ => 42
  strainSup := fun _ => 0
  vorticity_nonneg := fun _ _ => le_rfl
  clayStatementB := (1 : ℕ) = 1
  bkm_vorticity_criterion := by
    constructor
    · intro _ T _; exact ⟨0, fun t _ => by simp⟩
    · intro _; rfl
  smooth_implies_bounded_strain := fun _ _ _ => ⟨0, fun _ _ => le_rfl⟩
  differential_bounds := fun _ _ =>
    ⟨fun _ _ => differentiableAt_const _, continuousOn_const, continuousOn_const,
      fun _ _ => by simp⟩

/-! (2) Lifespan `NavierStokesUnifiedData`: the BKM field is a field about an arbitrary
real function `vorticitySup`; any global scalar pair satisfies it (no PDE). -/
noncomputable def lifespan_junk : FrohmanianTripleArchitectureLifespan.NavierStokesUnifiedData where
  Tstar := ⊤
  vorticitySup := fun t => Real.exp t
  strainSup := fun _ => 1
  vorticity_nonneg := fun _ _ _ => (Real.exp_pos _).le
  bkm_vorticity_criterion := fun _ => rfl
  differential_bounds := fun _ _ _ =>
    ⟨fun _ _ => Real.differentiableAt_exp, Real.continuous_exp.continuousOn, continuousOn_const,
      fun t _ => by simp [Real.deriv_exp]⟩

/-- In the lifespan structure the "BKM field" is literally `BKMVorticityIntegrable → T⋆ = ⊤`;
so `hypothesisB_implies_clayStatementB` there is Grönwall + that field, nothing more. -/
theorem lifespan_bkm_is_field (sol : FrohmanianTripleArchitectureLifespan.NavierStokesUnifiedData) :
    FrohmanianTripleArchitectureLifespan.BKMVorticityIntegrable sol →
      FrohmanianTripleArchitectureLifespan.clayStatementB sol :=
  sol.bkm_vorticity_criterion

/-! (3) `KatoPonceEnergy`: `HsR = 0` satisfies it (repo's `kp_trivial`), so the Hˢ bound in
`formB_Hs_bound` is `0 ≤ 0 * exp _` for that instance. -/
example : ClassicalNS.KatoPonceEnergy (fun _ _ => 0) 3 0 := ClassicalNS.kp_trivial 3

/-! (4) `not_uniform_rate_sup`: its cited-PDE hypotheses are satisfiable by plain affine
functions (no fluid), so the theorem is not vacuous, but its content is pure algebra. -/
theorem rate_hyps_satisfiable (ν : ℝ) :
    ∃ (M g : ℝ → ℝ → ℝ) (m δ : ℝ → ℝ), (∀ A, 0 < δ A) ∧
      (∀ A, 0 < A → HasDerivWithinAt (M A) (m A) (Set.Ici 0) 0) ∧
      (∀ A, 0 < A → M A 0 = 6 * A) ∧
      (∀ A, 0 < A → HasDerivWithinAt (g A) (6 * A * (A - ν)) (Set.Ici 0) 0) ∧
      (∀ A, 0 < A → ∀ t ∈ Set.Ico 0 (δ A), g A t ≤ M A t) ∧
      (∀ A, 0 < A → g A 0 = M A 0) := by
  refine ⟨fun A t => 6 * A + 6 * A * (A - ν) * t, fun A t => 6 * A + 6 * A * (A - ν) * t,
    fun A => 6 * A * (A - ν), fun _ => 1, fun _ => one_pos, ?_, ?_, ?_, ?_, ?_⟩
  · intro A _
    have := ((hasDerivAt_id (0:ℝ)).const_mul (6 * A * (A - ν))).const_add (6 * A)
    simpa using this.hasDerivWithinAt
  · intro A _; simp
  · intro A _
    have := ((hasDerivAt_id (0:ℝ)).const_mul (6 * A * (A - ν))).const_add (6 * A)
    simpa using this.hasDerivWithinAt
  · intro A _ t _; exact le_rfl
  · intro A _; rfl

end AbstractAudit

#print axioms AbstractAudit.orig_clay_always
#print axioms AbstractAudit.orig_junk
#print axioms AbstractAudit.lifespan_junk
#print axioms AbstractAudit.rate_hyps_satisfiable
