/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import FrohmanianTetherConditional.ClassicalNS
import FrohmanianTetherConditional.FrohmanianTripleArchitectureLifespan
import FrohmanianTetherConditional.FrohmanianTripleArchitecture

/-! Scratch audit (not part of the repo): is `ClassicalNS.BKMCriterion` satisfiable? -/

open Set MeasureTheory
namespace BKMAudit
open ClassicalNS

/-- Non-periodic datum `u₀(x) = x`. -/
def badData : E3 → E3 := fun x => x

lemma e0_ne_zero : e 0 ≠ 0 := by
  intro h
  have := congrArg (fun v : E3 => v 0) h
  simp [e] at this

lemma no_classical_solution_pos {ν : ℝ} {T' : ENNReal} (hT : 0 < T')
    {v : ℝ → E3 → E3} {q : ℝ → E3 → ℝ} (h : IsClassicalNS ν badData v q T') : False := by
  have h0 : (0 : ℝ) ∈ lifespan T' := ⟨le_rfl, by simpa using hT⟩
  have hp := h.periodic_u 0 h0 0 0
  rw [h.init] at hp
  simp [badData] at hp
  exact e0_ne_zero hp

/-- A "maximal solution" with lifespan `T⋆ = 0`: every field holds vacuously. -/
noncomputable def degenerateSol : NSSolution 1 badData where
  visc_pos := one_pos
  Tstar := 0
  u := fun _ => badData
  p := fun _ _ => 0
  isNS :=
    { init := rfl
      periodic_u := fun t ht => absurd ht.2 (by simp)
      periodic_p := fun t ht => absurd ht.2 (by simp)
      smooth_u := fun t ht => absurd ht.2 (by simp)
      smooth_p := fun t ht => absurd ht.2 (by simp)
      jointSmooth_u := by
        have : openLifespan 0 = ∅ := by ext t; simp [openLifespan]
        simp [this]
      jointSmooth_p := by
        have : openLifespan 0 = ∅ := by ext t; simp [openLifespan]
        simp [this]
      cont_u := by
        have : lifespan 0 = ∅ := by ext t; simp [lifespan]
        simp [this]
      cont_grad := by
        have : lifespan 0 = ∅ := by ext t; simp [lifespan]
        simp [this]
      div_free := fun t ht => absurd ht.2 (by simp)
      momentum := fun t ht => absurd ht.2 (by simp) }
  maximal := fun T' v q hT hv _ => no_classical_solution_pos hT hv

/-- **The cited BKM hypothesis, as encoded, is FALSE.** -/
theorem not_BKMCriterion : ¬ BKMCriterion := by
  intro bkm
  have h := bkm degenerateSol (by simp [degenerateSol])
  simp [degenerateSol] at h

/-- Hence every theorem taking `bkm : BKMCriterion` is vacuous; e.g. Clay (B) itself
"follows" from it in one line, with no Hypothesis B. -/
theorem clay_from_false_bkm (bkm : BKMCriterion) : AnalyticBridgeStatement :=
  (not_BKMCriterion bkm).elim

end BKMAudit

#print axioms BKMAudit.not_BKMCriterion
#print axioms BKMAudit.clay_from_false_bkm
