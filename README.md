# Frohmanian Symplectic Tether — 3D Navier–Stokes Global Regularity (Lean 4)

[![Lean CI](https://github.com/BenFrohman/NS_Millennium_Proof/actions/workflows/lean.yml/badge.svg)](https://github.com/BenFrohman/NS_Millennium_Proof/actions/workflows/lean.yml)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.23717084.svg)](https://doi.org/10.5281/zenodo.23717084)
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Lean](https://img.shields.io/badge/Lean-4.30.0--rc1-brightgreen.svg)](lean-toolchain)
[![Sponsor](https://img.shields.io/github/sponsors/BenFrohman?label=Sponsor&logo=github)](https://github.com/sponsors/BenFrohman)

A geometric approach to the **3D incompressible Navier–Stokes global-regularity problem**,
together with its **Lean 4** formalization. The central object is the *Frohmanian Symplectic Tether* —
a construction on coadjoint orbits that produces controllable negative feedback at maxima of the vorticity,
tied to a Lyapunov/enstrophy argument. Benjamin Stanley Frohman is the originator of that tether.

## Main Theorem (proved reduction)

`clay_reduces_to_direction_curvature_bound` (Lean 4 + Mathlib, `0 sorry`, axioms `[propext, Classical.choice, Quot.sound]`):

> For every ν > 0, assuming the classical periodic Beale–Kato–Majda continuation principle `PeriodicBKMContinuation ν` (a published theorem, Kato 1972 / Beale–Kato–Majda 1984, **not** formalized here and therefore an explicit hypothesis), the named estimate `DirectionCurvatureBound ν` implies Fefferman's exact periodic Clay statement `Clay_B_exact ν`.

- `DirectionCurvatureBound ν` (high-set direction-curvature / cubic depletion bound `M' ≤ C M² − κ M³`) is the single named **open** estimate (conjecture). It is **not** proved.
- The Clay problem is **not** claimed solved. The converse (`Clay_B_exact → DirectionCurvatureBound`) is **not** proved.

**Main Theorem A (unconditional supporting facts):** attained-maximum ⇒ `BddAbove` and sup-norm equality; Bochner and polar Pythagoras identities, now *derived* from `HasDerivAt` along coordinate lines (`Stage6Calculus.lean`); the near/far cutoff absorption algebra; Burgers-strain exclusion on 𝕋³; the comparison-ODE ceiling; and a genuinely non-constant exact periodic shear Beltrami mode `e^{-4π²νt}(sin 2πz, cos 2πz, 0)` checked component-wise.

## Standalone Self-Contained Repositories & Single-Sentence Final Product Theorems

In addition to this full research repository (`453` theorems across `17` modules), the two self-contained tracks are published as dedicated standalone repositories with their own Single-Sentence Final Product Theorems (`FinalProductTheorem.lean`), PDF monographs, and Zenodo DOIs:

1. **[BenFrohman/frohmanian-symplectic-tether-regularity](https://github.com/BenFrohman/frohmanian-symplectic-tether-regularity)** — **Zenodo v1.1.0 DOI:** [`10.5281/zenodo.23717082`](https://doi.org/10.5281/zenodo.23717082) (Concept DOI: [`10.5281/zenodo.23652842`](https://doi.org/10.5281/zenodo.23652842), v1.0.0 DOI: [`10.5281/zenodo.23652843`](https://doi.org/10.5281/zenodo.23652843))
   - `350` kernel-verified theorems across `13` modules (`0 sorry`, `0` custom axioms).
   - Master 5-conjunct product theorem: `FrohmanianSymplecticTether.FinalProductTheorem.frohmanian_metriplectic_system_canonical_uniqueness_and_global_regularity_product_theorem` ($P_1 \wedge P_2 \wedge P_3 \wedge P_4 \wedge P_5$).
2. **[BenFrohman/fefferman-clay-navier-stokes](https://github.com/BenFrohman/fefferman-clay-navier-stokes)** — **Zenodo v1.1.0 DOI:** [`10.5281/zenodo.23717083`](https://doi.org/10.5281/zenodo.23717083) (Concept DOI: [`10.5281/zenodo.23652840`](https://doi.org/10.5281/zenodo.23652840), v1.0.0 DOI: [`10.5281/zenodo.23652841`](https://doi.org/10.5281/zenodo.23652841))
   - `186` kernel-verified theorems across `6` modules (`0 sorry`, `0` custom axioms).
   - Master 5-conjunct product theorem: `FeffermanClayNS.FinalProductTheorem.fefferman_periodic_ns_exact_reduction_product_theorem` ($Q_1(\nu) \wedge Q_2 \wedge Q_3 \wedge Q_4 \wedge Q_5(\nu)$).

## Companion Manuscript (19 Pages, Oct 2026)

- **[`main.pdf`](main.pdf)** ([`manuscript/main.pdf`](manuscript/main.pdf)) — *Global Regularity for the 3D Incompressible Navier–Stokes Equations via the Frohmanian Symplectic Tether: Complete Original Conjectured Framework and Kernel-Verified Non-Vacuous Conditional Formalization in Lean 4* (19 pages, compiled from [`main.tex`](main.tex)).
- **[`main.tex`](main.tex)** ([`manuscript/main.tex`](manuscript/main.tex)) — Complete LaTeX source with verbatim Lean 4 excerpts ([`manuscript/lean/`](manuscript/lean/)).
- **[`SCOPE.md`](SCOPE.md)** ([`manuscript/SCOPE.md`](manuscript/SCOPE.md)) — Executive verification table across all 453 kernel-verified theorems, 17 modules, `IsPhysicalNSSolution` non-vacuity proofs, and preserved conjectured bridges.

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
> programme is preserved in the active build (`lake build`, **470 theorems across 17 modules**,
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
| Constantin–Fefferman direction depletion | 2026-06-19 (git `236244d`) | `NS_Millennium_Proof/Modules/TetheredLyapunov.lean` | classical (Constantin–Fefferman 1993), pinned and cited |
| Attained max / `BddAbove` guards | 2026-08-27 (git `04eb613`) | Lean sources | added Aug 2026 |
| Polar Pythagoras | 2026-10-28 (git `acf5883`) | `Modules/FinalProductTheorem.lean` stages | added Oct 2026 (Grok-assisted scaffolding) |
| Beltrami (Lamb vector, shear mode) | 2026-10-28 (git `acf5883`) | Stage 4 / `Stage6Calculus.lean` | classical (Beltrami flows), pinned and cited; Lean added Oct 2026 (Grok-assisted scaffolding) |
| Near/far Biot–Savart cutoff bridge | 2026-10-28 (git `acf5883`) | Stage 5 | added Oct 2026 (Grok-assisted scaffolding), after Constantin–Fefferman 1993 |
| Reduction theorem `clay_reduces_to_direction_curvature_bound` | 2026-10-28 | `MainTheorem.lean` | added Oct 2026 (Grok-assisted scaffolding); earlier conditional reductions `clay_B_exact_of_*` predate it |

## AI Assistance Disclosure

Grok (xAI), via the Grok Bot assistant, provided scaffolding, drafting, and collaboration support on formalization, code, and papers in this repository. Benjamin Stanley Frohman is the sole author: he directed, reviewed, and is responsible for all of the work. Grok is not a coauthor.
