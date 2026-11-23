/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import TwoLayerT3.Semantics
import TwoLayerT3.ExplicitFields
import TwoLayerT3.LayerTwo
import TwoLayerT3.KernelVersions

/-! Axiom audit: printed during `lake build`. -/

#check @TwoLayerT3.intended_correspondence
#print TwoLayerT3.paper_claim
#print TwoLayerT3.formal_claim
#print axioms TwoLayerT3.intended_correspondence
#print axioms TwoLayerT3.paper_claim_refuted
#print axioms TwoLayerT3.projPerp_self
#print axioms TwoLayerT3.inner_projPerp_u
#print axioms TwoLayerT3.projPerp_idem
#print axioms TwoLayerT3.tether_degenerate
#print axioms TwoLayerT3.metriplectic_rate_tether_drops
#print axioms TwoLayerT3.tether_no_feedback
#print axioms TwoLayerT3.tether_degenerate_iff
#print axioms TwoLayerT3.projPerp_eq_zero_imp
#print axioms TwoLayerT3.tether_not_antisymm
#print axioms TwoLayerT3.tether_degenerate_L2
#print axioms TwoLayerT3.Explicit.div_free
#print axioms TwoLayerT3.Explicit.lap_u1
#print axioms TwoLayerT3.Explicit.lap_u2
#print axioms TwoLayerT3.Explicit.lap_u3
#print axioms TwoLayerT3.Explicit.viscous_difference_value
#print axioms TwoLayerT3.Explicit.viscous_difference_ne_zero
#print axioms TwoLayerT3.Explicit.curl_a
#print axioms TwoLayerT3.Explicit.a_not_multiple_of_u
#print axioms TwoLayerT3.LayerTwo.phi_term_deriv
#print axioms TwoLayerT3.LayerTwo.phi_term_source
#print axioms TwoLayerT3.LayerTwo.cubic_rate_amplitude
#print axioms TwoLayerT3.LayerTwo.enstrophy_rate_amplitude
#print axioms TwoLayerT3.kernelB_eq
#print axioms TwoLayerT3.kernelB_degenerate
#print axioms TwoLayerT3.kernelB_diag_nonpos
#print axioms TwoLayerT3.kernelB_diag_neg
