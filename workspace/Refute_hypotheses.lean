import TetherMayForm.TetheredLyapunov
open Frohman.Tether
def sCut : NSTetherSolution where
  y := fun _ => 0
  y' := fun _ => 0
  SmoothOn := fun T => T < 1
  smoothOn_mono := fun h h' => lt_of_le_of_lt h h'
  smoothOn_zero := by norm_num
  y_zero_nonneg := le_rfl
theorem not_all_BKM : ¬ ∀ s, BKMContinuation s := by
  intro h
  have := h sCut 1 one_pos (fun T' hT' => hT') ⟨0, fun _ _ => le_rfl⟩
  exact lt_irrefl _ this
def sZero : NSTetherSolution where
  y := fun _ => 0
  y' := fun _ => 0
  SmoothOn := fun T => T ≤ 0
  smoothOn_mono := fun h h' => le_trans h h'
  smoothOn_zero := le_rfl
  y_zero_nonneg := le_rfl
theorem not_all_Local : ¬ ∀ s, LocalContinuation s := by
  intro h
  obtain ⟨δ, hδ, h2⟩ := h sZero 0 le_rfl
  exact absurd h2 (by show ¬ (0 + δ ≤ 0); linarith)
noncomputable def sJump : NSTetherSolution where
  y := fun t => if t ≤ 1/2 then 0 else 1
  y' := fun _ => 0
  SmoothOn := fun _ => True
  smoothOn_mono := fun _ _ => trivial
  smoothOn_zero := trivial
  y_zero_nonneg := by norm_num
theorem not_all_Enstrophy (C κ : ℝ) : ¬ ∀ s, NSTetherEnstrophyInequality s C κ := by
  intro h
  obtain ⟨hc, -, -⟩ := h sJump 1 trivial
  have h1 := (hc (1/2) ⟨by norm_num, by norm_num⟩)
  have hseq : Filter.Tendsto (fun n : ℕ => (1/2 : ℝ) + 1/((n:ℝ)+2)) Filter.atTop
      (nhdsWithin (1/2) (Set.Icc 0 1)) := by
    apply tendsto_nhdsWithin_iff.2
    refine ⟨?_, Filter.Eventually.of_forall fun n => ⟨by positivity, ?_⟩⟩
    · simpa using (tendsto_one_div_add_atTop_nhds_zero_nat.comp (Filter.tendsto_add_atTop_nat 1)).const_add (1/2 : ℝ) |>.congr (fun n => by simp only [Function.comp]; push_cast; ring_nf)
    · have : (1:ℝ)/((n:ℝ)+2) ≤ 1/2 := by rw [div_le_div_iff₀ (by positivity) (by norm_num)]; linarith [n.cast_nonneg (α := ℝ)]
      linarith
  have := h1.tendsto.comp hseq
  have hv : ∀ n : ℕ, sJump.y ((1/2 : ℝ) + 1/((n:ℝ)+2)) = 1 := fun n => by
    simp only [sJump]; rw [if_neg]; have : (0:ℝ) < 1/((n:ℝ)+2) := by positivity
    linarith
  simp only [Function.comp_def, hv] at this
  have h0 : sJump.y (1/2) = 0 := by simp [sJump]
  rw [h0] at this
  exact one_ne_zero (tendsto_nhds_unique tendsto_const_nhds this)
#print axioms not_all_BKM
#print axioms not_all_Local
#print axioms not_all_Enstrophy
