# Lyapunov identities and the cubic sink — status

**Author:** Benjamin Stanley Frohman
**Date:** 2026-11-23 (America/Chicago)
**Status:** The cubic / quartic sink is a **hypothesized majorant**, not a theorem of the unforced 3D periodic Navier–Stokes vorticity equation.
**Lean source of record:** `Modules/TetheredLyapunov.lean`, `Modules/CubicSourceCertificate.lean`, `Modules/LyapunovDIStatus.lean`.
**Historical source of record:** [HISTORY.md](../HISTORY.md) entry **2026-08-31 (classical §10 identities; no fake sextic sink)**.

This note records what the kernel already checks, and what remains a named hypothesis. Nothing below fake-closes `hIdent`, `hRiccati`, Kato, BKM, or `frohmanian_tether_theorem`. No `sorry` is added.

## Construction order of the remaining gaps

1. **Geometric tether uniqueness first.** The live uniqueness theorem is `uniqueness_of_minimal_tether` in `Modules/Uniqueness.lean` (minimal uniqueness among corrections that saturate the C3 quadratic form and polarize). That is a geometric statement. It is not an analytic bound on unmodified Navier–Stokes.
2. **The analytic majorant is a separate comparison.** Once a rate of the form \(M' \le C M^2 - \kappa'' M^3\) is *assumed*, the comparison ODE and the ceiling theorems (`comparison_ode_exists`, `comparison_ode_stability`, `riccati_ceiling_of_vorticity_di`, `classical_vorticity_ceiling`) apply. Those implications are not a derivation of the rate.
3. **The corrected-rate subtraction is a hypothesis.** `CorrectedMaxRate` (and the paper's tether identification that would justify it) is labeled as a hypothesis, not a theorem about the stretching pairing or about \(B_F\).

Degeneracy \(B(F,H)\equiv 0\) on the kinetic-energy Hamiltonian (`tetherKernel_degenerates_on_kinetic_energy`) keeps the kinetic-energy Hamiltonian vector field classical. It does not supply the cubic sink.

## What the unforced equation actually gives

The classical unforced 3D periodic vorticity equation does **not** produce a controllable cubic or quartic sink. The checked identities are as follows. Each name was verified as a live `theorem` or `def` in this repository, except where a discrepancy is called out.

### Unweighted density

`hasDerivAt_lyapunov_density_unweighted` (`Modules/TetheredLyapunov.lean`):

\[
\frac{d}{dt}\Bigl(\tfrac12|v|^2 + \tfrac{\kappa}{4}|v|^4\Bigr) = \langle v, v'\rangle\,(1 + \kappa|v|^2).
\]

### Stretching at a spatial maximum is a source

`stretching_inner_le_at_max` (`Modules/NS_Equations.lean`): at a spatial maximum,

\[
\langle \omega, (\omega\cdot\nabla)u \rangle \le C_{\mathrm{CZ}} M^3
\]

(a cubic **source**, not a sink). The product rule multiplies by the positive factor \((1+\kappa M^2)\), which yields

\[
s_\kappa' \le C_{\mathrm{CZ}} M^3(1+\kappa M^2) = C_{\mathrm{CZ}} M^3 + C_{\mathrm{CZ}}\kappa M^5.
\]

Both terms are sources. Equivalently, \(M' \le C_{\mathrm{CZ}} M^2\) (a quadratic majorant). This algebra is recorded as `weighted_source_polynomial` in `Modules/CubicSourceCertificate.lean`. Identity (2) / the stretching identity alone does not produce the Riccati sink.

### Plus-weight along the enstrophy source \(\varphi' = |v|^2\)

`hasDerivAt_lyapunov_plus_of_enstrophy_source`:

\[
\frac{d}{dt}\Bigl(\tfrac12|v|^2 + \tfrac{\kappa}{4}|v|^4\varphi\Bigr)
= \langle v,v'\rangle\bigl(1+\kappa|v|^2\varphi\bigr) + \tfrac{\kappa}{4}|v|^6.
\]

The sextic coming from the source is **positive**. It is not \(-\kappa|v|^6\).

### Minus-weight (coefficient \(\kappa/2\))

`hasDerivAt_lyapunov_minus_of_enstrophy_source` is the live identity

\[
\frac{d}{dt}\Bigl(\tfrac12|v|^2 - \tfrac{\kappa}{2}|v|^4\varphi\Bigr)
= \langle v,v'\rangle\bigl(1-2\kappa|v|^2\varphi\bigr) - \tfrac{\kappa}{2}|v|^6.
\]

(The handoff compressed the right-hand side to the sextic term alone; the Lean statement also has the product-rule factor \(1-2\kappa|v|^2\varphi\).) The sextic is negative, but the functional is not a coercive upper bound on enstrophy: `lyapunovSminus_density_neg_of_large_weight` shows that the density is strictly negative when \(|\omega|^2\varphi > 1/\kappa\).

### Sign-flipped \(\kappa/4\) version and the threshold \(2/\kappa\)

No Lean declaration was found for a sign-flipped \(\kappa/4\) Lyapunov density, nor for a coercivity-loss theorem at the exact threshold \(2/\kappa\). The live coercivity-failure theorem is `lyapunovSminus_density_neg_of_large_weight` at threshold \(1/\kappa\) for the \(\kappa/2\) minus-weight. That gap is reported here rather than filled with a new name.

## The cubic rate is a hypothesized majorant

The cubic sink

\[
M' \le M(C M - \kappa M^2) = C M^2 - \kappa M^3
\]

(and the comparison field \(y' = C y^2 - \kappa'' y^3\)) is a hypothesized `CorrectedMaxRate` / tether identification. It is **not** derived from the stretching identity.

`CorrectedMaxRate` is a `def … : Prop` in `Modules/CubicSourceCertificate.lean`. The certificate header of that file states, verbatim in substance: the rate already assumed to carry the strain subtraction \(C_{\mathrm{CZ}} M - \kappa M^2\) is **not derived from** \(\omega\cdot\partial_t\omega\); `ReducedStrain` is “recorded and not proved”; “The hypothesis is not a theorem about \(B_F\).” The algebraic lemma `cubic_sink_of_corrected_rate` only expands that hypothesis.

[HISTORY.md](../HISTORY.md), **2026-08-31**, states: “The Riccati sink \(y' = C y^2 - \kappa'' y^3\) is not derived from (2). Kato / BKM / `hIdent` remain named; `frohmanian_tether_theorem` is not fake-closed.”

The README already says `ns_global_regularity_of_cubic_damped_rate` assumes \(M' \le C M^2 - \kappa'' M^3\) and does not derive it. That wording is kept.

## Named items that stay open

| Name | What it is in Lean | Status |
| --- | --- | --- |
| `CorrectedMaxRate` | `def … : Prop` | Open hypothesis |
| `hIdent` | Hypothesis binder on identification lemmas (not a standalone declaration) | Open |
| `hRiccati` | Hypothesis binder, typically `FrohmanianTetherBound` or a finite-time vorticity bound (not a standalone declaration) | Open |
| Kato | Binders such as `KatoLocalWitness` / `hKato` | Open as a library formalization of classical local existence |
| BKM | Binders such as `PhysicalBKMContinuationCriterionFor`, and the open `Prop`s `BKMClosingCriterion`, `PeriodicBKMContinuation` | Open |
| `frohmanian_tether_theorem` | Theorem that takes the open analytic hypotheses | Conditional; not fake-closed |
| `FrohmanianTetherRate`, `FrohmanianTetherClosingBound`, `UniformVorticityEnvelopeBound`, `CubicVorticityDifferentialBound` | Named `Prop`s | Open |

`Modules/LyapunovDIStatus.lean` records a further honesty point: the intended N1 name `lyapunov_differential_inequality` has never existed as a declaration, and the private lemmas that conclude a similar inequality are vacuous as stated because they require `MemLp (fun _ => 1) 3 volume` on the model space `T3 = ℝ³`.

## Documentation corrections made with this note

- [HANDOVER-2026-11-23.md](../HANDOVER-2026-11-23.md) used the phrase “cubic rate … derived from energy-class initial data.” That wording is corrected: the rate is hypothesized, not derived from energy-class data or from the stretching identity.
- Root `main.tex` proposition `prop:ceiling` is the **proved implication** “cubic rate \(\Rightarrow\) ceiling,” which is `riccati_ceiling_of_vorticity_di`. The header is aligned with `manuscript/main.tex` by marking the premise unresolved. The implication itself is not weakened.
- [docs/VorticityEnvelopeCorrection.tex](VorticityEnvelopeCorrection.tex) already states that a sufficient net-source estimate would give the cubic rate, and that the repository proves the algebra conditionally, not that general estimate. No change was required there.

No kernel-certified statement is weakened.
