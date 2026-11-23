# The Frohmanian Tether on the Coadjoint Orbit: A Lean-Synchronized Statement

Benjamin Stanley Frohman (B.S. Frohman) · ORCID 0009-0006-7068-3718 · Independent Researcher, Texas, United States · frohmanbenjamin@gmail.com
Version 1.0.0 · 11 November 2026 · DOI 10.5281/zenodo.23940666

**Scope.** Not a Clay Millennium claim. Not peer reviewed. Nothing here proves existence, smoothness or global regularity of 3D Navier–Stokes solutions. The note reproduces the author's 4 November 2026 draft verbatim and labels every claim proved / conditional / open / refuted / not formalized against the Lean development at the pinned commit. Where the draft and the Lean disagree, the Lean wins and the disagreement is shown in a marked "Lean correction" box.

At this pin, periodic Beale–Kato–Majda continuation is proved (`periodicBKMContinuation_of_classical` in `FrohmanianTether/Pillars/BKMContinuation.lean`). The main periodic theorems `clay_B_exact_of_periodic_tether_closing_bound` and `clay_B_exact_unique_of_periodic_tether_closing_bound` are conditional on the single open hypothesis `PeriodicTetherClosingBound` (as hard as Clay (B)). This is not a proof of Clay (B).

PR #4 (merge commit `0698d08`, included in this pin) added the repaired rate `FeffermanClayA.FrohmanianTetherRateSmooth` and the conditional theorem `FeffermanClayA.clay_A_fefferman_of_frohmanianTetherRateSmooth`. Both hypotheses of that theorem remain open for general data and are only shown satisfiable at `u₀ = 0`. This is not a proof of Clay (A). The unrestricted `FrohmanianTetherRate` remains refuted (`not_forall_frohmanianTetherRate`).

## Files

| File | Contents |
|---|---|
| `main.pdf` | The note (preview file) |
| `main.tex`, `frohman-paper.sty` | LaTeX source (XeLaTeX / tectonic: `tectonic main.tex`) |
| `original_draft.md` | The author's 4 November 2026 draft, raw and unedited |
| `frohmanian-tether-sdiff-4aba751.zip` | `git archive` of BenFrohman/frohmanian-tether-sdiff at the pinned commit |
| `axioms.txt` | Strict axiom audit output (CI artifact `axioms-push-43107567565`) |
| `print_axioms.txt` | `#print axioms` for the headline theorems (same artifact) |
| `SHA256SUMS` | Checksums of the files above |

## Pinned Lean development

- Repository: https://github.com/BenFrohman/frohmanian-tether-sdiff
- Commit: `4aba751d2d365faf0cc48c5b46e9aa0113519273` (main, 11 Nov 2026, merge of PR #5)
- Toolchain: `leanprover/lean4:v4.30.0-rc1`
- Mathlib: `0c154d67103f74be3a0f2c509f72ccbf5be9f2a7`
- CI: "Lean certificate" run https://github.com/BenFrohman/frohmanian-tether-sdiff/actions/runs/43107567565 (success, `VERIFY OK`); "Lean 4" run https://github.com/BenFrohman/frohmanian-tether-sdiff/actions/runs/43107567433 (success). The pull-request certificate for the same tree is https://github.com/BenFrohman/frohmanian-tether-sdiff/actions/runs/43105941627 (identical axiom artifact).

Axiom audit summary:

```
AUDIT SUMMARY: theorems audited: 1886 (1674 stated in the sources, 212 auto-generated equation/congruence/injectivity lemmas); declarations audited: 2546; violations: 0
AUDIT PASS: only propext, Classical.choice, Quot.sound; no sorryAx; no axiom declarations
```

## Rebuild (one command)

```
git clone https://github.com/BenFrohman/frohmanian-tether-sdiff && cd frohmanian-tether-sdiff && git checkout 4aba751d2d365faf0cc48c5b46e9aa0113519273 && bash scripts/verify.sh
```

## Related works (cross-referenced, not re-released)

- sdiff formalization (concept DOI; latest published v0.1.5): https://doi.org/10.5281/zenodo.24081999 (v0.1.5: https://doi.org/10.5281/zenodo.24122596)
- The Frohmanian Tether on SDiff(T³) (geometric): https://doi.org/10.5281/zenodo.23956935
- Written Proofs Companion: https://doi.org/10.5281/zenodo.23942463
- A Tether That Holds Nothing: https://doi.org/10.5281/zenodo.23971661

© 2026 Benjamin Stanley Frohman. Licensed under the Apache License, Version 2.0.
