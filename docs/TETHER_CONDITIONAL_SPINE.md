# Conditional Dependency Spine: Frohmanian Tether → Clay (B)

Author: Benjamin Stanley Frohman  
ORCID: [0009-0006-7068-3718](https://orcid.org/0009-0006-7068-3718)

Version DOI (v2.6.0): [10.5281/zenodo.24302372](https://doi.org/10.5281/zenodo.24302372).  
Concept DOI: [10.5281/zenodo.23627609](https://doi.org/10.5281/zenodo.23627609).

## Status

These are **conditional reductions** only. No unconditional Clay (B) solution is claimed.

Official kernel certificate on Lean-identical parent commit [`6b78ba7f59f1def862744e7325619c5f34e1f4d0`](https://github.com/BenFrohman/NS_Millennium_Proof/commit/6b78ba7f59f1def862744e7325619c5f34e1f4d0) ([run 45241230794](https://github.com/BenFrohman/NS_Millennium_Proof/actions/runs/45241230794); Lean 4.30.0-rc1): `AUDIT PASS: 691 theorems in 30 modules` depend only on `propext`, `Classical.choice`, and `Quot.sound`; `0` hits in the certified library (`historical/`, `docs/`, and `scripts/truth-gate-tests/` are still excluded by the scan on that run; see the interaction with [PR #44](https://github.com/BenFrohman/NS_Millennium_Proof/pull/44) below). Later documentation-only commits of `main` do not change the Lean sources.

The following remain **OPEN** named hypotheses. They are not theorems, and they are not interchangeable.

- `UniformVorticityEnvelopeBound ν` (abbreviation of `PeriodicDirectionDepletionBound ν`)
- `PeriodicBKMContinuation ν`
- `FrohmanianTetherRate u₀ ν`
- `CubicVorticityDifferentialBound u τ C κ`

The geometric tether does not by itself imply either analytic bound.

Notation: \(M(t)=\|\omega(t)\|_\infty\) with \(\omega=\operatorname{curl} u\), and viscosity \(\nu>0\).

## Path A — envelope and BKM (the terminal Clay reduction)

This is the path whose terminal node is `clay_reduces_to_uniform_vorticity_envelope`. Geometry listed in (1) is kernel-checked, but it is **not** a hypothesis of that theorem and is not an edge into Path A.

1. **Geometry (kernel-checked; not used by the terminal reduction).**
   - `FrohmanianTether.uniqueness_of_minimal_tether` — user interface for uniqueness of the minimal **symmetric** tether. It takes an `SDiff` action hypothesis, symmetry, (C1)–(C3), saturation (`SaturatesTetherQuadratic`), and polarization (`Polarizes B` and `Polarizes TetherKernel`), and concludes `B = TetherKernel`. The Lean docstring records that the proof goes through `uniqueness_of_minimal_symmetric_tether` and that `_hyp`, C1, C2, and C3 are carried but not used: the conclusion follows from saturation and polarization. Official `#print axioms`: only `propext`, `Classical.choice`, `Quot.sound`.
   - The antisymmetric interface `uniqueness_of_minimal_tether_antisymmetric` is vacuous in the presence of saturation: `antisym_sat_forces_zero_diag` proves that antisymmetry plus `SaturatesTetherQuadratic` forces `TetherKernel ω F F = 0` for every `F`, so the antisymmetric reading holds only where the tether quadratic form vanishes.
   - `FrohmanianTether.tetherKernel_nondegenerate_on_casimir_defect` — `casimirTetherKernel ωx ωy grad_orth = 0 ↔ grad_orth = 0`. Official axioms: the same three.
   - `Symplectori.SymplecticConstraint.volumePreservingCoadjointAction_preserves_TetherKernel` — any `VolumePreservingCoadjointAction SDiff` satisfies the C1 integral-preservation hypothesis `TetherIntegralPreserved SDiff`, hence (via `tether_satisfies_C1`) C1 for the tether. **There is no Lean declaration named `tether_preserves_casimir`.** Related proved names that do exist are `ConcreteSDiff.casimir_invariant` and `PlanSteps.casimir_conserved` (both under `SDiffActionHyp`).

2. **OPEN envelope.** `UniformVorticityEnvelopeBound ν` is an abbreviation of `PeriodicDirectionDepletionBound ν`: for every smooth, divergence-free, \(\mathbb{Z}^3\)-periodic initial field \(u_0\), there exist \(C,\kappa>0\) such that along any local periodic smooth solution on \([0,T)\),
   \[
   \|\omega(t)\|_\infty \le \max\bigl(\|\omega_0\|_\infty,\, C/\kappa\bigr).
   \]
   This is an assumed uniform ceiling. It does **not** assert or derive a differential inequality.

3. **OPEN continuation.** `PeriodicBKMContinuation ν`: if a uniform bound \(\|\omega\|_\infty\le Y\) holds along every local periodic smooth solution from \(u_0\), then a global `IsPeriodicSmoothSolution` exists. Stated as a hypothesis; not formalized here.

4. **Kernel-checked bridges.** `periodicTetherClosingBound_of_directionDepletion` turns the envelope into `PeriodicTetherClosingBound ν`. Then `clay_B_exact_of_torus_direction_depletion` (and the formal side `clay_B_exact_of_periodic_tether_bound_formal`) give `Clay_B_exact` from the envelope (or closing bound) together with `PeriodicBKMContinuation`, for every \(\nu>0\). Official axioms: the same three.

5. **Terminal node (kernel-checked, conditional).**
   `FrohmanianTether.HighSetDepletionAndBKM.clay_reduces_to_uniform_vorticity_envelope`  
   has type `NS_Millennium_Proof.Semantics.EnvelopeReduction.paper_claim`:
   \[
   \bigl((\forall \nu>0,\ \texttt{PaperUniformEnvelope}\,\nu)
   \;\land\;
   (\forall \nu>0,\ \texttt{PeriodicBKMContinuation}\,\nu)\bigr)
   \;\to\;
   \texttt{Clay\_B\_exact}.
   \]
   The formal side `clay_reduces_to_uniform_vorticity_envelope_formal` is the historically curried form
   \((\forall \nu>0,\ \texttt{PeriodicBKMContinuation}\,\nu)\to
   (\forall \nu>0,\ \texttt{UniformVorticityEnvelopeBound}\,\nu)\to
   \texttt{Clay\_B\_exact}\).
   The public theorem is obtained only by transport across the Truth Gate lock `EnvelopeReduction`. Official axioms: the same three.

   The historical alias `clay_reduces_to_direction_curvature_bound` is the same official path, with the envelope transcribed as `PaperUniformCeiling` (`DirectionCurvatureBound` is an abbreviation of `UniformVorticityEnvelopeBound`).

   The reduction is closed only if **both** `UniformVorticityEnvelopeBound` and `PeriodicBKMContinuation` are accepted, for every \(\nu>0\). Neither hypothesis by itself yields `Clay_B_exact`.

## Path B — rate and comparison ceiling (does not by itself give Clay (B))

`FrohmanianTetherRate` and `CubicVorticityDifferentialBound` are **not** `UniformVorticityEnvelopeBound`, and Lean does not identify them. The envelope is a per-viscosity assumed ceiling over all periodic data, with no differential inequality. The rate and the compact-interval bound are differential inequalities along a solution (or along all classical periodic solutions from a fixed datum). Comparison theorems turn those inequalities into a ceiling on \(M(t)\); they do not discharge the envelope, and they do not, by themselves, imply `Clay_B_exact`.

1. **OPEN rate.** `FrohmanianTetherRate u₀ ν`: along every classical periodic smooth unforced solution from \(u_0\) (`IsPeriodicSmoothSolution` with force \(0\)), \(M(t)=\|\omega(t)\|_\infty\) is differentiable and obeys
   \[
   M' \le C M^2 - \kappa M^3
   \]
   with \(C,\kappa>0\), plus continuity of \(M\) and a bounded-range guard on \(\|\omega(t,x)\|\). This is open for a general smooth periodic datum. The zero field is one classical solution (`zero_isPeriodicSmoothSolution`); that single field does not discharge the universal quantifier.

   This is **not** `FrohmanianTetherBound`. The Takagi field \(U\) in `TetherRateCounterexample` refutes `FrohmanianTetherBound` on the weak class; the same module does **not** claim that the classical rate fails, and \(U\) is not a classical periodic solution.

2. **OPEN compact-interval differential hypothesis.** `CubicVorticityDifferentialBound u τ C κ` requires the same inequality on \([0,\tau]\), with explicit `DifferentiableAt` and `BddAbove` guards. Ordinary differentiability of the spatial supremum is not inferred from PDE smoothness.

3. **Kernel-checked comparison (conditional on the inequality above).**
   - `TetheredLyapunov.riccati_ceiling_of_vorticity_di`: the differential inequality implies a uniform ceiling \(\exists Y,\ \forall t\ge 0,\ M(t)\le Y\).
   - `CeilingFromRate.classical_vorticity_ceiling` (and the locked `CeilingFromRate.theorem_1_1`): along one `IsPeriodicSmoothSolution`, \(M(t)\le \max(M(0), C/\kappa)\).
   - `vorticity_envelope_of_cubic_differential_bound`: the compact-interval form of the same comparison.

   Official axioms for these theorems: only `propext`, `Classical.choice`, `Quot.sound`.

## Deferred side branches

- Derivation of the rate or of the uniform vorticity envelope for unmodified Navier–Stokes.
- Full unconditional resolution of Clay statement (B).
- Any claim that the geometric tether alone implies the analytic bound.

## Scan exclusions and PR #44

On current `main`, `certificates/tools/sorry_scan.py` still excludes `historical/`, `docs/`, and `scripts/truth-gate-tests/`. Those trees contain `sorry` / `axiom` / `native_decide` (archived snapshots and intentional Truth Gate fixtures). Removing the exclusions without an archive decision makes the kernel-certificate job red: that work is already open as [PR #44](https://github.com/BenFrohman/NS_Millennium_Proof/pull/44) ("No skips… expected red until the archive decision") and is not duplicated here.

## Build

```bash
lake exe cache get
lake build
```

The default `lake build` of `NS_Millennium_Proof` runs the in-library axiom audit and the Truth Gate. Official `#print axioms` for the terminal reduction, uniqueness, and the comparison ceiling are in `NS_Millennium_Proof.lean` and in the kernel-certificate artifact cited above.
