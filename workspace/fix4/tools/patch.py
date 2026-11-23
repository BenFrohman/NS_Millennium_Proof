import sys,re,pathlib
def sub1(path, old, new, count=1):
    p=pathlib.Path(path); s=p.read_text()
    n=s.count(old)
    if n!=count: raise SystemExit(f"{path}: expected {count} got {n} for: {old[:80]!r}")
    p.write_text(s.replace(old,new))

PSB_DEF = '''/-- **Pointwise strain-by-sup-vorticity bound** `‖Du(x)‖ ≤ C · ‖ω‖_∞`.

This is **false in general**: the Biot–Savart / Riesz operators recovering `∇u` from `ω`
are Calderón–Zygmund operators, bounded on `Lᵖ` for `1 < p < ∞` but **not** on `L∞`
(CZ fails at `p = ∞`; the true bound carries a logarithmic loss). Every theorem that takes
this `Prop` as a hypothesis is therefore conditional on a bound that is false in general;
such theorems are linear-algebra consequences, not estimates for Navier–Stokes solutions. -/
@[expose] public def PointwiseStrainSupBound (u : VelocityField) (ω : VorticityField)
    (C : ℝ) (x : T3) : Prop :=
  ‖fderiv ℝ u x‖ ≤ C * vorticity_sup_norm ω

'''
def ns_equations(path):
    sub1(path, '''/-- Pointwise CZ/Biot–Savart bound `‖Du(x)‖ ≤ C_CZ ‖ω‖_∞` upgrades to''',
         PSB_DEF + '''/-- Pointwise CZ/Biot–Savart bound `‖Du(x)‖ ≤ C_CZ ‖ω‖_∞` upgrades to''')
    sub1(path, '''    (hCZ : ∀ x, ‖fderiv ℝ u x‖ ≤ C_CZ * vorticity_sup_norm (curl u))
    (_hbdd''', '''    (hCZ : ∀ x, PointwiseStrainSupBound u (curl u) C_CZ x)
    (_hbdd''')
    sub1(path, "the Riesz\ntheorem itself. -/\npublic theorem strain_sup_le_of_CZ",
         "the Riesz\ntheorem itself. Conditional on `PointwiseStrainSupBound`, which is false in\ngeneral at `L∞`. -/\npublic theorem strain_sup_le_of_CZ")

def closure(path):
    sub1(path, '''    (hCZ : ∀ x, ‖fderiv ℝ u x‖ ≤
      CalderonZygmundConstant3D * vorticity_sup_norm ω) :''',
      '''    (hCZ : ∀ x, PointwiseStrainSupBound u ω CalderonZygmundConstant3D x) :''')
    sub1(path, '''Linear algebra is `convective_norm_le_of_CZ`; the Riesz bound remains the
named CZ hyp. -/''', '''Linear algebra is `convective_norm_le_of_CZ`. Conditional on
`PointwiseStrainSupBound`, which is false in general at `L∞` (CZ fails at `p = ∞`). -/''')
    # continuation_under_global_existence
    sub1(path, '''    (w : KatoLocalWitness u₀ ν)
    (hRiccati : ∀ u : ℝ → VelocityField, ∀ p : ℝ → PressureField,
      NS_PDE u p ν → u 0 = u₀ →
        ∃ Y : ℝ,
          (∀ τ ≥ (0 : ℝ), vorticity_sup_norm (vorticity (u τ)) ≤ Y) ∧
          Continuous (fun τ : ℝ => vorticity_sup_norm (vorticity (u τ))))
    (hTstar''', '''    (w : KatoLocalWitness u₀ ν)
    (hRiccati : TetheredLyapunov.UniformVorticityCeiling u₀ ν)
    (hTstar''')
    sub1(path, '''    (w : KatoLocalWitness u₀ ν)
    (hRiccati : ∀ u : ℝ → VelocityField, ∀ p : ℝ → PressureField,
      NS_PDE u p ν → u 0 = u₀ →
        ∃ (C κ'' : ℝ), 0 < C ∧ 0 < κ'' ∧
          ∃ y : ℝ → ℝ,
            (∀ s ≥ (0 : ℝ), DifferentiableAt ℝ y s) ∧
            (∀ s ≥ (0 : ℝ), deriv y s ≤ C * (y s) ^ 2 - κ'' * (y s) ^ 3) ∧
            (∀ t ≥ (0 : ℝ), vorticity_sup_norm (vorticity (u t)) ≤ y t) ∧
            Continuous (fun τ : ℝ => vorticity_sup_norm (vorticity (u τ))))
    (hTstar''', '''    (w : KatoLocalWitness u₀ ν)
    (hRiccati : RiccatiMajorantExists u₀ ν)
    (hTstar''')
    sub1(path, '''/-- Sequential composition of the Symplectic Tether path.''', '''/-- **Riccati majorant hypothesis** (open for general data). Along every solution of the
unmodified equations from `u₀`, `M(t) = ‖ω(t)‖_∞` is continuous and is dominated by a
differentiable `y` obeying `y' ≤ C y² − κ'' y³` with `C, κ'' > 0`. A named, dischargeable
`Prop`; it is not proved for general data. -/
@[expose] public def RiccatiMajorantExists (u₀ : VelocityField) (ν : ℝ) : Prop :=
  ∀ u : ℝ → VelocityField, ∀ p : ℝ → PressureField,
    NS_PDE u p ν → u 0 = u₀ →
      ∃ (C κ'' : ℝ), 0 < C ∧ 0 < κ'' ∧
        ∃ y : ℝ → ℝ,
          (∀ s ≥ (0 : ℝ), DifferentiableAt ℝ y s) ∧
          (∀ s ≥ (0 : ℝ), deriv y s ≤ C * (y s) ^ 2 - κ'' * (y s) ^ 3) ∧
          (∀ t ≥ (0 : ℝ), vorticity_sup_norm (vorticity (u t)) ≤ y t) ∧
          Continuous (fun τ : ℝ => vorticity_sup_norm (vorticity (u τ)))

/-- Sequential composition of the Symplectic Tether path.''')
    sub1(path, "an explicit hypothesis (`hRiccati`); it is not proved here.",
         "the named hypothesis `RiccatiMajorantExists`; it is not proved here.")

PROPS = '''/-! ## Named open hypotheses (dischargeable `Prop`s)

Each conditional regularity theorem below takes one of these as an explicit argument.
None is proved for general data; a proof of the `Prop` discharges the theorem. -/

/-- **Uniform vorticity ceiling** (open for general data): along every solution of the
unmodified equations from `u₀`, `‖ω(t)‖_∞` is bounded uniformly in `t ≥ 0` and continuous. -/
@[expose] public def UniformVorticityCeiling (u₀ : VelocityField) (ν : ℝ) : Prop :=
  ∀ u : ℝ → VelocityField, ∀ p : ℝ → PressureField,
    NS_PDE u p ν → u 0 = u₀ →
      ∃ Y : ℝ,
        (∀ τ ≥ (0 : ℝ), vorticity_sup_norm (vorticity (u τ)) ≤ Y) ∧
        Continuous (fun τ : ℝ => vorticity_sup_norm (vorticity (u τ)))

/-- **Uniform vorticity ceiling on physical solutions** (open for general data): as
`UniformVorticityCeiling`, restricted to `IsPhysicalNSSolution` paths.
`FrohmanianTetherBound` implies it (`physicalUniformVorticityCeiling_of_tetherBound`). -/
@[expose] public def PhysicalUniformVorticityCeiling (u₀ : VelocityField) (ν : ℝ) : Prop :=
  ∀ u : ℝ → VelocityField, ∀ p : ℝ → PressureField,
    NS_PDE u p ν → u 0 = u₀ → IsPhysicalNSSolution u →
      ∃ Y : ℝ,
        (∀ τ ≥ (0 : ℝ), vorticity_sup_norm (vorticity (u τ)) ≤ Y) ∧
        Continuous (fun τ : ℝ => vorticity_sup_norm (vorticity (u τ)))

/-- **Cubic vorticity rate on physical solutions** (open for general data): along every
physical solution from `u₀`, `M(t) = ‖ω(t)‖_∞` is differentiable, continuous, and obeys
`M' ≤ C M² − κ'' M³` with `C, κ'' > 0`. No such cubic sink is known for the unmodified
equations. `FrohmanianTetherRate` implies it when `ν > 0`. -/
@[expose] public def PhysicalVorticityCubicRate (u₀ : VelocityField) (ν : ℝ) : Prop :=
  ∀ u : ℝ → VelocityField, ∀ p : ℝ → PressureField,
    NS_PDE u p ν → u 0 = u₀ → IsPhysicalNSSolution u →
      ∃ C κ'' : ℝ, 0 < C ∧ 0 < κ'' ∧
        (∀ s ≥ (0 : ℝ),
          DifferentiableAt ℝ (fun τ => vorticity_sup_norm (vorticity (u τ))) s) ∧
        (∀ s ≥ (0 : ℝ),
          deriv (fun τ => vorticity_sup_norm (vorticity (u τ))) s ≤
            C * vorticity_sup_norm (vorticity (u s)) ^ 2 -
              κ'' * vorticity_sup_norm (vorticity (u s)) ^ 3) ∧
        Continuous fun τ : ℝ => vorticity_sup_norm (vorticity (u τ))

public theorem physicalUniformVorticityCeiling_of_tetherBound
    {u₀ : VelocityField} {ν : ℝ} (h : FrohmanianTetherBound u₀ ν) :
    PhysicalUniformVorticityCeiling u₀ ν :=
  fun u p hNS hu0 hphys =>
    let ⟨Y, hb, hc, _⟩ := h u p hNS hu0 hphys
    ⟨Y, hb, hc⟩

public theorem physicalVorticityCubicRate_of_tetherRate
    {u₀ : VelocityField} {ν : ℝ} (hν : 0 < ν) (h : FrohmanianTetherRate u₀ ν) :
    PhysicalVorticityCubicRate u₀ ν :=
  fun u p hNS hu0 hphys =>
    let ⟨C, κ'', hC, hκ, hd, hdd, hc, _⟩ := h u p hν hNS hu0 hphys
    ⟨C, κ'', hC, hκ, hd, hdd, hc⟩

'''
def lyap(path):
    sub1(path, "public theorem global_regularity\n    (u₀", PROPS + "public theorem global_regularity\n    (u₀")
    sub1(path, '''    (w : KatoLocalWitness u₀ ν)
    (hRiccati : ∀ u : ℝ → VelocityField, ∀ p : ℝ → PressureField,
      NS_PDE u p ν → u 0 = u₀ →
        ∃ Y : ℝ,
          (∀ τ ≥ (0 : ℝ), vorticity_sup_norm (vorticity (u τ)) ≤ Y) ∧
          Continuous (fun τ : ℝ => vorticity_sup_norm (vorticity (u τ))))
''', '''    (w : KatoLocalWitness u₀ ν)
    (hRiccati : UniformVorticityCeiling u₀ ν)
''')
    sub1(path, '''    (w : KatoLocalWitness u₀ ν)
    (hRiccati : ∀ u : ℝ → VelocityField, ∀ p : ℝ → PressureField,
      NS_PDE u p ν → u 0 = u₀ → IsPhysicalNSSolution u →
        ∃ Y : ℝ,
          (∀ τ ≥ (0 : ℝ), vorticity_sup_norm (vorticity (u τ)) ≤ Y) ∧
          Continuous (fun τ : ℝ => vorticity_sup_norm (vorticity (u τ))))
''', '''    (w : KatoLocalWitness u₀ ν)
    (hRiccati : PhysicalUniformVorticityCeiling u₀ ν)
''', count=2)
    sub1(path, '''    (hDI : ∀ u : ℝ → VelocityField, ∀ p : ℝ → PressureField,
      NS_PDE u p ν → u 0 = u₀ → IsPhysicalNSSolution u →
        ∃ C κ'' : ℝ, 0 < C ∧ 0 < κ'' ∧
          (∀ s ≥ (0 : ℝ),
            DifferentiableAt ℝ
              (fun τ => vorticity_sup_norm (vorticity (u τ))) s) ∧
          (∀ s ≥ (0 : ℝ),
            deriv (fun τ => vorticity_sup_norm (vorticity (u τ))) s ≤
              C * vorticity_sup_norm (vorticity (u s)) ^ 2 -
                κ'' * vorticity_sup_norm (vorticity (u s)) ^ 3) ∧
          Continuous fun τ : ℝ => vorticity_sup_norm (vorticity (u τ)))
''', '''    (hDI : PhysicalVorticityCubicRate u₀ ν)
''')
    sub1(path, '''  have hRiccati :
      ∀ u : ℝ → VelocityField, ∀ p : ℝ → PressureField,
        NS_PDE u p ν → u 0 = u₀ → IsPhysicalNSSolution u →
          ∃ Y : ℝ,
            (∀ τ ≥ (0 : ℝ), vorticity_sup_norm (vorticity (u τ)) ≤ Y) ∧
            Continuous (fun τ : ℝ => vorticity_sup_norm (vorticity (u τ))) := by''',
       '''  have hRiccati : PhysicalUniformVorticityCeiling u₀ ν := by''')

def conj(path):
    sub1(path, "  ‖fderiv ℝ (u t) x‖ ≤ C * vorticity_sup_norm (vorticity (u t)) →\n",
         "  PointwiseStrainSupBound (u t) (vorticity (u t)) C x →\n")
    sub1(path, "vorticity equation: that the symplectic tether feedback reduces the stretching pairing\nfrom `C M³` to `(C M - κ M²) M²`. Recorded openly as an explicit `Prop`. -/",
         "vorticity equation: that the symplectic tether feedback reduces the stretching pairing\nfrom `C M³` to `(C M - κ M²) M²`. Recorded openly as an explicit `Prop`. Its strain\nantecedent is `PointwiseStrainSupBound`, which is false in general at `L∞`. -/")

if __name__=="__main__":
    globals()[sys.argv[1]](sys.argv[2])
