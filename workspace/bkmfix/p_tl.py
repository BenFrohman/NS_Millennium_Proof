import sys,re
for f in sys.argv[1:]:
    s=open(f).read()
    # 1. replace global_regularity_of_bkmIntegrability
    a=s.index("/-- Global regularity from BKM integrability alone (finite-horizon input)")
    b=s.index("public theorem global_regularity\n")
    new_bkm='''/-- BKM continuation criterion for every solution from `u₀` (classical, Beale–Kato–Majda 1984). -/
@[expose] public def BKMContinuationCriterionFor (u₀ : VelocityField) (ν : ℝ) : Prop :=
  ∀ u : ℝ → VelocityField, ∀ p : ℝ → PressureField,
    NS_PDE u p ν → u 0 = u₀ → BKMContinuationCriterion u ν

/-- `BKMContinuationCriterionFor` restricted to `IsPhysicalNSSolution` paths. -/
@[expose] public def PhysicalBKMContinuationCriterionFor (u₀ : VelocityField) (ν : ℝ) : Prop :=
  ∀ u : ℝ → VelocityField, ∀ p : ℝ → PressureField,
    NS_PDE u p ν → u 0 = u₀ → IsPhysicalNSSolution u → BKMContinuationCriterion u ν

/-- Smoothness below `T*` for every solution from `u₀` (local regularity and uniqueness). -/
@[expose] public def SmoothBelowTstarFor (u₀ : VelocityField) (ν : ℝ) : Prop :=
  ∀ u : ℝ → VelocityField, ∀ p : ℝ → PressureField,
    NS_PDE u p ν → u 0 = u₀ → SmoothBelowTstar u ν

/-- Uniform Kato restart of length `τ` below `T*`. -/
@[expose] public def KatoUniformRestart (u₀ : VelocityField) (ν τ : ℝ) : Prop :=
  ∀ t : ℝ, 0 ≤ t → (t : EReal) < Tstar u₀ ν → ∃ T' ∈ existenceTimes u₀ ν, t + τ ≤ T'

/-- Every smooth physical solution on an existence interval agrees with the Kato witness. -/
@[expose] public def KatoUniquenessOnExistenceTimes (u₀ : VelocityField) (ν : ℝ)
    (w : KatoLocalWitness u₀ ν) : Prop :=
  ∀ (T' : ℝ) (v : TimeDependentVelocity) (q : TimeDependentPressure),
    T' ∈ existenceTimes u₀ ν → v 0 = u₀ → NS_PDE v q ν →
    (∀ t ∈ Set.Icc (0 : ℝ) T', ContDiff ℝ (⊤ : ℕ∞) (v t)) →
    IsPhysicalNSSolution v →
    ∀ t ∈ Set.Icc (0 : ℝ) T', w.u t = v t

/-- Positive local existence time for any solution starting at `u₀`, from the Kato witness. -/
public theorem localExistenceTime_of_kato {u₀ : VelocityField} {ν : ℝ}
    (w : KatoLocalWitness u₀ ν) (u : ℝ → VelocityField) (hu0 : u 0 = u₀) :
    LocalExistenceTime u ν := by
  unfold LocalExistenceTime
  rw [hu0]
  exact Tstar_pos_of_kato_witness u₀ ν w

/-- **Global regularity from BKM integrability.** `T* = ⊤` is derived from the Kato
local existence time, `BKMContinuationCriterionFor`, and `BKMIntegrability`
(`NavierStokes3D.Tstar_eq_top_of_bkm`). Open input: `BKMIntegrability`. -/
public theorem global_regularity_of_bkmIntegrability
    (u₀ : VelocityField) (ν : ℝ)
    (h_divfree : ∀ x, div u₀ x = 0)
    (h_smooth : ContDiff ℝ (⊤ : ℕ∞) u₀)
    (h_finite_energy : Integrable (fun x : T3 => ‖u₀ x‖ ^ 2))
    (h_pos_ν : ν > 0)
    (w : KatoLocalWitness u₀ ν)
    (hBKM : BKMIntegrability u₀ ν)
    (hcrit : BKMContinuationCriterionFor u₀ ν)
    (hbelow : SmoothBelowTstarFor u₀ ν) :
  ∃ (u : ℝ → VelocityField) (p : ℝ → PressureField),
    NS_PDE u p ν ∧
    u 0 = u₀ ∧
    (∀ t ≥ (0 : ℝ), ContDiff ℝ (⊤ : ℕ∞) (u t)) ∧
    (∀ t ≥ (0 : ℝ), vorticity_sup_norm (vorticity (u t)) ≥ 0) ∧
    (∀ t ≥ (0 : ℝ), ∀ x, div (u t) x = 0) := by
  obtain ⟨_Tloc, _hTloc, u, _hloc, hu0, _hphys, p, hNS⟩ :=
    local_existence u₀ ν h_smooth h_divfree h_finite_energy h_pos_ν w
  refine ⟨u, p, hNS, hu0, ?smooth, ?nn, ?div0⟩
  · exact beale_kato_majda u p ν h_pos_ν hNS (localExistenceTime_of_kato w u hu0)
      (hcrit u p hNS hu0) (fun T => hBKM u p hNS hu0 T) (hbelow u p hNS hu0)
  · intro t _ht
    exact vorticity_sup_norm_nonneg _
  · intro t ht x
    exact (hNS t ht x).2

/-- **Global regularity from the finite-horizon vorticity bound**, through
`bkmIntegrability_of_finiteTime` and `global_regularity_of_bkmIntegrability`.
Open input: `FiniteTimeVorticityBound`. -/
public theorem global_regularity
    (u₀ : VelocityField) (ν : ℝ)
    (h_divfree : ∀ x, div u₀ x = 0)
    (h_smooth : ContDiff ℝ (⊤ : ℕ∞) u₀)
    (h_finite_energy : Integrable (fun x : T3 => ‖u₀ x‖ ^ 2))
    (h_pos_ν : ν > 0)
    (w : KatoLocalWitness u₀ ν)
    (hRiccati : FiniteTimeVorticityBound u₀ ν)
    (hcrit : BKMContinuationCriterionFor u₀ ν)
    (hbelow : SmoothBelowTstarFor u₀ ν) :
  ∃ (u : ℝ → VelocityField) (p : ℝ → PressureField),
    NS_PDE u p ν ∧
    u 0 = u₀ ∧
    (∀ t ≥ (0 : ℝ), ContDiff ℝ (⊤ : ℕ∞) (u t)) ∧
    (∀ t ≥ (0 : ℝ), vorticity_sup_norm (vorticity (u t)) ≥ 0) ∧
    (∀ t ≥ (0 : ℝ), ∀ x, div (u t) x = 0) :=
  global_regularity_of_bkmIntegrability u₀ ν h_divfree h_smooth h_finite_energy h_pos_ν w
    (bkmIntegrability_of_finiteTime hRiccati) hcrit hbelow

/-- Scaffolding: the earlier assembly taking `T* = ⊤` for every path as an input. -/
public theorem global_regularity_scaffold
'''
    s=s[:a]+new_bkm+s[b+len("public theorem global_regularity\n"):]
    # within scaffold body, the call to beale_kato_majda -> scaffold ; hTstar binder types
    s=s.replace('''  · exact beale_kato_majda u p ν h_pos_ν hNS
      (fun T _hT => bkmIntegrability_of_finiteTime hRiccati u p hNS hu0 T)
      (hTstar u) (hbelow u)''','''  · exact beale_kato_majda_scaffold u p ν h_pos_ν hNS
      (fun T _hT => bkmIntegrability_of_finiteTime hRiccati u p hNS hu0 T)
      (hTstar u) (hbelow u)''')
    s=s.replace('''    (hTstar : ∀ u : ℝ → VelocityField, Tstar (u 0) ν = ⊤)
    (hbelow : ∀ u : ℝ → VelocityField,
      ∀ T : ℝ, (T : EReal) < Tstar (u 0) ν →
        ∀ t ∈ Set.Icc (0 : ℝ) T, ContDiff ℝ (⊤ : ℕ∞) (u t)) :''','''    (hTstar : ∀ u : ℝ → VelocityField, TstarIsTop u ν)
    (hbelow : ∀ u : ℝ → VelocityField, SmoothBelowTstar u ν) :''')
    # restart theorem
    old_rs='''    (hrestart : ∀ t : ℝ, 0 ≤ t → (t : EReal) < Tstar u₀ ν →
      ∃ T' ∈ existenceTimes u₀ ν, t + τ ≤ T')
    (huniq : ∀ (T' : ℝ) (v : TimeDependentVelocity) (q : TimeDependentPressure),
      T' ∈ existenceTimes u₀ ν →
      v 0 = u₀ →
      NS_PDE v q ν →
      (∀ t ∈ Set.Icc (0 : ℝ) T', ContDiff ℝ (⊤ : ℕ∞) (v t)) →
      IsPhysicalNSSolution v →
      ∀ t ∈ Set.Icc (0 : ℝ) T', w.u t = v t) :
    NS_PDE w.u w.p ν ∧'''
    assert s.count(old_rs)==1, (f, s.count(old_rs))
    s=s.replace(old_rs,'''    (hrestart : KatoUniformRestart u₀ ν τ)
    (huniq : KatoUniquenessOnExistenceTimes u₀ ν w) :
    NS_PDE w.u w.p ν ∧''')
    s=s.replace('''  · exact beale_kato_majda w.u w.p ν h_pos_ν w.pde''','''  · exact beale_kato_majda_scaffold w.u w.p ν h_pos_ν w.pde''')
    # add genuine restart-free version before global_regularity_of_kato_estimates docstring
    anchor="/-- Same assembly, with the free restart length replaced by the paper Kato"
    assert anchor in s
    genuine='''/-- Smoothness of the Kato witness below `T*` from `KatoUniquenessOnExistenceTimes`. -/
public theorem smoothBelowTstar_of_katoUniqueness {u₀ : VelocityField} {ν : ℝ}
    (w : KatoLocalWitness u₀ ν) (huniq : KatoUniquenessOnExistenceTimes u₀ ν w) :
    SmoothBelowTstar w.u ν := by
  have hu0 : w.u 0 = u₀ := w.init
  intro T hTlt t ht
  by_cases hTnn : 0 ≤ T
  · have huniq' :
        ∀ (T' : ℝ) (v : TimeDependentVelocity) (q : TimeDependentPressure),
          T' ∈ existenceTimes (w.u 0) ν →
          v 0 = w.u 0 →
          NS_PDE v q ν →
          (∀ s ∈ Set.Icc (0 : ℝ) T', ContDiff ℝ (⊤ : ℕ∞) (v s)) →
          IsPhysicalNSSolution v →
          ∀ s ∈ Set.Icc (0 : ℝ) T', w.u s = v s := by
      intro T' v q hmem hv0 hpde hsm hphys
      have hmem' : T' ∈ existenceTimes u₀ ν := by
        simpa [hu0] using hmem
      exact huniq T' v q hmem' (hv0.trans hu0) hpde hsm hphys
    exact smoothness_below_Tstar_of_uniqueness w.u ν huniq' hTlt hTnn t ht
  · exact absurd (le_trans ht.1 ht.2) hTnn

/-- **Global regularity of the Kato witness through BKM.** `T* = ⊤` is derived from the
Kato local existence time, `PhysicalBKMContinuationCriterionFor`, and the BKM integrability
supplied by `PhysicalFiniteTimeVorticityBound`; smoothness below `T*` comes from
`KatoUniquenessOnExistenceTimes`. No restart hypothesis.
Open input: `PhysicalFiniteTimeVorticityBound`. -/
public theorem global_regularity_of_bkm_uniqueness
    (u₀ : VelocityField) (ν : ℝ)
    (h_pos_ν : ν > 0)
    (w : KatoLocalWitness u₀ ν)
    (hRiccati : PhysicalFiniteTimeVorticityBound u₀ ν)
    (hcrit : PhysicalBKMContinuationCriterionFor u₀ ν)
    (huniq : KatoUniquenessOnExistenceTimes u₀ ν w) :
    NS_PDE w.u w.p ν ∧
      w.u 0 = u₀ ∧
      (∀ t ≥ (0 : ℝ), ContDiff ℝ (⊤ : ℕ∞) (w.u t)) ∧
      (∀ t ≥ (0 : ℝ), vorticity_sup_norm (vorticity (w.u t)) ≥ 0) ∧
      (∀ t ≥ (0 : ℝ), ∀ x, div (w.u t) x = 0) := by
  refine ⟨w.pde, w.init, ?smooth, ?nn, ?div0⟩
  · exact beale_kato_majda w.u w.p ν h_pos_ν w.pde (localExistenceTime_of_kato w w.u w.init)
      (hcrit w.u w.p w.pde w.init w.phys)
      (fun T => physicalBKMIntegrability_of_finiteTime hRiccati w.u w.p w.pde w.init w.phys T)
      (smoothBelowTstar_of_katoUniqueness w huniq)
  · intro _t _ht
    exact vorticity_sup_norm_nonneg _
  · intro t ht x
    exact (w.pde t ht x).2

/-- In `global_regularity_of_restart`, `T* = ⊤` follows from `KatoUniformRestart` and the
Kato witness alone; the vorticity-bound argument is not used for it. -/
public theorem Tstar_top_of_restart_without_vorticity_bound
    (u₀ : VelocityField) (ν : ℝ) (w : KatoLocalWitness u₀ ν)
    (τ : ℝ) (hτ : 0 < τ) (hrestart : KatoUniformRestart u₀ ν τ) :
    Tstar u₀ ν = ⊤ :=
  Tstar_eq_top_of_uniform_restart u₀ ν τ hτ (Tstar_pos_of_kato_witness u₀ ν w) hrestart

'''
    s=s.replace(anchor,genuine+anchor,1)
    s=s.replace("#print axioms global_regularity_of_bkmIntegrability\n","#print axioms global_regularity_of_bkmIntegrability\n#print axioms global_regularity_of_bkm_uniqueness\n#print axioms Tstar_top_of_restart_without_vorticity_bound\n")
    open(f,'w').write(s)
