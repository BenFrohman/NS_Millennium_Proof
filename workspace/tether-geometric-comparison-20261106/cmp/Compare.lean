import FTVerified.May.Jacobi
import FTVerified.May.JacobiWitness
import Mathlib.Analysis.InnerProductSpace.Calculus
/-! Scratch comparison lemmas (not part of any repo). Real Hilbert space `H`;
`tetheredBracketVec P κ w u a b = P a b + (-(κ w)⟪Π_u a,Π_u b⟫) • u` (FTVerified defs). -/
namespace Scratch
open Frohman.Tether
open scoped InnerProductSpace RealInnerProductSpace
variable {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℝ H]

/-- (1) Pairing identity for the frozen vector operation. -/
theorem pair_tethered (P : H → H → H) (κ w : ℝ) (u a b m : H) :
    ⟪m, tetheredBracketVec P κ w u a b⟫ =
      ⟪m, P a b⟫ + (-(κ * w) * ⟪piU u a, piU u b⟫) * ⟪m, u⟫ := by
  simp [tetheredBracketVec, tetherVec, frohmanianTether_apply, inner_add_right, inner_smul_right]

/-- Geometric-shaped scalar value at a frozen point: classical pairing − κ E ⟪Π a,Π b⟫. -/
noncomputable def geomVal (P : H → H → H) (κ E : ℝ) (u a b m : H) : ℝ :=
  ⟪m, P a b⟫ + (-(κ * E)) * ⟪piU u a, piU u b⟫

/-- (2) Exact matching condition. -/
theorem match_iff (P : H → H → H) (κ w E : ℝ) (u a b m : H) :
    ⟪m, tetheredBracketVec P κ w u a b⟫ = geomVal P κ E u a b m ↔
      κ * ⟪piU u a, piU u b⟫ * (w * ⟪m, u⟫ - E) = 0 := by
  rw [pair_tethered, geomVal]; constructor <;> intro h <;> linarith

/-- (3) If ⟪m,u⟫ ≠ 0 the parameter `w = E/⟪m,u⟫` matches (pointwise only). -/
theorem match_of_ne (P : H → H → H) (κ E : ℝ) (u a b m : H) (h : ⟪m, u⟫ ≠ 0) :
    ⟪m, tetheredBracketVec P κ (E / ⟪m, u⟫) u a b⟫ = geomVal P κ E u a b m := by
  rw [match_iff]; field_simp; ring

/-- (4) Obstruction: if ⟪m,u⟫ = 0 and κ E ⟪Πa,Πb⟫ ≠ 0, no `w` matches. -/
theorem no_match (P : H → H → H) (κ E : ℝ) (u a b m : H) (hmu : ⟪m, u⟫ = 0)
    (hk : κ ≠ 0) (hE : E ≠ 0) (hq : ⟪piU u a, piU u b⟫ ≠ 0) (w : ℝ) :
    ⟪m, tetheredBracketVec P κ w u a b⟫ ≠ geomVal P κ E u a b m := by
  intro h; rw [match_iff, hmu] at h; simp [hk, hE, hq] at h

/-- (5) State dependence: with `u` frozen and `E(m)=‖m‖²`, the geometric-shaped value of linear
functionals has derivative `⟪·, P a b⟫ − 2κq⟪m,·⟫`; the frozen one has constant derivative. -/
theorem hasFDeriv_geomVal (P : H → H → H) (κ : ℝ) (u a b m : H) :
    HasFDerivAt (fun m' => geomVal P κ (‖m'‖ ^ 2) u a b m')
      (innerSL ℝ (P a b) + (-(κ) * ⟪piU u a, piU u b⟫) • (2 • innerSL ℝ m)) m := by
  have h1 : HasFDerivAt (fun m' : H => ⟪m', P a b⟫) (innerSL ℝ (P a b)) m := by
    have := (innerSL ℝ (P a b)).hasFDerivAt (x := m)
    convert this using 1; funext m'; simp [real_inner_comm]
  have h2 := (hasStrictFDerivAt_norm_sq m).hasFDerivAt
  have h3 := h2.const_mul (-(κ) * ⟪piU u a, piU u b⟫)
  convert h1.add h3 using 1
  · funext m'; simp [geomVal]; ring

theorem hasFDeriv_frozen (P : H → H → H) (κ w : ℝ) (u a b m : H) :
    HasFDerivAt (fun m' => ⟪m', tetheredBracketVec P κ w u a b⟫)
      (innerSL ℝ (tetheredBracketVec P κ w u a b)) m := by
  have := (innerSL ℝ (tetheredBracketVec P κ w u a b)).hasFDerivAt (x := m)
  convert this using 1; funext m'; simp [real_inner_comm]

/-- (6) Gradient obstruction: if κq ≠ 0 and `m ∉ span u`, no `w` makes the two derivatives equal
(so no frozen parameter reproduces the geometric differential terms). -/
theorem grad_mismatch (P : H → H → H) (κ w : ℝ) (u a b m : H)
    (hkq : κ * ⟪piU u a, piU u b⟫ ≠ 0) (hm : ∀ t : ℝ, m ≠ t • u) :
    innerSL ℝ (tetheredBracketVec P κ w u a b) ≠
      innerSL ℝ (P a b) + (-(κ) * ⟪piU u a, piU u b⟫) • (2 • innerSL ℝ m) := by
  intro h
  have key : ∀ v : H, ⟪(-(κ * w) * ⟪piU u a, piU u b⟫) • u - (-(κ) * ⟪piU u a, piU u b⟫ * 2) • m, v⟫ = 0 := by
    intro v
    have := congrArg (fun L => L v) h
    simp [innerSL_apply, tetheredBracketVec, tetherVec, frohmanianTether_apply, inner_add_left,
      inner_smul_left] at this
    simp only [inner_sub_left, inner_smul_left, inner_neg_left, inner_add_left, conj_trivial] at *
    linear_combination (-1:ℝ) * this
  have h0 := inner_self_eq_zero.mp (key _)
  rw [sub_eq_zero] at h0
  apply hm ((-(κ * w) * ⟪piU u a, piU u b⟫) / (-(κ) * ⟪piU u a, piU u b⟫ * 2))
  have hc : (-(κ) * ⟪piU u a, piU u b⟫ * 2) ≠ 0 := by
    have : -(κ) * ⟪piU u a, piU u b⟫ * 2 = -2 * (κ * ⟪piU u a, piU u b⟫) := by ring
    rw [this]; exact mul_ne_zero (by norm_num) hkq
  rw [div_eq_inv_mul, mul_smul, h0, smul_smul, inv_mul_cancel₀ hc, one_smul]

/-! Nonvacuity in ℝ³ (`E3`, `u = e₁`, `m = a = b = e₂`). -/
open Frohman.Tether.JacobiWitness
theorem e2_e1 : ⟪e2, e1⟫ = 0 := by
  simp [e1, e2, PiLp.inner_apply, Fin.sum_univ_three]
theorem piU_e1_e2 : piU e1 e2 = e2 := by
  rw [piU, Submodule.starProjection_eq_self_iff, Submodule.mem_orthogonal_singleton_iff_inner_right]
  simp [e1, e2, PiLp.inner_apply, Fin.sum_univ_three]
theorem q_e2 : ⟪piU e1 e2, piU e1 e2⟫ = 1 := by
  rw [piU_e1_e2]; simp [e2, EuclideanSpace.inner_single_left]
theorem no_match_instance (w : ℝ) :
    ⟪e2, tetheredBracketVec crossBr (3/2) w e1 e2 e2⟫ ≠ geomVal crossBr (3/2) 1 e1 e2 e2 e2 :=
  no_match _ _ _ _ _ _ _ e2_e1 (by norm_num) one_ne_zero (by rw [q_e2]; exact one_ne_zero) w
theorem e2_not_span (t : ℝ) : e2 ≠ t • e1 := by
  intro h; have := congrArg (fun v : E3 => v 1) h; simp [e1, e2] at this
theorem grad_mismatch_instance (w : ℝ) :
    innerSL ℝ (tetheredBracketVec crossBr (3/2) w e1 e2 e2) ≠
      innerSL ℝ (crossBr e2 e2) + (-(3/2:ℝ) * ⟪piU e1 e2, piU e1 e2⟫) • (2 • innerSL ℝ e2) :=
  grad_mismatch _ _ _ _ _ _ _ (by rw [q_e2]; norm_num) e2_not_span
end Scratch
#print axioms Scratch.pair_tethered
#print axioms Scratch.match_of_ne
#print axioms Scratch.no_match
#print axioms Scratch.hasFDeriv_geomVal
#print axioms Scratch.hasFDeriv_frozen
#print axioms Scratch.grad_mismatch
#print axioms Scratch.no_match_instance
#print axioms Scratch.grad_mismatch_instance
