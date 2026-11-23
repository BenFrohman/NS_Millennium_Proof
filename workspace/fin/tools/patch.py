import sys,re
def sub(path, old, new, count=1):
    s=open(path).read()
    n=s.count(old)
    assert n==count, (path, old[:80], n)
    s=s.replace(old,new); open(path,'w').write(s)

TL, CB, GR = sys.argv[1], sys.argv[2], sys.argv[3]

# 1. new Props + bridges, inserted before global_regularity
NEW = r'''
/-! ## Finite-horizon vorticity control (the form Clay statement (B) needs)

Fefferman's statement (B) asks for smoothness on `[0, ∞)` and bounded energy. It does not
ask for a bound on `‖ω(t)‖_∞` that is uniform in `t`. The continuation arguments below only
use a bound on each compact interval `[0, T]`, with a constant allowed to depend on `T` and
on the data, or the Beale–Kato–Majda integrability `∫₀ᵀ ‖ω‖_∞ dt < ∞` for every `T`.
The uniform ceilings above are the stronger variants; each implies its finite-horizon form. -/

/-- **Finite-horizon vorticity bound** (open for general data): along every solution of the
unmodified equations from `u₀`, for every `T ≥ 0` there is `C(T)` with
`sup_{t ∈ [0,T]} ‖ω(t)‖_∞ ≤ C(T)`, and `t ↦ ‖ω(t)‖_∞` is continuous. -/
@[expose] public def FiniteTimeVorticityBound (u₀ : VelocityField) (ν : ℝ) : Prop :=
  ∀ u : ℝ → VelocityField, ∀ p : ℝ → PressureField,
    NS_PDE u p ν → u 0 = u₀ →
      (∀ T ≥ (0 : ℝ), ∃ C : ℝ,
        ∀ t ∈ Set.Icc (0 : ℝ) T, vorticity_sup_norm (vorticity (u t)) ≤ C) ∧
      Continuous (fun τ : ℝ => vorticity_sup_norm (vorticity (u τ)))

/-- **Finite-horizon vorticity bound on physical solutions** (open for general data):
`FiniteTimeVorticityBound` restricted to `IsPhysicalNSSolution` paths. -/
@[expose] public def PhysicalFiniteTimeVorticityBound (u₀ : VelocityField) (ν : ℝ) : Prop :=
  ∀ u : ℝ → VelocityField, ∀ p : ℝ → PressureField,
    NS_PDE u p ν → u 0 = u₀ → IsPhysicalNSSolution u →
      (∀ T ≥ (0 : ℝ), ∃ C : ℝ,
        ∀ t ∈ Set.Icc (0 : ℝ) T, vorticity_sup_norm (vorticity (u t)) ≤ C) ∧
      Continuous (fun τ : ℝ => vorticity_sup_norm (vorticity (u τ)))

/-- **Beale–Kato–Majda integrability** (open for general data): along every solution from
`u₀`, `t ↦ ‖ω(t)‖_∞` is integrable on `[0, T]` for every `T`, i.e. `∫₀ᵀ ‖ω‖_∞ dt < ∞`. -/
@[expose] public def BKMIntegrability (u₀ : VelocityField) (ν : ℝ) : Prop :=
  ∀ u : ℝ → VelocityField, ∀ p : ℝ → PressureField,
    NS_PDE u p ν → u 0 = u₀ →
      ∀ T : ℝ, IntegrableOn (fun t => vorticity_sup_norm (vorticity (u t))) (Set.Icc 0 T)

/-- `BKMIntegrability` restricted to `IsPhysicalNSSolution` paths. -/
@[expose] public def PhysicalBKMIntegrability (u₀ : VelocityField) (ν : ℝ) : Prop :=
  ∀ u : ℝ → VelocityField, ∀ p : ℝ → PressureField,
    NS_PDE u p ν → u 0 = u₀ → IsPhysicalNSSolution u →
      ∀ T : ℝ, IntegrableOn (fun t => vorticity_sup_norm (vorticity (u t))) (Set.Icc 0 T)

/-- Uniform ceiling ⇒ finite-horizon bound (take `C(T) = Y` for every `T`). -/
public theorem finiteTimeVorticityBound_of_uniform
    {u₀ : VelocityField} {ν : ℝ} (h : UniformVorticityCeiling u₀ ν) :
    FiniteTimeVorticityBound u₀ ν :=
  fun u p hNS hu0 =>
    let ⟨Y, hb, hc⟩ := h u p hNS hu0
    ⟨fun _T _hT => ⟨Y, fun t ht => hb t ht.1⟩, hc⟩

/-- Physical uniform ceiling ⇒ physical finite-horizon bound. -/
public theorem physicalFiniteTimeVorticityBound_of_uniform
    {u₀ : VelocityField} {ν : ℝ} (h : PhysicalUniformVorticityCeiling u₀ ν) :
    PhysicalFiniteTimeVorticityBound u₀ ν :=
  fun u p hNS hu0 hphys =>
    let ⟨Y, hb, hc⟩ := h u p hNS hu0 hphys
    ⟨fun _T _hT => ⟨Y, fun t ht => hb t ht.1⟩, hc⟩

/-- A function continuous on `ℝ` is integrable on every `[0, T]` (empty when `T < 0`). -/
public theorem integrableOn_Icc_zero_of_continuous
    (M : ℝ → ℝ) (hcont : Continuous M) (T : ℝ) :
    IntegrableOn M (Set.Icc (0 : ℝ) T) :=
  hcont.continuousOn.integrableOn_Icc

/-- Finite-horizon bound ⇒ BKM integrability on every `[0, T]`. -/
public theorem bkmIntegrability_of_finiteTime
    {u₀ : VelocityField} {ν : ℝ} (h : FiniteTimeVorticityBound u₀ ν) :
    BKMIntegrability u₀ ν :=
  fun u p hNS hu0 T =>
    integrableOn_Icc_zero_of_continuous _ (h u p hNS hu0).2 T

/-- Physical finite-horizon bound ⇒ physical BKM integrability. -/
public theorem physicalBKMIntegrability_of_finiteTime
    {u₀ : VelocityField} {ν : ℝ} (h : PhysicalFiniteTimeVorticityBound u₀ ν) :
    PhysicalBKMIntegrability u₀ ν :=
  fun u p hNS hu0 hphys T =>
    integrableOn_Icc_zero_of_continuous _ (h u p hNS hu0 hphys).2 T

/-- Global regularity from BKM integrability alone (finite-horizon input), with the
continuation hypotheses `hTstar`, `hbelow` as in `global_regularity`. -/
public theorem global_regularity_of_bkmIntegrability
    (u₀ : VelocityField) (ν : ℝ)
    (h_divfree : ∀ x, div u₀ x = 0)
    (h_smooth : ContDiff ℝ (⊤ : ℕ∞) u₀)
    (h_finite_energy : Integrable (fun x : T3 => ‖u₀ x‖ ^ 2))
    (h_pos_ν : ν > 0)
    (w : KatoLocalWitness u₀ ν)
    (hBKM : BKMIntegrability u₀ ν)
    (hTstar : ∀ u : ℝ → VelocityField, Tstar (u 0) ν = ⊤)
    (hbelow : ∀ u : ℝ → VelocityField,
      ∀ T : ℝ, (T : EReal) < Tstar (u 0) ν →
        ∀ t ∈ Set.Icc (0 : ℝ) T, ContDiff ℝ (⊤ : ℕ∞) (u t)) :
  ∃ (u : ℝ → VelocityField) (p : ℝ → PressureField),
    NS_PDE u p ν ∧
    u 0 = u₀ ∧
    (∀ t ≥ (0 : ℝ), ContDiff ℝ (⊤ : ℕ∞) (u t)) ∧
    (∀ t ≥ (0 : ℝ), vorticity_sup_norm (vorticity (u t)) ≥ 0) ∧
    (∀ t ≥ (0 : ℝ), ∀ x, div (u t) x = 0) := by
  obtain ⟨_Tloc, _hTloc, u, _hloc, hu0, _hphys, p, hNS⟩ :=
    local_existence u₀ ν h_smooth h_divfree h_finite_energy h_pos_ν w
  refine ⟨u, p, hNS, hu0, ?smooth, ?nn, ?div0⟩
  · exact beale_kato_majda u p ν h_pos_ν hNS
      (fun T _hT => hBKM u p hNS hu0 T) (hTstar u) (hbelow u)
  · intro t _ht
    exact vorticity_sup_norm_nonneg _
  · intro t ht x
    exact (hNS t ht x).2

public theorem global_regularity
'''
sub(TL, "\npublic theorem global_regularity\n", NEW)

# 2. global_regularity: finite-time
sub(TL, """    (w : KatoLocalWitness u₀ ν)
    (hRiccati : UniformVorticityCeiling u₀ ν)
    (hTstar""", """    (w : KatoLocalWitness u₀ ν)
    (hRiccati : FiniteTimeVorticityBound u₀ ν)
    (hTstar""")
sub(TL, """  obtain ⟨Y, hbound, hcont⟩ := hRiccati u p hNS hu0
  refine ⟨u, p, hNS, hu0, ?smooth, ?nn, ?div0⟩
  · exact AnalyticPipeline.bkm_regularity_pipeline u p ν h_pos_ν hNS Y hbound hcont
      (hTstar u) (hbelow u)""", """  refine ⟨u, p, hNS, hu0, ?smooth, ?nn, ?div0⟩
  · exact beale_kato_majda u p ν h_pos_ν hNS
      (fun T _hT => bkmIntegrability_of_finiteTime hRiccati u p hNS hu0 T)
      (hTstar u) (hbelow u)""")
sub(TL, "uniform bound from the majorant to the vorticity", "finite-horizon bound on each [0,T] to the vorticity")
# 3. of_restart and of_kato_estimates
sub(TL, "    (hRiccati : PhysicalUniformVorticityCeiling u₀ ν)\n", "    (hRiccati : PhysicalFiniteTimeVorticityBound u₀ ν)\n", 2)
sub(TL, """  obtain ⟨Y, hbound, hcont⟩ := hRiccati w.u w.p w.pde hu0 w.phys
  refine ⟨w.pde, hu0, ?smooth, ?nn, ?div0⟩
  · exact AnalyticPipeline.bkm_regularity_pipeline w.u w.p ν h_pos_ν w.pde
      Y hbound hcont (by rw [hu0]; exact hTstar) hbelow""", """  refine ⟨w.pde, hu0, ?smooth, ?nn, ?div0⟩
  · exact beale_kato_majda w.u w.p ν h_pos_ν w.pde
      (fun T _hT => physicalBKMIntegrability_of_finiteTime hRiccati w.u w.p w.pde hu0
        w.phys T)
      (by rw [hu0]; exact hTstar) hbelow""")
sub(TL, """  obtain ⟨Y, _hbound, _hcont⟩ := hRiccati w.u w.p w.pde w.init w.phys
  exact""", """  obtain ⟨C₀, _hC₀⟩ := (hRiccati w.u w.p w.pde w.init w.phys).1 0 le_rfl
  exact""")
sub(TL, "    h_pos_ν w hRiccati (katoRestartTime C Y (max R 1))\n    (katoRestartTime_pos C Y (max R 1)) (hrestart Y) huniq",
        "    h_pos_ν w hRiccati (katoRestartTime C C₀ (max R 1))\n    (katoRestartTime_pos C C₀ (max R 1)) (hrestart C₀) huniq")
sub(TL, "time `katoRestartTime C Y (max R 1)` from the log-Gronwall / quadratic\ncomparison (Drive Steps 3.2–3.4). `Y` is the Riccati ceiling; `R` is the\nSobolev proxy at time 0. -/",
        "time `katoRestartTime C C₀ (max R 1)` from the log-Gronwall / quadratic\ncomparison (Drive Steps 3.2–3.4). `C₀` is the finite-horizon vorticity bound on `[0, 0]`;\n`hrestart` is assumed for every ceiling value. `R` is the Sobolev proxy at time 0. -/")
sub(TL, """    exact riccati_ceiling_of_vorticity_di u C κ'' hC hκ hdiff hDIu hcont
  have hrestart :=""", """    exact riccati_ceiling_of_vorticity_di u C κ'' hC hκ hdiff hDIu hcont
  have hFin : PhysicalFiniteTimeVorticityBound u₀ ν :=
    physicalFiniteTimeVorticityBound_of_uniform hRiccati
  have hrestart :=""")
sub(TL, "    h_pos_ν w hRiccati τ hτ hrestart huniq\n\n#print", "    h_pos_ν w hFin τ hτ hrestart huniq\n\n#print")
s=open(TL).read()
s=s.replace("#print axioms global_regularity_of_kato_estimates\n", """#print axioms global_regularity_of_kato_estimates
#print axioms finiteTimeVorticityBound_of_uniform
#print axioms physicalFiniteTimeVorticityBound_of_uniform
#print axioms bkmIntegrability_of_finiteTime
#print axioms physicalBKMIntegrability_of_finiteTime
#print axioms global_regularity_of_bkmIntegrability
#print axioms global_regularity
""",1); open(TL,'w').write(s)

# ClosureBlueprint
sub(CB, "    (hRiccati : TetheredLyapunov.UniformVorticityCeiling u₀ ν)\n", "    (hRiccati : TetheredLyapunov.FiniteTimeVorticityBound u₀ ν)\n")
sub(CB, """    (fun u p hNS hu0 hphys =>
      let ⟨Y, hb, hc, _⟩ := hRiccati u p hNS hu0 hphys
      ⟨Y, hb, hc⟩) τ hτ hrestart huniq⟩""", """    (TetheredLyapunov.physicalFiniteTimeVorticityBound_of_uniform
      (TetheredLyapunov.physicalUniformVorticityCeiling_of_tetherBound hRiccati))
    τ hτ hrestart huniq⟩""")
# GlobalRegularity
sub(GR, """      w (fun u p hNS hu0 hphys =>
          let ⟨Y, hb, hc, _⟩ := hRiccati u p hNS hu0 hphys
          ⟨Y, hb, hc⟩) τ hτ hrestart huniq""", """      w (TetheredLyapunov.physicalFiniteTimeVorticityBound_of_uniform
          (TetheredLyapunov.physicalUniformVorticityCeiling_of_tetherBound hRiccati))
      τ hτ hrestart huniq""")
print("ok")
