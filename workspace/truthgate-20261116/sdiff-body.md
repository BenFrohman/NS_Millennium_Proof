Adds the Truth Gate, the GOD gate (read `TRUTH_GATE.md` first): `FrohmanianTether/Semantics.lean`, `scripts/verify-lock.sh`, `.github/workflows/truth-gate.yml`, `TRUTH_GATE.md` and `TRUTH_GATE.lock`.

**Locked claim.** `manuscript/main.tex` (sha256 `b1e6a8e9…880de9`), Section 2, Theorem `thm:mainA` ("Main theorem, kernel-checked"), quoted verbatim in `Semantics.lean` and `TRUTH_GATE.md`.

* `formal_claim`: the statement of `ClayStatements.clay_B_exact_of_periodic_tether_bound`, i.e. `(∀ ν>0, PeriodicTetherClosingBound ν) → (∀ ν>0, PeriodicBKMContinuation ν) → Clay_B_exact`.
* `paper_claim`: the paper's theorem as worded. It takes (i) and (ii) jointly for every ν>0, and spells out the conclusion clause by clause: smooth, divergence-free, ℤ³-periodic u₀ ⇒ ∃ (u,p) jointly C^∞ on [0,∞)×ℝ³, Navier–Stokes with zero forcing, u(0)=u₀, u(t), p(t) periodic for t≥0. It does not mention `formal_claim`, `Clay_B_exact` or `IsPeriodicSmoothSolution`.
* `intended_correspondence` is proved at the statement level and does not use the main theorem. `paper_claim_holds` is the main theorem transported across it.

**Scope: CONDITIONAL.** Hypothesis (i) is open and as strong as statement (B). This is not a proof of the Navier–Stokes Millennium problem.

Locally: the static gate passes, `lake build FrohmanianTether.Semantics` succeeds, and the kernel audit passes with only propext, Classical.choice and Quot.sound.

This PR touches none of the files in open PR #8 (`.gitignore`, `certificates/gaps-ledger-axioms.txt`, `scripts/PrintGapsLedgerAxioms.lean`, `scripts/verify.sh`).
