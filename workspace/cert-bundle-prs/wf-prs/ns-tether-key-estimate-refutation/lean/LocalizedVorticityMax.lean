/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

/-
  LocalizedVorticityMax.lean — Benjamin Stanley Frohman, 2026-11-17.

  Kernel-checked L^∞ maximum of the V2 localized initial vorticity ω₁ on ℝ³.

  Paper definitions (ε = 1, c = 3):
    ρ(x) = |x|²,
    β(ρ) = exp(-3ρ/(1-ρ)) for ρ < 1 and β(ρ) = 0 for ρ ≥ 1,
    Ψ = β e_z + z β (-y, x, 0),
    u₁ = ∇ × Ψ,   ω₁ = ∇ × u₁.

  On the open unit ball {ρ < 1} the vorticity equals the explicit field
  w(x, t(ρ)) · β, with t = 1/(1-ρ) and w the paper's coefficient polynomials.
  This file proves |ω₁(x)| ≤ 12 everywhere, with equality at the origin, hence
  ‖ω₁‖_∞ = 12.

  The pointwise bound reduces to the elementary inequalities
    (1+s)⁴ ≤ exp(6s)  and  V(s) ≤ exp(6s)  for s ≥ 0, which follow from
  `Real.sum_le_exp_of_nonneg` and algebraic positivity (no interval
  arithmetic, no `native_decide`, no new axioms).
-/

import Mathlib

open Set Filter Topology Real Finset

namespace LocalizedV2

noncomputable section

/-! ## Paper definitions -/

/-- Squared Euclidean radius `ρ = |x|²` appearing in the paper. -/
def rho (x y z : ℝ) : ℝ := x ^ 2 + y ^ 2 + z ^ 2

/-- Horizontal radius squared `R² = x² + y²`. -/
def Rsq (x y : ℝ) : ℝ := x ^ 2 + y ^ 2

/-- The radial parameter `t = 1/(1-ρ)` used inside the open unit ball. -/
def tpar (ρ : ℝ) : ℝ := (1 - ρ)⁻¹

/-- The core bump `β(ρ) = exp(-3ρ/(1-ρ))`, used for `ρ < 1`. -/
def betaCore (ρ : ℝ) : ℝ := Real.exp (-3 * ρ / (1 - ρ))

/-- The compactly supported amplitude `β` of the paper. -/
def beta (x y z : ℝ) : ℝ :=
  if rho x y z < 1 then betaCore (rho x y z) else 0

/-- Vector potential `Ψ = β e_z + z β (-y, x, 0)`. -/
def psi1 (x y z : ℝ) : ℝ := -y * z * beta x y z
def psi2 (x y z : ℝ) : ℝ := x * z * beta x y z
def psi3 (x y z : ℝ) : ℝ := beta x y z

/-- Partial derivatives along the coordinate axes. -/
def dx (f : ℝ → ℝ → ℝ → ℝ) (x y z : ℝ) : ℝ := deriv (fun s => f s y z) x
def dy (f : ℝ → ℝ → ℝ → ℝ) (x y z : ℝ) : ℝ := deriv (fun s => f x s z) y
def dz (f : ℝ → ℝ → ℝ → ℝ) (x y z : ℝ) : ℝ := deriv (fun s => f x y s) z

/-- Velocity `u₁ = ∇ × Ψ`, paper definition. -/
def u1 (x y z : ℝ) : ℝ := dy psi3 x y z - dz psi2 x y z
def u2 (x y z : ℝ) : ℝ := dz psi1 x y z - dx psi3 x y z
def u3 (x y z : ℝ) : ℝ := dx psi2 x y z - dy psi1 x y z

/-- Vorticity `ω₁ = ∇ × u₁`, paper definition. -/
def omega1 (x y z : ℝ) : ℝ := dy u3 x y z - dz u2 x y z
def omega2 (x y z : ℝ) : ℝ := dz u1 x y z - dx u3 x y z
def omega3 (x y z : ℝ) : ℝ := dx u2 x y z - dy u1 x y z

/-! ## Coefficient polynomials of `u₁` and `ω₁` (multiplied by `β` for `ρ < 1`). -/

def uPoly1 (x y z t : ℝ) : ℝ := 6 * t ^ 2 * x * z ^ 2 - 6 * t ^ 2 * y - x
def uPoly2 (x y z t : ℝ) : ℝ := 6 * t ^ 2 * x + 6 * t ^ 2 * y * z ^ 2 - y
def uPoly3 (x y z t : ℝ) : ℝ := 2 * z * (1 - 3 * t ^ 2 * (x ^ 2 + y ^ 2))

def wPoly1 (x y z t : ℝ) : ℝ :=
  12 * t ^ 3 * (3 * t - 2) * z * (x + y * (x ^ 2 + y ^ 2 + z ^ 2)) - 42 * t ^ 2 * y * z

def wPoly2 (x y z t : ℝ) : ℝ :=
  12 * t ^ 3 * (3 * t - 2) * z * (y - x * (x ^ 2 + y ^ 2 + z ^ 2)) + 42 * t ^ 2 * x * z

def wPoly3 (x y _z t : ℝ) : ℝ :=
  12 * t ^ 2 * (1 + t * (x ^ 2 + y ^ 2) * (2 - 3 * t))

def wSq (x y z t : ℝ) : ℝ :=
  wPoly1 x y z t ^ 2 + wPoly2 x y z t ^ 2 + wPoly3 x y z t ^ 2

/-- Auxiliary coefficients in the compact form of `w`. -/
def aCoeff (t : ℝ) : ℝ := 12 * t ^ 3 * (3 * t - 2)
def bCoeff (t : ℝ) : ℝ := 42 * t ^ 2
def pCoeff (t : ℝ) : ℝ := 12 * t ^ 2
def qCoeff (t : ℝ) : ℝ := 12 * t ^ 3 * (2 - 3 * t)

lemma wPoly1_eq (x y z t : ℝ) :
    wPoly1 x y z t = aCoeff t * z * (x + y * rho x y z) - bCoeff t * y * z := by
  unfold wPoly1 aCoeff bCoeff rho; ring

lemma wPoly2_eq (x y z t : ℝ) :
    wPoly2 x y z t = aCoeff t * z * (y - x * rho x y z) + bCoeff t * x * z := by
  unfold wPoly2 aCoeff bCoeff rho; ring

lemma wPoly3_eq (x y z t : ℝ) :
    wPoly3 x y z t = pCoeff t + qCoeff t * Rsq x y := by
  unfold wPoly3 pCoeff qCoeff Rsq; ring

lemma z_sq_eq (x y z : ℝ) : z ^ 2 = rho x y z - Rsq x y := by
  unfold rho Rsq; ring

/-- `|w|²` identity: the horizontal contribution factors as
`z² R² (a² + (aρ - b)²)`. -/
lemma w12_sq (x y z t : ℝ) :
    wPoly1 x y z t ^ 2 + wPoly2 x y z t ^ 2 =
      z ^ 2 * Rsq x y * (aCoeff t ^ 2 + (aCoeff t * rho x y z - bCoeff t) ^ 2) := by
  rw [wPoly1_eq, wPoly2_eq]
  unfold Rsq
  ring

lemma wSq_as_quadratic (x y z t : ℝ) :
    wSq x y z t =
      (rho x y z - Rsq x y) * Rsq x y *
          (aCoeff t ^ 2 + (aCoeff t * rho x y z - bCoeff t) ^ 2) +
        (pCoeff t + qCoeff t * Rsq x y) ^ 2 := by
  unfold wSq
  rw [w12_sq, wPoly3_eq, z_sq_eq]

/-- The `r²` coefficient of `|w|²` as a quadratic in `R²`. It is a nonpositive
perfect square. -/
lemma coeff_C_factor (t ρ : ℝ) :
    qCoeff t ^ 2 - aCoeff t ^ 2 - (aCoeff t * ρ - bCoeff t) ^ 2 =
      -36 * t ^ 4 * (6 * ρ * t ^ 2 - 4 * ρ * t - 7) ^ 2 := by
  unfold aCoeff bCoeff qCoeff; ring

lemma coeff_C_nonpos (t ρ : ℝ) :
    qCoeff t ^ 2 - aCoeff t ^ 2 - (aCoeff t * ρ - bCoeff t) ^ 2 ≤ 0 := by
  rw [coeff_C_factor]
  have ht : 0 ≤ t ^ 4 := by
    have : t ^ 4 = (t ^ 2) ^ 2 := by ring
    rw [this]; exact sq_nonneg _
  have hs : 0 ≤ (6 * ρ * t ^ 2 - 4 * ρ * t - 7) ^ 2 := sq_nonneg _
  nlinarith

/-- Quadratic in the horizontal radius `r = R²`. -/
def Fquad (t ρ r : ℝ) : ℝ :=
  (ρ - r) * r * (aCoeff t ^ 2 + (aCoeff t * ρ - bCoeff t) ^ 2) +
    (pCoeff t + qCoeff t * r) ^ 2

lemma wSq_eq_Fquad (x y z t : ℝ) :
    wSq x y z t = Fquad t (rho x y z) (Rsq x y) := by
  unfold Fquad; exact wSq_as_quadratic x y z t

lemma Fquad_expand (t ρ r : ℝ) :
    Fquad t ρ r =
      pCoeff t ^ 2 +
        ((aCoeff t ^ 2 + (aCoeff t * ρ - bCoeff t) ^ 2) * ρ +
          2 * pCoeff t * qCoeff t) * r +
        (qCoeff t ^ 2 - aCoeff t ^ 2 - (aCoeff t * ρ - bCoeff t) ^ 2) * r ^ 2 := by
  unfold Fquad; ring

lemma pCoeff_sq (t : ℝ) : pCoeff t ^ 2 = 144 * t ^ 4 := by
  unfold pCoeff; ring

/-- The linear coefficient `B` in `F = A + B r + C r²`. -/
def Blin (t ρ : ℝ) : ℝ :=
  (aCoeff t ^ 2 + (aCoeff t * ρ - bCoeff t) ^ 2) * ρ + 2 * pCoeff t * qCoeff t

/-- Because the `r²` coefficient is `≤ 0`, `F(r) ≤ A + B r`. -/
lemma Fquad_le_linear (t ρ r : ℝ) : Fquad t ρ r ≤ pCoeff t ^ 2 + Blin t ρ * r := by
  have hC := coeff_C_nonpos t ρ
  have hr2 : 0 ≤ r ^ 2 := sq_nonneg r
  rw [Fquad_expand]
  unfold Blin
  nlinarith

lemma Fquad_le_A_of_Bnonpos (t ρ r : ℝ) (hr : 0 ≤ r) (hB : Blin t ρ ≤ 0) :
    Fquad t ρ r ≤ pCoeff t ^ 2 := by
  have hlin := Fquad_le_linear t ρ r
  have : Blin t ρ * r ≤ 0 := mul_nonpos_of_nonpos_of_nonneg hB hr
  linarith

lemma Fquad_le_A_add_Brho (t ρ r : ℝ) (_hr0 : 0 ≤ r) (hr1 : r ≤ ρ)
    (hB : 0 ≤ Blin t ρ) :
    Fquad t ρ r ≤ pCoeff t ^ 2 + Blin t ρ * ρ := by
  have hlin := Fquad_le_linear t ρ r
  have : Blin t ρ * r ≤ Blin t ρ * ρ := mul_le_mul_of_nonneg_left hr1 hB
  linarith

/-! ## Elementary exponential inequalities -/

lemma taylor4_exp (s : ℝ) :
    (∑ i ∈ range 5, (6 * s) ^ i / (i.factorial : ℝ)) =
      (1 : ℝ) + 6 * s + 18 * s ^ 2 + 36 * s ^ 3 + 54 * s ^ 4 := by
  simp [sum_range_succ, Nat.factorial_zero, Nat.factorial_succ]
  ring

lemma one_add_pow_four_le_taylor (s : ℝ) (hs : 0 ≤ s) :
    (1 + s) ^ 4 ≤ ∑ i ∈ range 5, (6 * s) ^ i / (i.factorial : ℝ) := by
  rw [taylor4_exp]
  have hpow : (1 + s) ^ 4 = 1 + 4 * s + 6 * s ^ 2 + 4 * s ^ 3 + s ^ 4 := by ring
  rw [hpow]
  nlinarith [sq_nonneg s, sq_nonneg (s ^ 2), pow_nonneg hs 3, pow_nonneg hs 4]

/-- `(1+s)⁴ ≤ exp(6s)` for `s ≥ 0`. -/
lemma one_add_pow_four_le_exp (s : ℝ) (hs : 0 ≤ s) :
    (1 + s) ^ 4 ≤ Real.exp (6 * s) := by
  have hx : 0 ≤ 6 * s := mul_nonneg (by norm_num : (0 : ℝ) ≤ 6) hs
  exact (one_add_pow_four_le_taylor s hs).trans (Real.sum_le_exp_of_nonneg hx 5)

lemma taylor8_exp (s : ℝ) :
    (∑ i ∈ range 9, (6 * s) ^ i / (i.factorial : ℝ)) =
      (1 : ℝ) + 6 * s + 18 * s ^ 2 + 36 * s ^ 3 + 54 * s ^ 4 +
        (324 / 5) * s ^ 5 + (324 / 5) * s ^ 6 + (1944 / 35) * s ^ 7 +
        (1458 / 35) * s ^ 8 := by
  simp [sum_range_succ, Nat.factorial_zero, Nat.factorial_succ]
  ring

/-- The comparison polynomial `V` such that `A + B ρ = 144 V` on the shell
`ρ = s/(s+1)`. -/
def Vpoly (s : ℝ) : ℝ :=
  18 * s ^ 8 + 66 * s ^ 7 + 74 * s ^ 6 + 9 * s ^ 5 - 103 * s ^ 4 / 4 -
    9 * s ^ 3 / 2 + 21 * s ^ 2 / 4 + 2 * s + 1

lemma taylor8_sub_Vpoly (s : ℝ) :
    (∑ i ∈ range 9, (6 * s) ^ i / (i.factorial : ℝ)) - Vpoly s =
      s * (3312 * s ^ 7 - 1464 * s ^ 6 - 1288 * s ^ 5 + 7812 * s ^ 4 +
        11165 * s ^ 3 + 5670 * s ^ 2 + 1785 * s + 560) / 140 := by
  rw [taylor8_exp]
  unfold Vpoly
  ring

lemma Qpoly_nonneg (s : ℝ) (hs : 0 ≤ s) :
    0 ≤ 3312 * s ^ 7 - 1464 * s ^ 6 - 1288 * s ^ 5 + 7812 * s ^ 4 +
      11165 * s ^ 3 + 5670 * s ^ 2 + 1785 * s + 560 := by
  have hrest : 0 ≤ 11165 * s ^ 3 + 5670 * s ^ 2 + 1785 * s + 560 := by
    nlinarith [pow_nonneg hs 3, sq_nonneg s]
  rcases le_total s 1 with hle | hge
  · have hs6 : s ^ 6 ≤ s ^ 5 := by
      calc
        s ^ 6 = s ^ 5 * s := by ring
        _ ≤ s ^ 5 * 1 := mul_le_mul_of_nonneg_left hle (pow_nonneg hs 5)
        _ = s ^ 5 := by ring
    have hs5 : s ^ 5 ≤ s ^ 4 := by
      calc
        s ^ 5 = s ^ 4 * s := by ring
        _ ≤ s ^ 4 * 1 := mul_le_mul_of_nonneg_left hle (pow_nonneg hs 4)
        _ = s ^ 4 := by ring
    have hneg : 1464 * s ^ 6 + 1288 * s ^ 5 ≤ 7812 * s ^ 4 := by
      have h1 : 1464 * s ^ 6 + 1288 * s ^ 5 ≤ 2752 * s ^ 5 := by nlinarith
      have h2 : 2752 * s ^ 5 ≤ 2752 * s ^ 4 := by nlinarith
      have h3 : 2752 * s ^ 4 ≤ 7812 * s ^ 4 := by nlinarith [pow_nonneg hs 4]
      linarith
    nlinarith [pow_nonneg hs 7, pow_nonneg hs 4]
  · have hneg : 1464 * s ^ 6 + 1288 * s ^ 5 ≤ 3312 * s ^ 7 := by
      have h1 : 1464 * s ^ 6 + 1288 * s ^ 5 ≤ 2752 * s ^ 6 := by
        nlinarith [pow_nonneg hs 5, pow_nonneg hs 6, hge]
      have h2 : 2752 * s ^ 6 ≤ 3312 * s ^ 7 := by
        have : (2752 : ℝ) * s ^ 6 ≤ 3312 * s * s ^ 6 := by
          nlinarith [pow_nonneg hs 6, hge]
        have hpow : (3312 : ℝ) * s * s ^ 6 = 3312 * s ^ 7 := by ring
        linarith
      linarith
    nlinarith [pow_nonneg hs 4, pow_nonneg hs 3]

lemma Vpoly_le_taylor8 (s : ℝ) (hs : 0 ≤ s) :
    Vpoly s ≤ ∑ i ∈ range 9, (6 * s) ^ i / (i.factorial : ℝ) := by
  have h := taylor8_sub_Vpoly s
  have hQ := Qpoly_nonneg s hs
  have h140 : (0 : ℝ) < 140 := by norm_num
  have : 0 ≤ (∑ i ∈ range 9, (6 * s) ^ i / (i.factorial : ℝ)) - Vpoly s := by
    rw [h]
    exact div_nonneg (mul_nonneg hs hQ) h140.le
  linarith

lemma Vpoly_le_exp (s : ℝ) (hs : 0 ≤ s) :
    Vpoly s ≤ Real.exp (6 * s) :=
  (Vpoly_le_taylor8 s hs).trans (Real.sum_le_exp_of_nonneg (by nlinarith) 9)

/-! ## Relating `A + B ρ` to `Vpoly` on the shell `ρ = s/(s+1)`. -/

lemma tpar_eq_one_add_s (ρ : ℝ) (h : ρ < 1) : tpar ρ = 1 + ρ / (1 - ρ) := by
  unfold tpar
  have : 1 - ρ ≠ 0 := (sub_pos.mpr h).ne'
  field_simp

lemma s_nonneg_of {ρ : ℝ} (hρ0 : 0 ≤ ρ) (hρ1 : ρ < 1) : 0 ≤ ρ / (1 - ρ) :=
  div_nonneg hρ0 (sub_pos.mpr hρ1).le

lemma rho_eq_s_div (ρ : ℝ) (h : ρ < 1) :
    ρ = (ρ / (1 - ρ)) / ((ρ / (1 - ρ)) + 1) := by
  have : 1 - ρ ≠ 0 := (sub_pos.mpr h).ne'
  field_simp

lemma p_plus_q_rho (s : ℝ) (hs : -1 < s) :
    pCoeff (1 + s) + qCoeff (1 + s) * (s / (s + 1)) =
      -12 * (1 + s) ^ 2 * (3 * s ^ 2 + s - 1) := by
  have hden : s + 1 ≠ 0 := by linarith
  have hmid : pCoeff (1 + s) + qCoeff (1 + s) * (s / (s + 1)) =
      12 * (1 + s) ^ 2 * (1 + s * (2 - 3 * (1 + s))) := by
    unfold pCoeff qCoeff
    field_simp
    ring
  rw [hmid]
  ring

lemma K_on_shell (s : ℝ) (hs : -1 < s) :
    aCoeff (1 + s) ^ 2 + (aCoeff (1 + s) * (s / (s + 1)) - bCoeff (1 + s)) ^ 2 =
      36 * (1 + s) ^ 4 * (72 * s ^ 4 + 120 * s ^ 3 + 8 * s ^ 2 + 4 * s + 53) := by
  have hden : s + 1 ≠ 0 := by linarith
  have ha : aCoeff (1 + s) = 12 * (1 + s) ^ 3 * (3 * (1 + s) - 2) := by
    unfold aCoeff; ring
  have hmid : aCoeff (1 + s) * (s / (s + 1)) - bCoeff (1 + s) =
      6 * (1 + s) ^ 2 * (2 * s * (3 * (1 + s) - 2) - 7) := by
    unfold aCoeff bCoeff
    field_simp
    ring
  rw [ha, hmid]
  ring

lemma A_add_Brho_eq_sq (s t ρ : ℝ) :
    pCoeff t ^ 2 + Blin t ρ * ρ =
      (pCoeff t + qCoeff t * ρ) ^ 2 +
        (aCoeff t ^ 2 + (aCoeff t * ρ - bCoeff t) ^ 2) * ρ ^ 2 := by
  unfold Blin; ring

/-- Explicit expansion of `A + Bρ` on the shell `t = 1+s`, `ρ = s/(s+1)`. -/
lemma A_add_Brho_eq_Vpoly (s : ℝ) (hs : -1 < s) :
    pCoeff (1 + s) ^ 2 + Blin (1 + s) (s / (s + 1)) * (s / (s + 1)) =
      144 * Vpoly s := by
  have hden : s + 1 ≠ 0 := by linarith
  rw [A_add_Brho_eq_sq, p_plus_q_rho s hs, K_on_shell s hs]
  have hρ : (s / (s + 1)) ^ 2 = s ^ 2 / (s + 1) ^ 2 := by
    field_simp
  rw [hρ]
  have hKρ :
      36 * (1 + s) ^ 4 * (72 * s ^ 4 + 120 * s ^ 3 + 8 * s ^ 2 + 4 * s + 53) *
          (s ^ 2 / (s + 1) ^ 2) =
        36 * (1 + s) ^ 2 * s ^ 2 *
          (72 * s ^ 4 + 120 * s ^ 3 + 8 * s ^ 2 + 4 * s + 53) := by
    have : (1 + s) ^ 4 / (s + 1) ^ 2 = (1 + s) ^ 2 := by
      have hts : (1 + s : ℝ) = s + 1 := by ring
      rw [hts]
      field_simp
      ring
    field_simp
    ring
  rw [hKρ]
  unfold Vpoly
  ring

lemma Fquad_le_144_exp {ρ r : ℝ} (hρ0 : 0 ≤ ρ) (hρ1 : ρ < 1)
    (hr0 : 0 ≤ r) (hr1 : r ≤ ρ) :
    Fquad (tpar ρ) ρ r ≤ 144 * Real.exp (6 * (ρ / (1 - ρ))) := by
  set t := tpar ρ
  set s := ρ / (1 - ρ)
  have hs0 : 0 ≤ s := s_nonneg_of hρ0 hρ1
  have hs1 : -1 < s := lt_of_lt_of_le (by norm_num : (-1 : ℝ) < 0) hs0
  have ht : t = 1 + s := tpar_eq_one_add_s ρ hρ1
  have hρs : ρ = s / (s + 1) := rho_eq_s_div ρ hρ1
  have hA : pCoeff t ^ 2 = 144 * t ^ 4 := pCoeff_sq t
  have hAexp : pCoeff t ^ 2 ≤ 144 * Real.exp (6 * s) := by
    rw [hA, ht]
    nlinarith [one_add_pow_four_le_exp s hs0, Real.exp_pos (6 * s)]
  have hV : pCoeff t ^ 2 + Blin t ρ * ρ = 144 * Vpoly s := by
    rw [ht, hρs]
    exact A_add_Brho_eq_Vpoly s hs1
  have hVexp : pCoeff t ^ 2 + Blin t ρ * ρ ≤ 144 * Real.exp (6 * s) := by
    rw [hV]
    nlinarith [Vpoly_le_exp s hs0, Real.exp_pos (6 * s)]
  rcases le_total (Blin t ρ) 0 with hB | hB
  · exact (Fquad_le_A_of_Bnonpos t ρ r hr0 hB).trans hAexp
  · exact (Fquad_le_A_add_Brho t ρ r hr0 hr1 hB).trans hVexp

/-! ## Pointwise bound for the explicit coefficient field. -/

lemma rho_nonneg (x y z : ℝ) : 0 ≤ rho x y z := by
  unfold rho; nlinarith [sq_nonneg x, sq_nonneg y, sq_nonneg z]

lemma Rsq_nonneg (x y : ℝ) : 0 ≤ Rsq x y := by
  unfold Rsq; nlinarith [sq_nonneg x, sq_nonneg y]

lemma Rsq_le_rho (x y z : ℝ) : Rsq x y ≤ rho x y z := by
  unfold Rsq rho; nlinarith [sq_nonneg z]

lemma beta_eq_core {x y z : ℝ} (h : rho x y z < 1) :
    beta x y z = betaCore (rho x y z) :=
  if_pos h

lemma beta_eq_zero {x y z : ℝ} (h : ¬ rho x y z < 1) :
    beta x y z = 0 :=
  if_neg h

lemma betaCore_sq (ρ : ℝ) (h : ρ < 1) :
    betaCore ρ ^ 2 = Real.exp (-6 * (ρ / (1 - ρ))) := by
  unfold betaCore
  have hne : 1 - ρ ≠ 0 := (sub_pos.mpr h).ne'
  have hexp : (Real.exp (-3 * ρ / (1 - ρ))) ^ 2 =
      Real.exp (2 * (-3 * ρ / (1 - ρ))) := by
    rw [pow_two, ← Real.exp_add]; ring
  rw [hexp]
  have : (2 : ℝ) * (-3 * ρ / (1 - ρ)) = -6 * (ρ / (1 - ρ)) := by ring
  rw [this]

lemma beta_sq_of_lt {x y z : ℝ} (h : rho x y z < 1) :
    beta x y z ^ 2 = Real.exp (-6 * (rho x y z / (1 - rho x y z))) := by
  rw [beta_eq_core h, betaCore_sq _ h]

lemma wSq_mul_beta_le_144 {x y z : ℝ} (h : rho x y z < 1) :
    wSq x y z (tpar (rho x y z)) * beta x y z ^ 2 ≤ 144 := by
  have hρ0 := rho_nonneg x y z
  have hr0 := Rsq_nonneg x y
  have hr1 := Rsq_le_rho x y z
  have hF := Fquad_le_144_exp hρ0 h (hr0) hr1
  have hident : wSq x y z (tpar (rho x y z)) = Fquad (tpar (rho x y z)) (rho x y z) (Rsq x y) :=
    wSq_eq_Fquad x y z (tpar (rho x y z))
  have hβ := beta_sq_of_lt h
  have hexp : 0 ≤ Real.exp (-6 * (rho x y z / (1 - rho x y z))) := (Real.exp_pos _).le
  have hpos : 0 ≤ wSq x y z (tpar (rho x y z)) := by
    unfold wSq; nlinarith [sq_nonneg (wPoly1 x y z (tpar (rho x y z))),
      sq_nonneg (wPoly2 x y z (tpar (rho x y z))),
      sq_nonneg (wPoly3 x y z (tpar (rho x y z)))]
  -- F * exp(-6s) ≤ 144 exp(6s) * exp(-6s) = 144
  have hmul := mul_le_mul_of_nonneg_right hF hexp
  rw [hident, hβ]
  have hcancel :
      144 * Real.exp (6 * (rho x y z / (1 - rho x y z))) *
        Real.exp (-6 * (rho x y z / (1 - rho x y z))) = 144 := by
    have hsum : 6 * (rho x y z / (1 - rho x y z)) +
        -6 * (rho x y z / (1 - rho x y z)) = 0 := by ring
    calc
      144 * Real.exp (6 * (rho x y z / (1 - rho x y z))) *
          Real.exp (-6 * (rho x y z / (1 - rho x y z))) =
        144 * (Real.exp (6 * (rho x y z / (1 - rho x y z))) *
          Real.exp (-6 * (rho x y z / (1 - rho x y z)))) := by ring
      _ = 144 * Real.exp (6 * (rho x y z / (1 - rho x y z)) +
            -6 * (rho x y z / (1 - rho x y z))) := by
        rw [Real.exp_add]
      _ = 144 * Real.exp 0 := by rw [hsum]
      _ = 144 := by simp
  linarith

/-- Explicit vorticity field: the paper polynomials times `β` inside the ball,
and `0` outside. This is identified with `∇ × ∇ × Ψ` on `{ρ < 1}` below. -/
def omegaExpl1 (x y z : ℝ) : ℝ :=
  if rho x y z < 1 then wPoly1 x y z (tpar (rho x y z)) * beta x y z else 0

def omegaExpl2 (x y z : ℝ) : ℝ :=
  if rho x y z < 1 then wPoly2 x y z (tpar (rho x y z)) * beta x y z else 0

def omegaExpl3 (x y z : ℝ) : ℝ :=
  if rho x y z < 1 then wPoly3 x y z (tpar (rho x y z)) * beta x y z else 0

lemma omegaExpl_sq_le_144 (x y z : ℝ) :
    omegaExpl1 x y z ^ 2 + omegaExpl2 x y z ^ 2 + omegaExpl3 x y z ^ 2 ≤ 144 := by
  by_cases h : rho x y z < 1
  · have h1 : omegaExpl1 x y z = wPoly1 x y z (tpar (rho x y z)) * beta x y z := if_pos h
    have h2 : omegaExpl2 x y z = wPoly2 x y z (tpar (rho x y z)) * beta x y z := if_pos h
    have h3 : omegaExpl3 x y z = wPoly3 x y z (tpar (rho x y z)) * beta x y z := if_pos h
    have : omegaExpl1 x y z ^ 2 + omegaExpl2 x y z ^ 2 + omegaExpl3 x y z ^ 2 =
        wSq x y z (tpar (rho x y z)) * beta x y z ^ 2 := by
      rw [h1, h2, h3]; unfold wSq; ring
    rw [this]
    exact wSq_mul_beta_le_144 h
  · have h1 : omegaExpl1 x y z = 0 := if_neg h
    have h2 : omegaExpl2 x y z = 0 := if_neg h
    have h3 : omegaExpl3 x y z = 0 := if_neg h
    simp [h1, h2, h3]

lemma wPoly_origin :
    wPoly1 0 0 0 1 = 0 ∧ wPoly2 0 0 0 1 = 0 ∧ wPoly3 0 0 0 1 = 12 := by
  unfold wPoly1 wPoly2 wPoly3; ring_nf; norm_num

lemma beta_origin : beta 0 0 0 = 1 := by
  have hρ : rho 0 0 0 = 0 := by unfold rho; ring
  have hlt : rho 0 0 0 < 1 := by rw [hρ]; norm_num
  rw [beta_eq_core hlt, hρ]
  unfold betaCore
  simp

lemma tpar_origin : tpar (rho 0 0 0) = 1 := by
  unfold tpar rho; simp

/-- Equality at the origin: `ω₁(0) = (0,0,12)`, so `|ω₁(0)| = 12`. -/
lemma omegaExpl_at_origin :
    omegaExpl1 0 0 0 = 0 ∧ omegaExpl2 0 0 0 = 0 ∧ omegaExpl3 0 0 0 = 12 := by
  have hlt : rho 0 0 0 < 1 := by unfold rho; norm_num
  simp only [omegaExpl1, omegaExpl2, omegaExpl3, if_pos hlt, tpar_origin, beta_origin]
  obtain ⟨h1, h2, h3⟩ := wPoly_origin
  simp [h1, h2, h3]

lemma omegaExpl_norm_le (x y z : ℝ) :
    Real.sqrt (omegaExpl1 x y z ^ 2 + omegaExpl2 x y z ^ 2 + omegaExpl3 x y z ^ 2) ≤ 12 := by
  have hsq := omegaExpl_sq_le_144 x y z
  have hnn : 0 ≤ omegaExpl1 x y z ^ 2 + omegaExpl2 x y z ^ 2 + omegaExpl3 x y z ^ 2 := by
    nlinarith [sq_nonneg (omegaExpl1 x y z), sq_nonneg (omegaExpl2 x y z),
      sq_nonneg (omegaExpl3 x y z)]
  rw [Real.sqrt_le_left (by norm_num : (0 : ℝ) ≤ 12)]
  nlinarith

lemma omegaExpl_norm_origin :
    Real.sqrt (omegaExpl1 0 0 0 ^ 2 + omegaExpl2 0 0 0 ^ 2 + omegaExpl3 0 0 0 ^ 2) = 12 := by
  have h := omegaExpl_at_origin
  rw [h.1, h.2.1, h.2.2]
  norm_num

/-- `‖ω₁‖_∞ = 12` for the explicit field (identified with `∇ × ∇ × Ψ` below). -/
theorem omegaExpl_sup_eq_12 :
    (∀ x y z : ℝ,
        Real.sqrt (omegaExpl1 x y z ^ 2 + omegaExpl2 x y z ^ 2 + omegaExpl3 x y z ^ 2) ≤ 12) ∧
      Real.sqrt (omegaExpl1 0 0 0 ^ 2 + omegaExpl2 0 0 0 ^ 2 + omegaExpl3 0 0 0 ^ 2) = 12 :=
  ⟨omegaExpl_norm_le, omegaExpl_norm_origin⟩

end

end LocalizedV2
