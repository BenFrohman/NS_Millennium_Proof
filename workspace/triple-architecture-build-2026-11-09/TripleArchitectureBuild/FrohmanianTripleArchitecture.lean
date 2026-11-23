import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.SpecialFunctions.ExpDeriv
import Mathlib.Analysis.Calculus.Deriv.MeanValue
import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic
import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus
import Mathlib.LinearAlgebra.CrossProduct
import Mathlib.Tactic

/-!
Fixed build copy for audit. Statements identical to pristine.
API adaptations for Mathlib v4.22.0 (79e94a09); see FIXES.md.
-/

noncomputable section
open Real Set Filter MeasureTheory intervalIntegral
open scoped Topology

namespace FrohmanianTripleArchitecture

-------------------------------------------------------------------------------
-- SECTION 1: Orthogonal Projection P^⊥ & Tether Metric Correction
-------------------------------------------------------------------------------

variable {V : Type*} [NormedAddCommGroup V] [InnerProductSpace ℝ V]

/-- L²-orthogonal projection onto span{u}^⊥ -/
def projPerp (u Φ : V) : V := Φ - (inner ℝ Φ u / ‖u‖ ^ 2) • u

@[simp]
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

/-- Symmetric Tether Metric Correction B(F, G) placed in the dissipative sector -/
def tetherMetricCorrection (κ W_ω : ℝ) (u dF dG : V) : ℝ :=
  -κ * W_ω * inner ℝ (projPerp u dF) (projPerp u dG)

theorem tether_degenerate_H (κ W_ω : ℝ) (u dF : V) :
    tetherMetricCorrection κ W_ω u dF u = 0 := by
  unfold tetherMetricCorrection
  rw [projPerp_self, inner_zero_right, mul_zero]

theorem tether_symmetric (κ W_ω : ℝ) (u dF dG : V) :
    tetherMetricCorrection κ W_ω u dF dG = tetherMetricCorrection κ W_ω u dG dF := by
  unfold tetherMetricCorrection
  rw [real_inner_comm]

-------------------------------------------------------------------------------
-- SECTION 2: Metriplectic System & Exact PDE Recovery
-------------------------------------------------------------------------------

/-- Metriplectic System incorporating Skew-Symmetric Poisson & Symmetric Dissipative Sectors -/
structure MetriplecticSystem (State V : Type*) [NormedAddCommGroup V] [InnerProductSpace ℝ V] where
  ν : ℝ
  hν : 0 < ν
  κ : ℝ
  hκ : 0 ≤ κ
  velField : State → V
  enstrophy : State → ℝ
  curlGradVar : ((State → ℝ) → State → V)
  curlGradVar_H : ∀ H : State → ℝ, ∀ ω, curlGradVar H ω = velField ω
  liePoisson : (State → ℝ) → (State → ℝ) → State → ℝ
  lp_skew : ∀ F G ω, liePoisson F G ω = -liePoisson G F ω
  morrisonDiss : (State → ℝ) → (State → ℝ) → State → ℝ
  diss_symm : ∀ F G ω, morrisonDiss F G ω = morrisonDiss G F ω

/-- Total Symmetric Metriplectic Bracket: [F, G]_total = [F, G]_diss + [F, G]_tether -/
def totalMetriplecticBracket (sys : MetriplecticSystem State V) (F G : State → ℝ) (ω : State) : ℝ :=
  sys.morrisonDiss F G ω + tetherMetricCorrection sys.κ (sys.enstrophy ω) (sys.velField ω)
    (sys.curlGradVar F ω) (sys.curlGradVar G ω)

theorem totalMetriplectic_symm (sys : MetriplecticSystem State V) (F G : State → ℝ) (ω : State) :
    totalMetriplecticBracket sys F G ω = totalMetriplecticBracket sys G F ω := by
  unfold totalMetriplecticBracket
  rw [sys.diss_symm, tether_symmetric]

theorem totalMetriplectic_flow_equals_unmodified_NS (sys : MetriplecticSystem State V)
    (H : State → ℝ) (F : State → ℝ) (ω : State) :
    sys.liePoisson F H ω + totalMetriplecticBracket sys F H ω =
    sys.liePoisson F H ω + sys.morrisonDiss F H ω := by
  unfold totalMetriplecticBracket
  rw [sys.curlGradVar_H H ω]
  have h_deg := tether_degenerate_H sys.κ (sys.enstrophy ω) (sys.velField ω) (sys.curlGradVar F ω)
  rw [h_deg, add_zero]

-------------------------------------------------------------------------------
-- SECTION 3: Grönwall Differential Inequality Formalization
-------------------------------------------------------------------------------

/-- Statement identical to pristine; proof body adapted to Mathlib v4.22 APIs. -/
lemma gronwall_differential_bound {Y α : ℝ → ℝ} {T : ℝ} (hT : 0 ≤ T)
    (hY_diff : ∀ t ∈ Icc 0 T, DifferentiableAt ℝ Y t)
    (hα_cont : ContinuousOn α (Icc 0 T))
    (h_ineq : ∀ t ∈ Icc 0 T, deriv Y t ≤ α t * Y t) :
    ∀ t ∈ Icc 0 T, Y t ≤ Y 0 * Real.exp (∫ τ in (0 : ℝ)..t, α τ) := by
  intro t ht
  set I : ℝ → ℝ := fun s => ∫ τ in (0 : ℝ)..s, α τ
  let φ : ℝ → ℝ := fun s => Y s * Real.exp (-I s)
  let φ' : ℝ → ℝ := fun s =>
    deriv Y s * Real.exp (-I s) + Y s * (Real.exp (-I s) * -α s)
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
      exact ((hY_diff s hs).continuousAt.continuousWithinAt).mul hexp
    case deriv =>
      intro s hs
      have hsIoo : s ∈ Ioo 0 T := by simpa [interior_Icc] using hs
      have hsIcc : s ∈ Icc 0 T := Ioo_subset_Icc_self hsIoo
      have hYd : HasDerivAt Y (deriv Y s) s := (hY_diff s hsIcc).hasDerivAt
      have hId : HasDerivAt (fun x => Real.exp (-I x)) (Real.exp (-I s) * -α s) s :=
        (hI_deriv s hsIoo).neg.exp
      exact (hYd.mul hId).hasDerivWithinAt
    case nonpos =>
      intro s hs
      have hsIoo : s ∈ Ioo 0 T := by simpa [interior_Icc] using hs
      have hsIcc : s ∈ Icc 0 T := Ioo_subset_Icc_self hsIoo
      have hineq := h_ineq s hsIcc
      have hpos : 0 < Real.exp (-I s) := Real.exp_pos _
      change φ' s ≤ 0
      dsimp [φ']
      calc deriv Y s * Real.exp (-I s) + Y s * (Real.exp (-I s) * -α s)
          = (deriv Y s - α s * Y s) * Real.exp (-I s) := by ring
        _ ≤ 0 := mul_nonpos_of_nonpos_of_nonneg (sub_nonpos.mpr hineq) (le_of_lt hpos)
  have h0 : (0 : ℝ) ∈ Icc 0 T := ⟨le_refl 0, hT⟩
  have hle : φ t ≤ φ 0 := hφ_anti h0 ht ht.1
  dsimp [φ] at hle
  have hI0 : I 0 = 0 := integral_same
  rw [hI0, neg_zero, Real.exp_zero, mul_one] at hle
  calc Y t = (Y t * Real.exp (-I t)) * Real.exp (I t) := by
        rw [mul_assoc, ← Real.exp_add, neg_add_cancel, Real.exp_zero, mul_one]
    _ ≤ Y 0 * Real.exp (I t) := mul_le_mul_of_nonneg_right hle (le_of_lt (Real.exp_pos _))

-------------------------------------------------------------------------------
-- SECTION 4: Three Regularity Pillars & Three-Way Equivalence
-------------------------------------------------------------------------------

structure NavierStokesUnifiedData where
  vorticitySup : ℝ → ℝ
  enstrophySq : ℝ → ℝ
  strainSup : ℝ → ℝ
  vorticity_nonneg : ∀ t ≥ 0, 0 ≤ vorticitySup t
  clayStatementB : Prop
  bkm_vorticity_criterion : clayStatementB ↔
    ∀ T > 0, ∃ C_ω : ℝ, ∀ t ∈ Icc 0 T, (∫ τ in (0 : ℝ)..t, vorticitySup τ) ≤ C_ω
  smooth_implies_bounded_strain : clayStatementB →
    ∀ T > 0, ∃ C_S : ℝ, ∀ t ∈ Icc 0 T, strainSup t ≤ C_S
  differential_bounds : ∀ T > 0,
    (∀ t ∈ Icc 0 T, DifferentiableAt ℝ vorticitySup t) ∧
    (ContinuousOn vorticitySup (Icc 0 T)) ∧
    (ContinuousOn strainSup (Icc 0 T)) ∧
    (∀ t ∈ Icc 0 T, deriv vorticitySup t ≤ strainSup t * vorticitySup t)

def HypothesisB (sol : NavierStokesUnifiedData) : Prop :=
  ∀ T > 0, ∃ C_star : ℝ, ∀ t ∈ Icc 0 T, (∫ τ in (0 : ℝ)..t, sol.strainSup τ) ≤ C_star

def BKMVorticityIntegrable (sol : NavierStokesUnifiedData) : Prop :=
  ∀ T > 0, ∃ C_ω : ℝ, ∀ t ∈ Icc 0 T, (∫ τ in (0 : ℝ)..t, sol.vorticitySup τ) ≤ C_ω

theorem hypothesisB_implies_clayStatementB (sol : NavierStokesUnifiedData)
    (hHypB : HypothesisB sol) : sol.clayStatementB := by
  rw [sol.bkm_vorticity_criterion]
  intro T hT
  obtain ⟨C_star, hC⟩ := hHypB T hT
  obtain ⟨hDiff, hVortCont, hStrainCont, hRiccati⟩ := sol.differential_bounds T hT
  have hM0 : 0 ≤ sol.vorticitySup 0 := sol.vorticity_nonneg 0 (le_refl 0)
  let M_max := sol.vorticitySup 0 * Real.exp C_star
  use M_max * T
  intro t ht
  have hVortInt : IntervalIntegrable sol.vorticitySup volume 0 t :=
    (hVortCont.mono (Icc_subset_Icc_right ht.2)).intervalIntegrable_of_Icc ht.1
  have h_ptwise : ∀ τ ∈ Icc 0 t, sol.vorticitySup τ ≤ M_max := by
    intro τ hτ
    have hτT : τ ∈ Icc 0 T := ⟨hτ.1, le_trans hτ.2 ht.2⟩
    have hGron := gronwall_differential_bound (le_of_lt hT) hDiff hStrainCont hRiccati τ hτT
    have hIntStrain : IntervalIntegrable sol.strainSup volume 0 τ :=
      (hStrainCont.mono (Icc_subset_Icc_right hτT.2)).intervalIntegrable_of_Icc hτT.1
    have h_int_le : (∫ r in (0 : ℝ)..τ, sol.strainSup r) ≤ C_star := hC τ hτT
    exact le_trans hGron (mul_le_mul_of_nonneg_left (Real.exp_le_exp.mpr h_int_le) hM0)
  have hM_max_nonneg : 0 ≤ M_max := mul_nonneg hM0 (le_of_lt (Real.exp_pos _))
  calc ∫ τ in (0 : ℝ)..t, sol.vorticitySup τ
    ≤ ∫ _ in (0 : ℝ)..t, M_max :=
      integral_mono_on ht.1 hVortInt intervalIntegrable_const h_ptwise
    _ = M_max * t := by simp [mul_comm]
    _ ≤ M_max * T := mul_le_mul_of_nonneg_left ht.2 hM_max_nonneg

theorem three_way_equivalence (sol : NavierStokesUnifiedData) :
    (HypothesisB sol ↔ BKMVorticityIntegrable sol) ∧
    (BKMVorticityIntegrable sol ↔ sol.clayStatementB) := by
  have h_bkm_clay : BKMVorticityIntegrable sol ↔ sol.clayStatementB := sol.bkm_vorticity_criterion.symm
  have h_clay_hypB : sol.clayStatementB → HypothesisB sol := by
    intro hClay T hT
    obtain ⟨C_S, hCS⟩ := sol.smooth_implies_bounded_strain hClay T hT
    have hStrainCont := (sol.differential_bounds T hT).2.2.1
    -- PRISTINE BUG: `nlinarith` from (strainSup 0 ≤ C_S) and (0 ≤ vorticitySup 0)
    -- does NOT imply 0 ≤ C_S (strainSup may be negative; vorticity_nonneg is irrelevant).
    -- Fix without changing the theorem statement: witness (max C_S 0) * T.
    use (max C_S 0) * T
    intro t ht
    have hInt_sub : IntervalIntegrable sol.strainSup volume 0 t :=
      (hStrainCont.mono (Icc_subset_Icc_right ht.2)).intervalIntegrable_of_Icc ht.1
    have hbound : ∀ τ ∈ Icc 0 t, sol.strainSup τ ≤ max C_S 0 := by
      intro τ hτ
      exact le_trans (hCS τ ⟨hτ.1, le_trans hτ.2 ht.2⟩) (le_max_left _ _)
    have hmax_nonneg : 0 ≤ max C_S 0 := le_max_right _ _
    calc ∫ τ in (0 : ℝ)..t, sol.strainSup τ
      ≤ ∫ _ in (0 : ℝ)..t, max C_S 0 :=
        integral_mono_on ht.1 hInt_sub intervalIntegrable_const hbound
      _ = (max C_S 0) * t := by simp [mul_comm]
      _ ≤ (max C_S 0) * T := mul_le_mul_of_nonneg_left ht.2 hmax_nonneg
  constructor
  · constructor
    · intro hHypB
      exact h_bkm_clay.mpr (hypothesisB_implies_clayStatementB sol hHypB)
    · intro hBKM
      exact h_clay_hypB (h_bkm_clay.mp hBKM)
  · exact h_bkm_clay

end FrohmanianTripleArchitecture
