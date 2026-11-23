import sys
for p in sys.argv[1:]:
    s=open(p).read()
    def rep(o,n):
        global s; assert s.count(o)==1,(o[:50],s.count(o)); s=s.replace(o,n)
    rep('''    (τ : ℝ) (hτ : 0 < τ)
    (hrestart : ∀ u₀ : VelocityField, ∀ t : ℝ, 0 ≤ t → (t : EReal) < Tstar u₀ ν →
      ∃ T' ∈ existenceTimes u₀ ν, t + τ ≤ T')
    (huniq : ∀ (u₀ : VelocityField) (w : KatoLocalWitness u₀ ν)
      (T' : ℝ) (v : TimeDependentVelocity) (q : TimeDependentPressure),
      T' ∈ existenceTimes u₀ ν → v 0 = u₀ → NS_PDE v q ν →
      (∀ t ∈ Set.Icc (0 : ℝ) T', ContDiff ℝ (⊤ : ℕ∞) (v t)) →
      IsPhysicalNSSolution v →
      ∀ t ∈ Set.Icc (0 : ℝ) T', w.u t = v t)''','''    (hcrit : ∀ u₀ : VelocityField, TetheredLyapunov.PhysicalBKMContinuationCriterionFor u₀ ν)
    (huniq : ∀ (u₀ : VelocityField) (w : KatoLocalWitness u₀ ν),
      TetheredLyapunov.KatoUniquenessOnExistenceTimes u₀ ν w)''')
    rep("(hKato u₀ hsm hdiv hE) (hclose u₀ hdiv hsm hE) τ hτ (hrestart u₀)","(hKato u₀ hsm hdiv hE) (hclose u₀ hdiv hsm hE) (hcrit u₀)")
    rep('''    1 one_pos
    (fun t ht _ => ⟨t + 1, mem_existenceTimes_zero ν (by linarith), le_rfl⟩)''','''    (by
      intro u p _ hu0 _ T hT
      rw [hu0, Tstar_zero_eq_top] at hT
      exact absurd hT.symm (EReal.coe_ne_top T))''')
    rep("`hRiccati = frohmanianTetherBound_zero ν`, `hrestart`,","`hRiccati = frohmanianTetherBound_zero ν`, `hcrit`,")
    open(p,'w').write(s)
