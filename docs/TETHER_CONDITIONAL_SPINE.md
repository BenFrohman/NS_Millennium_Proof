# Conditional Dependency Spine: Frohmanian Tether → Clay (B)

Author: Benjamin Stanley Frohman  
ORCID: [0009-0006-7068-3718](https://orcid.org/0009-0006-7068-3718)

## Status

Conditional reduction closed under named hypotheses. 0 `sorry` under those hypotheses.  
Axioms: only `propext`, `Classical.choice`, `Quot.sound`.  
No unconditional Clay solution is claimed.

## Root

Mathlib + geometric definitions of coadjoint orbits, Casimir, and necessary conditions (C1)–(C3).

## Primary well-founded path

1. **Geometric canonicity / uniqueness of the minimal tether**  
   `uniqueness_of_minimal_tether` (and symmetric variant).  
   From (C1)–(C3) extracted from the unmodified vorticity equation.

2. **Casimir non-degeneracy and degeneracy on the kinetic-energy Hamiltonian**  
   `tetherKernel_nondegenerate_on_casimir_defect`, `tether_preserves_casimir`, and related degeneracy lemmas.

3. **Tethered Lyapunov / enstrophy differential inequality (conditional)**  
   Explicit named hypothesis: `UniformVorticityEnvelopeBound ν`  
   or `FrohmanianTetherRate` / `CubicVorticityDifferentialBound`.  
   The geometric tether supplies the negative feedback; the rate/envelope is the open analytic input, accepted as a hypothesis.

4. **Comparison-ODE ceiling**  
   `riccati_ceiling_of_vorticity_di` / `classical_vorticity_ceiling`.  
   Uniform bound on `M(t)`.

5. **BKM-style continuation**  
   `PeriodicBKMContinuation ν`.

6. **Terminal node: conditional Clay reduction**  
   `clay_reduces_to_uniform_vorticity_envelope`:  
   If for every positive viscosity both the envelope/rate hypothesis and periodic BKM continuation hold, then `Clay_B_exact` holds.

## Deferred side branches

- Derivation of the rate or uniform vorticity envelope for unmodified Navier–Stokes.  
- Full unconditional resolution of Clay statement (B).  
- Any claim that the geometric tether alone implies the analytic bound.

## Build

```bash
lake exe cache get
lake build
lake env lean scripts/AxiomAudit.lean
```

The reduction is closed once the named rate/envelope hypothesis is accepted.
