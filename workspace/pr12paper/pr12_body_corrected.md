## Scope: local Kato theory, not Navier–Stokes regularity

This PR proves `R3BKM.KatoMaximalSolution ν u₀` for `ν > 0` and smooth, divergence-free, Fefferman-decaying data on ℝ³. That is a **maximal Fefferman-class solution plus the H^3 blow-up alternative**: either the solution exists on `[0, ∞)`, or it exists on a finite `[0, T*)` and `‖u(t)‖²_{H^3}` is unbounded there. It also proves the H^3 Kato–Ponce right-derivative bound on the maximal time set.

**This PR does not prove global regularity, does not prove Clay / Fefferman (A), and does not solve any open problem.** `R3BKMContinuation ν` (below) is a conditional continuation statement: it assumes a uniform `‖ω‖_∞` ceiling. `clay_A_fefferman_of_rate` keeps `FrohmanianTetherRateSmooth` as an explicit hypothesis, and that hypothesis is **not proved** in this repository.

## Main theorems

`Scratch/KatoMaximal.lean`
- `KatoMaximal.katoMaximalSolution_of_feffermanDecay` (line 2103)
  `∀ {u₀}, ContDiff ℝ ∞ u₀ → FeffermanDecay u₀ → ∀ {ν}, 0 < ν → (∀ x, div u₀ x = 0) → R3BKM.KatoMaximalSolution ν u₀`
- `KatoMaximal.katoPonce_h3_energy_physicalMaximal` (2071): one `Ck ≥ 0` such that at every `s ∈ Smax`, `t ↦ ‖u(t)‖²_{H^3}` has a right derivative `d ≤ Ck ‖∇u(s)‖_∞ ‖u(s)‖²_{H^3}`
- `KatoMaximal.h3IBPVanishingFlux_physicalMaximal` (2036)
- `KatoMaximal.isFeffermanSolutionOn_physicalMaximal` (1809): Fefferman-class solution on every `[0, T) ⊆ Smax`
- `KatoMaximal.momentum_physicalMaximal` (1626), `KatoMaximal.energyInequality_physicalMaximal` (1793)
- `KatoMaximal.continuousOn_hsSq_physicalMaximal` (1193), `KatoMaximal.hsSq_blowup_alternative` (1229), `KatoMaximal.Smax_eq_Ici_or_Ico` (1052)

`Scratch/KatoContinuation.lean` (new)
- `KatoContinuation.r3BKMContinuation_of_pos` (41): `0 < ν → R3BKMContinuation ν`. Conditional continuation only, since the vorticity ceiling stays a hypothesis inside `R3BKMContinuationAt`. It uses `LogBoundLocal.bkmLogInequality`.
- `KatoContinuation.clay_A_fefferman_of_rate` (49): **conditional**. `(∀ ν > 0, ∀ u₀, ContDiff ℝ ∞ u₀ → (∀ x, div u₀ x = 0) → FeffermanDecay u₀ → FrohmanianTetherRateSmooth u₀ ν) → Clay_A_Fefferman`. The rate hypothesis is unproved.

`Scratch/R3BKMContinuation.lean`: the docstrings no longer say `KatoMaximalSolution` is OPEN. They now point to `katoMaximalSolution_of_feffermanDecay`.

## Axioms

Every theorem above prints `[propext, Classical.choice, Quot.sound]`.
`scripts/PrintScratchAxioms.lean`: `SCRATCH AUDIT SUMMARY: theorems audited: 235; clean: 235; violations: 0` and `SCRATCH AUDIT PASS`. `scripts/check_no_sorry.py`: no sorry/admit/native_decide and no axiom declarations.

## Commits and CI ("Lean certificate" workflow, all success)

| SHA | Content | Run |
|---|---|---|
| e542999 … 244d89f | momentum, energy, IsFeffermanSolutionOn and H^3 derivative formula on Smax | 43996668381 … 44002323558 |
| 251fb17 | IBP vanishing flux on Smax | 44003048326 |
| 7883c31 | Kato–Ponce bound on Smax | 44003661441 |
| 38082d6 | `katoMaximalSolution_of_feffermanDecay` | 44004176764 |
| 8316d07 | R3BKMContinuation docstrings | 44006440226 |
| 1570913 | `KatoContinuation` | 44006443019 |

Toolchain: `leanprover/lean4:v4.30.0-rc1`, Mathlib `v4.30.0-rc1`.

## Rebuild

```
bash scripts/verify.sh && lake build Scratch && lake env lean scripts/PrintScratchAxioms.lean
```

## Notes

- Truth Gate: `KatoMaximal.katoMaximalSolution_of_feffermanDecay`, `KatoContinuation.r3BKMContinuation_of_pos` and `KatoContinuation.clay_A_fefferman_of_rate` are locked (`kato`, `bkm`, `clayA` in `Scratch/FeffermanSemantics.lean`; lock record `fefferman-clay-a-conditional` in `TRUTH_GATE.lock`) to Theorems `thm:kato-proved`, `thm:r3bkm` and `thm:clayA-rate` of `papers/fefferman-clay-a-conditional/main.tex` (sha256 `14179f79141f4a2b596f6fc08194be737e2f4bec8235d8f14bfc44175fa939dd`), approved by the author 2026-11-17 00:22 CT. The truth-gate runs on the merge (44042177638) and on main `1ea649e` (44047249293) report `TRUTH GATE AUDIT PASS (Fefferman locks)`. The other theorems listed above are not under a Truth Gate lock.
- Merged 2026-11-17 01:53 CT as `ad546216d56b5ab7514f1ed20fe168744ff9cf74`.

