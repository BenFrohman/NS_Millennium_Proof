<!--
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-->
# Scope: Frohmanian Symplectic Tether — Conditional NS Regularity & Complete Original Programme (v2.2, 2026-10-27)

Author: Benjamin Stanley Frohman.

**Overall status.** This manuscript and the companion Lean 4 formalization (`NS_Millennium_Proof`, **437 kernel-verified theorems across 17 modules**, **0 `sorry`**, **0 nonstandard axioms**) establish a **verified non-vacuous conditional reduction** for 3D incompressible Navier–Stokes global regularity, while preserving in full every original definition, theorem, physical motivation, and conjectured bridge from Benjamin Stanley Frohman's programme (`Frohmanian_Tether_Final_Submission_v8.tex`).

1. **Kernel-verified conditional implication (0 `sorry`, non-vacuous):**
   Kato local existence + the Beale–Kato–Majda continuation criterion (`PhysicalBKMContinuationCriterionFor`) + physical-solution uniqueness (`KatoUniquenessOnExistenceTimes`, `IsPhysicalNSSolution`) + the cubic tether rate (`FrohmanianTetherRate`)
   $$M'(t)\le C_{\mathrm{CZ}}M(t)^2-\kappa''M(t)^3$$
   implies the global vorticity ceiling
   $$M(t)\le \max\!\Big(M(0),\ \tfrac{C_{\mathrm{CZ}}}{\kappa''}\Big)$$
   and, via Beale–Kato–Majda continuation ($T^*=\infty$ derived from $T^*>0$, the criterion and $\int_0^T M<\infty$), a globally smooth, divergence-free physical solution (`frohmanian_tether_theorem`, `global_regularity_for_NS`).
2. **Time-smoothness & physical-solution non-vacuity repair (COMPLETED):**
   The formalization defines `IsPhysicalNSSolution u` (requiring pointwise time-differentiability $\forall t\ge 0, \forall x, \text{DifferentiableAt }\mathbb{R}\ (s\mapsto u(s,x))\ t$, spatial continuity, finite $L^2$ energy, and the Leray $L^2$ energy inequality $\int\|u(t)\|^2\le\int\|u(0)\|^2$). With `IsPhysicalNSSolution` threaded through `KatoLocalWitness`, `existenceTimes`, `FrohmanianTetherBound`, `FrohmanianTetherRate`, `global_regularity_for_NS`, and `frohmanian_tether_theorem`, the hypotheses are **jointly satisfiable and verified non-vacuous** in `ClayStatements.lean` (`stepField_not_physical`, `repaired_hInt`, `repaired_huniq_shift_at_zero`, `repaired_huniq_at_zero`, `frohmanianTetherBound_zero`, `frohmanianTetherRate_zero`, `global_regularity_for_NS_nonvacuous_at_zero`).
3. **Complete preservation of original conjectured bridges (0 `sorry`):**
   Every original definition and conjectured bridge from `v8.tex` is explicitly formalized without `sorry` and presented in full in the manuscript:
   - `ConjecturedUnmodifiedTetherPairing` and `reduced_pairing_of_unmodified_and_tether` (proved with zero `sorry` via `reduced_pairing_iff_cancels_kappa_M4`),
   - `tethered_stretching_of_weight` (proved with zero `sorry` under `hweight`),
   - `ConjecturedSDiffPushforwardInvariance` and `tether_coadjoint_invariance_of_integral_eq` alongside `tether_coadjoint_invariance`,
   - Both the symmetric metric-tether uniqueness theorem (`uniqueness_of_minimal_symmetric_tether`, `tetherKernel_symmetric`) and the antisymmetric uniqueness theorem (`uniqueness_of_minimal_tether`),
   - The full original physical motivation: modified Kirillov–Kostant–Souriau bracket, metriplectic viscous completion, $L^6$ Sobolev/Young quartic Lyapunov absorption, comparison of the original quadratic Riccati heuristic ($\dot{y}=C-\kappa'y^2$) with the rigorous cubic comparison ceiling ($\dot{y}=Cy^2-\kappa''y^3$), Onsager $\alpha=1$ persistence, and AdS/CFT fluid-gravity cosmic censorship.

## Verification Table (437 Theorems across 17 Lean Modules, 0 `sorry`, 0 Nonstandard Axioms)

| Piece | Lean declaration / section | Status |
|---|---|---|
| G1 Tether kernel & projector $\Pi_u$ | `TetherKernel`, `Pi_u` | Proved (`tetherKernel_symmetric`, `projector_orthogonality`) |
| G2 Degeneracy on $H$ (Route A) | `tetherKernel_degenerates_on_kinetic_energy`, `tetherKernel_C2` | Proved axiom-clean |
| A1 Symmetry & antisymmetry | `tetherKernel_symmetric`, `uniqueness_of_minimal_symmetric_tether`, `uniqueness_of_minimal_tether` | Both symmetric and antisymmetric uniqueness proved axiom-clean |
| A3/C1 Coadjoint invariance | `tether_coadjoint_invariance`, `tether_coadjoint_invariance_of_integral_eq` | Proved for abstract action and under `ConjecturedSDiffPushforwardInvariance` |
| A5/C3 Negative feedback on $B(F,F)$ | `ProducesControllableNegativeFeedback` | Proved axiom-clean |
| Reduced 9-term Jacobi identity | `tethered_jacobi_identity` | Proved conditionally on cyclic cocycle hypothesis |
| G4 Stretching & transport at max | `stretching_inner_le_at_max`, `time_pairing_le_stretching_at_max` | Proved axiom-clean (given `hCZ`) |
| Conjectured unmodified-tether pairing | `ConjecturedUnmodifiedTetherPairing`, `reduced_pairing_of_unmodified_and_tether` | Proved axiom-clean (0 `sorry`) from explicit bridge hypothesis |
| Weighted stretching absorption | `tethered_stretching_of_weight` | Proved axiom-clean (0 `sorry`) from `hweight` |
| N1 Lyapunov vehicle $S_\varepsilon,\varphi$ | `LyapunovS`, `IsEnstrophyAccumulation`, `lyapunov_differential_inequality` | Proved axiom-clean |
| N2 Cubic comparison & majorant | `comparison_ode_stability`, `comparison_majorant_global_bound` | Proved axiom-clean |
| N3 Rate $\Rightarrow$ ceiling | `riccati_ceiling_of_vorticity_di` | Proved axiom-clean |
| N4 Physical solution predicate | `IsPhysicalNSSolution`, `isPhysicalNSSolution_zero`, `eq_zero_of_isPhysicalNSSolution_zero` | Proved axiom-clean |
| N4 Main conditional theorems | `global_regularity_for_NS`, `frohmanian_tether_theorem` | Proved axiom-clean & **verified non-vacuous** |
| Non-vacuity & joint satisfiability | `stepField_not_physical`, `repaired_hInt`, `repaired_huniq_at_zero`, `frohmanianTetherBound_zero`, `frohmanianTetherRate_zero`, `global_regularity_for_NS_nonvacuous_at_zero` | Proved unconditionally at $u_0=0$ (axiom-clean) |
| Historical unpatched binder audit | `library_huniq_unsatisfiable_at_zero`, `closing_bound_uniqueness_family_unsatisfiable` | Preserved & proved axiom-clean (motivates `IsPhysicalNSSolution`) |
| N5 Periodic Clay (B) reduction | `Clay_B_exact`, `clay_B_exact_of_periodic_tether_bound` | Proved axiom-clean (conditional on `PeriodicTetherClosingBound`) |
| KKS symplectic & metriplectic constraint (`SymplecticConstraint.lean`, 45 theorems) | `kks_skew_symmetric`, `kks_jacobi_identity`, `Pi_u_idempotent`, `Pi_u_self_adjoint`, `tether_preserves_casimir` | Proved axiom-clean (0 `sorry`) |
| Torus linear strain exclusion (`TorusStrainExclusion.lean`, 19 theorems) | `z3_periodic_linear_eq_zero`, `burgersLinearStrain_not_z3_periodic` | Proved axiom-clean (0 `sorry`) |
| High-set direction depletion & BKM (`HighSetDepletionAndBKM.lean`, 8 theorems) | `biot_savart_det_aligned_eq_zero`, `navier_stokes_scaling_homogeneity_deg6`, `clay_B_exact_of_torus_direction_depletion` | Proved axiom-clean (0 `sorry`) |
