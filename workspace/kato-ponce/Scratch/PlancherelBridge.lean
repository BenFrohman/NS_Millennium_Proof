import Scratch.LerayPressure
import Scratch.FourierInvFDeriv
import Mathlib.Analysis.Distribution.SchwartzSpace.Basic
import Mathlib.Analysis.Distribution.TemperateGrowth
import Mathlib.Analysis.Fourier.LpSpace
import Mathlib.Analysis.Distribution.SchwartzSpace.Fourier
import Mathlib.Topology.Sequences
import Mathlib.Analysis.SpecialFunctions.JapaneseBracket
import Mathlib.MeasureTheory.Function.ConvergenceInMeasure
import Mathlib.MeasureTheory.Measure.WithDensity

/-!
# Plancherel bridge: `physicalInv` agrees with the Mathlib `L²` inverse Fourier transform

Mathlib already has Schwartz density in `Lᵖ(μ)` for temperate-growth measures that are
finite on compacts (`SchwartzMap.denseRange_toLpCLM`) and identification of the Schwartz
and `L²` inverse Fourier transforms (`SchwartzMap.toLp_fourierInv_eq`). This file
supplies the missing instances for the Fourier-side weight `μw m`, embeds `Ĥ^m` into
unweighted `L²`, and passes to the limit.

The `L²` inverse Fourier transform is packaged as `l2Inv` so that elaborated
statement types never mention a bare `𝓕⁻`.

Nothing in this file is a `sorry`, a custom axiom, or an `opaque` trick.
-/

open MeasureTheory FourierTransform Real Filter Topology
open scoped ENNReal

set_option autoImplicit false
set_option maxHeartbeats 4000000

noncomputable section
namespace PlancherelBridge

open LerayHeat SobolevHilbert InverseSobolev FourierInvBCF
open LerayPressure hiding two_le_of_three
open FourierInvFDeriv
open SobolevFourier NonlinearHm
open SchwartzMap

/-! ## Temperate growth and compactness of `μw m` -/

lemma toReal_sobW_le (m : ℕ) (ξ : E3) :
    (sobW m ξ).toReal ≤ (m + 1 : ℝ) * FourierEmb.w ξ ^ m := by
  have h := sobW_le_mul_ω_pow m ξ
  have hω : ω ξ ^ m = ENNReal.ofReal (FourierEmb.w ξ ^ m) := ω_pow_eq_ofReal m ξ
  have hw : 0 ≤ FourierEmb.w ξ ^ m := pow_nonneg (FourierEmb.w_pos ξ).le m
  have hC : 0 ≤ (m + 1 : ℝ) := by positivity
  have h' : sobW m ξ ≤ ENNReal.ofReal ((m + 1 : ℝ) * FourierEmb.w ξ ^ m) := by
    rw [hω] at h
    simpa [ENNReal.ofReal_mul hC] using h
  have hfin : ENNReal.ofReal ((m + 1 : ℝ) * FourierEmb.w ξ ^ m) ≠ ⊤ := ENNReal.ofReal_ne_top
  exact ((ENNReal.toReal_le_toReal (ne_top_of_le_ne_top hfin h') hfin).mpr h').trans
    (by simp [ENNReal.toReal_ofReal (mul_nonneg hC hw)])

lemma w_pow_le_mul_one_add_norm (m : ℕ) (ξ : E3) :
    FourierEmb.w ξ ^ m ≤ (1 + 4 * π ^ 2) ^ m * (1 + ‖ξ‖) ^ (2 * m) := by
  have hw : FourierEmb.w ξ = 1 + 4 * π ^ 2 * ‖ξ‖ ^ 2 := by
    unfold FourierEmb.w; ring
  have hπ : 0 ≤ 4 * π ^ 2 := by positivity
  have hξ : ‖ξ‖ ^ 2 ≤ (1 + ‖ξ‖) ^ 2 := by
    have : ‖ξ‖ ≤ 1 + ‖ξ‖ := le_add_of_nonneg_left zero_le_one
    exact pow_le_pow_left₀ (norm_nonneg _) this 2
  have hlin : 1 + 4 * π ^ 2 * ‖ξ‖ ^ 2 ≤ (1 + 4 * π ^ 2) * (1 + ‖ξ‖) ^ 2 := by
    have h1 : (1 : ℝ) ≤ (1 + ‖ξ‖) ^ 2 := by
      nlinarith [sq_nonneg (1 + ‖ξ‖), norm_nonneg ξ]
    have : 4 * π ^ 2 * ‖ξ‖ ^ 2 ≤ (4 * π ^ 2) * (1 + ‖ξ‖) ^ 2 :=
      mul_le_mul_of_nonneg_left hξ hπ
    calc
      1 + 4 * π ^ 2 * ‖ξ‖ ^ 2 ≤ 1 + (4 * π ^ 2) * (1 + ‖ξ‖) ^ 2 := by linarith
      _ ≤ (1 + ‖ξ‖) ^ 2 + (4 * π ^ 2) * (1 + ‖ξ‖) ^ 2 := by linarith
      _ = (1 + 4 * π ^ 2) * (1 + ‖ξ‖) ^ 2 := by ring
  have : FourierEmb.w ξ ≤ (1 + 4 * π ^ 2) * (1 + ‖ξ‖) ^ 2 := by
    simpa [hw] using hlin
  have hbase : 0 ≤ FourierEmb.w ξ := (FourierEmb.w_pos ξ).le
  have hr : 0 ≤ (1 + 4 * π ^ 2) * (1 + ‖ξ‖) ^ 2 := by positivity
  have hpow := pow_le_pow_left₀ hbase this m
  refine hpow.trans ?_
  rw [mul_pow, ← pow_mul]

lemma integrable_weight_neg_pow (m : ℕ) :
    Integrable (fun ξ : E3 => (1 + ‖ξ‖) ^ (-((2 * m + 4 : ℕ) : ℝ))) (μw m) := by
  have hflt : ∀ᵐ ξ ∂volume, sobW m ξ < ⊤ :=
    Filter.Eventually.of_forall (sobW_lt_top m)
  unfold μw
  rw [integrable_withDensity_iff (measurable_sobW m) hflt]
  -- Bound (1+‖ξ‖)^{-(2m+4)} * (sobW ξ).toReal by a multiple of (1+‖ξ‖)^{-4}.
  have hbound : ∀ ξ : E3,
      |(1 + ‖ξ‖) ^ (-((2 * m + 4 : ℕ) : ℝ)) * (sobW m ξ).toReal| ≤
        (m + 1 : ℝ) * (1 + 4 * π ^ 2) ^ m * (1 + ‖ξ‖) ^ (-(4 : ℝ)) := fun ξ => by
    have hnn : 0 ≤ (1 + ‖ξ‖) ^ (-((2 * m + 4 : ℕ) : ℝ)) :=
      Real.rpow_nonneg (by positivity) _
    have hnn' : 0 ≤ (sobW m ξ).toReal := ENNReal.toReal_nonneg
    rw [abs_mul, abs_of_nonneg hnn, abs_of_nonneg hnn']
    have h1 := toReal_sobW_le m ξ
    have h2 := w_pow_le_mul_one_add_norm m ξ
    have hprod : (sobW m ξ).toReal ≤
        (m + 1 : ℝ) * (1 + 4 * π ^ 2) ^ m * (1 + ‖ξ‖) ^ (2 * m) := by
      calc
        (sobW m ξ).toReal ≤ (m + 1 : ℝ) * FourierEmb.w ξ ^ m := h1
        _ ≤ (m + 1 : ℝ) * ((1 + 4 * π ^ 2) ^ m * (1 + ‖ξ‖) ^ (2 * m)) :=
          mul_le_mul_of_nonneg_left h2 (by positivity)
        _ = (m + 1 : ℝ) * (1 + 4 * π ^ 2) ^ m * (1 + ‖ξ‖) ^ (2 * m) := by
          ring
    have hmul := mul_le_mul_of_nonneg_left hprod hnn
    refine hmul.trans ?_
    have hx : 0 < 1 + ‖ξ‖ := by positivity
    have hnat : (1 + ‖ξ‖) ^ (2 * m) = (1 + ‖ξ‖) ^ ((2 * m : ℕ) : ℝ) :=
      (Real.rpow_natCast _ _).symm
    have hpow :
        (1 + ‖ξ‖) ^ (-((2 * m + 4 : ℕ) : ℝ)) * (1 + ‖ξ‖) ^ (2 * m) =
          (1 + ‖ξ‖) ^ (-(4 : ℝ)) := by
      rw [hnat, ← Real.rpow_add hx]
      have hexp : -((2 * m + 4 : ℕ) : ℝ) + ((2 * m : ℕ) : ℝ) = -4 := by
        push_cast; ring
      rw [hexp]
    have hrearr :
        (1 + ‖ξ‖) ^ (-((2 * m + 4 : ℕ) : ℝ)) *
            ((m + 1 : ℝ) * (1 + 4 * π ^ 2) ^ m * (1 + ‖ξ‖) ^ (2 * m)) =
          (m + 1 : ℝ) * (1 + 4 * π ^ 2) ^ m * (1 + ‖ξ‖) ^ (-(4 : ℝ)) := by
      calc
        (1 + ‖ξ‖) ^ (-((2 * m + 4 : ℕ) : ℝ)) *
            ((m + 1 : ℝ) * (1 + 4 * π ^ 2) ^ m * (1 + ‖ξ‖) ^ (2 * m)) =
          ((m + 1 : ℝ) * (1 + 4 * π ^ 2) ^ m) *
            ((1 + ‖ξ‖) ^ (-((2 * m + 4 : ℕ) : ℝ)) * (1 + ‖ξ‖) ^ (2 * m)) := by
          ring
        _ = ((m + 1 : ℝ) * (1 + 4 * π ^ 2) ^ m) * (1 + ‖ξ‖) ^ (-(4 : ℝ)) := by
          rw [hpow]
        _ = (m + 1 : ℝ) * (1 + 4 * π ^ 2) ^ m * (1 + ‖ξ‖) ^ (-(4 : ℝ)) := by
          ring
    exact hrearr.le
  have hint : Integrable (fun ξ : E3 => (1 + ‖ξ‖) ^ (-(4 : ℝ))) volume := by
    have hr : (Module.finrank ℝ E3 : ℝ) < 4 := by
      have hrank : Module.finrank ℝ E3 = 3 :=
        finrank_euclideanSpace_fin (𝕜 := ℝ) (n := 3)
      rw [hrank]
      exact Nat.cast_lt.mpr (by decide : (3 : ℕ) < 4)
    exact integrable_one_add_norm (μ := volume) hr
  have hC : 0 ≤ (m + 1 : ℝ) * (1 + 4 * π ^ 2) ^ m := by positivity
  refine (hint.const_mul ((m + 1 : ℝ) * (1 + 4 * π ^ 2) ^ m)).mono' ?_ ?_
  · exact (Measurable.mul (by fun_prop) (measurable_sobW m).ennreal_toReal).aestronglyMeasurable
  · exact Filter.Eventually.of_forall fun ξ => by
      simpa [Real.norm_eq_abs, mul_comm, mul_left_comm, mul_assoc] using hbound ξ

instance hasTemperateGrowth_μw (m : ℕ) : (μw m).HasTemperateGrowth :=
  ⟨⟨2 * m + 4, integrable_weight_neg_pow m⟩⟩

instance isFiniteMeasureOnCompacts_μw (m : ℕ) : IsFiniteMeasureOnCompacts (μw m) where
  lt_top_of_isCompact := fun {K} hK => by
    have hKmeas : MeasurableSet K := hK.measurableSet
    rw [μw, withDensity_apply (sobW m) hKmeas]
    let f : E3 → ℝ := fun ξ => (m + 1 : ℝ) * FourierEmb.w ξ ^ m
    have hfcont : Continuous f := by
      unfold f FourierEmb.w
      fun_prop
    have himg : IsCompact (f '' K) := hK.image hfcont
    obtain ⟨C, hC⟩ := himg.bddAbove
    have hle : ∀ ξ ∈ K, sobW m ξ ≤ ENNReal.ofReal (f ξ) := fun ξ hξ => by
      have h := sobW_le_mul_ω_pow m ξ
      have hω : ω ξ ^ m = ENNReal.ofReal (FourierEmb.w ξ ^ m) := ω_pow_eq_ofReal m ξ
      have hC0 : 0 ≤ (m + 1 : ℝ) := by positivity
      rw [hω] at h
      simpa [f, ENNReal.ofReal_mul hC0] using h
    have hleC : ∀ ξ ∈ K, sobW m ξ ≤ ENNReal.ofReal C := fun ξ hξ =>
      (hle ξ hξ).trans (ENNReal.ofReal_le_ofReal (hC ⟨ξ, hξ, rfl⟩))
    have hμK : volume K < ⊤ := hK.measure_lt_top
    have hmono : (∫⁻ ξ in K, sobW m ξ ∂volume) ≤ ∫⁻ ξ in K, ENNReal.ofReal C ∂volume :=
      setLIntegral_mono' hKmeas fun ξ hξ => hleC ξ hξ
    have hrhs : ∫⁻ ξ in K, ENNReal.ofReal C ∂volume = ENNReal.ofReal C * volume K :=
      setLIntegral_const K (ENNReal.ofReal C)
    rw [hrhs] at hmono
    exact hmono.trans_lt (ENNReal.mul_lt_top ENNReal.ofReal_lt_top hμK)

/-- Schwartz maps are dense in `Ĥ^m`. -/
theorem denseRange_schwartz_Hm (m : ℕ) :
    DenseRange (SchwartzMap.toLpCLM ℝ V 2 (μw m)) :=
  SchwartzMap.denseRange_toLpCLM (hp := ENNReal.ofNat_ne_top)

/-- Unweighted `L²` class of an `Ĥ^m` representative. -/
def toL2 {m : ℕ} (G : Hm m) : L2V :=
  (memLp_coe_Hm G).toLp _

lemma toL2_coeFn {m : ℕ} (G : Hm m) :
    (toL2 G : E3 → V) =ᵐ[volume] (G : E3 → V) :=
  MemLp.coeFn_toLp _

/-- Mathlib `L²` inverse Fourier transform, packaged so that `𝓕⁻` does not
appear in elaborated statement types. -/
irreducible_def l2Inv (F : L2V) : L2V :=
  (Lp.fourierTransformₗᵢ E3 V).symm F

lemma continuous_l2Inv : Continuous l2Inv := by
  have h : l2Inv = (Lp.fourierTransformₗᵢ E3 V).symm := by
    ext F
    rw [l2Inv]
  rw [h]
  exact (Lp.fourierTransformₗᵢ E3 V).symm.continuous

lemma l2Inv_eq (F : L2V) :
    l2Inv F = (Lp.fourierTransformₗᵢ E3 V).symm F := by
  rw [l2Inv]

lemma norm_toL2_le {m : ℕ} (G : Hm m) : ‖toL2 G‖ ≤ ‖G‖ := by
  have hnorm : ‖toL2 G‖ = (eLpNorm (G : E3 → V) 2 (volume : Measure E3)).toReal := by
    unfold toL2
    exact MemLp.norm_toLp (memLp_coe_Hm G)
  have hle := eLpNorm_coe_Hm_le G
  have hmono :
      (eLpNorm (G : E3 → V) 2 (volume : Measure E3)).toReal ≤
        (ENNReal.ofReal ‖G‖).toReal :=
    ENNReal.toReal_mono ENNReal.ofReal_ne_top hle
  have hnormG : (ENNReal.ofReal ‖G‖).toReal = ‖G‖ :=
    ENNReal.toReal_ofReal (norm_nonneg G)
  exact hnorm.trans_le (hmono.trans_eq hnormG)

lemma toL2_sub {m : ℕ} (G H : Hm m) : toL2 (G - H) = toL2 G - toL2 H := by
  refine Lp.ext ?_
  filter_upwards [toL2_coeFn (G - H), toL2_coeFn G, toL2_coeFn H,
    (Lp.coeFn_sub G H).filter_mono (Measure.AbsolutelyContinuous.ae_le (ac_vol m)),
    Lp.coeFn_sub (toL2 G) (toL2 H)] with
    ξ hGH hG hH hsub hL2
  rw [hGH, hL2, hsub]
  simp only [Pi.sub_apply, hG, hH]

lemma tendsto_toL2 {m : ℕ} {Gs : ℕ → Hm m} {G : Hm m}
    (h : Tendsto Gs atTop (nhds G)) :
    Tendsto (fun n => toL2 (Gs n)) atTop (nhds (toL2 G)) := by
  rw [Metric.tendsto_atTop] at h ⊢
  intro ε hε
  obtain ⟨N, hN⟩ := h ε hε
  refine ⟨N, fun n hn => ?_⟩
  have : dist (toL2 (Gs n)) (toL2 G) = ‖toL2 (Gs n - G)‖ := by
    rw [dist_eq_norm, ← toL2_sub]
  rw [this]
  have hlt : ‖Gs n - G‖ < ε := by
    simpa [dist_eq_norm] using hN n hn
  exact (norm_toL2_le (Gs n - G)).trans_lt hlt

lemma toL2_toLp_schwartz {m : ℕ} (f : 𝓢(E3, V)) :
    toL2 (f.toLp 2 (μw m)) = f.toLp 2 volume := by
  refine MemLp.toLp_congr (memLp_coe_Hm (f.toLp 2 (μw m))) (f.memLp 2 volume) ?_
  have hμ : (f.toLp 2 (μw m) : E3 → V) =ᵐ[μw m] f :=
    SchwartzMap.coeFn_toLp f 2 (μw m)
  have hvolμ : (f.toLp 2 (μw m) : E3 → V) =ᵐ[volume] f :=
    hμ.filter_mono (Measure.AbsolutelyContinuous.ae_le (ac_vol m))
  exact hvolμ

/-- On a Schwartz representative, `physicalInv` agrees a.e. with `l2Inv`. -/
theorem physicalInv_ae_eq_l2Inv_schwartz {m : ℕ} (hm : 2 ≤ m) (f : 𝓢(E3, V)) :
    (physicalInv hm (f.toLp 2 (μw m)) : E3 → V) =ᵐ[volume]
      (l2Inv (toL2 (f.toLp 2 (μw m))) : E3 → V) := by
  have haeμ : (f.toLp 2 (μw m) : E3 → V) =ᵐ[μw m] f :=
    SchwartzMap.coeFn_toLp f 2 (μw m)
  have hae : (f.toLp 2 (μw m) : E3 → V) =ᵐ[volume] f :=
    haeμ.filter_mono (Measure.AbsolutelyContinuous.ae_le (ac_vol m))
  have hpt : ∀ x, physicalInv hm (f.toLp 2 (μw m)) x = 𝓕⁻ (⇑f) x := by
    intro x
    rw [physicalInv, coe_fourierInvBCF]
    exact fourierInv_congr_ae hae x
  have hl2 : l2Inv (toL2 (f.toLp 2 (μw m))) = (𝓕⁻ f).toLp 2 volume := by
    rw [toL2_toLp_schwartz, l2Inv]
    exact SchwartzMap.toLp_fourierInv_eq f
  have hcoe : ((𝓕⁻ f).toLp 2 volume : E3 → V) =ᵐ[volume] ⇑(𝓕⁻ f) :=
    SchwartzMap.coeFn_toLp (𝓕⁻ f) 2 volume
  have hcoe_fun : ⇑(𝓕⁻ f) = 𝓕⁻ (⇑f) :=
    SchwartzMap.fourierInv_coe f
  filter_upwards [hcoe] with x hx
  rw [hpt x, hl2, hx, hcoe_fun]

/-- Inverse Fourier of an `Ĥ^m` representative agrees a.e. with the Mathlib
`L²` inverse Fourier transform of its unweighted class. -/
theorem physicalInv_ae_eq_l2Inv {m : ℕ} (hm : 2 ≤ m) (G : Hm m) :
    (physicalInv hm G : E3 → V) =ᵐ[volume] (l2Inv (toL2 G) : E3 → V) := by
  have hcl : G ∈ closure (Set.range (SchwartzMap.toLpCLM ℝ V 2 (μw m))) := by
    rw [(denseRange_schwartz_Hm m).closure_range]
    exact Set.mem_univ _
  obtain ⟨Gs, hmem, htend⟩ :=
    (mem_closure_iff_seq_limit
      (s := Set.range (SchwartzMap.toLpCLM ℝ V 2 (μw m))) (a := G)).1 hcl
  have hsch : ∀ n, ∃ f : 𝓢(E3, V), f.toLp 2 (μw m) = Gs n := fun n => by
    obtain ⟨f, hf⟩ := Set.mem_range.mp (hmem n)
    refine ⟨f, ?_⟩
    simpa [SchwartzMap.toLpCLM_apply] using hf
  let f : ℕ → 𝓢(E3, V) := fun n => (hsch n).choose
  have hfEq : ∀ n, (f n).toLp 2 (μw m) = Gs n := fun n => (hsch n).choose_spec
  have hpt : ∀ x,
      Tendsto (fun n => physicalInv hm (Gs n) x) atTop (nhds (physicalInv hm G x)) := by
    intro x
    have hBCF : Tendsto (fun n => fourierInvBCF hm (Gs n)) atTop
        (nhds (fourierInvBCF hm G)) :=
      ((isBoundedLinearMap_fourierInvBCF (m := m) hm).continuous.tendsto G).comp htend
    have hnorm :
        Tendsto (fun n => dist (fourierInvBCF hm (Gs n)) (fourierInvBCF hm G)) atTop (nhds 0) := by
      simpa using hBCF.dist (tendsto_const_nhds (x := fourierInvBCF hm G))
    refine Metric.tendsto_atTop.2 fun ε hε => ?_
    obtain ⟨N, hN⟩ := Metric.tendsto_atTop.1 hnorm ε hε
    refine ⟨N, fun n hn => ?_⟩
    have hle : dist (physicalInv hm (Gs n) x) (physicalInv hm G x) ≤
        dist (fourierInvBCF hm (Gs n)) (fourierInvBCF hm G) := by
      rw [dist_eq_norm, dist_eq_norm, physicalInv, physicalInv]
      exact BoundedContinuousFunction.norm_coe_le_norm
        (fourierInvBCF hm (Gs n) - fourierInvBCF hm G) x
    exact (hle.trans_lt (by simpa [dist_zero_right] using hN n hn))
  have hL2 : Tendsto (fun n => l2Inv (toL2 (Gs n))) atTop (nhds (l2Inv (toL2 G))) :=
    (continuous_l2Inv.tendsto (toL2 G)).comp (tendsto_toL2 htend)
  have hIM : TendstoInMeasure (volume : Measure E3)
      (fun n => (l2Inv (toL2 (Gs n)) : E3 → V)) atTop (l2Inv (toL2 G)) :=
    tendstoInMeasure_of_tendsto_Lp hL2
  obtain ⟨φ, hφmono, hφ⟩ := hIM.exists_seq_tendsto_ae
  have hagree : ∀ n,
      (physicalInv hm (Gs n) : E3 → V) =ᵐ[volume]
        (l2Inv (toL2 (Gs n)) : E3 → V) := fun n => by
    have := physicalInv_ae_eq_l2Inv_schwartz hm (f n)
    simpa [hfEq n] using this
  have hagree_all :
      ∀ᵐ x ∂volume, ∀ n, physicalInv hm (Gs n) x =
        (l2Inv (toL2 (Gs n)) : E3 → V) x :=
    (ae_all_iff (μ := volume)).2 hagree
  filter_upwards [hagree_all, hφ] with x hxall hxL2
  refine tendsto_nhds_unique ?_ hxL2
  exact (Tendsto.congr (fun n => hxall (φ n))
    ((hpt x).comp hφmono.tendsto_atTop))

/-- `physicalInv` of an `Ĥ^m` representative lies in unweighted `L²`. -/
theorem memLp_physicalInv {m : ℕ} (hm : 2 ≤ m) (G : Hm m) :
    MemLp (physicalInv hm G) 2 volume :=
  (Lp.memLp (l2Inv (toL2 G))).ae_eq (physicalInv_ae_eq_l2Inv hm G).symm

/-! ## Physical `L²` of first spatial derivatives -/

lemma hasFDerivAt_physicalInv {m : ℕ} (hm : 3 ≤ m) (G : Hm m) (x : E3) :
    HasFDerivAt (physicalInv (two_le_of_three hm) G) (spatFDeriv hm G x) x := by
  have h := hasFDerivAt_fourierInvBCF hm G x
  have hfun :
      (fun y => physicalInv (two_le_of_three hm) G y) =
        fun y => (fourierInvBCF (two_le_of_three hm) G).toFun y := by
    funext y
    rw [physicalInv]
    rfl
  simpa [hfun] using h

lemma fderiv_physicalInv_eq_spatFDeriv {m : ℕ} (hm : 3 ≤ m) (G : Hm m) (x : E3) :
    fderiv ℝ (physicalInv (two_le_of_three hm) G) x = spatFDeriv hm G x :=
  (hasFDerivAt_physicalInv hm G x).fderiv

lemma physicalInv_dH_eq_partial {m : ℕ} (hm : 3 ≤ m) (G : Hm m)
    (j : Fin 3) (x : E3) :
    physicalInv (two_le_pred_of_three hm) (dH (one_le_of_three hm) j G) x =
      fderiv ℝ (physicalInv (two_le_of_three hm) G) x
        (EuclideanSpace.single j (1 : ℝ)) := by
  rw [fderiv_physicalInv_eq_spatFDeriv hm G x, spatFDeriv_apply]
  let v : E3 := EuclideanSpace.single j (1 : ℝ)
  have hsum :
      (∑ i : Fin 3, v i • fourierInvBCF (two_le_pred_of_three hm)
          (dH (one_le_of_three hm) i G) x) =
        v j • fourierInvBCF (two_le_pred_of_three hm)
          (dH (one_le_of_three hm) j G) x := by
    refine Finset.sum_eq_single (s := (Finset.univ : Finset (Fin 3))) j ?_ ?_
    · intro i _ hij
      have hi : v i = 0 := by
        change (EuclideanSpace.single j (1 : ℝ) : E3) i = 0
        simp [PiLp.single_apply, hij]
      rw [hi, zero_smul]
    · intro hj
      exact (hj (Finset.mem_univ j)).elim
  refine Eq.trans ?_ hsum.symm
  have hvj : v j = 1 := by
    change (EuclideanSpace.single j (1 : ℝ) : E3) j = 1
    simp [PiLp.single_apply]
  rw [hvj, one_smul, physicalInv]

/-- Each first partial of `physicalInv` is the inverse Fourier transform of
a `dH` slice, hence lies in unweighted `L²` for `m ≥ 3`. -/
theorem memLp_fderiv_physicalInv {m : ℕ} (hm : 3 ≤ m) (G : Hm m) (j : Fin 3) :
    MemLp (fun x =>
        fderiv ℝ (physicalInv (two_le_of_three hm) G) x
          (EuclideanSpace.single j (1 : ℝ))) 2 volume := by
  have h := memLp_physicalInv (two_le_pred_of_three hm)
    (dH (one_le_of_three hm) j G)
  refine h.ae_eq ?_
  exact Filter.Eventually.of_forall fun x =>
    physicalInv_dH_eq_partial hm G j x

#print axioms PlancherelBridge.denseRange_schwartz_Hm
#print axioms PlancherelBridge.continuous_l2Inv
#print axioms PlancherelBridge.physicalInv_ae_eq_l2Inv
#print axioms PlancherelBridge.memLp_physicalInv
#print axioms PlancherelBridge.memLp_fderiv_physicalInv

end PlancherelBridge
