# FIXES.md — FrohmanianTripleArchitecture.lean (Mathlib v4.22.0 / 79e94a09)

All edits are in `fixed/FrohmanianTripleArchitecture.lean` only. Pristine copy untouched.

## API / import renames (statement-preserving)

1. `import Mathlib.Analysis.Calculus.MeanValue` → `Mathlib.Analysis.Calculus.Deriv.MeanValue`
   (and added `Mathlib.Analysis.Calculus.Deriv.Mul`) so `antitoneOn_of_*` and product rules resolve.
2. `open Filter` + `open scoped Topology` for `𝓝` notation used by the adapted Grönwall proof.
3. `ContinuousOn.intervalIntegrable` on `Icc` → `ContinuousOn.intervalIntegrable_of_Icc`
   (Mathlib expects `uIcc`; `of_Icc` takes an `a ≤ b` hypothesis).
4. `gronwall_differential_bound` proof body rewritten to the same Mathlib-v4.22 pattern used in
   the earlier ConditionalNavierStokesTetherFull audit:
   `intervalIntegrable_of_Icc`, `continuousOn_primitive_interval'`,
   `antitoneOn_of_hasDerivWithinAt_nonpos`, `integral_hasDerivAt_right` with
   `ContinuousOn.stronglyMeasurableAtFilter`, and corrected `calc` indentation.
   **Lemma statement unchanged.**
5. `intervalIntegral.integral_mono_on` → `integral_mono_on` (same lemma; namespace already opened
   via `open MeasureTheory` / intervalIntegral conventions in this Mathlib rev).

## Genuine proof bug (not API) — documented and corrected without changing statements

6. In pristine `three_way_equivalence`, the step
   ```
   have hCS_nonneg : 0 ≤ C_S := by
     have h0 := hCS 0 ...
     have h0_nonneg := sol.vorticity_nonneg 0 ...
     nlinarith
   ```
   **fails**: `strainSup 0 ≤ C_S` and `0 ≤ vorticitySup 0` do not imply `0 ≤ C_S`.
   `strainSup` has no nonnegativity field (unlike the earlier ConditionalNavierStokesTetherFull
   which had `strain_nonneg`). This is a genuine logic gap, not a rename issue.
   **Fix (statement unchanged):** witness `(max C_S 0) * T` instead of `C_S * T`, which is a
   valid upper bound whether or not `C_S` is nonnegative. No hypothesis was added to the structure.

## Not changed

- No theorem/def/structure statements altered.
- No `sorry` / `admit` / custom `axiom` / `native_decide` introduced.
- Sections 1–2 (projPerp, tether, MetriplecticSystem, totalMetriplectic*) needed **zero** edits;
  `State`/`V` autobinding on `totalMetriplecticBracket` elaborates successfully.

7. `open ... intervalIntegral` added (same as ConditionalNavierStokesTetherFull) so
   `integral_mono_on`, `integral_same`, `integral_hasDerivAt_right`,
   `continuousOn_primitive_interval'` resolve.

## AlignmentKernel_fragment.lean

Pristine fragment FAIL:
- `triple_product_cycle`: unfolding `crossProduct` (a `LinearMap.mk₂`) no longer simplifies via
  `Matrix.cons_val_*`; `ring` left unsolved goals.
- Trailing `/-- ... -/` doc comment with no following declaration caused a parse error at `end`.

Fixed fragment (statement-preserving):
- `open scoped Matrix`; prove `triple_product_cycle` via Mathlib `triple_product_permutation`
  + `dotProduct_comm` (same equality).
- Doc comment changed to ordinary `/- ... -/`.
- Minor `calc` indentation cleanup in `abs_alignmentKernel_le`.
- `abs_dot3_le` already built in pristine (Cauchy–Schwarz via `sum_mul_sq_le_sq_mul_sq`).

`constantin_fefferman_desingularization` was truncated mid-statement in the first paste and is
absent from the second complete copy; cannot be built.
