/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
-- NS_Millennium_Proof/Modules/SymplecticTether.lean (sorry-free)
public def ConjecturedUnmodifiedTetherPairing
    (u : VelocityField) (ω : VorticityField) (x : EuclideanSpace ℝ (Fin 3)) : Prop :=
  pairing (ω x) (convective ω u x) ≤
    CalderonZygmundConstant3D * vorticity_sup_norm ω ^ 3 -
      kappa * vorticity_sup_norm ω ^ 4

public theorem reduced_pairing_of_unmodified_and_tether
    (u : VelocityField) (ω : VorticityField)
    (x : EuclideanSpace ℝ (Fin 3))
    (h_max : ‖ω x‖ = vorticity_sup_norm ω)
    (hCZ : ‖fderiv ℝ u x‖ ≤ CalderonZygmundConstant3D * vorticity_sup_norm ω)
    (hcancels : ConjecturedUnmodifiedTetherPairing u ω x) :
    pairing (ω x) (convective ω u x) ≤
      CalderonZygmundConstant3D * (vorticity_sup_norm ω) ^ 3 -
        kappa * (vorticity_sup_norm ω) ^ 4 :=
  (reduced_pairing_iff_cancels_kappa_M4 u ω x h_max hCZ).mpr hcancels
