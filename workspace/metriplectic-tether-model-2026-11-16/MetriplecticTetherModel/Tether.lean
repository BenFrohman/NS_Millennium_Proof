/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import MetriplecticTetherModel.Basic

/-!
# MetriplecticTetherModel.Tether

Algebraic and measure-theoretic facts about the projection `Π_u` and the velocity-slot tether
`B(a,b) = −κ ∫ |ω|² (Π_u a · Π_u b)` on `𝕋³`:

* `proj_self`: `Π_u u = 0` when `⟨u,u⟩ ≠ 0`;
* `l2_proj_orth`: `⟨Π_u v, u⟩ = 0` for continuous `u, v`;
* `tether_symm`: `B(a,b) = B(b,a)`;
* `tether_diag_nonpos`: `B(a,a) ≤ 0` for `κ ≥ 0`;
* `tether_energy_slot_right`, `tether_energy_slot_left`: `B(a,u) = B(u,a) = 0` for continuous `u`
  (the tether is degenerate on the energy gradient `δH/δu = u`);
* the same degeneracy and sign for the factorized-weight variant
  `tetherFactorized κ ω u a b = −κ ‖ω‖² ⟨Π_u a, Π_u b⟩` (`tetherFactorized_energy_slot_right`,
  `tetherFactorized_diag_nonpos`).
-/

open MeasureTheory

namespace MetriplecticTetherModel

theorem dot_comm (p q : R3) : dot p q = dot q p := by
  simp only [dot, mul_comm]

theorem dot_self_nonneg (p : R3) : 0 ≤ dot p p := by
  unfold dot
  exact Finset.sum_nonneg fun i _ => mul_self_nonneg (p i)

theorem dot_self_eq_zero {p : R3} (h : dot p p = 0) : p = 0 := by
  unfold dot at h
  have hs := (Finset.sum_eq_zero_iff_of_nonneg (fun i _ => mul_self_nonneg (p i))).1 h
  funext i
  exact mul_self_eq_zero.1 (hs i (Finset.mem_univ i))

theorem dot_zero_right (p : R3) : dot p 0 = 0 := by simp [dot]

theorem dot_sub_smul_left (v u q : R3) (c : ℝ) : dot (v - c • u) q = dot v q - c * dot u q := by
  simp only [dot, Fin.sum_univ_three, Pi.sub_apply, Pi.smul_apply, smul_eq_mul]
  ring

theorem continuous_dot {f g : R3 → R3} (hf : Continuous f) (hg : Continuous g) :
    Continuous fun x => dot (f x) (g x) := by
  unfold dot
  fun_prop

theorem isCompact_cell : IsCompact cell :=
  isCompact_univ_pi fun _ => isCompact_Icc

/-- Every continuous scalar function is integrable on `𝕋³` (compact fundamental cell). -/
theorem integrable_of_continuous {f : R3 → ℝ} (hf : Continuous f) : Integrable f μ :=
  hf.continuousOn.integrableOn_compact isCompact_cell

theorem l2_comm (f g : R3 → R3) : l2 f g = l2 g f := by
  simp only [l2, dot_comm]

theorem l2_self_nonneg (u : R3 → R3) : 0 ≤ l2 u u :=
  integral_nonneg fun x => dot_self_nonneg (u x)

/-- A continuous field with `⟨u,u⟩ = 0` vanishes `μ`-almost everywhere. -/
theorem ae_eq_zero_of_l2_self_eq_zero {u : R3 → R3} (hu : Continuous u) (h : l2 u u = 0) :
    ∀ᵐ x ∂μ, u x = 0 := by
  have hint := integrable_of_continuous (continuous_dot hu hu)
  have h0 := (integral_eq_zero_iff_of_nonneg (fun x => dot_self_nonneg (u x)) hint).1 h
  filter_upwards [h0] with x hx
  exact dot_self_eq_zero hx

/-- `Π_u u = 0` whenever `⟨u,u⟩ ≠ 0`. -/
theorem proj_self {u : R3 → R3} (hu : l2 u u ≠ 0) : proj u u = 0 := by
  funext x
  simp [proj, div_self hu]

/-- `Π_u v` is `L²`-orthogonal to `u` (continuous `u`, `v`). -/
theorem l2_proj_orth {u v : R3 → R3} (hu : Continuous u) (hv : Continuous v) :
    l2 (proj u v) u = 0 := by
  by_cases h : l2 u u = 0
  · have hz := ae_eq_zero_of_l2_self_eq_zero hu h
    unfold l2
    refine integral_eq_zero_of_ae ?_
    filter_upwards [hz] with x hx
    simp [hx, dot_zero_right]
  · have hpt : ∀ x, dot (proj u v x) (u x) = dot (v x) (u x) - (l2 v u / l2 u u) * dot (u x) (u x) :=
      fun x => dot_sub_smul_left _ _ _ _
    have h1 := integrable_of_continuous (continuous_dot hv hu)
    have h2 := integrable_of_continuous (continuous_dot hu hu)
    unfold l2
    simp_rw [hpt]
    rw [integral_sub h1 (h2.const_mul _), integral_const_mul]
    change l2 v u - l2 v u / l2 u u * l2 u u = 0
    rw [div_mul_cancel₀ _ h]
    ring

/-- The tether is symmetric. -/
theorem tether_symm (κ : ℝ) (w u a b : R3 → R3) : tether κ w u a b = tether κ w u b a := by
  simp only [tether, dot_comm (proj u a _)]

/-- The tether has nonpositive diagonal: `B(a,a) ≤ 0` for `κ ≥ 0`. -/
theorem tether_diag_nonpos {κ : ℝ} (hκ : 0 ≤ κ) (w u a : R3 → R3) : tether κ w u a a ≤ 0 := by
  unfold tether
  have : 0 ≤ ∫ x, dot (w x) (w x) * dot (proj u a x) (proj u a x) ∂μ :=
    integral_nonneg fun x => mul_nonneg (dot_self_nonneg _) (dot_self_nonneg _)
  nlinarith

/-- Degeneracy on the energy gradient (right slot): `B(a, u) = 0` for continuous `u`. -/
theorem tether_energy_slot_right (κ : ℝ) (w a : R3 → R3) {u : R3 → R3} (hu : Continuous u) :
    tether κ w u a u = 0 := by
  unfold tether
  by_cases h : l2 u u = 0
  · have hz := ae_eq_zero_of_l2_self_eq_zero hu h
    have : (∫ x, dot (w x) (w x) * dot (proj u a x) (proj u u x) ∂μ) = 0 := by
      refine integral_eq_zero_of_ae ?_
      filter_upwards [hz] with x hx
      simp [proj, hx, dot_zero_right]
    rw [this, mul_zero]
  · rw [proj_self h]
    simp [dot_zero_right]

/-- Degeneracy on the energy gradient (left slot): `B(u, b) = 0` for continuous `u`. -/
theorem tether_energy_slot_left (κ : ℝ) (w b : R3 → R3) {u : R3 → R3} (hu : Continuous u) :
    tether κ w u u b = 0 := by
  rw [tether_symm]
  exact tether_energy_slot_right κ w b hu

/-- Factorized-weight velocity-slot tether `−κ ‖ω‖²_{L²} ⟨Π_u a, Π_u b⟩_{L²}`. -/
noncomputable def tetherFactorized (κ : ℝ) (w u a b : R3 → R3) : ℝ :=
  -κ * l2 w w * l2 (proj u a) (proj u b)

theorem l2_zero_right (f : R3 → R3) : l2 f 0 = 0 := by
  simp [l2, dot_zero_right]

/-- Degeneracy of the factorized variant on the energy gradient (continuous `u`, `a`). -/
theorem tetherFactorized_energy_slot_right (κ : ℝ) (w : R3 → R3) {u a : R3 → R3}
    (hu : Continuous u) (ha : Continuous a) : tetherFactorized κ w u a u = 0 := by
  unfold tetherFactorized
  by_cases h : l2 u u = 0
  · have hpu : proj u u = u := by
      funext x
      simp [proj, h]
    rw [hpu, l2_proj_orth hu ha, mul_zero]
  · rw [proj_self h, l2_zero_right, mul_zero]

/-- The factorized variant has nonpositive diagonal for `κ ≥ 0`. -/
theorem tetherFactorized_diag_nonpos {κ : ℝ} (hκ : 0 ≤ κ) (w u a : R3 → R3) :
    tetherFactorized κ w u a a ≤ 0 := by
  unfold tetherFactorized
  have h1 := l2_self_nonneg w
  have h2 := l2_self_nonneg (proj u a)
  have : 0 ≤ κ * l2 w w * l2 (proj u a) (proj u a) := by positivity
  linarith

end MetriplecticTetherModel
