# Kato/Leray formalization — PROGRESS (Benjamin t599u/t600u/t601u/t602u, Nov 23 2026)
Repo clone: /workspace/kato-formalization/repo (BenFrohman/NS_Millennium_Proof), branch feat/galerkin-sobolev-kato off origin/main 6b78ba7.
Packages: .lake/packages symlinked to /workspace/certify/frohmanian-tether-sdiff/.lake/packages (same manifest revs, mathlib 0c154d6710 = v4.30.0-rc1; no rebuild, no cache clear).
Rules: no sorry/admit/native_decide/axioms; std axioms only; Mathlib objects only (t602u); Mathlib style/docstrings; draft PR only; no mathlib4 PR without Benjamin's yes; PR #41 untouched.
CI notes: new modules must be imported by scripts/StrictAxiomAudit.lean (check_forbidden_tokens --require-imported-by).

## Stage 1 (Galerkin) — NS_Millennium_Proof/Modules/Kato/Galerkin.lean
- 2:50 PM CT: first draft written (wavevectorNormSq, lerayProj, convection, vectorField, velocity; contDiff_vectorField, exists_hasDerivAt, eqOn_Icc_of_hasDerivWithinAt, dotProduct_lerayProj). Compiling.
- 3:24 PM CT: commit 98e3dcf pushed, draft PR #45 opened. Local compile (27 min, box overloaded) found 1 error: Picard lemma lives in namespace ContDiffAt. Fixed in 1ec3988 (pushed ~3:31 PM CT); superseded queued runs for 98e3dcf cancelled.
- CI queue is saturated (runs sat "queued"); per Benjamin's 10-minute rule, cancel+rerun runs with no progress for 10 min.

## Stage 2 (Sobolev) — ForMathlib/Analysis/Sobolev/Torus/Basic.lean
- Draft written: sobolevWeight, sobolev (Submodule of L² via mFourierBasis.repr + Memℓp 2), mem_sobolev_iff, sobolev_antitone, sobolev_zero, sobolev_eq_top_of_nonpos, mFourierLp_mem_sobolev. Local compile running (log sobolev1.log). Not committed yet.
- Next: Hilbert-space structure on Hˢ (type synonym + induced norm/inner product from weighted ℓ²), completeness, algebra property s > d/2, Leray projector bounds.
