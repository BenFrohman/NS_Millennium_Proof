# Phase 0 and Phase 1 Implementation Plan (Strategic Order)

**Goal for this phase**: Establish all geometric foundations and prove the critical early lemma (degeneracy for the mollified sup-norm proxy) BEFORE any analytic estimates. This is the #1 way to avoid circularity pitfalls.

## Exact Order of Implementation (Do Not Deviate)

### Phase 0.1 - Basic Definitions (no analysis)
- Precise definition of T³ (as manifold or quotient)
- VelocityField, VorticityField, divergence-free condition
- NS_PDE exact statement (unmodified classical form)
- Local existence theorem statement (what it precisely gives: smooth solution on [0,T*), T* depends only on ||u0||_H^s )

### Phase 0.2 - Geometric Setup
- CoadjointOrbit
- ClassicalBracket (Arnold Lie-Poisson)
- KineticEnergyHamiltonian
- velocity_from_vorticity (Biot-Savart)

### Phase 1.1 - The Tether Construction
- Pi_u definition
- TetherKernel (projected quadratic form)
- TetheredBracket

### Phase 1.2 - The Three Conditions as Props
- InvariantUnderCoadjointAction
- DegenerateWRTKineticEnergy
- ProducesControllableNegativeFeedback

### Phase 1.3 - The Critical Early Lemma (MUST come before any estimate)
- MollifiedSupNormFunctional (the exact proxy used in Section 3)
- degeneracy_for_mollified_sup_norm_proxy : TetherKernel ... F_ε ... H = 0
  This must be a fully structured theorem with all supporting lemmas (functional derivative of the proxy, Pi_u(u)=0, etc.)

### Phase 1.4 - Other Geometric Properties
- Invariance lemma
- Jacobi identity (at least for test functionals)

### Phase 1.5 - Uniqueness/Canonicity (Theorem 2.3)
- The 5-step proof with all intermediate named lemmas (we already have the skeleton expanded)

Only after the above is in place (even with some inner sorrys) do we move to Phase 2 analytic estimates.

This order is non-negotiable per the living document + all PASS audits.
