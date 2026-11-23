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

/-- Version B kernel with the enstrophy factor `‖ω‖²_{L²}` (the real argument `enstrophy`). -/
noncomputable def kernelB (κ enstrophy : ℝ) (u f g : E) : ℝ :=
  tetherForm κ (enstrophy • ContinuousLinearMap.id ℝ E) u f g

theorem kernelB_eq (κ enstrophy : ℝ) (u f g : E) :
    kernelB κ enstrophy u f g = -κ * enstrophy * ⟪projPerp u f, projPerp u g⟫_ℝ := by
  simp [kernelB, tetherForm, inner_smul_right]; ring

/-- Version B is degenerate on H (δH = u): it adds nothing to any rate along the H-flow. -/
theorem kernelB_degenerate (κ enstrophy : ℝ) (u f : E) : kernelB κ enstrophy u f u = 0 :=
  tether_degenerate κ _ u f

/-- Version B is negative semidefinite on the diagonal for κ, enstrophy ≥ 0 (sign obstruction:
it cannot be a positive-semidefinite metriplectic metric bracket unless it vanishes there). -/
theorem kernelB_diag_nonpos (κ enstrophy : ℝ) (hκ : 0 ≤ κ) (henstrophy : 0 ≤ enstrophy) (u v : E) :
    kernelB κ enstrophy u v v ≤ 0 := by
  rw [kernelB_eq, real_inner_self_eq_norm_sq]
  have : 0 ≤ κ * enstrophy * ‖projPerp u v‖ ^ 2 := by positivity
  linarith

/-- For κ, enstrophy > 0 Version B is strictly negative at any `v` with `Π_u v ≠ 0`. -/
theorem kernelB_diag_neg (κ enstrophy : ℝ) (hκ : 0 < κ) (henstrophy : 0 < enstrophy) (u v : E)
    (hv : projPerp u v ≠ 0) : kernelB κ enstrophy u v v < 0 := by
  rw [kernelB_eq, real_inner_self_eq_norm_sq]
  have : 0 < κ * enstrophy * ‖projPerp u v‖ ^ 2 := by
    have := norm_pos_iff.mpr hv; positivity
  linarith

end TwoLayerT3
