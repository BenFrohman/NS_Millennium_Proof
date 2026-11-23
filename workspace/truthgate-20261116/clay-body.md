Adds the Truth Gate, the GOD gate (read `TRUTH_GATE.md` first). The Lean package lives in `lean/`, so the gate files are `lean/Clay/Semantics.lean`, `lean/scripts/verify-lock.sh` (with `truth_gate_check.py` and `TruthGateAudit.lean`), `lean/TRUTH_GATE.lock` and `lean/TRUTH_GATE.md`. A copy of `TRUTH_GATE.md` is at the repo root, and `.github/workflows/truth-gate.yml` runs in `lean/`.

**Locked claim (CONDITIONAL).** The locked claim is the paper's theorem `feffermanStatementB_of_bkm`: "PeriodicMaximalSolutionWithBKM and PeriodicBKMIntegrability together imply Statement (B)". The following are quoted verbatim, with the path and sha256 recorded:
* Section "Statement (B)";
* the paper's prose definitions of both hypotheses;
* the theorem;
* the scope sentence.

**The three Lean statements:**
* `formal_claim` is `PeriodicMaximalSolutionWithBKM → PeriodicBKMIntegrability → FeffermanStatementB`.
* `paper_claim` spells out both hypotheses and Statement (B) from the paper's English, with its own definitions (`pPart`, `pData`, `pSolution`, `pVortSup`):
  * "for all admissible data there are T* ∈ (0,∞] and a smooth solution on [0,T*) with T* < ∞ ⇒ ∫₀^{T*}‖ω‖_∞ = ∞";
  * "every smooth solution on a finite interval [0,T) (real T) has ∫₀ᵀ‖ω‖_∞ < ∞";
  * Statement (B) on [0,∞)×ℝ³.
* `intended_correspondence` proves that the readings agree:
  * it converts `T : ℝ≥0∞`, `T ≠ ⊤` to and from a real `T` with `Ico 0 T`;
  * it converts `¬(… < ⊤)` to and from `= ⊤`;
  * it converts bundled periodicity to and from coordinatewise periodicity.
  * It is not `rfl` and does not use the theorem.

**Reading note.** ‖ω(t)‖_{L^∞} is read as sup_x |ω(t,x)|. This is the same as the L^∞ norm for continuous ω, but the gate does not prove that in Lean.

`PeriodicBKMIntegrability` is **OPEN** and is as strong as Statement (B), so this does **not** prove Statement (B). The Clay problem remains open.
