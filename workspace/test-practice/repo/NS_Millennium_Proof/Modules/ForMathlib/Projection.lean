/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import NS_Millennium_Proof.Modules.NS_Equations
import ForMathlib.NS.Tether

/-!
# The projection `Π_u` on `L²(𝕋³)`

`Π_u v = v - (⟨v, u⟩_{L²(𝕋³)} / ‖u‖²_{L²(𝕋³)}) u`, the generic `NS.FrohmanianTether.Pi_u`
for the measure `torusVolume`.

Proved:
* `projection_orthogonal_to_u`: `Π_u u = 0` when `‖u‖²_{L²(𝕋³)} ≠ 0`.
* `Pi_u_is_the_L2_orthogonal_projection_onto_complement_of_u`: `∫_{𝕋³} ⟨Π_u v, u⟩ = 0`.

Corrections to the earlier statements:
* `projection_orthogonal_to_u` was stated without `‖u‖²_{L²} ≠ 0`. That version is false:
  for `u` that is not square integrable on the cell the Bochner integral is `0`, the quotient is
  `0`, and `Π_u u = u`. The hypothesis `div u = 0` it carried plays no role and was dropped.
* `projector_orthogonality` claimed **pointwise** orthogonality `⟨Π_u v (x), u(x)⟩ = 0` for all
  `x`. That is false in general (`Π_u` is orthogonal in `L²`, not pointwise), so it was removed;
  the correct `L²` statement is the second theorem above.
-/

open MeasureTheory
open scoped RealInnerProductSpace

namespace ForMathlib

open NavierStokes3D

/-- `Π_u v` on `L²(𝕋³)`. -/
noncomputable def Pi_u (u v : VelocityField) : VelocityField :=
  NS.FrohmanianTether.Pi_u torusVolume u v

theorem projection_orthogonal_to_u (u : VelocityField)
    (h : ∫ y, ‖u y‖ ^ 2 ∂torusVolume ≠ 0) : Pi_u u u = fun _ => 0 :=
  NS.FrohmanianTether.Pi_u_self torusVolume u h

theorem Pi_u_is_the_L2_orthogonal_projection_onto_complement_of_u (u v : VelocityField)
    (hvu : Integrable (fun y => ⟪v y, u y⟫) torusVolume)
    (hu : Integrable (fun y => ‖u y‖ ^ 2) torusVolume)
    (h : ∫ y, ‖u y‖ ^ 2 ∂torusVolume ≠ 0) :
    ∫ x, ⟪Pi_u u v x, u x⟫ ∂torusVolume = 0 :=
  NS.FrohmanianTether.integral_inner_Pi_u torusVolume u v hvu hu h

end ForMathlib
