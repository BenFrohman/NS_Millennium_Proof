/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import Mathlib.Tactic

/-!
# Pointwise algebra of the displayed Frohmanian Tether 2-form

This formalizes the *displayed densities* of the candidate `TF` formulas,
as written in the May 21 2026 `vFinal` note (Drive `vFinal.txt`,
sha256 `d5b6508eca165379bebd46185557cef5fc7864a94a8bc39d73aec142361e6c05`)
and the May 14 construction (recovered Drive tex,
sha256 `98717d941535df4d96d9fa18b6367c3de6350212a112ab09458c0a47bea026ff`).

The associated 2-form is written (vFinal, displayed equation (6); May 14
"associated 2-form") as the pointwise density

  `TF(δu, δv) ∼ ω · (δu × δv) − κ |ω|² (δu · δv)`.

A second, distinct formula in the same documents uses the projected kernel
`Π_u` (and, in vFinal / May 24, a Biot–Savart double integral). Those two
writings are not the same bilinear form. This file treats the densities
pointwise on `Fin 3 → ℝ`, which is enough to decide symmetry, degeneracy,
and collinearity, and does not stand in for a torus integral.

No `sorry`. No dummy types.
-/

namespace TFFrohmanianTether

/-- Standard basis vectors \(e_1,e_2,e_3\) of \(\mathbb{R}^3\). -/
def e₁ : Fin 3 → ℝ := fun i => if i = 0 then 1 else 0
def e₂ : Fin 3 → ℝ := fun i => if i = 1 then 1 else 0
def e₃ : Fin 3 → ℝ := fun i => if i = 2 then 1 else 0

def dot (a b : Fin 3 → ℝ) : ℝ := a 0 * b 0 + a 1 * b 1 + a 2 * b 2

def cross (a b : Fin 3 → ℝ) : Fin 3 → ℝ
  | 0 => a 1 * b 2 - a 2 * b 1
  | 1 => a 2 * b 0 - a 0 * b 2
  | 2 => a 0 * b 1 - a 1 * b 0

lemma dot_comm (a b : Fin 3 → ℝ) : dot a b = dot b a := by
  simp [dot, mul_comm]

lemma dot_zero_right (a : Fin 3 → ℝ) : dot a (fun _ => 0) = 0 := by
  simp [dot]

lemma dot_neg_right (a b : Fin 3 → ℝ) : dot a (fun i => -b i) = - dot a b := by
  simp [dot]
  ring

lemma dot_smul_right (a b : Fin 3 → ℝ) (c : ℝ) : dot a (fun i => c * b i) = c * dot a b := by
  simp [dot]
  ring

lemma dot_smul_left (a b : Fin 3 → ℝ) (c : ℝ) : dot (fun i => c * a i) b = c * dot a b := by
  simp [dot]
  ring

lemma sum_squares_eq_zero {a b c : ℝ} (h : a * a + b * b + c * c = 0) :
    a = 0 ∧ b = 0 ∧ c = 0 := by
  have ha : 0 ≤ a * a := mul_self_nonneg a
  have hb : 0 ≤ b * b := mul_self_nonneg b
  have hc : 0 ≤ c * c := mul_self_nonneg c
  have ha0 : a * a = 0 := by nlinarith
  have hb0 : b * b = 0 := by nlinarith
  have hc0 : c * c = 0 := by nlinarith
  exact ⟨mul_self_eq_zero.mp ha0, mul_self_eq_zero.mp hb0, mul_self_eq_zero.mp hc0⟩

lemma eq_zero_of_dot_self_eq_zero {u : Fin 3 → ℝ} (h : dot u u = 0) : u = fun _ => 0 := by
  have := sum_squares_eq_zero (by simpa [dot] using h)
  funext i; fin_cases i <;> simp [this]

lemma cross_antisymm (a b : Fin 3 → ℝ) : cross a b = fun i => - cross b a i := by
  funext i
  fin_cases i <;> simp [cross] <;> ring

/-- Kirillov–Kostant–Souriau / Lie–Poisson density: `ω · (δu × δv)`. -/
def ω_KKS (ω δu δv : Fin 3 → ℝ) : ℝ := dot ω (cross δu δv)

/-- Unprojected metric density appearing in vFinal (6) and May 14: `|ω|² (δu · δv)`. -/
def omega_sq_dot (ω δu δv : Fin 3 → ℝ) : ℝ := dot ω ω * dot δu δv

/-- Displayed associated 2-form density of `TF`. -/
def TF (κ : ℝ) (ω δu δv : Fin 3 → ℝ) : ℝ :=
  ω_KKS ω δu δv - κ * omega_sq_dot ω δu δv

lemma ω_KKS_antisymm (ω δu δv : Fin 3 → ℝ) : ω_KKS ω δu δv = - ω_KKS ω δv δu := by
  unfold ω_KKS
  rw [cross_antisymm, dot_neg_right]

lemma omega_sq_dot_symm (ω δu δv : Fin 3 → ℝ) : omega_sq_dot ω δu δv = omega_sq_dot ω δv δu := by
  simp [omega_sq_dot, dot_comm δu δv]

lemma TF_split (κ : ℝ) (ω δu δv : Fin 3 → ℝ) :
    TF κ ω δu δv = ω_KKS ω δu δv - κ * omega_sq_dot ω δu δv :=
  rfl

lemma dot_e₁_e₁ : dot e₁ e₁ = 1 := by simp [dot, e₁]
lemma dot_e₂_e₂ : dot e₂ e₂ = 1 := by simp [dot, e₂]
lemma dot_e₁_e₂ : dot e₁ e₂ = 0 := by simp [dot, e₁, e₂]
lemma dot_e₂_e₁ : dot e₂ e₁ = 0 := by simp [dot, e₁, e₂]
lemma dot_e₂_e₃ : dot e₂ e₃ = 0 := by simp [dot, e₂, e₃]

lemma cross_e₂_e₃ : cross e₂ e₃ = e₁ := by
  funext i
  fin_cases i <;> simp [cross, e₁, e₂, e₃]

lemma ω_KKS_e₁_e₂_e₃ : ω_KKS e₁ e₂ e₃ = 1 := by
  simp [ω_KKS, cross_e₂_e₃, dot_e₁_e₁]

lemma ω_KKS_e₁_e₁_e₁ : ω_KKS e₁ e₁ e₁ = 0 := by
  have : cross e₁ e₁ = fun _ => 0 := by
    funext i; fin_cases i <;> simp [cross, e₁]
  simp [ω_KKS, this, dot]

lemma omega_sq_dot_e₁_e₁_e₁ : omega_sq_dot e₁ e₁ e₁ = 1 := by
  simp [omega_sq_dot, dot_e₁_e₁]

lemma omega_sq_dot_e₁_e₂_e₃ : omega_sq_dot e₁ e₂ e₃ = 0 := by
  simp [omega_sq_dot, dot_e₁_e₁, dot_e₂_e₃]

/-- The displayed density is not antisymmetric in general.

Witness: `ω = δu = δv = e₁`, `κ = 1`. Then `ω_KKS = 0` and `omega_sq_dot = 1`, so
`TF = -1` while `-TF = 1`.
-/
theorem TF_not_antisymmetric :
    ¬ (∀ (κ : ℝ) (ω δu δv : Fin 3 → ℝ),
        TF κ ω δu δv = - TF κ ω δv δu) := by
  intro h
  have hκ := h 1 e₁ e₁ e₁
  have : TF 1 e₁ e₁ e₁ = -1 := by
    simp [TF, ω_KKS_e₁_e₁_e₁, omega_sq_dot_e₁_e₁_e₁]
  have : (-1 : ℝ) = 1 := by
    simp [TF, ω_KKS_e₁_e₁_e₁, omega_sq_dot_e₁_e₁_e₁] at hκ
    linarith
  exact absurd this (by norm_num)

/-- The displayed density is not symmetric either (the KKS term is alternating).

Witness: `ω = e₁`, `δu = e₁`, `δv = e₂`, `κ = 0`. Then `TF(δu,δv) = 1`
and `TF(δv,δu) = -1`.
-/
theorem TF_not_symmetric :
    ¬ (∀ (κ : ℝ) (ω δu δv : Fin 3 → ℝ),
        TF κ ω δu δv = TF κ ω δv δu) := by
  intro h
  have hκ := h 0 e₁ e₂ e₃
  have hL : TF 0 e₁ e₂ e₃ = 1 := by
    simp [TF, ω_KKS_e₁_e₂_e₃, omega_sq_dot_e₁_e₂_e₃]
  have hk : ω_KKS e₁ e₃ e₂ = -1 := by
    have := ω_KKS_antisymm e₁ e₂ e₃
    rw [ω_KKS_e₁_e₂_e₃] at this
    linarith
  have hm : omega_sq_dot e₁ e₃ e₂ = 0 := by
    rw [← omega_sq_dot_symm, omega_sq_dot_e₁_e₂_e₃]
  have hR : TF 0 e₁ e₃ e₂ = -1 := by
    simp [TF, hk, hm]
  rw [hL, hR] at hκ
  exact absurd hκ (by norm_num)

/-- `Π_u v = v − (⟨v,u⟩/⟨u,u⟩) u`, with the convention `Π_0 = id`. -/
noncomputable def Pi_u (u v : Fin 3 → ℝ) : Fin 3 → ℝ :=
  if dot u u = 0 then v else fun i => v i - (dot v u / dot u u) * u i

theorem Pi_u_self (u : Fin 3 → ℝ) : Pi_u u u = fun _ => 0 := by
  unfold Pi_u
  split_ifs with h
  · rw [eq_zero_of_dot_self_eq_zero h]
  · funext i
    field_simp [h]
    ring

theorem omega_sq_dot_Pi_u_self (u δF : Fin 3 → ℝ) :
    omega_sq_dot u (Pi_u u δF) (Pi_u u u) = 0 := by
  simp [omega_sq_dot, Pi_u_self, dot]

/-- The metric density still vanishes if the weight is an independent field `ω`,
because `Π_u u = 0`. -/
theorem omega_sq_dot_Pi_u_self_weight (ω u δF : Fin 3 → ℝ) :
    omega_sq_dot ω (Pi_u u δF) (Pi_u u u) = 0 := by
  simp [omega_sq_dot, Pi_u_self, dot]

/-- Unprojected metric pairing with the energy direction `u` need not vanish. -/
theorem omega_sq_dot_not_degenerate_on_u :
    ∃ ω u, omega_sq_dot ω u u ≠ 0 := by
  refine ⟨e₁, e₁, ?_⟩
  simp [omega_sq_dot, dot_e₁_e₁]

/-- Orthogonal projection onto the complement of `span{ω}` (Casimir direction).
Convention: if `ω = 0` then `P^⊥ = id`. -/
noncomputable def P_δC_perp (ω v : Fin 3 → ℝ) : Fin 3 → ℝ := Pi_u ω v

theorem P_δC_perp_self (ω : Fin 3 → ℝ) : P_δC_perp ω ω = fun _ => 0 :=
  Pi_u_self ω

/-- The later `K_FT` density (October uniqueness paper): `|ω|² ⟨P_ω^⊥ v, P_ω^⊥ w⟩`. -/
noncomputable def K_FT (ω v w : Fin 3 → ℝ) : ℝ :=
  dot ω ω * dot (P_δC_perp ω v) (P_δC_perp ω w)

theorem K_FT_vanishes_on_δC (ω v : Fin 3 → ℝ) : K_FT ω ω v = 0 := by
  simp [K_FT, P_δC_perp_self, dot]

theorem K_FT_vanishes_on_δC_right (ω v : Fin 3 → ℝ) : K_FT ω v ω = 0 := by
  simp [K_FT, P_δC_perp_self, dot]

theorem K_FT_uu_eq_zero_of_collinear (ω u : Fin 3 → ℝ) (c : ℝ)
    (hu : u = fun i => c * ω i) : K_FT ω u u = 0 := by
  have h : P_δC_perp ω u = fun _ => 0 := by
    unfold P_δC_perp Pi_u
    split_ifs with h0
    · have hω := eq_zero_of_dot_self_eq_zero h0
      rw [hu, hω]
      funext i; simp
    · funext i
      rw [hu]
      have hd : dot (fun j => c * ω j) ω = c * dot ω ω :=
        dot_smul_left ω ω c
      simp only [hd]
      field_simp [h0]
      ring
  simp [K_FT, h, dot]

/-- Explicit witness: `K_FT(u,u)` need not vanish when `u` is not parallel to `ω`. -/
theorem K_FT_uu_not_identically_zero :
    ∃ ω u, K_FT ω u u ≠ 0 := by
  refine ⟨e₁, e₂, ?_⟩
  have hpi : P_δC_perp e₁ e₂ = e₂ := by
    unfold P_δC_perp Pi_u
    have h0 : dot e₁ e₁ ≠ 0 := by simp [dot_e₁_e₁]
    simp [h0, dot_e₂_e₁, dot_e₁_e₁]
  have : K_FT e₁ e₂ e₂ = 1 := by
    simp [K_FT, hpi, dot_e₁_e₁, dot_e₂_e₂]
  exact this.symm ▸ (by norm_num : (1 : ℝ) ≠ 0)

/-- Projected (energy-null) pairing: `⟨Π_u δF, Π_u u⟩ = 0`, hence any kernel
built from `Π_u δF · Π_u δH` with `δH = u` vanishes.
This is C2 / energy-null degeneracy, used in vFinal's degeneracy paragraph
and in the published obstruction papers 23971661, 24120781, 23990195. -/
theorem Pi_u_pairing_with_u (u δF : Fin 3 → ℝ) :
    dot (Pi_u u δF) (Pi_u u u) = 0 := by
  simp [Pi_u_self, dot_zero_right]

/-- Consequently the tether contribution to `dF/dt` along the kinetic-energy
Hamiltonian, in the projected-kernel reading with `δH = u`, is identically zero. -/
theorem Pi_u_tether_contribution_along_H (κ : ℝ) (ω u δF : Fin 3 → ℝ) :
    -κ * omega_sq_dot ω (Pi_u u δF) (Pi_u u u) = 0 := by
  rw [omega_sq_dot_Pi_u_self_weight]
  simp

end TFFrohmanianTether
