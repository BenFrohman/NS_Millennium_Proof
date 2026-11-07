# Correction: uniform envelope versus cubic differential hypothesis

Author: Frohman, Benjamin Stanley <frohmanbenjamin@gmail.com>  
Copyright (c) 2026 Benjamin Stanley Frohman. Existing Apache-2.0 licensing is unchanged.

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

## 3. Bounded PDE attempt: exact identity and obstruction

For a classical unforced incompressible solution, write `ω = curl u`,
`S = (∇u + (∇u)^T)/2`, and `ρ = |ω|`. The vorticity equation gives

    (∂t + u·∇)(|ω|²/2)
      = ω·Sω + ν Δ(|ω|²/2) − ν |∇ω|².

Where `ρ > 0`, put `ξ = ω/ρ`. Differentiating `|ξ|² = 1` gives

    |∇ω|² = |∇ρ|² + ρ² |∇ξ|²,
    (∂t + u·∇ − νΔ)ρ = ρ ξ·Sξ − νρ |∇ξ|².

At a positive spatial maximum, `∇ρ = 0` and `Δρ ≤ 0`. These identities do not
produce a lower bound on `|∇ξ|²` in terms of `M = max ρ`. In a rigorous
maximum-in-time argument, one must also handle maximizing-branch switches with a
one-sided/Dini derivative, rather than assume that `M` is ordinarily differentiable.

### 3a. Fixed coefficients fail across the Beltrami family

On the unit-period torus let `ν > 0`, `t ≥ 0`, `k = 2π`, `a = νk²`, `A > 0`, and

    u_A(t,x) = A exp(-a t) (sin(k x₃), cos(k x₃), 0),    p = 0.

Direct differentiation gives `div u_A = 0`, `(u_A·∇)u_A = 0`,
`Δu_A = -k²u_A`, `∂t u_A = νΔu_A`, and `curl u_A = k u_A`.
Hence

    M_A(t) = k A exp(-a t),    M_A' = -a M_A.

At time zero the proposed differential bound is equivalent to

    κ M_A(0)² − C M_A(0) − a ≤ 0.

For fixed `C,κ,a` this fails at sufficiently large `A`; the quantified scalar
obstruction is checked in Lean. But the existing envelope allows the constants
to depend on `A`. Indeed, `C = κ M_A(0)` makes the cubic right-hand side nonnegative
for all `t ≥ 0`, while `M_A' ≤ 0`; this positive special-case test is also checked.
There is no disproof of the data-dependent envelope here.

### 3b. Direction-gradient-only coercivity fails even for a fixed smooth datum

Consider instead the single-component periodic shear

    v_A(t,x) = A exp(-a t) (sin(k x₃), 0, 0),    p = 0.

It also satisfies the unforced Navier–Stokes equations by the same heat,
divergence and convection calculation. Its vorticity is

    ω_A(t,x) = (0, k A exp(-a t) cos(k x₃), 0).

At `x₃ = 0`, its norm is the positive global maximum `M = k A exp(-a t)`.
In a neighborhood of that point `cos(k x₃) > 0`, so `ξ = (0,1,0)` is constant and

    |∇ξ|² = 0.

Consequently the bare coercivity premise appearing in
`viscous_direction_dissipation_bridge`,

    κ M² ≤ ν |∇ξ|²,

is false there for **every** `κ > 0`, even if `κ` depends on this initial datum.
This refutes promotion of that premise to an unconditional statement at every
positive vorticity maximum. It does not refute the existing implication, which
assumes the premise, or a different estimate restricted above a data-dependent
threshold. The shear has amplitude curvature instead:

    ω_A·Δω_A = -k² M²,    M' = -νk² M.

Discarding amplitude curvature and retaining direction dissipation alone loses
this actual viscous damping. A valid general argument must control the full net
stretching/viscous source (or another justified mechanism), not assert that all
positive maxima have nonzero direction curvature.

### 3c. Scaling does not supply a uniform positive cubic coefficient

Under the parabolic rescaling `u_λ(t,x) = λ u(λ²t, λx)`,
`M_λ(t) = λ² M(λ²t)`, and its time derivative scales by `λ⁴` wherever it exists.
Thus a cubic inequality rescales with `C_λ = C` and `κ_λ = κ/λ²`, not a fixed
positive `κ`. Similarly `ν|∇ξ|²` scales by `λ²` whereas `M²` scales by `λ⁴`.
This is not a contradiction when the coefficient is allowed to depend on the
initial datum. On the fixed unit torus, the displayed transformation preserves
unit periodicity for positive integer `λ`; arbitrary domain rescalings must not
be silently identified with the same torus.

The source's separate scale-homogeneous premise `κ_eff M ≤ ν|∇ξ|²` only yields
`M' ≤ (C − κ_eff) M²`, as its actual theorem body states. It does not yield the
stronger cubic-in-`M` damping inequality. Scaling is not a proof of either
coercivity premise.

### 3d. Exact remaining analytic obligation

For a general periodic solution the desired sufficient net-source estimate is,
at the relevant positive maxima,

    ω·Sω + ν ω·Δω ≤ C M³ − κ M⁴,

with positive coefficients uniform in time/lifespan and suitably quantified over
the initial datum and solution. Division by `M` gives the desired cubic norm rate
once the maximum-derivative argument is justified. The existing source-reduction
lemmas prove this algebra **conditionally**; they do not derive that net-source
estimate from the PDE. An endpoint `L∞` Calderón–Zygmund estimate
`|∇u| ≤ C |ω|∞` is not available in general and cannot silently supply it either.

No such general source estimate is proved by this correction. The single-shear
example shows why one proposed stronger direction-only route cannot prove it
without additional restrictions. An adequate Dini/one-sided comparison theorem
and a solution-linked source estimate remain further formal/analytic obligations.

## 4. Endpoint representation obstruction

`IsPeriodicSmoothSolutionOn` constrains a velocity only for nonnegative times.
Thus it cannot imply ordinary `DifferentiableAt ℝ M 0` for *every* represented
solution: extend the zero forward solution by the nonzero time-independent
Beltrami field `(sin(k x₃), cos(k x₃), 0)` for negative times. It is still the zero
solution on `[0,T)`, with zero pressure and zero initial datum, but its actual
spatial vorticity supremum jumps from `k` to zero at time zero.

This is an obstruction to a blanket ordinary two-sided differentiability claim
about this representation, not to right-sided PDE smoothness. Even a compatible
extension does not automatically remove interior supremum branch switches.
Accordingly, the new compact predicate is an **explicit conditional hypothesis on
a given trajectory**, not a purported theorem for all local solution representations.
The globally zero trajectory passes the Lean regression; the arbitrary negative
extension is a different trajectory. A general PDE bridge should use an appropriate
one-sided/Dini formulation or explicitly justify a compatible norm extension.

## 5. Reproduction and evidence boundary

Run `lake build`, `lake env lean scripts/AxiomAudit.lean`, and
`lake env lean scripts/EnvelopeCorrectionAudit.lean`, and
`lake env lean scripts/CertificateAxiomInventory.lean`. The correction audit checks historical
API compatibility and prints every new theorem's axiom dependencies. CI runs it
after the full build, alongside the per-theorem inventory. No new axiom, `sorry` or `native_decide` is introduced.
An axiom audit is not a semantic correctness or mathematical novelty certificate.

The accompanying review bundle records source hashes, exact toolchain/package
pins, logs, and project compiled artifacts. It does not contain Mathlib itself or
constitute an independently trusted standalone proof certificate. Rebuild the
sources against the pinned dependencies to reproduce the conditional statements.
The published PDFs and Zenodo records are unchanged; this source correction does
not repair or republish earlier archives.

### Pinned source references (before this correction)

* [Actual uniform-envelope definition and its reduction](https://github.com/BenFrohman/NS_Millennium_Proof/blob/c98fe859867affeba4508b3e51583cfa6b20087c/NS_Millennium_Proof/Modules/HighSetDepletionAndBKM.lean#L187-L223).
* [Direction-coercivity premise and conditional bridge](https://github.com/BenFrohman/NS_Millennium_Proof/blob/c98fe859867affeba4508b3e51583cfa6b20087c/NS_Millennium_Proof/Modules/HighSetDepletionAndBKM.lean#L68-L91).
* [Compact ODE comparison and all its premises](https://github.com/BenFrohman/NS_Millennium_Proof/blob/c98fe859867affeba4508b3e51583cfa6b20087c/NS_Millennium_Proof/Modules/HighSetDepletionAndBKM.lean#L142-L177).
* [Actual half-open periodic solution representation](https://github.com/BenFrohman/NS_Millennium_Proof/blob/c98fe859867affeba4508b3e51583cfa6b20087c/NS_Millennium_Proof/Modules/ClayStatements.lean#L552-L560).
* [Vorticity transport pairing with explicit PDE/regularity premises](https://github.com/BenFrohman/NS_Millennium_Proof/blob/c98fe859867affeba4508b3e51583cfa6b20087c/NS_Millennium_Proof/Modules/NS_Equations.lean#L2930-L2985).
* [Existing component-wise shear/Beltrami calculus](https://github.com/BenFrohman/NS_Millennium_Proof/blob/c98fe859867affeba4508b3e51583cfa6b20087c/NS_Millennium_Proof/Modules/Stage6Calculus.lean#L117-L189).
