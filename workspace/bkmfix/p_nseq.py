import sys,re
OLD_BKM='''/-- Beale–Kato–Majda criterion (Beale–Kato–Majda 1984).

If the time-integral of `‖ω(t)‖_∞` stays finite up to the maximal time, continuation
forces `T* = ⊤`; smoothness on compact subintervals then upgrades to all `t ≥ 0`.
The integral hyp is the BKM input; `T* = ⊤` and the compact-interval smoothness
are the continuation output. -/
public theorem beale_kato_majda
    (u : TimeDependentVelocity) (_p : TimeDependentPressure) (ν : ℝ)
    (_hν : 0 < ν) (_hNS : NS_PDE u _p ν)
    (_h_bkm : ∀ T : ℝ, (T : EReal) < Tstar (u 0) ν →
      IntegrableOn (fun t => vorticity_sup_norm (vorticity (u t))) (Set.Icc 0 T))
    (hTstar : Tstar (u 0) ν = ⊤)
    (hbelow : ∀ T : ℝ, (T : EReal) < Tstar (u 0) ν →
      ∀ t ∈ Set.Icc (0 : ℝ) T, ContDiff ℝ (⊤ : ℕ∞) (u t)) :
    ∀ t ≥ (0 : ℝ), ContDiff ℝ (⊤ : ℕ∞) (u t) :=
  smoothness_of_Tstar_top u ν hTstar hbelow
'''
NEW_BKM='''/-! ### Beale–Kato–Majda continuation as named `Prop`s

`T* = ⊤` is derived from three inputs: a positive local existence time, the BKM
continuation criterion (finite `T*` forces `∫₀^{T*} ‖ω‖_∞ dt = ∞`), and integrability of
`‖ω‖_∞` on every `[0, T]`. The integrability input is used: without it the criterion and
local existence are satisfied by `T* = 1` (`bkm_criterion_without_integrability_not_top`). -/

/-- `T* = ⊤` for the data `u 0`. -/
@[expose] public def TstarIsTop (u : TimeDependentVelocity) (ν : ℝ) : Prop :=
  Tstar (u 0) ν = ⊤

/-- Positive local existence time: `0 < T*` (Kato). -/
@[expose] public def LocalExistenceTime (u : TimeDependentVelocity) (ν : ℝ) : Prop :=
  (0 : EReal) < Tstar (u 0) ν

/-- Smoothness of `u` on every compact `[0, T]` with `T < T*` (local regularity together
with uniqueness of the maximal solution). -/
@[expose] public def SmoothBelowTstar (u : TimeDependentVelocity) (ν : ℝ) : Prop :=
  ∀ T : ℝ, (T : EReal) < Tstar (u 0) ν →
    ∀ t ∈ Set.Icc (0 : ℝ) T, ContDiff ℝ (⊤ : ℕ∞) (u t)

/-- Beale–Kato–Majda integrability along the path `u`: `∫₀ᵀ ‖ω(t)‖_∞ dt < ∞` for every `T`. -/
@[expose] public def PathBKMIntegrable (u : TimeDependentVelocity) : Prop :=
  ∀ T : ℝ, IntegrableOn (fun t => vorticity_sup_norm (vorticity (u t))) (Set.Icc 0 T)

/-- **BKM continuation criterion** (Beale–Kato–Majda 1984): if `T* < ∞` then
`∫₀^{T*} ‖ω(t)‖_∞ dt = ∞`. -/
@[expose] public def BKMContinuationCriterion (u : TimeDependentVelocity) (ν : ℝ) : Prop :=
  ∀ T : ℝ, Tstar (u 0) ν = (T : EReal) →
    ¬ IntegrableOn (fun t => vorticity_sup_norm (vorticity (u t))) (Set.Icc 0 T)

/-- Abstract BKM step: a positive extended time `T*` such that a finite `T*` makes `f`
non-integrable on `[0, T*]`, while `f` is integrable on every `[0, T]`, equals `⊤`. -/
public theorem ereal_eq_top_of_bkm (Ts : EReal) (f : ℝ → ℝ)
    (hpos : (0 : EReal) < Ts)
    (hcrit : ∀ T : ℝ, Ts = (T : EReal) → ¬ IntegrableOn f (Set.Icc 0 T))
    (hint : ∀ T : ℝ, IntegrableOn f (Set.Icc 0 T)) :
    Ts = ⊤ := by
  induction Ts using EReal.rec with
  | bot => exact absurd hpos (not_lt.2 bot_le)
  | coe T => exact absurd (hint T) (hcrit T rfl)
  | top => rfl

/-- Without the integrability input, local existence and the BKM criterion do not force
`T* = ⊤`: `T* = 1` with `f t = t⁻¹` satisfies both. -/
public theorem bkm_criterion_without_integrability_not_top :
    ∃ (Ts : EReal) (f : ℝ → ℝ), (0 : EReal) < Ts ∧
      (∀ T : ℝ, Ts = (T : EReal) → ¬ IntegrableOn f (Set.Icc 0 T)) ∧ Ts ≠ ⊤ := by
  refine ⟨((1 : ℝ) : EReal), fun t => t⁻¹, by exact_mod_cast one_pos, ?_,
    EReal.coe_ne_top 1⟩
  intro T hT h
  have hT1 : T = 1 := by exact_mod_cast hT.symm
  subst hT1
  have hii : IntervalIntegrable (fun t : ℝ => t⁻¹) MeasureTheory.volume 0 1 :=
    (intervalIntegrable_iff_integrableOn_Icc_of_le zero_le_one).2 h
  rw [intervalIntegrable_inv_iff] at hii
  rcases hii with h01 | h0
  · exact zero_ne_one h01
  · exact h0 (Set.left_mem_uIcc)

/-- `T* = ⊤` from local existence, the BKM criterion, and BKM integrability. -/
public theorem Tstar_eq_top_of_bkm (u : TimeDependentVelocity) (ν : ℝ)
    (hloc : LocalExistenceTime u ν) (hcrit : BKMContinuationCriterion u ν)
    (hint : PathBKMIntegrable u) :
    TstarIsTop u ν :=
  ereal_eq_top_of_bkm _ _ hloc hcrit hint

/-- **Beale–Kato–Majda** (1984). Global smoothness from local existence, the BKM
continuation criterion, smoothness below `T*`, and integrability of `‖ω‖_∞` on every
`[0, T]`. `T* = ⊤` is derived through `Tstar_eq_top_of_bkm`. -/
public theorem beale_kato_majda
    (u : TimeDependentVelocity) (_p : TimeDependentPressure) (ν : ℝ)
    (_hν : 0 < ν) (_hNS : NS_PDE u _p ν)
    (hloc : LocalExistenceTime u ν)
    (hcrit : BKMContinuationCriterion u ν)
    (hint : PathBKMIntegrable u)
    (hbelow : SmoothBelowTstar u ν) :
    ∀ t ≥ (0 : ℝ), ContDiff ℝ (⊤ : ℕ∞) (u t) :=
  smoothness_of_Tstar_top u ν (Tstar_eq_top_of_bkm u ν hloc hcrit hint) hbelow

/-- Scaffolding: the earlier BKM signature, taking `T* = ⊤` as an input. -/
public theorem beale_kato_majda_scaffold
    (u : TimeDependentVelocity) (_p : TimeDependentPressure) (ν : ℝ)
    (_hν : 0 < ν) (_hNS : NS_PDE u _p ν)
    (_h_bkm : ∀ T : ℝ, (T : EReal) < Tstar (u 0) ν →
      IntegrableOn (fun t => vorticity_sup_norm (vorticity (u t))) (Set.Icc 0 T))
    (hTstar : TstarIsTop u ν)
    (hbelow : SmoothBelowTstar u ν) :
    ∀ t ≥ (0 : ℝ), ContDiff ℝ (⊤ : ℕ∞) (u t) :=
  smoothness_of_Tstar_top u ν hTstar hbelow

/-- The conclusion of `beale_kato_majda_scaffold` follows from `TstarIsTop` and
`SmoothBelowTstar` alone; its integrability argument is not used. -/
public theorem beale_kato_majda_scaffold_integrability_unused
    (u : TimeDependentVelocity) (ν : ℝ)
    (hTstar : TstarIsTop u ν) (hbelow : SmoothBelowTstar u ν) :
    ∀ t ≥ (0 : ℝ), ContDiff ℝ (⊤ : ℕ∞) (u t) :=
  smoothness_of_Tstar_top u ν hTstar hbelow
'''
OLD_PAR='''    (hTstar : Tstar (u 0) ν = ⊤)
    (hbelow : ∀ T : ℝ, (T : EReal) < Tstar (u 0) ν →
      ∀ t ∈ Set.Icc (0 : ℝ) T, ContDiff ℝ (⊤ : ℕ∞) (u t)) :
    ∀ t ≥ (0 : ℝ), ContDiff ℝ (⊤ : ℕ∞) (u t) :=
  beale_kato_majda u p ν hν hNS (fun T _hTlt => by
    by_cases hT0 : 0 ≤ T
    · exact hcont.continuousOn.integrableOn_Icc
    · have hempty : Set.Icc (0 : ℝ) T = (∅ : Set ℝ) := by
        ext x
        constructor
        · intro hx
          exact (hT0 (le_trans hx.1 hx.2)).elim
        · intro hx
          exact hx.elim
      rw [hempty]
      exact integrableOn_empty) hTstar hbelow
'''
NEW_PAR='''    (hloc : LocalExistenceTime u ν)
    (hcrit : BKMContinuationCriterion u ν)
    (hbelow : SmoothBelowTstar u ν) :
    ∀ t ≥ (0 : ℝ), ContDiff ℝ (⊤ : ℕ∞) (u t) :=
  beale_kato_majda u p ν hν hNS hloc hcrit
    (fun T => hcont.continuousOn.integrableOn_Icc) hbelow
'''
for f in sys.argv[1:]:
    s=open(f).read()
    assert OLD_BKM in s and OLD_PAR in s, f
    s=s.replace(OLD_BKM,NEW_BKM).replace(OLD_PAR,NEW_PAR)
    s=s.replace("#print axioms beale_kato_majda\n","#print axioms beale_kato_majda\n#print axioms beale_kato_majda_scaffold_integrability_unused\n#print axioms bkm_criterion_without_integrability_not_top\n#print axioms Tstar_eq_top_of_bkm\n")
    open(f,'w').write(s)
