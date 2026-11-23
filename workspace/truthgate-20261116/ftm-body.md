Adds the Truth Gate, the GOD gate (read `TRUTH_GATE.md` first). The Lean package lives in `lean/`, so the gate files are `lean/MirrorMetriplectic/Semantics.lean`, `lean/scripts/verify-lock.sh` (with `truth_gate_check.py` and `TruthGateAudit.lean`), `lean/TRUTH_GATE.lock` and `lean/TRUTH_GATE.md`. A copy of `TRUTH_GATE.md` is at the root, and `.github/workflows/truth-gate.yml` runs in `lean/`. `lakefile.lean` adds `MirrorMetriplectic.Semantics` as a root so that `lake build` builds it.

**Locked claim.** The locked claim is the `riccati_bound` row of the appendix in `two_part/tether_two_part.tex`, "M' ≤ C − κ'M² ⇒ M ≤ max(M(0), √(C/κ'))", with C ≥ 0 and κ' > 0 from thm:cond. It is quoted verbatim, with the path and sha256 recorded.
* `formal_claim` is the statement of `riccati_bound`, which uses `HasDerivAt`.
* `paper_claim` uses `Differentiable ℝ M` and orders the hypotheses as the paper does.
* `intended_correspondence` is not `rfl` and does not use the theorem.

**Not locked.** `main.tex` states only conjectures. thm:cond as a whole is not locked either: its Dini-derivative form, T* = ∞ and Navier–Stokes smoothness rely on cited results that are not formalized. The Riccati hypothesis is not proved for Navier–Stokes, and nothing here bears on the Clay problem.

The gate was run locally and passed: static check, build, and a kernel audit showing standard axioms only.
