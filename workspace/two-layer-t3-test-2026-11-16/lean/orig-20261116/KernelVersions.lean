/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import TwoLayerT3.Tether

/-!
# Both published kernel formulas

* Version A (Zenodo 21856430, pointwise weight): `−κ ∫ |ω|² ⟨Π_u δF, Π_u δG⟩`, i.e. `W` =
  multiplication by `|ω|²`. This is covered by every theorem in `Tether.lean`, which holds for
  every continuous linear `W`.
* Version B (Lean `TetherKernel`, Zenodo 24120781): `−κ ‖ω‖²_{L²} ∫ ⟨Π_u δF, Π_u δG⟩`, i.e.
  `W = ‖ω‖² • id`. Specialised below.
-/

open scoped InnerProductSpace

namespace TwoLayerT3

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]

/-- Version B kernel with enstrophy factor `w = ‖ω‖²_{L²}`. -/
noncomputable def kernelB (κ w : ℝ) (u f g : E) : ℝ :=
  tetherForm κ (w • ContinuousLinearMap.id ℝ E) u f g

theorem kernelB_eq (κ w : ℝ) (u f g : E) :
    kernelB κ w u f g = -κ * w * ⟪projPerp u f, projPerp u g⟫_ℝ := by
  simp [kernelB, tetherForm, inner_smul_right]; ring

/-- Version B is degenerate on H (δH = u): it adds nothing to any rate along the H-flow. -/
theorem kernelB_degenerate (κ w : ℝ) (u f : E) : kernelB κ w u f u = 0 :=
  tether_degenerate κ _ u f

/-- Version B is negative semidefinite on the diagonal for κ, w ≥ 0 (sign obstruction:
it cannot be a positive-semidefinite metriplectic metric bracket unless it vanishes there). -/
theorem kernelB_diag_nonpos (κ w : ℝ) (hκ : 0 ≤ κ) (hw : 0 ≤ w) (u v : E) :
    kernelB κ w u v v ≤ 0 := by
  rw [kernelB_eq, real_inner_self_eq_norm_sq]
  have : 0 ≤ κ * w * ‖projPerp u v‖ ^ 2 := by positivity
  linarith

/-- For κ, w > 0 Version B is strictly negative at any `v` with `Π_u v ≠ 0`. -/
theorem kernelB_diag_neg (κ w : ℝ) (hκ : 0 < κ) (hw : 0 < w) (u v : E)
    (hv : projPerp u v ≠ 0) : kernelB κ w u v v < 0 := by
  rw [kernelB_eq, real_inner_self_eq_norm_sq]
  have : 0 < κ * w * ‖projPerp u v‖ ^ 2 := by
    have := norm_pos_iff.mpr hv; positivity
  linarith

end TwoLayerT3
