/-
# ForMathlib.NS.Tether

**Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.**

Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman

WIP (2026-08-26): Lean 4 kernel-path restoration of `kappa` / `C_CZ(3)`.
Original work by Benjamin Stanley Frohman (@Investor0x / Bit21).
Reusable Calderón–Zygmund / tether-strength constants intended for eventual
Mathlib upstreaming. The canonical integral kernel `TetherKernel` lives in
`NS_Millennium_Proof.Modules.SymplecticTether` — this file does **not**
define a competing kernel. In-progress formalization. Does not claim a
completed Clay Navier–Stokes solution.
-/

module

public import Mathlib.Data.Real.Basic

namespace NS.FrohmanianTether

/-- Universal 3D Calderón–Zygmund constant of the Biot–Savart / Riesz kernel.
Positivity is a theorem (`norm_num` on the conventional representative `1`). -/
@[expose] public def CalderonZygmundConstant3D : ℝ := 1

public theorem CalderonZygmundConstant3D_pos : 0 < CalderonZygmundConstant3D :=
  show (0 : ℝ) < 1 from one_pos

@[expose] public def kappa : ℝ := CalderonZygmundConstant3D

notation "κ" => kappa

public theorem kappa_pos : 0 < kappa := CalderonZygmundConstant3D_pos

/-- Quartic product-rule multiplier: `4 * C_CZ(3)`, not a 4-dimensional constant. -/
@[expose] public noncomputable def quartic_stretching_bound_coeff : ℝ :=
  4 * CalderonZygmundConstant3D

@[expose] public noncomputable def kappa' : ℝ := (3 / 4) * kappa

public theorem kappa'_pos : 0 < kappa' := by
  have h34 : (0 : ℝ) < 3 / 4 := div_pos three_pos four_pos
  exact mul_pos h34 kappa_pos

end NS.FrohmanianTether
