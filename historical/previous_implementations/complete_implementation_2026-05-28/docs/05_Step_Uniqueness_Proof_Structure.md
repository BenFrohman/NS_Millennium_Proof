# Step-by-Step Structure for Theorem 2.3 (Uniqueness of the Minimal Tether)

This document mirrors the structure from the audited LaTeX (PASS 2 / Section 2.7) and shows how it is (or will be) formalized in Lean.

## The Three Conditions

**(C1) Invariance under the coadjoint action**  
`InvariantUnderCoadjointAction B`

**(C2) Degeneracy w.r.t. kinetic-energy Hamiltonian**  
`DegenerateWRTKineticEnergy B`

**(C3) Produces controllable negative quadratic feedback**  
`ProducesControllableNegativeFeedback B`

## The 5-Step Classification Argument

### Step 1 — Locality from (C1)
Any admissible correction must be pointwise/local because only powers of |ω|² are invariant under the full SDiff(T³) action.

### Step 2 — Degree Counting
Lowest degree compatible with antisymmetry + bilinearity + invariance is quadratic weighted by |ω|².

### Step 3 — Degeneracy Forces the Projection (C2)
B(F, H) ≡ 0 for the kinetic energy Hamiltonian forces the use of Π_u.

### Step 4 — Coefficient Fixed by (C3)
At a spatial maximum of |ω_ε|², classical stretching gives +C_CZ(3) M_ε².  
The tether must give exactly -κ M_ε² with κ = C_CZ(3) for absorption to work with universal constants.

### Step 5 — Higher-order or Non-projected Terms Are Ruled Out
- Degree ≥4 cannot cancel the quadratic term without solution-dependent constants.
- Non-projected quadratic terms violate (C2).

## Lean Status (as of 2026-05-28)

- The statement of `uniqueness_of_minimal_tether` exists.
- The three conditions are defined.
- The 5-step reasoning is in comments.
- Full formal proof (with named sub-lemmas for each step) is still `sorry`.

This is the highest-priority expansion target.

See `Modules/SymplecticTether.lean` for the current state.
