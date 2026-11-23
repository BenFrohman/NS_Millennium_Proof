/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import MetriplecticTetherModel.Tether
import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Analysis.Calculus.Deriv.Add

/-!
# MetriplecticTetherModel.Energy

The `L²(𝕋³)` gradient of the kinetic energy `H(u) = ½‖u‖²` is `u`: for continuous `u`, `v`,
`d/dε H(u + ε v) |_{ε=0} = ⟨u, v⟩` (`energy_hasDerivAt`). This justifies taking `δH/δu = u` as the
energy slot of the tether in `tetheredRHS`.
-/

open MeasureTheory

namespace MetriplecticTetherModel

theorem dot_add_smul_self (u v : R3) (ε : ℝ) :
    dot (u + ε • v) (u + ε • v) = dot u u + 2 * ε * dot u v + ε ^ 2 * dot v v := by
  simp only [dot, Fin.sum_univ_three, Pi.add_apply, Pi.smul_apply, smul_eq_mul]
  ring

/-- Expansion `‖u + εv‖² = ‖u‖² + 2ε⟨u,v⟩ + ε²‖v‖²` in `L²(𝕋³)`. -/
theorem l2_add_smul_self {u v : R3 → R3} (hu : Continuous u) (hv : Continuous v) (ε : ℝ) :
    l2 (fun x => u x + ε • v x) (fun x => u x + ε • v x) =
      l2 u u + 2 * ε * l2 u v + ε ^ 2 * l2 v v := by
  have h1 := integrable_of_continuous (continuous_dot hu hu)
  have h2 := integrable_of_continuous (continuous_dot hu hv)
  have h3 := integrable_of_continuous (continuous_dot hv hv)
  unfold l2
  simp_rw [dot_add_smul_self]
  rw [integral_add, integral_add, integral_const_mul, integral_const_mul] <;>
    first
      | exact h1
      | exact h2.const_mul _
      | exact h3.const_mul _
      | exact h1.add (h2.const_mul _)

/-- The `L²` gradient of `H(u) = ½‖u‖²` is `u`. -/
theorem energy_hasDerivAt {u v : R3 → R3} (hu : Continuous u) (hv : Continuous v) :
    HasDerivAt (fun ε : ℝ => energy (fun x => u x + ε • v x)) (l2 u v) 0 := by
  have heq : (fun ε : ℝ => energy (fun x => u x + ε • v x)) =
      fun ε => (1 / 2) * (l2 u u + 2 * ε * l2 u v + ε ^ 2 * l2 v v) := by
    funext ε
    simp only [energy, l2_add_smul_self hu hv ε]
  rw [heq]
  have hlin : HasDerivAt (fun ε : ℝ => 2 * ε * l2 u v) (2 * 1 * l2 u v) 0 :=
    HasDerivAt.mul_const (HasDerivAt.const_mul 2 (hasDerivAt_id (0 : ℝ))) _
  have hsq : HasDerivAt (fun ε : ℝ => ε ^ 2 * l2 v v) ((2 : ℕ) * (0 : ℝ) ^ (2 - 1) * l2 v v) 0 :=
    HasDerivAt.mul_const (hasDerivAt_pow 2 (0 : ℝ)) _
  have h := HasDerivAt.const_mul (1 / 2 : ℝ)
    (HasDerivAt.add (HasDerivAt.add (hasDerivAt_const (0 : ℝ) (l2 u u)) hlin) hsq)
  convert h using 1
  simp

end MetriplecticTetherModel
