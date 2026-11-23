/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import FrohmanianTetherConditional.ClassicalNS

/-! Scratch audit: the decaying shear flow `u = A e^{-4π²t} sin(2π x₂) e₁` (ν = 1) is a genuine
global `NSSolution`; varying the amplitude `A` shows `HypothesisB C⋆` is false for every `C⋆`. -/

open Set MeasureTheory Real
open scoped ContDiff
namespace HypBAudit
open ClassicalNS

noncomputable def c : ℝ := 4 * π ^ 2
noncomputable def a (A : ℝ) (j : Fin 3) (t : ℝ) : ℝ := if j = 0 then A * Real.exp (-c * t) else 0
noncomputable def L : E3 →L[ℝ] ℝ := (2 * π) • EuclideanSpace.proj (1 : Fin 3)

lemma L_apply (x : E3) : L x = 2 * π * x 1 := by simp [L]
lemma L_e (i : Fin 3) : L (e i) = if i = 1 then 2 * π else 0 := by
  rw [L_apply]; by_cases h : i = 1 <;> simp [e, h, EuclideanSpace.single_apply, eq_comm]

lemma hasFDeriv_sin (k : ℝ) (x : E3) :
    HasFDerivAt (fun y : E3 => k * Real.sin (L y)) ((k * Real.cos (L x)) • L) x := by
  have h := (L.hasFDerivAt (x := x)).sin.const_mul k
  convert h using 1; ext v; simp [smul_eq_mul]; ring

lemma hasFDeriv_cos (k : ℝ) (x : E3) :
    HasFDerivAt (fun y : E3 => k * Real.cos (L y)) ((-(k * Real.sin (L x))) • L) x := by
  have h := (L.hasFDerivAt (x := x)).cos.const_mul k
  convert h using 1; ext v; simp [smul_eq_mul]; ring

lemma pd_sin (k : ℝ) (i : Fin 3) :
    pd i (fun y : E3 => k * Real.sin (L y)) =
      fun y => (if i = 1 then 2 * π else 0) * k * Real.cos (L y) := by
  funext x; simp only [pd, (hasFDeriv_sin k x).fderiv, ContinuousLinearMap.smul_apply, L_e,
    smul_eq_mul]; ring

lemma pd_cos (k : ℝ) (i : Fin 3) :
    pd i (fun y : E3 => k * Real.cos (L y)) =
      fun y => -((if i = 1 then 2 * π else 0) * k * Real.sin (L y)) := by
  funext x; simp only [pd, (hasFDeriv_cos k x).fderiv, ContinuousLinearMap.smul_apply, L_e,
    smul_eq_mul]; ring

/-- velocity -/
noncomputable def U (A : ℝ) (t : ℝ) (x : E3) : E3 := (A * Real.exp (-c * t) * Real.sin (L x)) • e 0

lemma comp_U (A t : ℝ) (j : Fin 3) : comp (U A t) j = fun y => a A j t * Real.sin (L y) := by
  funext y; by_cases h : j = 0 <;> simp [comp, U, a, e, h, EuclideanSpace.single_apply, eq_comm]

lemma U_apply (A t : ℝ) (x : E3) (j : Fin 3) : U A t x j = a A j t * Real.sin (L x) := by
  have := congrFun (comp_U A t j) x; simpa [comp] using this

lemma pd_pd (k : ℝ) (i : Fin 3) :
    pd i (pd i (fun y : E3 => k * Real.sin (L y))) =
      fun y => -((if i = 1 then 2 * π else 0) ^ 2 * k * Real.sin (L y)) := by
  rw [pd_sin]
  have : (fun y : E3 => (if i = 1 then 2 * π else 0) * k * Real.cos (L y)) =
      fun y => ((if i = 1 then 2 * π else 0) * k) * Real.cos (L y) := rfl
  rw [this, pd_cos]; funext y; ring

lemma contDiff_U (A t : ℝ) : ContDiff ℝ ∞ (U A t) := by
  unfold U; fun_prop

lemma contDiff_joint (A : ℝ) : ContDiff ℝ ∞ (fun q : ℝ × E3 => U A q.1 q.2) := by
  unfold U; fun_prop

lemma contDiff_joint2 (A : ℝ) :
    ContDiff ℝ ∞ (Function.uncurry fun (q : ℝ × E3) (y : E3) => U A q.1 y) := by
  unfold Function.uncurry U; fun_prop

theorem shear_isNS (A : ℝ) :
    IsClassicalNS 1 (U A 0) (U A) (fun _ _ => 0) ⊤ where
  init := rfl
  periodic_u := by
    intro t _ x i
    have hL : L (x + e i) = L x + (if i = 1 then 2 * π else 0) := by rw [map_add, L_e]
    unfold U; rw [hL]; split_ifs <;> simp [Real.sin_add_two_pi]
  periodic_p := fun _ _ _ _ => rfl
  smooth_u := fun t _ => contDiff_U A t
  smooth_p := fun _ _ => contDiff_const
  jointSmooth_u := (contDiff_joint A).contDiffOn
  jointSmooth_p := contDiffOn_const
  cont_u := (contDiff_joint A).continuous.continuousOn
  cont_grad := by
    have h := (contDiff_joint2 A).fderiv (g := fun q : ℝ × E3 => q.2)
      contDiff_snd (m := ∞) (n := 0) (by simp)
    exact h.continuous.continuousOn
  div_free := by
    intro t _ x
    simp only [divergence, comp_U, Fin.sum_univ_three]
    rw [pd_sin, pd_sin, pd_sin]; simp [a]
  momentum := by
    intro t _ x j
    have hlap : laplacian (U A t) j x = -(4 * π ^ 2 * (a A j t * Real.sin (L x))) := by
      simp only [laplacian, comp_U, Fin.sum_univ_three]
      rw [pd_pd, pd_pd, pd_pd]; simp; ring
    have hadv : advection (U A t) j x = 0 := by
      simp only [advection, comp_U, Fin.sum_univ_three, U_apply]
      rw [pd_sin, pd_sin, pd_sin]; simp [a]
    have hp : pd j (fun _ : E3 => (0:ℝ)) x = 0 := by simp
    simp only [U_apply]
    rw [hlap, hadv, hp]
    by_cases hj : j = 0
    · subst hj
      simp only [a, if_true]
      have h1 := ((((hasDerivAt_id t).const_mul (-c)).exp).const_mul A).mul_const (Real.sin (L x))
      convert h1 using 1
      simp [c]; ring
    · simp only [a, hj, if_false, zero_mul]
      simpa using hasDerivAt_const t (0:ℝ)

noncomputable def shearSol (A : ℝ) : NSSolution 1 (U A 0) where
  visc_pos := one_pos
  Tstar := ⊤
  u := U A
  p := fun _ _ => 0
  isNS := shear_isNS A
  maximal := fun _ _ _ h _ _ => (not_top_lt h).elim

lemma zero_mem_cube : (0 : E3) ∈ cube :=
  ⟨fun _ => 0, fun _ _ => ⟨le_rfl, zero_le_one⟩, by ext; simp⟩

lemma e_norm (i : Fin 3) : ‖e i‖ = 1 := by simp [e]

/-- `‖∇u(t)‖_∞ ≥ 2π |A| e^{-ct}` (at `x = 0`, direction `e₂`). -/
lemma gradLinf_ge (A t : ℝ) : |2 * π * A * Real.exp (-c * t)| ≤ gradLinf (U A t) := by
  have hF : HasFDerivAt (U A t)
      (((A * Real.exp (-c * t) * Real.cos (L 0)) • L).smulRight (e 0)) 0 := by
    exact (hasFDeriv_sin (A * Real.exp (-c * t)) 0).smul_const (e 0)
  have hbdd : BddAbove ((fun x => ‖fderiv ℝ (U A t) x‖) '' cube) :=
    (isCompact_cube.image ((contDiff_U A t).continuous_fderiv (by simp)).norm).bddAbove
  refine le_trans ?_ (le_csSup hbdd ⟨0, zero_mem_cube, rfl⟩)
  show _ ≤ ‖fderiv ℝ (U A t) 0‖
  have h1 := (fderiv ℝ (U A t) 0).le_opNorm (e 1)
  rw [e_norm, mul_one, hF.fderiv] at h1
  rw [hF.fderiv]
  refine le_trans (le_of_eq ?_) h1
  rw [ContinuousLinearMap.smulRight_apply, norm_smul, e_norm, mul_one,
    ContinuousLinearMap.smul_apply, L_e, map_zero, Real.cos_zero, if_pos rfl, smul_eq_mul,
    Real.norm_eq_abs]
  congr 1; ring

/-- **`HypothesisB C⋆` is FALSE for every `C⋆`** (no uniform bound over all data). -/
theorem not_HypothesisB (C_star : ℝ → ℝ) : ¬ HypothesisB C_star := by
  intro hB
  set K : ℝ := |C_star 1| + 1
  set A : ℝ := K * Real.exp c / (2 * π)
  have hπ : 0 < 2 * π := by positivity
  have hle := hB (shearSol A) 1 one_pos
  have hlife : lifeIco (shearSol A).Tstar 1 = Ico 0 1 := by
    ext t; simp [lifeIco, shearSol, Ico]
  have hlow : ∀ t ∈ Ico (0:ℝ) 1, ENNReal.ofReal K ≤ ENNReal.ofReal (gradLinf (U A t)) := by
    intro t ht
    apply ENNReal.ofReal_le_ofReal
    refine le_trans ?_ (le_trans (le_abs_self _) (gradLinf_ge A t))
    have hexp : Real.exp (-c) ≤ Real.exp (-c * t) := by
      apply Real.exp_le_exp.mpr
      have : 0 ≤ c := by unfold c; positivity
      nlinarith [ht.2.le]
    have hK : 0 ≤ K := by positivity
    have : 2 * π * A * Real.exp (-c) = K := by
      simp only [A]; field_simp; rw [mul_assoc, ← Real.exp_add]; simp
    calc K = 2 * π * A * Real.exp (-c) := this.symm
      _ ≤ 2 * π * A * Real.exp (-c * t) := by
        apply mul_le_mul_of_nonneg_left hexp; simp only [A]; positivity
  have hint : ENNReal.ofReal K ≤ gradIntegral (shearSol A) 1 := by
    unfold gradIntegral; rw [hlife]
    calc ENNReal.ofReal K = ∫⁻ _ in Ico (0:ℝ) 1, ENNReal.ofReal K := by simp
      _ ≤ ∫⁻ t in Ico (0:ℝ) 1, ENNReal.ofReal (gradLinf ((shearSol A).u t)) :=
        setLIntegral_mono' measurableSet_Ico hlow
  have := le_trans hint hle
  rcases (ENNReal.ofReal_le_ofReal_iff').1 this with h | h
  · linarith [le_abs_self (C_star 1)]
  · linarith [abs_nonneg (C_star 1)]

end HypBAudit

#print axioms HypBAudit.shear_isNS
#print axioms HypBAudit.not_HypothesisB
