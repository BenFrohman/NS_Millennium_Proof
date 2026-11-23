/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import TFFrohmanianTether.Basic

/-!
# The October kernel `K_FT(u,u)` is the Beltrami (velocity–vorticity) alignment defect

Pointwise, for the vorticity `ω` and the velocity `u` at one point of space,

  `K_FT ω u u = |ω|² |P_ω^⊥ u|² = |ω × u|²`

(Lagrange's identity), and this density vanishes exactly when `ω = 0` or
`u` is a real multiple of `ω`, i.e. exactly when `u ∥ ω` (Beltrami alignment).

These are pointwise statements on `Fin 3 → ℝ`. They do not integrate over
`ℝ³` or `T³`, and they say nothing about regularity of Navier–Stokes
solutions.
-/

namespace TFFrohmanianTether

/-- Lagrange's identity for the October kernel:
`K_FT(ω; u, u) = |ω|² |P_ω^⊥ u|² = |ω × u|²`. -/
theorem K_FT_uu_eq_cross_sq (ω u : Fin 3 → ℝ) :
    K_FT ω u u = dot (cross ω u) (cross ω u) := by
  unfold K_FT P_δC_perp Pi_u
  split_ifs with h0
  · have hω := eq_zero_of_dot_self_eq_zero h0
    subst hω
    simp [dot, cross]
  · generalize hc : dot u ω / dot ω ω = c
    have hcD : c * dot ω ω = dot u ω := by
      rw [← hc, div_mul_eq_mul_div, mul_div_assoc, div_self h0, mul_one]
    have c0 : cross ω u 0 = ω 1 * u 2 - ω 2 * u 1 := rfl
    have c1 : cross ω u 1 = ω 2 * u 0 - ω 0 * u 2 := rfl
    have c2 : cross ω u 2 = ω 0 * u 1 - ω 1 * u 0 := rfl
    simp only [dot] at hcD ⊢
    rw [c0, c1, c2]
    linear_combination
      (c * (ω 0 * ω 0 + ω 1 * ω 1 + ω 2 * ω 2) - (u 0 * ω 0 + u 1 * ω 1 + u 2 * ω 2)) * hcD

/-- `|ω × u|² = 0` exactly when `ω = 0` or `u = c ω` for some real `c`. -/
theorem K_FT_uu_eq_zero_iff (ω u : Fin 3 → ℝ) :
    K_FT ω u u = 0 ↔ (ω = fun _ => 0) ∨ ∃ c : ℝ, u = fun i => c * ω i := by
  constructor
  · intro h
    by_cases h0 : dot ω ω = 0
    · exact Or.inl (eq_zero_of_dot_self_eq_zero h0)
    · right
      have hP : dot (P_δC_perp ω u) (P_δC_perp ω u) = 0 := by
        have h' : dot ω ω * dot (P_δC_perp ω u) (P_δC_perp ω u) = 0 := h
        rcases mul_eq_zero.mp h' with h1 | h1
        · exact absurd h1 h0
        · exact h1
      have hz := eq_zero_of_dot_self_eq_zero hP
      refine ⟨dot u ω / dot ω ω, ?_⟩
      funext i
      have hi := congrFun hz i
      rw [P_δC_perp, Pi_u, if_neg h0] at hi
      show u i = dot u ω / dot ω ω * ω i
      linarith
  · rintro (hω | ⟨c, hc⟩)
    · subst hω
      simp [K_FT, dot]
    · exact K_FT_uu_eq_zero_of_collinear ω u c hc

/-- The October kernel density is never negative. -/
theorem K_FT_uu_nonneg (ω u : Fin 3 → ℝ) : 0 ≤ K_FT ω u u := by
  rw [K_FT_uu_eq_cross_sq]
  unfold dot
  exact add_nonneg (add_nonneg (mul_self_nonneg _) (mul_self_nonneg _)) (mul_self_nonneg _)

end TFFrohmanianTether
