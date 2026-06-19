# Exhaustive Lean 4 Formalization Roadmap for the Frohmanian Symplectic Tether Proof of 3D Navier-Stokes Global Regularity

**Goal**: Produce a complete, machine-checked Lean 4 proof of global smooth solutions for the 3D incompressible Navier-Stokes equations on T³, following the user's audited LaTeX argument with all non-circularity refinements from the PASS audits.

**Core Principle (to avoid all known Clay pitfalls)**: 
Every analytic estimate used in the global regularity argument must be justified using only objects and properties that have already been rigorously established geometrically or via independent majorants, with explicit verification of key properties (especially degeneracy) on the exact functionals appearing in the estimates. No bootstrap on the maximal existence time for constants. All constants universal or depending only on initial data in a controlled way.

## Strategic Implementation Order (Designed to Avoid Circularity)

### Phase 0: Foundations (No Analysis)
1. Basic spaces: T³, divergence-free fields, Sobolev spaces (use mathlib as much as possible).
2. Vorticity formulation of NS (exact classical equations).
3. Local existence (black-box from parabolic theory, with explicit statement of what it gives: smooth solution on [0, T*) with T* > 0 depending on initial data).

### Phase 1: Geometric Construction (Purely Algebraic/Symplectic)
4. Coadjoint orbit of SDiff(T³), Lie-Poisson structure, Arnold bracket.
5. Kinetic energy Hamiltonian and its vector field (classical Euler).
6. Definition of the projected quadratic tether B(F,G).
7. **Critical early lemma**: Explicit degeneracy B(F_ε, H) = 0 for the exact mollified sup-norm proxy F_ε used later in estimates (LaTeX 2.4.1). This must be proved before any estimate that uses F_ε.
8. Invariance under coadjoint action.
9. Jacobi identity on reduced orbit (via MWR + explicit verification on test functionals).
10. **Canonicity/Uniqueness Theorem (Theorem 2.3)**: The 5-step classification. Prove each step in order, with the coefficient forced exactly by the feedback requirement. This justifies the specific quartic weight in the Lyapunov functional.

### Phase 2: Analytic Estimates with Independent Majorant (Non-Circular by Design)
11. Mollifiers and basic properties.
12. Auxiliary enstrophy accumulation field φ (linear transport).
13. Mollified tethered Lyapunov functional S_ε(t) with the quartic weight justified by Phase 1 uniqueness.
14. Derivation of the differential inequality for S_ε (using only classical stretching bound + integration by parts + universal embeddings).
15. **Independent comparison majorant**: The autonomous ODE y' = C y² - κ'' y³ with global boundedness proved by pure phase-plane analysis (no dependence on NS solution).
16. **Corrected Lemma 3.1 (PASS 5 version)**: On any finite interval [0, T] where a smooth solution exists, the absorption constants are finite by smoothness alone. The independent majorant then gives uniform bound on [0, T]. Taking sup over T < T* gives bound on whole maximal interval without circularity.
17. Passage to limit ε→0, Beale-Kato-Majda, parabolic regularity.

### Phase 3: Assembly and Metriplectic/Holographic Extensions (Optional for Core Result)
18. Full main theorem.
19. Metriplectic formulation.
20. Any additional extensions.

## Current State of the Lean Project (in this mirror)

The files in this folder represent the current snapshot with the structure above partially implemented, following the refinements in the living document and all PASS blocks.

See the individual modules and the docs/ folder for details.

## Pitfalls Explicitly Avoided in This Order

- Using degeneracy only after the estimate (reversed here: degeneracy for the proxy proved in Phase 1).
- Implicit bootstrap on existence time for controlling constants in absorption (fixed by Lemma 3.1 finite-subinterval argument + independent majorant).
- Non-universal constants (everything traced to C_CZ(3) and universal embeddings, forced by uniqueness).
- Assuming global solution to derive bound (independent majorant + local existence + BKM).

This roadmap is the strategic blueprint. Implementation will proceed strictly in the order above.

Next concrete steps will be expanding the files in this folder to fill the `sorry`s in the order listed.
