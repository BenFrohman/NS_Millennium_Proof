Adds the Truth Gate, the GOD gate (read `TRUTH_GATE.md` first): `WeightedEnstrophy/Semantics.lean`, `scripts/verify-lock.sh`, `.github/workflows/truth-gate.yml`, `TRUTH_GATE.md` and `TRUTH_GATE.lock`.

**Locked claim.** Identity (1), dE/dt = P − ν∫|∇ω|² with E = ½∫|ω|², for the paper's smooth periodic model (`Smooth.enstrophy_identity_smooth`). The quotes are verbatim: the theorem, the smooth-model theorem, the Setting equations (div) and (vort), and the smooth-model definitions of ∂ₖ, ∂ₜ and I. The path and sha256 are recorded.
* `formal_claim` is the repository statement. It is phrased in the subalgebra `Smooth.A` with `div`, `VorticityEq`, `vsq`, `stretch` and `gradSq`, in the factor-2 form.
* `paper_claim` uses plain functions ℝ×ℝ³ → ℝ that are C^∞ and 1-periodic, with `fderiv` directional derivatives and iterated interval integrals ∫₀¹∫₀¹∫₀¹. Its conclusion is the paper's ½-form at every t.
* `intended_correspondence` packages functions into `Smooth.A` and back, and converts the factor-2 form into the ½-form. It is not `rfl` and does not use the theorem. Compiled locally.

Scope: an exact identity. It gives no bound, makes no regularity claim, and the Clay problem remains open.
