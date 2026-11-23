import FrohmanianTether.ArnoldGeometric
import Mathlib.Analysis.SpecialFunctions.SmoothTransition
import Mathlib.Analysis.InnerProductSpace.Calculus

open MeasureTheory NavierStokes3D ArnoldGeometric
noncomputable section
namespace RFTest

def eb (i : Fin 3) : T3 := EuclideanSpace.single i 1

def rotL : T3 →L[ℝ] T3 :=
  (-(EuclideanSpace.proj (1 : Fin 3) : T3 →L[ℝ] ℝ)).smulRight (eb 0) +
    (EuclideanSpace.proj (0 : Fin 3) : T3 →L[ℝ] ℝ).smulRight (eb 1)

theorem rotL_apply (v : T3) : rotL v = (-(v 1)) • eb 0 + (v 0) • eb 1 := by
  simp [rotL]

theorem rotL_coord (v : T3) (i : Fin 3) :
    rotL v i = if i = 0 then -(v 1) else if i = 1 then v 0 else 0 := by
  rw [rotL_apply]
  fin_cases i <;> simp [eb, PiLp.single_apply]

def bump (s : ℝ) : ℝ := Real.smoothTransition (1 - s)

def rotField (c : T3) (y : T3) : EuclideanSpace ℝ (Fin 3) :=
  bump (‖y - c‖ ^ 2) • rotL (y - c)

theorem bump_contDiff : ContDiff ℝ (⊤ : ℕ∞) bump :=
  Real.smoothTransition.contDiff.comp (contDiff_const.sub contDiff_id)

theorem rotField_contDiff (c : T3) : ContDiff ℝ (⊤ : ℕ∞) (rotField c) := by
  unfold rotField
  exact (bump_contDiff.comp ((contDiff_id.sub contDiff_const).norm_sq ℝ)).smul
    (rotL.contDiff.comp (contDiff_id.sub contDiff_const))

theorem hasFDerivAt_rotField_coord (c x : T3) (i : Fin 3) :
    HasFDerivAt (fun y => rotField c y i)
      (bump (‖x - c‖ ^ 2) • ((EuclideanSpace.proj i : T3 →L[ℝ] ℝ).comp rotL) +
        rotL (x - c) i • (deriv bump (‖x - c‖ ^ 2) •
          (2 • (innerSL ℝ (x - c)).comp (ContinuousLinearMap.id ℝ T3)))) x := by
  have hg : HasFDerivAt (fun y : T3 => ‖y - c‖ ^ 2)
      (2 • (innerSL ℝ (x - c)).comp (ContinuousLinearMap.id ℝ T3)) x :=
    ((hasFDerivAt_id x).sub_const c).norm_sq
  have hb : HasFDerivAt (fun y : T3 => bump (‖y - c‖ ^ 2))
      (deriv bump (‖x - c‖ ^ 2) • (2 • (innerSL ℝ (x - c)).comp (ContinuousLinearMap.id ℝ T3))) x := by
    have hd : HasDerivAt bump (deriv bump (‖x - c‖ ^ 2)) (‖x - c‖ ^ 2) :=
      (bump_contDiff.differentiable (by simp) _).hasDerivAt
    have h := HasDerivAt.comp_hasFDerivAt (h₂ := bump) x hd hg
    exact h
  have hl : HasFDerivAt (fun y : T3 => rotL (y - c) i)
      ((EuclideanSpace.proj i : T3 →L[ℝ] ℝ).comp rotL) x := by
    have : (fun y : T3 => rotL (y - c) i) =
        fun y => ((EuclideanSpace.proj i : T3 →L[ℝ] ℝ).comp rotL) y -
          ((EuclideanSpace.proj i : T3 →L[ℝ] ℝ).comp rotL) c := by
      funext y; simp [map_sub]
    rw [this]
    exact (ContinuousLinearMap.hasFDerivAt _).sub_const _
  have := hb.mul hl
  have he : (fun y => rotField c y i) = fun y => bump (‖y - c‖ ^ 2) * rotL (y - c) i := by
    funext y; simp [rotField]
  rw [he]
  convert this using 1

theorem inner_eb (v : T3) (i : Fin 3) : inner ℝ v (EuclideanSpace.single i (1:ℝ)) = v i := by
  simp [PiLp.inner_apply, PiLp.single_apply, real_inner_eq_re_inner]

theorem div_rotField (c x : T3) : NavierStokes3D.div (rotField c) x = 0 := by
  unfold NavierStokes3D.div
  simp only [(hasFDerivAt_rotField_coord c x _).fderiv]
  simp [Fin.sum_univ_three, rotL_coord, PiLp.single_apply, inner_sub_left, inner_eb]
  ring

def rotOrbit (c : T3) : CoadjointOrbit := ⟨rotField c, div_rotField c⟩

theorem rotField_eq_zero_of_far (c y : T3) (h : 1 ≤ ‖y - c‖) : rotField c y = 0 := by
  unfold rotField bump
  rw [Real.smoothTransition.zero_of_nonpos, zero_smul]
  nlinarith

theorem rotField_hasCompactSupport (c : T3) : HasCompactSupport (rotField c) := by
  apply HasCompactSupport.intro (isCompact_closedBall c 1)
  intro y hy
  apply rotField_eq_zero_of_far
  simp only [Metric.mem_closedBall, dist_eq_norm, not_le] at hy
  exact hy.le

theorem rotField_ne_zero (c : T3) : rotField c (c + (1/2 : ℝ) • eb 0) ≠ 0 := by
  intro h
  have h1 := congrArg (fun v : EuclideanSpace ℝ (Fin 3) => v 1) h
  simp only [rotField, add_sub_cancel_left, PiLp.smul_apply, smul_eq_mul, PiLp.zero_apply] at h1
  rw [rotL_coord] at h1
  have hn : ‖(1/2 : ℝ) • eb 0‖ ^ 2 = 1/4 := by
    rw [norm_smul, eb, PiLp.norm_single]; norm_num
  rw [hn] at h1
  have hb : 0 < bump (1/4) := Real.smoothTransition.pos_of_pos (by norm_num)
  rcases mul_eq_zero.mp h1 with h1 | h1
  · exact hb.ne' h1
  · simp [eb] at h1

theorem integral_rotField_pos (c : T3) : 0 < ∫ x, ‖rotField c x‖ ^ 2 := by
  apply Continuous.integral_pos_of_hasCompactSupport_nonneg_nonzero (x := c + (1/2 : ℝ) • eb 0)
  · exact ((rotField_contDiff c).continuous.norm).pow 2
  · exact (rotField_hasCompactSupport c).mono (fun x hx h0 => hx (by simp [h0]))
  · intro x; positivity
  · simpa using rotField_ne_zero c

end RFTest
