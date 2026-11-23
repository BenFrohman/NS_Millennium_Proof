# FrohmanianTetherRate vs. the pasted CZ / cutoff / BKM material — Nov 16 2026 (America/Chicago)

## Task A verdict
The pasted estimates give only UPPER bounds for growth (d/dt‖ω‖∞ ≤ ‖S‖∞‖ω‖∞, CZ in Lᵖ, BKM log).
None produces a negative −κ''M³ term, so they do not prove hDI (M' ≤ C M² − κ'' M³).

- Constants depending only on ν (or universal, e.g. C = C_CZ): REFUTED by u₀ = A·U
  (U = 3(−sin y, sin x, 0) + (−sin x cos z, 0, cos x sin z)) on (ℝ/2πℤ)³:
  * sup-norm: M(0) = 6A, D⁺M(0) ≥ 6A(A−ν);  M'(0) − RHS ≥ 216κA³ + (6−36C)A² − 6νA > 0 for A = 1+ν+|C|/κ.
  * enstrophy: E(0) = 80π³A², ∫ω·Sω = 0, ∫|∇ω|² = 88π³A², E'(0) = −176π³νA²;
    E'(0) − (C E² − κE³) = 512000π⁹κA⁶ − 6400π⁶CA⁴ − 176π³νA² > 0 for large A.
  Exact sympy: taskA/hdi_check.py / .log. Lean algebra: ClassicalEstimatePieces.amplitude_refutes_rate_*.
- Constants depending on the datum/solution (the Lean `FrohmanianTetherRate` puts ∃ C κ'' after ∀ u):
  not refuted by this family; implies the BKM ceiling max(M0, C/κ''), so for all smooth data it would give
  periodic Clay (B). OPEN.
- Lean `FrohmanianTetherRate` as written (sdiff repo) is already disproved via the Takagi junk-derivative
  loophole and vacuous on nonzero periodic data (IsPhysicalNSSolution requires L²(ℝ³)).

## Task B
No file in the tether repos/papers contains the pasted Method B triple or an ℝ³-with-decay statement of
CZ / Biot–Savart / BKM used where 𝕋³ is meant. No paper edited.
Correction to the earlier claim: (r/p, 2r/(r−2p), 2) has reciprocals p/r + (r−2p)/(2r) + 1/2 = 1 exactly
(Lean: holder_triple_pasted_sum). Its defect is that it is not matched to the ‖S‖_{L^r} condition.
