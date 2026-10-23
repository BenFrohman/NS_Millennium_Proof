/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

/-!
# Clay Millennium Problem: Official Statements

Official statement: Charles L. Fefferman, "Existence and Smoothness of the Navier–Stokes Equation",
Clay Mathematics Institute, 2000.
https://www.claymath.org/wp-content/uploads/2022/06/navierstokes.pdf

This file records the statements. It does not prove them.
The formalization works on the torus (Clay B).
Clay A (whole space) is recorded as an open declaration.
-/

import NS_Millennium_Proof.Modules.NS_Equations

open MeasureTheory

/-- Clay A (Fefferman): Global existence and smoothness on ℝ³, force zero,
    rapid decay of all derivatives of the initial data.
    Official statement (A).
    Not formalized. The current development is on the torus (Clay B).
    Whole-space types (ℝ³ velocity fields, rapid decay, whole-space Biot–Savart)
    are not present. -/
def Clay_A : Prop :=
  ∀ (u₀ : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (ν : ℝ),
    0 < ν →
    (∀ x, ∑ i, fderiv ℝ (u₀ · i) x = 0) →
    (∀ (α : Fin 3 → ℕ) (K : ℕ),
      ∃ C, ∀ x, ‖iteratedFDeriv ℝ (∑ i, α i) u₀ x‖ ≤ C / (1 + ‖x‖) ^ K) →
    ∃ (u : ℝ → EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3))
      (p : ℝ → EuclideanSpace ℝ (Fin 3) → ℝ),
      True  -- precise conclusion requires whole-space NS_PDE and energy

/-- Clay B (Fefferman): Global existence and smoothness on the 3-torus, force zero.
    Official statement (B). The formalization works on this domain.
    This is the statement. It is not a theorem. -/
def Clay_B : Prop :=
  ∀ (u₀ : T3 → EuclideanSpace ℝ (Fin 3)) (ν : ℝ),
    0 < ν →
    (∀ x, ∑ i, fderiv ℝ (u₀ · i) x = 0) →
    ∃ (u : ℝ → T3 → EuclideanSpace ℝ (Fin 3))
      (p : ℝ → T3 → ℝ),
      (∀ t ≥ 0, ContDiff ℝ ⊤ (u t)) ∧
      (∀ t ≥ 0, ∀ x, ∑ i, fderiv ℝ (u t · i) x = 0) ∧
      (∀ t ≥ 0, Integrable (fun x => ‖u t x‖ ^ 2)) ∧
      NS_PDE (fun t x => u t x) (fun t x => p t x) ν ∧
      ∀ x, u 0 x = u₀ x
