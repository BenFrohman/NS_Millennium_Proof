# The Frohmanian Symplectic Tether — Zenodo record v1.3.0 (correction)

Author: Benjamin Stanley Frohman (B.S. Frohman), ORCID 0009-0006-7068-3718,
Independent Researcher, Texas, United States. Contact: frohmanbenjamin@gmail.com.
Copyright (c) 2026 Benjamin Stanley Frohman. Released under the Apache License 2.0.

**Conditional result. Not a Clay Millennium claim.** Nothing in this record
proves global regularity for the 3D Navier–Stokes equations.

## What this version corrects

1. **P5 withdrawn.** Versions up to 1.2.0 described a fifth component P5 as
   "every physical flow governed by the Frohmanian tethered dynamics extends
   smoothly to all t ∈ [0, ∞)". That was an overclaim. The Lean conjunct
   `P5_TetheredGlobalRegularityAndNonVacuity` in the archived v1.1.0 zip states
   only (a) that one discontinuous step field is not an `IsPhysicalNSSolution`,
   and (b) that for every ν > 0 the zero datum u₀ ≡ 0 has the zero flow as a
   smooth solution, unique among smooth solutions with zero data. It says
   nothing about non-zero data. P5 was removed from the Lean, README and paper
   (commit 0ebbb2f); the product theorem is now P1 ∧ P2 ∧ P3 ∧ P4.
2. **T3 is ℝ³, not the torus.** The Lean type `T3` is
   `EuclideanSpace ℝ (Fin 3)` with Lebesgue measure. The hypothesis
   ∫_{ℝ³} ‖u₀‖² < ∞ forces every ℤ³-periodic datum to be zero, so
   `global_regularity_for_NS` is not a periodic (torus) result, and for
   periodic data it is vacuous. It is also conditional on the open
   `FrohmanianTetherBound` and on the unproved local-theory hypotheses
   `KatoLocalWitness`, `PhysicalBKMContinuationCriterionFor` and
   `KatoUniquenessOnExistenceTimes`.

## Files

| File | Content |
|---|---|
| `Frohmanian_Symplectic_Tether_Uniqueness_and_Global_Regularity_2026.pdf` | Corrected paper (preview file) |
| `Frohmanian_Symplectic_Tether_Uniqueness_and_Global_Regularity_2026.tex` | LaTeX source of the paper |
| `frohmanian-symplectic-tether-regularity-6ee4c5687b44f8b7175fb2c8174cc857228be416.zip` | GitHub archive of the Lean 4 repository at the exact commit below |
| `AxiomAudit_output_*.txt` | Output of `lake env lean AxiomAudit.lean` from GitHub Actions CI |
| `SHA256SUMS` | SHA-256 checksums of the files above |

## Reproducibility

- Repository: `BenFrohman/frohmanian-symplectic-tether-regularity`
- Commit: `6ee4c5687b44f8b7175fb2c8174cc857228be416`
- Toolchain: `leanprover/lean4:v4.30.0-rc1`
- Mathlib: `0c154d67103f74be3a0f2c509f72ccbf5be9f2a7` (pinned in `lake-manifest.json`)
- Axiom audit: `TOTAL theorems=595 nonstandard=0`; every audited theorem
  depends only on `[propext, Classical.choice, Quot.sound]`; 0 `sorry`.
  Source count (comment-aware): 531 `theorem`/`lemma` declarations in 20 modules.

Rebuild (from the unzipped archive):

```
lake exe cache get && lake build && lake env lean AxiomAudit.lean
```
