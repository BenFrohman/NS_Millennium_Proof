# Project History & Priority Claim

**Project:** NS_Millennium_Proof — Frohmanian Symplectic Tether Framework  
**Author:** Benjamin Stanley Frohman (@Investor0x / Bit21)  
**Primary Development Period:** February–June 2026

## Key Milestones

- **2026-02 to 2026-04**: Initial development of the symplectic/holographic dual approach and early tether constructions (living LaTeX document).
- **2026-04-02**: Major LaTeX manuscript ("The Frohman Symplectic and Holographic Dual") finalized with novel conjectures on turbulence singularity.
- **2026-05**: Lean 4 formalization begins. Core geometric layer (ForMathlib.NS.Tether) developed with full 1st-principles derivations, degeneracy lemmas, and the 5-step uniqueness proof for the minimal correction.
- **2026-05-28 to 2026-05-31**: Complete implementation versions stabilized in backup folders.
- **2026-06 to 2026-07**: Recovery from build corruption event. Authorship headers and project-level files (COPYRIGHT.md, AUTHORS.md, HISTORY.md) applied to all original modules.
- **2026-08-26 (WIP)**: Kernel-path restoration of the full restored modules: Lean 4 `kappa` / `C_CZ(3)`, canonical `TetherKernel`, BKM criterion, uniqueness types, quartic Young absorption, and top-level `Modules/` copies. Labeled WIP under Benjamin Stanley Frohman. `lake build NS_Millennium_Proof ForMathlib` succeeds with documented classical `sorry`s.
- **2026-08-26 (attribution)**: Mathlib five-line `Authors: Benjamin Stanley Frohman` headers on original Lean modules; `.mailmap` maps commit aliases `Frohmanian` / `BenFrohman` without rewriting history; PR `Author:` comments for Lean/Zulip contact.
- **2026-08-26 (provenance, branch `kernel/cohesive-tether-kappa-bkm`, PR #8)**: `d23e11e` attribution; `a256cb0` Kato→BKM composition; `deff823` Lyapunov Young composition; `3ae8a10` Fin 3 vs ℝ and ε-Young; `1c76f50` Jacobi `jacobiator = 0` (Lean 4, not True.intro). Author: Benjamin Stanley Frohman (`frohmanbenjamin@gmail.com`). GitHub: @BenFrohman / @Investor0x.
- **2026-08-26 (classical boxes, same branch/PR)**: `496c167` `div_smul` (unconditional, `fderiv_const_smul_field` + `Finset.mul_sum`); `curl_gradient` from mixed partials (`IsSymmSndFDerivAt`); `Tstar` as `EReal` supremum of existence times (no `sorry` def); CoadjointOrbit is the divergence-free subtype; `Pi_u_zero`; energy-zero Euler branch when `u ≡ 0`. Remaining Kato/BKM/stretching/Jacobi sorrys are untranscribed steps in this authorship, not community fill-ins. Author: Benjamin Stanley Frohman.
- **2026-08-26 (certificate path)**: Replace remaining `sorry` *definitions* with real objects: Gâteaux `FunctionalDerivative` (choice of representative), integral Biot–Savart kernel, Gaussian mollifier / convolution, `ComparisonODE` as choice of a C¹ Riccati solution. Live `#print axioms tetherKernel_C3` has **no `sorryAx`**. `comparison_ode_nonneg` closed. Existence of the majorant ODE remains the named theorem `comparison_ode_exists`. The Lean certificate (`#print axioms frohmanian_tether_theorem` without `sorryAx`) is the end goal. Author: Benjamin Stanley Frohman.
- **2026-08-26 (Picard local majorant)**: `comparison_ode_local_exists` kernel-closed via mathlib Picard–Lindelöf (`of_contDiffAt_one` on the polynomial field). Live `#print axioms` has no `sorryAx`. Global `comparison_ode_exists` remains the continuation step. Author: Benjamin Stanley Frohman.

This formalization establishes priority for the **Frohmanian Symplectic Tether Regularity Theorem** as the original solution approach to the 3D Navier–Stokes Millennium Problem.

All original mathematical content (especially the tether kernel, projected bilinear correction, and associated 2-form) is the work of Benjamin Stanley Frohman.

For formal submission or priority claims, this dated record, combined with git history and the dated LaTeX manuscript, serves as primary evidence.

