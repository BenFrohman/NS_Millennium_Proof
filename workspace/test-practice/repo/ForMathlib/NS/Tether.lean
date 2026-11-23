/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.MeasureTheory.Integral.Bochner.Basic

/-!
# ForMathlib.NS.Tether: generic algebra behind the Frohmanian tether

This file contains the measure-theoretic and linear-algebraic facts used by the
tether construction, stated for an arbitrary measure `μ` and proved in full.

* `NS.FrohmanianTether.cross a b` is the cross product `a × b` on `ℝ³ = EuclideanSpace ℝ (Fin 3)`.
* `NS.FrohmanianTether.Pi_u μ u v` is `Π_u v = v - (⟨v, u⟩_{L²(μ)} / ‖u‖²_{L²(μ)}) u`, the
  `L²(μ)`-projection of `v` onto the orthogonal complement of the line spanned by `u`.
* `NS.FrohmanianTether.TetherTwoForm μ κ ω a b` is
  `Ω_κ(ω; a, b) = ∫ ⟨ω, a × b⟩ dμ - κ ∫ ‖ω‖² ⟨a, b⟩ dμ`.

## What is proved here

* `Pi_u_self`: `Π_u u = 0` whenever `‖u‖²_{L²(μ)} ≠ 0`.
* `integral_inner_Pi_u`: `∫ ⟨Π_u v, u⟩ dμ = 0` (orthogonality in `L²(μ)`, not pointwise).
* `tetherTwoForm_add_swap`: `Ω_κ(a, b) + Ω_κ(b, a) = -2κ ∫ ‖ω‖² ⟨a, b⟩ dμ`.
  In particular `Ω_κ` is **not** antisymmetric when `κ ∫ ‖ω‖² ⟨a, b⟩ dμ ≠ 0`, so for `κ ≠ 0`
  it is not a symplectic (skew) two-form in general.
* `tetherTwoForm_self`: `Ω_κ(a, a) = -κ ∫ ‖ω‖² ‖a‖² dμ`.

The earlier version of this file did not parse and was never compiled by `lake build`
(the `ForMathlib` library was not a build target). It also contained `sorry` and the custom
axiom `κ_pos`. Here `κ` is an explicit parameter; positivity `0 < κ` is a hypothesis wherever
it is used.
-/

open MeasureTheory
open scoped RealInnerProductSpace

namespace NS.FrohmanianTether

/-- `ℝ³` as a Euclidean space. -/
abbrev R3 : Type := EuclideanSpace ℝ (Fin 3)

/-- The cross product `a × b` on `ℝ³`, written in the standard basis. -/
noncomputable def cross (a b : R3) : R3 :=
  (a 1 * b 2 - a 2 * b 1) • EuclideanSpace.single 0 1 +
  (a 2 * b 0 - a 0 * b 2) • EuclideanSpace.single 1 1 +
  (a 0 * b 1 - a 1 * b 0) • EuclideanSpace.single 2 1

@[simp] theorem cross_self (a : R3) : cross a a = 0 := by
  simp [cross, mul_comm]

theorem cross_anticomm (a b : R3) : cross b a = -cross a b := by
  simp only [cross]
  rw [neg_add, neg_add, ← neg_smul, ← neg_smul, ← neg_smul]
  congr 2 <;> congr 1 <;> ring

variable {X E : Type*} [MeasurableSpace X] [NormedAddCommGroup E] [InnerProductSpace ℝ E]

/-- `Π_u v = v - (⟨v, u⟩_{L²(μ)} / ‖u‖²_{L²(μ)}) u`. -/
noncomputable def Pi_u (μ : Measure X) (u v : X → E) : X → E :=
  fun x => v x - ((∫ y, ⟪v y, u y⟫ ∂μ) / (∫ y, ‖u y‖ ^ 2 ∂μ)) • u x

theorem Pi_u_self (μ : Measure X) (u : X → E) (h : ∫ y, ‖u y‖ ^ 2 ∂μ ≠ 0) :
    Pi_u μ u u = 0 := by
  funext x
  have : (∫ y, ⟪u y, u y⟫ ∂μ) = ∫ y, ‖u y‖ ^ 2 ∂μ := by
    congr 1; funext y; exact real_inner_self_eq_norm_sq (u y)
  simp [Pi_u, this, div_self h]

/-- `L²(μ)` orthogonality of `Π_u v` to `u`. -/
theorem integral_inner_Pi_u (μ : Measure X) (u v : X → E)
    (hvu : Integrable (fun y => ⟪v y, u y⟫) μ) (hu : Integrable (fun y => ‖u y‖ ^ 2) μ)
    (h : ∫ y, ‖u y‖ ^ 2 ∂μ ≠ 0) :
    ∫ x, ⟪Pi_u μ u v x, u x⟫ ∂μ = 0 := by
  set c := (∫ y, ⟪v y, u y⟫ ∂μ) / (∫ y, ‖u y‖ ^ 2 ∂μ)
  have hpt : (fun x => ⟪Pi_u μ u v x, u x⟫) = fun x => ⟪v x, u x⟫ - c * ‖u x‖ ^ 2 := by
    funext x
    simp only [Pi_u, inner_sub_left, real_inner_smul_left, real_inner_self_eq_norm_sq]
  rw [hpt, integral_sub hvu (hu.const_mul c), integral_const_mul]
  simp only [c]
  field_simp
  ring

/-- `Ω_κ(ω; a, b) = ∫ ⟨ω, a × b⟩ dμ - κ ∫ ‖ω‖² ⟨a, b⟩ dμ`. -/
noncomputable def TetherTwoForm (μ : Measure X) (κ : ℝ) (ω a b : X → R3) : ℝ :=
  (∫ x, ⟪ω x, cross (a x) (b x)⟫ ∂μ) - κ * ∫ x, ‖ω x‖ ^ 2 * ⟪a x, b x⟫ ∂μ

theorem tetherTwoForm_add_swap (μ : Measure X) (κ : ℝ) (ω a b : X → R3) :
    TetherTwoForm μ κ ω a b + TetherTwoForm μ κ ω b a =
      -2 * κ * ∫ x, ‖ω x‖ ^ 2 * ⟪a x, b x⟫ ∂μ := by
  have h1 : (∫ x, ⟪ω x, cross (b x) (a x)⟫ ∂μ) = -∫ x, ⟪ω x, cross (a x) (b x)⟫ ∂μ := by
    rw [← integral_neg]; congr 1; funext x; rw [cross_anticomm, inner_neg_right]
  have h2 : (∫ x, ‖ω x‖ ^ 2 * ⟪b x, a x⟫ ∂μ) = ∫ x, ‖ω x‖ ^ 2 * ⟪a x, b x⟫ ∂μ := by
    congr 1; funext x; rw [real_inner_comm]
  simp only [TetherTwoForm, h1, h2]
  ring

theorem tetherTwoForm_self (μ : Measure X) (κ : ℝ) (ω a : X → R3) :
    TetherTwoForm μ κ ω a a = -κ * ∫ x, ‖ω x‖ ^ 2 * ‖a x‖ ^ 2 ∂μ := by
  have : (fun x => ‖ω x‖ ^ 2 * ⟪a x, a x⟫) = fun x => ‖ω x‖ ^ 2 * ‖a x‖ ^ 2 := by
    funext x; rw [real_inner_self_eq_norm_sq]
  simp only [TetherTwoForm, cross_self, inner_zero_right, integral_zero, this]
  ring

end NS.FrohmanianTether
