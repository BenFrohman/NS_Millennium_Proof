Adds the Truth Gate, the GOD gate (read `TRUTH_GATE.md` first): `MetriplecticWorldModel/Semantics.lean`, `scripts/verify-lock.sh`, `.github/workflows/truth-gate.yml`, `TRUTH_GATE.md` and `TRUTH_GATE.lock`.

**Locked claim.** `paper/metriplectic-world-model.tex`, section `sec:ceiling`: theorem `uniform_ceiling`, quoted verbatim, with its path and sha256 recorded. It reads: if M' ≤ CM² − κM³ and κ > 0, then M(t) ≤ max(M(0), max(C/κ, 0)) for t ≥ 0.
* `formal_claim` is the statement of `MetriplecticWorldModel.uniform_ceiling`. It takes the derivative as a separate function `M'` with `HasDerivAt M (M' t) t`.
* `paper_claim` is an independent transcription. In it, M is differentiable on t ≥ 0, M' is `deriv M`, and the ceiling is written out as `max (M 0) (max (C/κ) 0)`.
* `intended_correspondence` identifies `M'` with `deriv M` via `HasDerivAt.deriv` and unfolds `ceiling`. It is not `rfl` and does not use the theorem.

Scope: a comparison-ODE fact inside the tethered model. It makes no statement about unmodified Navier–Stokes and no Clay claim.
