import sys,os
d=sys.argv[1]
def rep(f,old,new,cnt=1):
    p=os.path.join(d,f); s=open(p).read()
    assert s.count(old)==cnt,(f,old[:60],s.count(old)); s=s.replace(old,new); open(p,'w').write(s)
HT='''    (hTstar : Tstar (u 0) ν = ⊤)
    (hbelow : ∀ T : ℝ, (T : EReal) < Tstar (u 0) ν →
      ∀ t ∈ Set.Icc (0 : ℝ) T, ContDiff ℝ (⊤ : ℕ∞) (u t)) :'''
HN='''    (hloc : LocalExistenceTime u ν)
    (hcrit : BKMContinuationCriterion u ν)
    (hbelow : SmoothBelowTstar u ν) :'''
rep("AnalyticPipeline.lean",HT,HN)
rep("AnalyticPipeline.lean",'''  beale_kato_majda u p ν hν hNS (fun T _hTlt =>
    bkm_integrableOn_of_uniform_bound Y
      (fun τ => vorticity_sup_norm (vorticity (u τ))) hbound hcont T)
    hTstar hbelow''','''  beale_kato_majda u p ν hν hNS hloc hcrit (fun T =>
    bkm_integrableOn_of_uniform_bound Y
      (fun τ => vorticity_sup_norm (vorticity (u τ))) hbound hcont T)
    hbelow''')
C="ClosureBlueprint.lean"
rep(C,'''    (h_bkm : ∀ T : ℝ, (T : EReal) < Tstar (u 0) ν →
      IntegrableOn (fun t => vorticity_sup_norm (vorticity (u t))) (Set.Icc 0 T))
'''+HT,'''    (hloc : LocalExistenceTime u ν)
    (hcrit : BKMContinuationCriterion u ν)
    (h_bkm : PathBKMIntegrable u)
    (hbelow : SmoothBelowTstar u ν) :''')
rep(C,"NavierStokes3D.beale_kato_majda u p ν hν hNS h_bkm hTstar hbelow","NavierStokes3D.beale_kato_majda u p ν hν hNS hloc hcrit h_bkm hbelow")
rep(C,HT,HN,2)
rep(C,"hbound hcont hTstar hbelow","hbound hcont hloc hcrit hbelow")
rep(C,'''hcont
    hTstar hbelow''','''hcont
    hloc hcrit hbelow''')
rep(C,'''    (hRiccati : RiccatiMajorantExists u₀ ν)
    (hTstar : ∀ u : ℝ → VelocityField, Tstar (u 0) ν = ⊤)
    (hbelow : ∀ u : ℝ → VelocityField,
      ∀ T : ℝ, (T : EReal) < Tstar (u 0) ν →
        ∀ t ∈ Set.Icc (0 : ℝ) T, ContDiff ℝ (⊤ : ℕ∞) (u t)) :''','''    (hRiccati : RiccatiMajorantExists u₀ ν)
    (hcrit : TetheredLyapunov.BKMContinuationCriterionFor u₀ ν)
    (hbelow : TetheredLyapunov.SmoothBelowTstarFor u₀ ν) :''')
rep(C,"hmaj hcont (hTstar u) (hbelow u)","hmaj hcont (TetheredLyapunov.localExistenceTime_of_kato w u hu0)\n    (hcrit u p hNS hu0) (hbelow u p hNS hu0)")
rep(C,'''-- NOTE: like `continuation_under_global_existence`, this takes `hTstar` (global existence)
-- as a hypothesis; it records type composition only and is not a regularity claim.
''','''''')
rep(C,'''    (hTstar : ∀ u : ℝ → VelocityField, Tstar (u 0) ν = ⊤)
    (hbelow : ∀ u : ℝ → VelocityField,
      ∀ T : ℝ, (T : EReal) < Tstar (u 0) ν →
        ∀ t ∈ Set.Icc (0 : ℝ) T, ContDiff ℝ (⊤ : ℕ∞) (u t)) :''','''    (hTstar : ∀ u : ℝ → VelocityField, TstarIsTop u ν)
    (hbelow : ∀ u : ℝ → VelocityField, SmoothBelowTstar u ν) :''')
rep(C,"TetheredLyapunov.global_regularity u₀ ν h_divfree","TetheredLyapunov.global_regularity_scaffold u₀ ν h_divfree")
rep(C,'''    (τ : ℝ) (hτ : 0 < τ)
    (hrestart : ∀ t : ℝ, 0 ≤ t → (t : EReal) < Tstar u₀ ν →
      ∃ T' ∈ existenceTimes u₀ ν, t + τ ≤ T')
    (huniq : ∀ (T' : ℝ) (v : TimeDependentVelocity) (q : TimeDependentPressure),
      T' ∈ existenceTimes u₀ ν → v 0 = u₀ → NS_PDE v q ν →
      (∀ t ∈ Set.Icc (0 : ℝ) T', ContDiff ℝ (⊤ : ℕ∞) (v t)) →
      IsPhysicalNSSolution v →
      ∀ t ∈ Set.Icc (0 : ℝ) T', w.u t = v t) :''','''    (hcrit : TetheredLyapunov.PhysicalBKMContinuationCriterionFor u₀ ν)
    (huniq : TetheredLyapunov.KatoUniquenessOnExistenceTimes u₀ ν w) :''')
rep(C,'''  ⟨w.u, w.p, TetheredLyapunov.global_regularity_of_restart u₀ ν h_divfree h_smooth
    h_finite_energy h_pos_ν w
    (TetheredLyapunov.physicalFiniteTimeVorticityBound_of_uniform
      (TetheredLyapunov.physicalUniformVorticityCeiling_of_tetherBound hRiccati))
    τ hτ hrestart huniq⟩''','''  ⟨w.u, w.p, TetheredLyapunov.global_regularity_of_bkm_uniqueness u₀ ν h_pos_ν w
    (TetheredLyapunov.physicalFiniteTimeVorticityBound_of_uniform
      (TetheredLyapunov.physicalUniformVorticityCeiling_of_tetherBound hRiccati))
    hcrit huniq⟩''')
rep(C,'''Derived from the open `FrohmanianTetherBound` hypothesis plus the classical uniform-restart
and local-uniqueness binders, via `TetheredLyapunov.global_regularity_of_restart`.
`Tstar = ⊤` is *derived* (restart lemma), not assumed.''','''Derived from the open `FrohmanianTetherBound` hypothesis plus the classical
`PhysicalBKMContinuationCriterionFor` and `KatoUniquenessOnExistenceTimes`, via
`TetheredLyapunov.global_regularity_of_bkm_uniqueness`. `Tstar = ⊤` is derived from the
vorticity bound through the BKM criterion.''')
rep(C,"(tether bound + uniform restart)","(tether bound + BKM criterion)")
G="GlobalRegularity.lean"
rep(G,'''    (τ : ℝ) (hτ : 0 < τ)
    (hrestart : ∀ t : ℝ, 0 ≤ t → (t : EReal) < Tstar (u0 0) ν →
      ∃ T' ∈ existenceTimes (u0 0) ν, t + τ ≤ T')
    (huniq : ∀ (T' : ℝ) (v : TimeDependentVelocity) (q : TimeDependentPressure),
      T' ∈ existenceTimes (u0 0) ν →
      v 0 = u0 0 →
      NS_PDE v q ν →
      (∀ t ∈ Set.Icc (0 : ℝ) T', ContDiff ℝ (⊤ : ℕ∞) (v t)) →
      IsPhysicalNSSolution v →
      ∀ t ∈ Set.Icc (0 : ℝ) T', w.u t = v t) :''','''    (hcrit : TetheredLyapunov.PhysicalBKMContinuationCriterionFor (u0 0) ν)
    (huniq : TetheredLyapunov.KatoUniquenessOnExistenceTimes (u0 0) ν w) :''')
rep(G,'''    TetheredLyapunov.global_regularity_of_restart (u0 0) ν
      (fun x => h_div_free 0 x) h_smooth h_finite_energy h_ν_pos
      w (TetheredLyapunov.physicalFiniteTimeVorticityBound_of_uniform
          (TetheredLyapunov.physicalUniformVorticityCeiling_of_tetherBound hRiccati))
      τ hτ hrestart huniq''','''    TetheredLyapunov.global_regularity_of_bkm_uniqueness (u0 0) ν h_ν_pos
      w (TetheredLyapunov.physicalFiniteTimeVorticityBound_of_uniform
          (TetheredLyapunov.physicalUniformVorticityCeiling_of_tetherBound hRiccati))
      hcrit huniq''')
rep(G,'''    1 one_pos
    (fun t ht _ => ⟨t + 1, mem_existenceTimes_zero ν (by linarith), le_rfl⟩)''','''    (by
      intro u p _ hu0 _ T hT
      rw [hu0, Tstar_zero_eq_top] at hT
      exact absurd hT.symm (EReal.coe_ne_top T))''')
rep(G,"classical local-theory binders `w`, `hrestart`, `huniq`","classical local-theory binders `w`, `hcrit` (BKM continuation criterion), `huniq`")
rep(G,"`hRiccati = frohmanianTetherBound_zero ν`, `hrestart`,","`hRiccati = frohmanianTetherBound_zero ν`, `hcrit`,")
