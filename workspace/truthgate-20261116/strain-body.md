Adds the Truth Gate, the GOD gate (read `TRUTH_GATE.md` first): `StrainEigenvalue/Semantics.lean`, `scripts/verify-lock.sh`, `.github/workflows/truth-gate.yml`, `TRUTH_GATE.md` and `TRUTH_GATE.lock`.

**Locked claim.** `paper/Strain_Eigenvalue_Breakdown.tex`, Proposition 1.1 ("Intermediate-eigenvalue representation"), quoted verbatim: ξ·Sξ = λ₂ + (λ₁−λ₂)ξ₁² + (λ₃−λ₂)ξ₃².

* `formal_claim`: the statement of `StrainEigenvalue.quadratic_form_intermediate`, over the bundled `StrainTensor`.
* `paper_claim`: for every real symmetric trace-free 3×3 matrix A and every ξ with ξ₁²+ξ₂²+ξ₃² = 1, ξ·Aξ = λ₂ + (λ₁−λ₂)ξ₁² + (λ₃−λ₂)ξ₃². λᵢ are the increasing eigenvalues and ξᵢ the coordinates in the ordered orthonormal eigenbasis, read as in the paper's own "Lean formalization: exact scope" section. It does not mention `formal_claim`.
* `intended_correspondence` is a statement-level proof (bundling/unbundling and sum expansion) that does not use the main theorem.

Scope: a pointwise algebraic identity. It gives no L^∞ bound on S, Hypothesis B stays open, and nothing is claimed about the Clay problem.
