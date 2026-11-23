Adds the Truth Gate, the GOD gate (read `TRUTH_GATE.md` first): `FrohmanianSymplecticTether/Semantics.lean`, `scripts/verify-lock.sh`, `.github/workflows/truth-gate.yml`, `TRUTH_GATE.md` and `TRUTH_GATE.lock`.

**Locked claim.** Conjunct (P4) of the paper's Master Product Theorem, quoted verbatim, with the paper's path, sha256 and section recorded. It reads: for C, κ'' > 0, every y : ℝ → ℝ differentiable at every s ≥ 0 with y'(s) ≤ C y(s)² − κ'' y(s)³ satisfies y(t) ≤ max(y(0), C/κ'') for t ≥ 0.
* `formal_claim` is the statement of `AnalyticPipeline.comparison_ode_stability`.
* `paper_claim` is an independent transcription of the sentence, with joint hypotheses bundled as written. It does not reference `formal_claim`.
* `intended_correspondence` is proved by rebundling the hypotheses. It is not `rfl` and does not use the theorem.

**Not locked: (P1)–(P3).** Their sentences depend on repository definitions (C1–C3, TetherKernel, the KKS form). The paper itself notes that the C1–C3 hypothesis class in (P1) may be empty, so those conjuncts may hold vacuously. This gate therefore certifies (P4) only. That is a scalar comparison fact. It does not show that NS vorticity obeys the inequality, does not prove global regularity, and makes no Clay claim.
