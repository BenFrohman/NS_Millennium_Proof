/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

module

public import NS_Millennium_Proof.Modules.NS_Equations

/-!
# Cubic damping from the tether kernel

`cubic_damping_of_tether_kernel` states the damped rate and does not prove it.
`ns_global_regularity_of_cubic_damped_rate` does not import this file.

`satisfies_unmodified_vorticity_equation`, `evolves_under_tethered_bracket`,
and `KatoInterval` are not definitions. `TetheredBracket` is a scalar on two
test functionals, not a time evolution. The hypothesis used here is `NS_PDE`.
-/

namespace Frohmanian.CubicDamping

open NavierStokes3D

/-- Claimed cubic damping. Not a derivation.

The unmodified Navier–Stokes equation is `NS_PDE`. The claimed conclusion is
`M' ≤ C M² - κ'' M³` for `M = ‖ω‖_∞`. The body is `sorry`. No integral of
`TetherKernel` against a derivative of the supremum norm is computed here.

Author: Benjamin Stanley Frohman
-/
public lemma cubic_damping_of_tether_kernel
    (u : ℝ → VelocityField) (p : ℝ → PressureField) (ν : ℝ)
    (hNS : NS_PDE u p ν)
    (M : ℝ → ℝ)
    (hM : ∀ t, M t = vorticity_sup_norm (vorticity (u t)))
    (C κ'' : ℝ) (hC : 0 < C) (hκ : 0 < κ'') :
    ∀ t ≥ (0 : ℝ),
      deriv M t ≤ C * (M t) ^ 2 - κ'' * (M t) ^ 3 := by
  sorry

end Frohmanian.CubicDamping
