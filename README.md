# Frohmanian Symplectic Tether — Conditional Navier–Stokes Reductions (Lean 4)

[![lean.yml](https://github.com/BenFrohman/NS_Millennium_Proof/actions/workflows/lean.yml/badge.svg?branch=main)](https://github.com/BenFrohman/NS_Millennium_Proof/actions/workflows/lean.yml)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.23717084.svg)](https://doi.org/10.5281/zenodo.23717084)
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Lean](https://img.shields.io/badge/Lean-4.30.0--rc1-brightgreen.svg)](lean-toolchain)
[![Sponsor](https://img.shields.io/github/sponsors/BenFrohman?label=Sponsor&logo=github)](https://github.com/sponsors/BenFrohman)

A geometric approach to the **3D incompressible Navier–Stokes global-regularity problem**,
together with its **Lean 4** formalization. The central object is the *Frohmanian Symplectic Tether* —
a proposed construction on coadjoint orbits intended to control vortex stretching. Its required
analytic link to general unmodified Navier–Stokes solutions is not established. Benjamin Stanley Frohman is the originator of that tether.

## Main theorem: conditional reduction, not a PDE estimate

`clay_reduces_to_uniform_vorticity_envelope` states:

> If, for every positive viscosity, both `UniformVorticityEnvelopeBound ν` and
> `PeriodicBKMContinuation ν` hold, then `Clay_B_exact` holds.

The accurately named envelope assumes, for each smooth divergence-free periodic
initial datum, positive constants `C, κ` independent of the local solution's
lifespan, with `M(t) ≤ max (M(0)) (C/κ)` for every local periodic solution.
It does **not** assume or prove a differential inequality. Historical names
`PeriodicDirectionDepletionBound`, `DirectionCurvatureBound` and
`clay_reduces_to_direction_curvature_bound` retain their original propositions/API.

The separate `CubicVorticityDifferentialBound u τ C κ` concerns the **actual**
`M(t) = vorticity_sup_norm (vorticity (u t))`: it explicitly requires bounded
spatial ranges, ordinary differentiability on `[0,τ]`, positive coefficients, and
`M' ≤ C M² − κ M³`. The compact comparison and its half-open-lifespan consequence
are proved conditionally. Neither that inequality nor differentiability of the
supremum is inferred from PDE smoothness. In particular, ordinary differentiability
at zero depends on the otherwise unconstrained negative-time extension.

The envelope and the BKM continuation principle remain separate hypotheses.
No unconditional Clay solution, converse, or equivalence of the two assumptions
is claimed. See [the source/paper correction and quantified shear tests](docs/VORTICITY_ENVELOPE_CORRECTION.md).
A synchronized [correction addendum (PDF)](docs/VorticityEnvelopeCorrection.pdf)
with [TeX source](docs/VorticityEnvelopeCorrection.tex) accompanies the source fix.
The existing manuscript PDFs and published archives are **not** updated by this
source correction; their differential formulation must be read with that addendum.

Reproduce against the exact `lean-toolchain` and `lake-manifest.json`:

```sh
lake build
lake env lean scripts/AxiomAudit.lean
lake env lean scripts/EnvelopeCorrectionAudit.lean
lake env lean scripts/CertificateAxiomInventory.lean
```

The root build checks the full project and audits theorem dependencies; the
additional script checks the corrected API and prints each new theorem's axioms.
These checks validate conditional Lean statements, not a missing PDE hypothesis
or the truth of the paper's stronger analytic claims. Author: Frohman, Benjamin Stanley.

**Main Theorem A (unconditional supporting facts):** attained-maximum ⇒ `BddAbove` and sup-norm equality; Bochner and polar Pythagoras identities, now *derived* from `HasDerivAt` along coordinate lines (`Stage6Calculus.lean`); the near/far cutoff absorption algebra; Burgers-strain exclusion on 𝕋³; the comparison-ODE ceiling; and a genuinely non-constant exact periodic shear Beltrami mode `e^{-4π²νt}(sin 2πz, cos 2πz, 0)` checked component-wise.

## Standalone Self-Contained Repositories & Single-Sentence Final Product Theorems

In addition to this research repository (see fresh build/audit logs for declaration counts), the two self-contained tracks are published as dedicated standalone repositories with their own Single-Sentence Final Product Theorems (`FinalProductTheorem.lean`), PDF monographs, and Zenodo DOIs:

1. **[BenFrohman/frohmanian-symplectic-tether-regularity](https://github.com/BenFrohman/frohmanian-symplectic-tether-regularity)** — **Zenodo v1.1.0 DOI:** [`10.5281/zenodo.23717082`](https://doi.org/10.5281/zenodo.23717082) (Concept DOI: [`10.5281/zenodo.23652842`](https://doi.org/10.5281/zenodo.23652842), v1.0.0 DOI: [`10.5281/zenodo.23652843`](https://doi.org/10.5281/zenodo.23652843))
   - `350` kernel-verified theorems across `13` modules (`0 sorry`, `0` custom axioms).
   - Master 5-conjunct product theorem: `FrohmanianSymplecticTether.FinalProductTheorem.frohmanian_metriplectic_system_canonical_uniqueness_and_global_regularity_product_theorem` ($P_1 \wedge P_2 \wedge P_3 \wedge P_4 \wedge P_5$).
2. **[BenFrohman/fefferman-clay-navier-stokes](https://github.com/BenFrohman/fefferman-clay-navier-stokes)** — **Zenodo v1.1.0 DOI:** [`10.5281/zenodo.23717083`](https://doi.org/10.5281/zenodo.23717083) (Concept DOI: [`10.5281/zenodo.23652840`](https://doi.org/10.5281/zenodo.23652840), v1.0.0 DOI: [`10.5281/zenodo.23652841`](https://doi.org/10.5281/zenodo.23652841))
   - `224` `theorem`/`lemma` declarations across `7` modules (`0 sorry`, `0` custom axioms), counted in the source at commit `34e5a7f`. The titan audit reports more because it counts compiled/generated constants.
   - Master 5-conjunct product theorem: `FeffermanClayNS.FinalProductTheorem.fefferman_periodic_ns_exact_reduction_product_theorem` ($Q_1(\nu) \wedge Q_2 \wedge Q_3 \wedge Q_4 \wedge Q_5(\nu)$).

## Companion Manuscript (19 Pages, Oct 2026)

- **[`main.pdf`](main.pdf)** ([`manuscript/main.pdf`](manuscript/main.pdf)) — *Global Regularity for the 3D Incompressible Navier–Stokes Equations via the Frohmanian Symplectic Tether: Complete Original Conjectured Framework and Kernel-Verified Non-Vacuous Conditional Formalization in Lean 4* (19 pages, compiled from [`main.tex`](main.tex)).
- **[`main.tex`](main.tex)** ([`manuscript/main.tex`](manuscript/main.tex)) — Complete LaTeX source with verbatim Lean 4 excerpts ([`manuscript/lean/`](manuscript/lean/)).
- **[`SCOPE.md`](SCOPE.md)** ([`manuscript/SCOPE.md`](manuscript/SCOPE.md)) — Historical verification table; use fresh audit logs for current declaration counts, `IsPhysicalNSSolution` non-vacuity proofs, and preserved conjectured bridges.

> ### Scope
> Benjamin Stanley Frohman is the originator of the Frohmanian Symplectic Tether.
> The Lean domain is `T3 := EuclideanSpace ℝ (Fin 3)`.
> Fefferman's statement (B) is the periodic torus. Neither regularity head is that statement.
>
> `ns_global_regularity_of_cubic_damped_rate` assumes the cubic rate
> `M' ≤ C M² − κ'' M³` and does not derive it.
> `global_regularity_for_NS` assumes a vorticity ceiling and does not derive it.
>
> **Status: conditional formalization; the general analytic input remains unproved.**
> Every original definition, theorem, and conjectured bridge from Benjamin Stanley Frohman's
> programme is preserved in the active build (`lake build`; see its current theorem audit,
> **0 `sorry`**, and **0 nonstandard axioms** — `#print axioms` reports only
> `[propext, Classical.choice, Quot.sound]`, audited by `scripts/AxiomAudit.lean`):
> - **Periodic torus kinematics & conditional Clay (B) reductions (`Modules/TorusStrainExclusion.lean`, `Modules/HighSetDepletionAndBKM.lean`):**
>   Proves unconditionally that spatial $\mathbb{Z}^3$-periodicity excludes any non-zero *global* linear background strain (`z3_periodic_linear_eq_zero`, `burgersLinearStrain_not_z3_periodic`; note that localized Burgers-like vortex structures can still form locally on $\mathbb{T}^3$, so this does **not** give unconditional Clay (B)), proves the pointwise Biot–Savart direction-alignment identities (`biot_savart_det_aligned_eq_zero`, `biot_savart_det_difference_identity`), parabolic $\lambda^6$ scaling homogeneity (`navier_stokes_scaling_homogeneity_deg6`), the ODE comparison ceiling (`comparison_ode_ceiling`), and the **conditional reductions** `clay_B_exact_of_periodic_tether_bound` and `clay_B_exact_of_torus_direction_depletion` whose analytic hypotheses (`PeriodicDirectionDepletionBound` / `PeriodicTetherClosingBound` and `PeriodicBKMContinuation`) remain **OPEN** and are stated explicitly as hypotheses.
> - **Symplectic-metriplectic KKS bracket, Jacobi identity, and projector geometry (`Modules/SymplecticConstraint.lean`, 45 theorems):**
>   Proves unconditionally KKS skew-symmetry (`kks_skew_symmetric`), the cyclic Jacobi identity (`kks_jacobi_identity`), idempotence and self-adjointness of the Casimir-orthogonal projector (`Pi_u_idempotent`, `Pi_u_self_adjoint`), Casimir conservation (`tether_preserves_casimir`), and strict transverse metriplectic damping.
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
>   Named hypotheses (open, taken as explicit `Prop` arguments). Finite-horizon form, which is
>   what Clay statement (B) needs: `FiniteTimeVorticityBound`, `PhysicalFiniteTimeVorticityBound`
>   (for every `T` a bound `C(T)` on `sup_{[0,T]} ‖ω‖_∞`), `BKMIntegrability`,
>   `PhysicalBKMIntegrability` (`∫₀ᵀ ‖ω‖_∞ < ∞` for every `T`).
>   BKM step: `beale_kato_majda` takes `LocalExistenceTime` (`T* > 0`), `BKMContinuationCriterion`
>   (finite `T*` forces `∫₀^{T*} ‖ω‖_∞ = ∞`), `PathBKMIntegrable` and `SmoothBelowTstar`, and derives
>   `T* = ⊤` (`Tstar_eq_top_of_bkm`); the integrability is necessary
>   (`bkm_criterion_without_integrability_not_top`). `BKMContinuationCriterion` (u₀-level:
>   `BKMContinuationCriterionFor`, `PhysicalBKMContinuationCriterionFor`), `SmoothBelowTstar`
>   (`SmoothBelowTstarFor`) and `KatoUniquenessOnExistenceTimes` are classical and not formalized here.
>   `global_regularity`, `global_regularity_of_bkmIntegrability`, `global_regularity_of_bkm_uniqueness`,
>   `global_regularity_for_NS` and `frohmanian_global_regularity_of_closing_bound` go through this step.
>   Scaffolding that does not use integrability: `beale_kato_majda_scaffold` (takes `TstarIsTop`;
>   `beale_kato_majda_scaffold_integrability_unused`), `global_regularity_scaffold`,
>   `continuation_under_global_existence`, and `global_regularity_of_restart` /
>   `global_regularity_of_kato_estimates`, which derive `T* = ⊤` from `KatoUniformRestart` alone
>   (`Tstar_top_of_restart_without_vorticity_bound`).
>   Stronger uniform variants: `UniformVorticityCeiling`, `PhysicalUniformVorticityCeiling`,
>   `PhysicalVorticityCubicRate` (`TetheredLyapunov.lean`), `RiccatiMajorantExists`
>   (`ClosureBlueprint.lean`); proved bridges `finiteTimeVorticityBound_of_uniform`,
>   `physicalFiniteTimeVorticityBound_of_uniform`, `bkmIntegrability_of_finiteTime`,
>   `physicalBKMIntegrability_of_finiteTime`. `PointwiseStrainSupBound`
>   (`NS_Equations.lean`, `‖∇u(x)‖ ≤ C‖ω‖_∞`) and `PointwiseCZGradientBoundAtMax` are false in
>   general (Calderón–Zygmund fails at `p = ∞`); `strain_sup_le_of_CZ`,
>   `convective_norm_le_of_CZ`, `stretching_inner_le`, `stretching_inner_le_at_max`,
>   `stretching_quartic_le`, `calderon_zygmund_stretching_bound`, the `AssemblyGap` stretching lemmas and
>   `ConjecturedUnmodifiedTetherPairing` are conditional on a bound that is false in general.
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

## Provenance of Ingredients

Dates below are verified from files in the `NS_Millennium_Proof` git history (first commit 2026-06-19, which imported a snapshot directory `historical/previous_implementations/complete_implementation_2026-05-28/`). No April 2026 file was found in the repositories; earlier dates are not asserted.

| Ingredient | Earliest verified date | Source | Status |
|---|---|---|---|
| Young absorption | 2026-05-28 snapshot | `historical/previous_implementations/complete_implementation_2026-05-28/docs/Frohmanian_Tether_NS_Proof_Conversation_Summary.md` | original scaffolding |
| Cubic majorant / Riccati comparison | 2026-05-28 snapshot | `.../complete_implementation_2026-05-28/Modules/IndependentMajorant.lean`, `Skeleton/PaperOverview.lean` | original scaffolding |
| Frohmanian tether | 2026-05-28 snapshot | `.../complete_implementation_2026-05-28/docs/05_Step_Uniqueness_Proof_Structure.md` | original scaffolding |
| Biot–Savart (mentions) | 2026-05-28 snapshot | `.../complete_implementation_2026-05-28/docs/Phase0_Phase1_Implementation_Plan.md` | original scaffolding |
| Bochner–Weitzenböck | 2026-06-19 (git `236244d`) | `NS_Millennium_Proof/Modules/NS_Equations.lean` | classical (Bochner), pinned and cited; concrete 3D form added Oct 2026 (Grok-assisted scaffolding) |
| Constantin–Fefferman cited as classical tool (name only; no direction condition stated) | 2026-06-19 (git `236244d`) | `NS_Millennium_Proof/Modules/TetheredLyapunov.lean` | classical (Constantin–Fefferman 1993), pinned and cited |
| Attained max / `BddAbove` guards | 2026-08-27 (git `04eb613`) | Lean sources | added Aug 2026 |
| Polar Pythagoras | 2026-10-28 (git `acf5883`) | `Modules/FinalProductTheorem.lean` stages | added Oct 2026 (Grok-assisted scaffolding) |
| Beltrami (Lamb vector, shear mode) | 2026-10-28 (git `acf5883`) | Stage 4 / `Stage6Calculus.lean` | classical (Beltrami flows), pinned and cited; Lean added Oct 2026 (Grok-assisted scaffolding) |
| Near/far Biot–Savart cutoff bridge | 2026-10-28 (git `acf5883`) | Stage 5 | added Oct 2026 (Grok-assisted scaffolding), after Constantin–Fefferman 1993 |
| Reduction theorem `clay_reduces_to_direction_curvature_bound` | 2026-10-28 | `MainTheorem.lean` | added Oct 2026 (Grok-assisted scaffolding); earlier conditional reductions `clay_B_exact_of_*` predate it |

See [`NAMING.md`](NAMING.md) for the canonical names (Frohmanian Tether Hypothesis, symbol 𝔉𝕋) and the old-name glossary.

## AI Assistance Disclosure

Grok (xAI), via the Grok Bot assistant, provided scaffolding, drafting, and collaboration support on formalization, code, and papers in this repository. Benjamin Stanley Frohman is the sole author: he directed, reviewed, and is responsible for all of the work. Grok is not a coauthor.

## Zenodo archive

This repository owns the Zenodo record family below. Do **not** confuse it with
[`frohmanian-tether-sdiff`](https://github.com/BenFrohman/frohmanian-tether-sdiff)
([`10.5281/zenodo.24082000`](https://doi.org/10.5281/zenodo.24082000)), a different project.

| Role | DOI | Notes |
|------|-----|-------|
| **Version DOI (badge / `CITATION.cff`)** | [`10.5281/zenodo.23717084`](https://doi.org/10.5281/zenodo.23717084) | Zenodo **v2.2.0**; pinned to GitHub tag [`v2.2.0`](https://github.com/BenFrohman/NS_Millennium_Proof/tree/v2.2.0) / commit [`8a5ec50`](https://github.com/BenFrohman/NS_Millennium_Proof/commit/8a5ec50aa602318c0c611269731e7d41cd30b75b) |
| Concept DOI (all versions) | [`10.5281/zenodo.23627609`](https://doi.org/10.5281/zenodo.23627609) | Resolves to the latest deposited version in this family |
| Latest Zenodo version DOI | [`10.5281/zenodo.23749850`](https://doi.org/10.5281/zenodo.23749850) | Labeled Zenodo **v2.3.0**; still points at the same GitHub `v2.2.0` / `8a5ec50` snapshot and adds one extra PDF. There is **no** GitHub tag `v2.3.0`. |
| Earlier version | [`10.5281/zenodo.23627610`](https://doi.org/10.5281/zenodo.23627610) | Zenodo **v2.1.0** |

- [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.23717084.svg)](https://doi.org/10.5281/zenodo.23717084) Version DOI for the archived `v2.2.0` release.
- [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.23627609.svg)](https://doi.org/10.5281/zenodo.23627609) Concept DOI for all versions of this record family.
