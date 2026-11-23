/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import NS_Millennium_Proof.Modules.Continuation
import NS_Millennium_Proof.Modules.NS_Equations

/-!
# Non-vacuity checks

1. `continuation_hypotheses_consistent`: the five hypotheses of
   `Continuation.global_of_continuation` hold together in a model.
2. For each of (loc), (glue), (cont) and (bd) there is a model in which the other four
   hypotheses hold and the conclusion `∀ T, E T` fails, so that hypothesis cannot be dropped.
   ((mono) holds in all of these models.)
3. `NavierStokes3D.zero_isClassicalSolutionOn` (in `NS_Equations.lean`): the zero field is a
   classical solution, so the solution notion is not empty.
-/

namespace NonVacuity

/-- The five continuation hypotheses for given `E`, `Bd`, as a single predicate. -/
def Hyps (E Bd : ℝ → Prop) : Prop :=
  (∃ T > 0, E T) ∧ (∀ T T', E T → T' ≤ T → E T') ∧ (∀ T, (∀ T' < T, E T') → E T) ∧
    (∀ T, 0 < T → E T → Bd T → ∃ T' > T, E T') ∧ (∀ T, 0 < T → E T → Bd T)

theorem continuation_hypotheses_consistent : Hyps (fun _ => True) (fun _ => True) :=
  ⟨⟨1, one_pos, trivial⟩, fun _ _ _ _ => trivial, fun _ _ => trivial,
    fun T _ _ _ => ⟨T + 1, by linarith, trivial⟩, fun _ _ _ => trivial⟩

private theorem le_of_forall_lt_le_aux {a T : ℝ} (h : ∀ T' < T, T' ≤ a) : T ≤ a := by
  by_contra hT
  push_neg at hT
  have := h ((a + T) / 2) (by linarith)
  linarith

/-- Without (bd): `E T ↔ T ≤ 1`, `Bd T ↔ T < 1`; (loc), (mono), (glue), (cont) hold and
`∀ T, E T` fails. -/
theorem bd_needed :
    (∃ T > (0 : ℝ), T ≤ 1) ∧ (∀ T T' : ℝ, T ≤ 1 → T' ≤ T → T' ≤ 1) ∧
      (∀ T : ℝ, (∀ T' < T, T' ≤ 1) → T ≤ 1) ∧
      (∀ T : ℝ, 0 < T → T ≤ 1 → T < 1 → ∃ T' > T, T' ≤ 1) ∧ ¬ (∀ T : ℝ, T ≤ 1) :=
  ⟨⟨1, one_pos, le_rfl⟩, fun _ _ h h' => h'.trans h, fun _ h => le_of_forall_lt_le_aux h,
    fun T _ _ hB => ⟨(T + 1) / 2, by linarith, by linarith⟩,
    fun h => by have := h 2; norm_num at this⟩

/-- In the model of `bd_needed`, (bd) itself fails at `T = 1`. -/
theorem bd_fails : ¬ (∀ T : ℝ, 0 < T → T ≤ 1 → T < 1) := fun h => by
  have := h 1 one_pos le_rfl
  norm_num at this

/-- Without (cont): `E T ↔ T ≤ 1`, `Bd = True`; (loc), (mono), (glue), (bd) hold and
`∀ T, E T` fails. -/
theorem cont_needed :
    (∃ T > (0 : ℝ), T ≤ 1) ∧ (∀ T T' : ℝ, T ≤ 1 → T' ≤ T → T' ≤ 1) ∧
      (∀ T : ℝ, (∀ T' < T, T' ≤ 1) → T ≤ 1) ∧ (∀ T : ℝ, 0 < T → T ≤ 1 → True) ∧
      ¬ (∀ T : ℝ, T ≤ 1) :=
  ⟨⟨1, one_pos, le_rfl⟩, fun _ _ h h' => h'.trans h, fun _ h => le_of_forall_lt_le_aux h,
    fun _ _ _ => trivial, fun h => by have := h 2; norm_num at this⟩

/-- In the model of `cont_needed`, (cont) itself fails at `T = 1`. -/
theorem cont_fails : ¬ (∀ T : ℝ, 0 < T → T ≤ 1 → True → ∃ T' > T, T' ≤ 1) := fun h => by
  obtain ⟨T', hT', hT'1⟩ := h 1 one_pos le_rfl trivial
  linarith

/-- Without (glue): `E T ↔ T < 1`, `Bd = True`; (loc), (mono), (cont), (bd) hold and
`∀ T, E T` fails. -/
theorem glue_needed :
    (∃ T > (0 : ℝ), T < 1) ∧ (∀ T T' : ℝ, T < 1 → T' ≤ T → T' < 1) ∧
      (∀ T : ℝ, 0 < T → T < 1 → True → ∃ T' > T, T' < 1) ∧ (∀ T : ℝ, 0 < T → T < 1 → True) ∧
      ¬ (∀ T : ℝ, T < 1) :=
  ⟨⟨1 / 2, by norm_num, by norm_num⟩, fun _ _ h h' => lt_of_le_of_lt h' h,
    fun T _ hE _ => ⟨(T + 1) / 2, by linarith, by linarith⟩,
    fun _ _ _ => trivial, fun h => by have := h 1; norm_num at this⟩

/-- In the model of `glue_needed`, (glue) itself fails at `T = 1`. -/
theorem glue_fails : ¬ (∀ T : ℝ, (∀ T' < T, T' < 1) → T < 1) := fun h => by
  have := h 1 fun _ h' => h'
  norm_num at this

/-- Without (loc): `E T ↔ T ≤ 0`, `Bd = True`; (mono), (glue), (cont), (bd) hold and
`∀ T, E T` fails. -/
theorem loc_needed :
    (∀ T T' : ℝ, T ≤ 0 → T' ≤ T → T' ≤ 0) ∧ (∀ T : ℝ, (∀ T' < T, T' ≤ 0) → T ≤ 0) ∧
      (∀ T : ℝ, 0 < T → T ≤ 0 → True → ∃ T' > T, T' ≤ 0) ∧
      (∀ T : ℝ, 0 < T → T ≤ 0 → True) ∧ ¬ (∀ T : ℝ, T ≤ 0) :=
  ⟨fun _ _ h h' => h'.trans h, fun _ h => le_of_forall_lt_le_aux h,
    fun T hT hE _ => absurd hE (not_le.mpr hT), fun _ _ _ => trivial,
    fun h => by have := h 1; norm_num at this⟩

end NonVacuity
