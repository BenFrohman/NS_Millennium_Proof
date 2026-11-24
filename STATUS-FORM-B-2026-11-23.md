# Form B Conditional Theorem — Status Note (2026-11-23)

**Author:** Benjamin Stanley Frohman  
**Status:** Conditional. Form B (the integral bound on strain) is an open hypothesis.  
**Purpose:** Clean handover statement for GitHub Actions and Zenodo bots. Do not claim an unconditional solution of the Clay problem.

## Conditional theorem (Form B ⇒ global regularity)

Let $s > 5/2$ and let $u_0 \in H^s(\mathbb{T}^3; \mathbb{R}^3)$ satisfy $\operatorname{div} u_0 = 0$. Let $u$ be the Kato solution of the unmodified incompressible Navier–Stokes equations

$$
\partial_t u + (u \cdot \nabla) u = \nu \Delta u - \nabla p, \qquad \operatorname{div} u = 0
$$

on its maximal interval of existence $[0, T_*)$. Write $\omega = \nabla \times u$,

$$
M(t) := \|\omega(t)\|_{L^\infty(\mathbb{T}^3)},
$$

and let $S = \frac12\bigl(\nabla u + (\nabla u)^T\bigr)$ be the strain.

**Assumption (Form B).** For every finite $T < T_*$,

$$
\int_0^T \|S(t)\|_{L^\infty(\mathbb{T}^3)}\, dt \le C_*\bigl(\|u_0\|_{H^s}, \nu, T\bigr)
$$

with the constant finite and depending only on the initial datum, viscosity, and $T$.

**Conclusion.** $T_* = \infty$ and $u \in C^\infty(\mathbb{T}^3 \times [0, \infty))$.

### Proof sketch (classical ingredients only)

The vorticity satisfies the unmodified transport-diffusion equation. The stretching term reduces to $S\omega$. The maximum principle yields

$$
\frac{d}{dt} \log M(t) \le \|S(t)\|_{L^\infty}.
$$

Integration and Form B keep $M(t)$ finite on every compact subinterval of $[0, T_*)$. Beale–Kato–Majda then forces $T_* = \infty$. Parabolic regularity and Calderón–Zygmund control of the pressure on the torus bootstrap to $C^\infty$.

Form B is an explicit hypothesis and is not discharged.

## What is not claimed

- Form B itself is not proved for arbitrary smooth divergence-free $u_0$.
- The integral $\int_0^T \|S(t)\|_{L^\infty}\,dt$ is finite on compact subintervals of the existence interval by continuity of the Kato solution, but that finiteness is solution-dependent and does not supply a data-only constant $C_*$.
- Small-data (Fujita–Kato) and short-time regimes do satisfy Form B; neither covers arbitrary large data on arbitrarily long intervals.
- No theorem in the Lean scaffolding (`Modules/ClayStatements.lean` and related) proves `FrohmanianTetherClosingBound` or `BKMClosingCriterion`. Both remain open `def … : Prop`.

## Lean scaffolding status

- Conditional implications (if the closing bound holds, then regularity follows, given classical local-theory binders) are formalized.
- Open targets (`FrohmanianTetherClosingBound`, `BKMClosingCriterion`, `Clay_A`, `Clay_B_exact`, etc.) are declared as `Prop`s and are not assumed except as explicit hypotheses.
- Uniqueness binder in some statements quantifies only over spatial smoothness and is unsatisfiable as written (step-field counterexample). This is a formalization issue, not a proof of the integral bound.

## Zenodo / publication notes

Existing records (e.g. DOI 10.5281/zenodo.23717084 and companions) describe conditional reductions. Any new deposit must preserve the distinction:

- Conditional theorem: classical, correctly typed.
- Form B / H1 integral bound: open.
- Do not title or describe any deposit as an unconditional solution of the Clay Navier–Stokes problem.

This note is the authoritative current summary for bots and merge processes.
