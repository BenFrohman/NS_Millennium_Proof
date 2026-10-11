/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

module

public import NS_Millennium_Proof.Modules.NS_Equations
public import NS_Millennium_Proof.Modules.SymplecticTether

/-!
# Classical pairing derivation

Nothing on the lake-checked path imports this module. It does not import
`GlobalRegularity` or `TetheredLyapunov`.

`reduced_pairing_from_unmodified` is the open estimate. The body is `sorry`.
It is not a derivation of `M' ≤ C M² - κ'' M³`, and it is not used by
`frohmanian_tether_theorem` or `global_regularity_for_NS`.
-/

namespace Frohmanian.ClassicalDerivation

open NavierStokes3D FrohmanianTether

/-- At a spatial maximum, the unmodified vorticity equation and `(C3)` are
supposed to give
`⟨ω, (ω·∇)u⟩ ≤ (C M - κ M²) M²`.
No proof from those hypotheses is written here. -/
theorem reduced_pairing_from_unmodified
    (u : TimeDependentVelocity) (p : TimeDependentPressure) (ν : ℝ)
    (t : ℝ) (ht : 0 ≤ t) (x : T3)
    (hNS : NS_PDE u p ν)
    (hreg : VorticityTransportRegularity u p t x)
    (hu : DifferentiableAt ℝ (u t) x)
    (C M : ℝ)
    (hCZ : ‖fderiv ℝ (u t) x‖ ≤ C * vorticity_sup_norm (vorticity (u t)))
    (htransp : inner ℝ (vorticity (u t) x)
      (convective (u t) (vorticity (u t)) x) = 0)
    (hvisc : inner ℝ (vorticity (u t) x)
      (laplacian (vorticity (u t)) x) ≤ 0)
    (hν : 0 ≤ ν)
    (hmax : ‖vorticity (u t) x‖ = M ∧
      M = vorticity_sup_norm (vorticity (u t)))
    (htether : ProducesControllableNegativeFeedback TetherKernel)
    (hκ : kappa = CalderonZygmundConstant3D) :
    inner ℝ (vorticity (u t) x)
        (convective (vorticity (u t)) (u t) x) ≤
      (C * M - kappa * M ^ 2) * M ^ 2 := by
  sorry

end Frohmanian.ClassicalDerivation
