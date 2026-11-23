/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import Mathlib

/-!
# Explicit fields on (ℝ/2πℤ)³: the Nov 9 family u₀ = A·U

`U = 3(−sin y, sin x, 0) + (−sin x cos z, 0, cos x sin z)` (2π-periodic, div-free).
* `ν Δu` is the exact difference between the Navier–Stokes vector field and the
  Lie–Poisson + B_F (generator H) vector field (B_F(·,H) ≡ 0, see `Tether.lean`); we show
  it is nonzero at (π/2,0,0): `ν Δ(A·U)(π/2,0,0) = νA(2,−3,0)`.
* Vorticity reading: the vector potential `a = (0, A sin x sin z, 3A(cos x + cos y))`
  (δH/δω, curl a = u) is not a scalar multiple of u, since a(0) = (0,0,6A), u(0) = 0.
-/

namespace TwoLayerT3.Explicit

noncomputable section

def u1 (A x y z : ℝ) : ℝ := A * (-3 * Real.sin y - Real.sin x * Real.cos z)
def u2 (A x _y _z : ℝ) : ℝ := A * (3 * Real.sin x)
def u3 (A x _y z : ℝ) : ℝ := A * (Real.cos x * Real.sin z)

def dx (f : ℝ → ℝ → ℝ → ℝ) (x y z : ℝ) : ℝ := deriv (fun s => f s y z) x
def dy (f : ℝ → ℝ → ℝ → ℝ) (x y z : ℝ) : ℝ := deriv (fun s => f x s z) y
def dz (f : ℝ → ℝ → ℝ → ℝ) (x y z : ℝ) : ℝ := deriv (fun s => f x y s) z

def lap (f : ℝ → ℝ → ℝ → ℝ) (x y z : ℝ) : ℝ :=
  deriv (fun s => deriv (fun r => f r y z) s) x + deriv (fun s => deriv (fun r => f x r z) s) y +
    deriv (fun s => deriv (fun r => f x y r) s) z

theorem div_free (A x y z : ℝ) : dx (u1 A) x y z + dy (u2 A) x y z + dz (u3 A) x y z = 0 := by
  simp [dx, dy, dz, u1, u2, u3]

theorem lap_u1 (A x y z : ℝ) :
    lap (u1 A) x y z = A * (3 * Real.sin y + 2 * Real.sin x * Real.cos z) := by
  simp [lap, u1]; ring

theorem lap_u2 (A x y z : ℝ) : lap (u2 A) x y z = A * (-3 * Real.sin x) := by
  simp [lap, u2]

theorem lap_u3 (A x y z : ℝ) : lap (u3 A) x y z = A * (-2 * Real.cos x * Real.sin z) := by
  simp [lap, u3]; ring

/-- **NS ≠ Lie–Poisson + B_F at an explicit point**: `νΔ(A·U)(π/2,0,0) = (2νA, −3νA, 0)`. -/
theorem viscous_difference_value (A ν : ℝ) :
    ν * lap (u1 A) (Real.pi / 2) 0 0 = 2 * ν * A ∧
    ν * lap (u2 A) (Real.pi / 2) 0 0 = -3 * ν * A ∧
    ν * lap (u3 A) (Real.pi / 2) 0 0 = 0 := by
  refine ⟨?_, ?_, ?_⟩
  · rw [lap_u1]; simp; ring
  · rw [lap_u2]; simp; ring
  · rw [lap_u3]; simp

theorem viscous_difference_ne_zero (A ν : ℝ) (hA : A ≠ 0) (hν : ν ≠ 0) :
    ν * lap (u1 A) (Real.pi / 2) 0 0 ≠ 0 := by
  rw [(viscous_difference_value A ν).1]
  exact mul_ne_zero (mul_ne_zero two_ne_zero hν) hA

/-! ## Vector potential (δH/δω in the vorticity reading) -/

def a1 (_A _x _y _z : ℝ) : ℝ := 0
def a2 (A x _y z : ℝ) : ℝ := A * (Real.sin x * Real.sin z)
def a3 (A x y _z : ℝ) : ℝ := A * (3 * (Real.cos x + Real.cos y))

/-- curl a = u (componentwise). -/
theorem curl_a (A x y z : ℝ) :
    dy (a3 A) x y z - dz (a2 A) x y z = u1 A x y z ∧
    dz (a1 A) x y z - dx (a3 A) x y z = u2 A x y z ∧
    dx (a2 A) x y z - dy (a1 A) x y z = u3 A x y z := by
  refine ⟨?_, ?_, ?_⟩ <;> simp [dx, dy, dz, a1, a2, a3, u1, u2, u3] <;> ring

/-- a is not a pointwise scalar multiple of u (for A ≠ 0): a(0) = (0,0,6A), u(0) = 0. -/
theorem a_not_multiple_of_u (A : ℝ) (hA : A ≠ 0) :
    ¬ ∃ c : ℝ, ∀ x y z, a3 A x y z = c * u3 A x y z := by
  rintro ⟨c, hc⟩
  have h := hc 0 0 0
  simp [a3, u3] at h
  exact hA (by linarith)

end

end TwoLayerT3.Explicit
