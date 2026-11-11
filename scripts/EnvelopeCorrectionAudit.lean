/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Frohman, Benjamin Stanley
-/
import NS_Millennium_Proof.Modules.MainTheorem
import NS_Millennium_Proof.Modules.Stage6Calculus
import NS_Millennium_Proof.Modules.ShearSolution

open NavierStokes3D FrohmanianTether.ClayStatements
open FrohmanianTether.HighSetDepletionAndBKM

-- Definitional compatibility, not a claimed differential/envelope equivalence.
example (ν : ℝ) : UniformVorticityEnvelopeBound ν = PeriodicDirectionDepletionBound ν := rfl
example (ν : ℝ) : DirectionCurvatureBound ν = PeriodicDirectionDepletionBound ν := rfl
example (hBKM : ∀ ν > (0 : ℝ), PeriodicBKMContinuation ν) :
    (∀ ν > (0 : ℝ), DirectionCurvatureBound ν) → Clay_B_exact :=
  clay_reduces_to_direction_curvature_bound hBKM

#print axioms vorticity_envelope_of_cubic_differential_bound
#print axioms pointwise_vorticity_envelope_of_cubic_differential_bound
#print axioms periodic_solution_envelope_of_compact_cubic_bounds
#print axioms cubicVorticityDifferentialBound_zero
#print axioms clay_reduces_to_uniform_vorticity_envelope
#print axioms NS_Millennium_Proof.Stage6.exponential_profile_hasDerivAt
#print axioms NS_Millennium_Proof.Stage6.exponential_profile_satisfies_cubic_bound
#print axioms NS_Millennium_Proof.Stage6.fixed_cubic_constants_fail_for_some_amplitude

-- Actual shear solution (addendum): assembled into IsPeriodicSmoothSolutionOn.
#print axioms NS_Millennium_Proof.ShearSolution.K_pos
#print axioms NS_Millennium_Proof.ShearSolution.e0_apply
#print axioms NS_Millennium_Proof.ShearSolution.single_apply_two
#print axioms NS_Millennium_Proof.ShearSolution.hasFDerivAt_F
#print axioms NS_Millennium_Proof.ShearSolution.fderiv_F_apply
#print axioms NS_Millennium_Proof.ShearSolution.hasFDerivAt_F_coord
#print axioms NS_Millennium_Proof.ShearSolution.fderiv_F_coord_apply
#print axioms NS_Millennium_Proof.ShearSolution.convective_F
#print axioms NS_Millennium_Proof.ShearSolution.div_F
#print axioms NS_Millennium_Proof.ShearSolution.laplacian_F
#print axioms NS_Millennium_Proof.ShearSolution.curl_F
#print axioms NS_Millennium_Proof.ShearSolution.sin_profile_deriv
#print axioms NS_Millennium_Proof.ShearSolution.cos_profile_deriv
#print axioms NS_Millennium_Proof.ShearSolution.shearU_eq
#print axioms NS_Millennium_Proof.ShearSolution.shearU_zero
#print axioms NS_Millennium_Proof.ShearSolution.shear_time_deriv
#print axioms NS_Millennium_Proof.ShearSolution.gradient_zero
#print axioms NS_Millennium_Proof.ShearSolution.latticeVec_two
#print axioms NS_Millennium_Proof.ShearSolution.shear_periodic
#print axioms NS_Millennium_Proof.ShearSolution.shear_contDiff
#print axioms NS_Millennium_Proof.ShearSolution.shear_isPeriodicSmoothSolutionOn
#print axioms NS_Millennium_Proof.ShearSolution.shear_vorticity
#print axioms NS_Millennium_Proof.ShearSolution.shear_vorticity_norm
#print axioms NS_Millennium_Proof.ShearSolution.shear_vorticity_bdd
#print axioms NS_Millennium_Proof.ShearSolution.shear_vorticity_sup_norm
#print axioms NS_Millennium_Proof.ShearSolution.shear_M_eq
#print axioms NS_Millennium_Proof.ShearSolution.shear_cubic_bound_data_dependent
#print axioms NS_Millennium_Proof.ShearSolution.shear_fixed_cubic_constants_fail
#print axioms NS_Millennium_Proof.ShearSolution.shear_envelope_nonvacuous
