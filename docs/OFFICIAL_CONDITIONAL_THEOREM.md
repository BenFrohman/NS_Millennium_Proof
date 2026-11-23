# Official Conditional Theorem (Form B of H1) — November 2026

**Author:** Benjamin Stanley Frohman
**ORCID:** [0009-0006-7068-3718](https://orcid.org/0009-0006-7068-3718)
**Status:** Conditional. Form B / H1 is an **open** hypothesis. This document does **not** claim a solution of the Clay Navier–Stokes problem.
**Companion notes:** [STATUS-FORM-B-2026-11-23.md](../STATUS-FORM-B-2026-11-23.md), [LYAPUNOV_CUBIC_SINK_STATUS.md](LYAPUNOV_CUBIC_SINK_STATUS.md), [TETHER_CONDITIONAL_SPINE.md](TETHER_CONDITIONAL_SPINE.md), [HISTORY.md](../HISTORY.md).

This is the official proposed theorem for unmodified 3D incompressible Navier–Stokes on \(\mathbb{T}^3\), recorded so that the statement, the Lean names, and the open status stay aligned.

## The theorem (Form B \(\Rightarrow\) global regularity)

Let \(s > 5/2\) and let \(u_0 \in H^s(\mathbb{T}^3; \mathbb{R}^3)\) be divergence-free. Let \(u\) be the Kato solution of the unmodified incompressible Navier–Stokes equations on its maximal interval of existence \([0, T_*)\). Write \(\omega = \nabla \times u\),

\[
M(t) := \|\omega(t)\|_{L^\infty(\mathbb{T}^3)},
\]

and let \(S = \tfrac12\bigl(\nabla u + (\nabla u)^\top\bigr)\) be the strain.

**Assumption (Form B of H1).** For every finite \(T < T_*\),

\[
\int_0^T \|S(t)\|_{L^\infty(\mathbb{T}^3)}\, dt \le C_*\bigl(\|u_0\|_{H^s}, \nu, T\bigr)
\]

with \(C_*\) finite and depending only on the initial datum, viscosity, and \(T\).

**Conclusion.** \(T_* = \infty\) and \(u \in C^\infty(\mathbb{T}^3 \times [0,\infty))\).

### Why this implication is classical

The vorticity of the unmodified equations satisfies the transport-diffusion equation, and stretching reduces to \(S\omega\). The log-maximum identity is

\[
\frac{d}{dt}\log M(t) \le \|S(t)\|_{L^\infty}.
\]

Integration and Form B keep \(M(t)\) finite on every compact subinterval of \([0,T_*)\). One-directional Beale–Kato–Majda then forces \(T_* = \infty\). Parabolic regularity bootstraps to \(C^\infty\).

Form B is an explicit hypothesis and is **not proved**. For classical solutions on \(\mathbb{T}^3\) it is equivalent in strength to the Clay statement. It remains open.

### Known regimes, and what is still open

- Fujita–Kato small data in \(\dot H^{1/2}\) satisfy Form B.
- Short-time local existence is controlled by \(\|u_0\|_{H^s}\), so Form B holds on a short interval.
- Unconditional Form B for arbitrary large data on arbitrary finite intervals is **open**.

The integral \(\int_0^T \|S(t)\|_{L^\infty}\,dt\) is finite on compact subintervals of the existence interval by continuity of the Kato solution, but that finiteness is solution-dependent and does not supply a data-only constant \(C_*\).

## Geometric layer: recovers the unmodified vorticity equation, does not imply Form B

The Frohmanian tether is the bilinear correction

\[
B(F,G) = -\kappa \int_{\mathbb{T}^3} |\omega|^2 \Bigl( \Pi_u \frac{\delta F}{\delta\omega} \cdot \Pi_u \frac{\delta G}{\delta\omega} \Bigr)\, dV
\]

with \(\kappa = C_{\mathrm{CZ}}(3) = 3/2\), and with \(\Pi_u\) the projector appearing in the velocity slot (C2). The geometric package — degeneracy \(B(F,H)\equiv 0\) on the kinetic-energy Hamiltonian, coadjoint invariance, the metriplectic/MWR reduction, and the 5-step canonicity of the lowest-degree polynomial-in-\(\omega\) correction — is intended to recover the unmodified vorticity equation. That geometric layer **does not currently imply Form B non-circularly**. The critical analytic estimates remain named open hypotheses (or, in older archived modules only, `sorry`).

Live Lean names for the \(\kappa = 3/2\) algebra, in `ForMathlib/NS/Tether.lean` (namespace `NS.FrohmanianTether`):

- `CalderonZygmundConstant3D` (definition: prefactor times area of \(S^2\))
- `CalderonZygmundConstant3D_eq_three_halves` : `CalderonZygmundConstant3D = 3/2`
- `CalderonZygmundConstant3D_ne_one`, `CalderonZygmundConstant3D_pos`
- `kappa` (notation `κ`), `kappa_eq_three_halves`, `kappa_ne_one`, `kappa_pos`

The kernel \(A(\theta,\omega)\) identification of the Biot–Savart strain kernel is recorded in that same file as `biotSavartStrainKernelPrefactor` (the Constantin–Fefferman / Majda–Bertozzi prefactor \(3/(8\pi)\)). The Iteration 11 \(\kappa=3/2\) ledger PDF named in the handoff was **not found** (see [official-conditional-theorem/PROVENANCE.md](official-conditional-theorem/PROVENANCE.md)).

Degeneracy on the kinetic-energy Hamiltonian is the live theorem `tetherKernel_degenerates_on_kinetic_energy` in `Modules/SymplecticTether.lean`. The name `tether_preserves_casimir`, which appears in the README scope list, **is not a Lean declaration** in this repository. Closest live names include `tetherKernel_nondegenerate_on_casimir_defect`, `casimir_const_on_orbit`, `casimir_invariant`, and `HelicityCasimir`.

## Lean scaffolding (checked on `origin/main` at the start of this note)

`Modules/ClayStatements.lean`:

- `FrohmanianTetherClosingBound` and `BKMClosingCriterion` are `def … : Prop` (open targets, not theorems).
- `frohmanian_global_regularity_of_closing_bound` and `bkm_of_closing_bound` take the closing bound as an explicit hypothesis.
- `Clay_A` and `Clay_B_exact` are likewise open `def … : Prop`.

`Modules/MainTheorem.lean` / `NS_Millennium_Proof/Modules/HighSetDepletionAndBKM.lean`:

- `UniformVorticityEnvelopeBound` is an `abbrev` for an assumed uniform ceiling (not a differential inequality).
- `DirectionCurvatureBound` is a historical alias of that envelope.
- `CubicVorticityDifferentialBound` is the actual cubic-rate predicate on \(M(t)\); it is assumed, not derived from the unforced PDE.
- `clay_reduces_to_uniform_vorticity_envelope` is the proved reduction: if the envelope and `PeriodicBKMContinuation` hold for every \(\nu > 0\), then `Clay_B_exact` holds. Both premises stay open.

`FrohmanianTetherRate` and `FrohmanianTetherBound` exist as `abbrev`/`def` of `Prop` in `Modules/SymplecticTether.lean` (and related modules). `frohmanian_tether_theorem` takes such hypotheses; it is not an unconditional regularity theorem.

`IsPeriodicSmoothSolution` is defined in `Modules/ClayStatements.lean` (and `Modules/NS_Equations.lean`).

### Uniqueness-binder issue (does not fill Form B)

`Modules/ClayStatements.lean` records that the library's uniqueness binder, as originally written, is unsatisfiable at \(u_0 = 0\): a spatially smooth step field can meet an unpatched `NS_PDE` predicate because Mathlib `deriv` is \(0\) off the differentiability set. That is a formalization issue. It does **not** prove or discharge the strain-integral bound. See `library_huniq_unsatisfiable_at_zero` and the surrounding audit section. The Clay-facing class is `IsPeriodicSmoothSolution`.

### Named remainders (stay open; never fake-closed)

Hypothesis binders, not standalone declarations: `hIdent`, `hRiccati`. Classical local-theory binders used by `global_regularity_for_NS` include `KatoLocalWitness` / `hKato`, `PhysicalBKMContinuationCriterionFor` / `hcrit`, and uniqueness `huniq`. `PeriodicBKMContinuation` is a named open `Prop`.

`tethered_jacobi_identity` is a two-line implication: if `hident` and `hvanish` hold, the Jacobiator is zero. It does not by itself prove that the cyclic integrand vanishes. The name `h_cyclic_integrand_zero` appears in comments and in older notes; it is **not** a Lean declaration.

## April 2026 manuscript

The April 2026 manuscript's claim of (unconditional) global regularity is **superseded** and is corrected to this conditional statement. The manuscript itself is not deleted; it remains in the historical record and in companion repositories. See the 2026-11-23 entry in [HISTORY.md](../HISTORY.md).

## Artifacts

The cover PDF is archived at [official-conditional-theorem/00_COVER_Official_Proposed_Theorem.pdf](official-conditional-theorem/00_COVER_Official_Proposed_Theorem.pdf). The Iteration 11 tex/PDF pack, the H1-trials PDF, and the \(\kappa=3/2\) stretching-remainders ledger were not found on this computer, on Google Drive (exact filename search), or in GitHub code search. They are listed in the provenance file rather than reconstructed.

No Clay solution is claimed.
