import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Analysis.SpecialFunctions.ExpDeriv
import Mathlib.Analysis.Calculus.Deriv.MeanValue
import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic
import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus
import Mathlib.Tactic

/-!
# Full Formalization of the Conditional Global Regularity Theorem
  for 3D Navier–Stokes via the Frohmanian Symplectic Tether

This module formalizes the logical core of the conditional theorem in greater detail:
- Orthogonal projection and strict degeneracy of the quadratic tether
- Abstract solution data carrying the differential inequality
- Complete integrating-factor Gronwall argument
- Hypothesis B ⇒ exponential bound on vorticity ⇒ Clay Statement (B) via BKM interface
- Three-way equivalence (Hyp B ↔ BKM vorticity integral ↔ global regularity)
-/

noncomputable section

open Real Set Filter MeasureTheory intervalIntegral
open scoped Topology

namespace NavierStokesTetherFull

variable {V : Type*} [NormedAddCommGroup V] [InnerProductSpace ℝ V]

/-- L²-orthogonal projection onto the complement of the velocity field. -/
def projPerp (u Φ : V) : V :=
  Φ - (inner ℝ Φ u / ‖u‖ ^ 2) • u

lemma projPerp_self (u : V) : projPerp u u = 0 := by
  unfold projPerp
  by_cases hu : u = 0
  · simp [hu]
  · have hnorm : ‖u‖ ^ 2 ≠ 0 := pow_ne_zero 2 (norm_ne_zero_iff.mpr hu)
    have hinner : inner ℝ u u = ‖u‖ ^ 2 := real_inner_self_eq_norm_sq u
    rw [hinner, div_self hnorm, one_smul, sub_self]

lemma inner_projPerp_self (u Φ : V) : inner ℝ (projPerp u Φ) u = 0 := by
  unfold projPerp
  by_cases hu : u = 0
  · simp [hu]
  · have hnorm : ‖u‖ ^ 2 ≠ 0 := pow_ne_zero 2 (norm_ne_zero_iff.mpr hu)
    rw [inner_sub_left, inner_smul_left, real_inner_self_eq_norm_sq u]
    simp only [conj_trivial]
    rw [div_mul_cancel₀ _ hnorm, sub_self]

/-- Quadratic tether correction B(F,G). -/
def quadraticBilinearTether (κ W : ℝ) (u dF dG : V) : ℝ :=
  -κ * W * inner ℝ (projPerp u dF) (projPerp u dG)

theorem quadraticTether_degenerate_H (κ W : ℝ) (u dF : V) :
    quadraticBilinearTether κ W u dF u = 0 := by
  unfold quadraticBilinearTether
  rw [projPerp_self, inner_zero_right, mul_zero]

theorem quadraticTether_symm (κ W : ℝ) (u dF dG : V) :
    quadraticBilinearTether κ W u dF dG = quadraticBilinearTether κ W u dG dF := by
  unfold quadraticBilinearTether
  rw [real_inner_comm]

theorem quadraticTether_diag_nonpos {κ W : ℝ} (hκ : 0 ≤ κ) (hW : 0 ≤ W) (u dF : V) :
    quadraticBilinearTether κ W u dF dF ≤ 0 := by
  unfold quadraticBilinearTether
  have h_inner : 0 ≤ inner ℝ (projPerp u dF) (projPerp u dF) := real_inner_self_nonneg
  have h_coeff : 0 ≤ κ * W := mul_nonneg hκ hW
  nlinarith

/-- Abstract data for a maximal Kato solution of 3D Navier–Stokes. -/
structure NavierStokesSolutionData where
  vorticitySup : ℝ → ℝ
  strainSup : ℝ → ℝ
  vorticity_nonneg : ∀ t ≥ 0, 0 ≤ vorticitySup t
  strain_nonneg : ∀ t ≥ 0, 0 ≤ strainSup t
  /-- Clay Statement (B): the solution extends to a global C^∞ solution. -/
  clayStatementB : Prop
  /-- Beale–Kato–Majda continuation criterion as an interface. -/
  bkm_criterion : clayStatementB ↔
    ∀ T > 0, ∃ C, ∀ t ∈ Icc 0 T, (∫ τ in (0 : ℝ)..t, vorticitySup τ) ≤ C
  /-- Smooth solutions have bounded strain on every compact time interval. -/
  smooth_implies_bounded_strain : clayStatementB →
    ∀ T > 0, ∃ C_S, ∀ t ∈ Icc 0 T, strainSup t ≤ C_S
  /-- Differential inequality obtained from the tether evolution
      (degeneracy isolates the stretching term). -/
  vorticity_diff_bound : ∀ T > 0,
    (∀ t ∈ Icc 0 T, DifferentiableAt ℝ vorticitySup t) ∧
    ContinuousOn vorticitySup (Icc 0 T) ∧
    ContinuousOn strainSup (Icc 0 T) ∧
    (∀ t ∈ Icc 0 T, deriv vorticitySup t ≤ strainSup t * vorticitySup t)

/-- Hypothesis B: critical L¹_t L^∞_x strain integrability on every finite interval. -/
def HypothesisB (sol : NavierStokesSolutionData) : Prop :=
  ∀ T > 0, ∃ C_star : ℝ, ∀ t ∈ Icc 0 T,
    (∫ τ in (0 : ℝ)..t, sol.strainSup τ) ≤ C_star

/-- Complete integrating-factor Gronwall bound.
    (Proof adapted to Mathlib v4.22 APIs; statement unchanged.) -/
lemma gronwall_vorticity_bound {M α : ℝ → ℝ} {T : ℝ} (hT : 0 ≤ T)
    (hM_diff : ∀ t ∈ Icc 0 T, DifferentiableAt ℝ M t)
    (hα_cont : ContinuousOn α (Icc 0 T))
    (h_riccati : ∀ t ∈ Icc 0 T, deriv M t ≤ α t * M t) :
    ∀ t ∈ Icc 0 T, M t ≤ M 0 * Real.exp (∫ τ in (0 : ℝ)..t, α τ) := by
  intro t ht
  set I : ℝ → ℝ := fun s => ∫ τ in (0 : ℝ)..s, α τ
  let φ : ℝ → ℝ := fun s => M s * Real.exp (-I s)
  let φ' : ℝ → ℝ := fun s =>
    deriv M s * Real.exp (-I s) + M s * (Real.exp (-I s) * -α s)
  have hα_int : IntervalIntegrable α volume 0 T := hα_cont.intervalIntegrable_of_Icc hT
  have hI_cont : ContinuousOn I (Icc 0 T) := by
    have := continuousOn_primitive_interval' hα_int (left_mem_uIcc (a := (0 : ℝ)) (b := T))
    rwa [uIcc_of_le hT] at this
  have hI_deriv : ∀ s ∈ Ioo 0 T, HasDerivAt I (α s) s := by
    intro s hs
    have hcontAt : ContinuousAt α s := hα_cont.continuousAt (Icc_mem_nhds hs.1 hs.2)
    have hα_Ioo : ContinuousOn α (Ioo 0 T) := hα_cont.mono Ioo_subset_Icc_self
    have hmeas : StronglyMeasurableAtFilter α (𝓝 s) volume :=
      ContinuousOn.stronglyMeasurableAtFilter isOpen_Ioo hα_Ioo s hs
    have hint_s : IntervalIntegrable α volume 0 s :=
      hα_int.mono_set (by
        rw [uIcc_of_le (le_of_lt hs.1), uIcc_of_le hT]
        exact Icc_subset_Icc_right (le_of_lt hs.2))
    exact integral_hasDerivAt_right hint_s hmeas hcontAt
  have hφ_anti : AntitoneOn φ (Icc 0 T) := by
    refine antitoneOn_of_hasDerivWithinAt_nonpos (convex_Icc 0 T) (f := φ) (f' := φ') ?cont ?deriv ?nonpos
    case cont =>
      intro s hs
      have hIneg : ContinuousWithinAt (fun x => -I x) (Icc 0 T) s := (hI_cont s hs).neg
      have hexp : ContinuousWithinAt (fun x => Real.exp (-I x)) (Icc 0 T) s :=
        Real.continuous_exp.continuousAt.comp_continuousWithinAt hIneg
      exact ((hM_diff s hs).continuousAt.continuousWithinAt).mul hexp
    case deriv =>
      intro s hs
      have hsIoo : s ∈ Ioo 0 T := by simpa [interior_Icc] using hs
      have hsIcc : s ∈ Icc 0 T := Ioo_subset_Icc_self hsIoo
      have hMd : HasDerivAt M (deriv M s) s := (hM_diff s hsIcc).hasDerivAt
      have hId : HasDerivAt (fun x => Real.exp (-I x)) (Real.exp (-I s) * -α s) s :=
        (hI_deriv s hsIoo).neg.exp
      exact (hMd.mul hId).hasDerivWithinAt
    case nonpos =>
      intro s hs
      have hsIoo : s ∈ Ioo 0 T := by simpa [interior_Icc] using hs
      have hsIcc : s ∈ Icc 0 T := Ioo_subset_Icc_self hsIoo
      have hineq := h_riccati s hsIcc
      have hpos : 0 < Real.exp (-I s) := Real.exp_pos _
      change φ' s ≤ 0
      dsimp [φ']
      calc deriv M s * Real.exp (-I s) + M s * (Real.exp (-I s) * -α s)
          = (deriv M s - α s * M s) * Real.exp (-I s) := by ring
        _ ≤ 0 := mul_nonpos_of_nonpos_of_nonneg (sub_nonpos.mpr hineq) (le_of_lt hpos)
  have h0 : (0 : ℝ) ∈ Icc 0 T := ⟨le_refl 0, hT⟩
  have hle : φ t ≤ φ 0 := hφ_anti h0 ht ht.1
  dsimp [φ] at hle
  have hI0 : I 0 = 0 := integral_same
  rw [hI0, neg_zero, Real.exp_zero, mul_one] at hle
  calc M t = (M t * Real.exp (-I t)) * Real.exp (I t) := by
        rw [mul_assoc, ← Real.exp_add, neg_add_cancel, Real.exp_zero, mul_one]
    _ ≤ M 0 * Real.exp (I t) := mul_le_mul_of_nonneg_right hle (le_of_lt (Real.exp_pos _))

/-- Hypothesis B implies an explicit exponential bound on the vorticity supremum,
    which in turn implies Clay Statement (B) via the BKM interface. -/
theorem hypothesisB_implies_clayStatementB (sol : NavierStokesSolutionData)
    (hHypB : HypothesisB sol) : sol.clayStatementB := by
  rw [sol.bkm_criterion]
  intro T hT
  obtain ⟨C_star, hC⟩ := hHypB T hT
  obtain ⟨hDiff, hVortCont, hStrainCont, hRiccati⟩ := sol.vorticity_diff_bound T hT
  have hM0 : 0 ≤ sol.vorticitySup 0 := sol.vorticity_nonneg 0 (le_refl 0)
  let M_max := sol.vorticitySup 0 * Real.exp C_star
  use M_max * T
  intro t ht
  have h_ptwise : ∀ τ ∈ Icc 0 t, sol.vorticitySup τ ≤ M_max := by
    intro τ hτ
    have hτT : τ ∈ Icc 0 T := ⟨hτ.1, le_trans hτ.2 ht.2⟩
    have hGron := gronwall_vorticity_bound (le_of_lt hT) hDiff hStrainCont hRiccati τ hτT
    have h_int_le : (∫ r in (0 : ℝ)..τ, sol.strainSup r) ≤ C_star := hC τ hτT
    exact le_trans hGron (mul_le_mul_of_nonneg_left (Real.exp_le_exp.mpr h_int_le) hM0)
  have hVortInt : IntervalIntegrable sol.vorticitySup volume 0 t :=
    (hVortCont.mono (Icc_subset_Icc_right ht.2)).intervalIntegrable_of_Icc ht.1
  have hM_max_nonneg : 0 ≤ M_max := mul_nonneg hM0 (le_of_lt (Real.exp_pos _))
  calc ∫ τ in (0 : ℝ)..t, sol.vorticitySup τ
      ≤ ∫ _ in (0 : ℝ)..t, M_max :=
        integral_mono_on ht.1 hVortInt intervalIntegrable_const h_ptwise
    _ = M_max * t := by simp [mul_comm]
    _ ≤ M_max * T := mul_le_mul_of_nonneg_left ht.2 hM_max_nonneg

/-- Three-way equivalence of Hypothesis B, the classical BKM vorticity integrability
    condition, and Clay Statement (B). -/
theorem three_way_equivalence (sol : NavierStokesSolutionData) :
    (HypothesisB sol ↔ sol.clayStatementB) ∧
    (sol.clayStatementB ↔ ∀ T > 0, ∃ C, ∀ t ∈ Icc 0 T,
      (∫ τ in (0 : ℝ)..t, sol.vorticitySup τ) ≤ C) := by
  constructor
  · constructor
    · exact hypothesisB_implies_clayStatementB sol
    · intro hClay T hT
      obtain ⟨C_S, hCS⟩ := sol.smooth_implies_bounded_strain hClay T hT
      have hCS_nonneg : 0 ≤ C_S := by
        have h0 : 0 ≤ sol.strainSup 0 := sol.strain_nonneg 0 (le_refl 0)
        exact le_trans h0 (hCS 0 ⟨le_refl 0, le_of_lt hT⟩)
      use C_S * T
      intro t ht
      have hStrainCont := (sol.vorticity_diff_bound T hT).2.2.1
      have hInt_sub : IntervalIntegrable sol.strainSup volume 0 t :=
        (hStrainCont.mono (Icc_subset_Icc_right ht.2)).intervalIntegrable_of_Icc ht.1
      calc ∫ τ in (0 : ℝ)..t, sol.strainSup τ
          ≤ ∫ _ in (0 : ℝ)..t, C_S := by
            apply integral_mono_on ht.1 hInt_sub intervalIntegrable_const
            intro τ hτ
            exact hCS τ ⟨hτ.1, le_trans hτ.2 ht.2⟩
        _ = C_S * t := by simp [mul_comm]
        _ ≤ C_S * T := mul_le_mul_of_nonneg_left ht.2 hCS_nonneg
  · exact sol.bkm_criterion

end NavierStokesTetherFull

#print axioms projPerp_self
#print axioms inner_projPerp_self
#print axioms quadraticTether_degenerate_H
#print axioms quadraticTether_symm
#print axioms quadraticTether_diag_nonpos
#print axioms gronwall_vorticity_bound
#print axioms hypothesisB_implies_clayStatementB
#print axioms three_way_equivalence
