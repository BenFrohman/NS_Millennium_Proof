Adds the Truth Gate, the GOD gate (read `TRUTH_GATE.md` first): `TorusFourierNS/Semantics.lean`, `scripts/verify-lock.sh`, `.github/workflows/truth-gate.yml`, `TRUTH_GATE.md` and `TRUTH_GATE.lock`.

**Locked claim.** `paper/main.tex`, Theorem `heat_smoothing`, quoted verbatim, together with the paper's verbatim definitions of f̂, of e^{tνΔ} (its coefficients are e^{-ν|n|²t} f̂(n)) and of ‖·‖_{H^s}. The path and sha256 are recorded.
* `formal_claim` is the statement of `TorusFourierNS.heat_smoothing`. It uses the repository's `heat`, `InHs`, `HsSq`, `coeff` and `nsq`.
* `paper_claim` uses only Mathlib's `mFourierCoeff` and the paper's formulas. It quantifies over any L² function g whose coefficients are e^{-ν|n|²t} f̂(n).
* `intended_correspondence` identifies g with `heat f` by injectivity of the Fourier coefficient map and unfolds the definitions. It is not `rfl` and does not use the theorem.

Scope: a Fourier-side smoothing estimate. It proves no NS existence or regularity, and the Clay problem remains open.
