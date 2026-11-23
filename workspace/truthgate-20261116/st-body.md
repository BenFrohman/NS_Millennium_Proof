Adds the Truth Gate, the GOD gate (read `TRUTH_GATE.md` first): `TetherMayForm/Semantics.lean`, `scripts/verify-lock.sh`, `.github/workflows/truth-gate.yml`, `TRUTH_GATE.md` and `TRUTH_GATE.lock`.

**Drift found and fixed by rewriting the formalization, not the lock.** The paper's Theorem `thm:routeA` (Route A determines κ) assumes only ω ⊥ u, ‖ω‖ = 1, w ≠ 0 and the matching T[κ,w,u](ω,ω) + S w = 0, plus the section's standing assumptions dim H ≥ 3 and u ≠ 0. The existing `routeA_determines_kappa` assumes the full `RouteAFeedback` structure, which also requires nonpositivity (so κ w ≥ 0) and reduced Jacobi. It therefore does not certify the paper's sentence when κ w < 0. This PR adds `routeA_determines_kappa_of_matching` with exactly the paper's hypotheses, using the same proof. The old theorem is kept unchanged.

**Locked claim.** `paper/companion.tex`, section `sec:geom`: the standing assumptions and the first two sentences of `thm:routeA`, quoted verbatim.
* `formal_claim`: the statement of `Frohman.Tether.routeA_determines_kappa_of_matching`.
* `paper_claim`: the paper's sentence, with Π_u x = x − (⟨u,x⟩/‖u‖²) u and T(F,G) = −(κw)⟨Π_u F, Π_u G⟩ written out by the paper's formulas rather than the library's `piU` and `frohmanianTether`, and ω ⊥ u written as ⟨ω,u⟩ = 0.
* `intended_correspondence` is proved by unfolding the library definitions into the paper's formulas (`frohmanianTether_apply`, `piU_apply`, `real_inner_comm`). It does not use the main theorem.

Scope: S is supplied, not derived. The Frohmanian Tether Hypothesis stays open, and no regularity or Millennium claim is made.
