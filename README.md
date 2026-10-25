# Frohmanian Symplectic Tether — 3D Navier–Stokes Global Regularity (Lean 4)

[![Lean CI](https://github.com/BenFrohman/NS_Millennium_Proof/actions/workflows/lean.yml/badge.svg)](https://github.com/BenFrohman/NS_Millennium_Proof/actions/workflows/lean.yml)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.23627610.svg)](https://doi.org/10.5281/zenodo.23627610)
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Lean](https://img.shields.io/badge/Lean-4.30.0--rc1-brightgreen.svg)](lean-toolchain)
[![Sponsor](https://img.shields.io/github/sponsors/BenFrohman?label=Sponsor&logo=github)](https://github.com/sponsors/BenFrohman)

A geometric approach to the **3D incompressible Navier–Stokes global-regularity problem**,
together with its **Lean 4** formalization. The central object is the *Frohmanian Symplectic Tether* —
a construction on coadjoint orbits that produces controllable negative feedback at maxima of the vorticity,
tied to a Lyapunov/enstrophy argument. Benjamin Stanley Frohman is the originator of that tether.

## Companion Manuscript (19 Pages, Oct 2026)

- **[`main.pdf`](main.pdf)** ([`manuscript/main.pdf`](manuscript/main.pdf)) — *Global Regularity for the 3D Incompressible Navier–Stokes Equations via the Frohmanian Symplectic Tether: Complete Original Conjectured Framework and Kernel-Verified Non-Vacuous Conditional Formalization in Lean 4* (19 pages, compiled from [`main.tex`](main.tex)).
- **[`main.tex`](main.tex)** ([`manuscript/main.tex`](manuscript/main.tex)) — Complete LaTeX source with verbatim Lean 4 excerpts ([`manuscript/lean/`](manuscript/lean/)).
- **[`SCOPE.md`](SCOPE.md)** ([`manuscript/SCOPE.md`](manuscript/SCOPE.md)) — Executive verification table across all 360 kernel-verified theorems, 14 modules, `IsPhysicalNSSolution` non-vacuity proofs, and preserved conjectured bridges.

> ### Scope
> Benjamin Stanley Frohman is the originator of the Frohmanian Symplectic Tether.
> The Lean domain is `T3 := EuclideanSpace ℝ (Fin 3)`.
> Fefferman's statement (B) is the periodic torus. Neither regularity head is that statement.
>
> `ns_global_regularity_of_cubic_damped_rate` assumes the cubic rate
> `M' ≤ C M² − κ'' M³` and does not derive it.
> `global_regularity_for_NS` assumes a vorticity ceiling and does not derive it.
>
> **Status (Oct 2026): Complete, sorry-free, axiom-clean, and verified non-vacuous.**
> Every original definition, theorem, and conjectured bridge from Benjamin Stanley Frohman's
> programme is preserved in the active build (`lake build`, **392 theorems across 16 modules**,
> **0 `sorry`**, and **0 nonstandard axioms** — `#print axioms` reports only
> `[propext, Classical.choice, Quot.sound]`, audited by `scripts/AxiomAudit.lean`):
> - **Periodic torus kinematics & conditional Clay (B) reductions (`Modules/TorusStrainExclusion.lean`, `Modules/HighSetDepletionAndBKM.lean`):**
>   Proves unconditionally that spatial $\mathbb{Z}^3$-periodicity excludes any non-zero *global* linear background strain (`z3_periodic_linear_eq_zero`, `burgersLinearStrain_not_z3_periodic`; note that localized Burgers-like vortex structures can still form locally on $\mathbb{T}^3$, so this does **not** give unconditional Clay (B)), proves the pointwise Biot–Savart direction-alignment identities (`biot_savart_det_aligned_eq_zero`, `biot_savart_det_difference_identity`), parabolic $\lambda^6$ scaling homogeneity (`navier_stokes_scaling_homogeneity_deg6`), the ODE comparison ceiling (`comparison_ode_ceiling`), and the **conditional reductions** `clay_B_exact_of_periodic_tether_bound` and `clay_B_exact_of_torus_direction_depletion` whose analytic hypotheses (`PeriodicDirectionDepletionBound` / `PeriodicTetherClosingBound` and `PeriodicBKMContinuation`) remain **OPEN** and are stated explicitly as hypotheses.
> - **Casimir non-degeneracy of the Frohmanian Symplectic Tether (`Modules/SymplecticTether.lean`):**
>   Proves unconditionally `tetherPointwiseDensity_nonpos`, `tetherPointwiseDensity_strict_neg_of_noncasimir`, `tetherKernel_diagonal_nonpos`, `tetherKernel_strict_neg_of_orthogonal_component`, and `tetherKernel_nondegenerate_on_casimir_defect`.
> - **Original conjectured bridges preserved and proved conditionally:**
>   `FrohmanianTetherRate` (`hDI`), `FrohmanianTetherBound` (`hRiccati`),
>   `ConjecturedUnmodifiedTetherPairing` and `reduced_pairing_of_unmodified_and_tether`
>   (proved with zero `sorry` via `reduced_pairing_iff_cancels_kappa_M4`),
>   `tethered_stretching_of_weight` (proved with zero `sorry` from `hweight`),
>   `ConjecturedSDiffPushforwardInvariance` and `tether_coadjoint_invariance_of_integral_eq`,
>   and both antisymmetric (`uniqueness_of_minimal_tether`) and symmetric
>   (`uniqueness_of_minimal_symmetric_tether`) uniqueness characterizations.
> - **Time-smoothness & physical-solution non-vacuity repair (`IsPhysicalNSSolution`):**
>   All PDE uniqueness and continuation binders (`KatoLocalWitness`, `existenceTimes`,
>   `restart_of_kato_quantitative`, `FrohmanianTetherBound`, `FrohmanianTetherRate`,
>   `global_regularity_for_NS`, `frohmanian_tether_theorem`) require `IsPhysicalNSSolution`
>   (pointwise time-differentiability + Leray $L^2$ energy inequality), ruling out unphysical
>   time-step fields (`stepField_not_physical`) and establishing joint satisfiability and
>   non-vacuity (`repaired_hInt`, `repaired_huniq_at_zero`, `frohmanianTetherBound_zero`,
>   `frohmanianTetherRate_zero`, `global_regularity_for_NS_nonvacuous_at_zero` in
>   `NS_Millennium_Proof/Modules/ClayStatements.lean`).

## Approach at a glance

The proof is organized as a **two-layer, non-circular** architecture:

1. **Geometric layer** — a symplectic tether on coadjoint orbits, with three necessary conditions (C1)–(C3)
   and a degeneracy result with respect to the kinetic-energy Hamiltonian (`Modules/SymplecticTether.lean`,
   `Modules/ArnoldGeometric.lean`).
2. **Analytic layer** — a tethered Lyapunov / enstrophy differential inequality in which higher-order
   dissipation absorbs the nonlinear vorticity-stretching term (`Modules/TetheredLyapunov.lean`,
   `Modules/IndependentMajorant.lean`), closing to global regularity (`Modules/GlobalRegularity.lean`).

Reusable, potentially upstreamable lemmas live under [`ForMathlib/`](ForMathlib/README.md) following the
hygiene pattern used in Tao's PFR project.

## Repository structure

```
Modules/                 Core Lean modules (geometric + analytic layers)
ForMathlib/              Reusable lemmas intended for eventual Mathlib upstreaming
NS_Millennium_Proof/     Library root (Definitions, Modules, Skeleton, Widgets)
Blueprint.md             Human-readable dependency graph and atomic statements
main.pdf / main.tex / SCOPE.md   19-page manuscript, LaTeX source, and Lean verification scope table
manuscript/              Complete manuscript source bundle and Lean snippet extracts
LaTeX_Lean_Relationship.md   Mapping between LaTeX intuition and the Lean code
AUTHORS.md / COPYRIGHT.md / HISTORY.md   Attribution and provenance
lakefile.lean / lean-toolchain / lake-manifest.json   Build configuration
```

## Building

Requires [`elan`](https://github.com/leanprover/elan) (the toolchain pin in `lean-toolchain` is fetched
automatically). Mathlib is a dependency; fetch its prebuilt cache before building to avoid a multi-hour
compile:

```bash
lake exe cache get   # download prebuilt Mathlib artifacts
lake build           # build the project
```

The pinned toolchain is **Lean 4.30.0-rc1** with **Mathlib @ v4.30.0-rc1**. It was developed originally on Lean 4.28.0; currently pinned to v4.30.0-rc1.

## Authorship, priority, and citation

Original author and originator: **Benjamin Stanley Frohman** (see [`AUTHORS.md`](AUTHORS.md)). The named
constructions in this repository (Frohmanian tether, tethered bracket, tethered Lyapunov, tethered nullifier,
independent majorant) are original to this work. If you reference it, please cite via
[`CITATION.cff`](CITATION.cff).

**Disclaimer.** The mathematical proofs are those of Benjamin Stanley Frohman (the paper). The Lean 4
encoding in this repository was compiled in a collaborative effort with an AI assistant (Grok, xAI)
from that author's paper proofs. Authorship of the mathematics and of the original constructions
remains Benjamin Stanley Frohman.

### Lean 4 / mathlib4 / Zulip

Original Lean modules use Mathlib's five-line copyright header with
`Authors: Benjamin Stanley Frohman` (no trailing period). That is the name to ping on
the Lean Zulip. GitHub: [@BenFrohman](https://github.com/BenFrohman).
X.com : [Investor0x](https://x.com/Investor0x). Historical commit names `Frohmanian` and
`BenFrohman` are mapped in [`.mailmap`](.mailmap); git history is not rewritten.
On PRs, comment `Author: Benjamin Stanley Frohman` when the git author is a handle.
See [`CONTRIBUTING.md`](CONTRIBUTING.md).

## Support

Independent research. If this corpus is useful: **[Sponsor on GitHub](https://github.com/sponsors/BenFrohman)**.

## License

[Apache License 2.0](LICENSE) © 2026 Benjamin Stanley Frohman.
