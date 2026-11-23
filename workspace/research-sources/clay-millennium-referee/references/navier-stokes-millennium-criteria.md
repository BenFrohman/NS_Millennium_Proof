# Navier–Stokes Existence and Smoothness Problem – Clay Institute Official Criteria & Common Pitfalls

## Official Problem Statement (Fefferman, 2000)
The Clay Mathematics Institute Millennium Prize Problem for the 3D incompressible Navier–Stokes equations asks:

> Does there exist a global smooth solution to the 3D incompressible Navier–Stokes equations for **arbitrary** smooth, divergence-free initial data? Or can singularities form in finite time?

**Exact requirements for a positive solution (global regularity):**
- For every smooth, divergence-free initial velocity field \(u_0\) (on \(\mathbb{T}^3\) or \(\mathbb{R}^3\) with suitable decay), there exists a unique smooth solution \(u(x,t)\) for all \(t > 0\).
- The solution must remain smooth (in the classical sense) globally in time.
- The result must hold **uniformly** for arbitrary smooth initial data (no smallness, symmetry, or special structure assumptions on \(u_0\)).
- The proof must work for the **exact** unmodified equations (no artificial regularization, no extra terms that are not absorbed into pressure after Leray projection).

**What constitutes a valid proof (Clay standards):**
- Complete rigor with every estimate justified from first principles.
- No circular reasoning.
- No hidden regularity assumptions.
- Full control of constants (dependence only on norms of initial data and viscosity).
- Clear passage to limits (mollifiers, approximations, etc.).
- The claimed dynamics must reproduce the original PDE exactly.

## Common Fatal Pitfalls in Submitted Attempts
1. **Assuming the desired bound** (e.g., assuming \(\|\omega\|_\infty\) is bounded to derive the bound — circular).
2. **Modifying the equations** without proving equivalence back to the original NS (extra terms must be shown to be pure gradients or absorbed into pressure).
3. **Degeneracy vs. Nonzero Contribution Contradiction**: Claiming a correction term vanishes on the Hamiltonian (degeneracy) while simultaneously claiming it produces the decisive negative quadratic term in the sup-norm evolution.
4. **Hamiltonian vs. Dissipative Dynamics**: Pure symplectic/Hamiltonian structures conserve kinetic energy. Viscous NS dissipates it. Any construction must explicitly separate reversible and dissipative parts (metriplectic) or reconcile this.
5. **Incorrect stretching coefficient**: Asserting the vortex stretching term contributes exactly "+1" at a maximum point without rigorous calculation. The actual bound involves the operator norm of the Calderón–Zygmund operator \(\nabla \circ \text{Biot-Savart}\), which is strictly greater than 1 in general.
6. **Failure of uniformity**: Constants that secretly depend on the solution itself rather than only on \(\|u_0\|_{H^s}\).
7. **Missing limit justifications**: Mollifier estimates, interchange of derivatives and limits, dominated convergence in infinite dimensions.
8. **Ad-hoc choices**: Picking constants or corrections "to make the bound work" without derivation from the PDE or coadjoint structure.
9. **Not matching the exact problem**: Proving regularity only for small data, axisymmetric flows, or regularized equations.

## Key Mathematical Objects That Must Be Handled Rigorously
- Vorticity transport equation: \(\frac{D\omega}{Dt} = (\omega \cdot \nabla)u + \nu \Delta \omega\)
- Beale–Kato–Majda criterion
- Energy equality / inequality
- Calderón–Zygmund estimates for Biot-Savart law
- Mollifier approximations and maximum principle
- Leray projector and pressure reconstruction
- Passage from mollified to original quantities

Any proof attempt must explicitly address these with complete estimates.