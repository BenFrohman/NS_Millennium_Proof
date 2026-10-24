/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
-- NS_Millennium_Proof/Modules/Uniqueness.lean
public theorem uniqueness_of_minimal_tether
    (B' : VorticityField → FunctionalOnOrbit → FunctionalOnOrbit → ℝ)
    (_h_bilinear : ∀ ω F G, B' ω F G = - B' ω G F)
    (_h_C1 : InvariantUnderCoadjointAction B')
    (_h_C2 : DegenerateWRTKineticEnergy B')
    (_h_C3 : ProducesControllableNegativeFeedback B')
    (h_min : IsLowestOrderTerm B')
    (h_sat : SaturatesTetherQuadratic B') :
    B' = TetherKernel := ...

public theorem uniqueness_of_minimal_symmetric_tether
    (B' : VorticityField → FunctionalOnOrbit → FunctionalOnOrbit → ℝ)
    (_h_symm : ∀ ω F G, B' ω F G = B' ω G F)
    (_h_C1 : InvariantUnderCoadjointAction B')
    (_h_C2 : DegenerateWRTKineticEnergy B')
    (_h_C3 : ProducesControllableNegativeFeedback B')
    (h_min : IsLowestOrderTerm B')
    (h_sat : SaturatesTetherQuadratic B') :
    B' = TetherKernel := ...
