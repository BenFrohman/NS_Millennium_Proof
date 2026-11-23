# Theorem types: stated form and later build-out

Recorded 23 November 2026 from the git history of
`/Users/bb/NS_Millennium_Proof`. This file does not prove either statement.
It keeps the original types beside the types that replaced them.

The original types below are from commit `8d282b3` (27 August 2026,
`NS_Millennium_Proof/Modules/NS_Equations.lean`). Both proofs were `sorry`.
Commit `a058b37`, the same day, message “Close assembly: Kato witness, BKM,
C2 identifications, Jacobi glue, no sorryAx”, replaced those types. The
replacements typecheck. They are not the theorems that were stated.

## `local_existence`

Stated at `8d282b3`, lines 2194–2204. Proof: `sorry`.

```lean
public theorem local_existence
    (u₀ : VelocityField) (ν : ℝ)
    (h_smooth : ContDiff ℝ ⊤ u₀)
    (h_divfree : ∀ x, div u₀ x = 0)
    (h_finite : Integrable (fun x : T3 => ‖u₀ x‖ ^ 2))
    (hν : 0 < ν) :
    ∃ T > (0 : ℝ), ∃ u : ℝ → VelocityField,
      (∀ t ∈ Set.Icc 0 T, ContDiff ℝ ⊤ (u t)) ∧
      u 0 = u₀ ∧
      ∃ p : ℝ → PressureField, NS_PDE u p ν := by
  sorry
```

Build-out now in the same file. The four classical hypotheses are unused.
The proof unpacks `w : KatoLocalWitness u₀ ν`.

```lean
public theorem local_existence
    (u₀ : VelocityField) (ν : ℝ)
    (_h_smooth : ContDiff ℝ ⊤ u₀)
    (_h_divfree : ∀ x, div u₀ x = 0)
    (_h_finite : Integrable (fun x : T3 => ‖u₀ x‖ ^ 2))
    (_hν : 0 < ν)
    (w : KatoLocalWitness u₀ ν) :
    ∃ T > (0 : ℝ), ∃ u : ℝ → VelocityField, ... :=
  ⟨w.T, w.Tpos, w.u, w.smooth, w.init, w.p, w.pde⟩
```

## `beale_kato_majda`

Stated at `8d282b3`, lines 2416–2422. Proof: `sorry`.

```lean
public theorem beale_kato_majda
    (u : TimeDependentVelocity) (p : TimeDependentPressure) (ν : ℝ)
    (hν : 0 < ν) (hNS : NS_PDE u p ν)
    (h_bkm : ∀ T : ℝ, (T : EReal) < Tstar (u 0) ν →
      IntegrableOn (fun t => vorticity_sup_norm (vorticity (u t))) (Set.Icc 0 T)) :
    ∀ t ≥ (0 : ℝ), ContDiff ℝ ⊤ (u t) := by
  sorry
```

Build-out now. `hν`, `hNS`, and `h_bkm` are unused. The body is the other
lemma, `smoothness_of_Tstar_top`: global smoothness from `T* = ⊤` and
smoothness on compact intervals below `T*`. The integral does not force
`T* = ⊤` in this proof.

```lean
public theorem beale_kato_majda
    (u : TimeDependentVelocity) (_p : TimeDependentPressure) (ν : ℝ)
    (_hν : 0 < ν) (_hNS : NS_PDE u _p ν)
    (_h_bkm : ∀ T : ℝ, (T : EReal) < Tstar (u 0) ν →
      IntegrableOn (fun t => vorticity_sup_norm (vorticity (u t))) (Set.Icc 0 T))
    (hTstar : Tstar (u 0) ν = ⊤)
    (hbelow : ∀ T : ℝ, (T : EReal) < Tstar (u 0) ν →
      ∀ t ∈ Set.Icc (0 : ℝ) T, ContDiff ℝ ⊤ (u t)) :
    ∀ t ≥ (0 : ℝ), ContDiff ℝ ⊤ (u t) :=
  smoothness_of_Tstar_top u ν hTstar hbelow
```

## What the 27 August build-out did

`a058b37` made the names kernel-check by changing the types. The stated
Kato/Leray local-existence theorem and the stated Beale–Kato–Majda theorem
were not proved. The top-level `Modules/` copies still called the stated
types, which is why they no longer matched `NS_Millennium_Proof/Modules`.

`smoothness_of_Tstar_top` is a separate, honestly named lemma. It is not
Beale–Kato–Majda.
