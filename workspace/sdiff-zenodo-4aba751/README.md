# The Frohmanian Tether Bound Implies Global Smoothness on T³ under Beale–Kato–Majda Continuation, and Implies BKM Integrability

Benjamin Stanley Frohman (B.S. Frohman) · ORCID 0009-0006-7068-3718 · Independent Researcher, Texas, United States · frohmanbenjamin@gmail.com

Version 0.1.6 · 11 November 2026 · this version's DOI 10.5281/zenodo.24148268 · concept DOI 10.5281/zenodo.24081999 · new version of 10.5281/zenodo.24122596

**Scope.** Preprint. Not peer reviewed. All main results are conditional. This record is not a proof of global regularity of the 3D Navier–Stokes equations and makes no Clay Millennium claim.

## What is new in 0.1.6 (BKM continuation pillar)

At commit `4aba751d2d365faf0cc48c5b46e9aa0113519273` (merge of PR #5 on main, 11 November 2026), periodic Beale–Kato–Majda continuation is proved:

- `FrohmanianTether.Pillars.periodicBKMContinuation_of_classical` in `FrohmanianTether/Pillars/BKMContinuation.lean`: `0 < ν → PeriodicBKMContinuation ν`.

The Main Theorem therefore needs only the still-open tether closing bound (as hard as Fefferman's statement (B)):

- `clay_B_exact_of_periodic_tether_closing_bound (hclose : ∀ ν > 0, PeriodicTetherClosingBound ν) : Clay_B_exact`
- `clay_B_exact_unique_of_periodic_tether_closing_bound` (same hypothesis; unique global velocity)

This is not a proof of statement (B). The two-hypothesis form `clay_B_exact_of_periodic_tether_bound` remains, with `hBKM` now supplied by the pillar.

The same commit includes PR #4: the repaired rate `FeffermanClayA.FrohmanianTetherRateSmooth` and the conditional reduction `FeffermanClayA.clay_A_fefferman_of_frohmanianTetherRateSmooth` of Fefferman's Problem (A). Both hypotheses of that theorem remain open for general data and are only shown satisfiable at `u₀ = 0`. This is not a proof of Clay (A). The unrestricted `FrohmanianTetherRate` remains refuted (`not_forall_frohmanianTetherRate`).

## Files

| File | Contents |
|---|---|
| `frohmanian-tether-sdiff-0.1.6.pdf` | The paper (preview file) |
| `frohmanian-tether-sdiff-0.1.6.tex` | LaTeX source of the paper |
| `frohmanian-tether-sdiff-0.1.6-manuscript-source.zip` | Paper TeX plus the `lean/` snippet files needed to rebuild (`tectonic main.tex`) |
| `frohmanian-tether-sdiff-0.1.6-source.zip` | `git archive` of BenFrohman/frohmanian-tether-sdiff at `4aba751` |
| `axioms.txt` | Strict axiom audit (CI artifact `axioms-push-43107567565`) |
| `print_axioms.txt` | `#print axioms` for the headline theorems (same artifact) |
| `CERTIFICATE.md` | Verification certificate from the pinned commit |
| `SHA256SUMS` | Checksums of the files above |

## Pinned Lean development

- Repository: https://github.com/BenFrohman/frohmanian-tether-sdiff
- Commit: `4aba751d2d365faf0cc48c5b46e9aa0113519273` (main, 11 Nov 2026)
- Toolchain: `leanprover/lean4:v4.30.0-rc1`
- Mathlib: `0c154d67103f74be3a0f2c509f72ccbf5be9f2a7`
- CI: "Lean certificate" https://github.com/BenFrohman/frohmanian-tether-sdiff/actions/runs/43107567565 (success, `VERIFY OK`); "Lean 4" https://github.com/BenFrohman/frohmanian-tether-sdiff/actions/runs/43107567433 (success). Pull-request certificate for the same tree: https://github.com/BenFrohman/frohmanian-tether-sdiff/actions/runs/43105941627 (identical axiom artifact).

Axiom audit summary:

```
AUDIT SUMMARY: theorems audited: 1886 (1674 stated in the sources, 212 auto-generated equation/congruence/injectivity lemmas); declarations audited: 2546; violations: 0
AUDIT PASS: only propext, Classical.choice, Quot.sound; no sorryAx; no axiom declarations
```

## Rebuild (one command)

```
git clone https://github.com/BenFrohman/frohmanian-tether-sdiff && cd frohmanian-tether-sdiff && git checkout 4aba751d2d365faf0cc48c5b46e9aa0113519273 && bash scripts/verify.sh
```

© 2026 Benjamin Stanley Frohman. Licensed under the Apache License, Version 2.0.
