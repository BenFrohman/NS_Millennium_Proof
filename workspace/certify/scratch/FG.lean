import FrohmanianTether.ArnoldGeometric
import Mathlib.MeasureTheory.Function.L2Space
import Mathlib.MeasureTheory.Function.ContinuousMapDense
import Mathlib.MeasureTheory.Integral.Prod
import FrohmanianTether.ForMathlib.Projection
import FrohmanianTether.SymplecticTether
import Mathlib.Analysis.SpecialFunctions.SmoothTransition
import Mathlib.Analysis.InnerProductSpace.Calculus
import Mathlib.Analysis.Calculus.Deriv.Abs

open MeasureTheory NavierStokes3D ArnoldGeometric
noncomputable section

namespace FGTest

abbrev L2Field : Type := Lp (EuclideanSpace ℝ (Fin 3)) 2 (MeasureTheory.volume : Measure T3)

def IsRegularVorticity (ω : CoadjointOrbit) : Prop :=
  ∀ i x, DifferentiableAt ℝ (fun y => ω.val y i) x

def IsTestDirection (ε : CoadjointOrbit) : Prop :=
  ContDiff ℝ (⊤ : ℕ∞) ε.val ∧ HasCompactSupport ε.val

theorem IsTestDirection.memLp {ε : CoadjointOrbit} (h : IsTestDirection ε) :
    MemLp ε.val 2 MeasureTheory.volume :=
  h.1.continuous.memLp_of_hasCompactSupport h.2

theorem IsTestDirection.regular {ε : CoadjointOrbit} (h : IsTestDirection ε) :
    IsRegularVorticity ε := by
  intro i x
  have hd : Differentiable ℝ ε.val := h.1.differentiable (by simp)
  exact ((EuclideanSpace.proj i : EuclideanSpace ℝ (Fin 3) →L[ℝ] ℝ).differentiableAt).comp x (hd x)

def testToL2 (ε : CoadjointOrbit) (h : IsTestDirection ε) : L2Field := h.memLp.toLp ε.val

def testFields : Set L2Field := {f | ∃ ε h, testToL2 ε h = f}

def DivFreeL2 : Submodule ℝ L2Field := (Submodule.span ℝ testFields).topologicalClosure

def orbitLine (ω ε : CoadjointOrbit) (hω : IsRegularVorticity ω) (hε : IsRegularVorticity ε)
    (t : ℝ) : CoadjointOrbit :=
  ⟨fun x => ω.val x + t • ε.val x, fun x => orbit_add_smul_div_free ω ε t hω hε x⟩

def IsFunctionalGradient (F : CoadjointOrbit → ℝ) (ω : CoadjointOrbit) (g : L2Field) : Prop :=
  g ∈ DivFreeL2 ∧ ∃ hω : IsRegularVorticity ω, ∀ ε (hε : IsTestDirection ε),
    HasDerivAt (fun t => F (orbitLine ω ε hω hε.regular t)) (inner ℝ g (testToL2 ε hε)) 0

theorem inner_eq_zero_of_forall_test {d : L2Field} (hd : d ∈ DivFreeL2)
    (h : ∀ ε (hε : IsTestDirection ε), inner ℝ d (testToL2 ε hε) = 0) : d = 0 := by
  let K : Submodule ℝ L2Field := LinearMap.ker (innerSL ℝ d).toLinearMap
  have hK : IsClosed (K : Set L2Field) := (innerSL ℝ d).isClosed_ker
  have hS : testFields ⊆ K := by
    rintro f ⟨ε, hε, rfl⟩
    simp [K, h ε hε]
  have hspan : Submodule.span ℝ testFields ≤ K := Submodule.span_le.mpr hS
  have hcl : DivFreeL2 ≤ K := Submodule.topologicalClosure_minimal _ hspan hK
  have : inner ℝ d d = (0:ℝ) := by simpa [K] using hcl hd
  exact inner_self_eq_zero.mp this

theorem isFunctionalGradient_unique {F : CoadjointOrbit → ℝ} {ω : CoadjointOrbit} {g₁ g₂ : L2Field}
    (h₁ : IsFunctionalGradient F ω g₁) (h₂ : IsFunctionalGradient F ω g₂) : g₁ = g₂ := by
  obtain ⟨m₁, hω, d₁⟩ := h₁
  obtain ⟨m₂, hω', d₂⟩ := h₂
  have : g₁ - g₂ = 0 := by
    apply inner_eq_zero_of_forall_test (DivFreeL2.sub_mem m₁ m₂)
    intro ε hε
    have := (d₁ ε hε).unique (d₂ ε hε)
    rw [inner_sub_left, this, sub_self]
  exact sub_eq_zero.mp this

open Classical in
def FunctionalDerivative (F : CoadjointOrbit → ℝ) (ω : CoadjointOrbit) : T3 → EuclideanSpace ℝ (Fin 3) :=
  if h : ∃ g, IsFunctionalGradient F ω g then ⇑(Classical.choose h) else 0

theorem functionalDerivative_eq {F ω g} (h : IsFunctionalGradient F ω g) :
    FunctionalDerivative F ω = ⇑g := by
  have hex : ∃ g, IsFunctionalGradient F ω g := ⟨g, h⟩
  rw [FunctionalDerivative, dif_pos hex, isFunctionalGradient_unique (Classical.choose_spec hex) h]


theorem functionalDerivative_eq_zero_of_not_regular {F ω} (h : ¬ IsRegularVorticity ω) :
    FunctionalDerivative F ω = 0 := by
  rw [FunctionalDerivative, dif_neg]
  rintro ⟨g, -, hω, -⟩
  exact h hω

theorem functionalDerivative_eq_zero_of_not {F ω} (h : ¬ ∃ g, IsFunctionalGradient F ω g) :
    FunctionalDerivative F ω = 0 := by
  rw [FunctionalDerivative, dif_neg h]

theorem IsFunctionalGradient.add {F G : CoadjointOrbit → ℝ} {ω a b}
    (hF : IsFunctionalGradient F ω a) (hG : IsFunctionalGradient G ω b) :
    IsFunctionalGradient (fun η => F η + G η) ω (a + b) := by
  obtain ⟨ma, hω, da⟩ := hF
  obtain ⟨mb, hω', db⟩ := hG
  refine ⟨DivFreeL2.add_mem ma mb, hω, fun ε hε => ?_⟩
  rw [inner_add_left]
  exact (da ε hε).add (db ε hε)

theorem IsFunctionalGradient.sub {F G : CoadjointOrbit → ℝ} {ω a b}
    (hF : IsFunctionalGradient F ω a) (hG : IsFunctionalGradient G ω b) :
    IsFunctionalGradient (fun η => F η - G η) ω (a - b) := by
  obtain ⟨ma, hω, da⟩ := hF
  obtain ⟨mb, hω', db⟩ := hG
  refine ⟨DivFreeL2.sub_mem ma mb, hω, fun ε hε => ?_⟩
  rw [inner_sub_left]
  exact (da ε hε).sub (db ε hε)

theorem IsRegularVorticity.continuous {ω : CoadjointOrbit} (h : IsRegularVorticity ω) :
    Continuous ω.val := by
  have hc : ∀ i, Continuous (fun y => ω.val y i) := fun i =>
    continuous_iff_continuousAt.2 fun x => (h i x).continuousAt
  have : ω.val = fun y => (WithLp.equiv 2 _).symm (fun i => ω.val y i) := by
    funext y; rfl
  rw [this]
  exact (PiLp.continuous_toLp 2 _).comp (continuous_pi hc)

/-- The linear test functional `ω ↦ ∫ ⟨ω, φ⟩`. -/
def linFun (φ : CoadjointOrbit) : CoadjointOrbit → ℝ :=
  fun η => ∫ x, inner ℝ (η.val x) (φ.val x)

theorem integrable_inner_test {f : T3 → EuclideanSpace ℝ (Fin 3)} (hf : Continuous f)
    {φ : CoadjointOrbit} (hφ : IsTestDirection φ) :
    Integrable (fun x => inner ℝ (f x) (φ.val x)) := by
  apply Continuous.integrable_of_hasCompactSupport (hf.inner hφ.1.continuous)
  exact hφ.2.mono (fun x hx => by
    intro h0
    apply hx
    simp [h0])

theorem inner_testToL2 (φ ε : CoadjointOrbit) (hφ : IsTestDirection φ) (hε : IsTestDirection ε) :
    inner ℝ (testToL2 φ hφ) (testToL2 ε hε) = ∫ x, inner ℝ (φ.val x) (ε.val x) := by
  rw [L2.inner_def]
  apply integral_congr_ae
  filter_upwards [hφ.memLp.coeFn_toLp, hε.memLp.coeFn_toLp] with x h1 h2
  simp only [testToL2] at *
  rw [h1, h2]

theorem linFun_gradient {ω : CoadjointOrbit} (hω : IsRegularVorticity ω) (φ : CoadjointOrbit)
    (hφ : IsTestDirection φ) : IsFunctionalGradient (linFun φ) ω (testToL2 φ hφ) := by
  refine ⟨Submodule.le_topologicalClosure _ (Submodule.subset_span ⟨φ, hφ, rfl⟩), hω, ?_⟩
  intro ε hε
  have h1 := integrable_inner_test hω.continuous hφ
  have h2 := integrable_inner_test hε.regular.continuous hφ
  have hline : (fun t => linFun φ (orbitLine ω ε hω hε.regular t)) =
      fun t => (∫ x, inner ℝ (ω.val x) (φ.val x)) + t * ∫ x, inner ℝ (ε.val x) (φ.val x) := by
    funext t
    simp only [linFun, orbitLine, inner_add_left, inner_smul_left, RCLike.conj_to_real]
    rw [integral_add h1 (h2.const_mul t), integral_const_mul]
  rw [hline, inner_testToL2, show (∫ x, inner ℝ (φ.val x) (ε.val x)) =
      ∫ x, inner ℝ (ε.val x) (φ.val x) from by simp_rw [real_inner_comm]]
  simpa using ((hasDerivAt_id (0:ℝ)).mul_const (∫ x, inner ℝ (ε.val x) (φ.val x))).const_add
    (∫ x, inner ℝ (ω.val x) (φ.val x))


theorem continuous_cross : Continuous (fun p : EuclideanSpace ℝ (Fin 3) × EuclideanSpace ℝ (Fin 3) =>
    cross p.1 p.2) := by
  show Continuous fun p : EuclideanSpace ℝ (Fin 3) × EuclideanSpace ℝ (Fin 3) =>
    WithLp.toLp 2 (crossProduct (WithLp.ofLp p.1) (WithLp.ofLp p.2))
  apply (PiLp.continuous_toLp 2 _).comp
  apply continuous_pi
  intro i
  fin_cases i <;> simp [cross_apply] <;> fun_prop

theorem biotSavartKernel_eq (x y : T3) :
    biotSavartKernel x y = if x = y then 0 else (4 * Real.pi)⁻¹ * ‖x - y‖ ^ (-(3 : ℝ)) := by
  by_cases h : x = y
  · subst h; simp
  · rw [if_neg h, biotSavartKernel_of_ne h]

theorem stronglyMeasurable_biotSavart {f : T3 → EuclideanSpace ℝ (Fin 3)} (hf : Continuous f) :
    StronglyMeasurable (BiotSavart f) := by
  have hK : Measurable (fun p : T3 × T3 => biotSavartKernel p.1 p.2) := by
    simp_rw [biotSavartKernel_eq]
    refine Measurable.ite ?_ measurable_const ?_
    · exact measurableSet_diagonal
    · exact measurable_const.mul ((measurable_fst.sub measurable_snd).norm.pow_const _)
  have hC : Measurable (fun p : T3 × T3 => cross (f p.2) (p.1 - p.2)) :=
    (continuous_cross.comp ((hf.comp continuous_snd).prodMk
      (continuous_fst.sub continuous_snd))).measurable
  have hF : StronglyMeasurable (fun p : T3 × T3 =>
      biotSavartKernel p.1 p.2 • cross (f p.2) (p.1 - p.2)) := (hK.smul hC).stronglyMeasurable
  have := MeasureTheory.StronglyMeasurable.integral_prod_right' (ν := (MeasureTheory.volume : Measure T3)) hF
  have he : BiotSavart f = fun x => ∫ y, biotSavartKernel x y • cross (f y) (x - y) := by
    funext x; exact BiotSavart_apply f x
  rw [he]
  exact this


open ForMathlib in
theorem pi_u_L2 {u : T3 → EuclideanSpace ℝ (Fin 3)} (hu : AEStronglyMeasurable u MeasureTheory.volume) :
    ∃ (U : L2Field) (ℓ : L2Field → ℝ), (∀ v w, ℓ (v + w) = ℓ v + ℓ w) ∧
      ∀ v : L2Field, Pi_u u ⇑v =ᵐ[MeasureTheory.volume] ⇑(v - ℓ v • U) := by
  by_cases hN : (∫ y, ‖u y‖ ^ 2 ∂MeasureTheory.volume) = 0
  · refine ⟨0, fun _ => 0, fun _ _ => by simp, fun v => ?_⟩
    simp only [smul_zero, sub_zero]
    exact Filter.Eventually.of_forall fun x => by
      simp only [Pi_u, NavierStokes3D.volume] at *; simp [hN]
  · have hint : Integrable (fun y => ‖u y‖ ^ 2) MeasureTheory.volume := by
      by_contra h; exact hN (integral_undef h)
    have hmem : MemLp u 2 MeasureTheory.volume := (memLp_two_iff_integrable_sq_norm hu).2 hint
    set N := ∫ y, ‖u y‖ ^ 2 ∂MeasureTheory.volume
    refine ⟨hmem.toLp u, fun v => inner ℝ v (hmem.toLp u) / N, fun v w => by
      simp only [inner_add_left, add_div], fun v => ?_⟩
    have hpair : (∫ y, ArnoldGeometric.pairing (v y) (u y) ∂MeasureTheory.volume) =
        inner ℝ v (hmem.toLp u) := by
      rw [L2.inner_def]
      apply integral_congr_ae
      filter_upwards [hmem.coeFn_toLp] with y hy
      rw [hy]; rfl
    filter_upwards [Lp.coeFn_sub v ((inner ℝ v (hmem.toLp u) / N) • hmem.toLp u),
      Lp.coeFn_smul (inner ℝ v (hmem.toLp u) / N) (hmem.toLp u), hmem.coeFn_toLp] with x h1 h2 h3
    rw [h1, Pi.sub_apply, h2, Pi.smul_apply, h3]
    simp only [Pi_u, NavierStokes3D.volume]
    rw [hpair]


def eb (i : Fin 3) : T3 := EuclideanSpace.single i 1

def rotL : T3 →L[ℝ] T3 :=
  (-(EuclideanSpace.proj (1 : Fin 3) : T3 →L[ℝ] ℝ)).smulRight (eb 0) +
    (EuclideanSpace.proj (0 : Fin 3) : T3 →L[ℝ] ℝ).smulRight (eb 1)

theorem rotL_apply (v : T3) : rotL v = (-(v 1)) • eb 0 + (v 0) • eb 1 := by
  simp [rotL]

theorem rotL_coord (v : T3) (i : Fin 3) :
    rotL v i = if i = 0 then -(v 1) else if i = 1 then v 0 else 0 := by
  rw [rotL_apply]
  fin_cases i <;> simp [eb, PiLp.single_apply]

def bump (s : ℝ) : ℝ := Real.smoothTransition (1 - s)

def rotField (c : T3) (y : T3) : EuclideanSpace ℝ (Fin 3) :=
  bump (‖y - c‖ ^ 2) • rotL (y - c)

theorem bump_contDiff : ContDiff ℝ (⊤ : ℕ∞) bump :=
  Real.smoothTransition.contDiff.comp (contDiff_const.sub contDiff_id)

theorem rotField_contDiff (c : T3) : ContDiff ℝ (⊤ : ℕ∞) (rotField c) := by
  unfold rotField
  exact (bump_contDiff.comp ((contDiff_id.sub contDiff_const).norm_sq ℝ)).smul
    (rotL.contDiff.comp (contDiff_id.sub contDiff_const))

theorem hasFDerivAt_rotField_coord (c x : T3) (i : Fin 3) :
    HasFDerivAt (fun y => rotField c y i)
      (bump (‖x - c‖ ^ 2) • ((EuclideanSpace.proj i : T3 →L[ℝ] ℝ).comp rotL) +
        rotL (x - c) i • (deriv bump (‖x - c‖ ^ 2) •
          (2 • (innerSL ℝ (x - c)).comp (ContinuousLinearMap.id ℝ T3)))) x := by
  have hg : HasFDerivAt (fun y : T3 => ‖y - c‖ ^ 2)
      (2 • (innerSL ℝ (x - c)).comp (ContinuousLinearMap.id ℝ T3)) x :=
    ((hasFDerivAt_id x).sub_const c).norm_sq
  have hb : HasFDerivAt (fun y : T3 => bump (‖y - c‖ ^ 2))
      (deriv bump (‖x - c‖ ^ 2) • (2 • (innerSL ℝ (x - c)).comp (ContinuousLinearMap.id ℝ T3))) x := by
    have hd : HasDerivAt bump (deriv bump (‖x - c‖ ^ 2)) (‖x - c‖ ^ 2) :=
      (bump_contDiff.differentiable (by simp) _).hasDerivAt
    have h := HasDerivAt.comp_hasFDerivAt (h₂ := bump) x hd hg
    exact h
  have hl : HasFDerivAt (fun y : T3 => rotL (y - c) i)
      ((EuclideanSpace.proj i : T3 →L[ℝ] ℝ).comp rotL) x := by
    have : (fun y : T3 => rotL (y - c) i) =
        fun y => ((EuclideanSpace.proj i : T3 →L[ℝ] ℝ).comp rotL) y -
          ((EuclideanSpace.proj i : T3 →L[ℝ] ℝ).comp rotL) c := by
      funext y; simp [map_sub]
    rw [this]
    exact (ContinuousLinearMap.hasFDerivAt _).sub_const _
  have := hb.mul hl
  have he : (fun y => rotField c y i) = fun y => bump (‖y - c‖ ^ 2) * rotL (y - c) i := by
    funext y; simp [rotField]
  rw [he]
  convert this using 1

theorem inner_eb (v : T3) (i : Fin 3) : inner ℝ v (EuclideanSpace.single i (1:ℝ)) = v i := by
  simp [PiLp.inner_apply, PiLp.single_apply, real_inner_eq_re_inner]

theorem div_rotField (c x : T3) : NavierStokes3D.div (rotField c) x = 0 := by
  unfold NavierStokes3D.div
  simp only [(hasFDerivAt_rotField_coord c x _).fderiv]
  simp [Fin.sum_univ_three, rotL_coord, PiLp.single_apply, inner_sub_left, inner_eb]
  ring

def rotOrbit (c : T3) : CoadjointOrbit := ⟨rotField c, div_rotField c⟩

theorem rotField_eq_zero_of_far (c y : T3) (h : 1 ≤ ‖y - c‖) : rotField c y = 0 := by
  unfold rotField bump
  rw [Real.smoothTransition.zero_of_nonpos, zero_smul]
  nlinarith

theorem rotField_hasCompactSupport (c : T3) : HasCompactSupport (rotField c) := by
  apply HasCompactSupport.intro (isCompact_closedBall c 1)
  intro y hy
  apply rotField_eq_zero_of_far
  simp only [Metric.mem_closedBall, dist_eq_norm, not_le] at hy
  exact hy.le

theorem rotField_ne_zero (c : T3) : rotField c (c + (1/2 : ℝ) • eb 0) ≠ 0 := by
  intro h
  have h1 := congrArg (fun v : EuclideanSpace ℝ (Fin 3) => v 1) h
  simp only [rotField, add_sub_cancel_left, PiLp.smul_apply, smul_eq_mul, PiLp.zero_apply] at h1
  rw [rotL_coord] at h1
  have hn : ‖(1/2 : ℝ) • eb 0‖ ^ 2 = 1/4 := by
    rw [norm_smul, eb, PiLp.norm_single]; norm_num
  rw [hn] at h1
  have hb : 0 < bump (1/4) := Real.smoothTransition.pos_of_pos (by norm_num)
  rcases mul_eq_zero.mp h1 with h1 | h1
  · exact hb.ne' h1
  · simp [eb] at h1

theorem integral_rotField_pos (c : T3) : 0 < ∫ x, ‖rotField c x‖ ^ 2 := by
  apply Continuous.integral_pos_of_hasCompactSupport_nonneg_nonzero (x := c + (1/2 : ℝ) • eb 0)
  · exact ((rotField_contDiff c).continuous.norm).pow 2
  · exact (rotField_hasCompactSupport c).mono (fun x hx h0 => hx (by simp [h0]))
  · intro x; positivity
  · simpa using rotField_ne_zero c



open ForMathlib FrohmanianTether

def tI (ω : CoadjointOrbit) (a b : T3 → EuclideanSpace ℝ (Fin 3)) : ℝ :=
  ∫ x, inner ℝ (Pi_u (velocity_from_vorticity ω) a x) (Pi_u (velocity_from_vorticity ω) b x)

def tK (ω : CoadjointOrbit) (F G : CoadjointOrbit → ℝ) : ℝ :=
  -kappa * Enstrophy ω * tI ω (FunctionalDerivative F ω) (FunctionalDerivative G ω)

theorem tetherIntegral_L2 {ω : CoadjointOrbit} (hω : IsRegularVorticity ω) :
    ∃ (U : L2Field) (ℓ : L2Field → ℝ), (∀ v w, ℓ (v + w) = ℓ v + ℓ w) ∧
      ∀ v w : L2Field, tI ω ⇑v ⇑w = inner ℝ (v - ℓ v • U) (w - ℓ w • U) := by
  have hu : AEStronglyMeasurable (velocity_from_vorticity ω) MeasureTheory.volume := by
    rw [velocity_from_vorticity_eq_BiotSavart]
    exact (stronglyMeasurable_biotSavart hω.continuous).aestronglyMeasurable
  obtain ⟨U, ℓ, hadd, hae⟩ := pi_u_L2 hu
  refine ⟨U, ℓ, hadd, fun v w => ?_⟩
  rw [tI, L2.inner_def]
  apply integral_congr_ae
  filter_upwards [hae v, hae w] with x h1 h2
  rw [h1, h2]

theorem tK_polarizes_of_gradient {F G : CoadjointOrbit → ℝ} {ω a b}
    (hF : IsFunctionalGradient F ω a) (hG : IsFunctionalGradient G ω b) :
    2 * tK ω F G = tK ω (fun η => F η + G η) (fun η => F η + G η) - tK ω F F - tK ω G G := by
  obtain ⟨U, ℓ, hadd, hI⟩ := tetherIntegral_L2 hF.2.1
  have hS := hF.add hG
  simp only [tK, functionalDerivative_eq hF, functionalDerivative_eq hG,
    functionalDerivative_eq hS, hI, hadd, add_smul]
  have e : a + b - (ℓ a • U + ℓ b • U) = (a - ℓ a • U) + (b - ℓ b • U) := by abel
  rw [e, real_inner_add_add_self]
  ring

theorem tK_eq_zero_left {ω : CoadjointOrbit} {F : CoadjointOrbit → ℝ} (G : CoadjointOrbit → ℝ)
    (h : FunctionalDerivative F ω = 0) : tK ω F G = 0 := by
  simp [tK, tI, h, Pi_u_zero]

theorem inner_self_testToL2 (φ : CoadjointOrbit) (hφ : IsTestDirection φ) :
    inner ℝ (testToL2 φ hφ) (testToL2 φ hφ) = ∫ x, ‖φ.val x‖ ^ 2 := by
  rw [inner_testToL2]
  simp_rw [real_inner_self_eq_norm_sq]


theorem linFun_orbitLine {ω : CoadjointOrbit} (hω : IsRegularVorticity ω) (φ : CoadjointOrbit)
    (hφ : IsTestDirection φ) (ε : CoadjointOrbit) (hε : IsTestDirection ε) (t : ℝ) :
    linFun φ (orbitLine ω ε hω hε.regular t) =
      linFun φ ω + t * ∫ x, inner ℝ (ε.val x) (φ.val x) := by
  have h1 := integrable_inner_test hω.continuous hφ
  have h2 := integrable_inner_test hε.regular.continuous hφ
  simp only [linFun, orbitLine, inner_add_left, inner_smul_left, RCLike.conj_to_real]
  rw [integral_add h1 (h2.const_mul t), integral_const_mul]

theorem rotField_disjoint (x : T3) :
    inner ℝ (rotField 0 x) (rotField ((3:ℝ) • eb 0) x) = 0 := by
  by_cases hx : 1 ≤ ‖x - 0‖
  · simp [rotField_eq_zero_of_far 0 x hx]
  · have h3 : 1 ≤ ‖x - (3:ℝ) • eb 0‖ := by
      push Not at hx
      have hn : ‖(3:ℝ) • eb 0‖ = 3 := by simp [eb, norm_smul]
      have := norm_sub_norm_le ((3:ℝ) • eb 0) x
      rw [norm_sub_rev] at this
      simp at hx
      linarith
    simp [rotField_eq_zero_of_far _ x h3]

theorem rot_test (c : T3) : IsTestDirection (rotOrbit c) :=
  ⟨rotField_contDiff c, rotField_hasCompactSupport c⟩

/-- **Nondegeneracy of the tether kernel** (formerly the hypothesis `h_nondeg`). -/
theorem tetherKernel_nondegenerate :
    ∃ (ω φ : CoadjointOrbit) (hφ : IsTestDirection φ), IsRegularVorticity ω ∧
      tK ω (linFun φ) (linFun φ) ≠ 0 := by
  set ω := rotOrbit 0
  have hω : IsRegularVorticity ω := (rot_test 0).regular
  obtain ⟨U, ℓ, -, hI⟩ := tetherIntegral_L2 hω
  have hE : 0 < Enstrophy ω := by
    simpa [Enstrophy, Casimir, ω, rotOrbit] using integral_rotField_pos 0
  have hk : kappa ≠ 0 := by rw [kappa_eq_three_halves]; norm_num
  set h0 := rot_test 0
  set h1 := rot_test ((3:ℝ) • eb 0)
  set T0 := testToL2 _ h0
  set T1 := testToL2 _ h1
  have key : ∀ (φ : CoadjointOrbit) (hφ : IsTestDirection φ),
      tK ω (linFun φ) (linFun φ) = -kappa * Enstrophy ω *
        inner ℝ (testToL2 φ hφ - ℓ (testToL2 φ hφ) • U) (testToL2 φ hφ - ℓ (testToL2 φ hφ) • U) := by
    intro φ hφ
    rw [tK, functionalDerivative_eq (linFun_gradient hω φ hφ), hI]
  by_contra hall
  push Not at hall
  have z : ∀ (φ : CoadjointOrbit) (hφ : IsTestDirection φ),
      testToL2 φ hφ = ℓ (testToL2 φ hφ) • U := by
    intro φ hφ
    have := hall ω φ hφ hω
    rw [key φ hφ] at this
    have hc : -kappa * Enstrophy ω ≠ 0 := mul_ne_zero (neg_ne_zero.mpr hk) hE.ne'
    exact sub_eq_zero.mp (inner_self_eq_zero.mp ((mul_eq_zero.mp this).resolve_left hc))
  have p0 : 0 < inner ℝ T0 T0 := by
    rw [inner_self_testToL2]; exact integral_rotField_pos 0
  have p1 : 0 < inner ℝ T1 T1 := by
    rw [inner_self_testToL2]; exact integral_rotField_pos _
  have d01 : inner ℝ T0 T1 = 0 := by
    rw [inner_testToL2]; simp [rotOrbit, rotField_disjoint]
  have e0 : T0 = ℓ T0 • U := z _ h0
  have e1 : T1 = ℓ T1 • U := z _ h1
  clear_value T0 T1
  rw [e0, e1] at d01
  rw [e0] at p0
  rw [e1] at p1
  simp only [real_inner_smul_left, real_inner_smul_right] at p0 p1 d01
  have hU : inner ℝ U U ≠ 0 := by intro h; rw [h] at p0; simp at p0
  have hl0 : ℓ T0 ≠ 0 := by intro h; rw [h] at p0; simp at p0
  have hl1 : ℓ T1 = 0 := by
    rcases mul_eq_zero.mp d01 with h | h
    · exact h
    · rcases mul_eq_zero.mp h with h | h
      · exact absurd h hl0
      · exact absurd h hU
  rw [hl1] at p1; simp at p1

/-- The non-differentiable functional `η ↦ |∫⟨η,φ⟩ - ∫⟨ω,φ⟩|`. -/
def absFun (φ ω : CoadjointOrbit) : CoadjointOrbit → ℝ := fun η => |linFun φ η - linFun φ ω|

theorem absFun_no_gradient {ω φ : CoadjointOrbit} (hφ : IsTestDirection φ)
    (hpos : 0 < ∫ x, ‖φ.val x‖ ^ 2) : ¬ ∃ g, IsFunctionalGradient (absFun φ ω) ω g := by
  rintro ⟨g, -, hω, hd⟩
  have h := hd φ hφ
  set c := ∫ x, ‖φ.val x‖ ^ 2
  have hline : (fun t => absFun φ ω (orbitLine ω φ hω hφ.regular t)) = fun t => |t * c| := by
    funext t
    simp only [absFun, linFun_orbitLine hω φ hφ φ hφ, add_sub_cancel_left, c]
    simp_rw [real_inner_self_eq_norm_sq]
  rw [hline] at h
  have h2 : HasDerivAt (fun t => |t * c| / c) (inner ℝ g (testToL2 φ hφ) / c) 0 := h.div_const c
  have : (fun t => |t * c| / c) = fun t => |t| := by
    funext t; rw [abs_mul, abs_of_pos hpos]; field_simp
  rw [this] at h2
  exact not_differentiableAt_abs_zero h2.differentiableAt

/-- **Unrestricted polarization of the tether kernel is false.** -/
theorem not_tetherKernel_polarizes :
    ¬ ∀ ω F G, 2 * tK ω F G = tK ω (fun η => F η + G η) (fun η => F η + G η) - tK ω F F - tK ω G G := by
  intro hP
  obtain ⟨ω, φ, hφ, hω, hne⟩ := tetherKernel_nondegenerate
  have hpos : 0 < ∫ x, ‖φ.val x‖ ^ 2 := by
    rw [← inner_self_testToL2 φ hφ]
    refine lt_of_le_of_ne real_inner_self_nonneg (fun h => hne ?_)
    have : testToL2 φ hφ = 0 := inner_self_eq_zero.mp h.symm
    obtain ⟨U, ℓ, hadd, hI⟩ := tetherIntegral_L2 hω
    have hl : ℓ 0 = 0 := by have := hadd 0 0; simp at this; linarith
    rw [tK, functionalDerivative_eq (linFun_gradient hω φ hφ), this, hI, hl]
    simp
  have hF : FunctionalDerivative (absFun φ ω) ω = 0 :=
    functionalDerivative_eq_zero_of_not (absFun_no_gradient hφ hpos)
  have hS : FunctionalDerivative (fun η => absFun φ ω η + linFun φ η) ω = 0 := by
    apply functionalDerivative_eq_zero_of_not
    rintro ⟨g, hg⟩
    apply absFun_no_gradient (ω := ω) hφ hpos
    refine ⟨g - testToL2 φ hφ, ?_⟩
    have := hg.sub (linFun_gradient hω φ hφ)
    simpa using this
  have := hP ω (absFun φ ω) (linFun φ)
  rw [tK_eq_zero_left _ hF, tK_eq_zero_left _ hS, tK_eq_zero_left _ hF] at this
  exact hne (by linarith)

end FGTest
