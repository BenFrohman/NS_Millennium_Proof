/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Frohman, Benjamin Stanley
-/
import NS_Millennium_Proof.Modules.MainTheorem
import NS_Millennium_Proof.Modules.Stage6Calculus

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
