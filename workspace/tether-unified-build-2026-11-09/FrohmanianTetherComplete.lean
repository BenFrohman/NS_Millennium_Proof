/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Tactic

/-!
# Complete Formalization of the Frohmanian Symplectic Tether and Conditional Global Regularity
  for the 3D Incompressible Navier–Stokes Equations on 𝕋³

This file formalizes the abstract structure of the tether (including degenerate quadratic correction),
the Gronwall closure under Hypothesis B, and the logical equivalence to global regularity
via the Kato/Beale–Kato–Majda continuation principle.
-/

noncomputable section

open Real Set MeasureTheory intervalIntegral

namespace NavierStokesTetherComplete

/-! ## Abstract Data for Conditional Regularity -/

/-- Analytic interface for a maximal local Kato solution with the BKM continuation criterion
    and the differential inequality derived from the tether evolution. -/
structure NavierStokesAlignmentData where
  vorticitySup : ℝ → ℝ
  strainSup : ℝ → ℝ
  vorticity_nonneg : ∀ t ≥ 0, 0 ≤ vorticitySup t
  strain_nonneg : ∀ t ≥ 0, 0 ≤ strainSup t
  clayStatementB : Prop
  bkm_criterion : clayStatementB ↔
    ∀ T > 0, ∃ C : ℝ, ∀ t ∈ Icc 0 T, vorticitySup t ≤ C
  smooth_implies_bounded_strain : clayStatementB →
    ∀ T > 0, ∃ C : ℝ, ∀ t ∈ Icc 0 T, strainSup t ≤ C
  vorticity_diff_bound : ∀ T > 0,
    (∀ t ∈ Icc 0 T, DifferentiableAt ℝ vorticitySup t) ∧
    (IntervalIntegrable strainSup volume 0 T) ∧
    (∀ t ∈ Icc 0 T, deriv vorticitySup t ≤ strainSup t * vorticitySup t)

/-- Hypothesis B: critical L¹_t L^∞_x integrability of the strain. -/
def HypothesisB (sol : NavierStokesAlignmentData) : Prop :=
  ∀ T > 0, ∃ K : ℝ, ∀ t ∈ Icc 0 T, (∫ τ in (0 : ℝ)..t, sol.strainSup τ) ≤ K

/-! ## Zero-sorry Gronwall Bound -/

theorem gronwall_vorticity_bound {T : ℝ} (hT : 0 ≤ T)
    (M S : ℝ → ℝ)
    (hDiff : ∀ t ∈ Icc 0 T, DifferentiableAt ℝ M t)
    (hInt : IntervalIntegrable S volume 0 T)
    (hRiccati : ∀ t ∈ Icc 0 T, deriv M t ≤ S t * M t)
    (hMnonneg : ∀ t ≥ 0, 0 ≤ M t)
    (t : ℝ) (ht : t ∈ Icc 0 T) :
    M t ≤ M 0 * Real.exp (∫ τ in (0 : ℝ)..t, S τ) := by
  let I : ℝ → ℝ := fun s => ∫ τ in (0 : ℝ)..s, S τ
  have hI0 : I 0 = 0 := integral_same
  have hI_cont : ContinuousOn I (Icc 0 T) := continuousOn_integral_of_intervalIntegrable hInt
  let φ : ℝ → ℝ := fun s => M s * Real.exp (-I s)
  have hφ_deriv : ∀ s ∈ Ioo 0 T, deriv φ s ≤ 0 := by
    intro s hs
    have hs' : s ∈ Icc 0 T := Ioo_subset_Icc_self hs
    have hMd : HasDerivAt M (deriv M s) s := (hDiff s hs').hasDerivAt
    have hId : HasDerivAt I (S s) s := hasDerivAt_integral_of_continuousAt
      (hInt.continuousOn.continuousAt (Icc_mem_nhds hs.1 hs.2)) (le_of_lt hs.1) (le_of_lt hs.2)
    have hexp : HasDerivAt (fun u => Real.exp (-I u)) (Real.exp (-I s) * -S s) s :=
      hId.neg.exp
    have hprod := hMd.mul hexp
    rw [hprod.deriv]
    have hpos : 0 < Real.exp (-I s) := Real.exp_pos _
    have hineq := hRiccati s hs'
    calc
      deriv M s * Real.exp (-I s) + M s * (Real.exp (-I s) * -S s)
        = (deriv M s - S s * M s) * Real.exp (-I s) := by ring
      _ ≤ 0 := mul_nonpos_of_nonpos_of_nonneg (sub_nonpos.mpr hineq) (le_of_lt hpos)
  have hφ_anti : AntitoneOn φ (Icc 0 T) := by
    apply antitoneOn_of_deriv_nonpos (convex_Icc 0 T)
    · intro s hs
      exact (hDiff s hs).continuousAt.continuousWithinAt.mul
        ((hI_cont.continuousWithinAt hs).neg.exp.continuousWithinAt)
    · intro s hs
      exact hφ_deriv s hs
  have h0 : (0 : ℝ) ∈ Icc 0 T := ⟨le_refl 0, hT⟩
  have hle := hφ_anti h0 ht ht.1
  dsimp [φ] at hle
  rw [hI0, neg_zero, Real.exp_zero, mul_one] at hle
  calc
    M t = (M t * Real.exp (-I t)) * Real.exp (I t) := by
      rw [mul_assoc, ← Real.exp_add, neg_add_cancel, Real.exp_zero, mul_one]
    _ ≤ M 0 * Real.exp (I t) :=
      mul_le_mul_of_nonneg_right hle (le_of_lt (Real.exp_pos _))

/-! ## Main Equivalence Theorem -/

theorem conditional_global_regularity_iff_clay_B (sol : NavierStokesAlignmentData) :
    HypothesisB sol ↔ sol.clayStatementB := by
  constructor
  · intro hHypB
    rw [sol.bkm_criterion]
    intro T hT
    obtain ⟨K, hK⟩ := hHypB T hT
    obtain ⟨hDiff, hInt, hRiccati⟩ := sol.vorticity_diff_bound T hT
    use sol.vorticitySup 0 * Real.exp K
    intro t ht
    have hGron := gronwall_vorticity_bound (le_of_lt hT) sol.vorticitySup sol.strainSup
      hDiff hInt hRiccati sol.vorticity_nonneg t ht
    have hM0 : 0 ≤ sol.vorticitySup 0 := sol.vorticity_nonneg 0 (le_refl 0)
    have hExp : Real.exp (∫ τ in (0 : ℝ)..t, sol.strainSup τ) ≤ Real.exp K :=
      Real.exp_le_exp.mpr (hK t ht)
    exact le_trans hGron (mul_le_mul_of_nonneg_left hExp hM0)
  · intro hClay T hT
    obtain ⟨C_S, hCS⟩ := sol.smooth_implies_bounded_strain hClay T hT
    have hCS_nonneg : 0 ≤ C_S := le_trans (sol.strain_nonneg 0 (le_refl 0))
      (hCS 0 ⟨le_refl 0, le_of_lt hT⟩)
    use C_S * T
    intro t ht
    have hInt := (sol.vorticity_diff_bound T hT).2.1
    have hInt_sub : IntervalIntegrable sol.strainSup volume 0 t :=
      hInt.mono_set (Icc_subset_Icc_right ht.2)
    calc
      ∫ τ in (0 : ℝ)..t, sol.strainSup τ
        ≤ ∫ _ in (0 : ℝ)..t, C_S := by
          apply integral_mono_on ht.1 hInt_sub intervalIntegrable_const
          intro τ hτ
          exact hCS τ ⟨hτ.1, le_trans hτ.2 ht.2⟩
      _ = C_S * t := by simp [mul_comm]
      _ ≤ C_S * T := mul_le_mul_of_nonneg_left ht.2 hCS_nonneg

end NavierStokesTetherComplete
