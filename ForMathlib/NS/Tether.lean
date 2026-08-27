/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

module

public import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
public import Mathlib.Tactic.FieldSimp
public import Mathlib.Tactic.Ring

/-!
# ForMathlib.NS.Tether

Original work by Benjamin Stanley Frohman (@Investor0x / Bit21).

Reusable Calderón–Zygmund / tether-strength constants intended for eventual
Mathlib upstreaming. The canonical integral kernel `TetherKernel` lives in
`NS_Millennium_Proof.Modules.SymplecticTether` — this file does **not**
define a competing kernel.

`C_CZ(3)` is the spherical L¹ of the 3D Biot–Savart strain kernel, equal to
`3/2`, not the nondimensional stand-in `1`. Positivity of `kappa` is a
theorem, not an axiom.
-/

namespace NS.FrohmanianTether

/-- Prefactor of the Constantin–Fefferman / Majda–Bertozzi 3D strain kernel
`(K z ω)_{ij} = (3/(8 π)) [(z × ω)_i z_j + (z × ω)_j z_i] / |z|^5`. -/
@[expose] public noncomputable def biotSavartStrainKernelPrefactor : ℝ :=
  3 / (8 * Real.pi)

/-- Euclidean surface area of the unit sphere `S² ⊂ ℝ³`. -/
@[expose] public noncomputable def sphereAreaS2 : ℝ :=
  4 * Real.pi

/-- Universal 3D Calderón–Zygmund constant of the Biot–Savart strain kernel:
`(3/(8 π)) · area(S²) = 3/2`. This is not the stand-in `1`. -/
@[expose] public noncomputable def CalderonZygmundConstant3D : ℝ :=
  biotSavartStrainKernelPrefactor * sphereAreaS2

public theorem CalderonZygmundConstant3D_eq_three_halves :
    CalderonZygmundConstant3D = 3 / 2 := by
  unfold CalderonZygmundConstant3D biotSavartStrainKernelPrefactor sphereAreaS2
  field_simp [Real.pi_ne_zero]
  ring

public theorem CalderonZygmundConstant3D_ne_one :
    CalderonZygmundConstant3D ≠ 1 := by
  rw [CalderonZygmundConstant3D_eq_three_halves]
  norm_num

public theorem CalderonZygmundConstant3D_pos : 0 < CalderonZygmundConstant3D := by
  rw [CalderonZygmundConstant3D_eq_three_halves]
  exact div_pos three_pos two_pos

@[expose] public noncomputable def kappa : ℝ := CalderonZygmundConstant3D

scoped notation "κ" => kappa

public theorem kappa_eq_three_halves : kappa = 3 / 2 :=
  CalderonZygmundConstant3D_eq_three_halves

public theorem kappa_ne_one : kappa ≠ 1 :=
  CalderonZygmundConstant3D_ne_one

public theorem kappa_pos : 0 < kappa := CalderonZygmundConstant3D_pos

/-- Quartic product-rule multiplier: `4 * C_CZ(3) = 6`, not a 4-dimensional constant. -/
@[expose] public noncomputable def quartic_stretching_bound_coeff : ℝ :=
  4 * CalderonZygmundConstant3D

@[expose] public noncomputable def kappa' : ℝ := (3 / 4) * kappa

public theorem kappa'_pos : 0 < kappa' := by
  have h34 : (0 : ℝ) < 3 / 4 := div_pos three_pos four_pos
  exact mul_pos h34 kappa_pos

/-- Gagliardo–Nirenberg / Sobolev representative. Positivity is a theorem. -/
@[expose] public def SobolevConstant3D : ℝ := 1

public theorem SobolevConstant3D_pos : 0 < SobolevConstant3D := by
  change (0 : ℝ) < 1
  exact one_pos

end NS.FrohmanianTether
