# Relationship Between Manuscript and Lean Formalization

Author: Frohman, Benjamin Stanley

This mapping describes conditional statements, not an unconditional proof of Navier–Stokes regularity. The published manuscript PDFs/archives are unchanged by the source correction.

## 1. Exact source correction

Baseline: `c98fe859867affeba4508b3e51583cfa6b20087c`.
Lean: `leanprover/lean4:v4.30.0-rc1`.
Mathlib: `0c154d67103f74be3a0f2c509f72ccbf5be9f2a7` (all package pins are in `lake-manifest.json`).

Historically `DirectionCurvatureBound ν` abbreviates
`PeriodicDirectionDepletionBound ν`, whose body assumes a **uniform envelope**:
for every smooth divergence-free periodic initial datum, there exist `C,κ > 0`
such that every represented local periodic solution has

    M(t) ≤ max(M(0), C/κ),    0 ≤ t < T.

The constants may depend on viscosity and the initial datum, but not on the local
solution or its lifespan. This body does not contain `deriv`, a differential
inequality, or a geometric curvature estimate. It is preserved exactly.
`UniformVorticityEnvelopeBound` supplies the accurate public name. All historical
names and the original reduction theorem remain definitionally compatible.

The new, separate `CubicVorticityDifferentialBound u τ C κ` concerns

    M(s) = vorticity_sup_norm (vorticity (u s)),

not a free scalar surrogate. Its premises are:

* `0 ≤ τ`, `0 < C`, `0 < κ`;
* bounded spatial vorticity-norm ranges at every time in `[0,τ]`;
* ordinary real differentiability of this actual `M` at every such time;
* `deriv M t ≤ C M(t)^2 − κ M(t)^3` at every such time.

The boundedness premise matters: real-valued conditional suprema have a default
value on unbounded sets. The pointwise theorem below explicitly uses that premise.
No missing estimate is encoded as a new axiom or silently inferred from smoothness.

## 2. What is proved in Lean

In `FrohmanianTether.HighSetDepletionAndBKM`:

* `vorticity_envelope_of_cubic_differential_bound`: exact application of the existing
  `comparison_ode_ceiling` on `[0,τ]`, retaining all of its premises.
* `pointwise_vorticity_envelope_of_cubic_differential_bound`: the same ceiling bounds
  the norm of the **actual curl** at every spatial point, using spatial boundedness.
* `periodic_solution_envelope_of_compact_cubic_bounds`: on an actual
  `IsPeriodicSmoothSolutionOn ν T u₀ u p`, compatible compact hypotheses for every
  `0 ≤ τ < T`, with the **same constants**, give the envelope on `[0,T)`.
  The initial identity `u 0 = u₀` comes from the actual solution definition.
* `cubicVorticityDifferentialBound_zero`: the globally zero trajectory satisfies
  the new differential hypothesis for every nonnegative compact endpoint and
  positive coefficients. The hypothesis is not inherently empty.
* `clay_reduces_to_uniform_vorticity_envelope`: accurately named version of the
  original conditional reduction; both the envelope and periodic BKM continuation
  remain explicit premises.

In `NS_Millennium_Proof.Stage6`:

* `exponential_profile_hasDerivAt` proves the exact derivative of `M₀ exp(-a t)`.
* `exponential_profile_satisfies_cubic_bound` proves, for `M₀ > 0`, `a ≥ 0`, `κ > 0`
  and `t ≥ 0`, the cubic inequality for this profile with **data-dependent**
  `C = κ M₀`.
* `fixed_cubic_constants_fail_for_some_amplitude` proves, for fixed `C ≥ 0`, `κ > 0`,
  `a ≥ 0`, that some `M > 0` satisfies

      C M² − κ M³ < −a M.

  Thus a uniform-across-amplitudes cubic bound cannot hold for every decaying
  eigenmode. This is NOT a counterexample to constants depending on the datum.

The three Stage6 additions are scalar calculus/algebra theorems. Assembly of the
following vector fields into `IsPeriodicSmoothSolutionOn`, and identification of
their spatial supremum in that representation, are **not newly formalized here**.
The following explicit PDE calculations are a separate mathematical check, not a
claim that the Lean scalar tests already establish that assembly.

## Remaining analytic obligations and reproduction

See [the full correction](docs/VORTICITY_ENVELOPE_CORRECTION.md) for the explicit shear calculations, failed direction-only coercivity, endpoint differentiability obstruction, pinned source links and evidence boundary.

Reproduce with `lake build`, `lake env lean scripts/AxiomAudit.lean`, `lake env lean scripts/EnvelopeCorrectionAudit.lean` and `lake env lean scripts/CertificateAxiomInventory.lean`.

Generated deterministically by `scripts/generate_laTeX_lean_relationship.py` from the maintained correction. This is a documentation mapping, not automatic semantic verification or a novelty assessment.
