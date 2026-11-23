import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.SpecialFunctions.ExpDeriv
import Mathlib.Analysis.Calculus.MeanValue
import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic
import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus
import Mathlib.LinearAlgebra.CrossProduct
import Mathlib.Tactic

noncomputable section
open Real Set MeasureTheory

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

end FrohmanianTripleArchitecture
