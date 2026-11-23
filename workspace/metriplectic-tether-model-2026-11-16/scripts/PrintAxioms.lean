/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import MetriplecticTetherModel

/-!
# PrintAxioms

`#print axioms` for every theorem of `MetriplecticTetherModel`, plus the semantics-lock checks.
-/

open MetriplecticTetherModel

#check @intended_correspondence
#print paper_claim
#print formal_claim
#print axioms MetriplecticTetherModel.FlowField.continuous
#print axioms MetriplecticTetherModel.tether_term_vanishes
#print axioms MetriplecticTetherModel.tetheredRHS_eq_nsRHS
#print axioms MetriplecticTetherModel.tetheredRHS_fun_eq
#print axioms MetriplecticTetherModel.isSolution_tethered_iff
#print axioms MetriplecticTetherModel.globalRegularity_tethered_iff
#print axioms MetriplecticTetherModel.solution_property_transfer
#print axioms MetriplecticTetherModel.dot_add_smul_self
#print axioms MetriplecticTetherModel.l2_add_smul_self
#print axioms MetriplecticTetherModel.energy_hasDerivAt
#print axioms MetriplecticTetherModel.pd_comp_coord0
#print axioms MetriplecticTetherModel.hasDerivAt_beltramiProfile
#print axioms MetriplecticTetherModel.beltramiProfile_add_one
#print axioms MetriplecticTetherModel.contDiff_beltramiProfile
#print axioms MetriplecticTetherModel.pd_beltrami
#print axioms MetriplecticTetherModel.curl_beltrami
#print axioms MetriplecticTetherModel.dot_curl_beltrami
#print axioms MetriplecticTetherModel.l2_e0_beltrami
#print axioms MetriplecticTetherModel.proj_beltrami_e0
#print axioms MetriplecticTetherModel.mu_univ
#print axioms MetriplecticTetherModel.tether_beltrami
#print axioms MetriplecticTetherModel.tether_diag_neg_somewhere
#print axioms MetriplecticTetherModel.tether_not_psd
#print axioms MetriplecticTetherModel.paper_rhs_eq
#print axioms MetriplecticTetherModel.beltrami_u_eq
#print axioms MetriplecticTetherModel.e0_v_eq
#print axioms MetriplecticTetherModel.intended_correspondence
#print axioms MetriplecticTetherModel.formal_claim_holds
#print axioms MetriplecticTetherModel.main_theorem
#print axioms MetriplecticTetherModel.dot_comm
#print axioms MetriplecticTetherModel.dot_self_nonneg
#print axioms MetriplecticTetherModel.dot_self_eq_zero
#print axioms MetriplecticTetherModel.dot_zero_right
#print axioms MetriplecticTetherModel.dot_sub_smul_left
#print axioms MetriplecticTetherModel.continuous_dot
#print axioms MetriplecticTetherModel.isCompact_cell
#print axioms MetriplecticTetherModel.integrable_of_continuous
#print axioms MetriplecticTetherModel.l2_comm
#print axioms MetriplecticTetherModel.l2_self_nonneg
#print axioms MetriplecticTetherModel.ae_eq_zero_of_l2_self_eq_zero
#print axioms MetriplecticTetherModel.proj_self
#print axioms MetriplecticTetherModel.l2_proj_orth
#print axioms MetriplecticTetherModel.tether_symm
#print axioms MetriplecticTetherModel.tether_diag_nonpos
#print axioms MetriplecticTetherModel.tether_energy_slot_right
#print axioms MetriplecticTetherModel.tether_energy_slot_left
#print axioms MetriplecticTetherModel.l2_zero_right
#print axioms MetriplecticTetherModel.tetherFactorized_energy_slot_right
#print axioms MetriplecticTetherModel.tetherFactorized_diag_nonpos
