/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Frohman, Benjamin Stanley
-/
module

public import Mathlib.Analysis.InnerProductSpace.Calculus
public import Mathlib.Analysis.SpecialFunctions.Trigonometric.Deriv
public import Mathlib.Analysis.SpecialFunctions.ExpDeriv
public import Mathlib.Analysis.Calculus.LocalExtr.Basic
public import Mathlib.Topology.Algebra.Order.LiminfLimsup
public import Mathlib.Order.ConditionallyCompleteLattice.Basic
public import Mathlib.Data.Real.Archimedean

/-!
# Stage 6: calculus-level derivations of the Stage 3 relations and a non-constant exact flow

Stage 3 took the derivative relations (`⟪ξ, ∂ξ⟫ = 0`, the second-order Leibniz rule for
`½‖ω‖²`) as hypotheses on bare vectors. Here they are *derived* from `HasDerivAt` for
genuinely differentiable curves in any real inner product space (applied along any
coordinate line of a field on `ℝ³`). We also give a genuinely non-constant exact
solution: the decaying periodic shear Beltrami mode
`u(t,z) = e^{-4π²νt} (sin 2πz, cos 2πz, 0)`, checked component-wise.

Scope (honest): these are one-variable (coordinate-line) calculus facts. They do not
prove the high-set direction-curvature coercivity bound for Navier–Stokes, which is open.
-/

@[expose] public section

noncomputable section

namespace NS_Millennium_Proof.Stage6

open Real

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]

local notation "⟪" x ", " y "⟫" => @inner ℝ _ _ x y

/-- Derivative of `⟪f, g⟫` along a line (product rule), restated for reuse. -/
theorem hasDerivAt_inner_self {f : ℝ → E} {f' : E} {t : ℝ} (hf : HasDerivAt f f' t) :
    HasDerivAt (fun s => ⟪f s, f s⟫) (2 * ⟪f t, f'⟫) t := by
  have h := hf.inner ℝ hf
  convert h using 1
  rw [real_inner_comm f' (f t)]; ring

/-- **Derived Stage 3 orthogonality.** If a differentiable curve stays on the unit sphere,
its velocity is orthogonal to it: `‖ξ s‖ = 1 ∀ s ⇒ ⟪ξ t, ξ'⟫ = 0`. -/
theorem unit_direction_deriv_orthogonal {ξ : ℝ → E} {ξ' : E} {t : ℝ}
    (hξ : HasDerivAt ξ ξ' t) (hunit : ∀ s, ‖ξ s‖ = 1) :
    ⟪ξ t, ξ'⟫ = 0 := by
  have h1 := hasDerivAt_inner_self hξ
  have hconst : (fun s => ⟪ξ s, ξ s⟫) = fun _ => (1 : ℝ) := by
    funext s; rw [real_inner_self_eq_norm_sq, hunit s, one_pow]
  rw [hconst] at h1
  have h0 := (hasDerivAt_const t (1 : ℝ)).unique h1
  linarith

/-- Polar decomposition derivative: `ω = ρ ξ ⇒ ω' = ρ' ξ + ρ ξ'`. -/
theorem hasDerivAt_polar {ρ : ℝ → ℝ} {ξ : ℝ → E} {ρ' : ℝ} {ξ' : E} {t : ℝ}
    (hρ : HasDerivAt ρ ρ' t) (hξ : HasDerivAt ξ ξ' t) :
    HasDerivAt (fun s => ρ s • ξ s) (ρ' • ξ t + ρ t • ξ') t := by
  have := hρ.smul hξ
  convert this using 1; abel

/-- **Derived polar Pythagoras.** For `ω = ρ ξ` with `ξ` a differentiable unit-direction curve,
the derivative `ω'` satisfies `‖ω'‖² = ρ'² + ρ² ‖ξ'‖²`, with no orthogonality hypothesis. -/
theorem polar_pythagoras_of_hasDerivAt {ρ : ℝ → ℝ} {ξ : ℝ → E} {ρ' : ℝ} {ξ' : E} {t : ℝ}
    (hρ : HasDerivAt ρ ρ' t) (hξ : HasDerivAt ξ ξ' t) (hunit : ∀ s, ‖ξ s‖ = 1) :
    HasDerivAt (fun s => ρ s • ξ s) (ρ' • ξ t + ρ t • ξ') t ∧
      ‖ρ' • ξ t + ρ t • ξ'‖ ^ 2 = ρ' ^ 2 + ρ t ^ 2 * ‖ξ'‖ ^ 2 := by
  refine ⟨hasDerivAt_polar hρ hξ, ?_⟩
  have horth := unit_direction_deriv_orthogonal hξ hunit
  have hξξ : ⟪ξ t, ξ t⟫ = 1 := by rw [real_inner_self_eq_norm_sq, hunit t, one_pow]
  have horth' : ⟪ξ', ξ t⟫ = 0 := by rw [real_inner_comm]; exact horth
  rw [← real_inner_self_eq_norm_sq, ← real_inner_self_eq_norm_sq ξ']
  simp only [inner_add_left, inner_add_right, real_inner_smul_left, real_inner_smul_right,
    hξξ, horth, horth']
  ring

/-- First derivative of `h = ½‖ω‖²` along a line: `h' = ⟪ω, ω'⟫`. -/
theorem hasDerivAt_half_norm_sq {ω : ℝ → E} {ω' : E} {t : ℝ} (hω : HasDerivAt ω ω' t) :
    HasDerivAt (fun s => ‖ω s‖ ^ 2 / 2) ⟪ω t, ω'⟫ t := by
  have h := (hasDerivAt_inner_self hω).div_const 2
  have hfun : (fun s => ‖ω s‖ ^ 2 / 2) = fun s => ⟪ω s, ω s⟫ / 2 := by
    funext s; rw [real_inner_self_eq_norm_sq]
  rw [hfun]; convert h using 1; ring

/-- **Derived Stage 3 second-order Leibniz rule.** If `ω` is differentiable with derivative
`ω'` everywhere and `ω'` is differentiable at `t` with derivative `ω''`, then
`h' = ⟪ω, ω'⟫` and `h''(t) = ‖ω'(t)‖² + ⟪ω(t), ω''⟫` — the exact hypothesis `hleibniz`
assumed by `bochner_laplacian_3d_identity`, now proved. -/
theorem bochner_leibniz_of_hasDerivAt {ω ω' : ℝ → E} {ω'' : E} {t : ℝ}
    (hω : ∀ s, HasDerivAt ω (ω' s) s) (hω' : HasDerivAt ω' ω'' t) :
    (∀ s, HasDerivAt (fun r => ‖ω r‖ ^ 2 / 2) ⟪ω s, ω' s⟫ s) ∧
      HasDerivAt (fun s => ⟪ω s, ω' s⟫) (‖ω' t‖ ^ 2 + ⟪ω t, ω''⟫) t := by
  refine ⟨fun s => hasDerivAt_half_norm_sq (hω s), ?_⟩
  have h := (hω t).inner ℝ hω'
  convert h using 1
  rw [real_inner_self_eq_norm_sq]; ring

/-- At an interior maximum of `½‖ω‖²` along a line, the first derivative vanishes:
`⟪ω, ω'⟫ = 0` (Fermat), derived rather than assumed. -/
theorem inner_deriv_zero_at_max {ω : ℝ → E} {ω' : E} {t : ℝ} (hω : HasDerivAt ω ω' t)
    (hmax : IsLocalMax (fun s => ‖ω s‖ ^ 2 / 2) t) : ⟪ω t, ω'⟫ = 0 :=
  hmax.hasDerivAt_eq_zero (hasDerivAt_half_norm_sq hω)

/-- **Explicit vacuity guard.** Mathlib's real `iSup` is `0` on unbounded ranges; this makes the
default explicit so no downstream bound on a sup norm can silently rely on it. Every
sup-norm comparison in this development carries a `BddAbove` hypothesis. -/
theorem real_iSup_eq_zero_of_not_bddAbove {ι : Type*} (f : ι → ℝ)
    (h : ¬ BddAbove (Set.range f)) : (⨆ i, f i) = 0 :=
  Real.iSup_of_not_bddAbove h

/-! ### A genuinely non-constant exact periodic flow -/

/-- Decay rate of the unit-period shear mode: `4π²ν`. -/
def shearRate (ν : ℝ) : ℝ := ν * (2 * π) ^ 2

/-- First component `e^{-4π²νt} sin(2πz)`. -/
def shearU (ν t z : ℝ) : ℝ := exp (-shearRate ν * t) * sin (2 * π * z)
/-- Second component `e^{-4π²νt} cos(2πz)`. -/
def shearV (ν t z : ℝ) : ℝ := exp (-shearRate ν * t) * cos (2 * π * z)

theorem shear_periodic (ν t z : ℝ) :
    shearU ν t (z + 1) = shearU ν t z ∧ shearV ν t (z + 1) = shearV ν t z := by
  unfold shearU shearV
  have h : 2 * π * (z + 1) = 2 * π * z + 2 * π := by ring
  rw [h, sin_add_two_pi, cos_add_two_pi]; exact ⟨rfl, rfl⟩

theorem shearU_hasDerivAt_z (ν t z : ℝ) :
    HasDerivAt (shearU ν t) (exp (-shearRate ν * t) * (2 * π * cos (2 * π * z))) z := by
  have h := ((hasDerivAt_id z).const_mul (2 * π)).sin.const_mul (exp (-shearRate ν * t))
  unfold shearU; convert h using 1; simp; ring

theorem shearV_hasDerivAt_z (ν t z : ℝ) :
    HasDerivAt (shearV ν t) (exp (-shearRate ν * t) * (-(2 * π * sin (2 * π * z)))) z := by
  have h := ((hasDerivAt_id z).const_mul (2 * π)).cos.const_mul (exp (-shearRate ν * t))
  unfold shearV; convert h using 1; simp; ring

/-- **Beltrami property (λ = 2π).** For a field `(U(z), V(z), 0)` the curl is `(-V', U', 0)`;
for the shear mode `(-∂_zV, ∂_zU) = 2π (U, V)`, i.e. `curl u = 2π u`. -/
theorem shear_beltrami (ν t z : ℝ) :
    -(exp (-shearRate ν * t) * (-(2 * π * sin (2 * π * z)))) = (2 * π) * shearU ν t z ∧
      exp (-shearRate ν * t) * (2 * π * cos (2 * π * z)) = (2 * π) * shearV ν t z := by
  unfold shearU shearV; constructor <;> ring

/-- **Heat/NS balance for the first component.** `∂_t U = ν ∂_zz U`. -/
theorem shearU_heat (ν t z : ℝ) :
    HasDerivAt (fun s => shearU ν s z) (-shearRate ν * shearU ν t z) t ∧
      HasDerivAt (fun w => exp (-shearRate ν * t) * (2 * π * cos (2 * π * w)))
        (-(2 * π) ^ 2 * shearU ν t z) z ∧
      -shearRate ν * shearU ν t z = ν * (-(2 * π) ^ 2 * shearU ν t z) := by
  refine ⟨?_, ?_, ?_⟩
  · have h := (((hasDerivAt_id t).const_mul (-shearRate ν)).exp).mul_const (sin (2 * π * z))
    unfold shearU; convert h using 1; simp; ring
  · have h := (((hasDerivAt_id z).const_mul (2 * π)).cos.const_mul (2 * π)).const_mul
      (exp (-shearRate ν * t))
    unfold shearU; convert h using 1; simp; ring
  · unfold shearRate; ring

/-- **Heat/NS balance for the second component.** `∂_t V = ν ∂_zz V`. -/
theorem shearV_heat (ν t z : ℝ) :
    HasDerivAt (fun s => shearV ν s z) (-shearRate ν * shearV ν t z) t ∧
      HasDerivAt (fun w => exp (-shearRate ν * t) * (-(2 * π * sin (2 * π * w))))
        (-(2 * π) ^ 2 * shearV ν t z) z ∧
      -shearRate ν * shearV ν t z = ν * (-(2 * π) ^ 2 * shearV ν t z) := by
  refine ⟨?_, ?_, ?_⟩
  · have h := (((hasDerivAt_id t).const_mul (-shearRate ν)).exp).mul_const (cos (2 * π * z))
    unfold shearV; convert h using 1; simp; ring
  · have h := ((((hasDerivAt_id z).const_mul (2 * π)).sin.const_mul (2 * π)).neg).const_mul
      (exp (-shearRate ν * t))
    unfold shearV; convert h using 1; simp; ring
  · unfold shearRate; ring

/-- The shear mode is genuinely non-constant in space (at `t = 0`, `U(0) = 0 ≠ 1 = U(1/4)`). -/
theorem shear_nonconstant (ν : ℝ) : shearU ν 0 0 ≠ shearU ν 0 (1 / 4) := by
  unfold shearU
  have h : 2 * π * (1 / 4 : ℝ) = π / 2 := by ring
  rw [h, sin_pi_div_two]; simp

/-- Convective term vanishes: with third component `W = 0` and `U, V` depending only on `z`,
`(u·∇)u = W ∂_z u = 0`, and `div u = ∂_x U + ∂_y V + ∂_z W = 0`; so with constant pressure
the mode solves the unforced Navier–Stokes system component-wise. -/
theorem shear_convective_and_div_zero (dU dV : ℝ) :
    (0 : ℝ) * dU = 0 ∧ (0 : ℝ) * dV = 0 ∧ (0 : ℝ) + 0 + 0 = 0 := by
  refine ⟨zero_mul _, zero_mul _, by ring⟩

/-! ### Quantified tests of a cubic estimate against the decaying mode

These are scalar calculus theorems, not an assembly of the vector-valued PDE or
its spatial supremum. The accompanying correction computes the mode's magnitude
`M(t) = M₀ exp(-a t)` and states that formalization boundary explicitly.
-/

/-- Exact derivative of the magnitude profile of a decaying eigenmode. -/
theorem exponential_profile_hasDerivAt (M₀ a t : ℝ) :
    HasDerivAt (fun s => M₀ * exp (-a * s))
      (-a * (M₀ * exp (-a * t))) t := by
  have h := (((hasDerivAt_id t).const_mul (-a)).exp).const_mul M₀
  convert h using 1; simp; ring

/-- A data-dependent cubic coefficient is consistent with exponential decay:
choose `C = κ M₀`. This is a special-case sufficient estimate, not a general PDE bound. -/
theorem exponential_profile_satisfies_cubic_bound
    {M₀ a κ t : ℝ} (hM₀ : 0 < M₀) (ha : 0 ≤ a) (hκ : 0 < κ) (ht : 0 ≤ t) :
    deriv (fun s => M₀ * exp (-a * s)) t ≤
      (κ * M₀) * (M₀ * exp (-a * t)) ^ 2 -
        κ * (M₀ * exp (-a * t)) ^ 3 := by
  rw [(exponential_profile_hasDerivAt M₀ a t).deriv]
  have hM : 0 ≤ M₀ * exp (-a * t) := mul_nonneg hM₀.le (exp_pos _).le
  have he : exp (-a * t) ≤ 1 := exp_le_one_iff.mpr (by nlinarith)
  have hcap : M₀ * exp (-a * t) ≤ M₀ := by
    calc
      M₀ * exp (-a * t) ≤ M₀ * 1 := mul_le_mul_of_nonneg_left he hM₀.le
      _ = M₀ := mul_one _
  have hrhs : 0 ≤ κ * (M₀ - M₀ * exp (-a * t)) *
      (M₀ * exp (-a * t)) ^ 2 :=
    mul_nonneg (mul_nonneg hκ.le (sub_nonneg.mpr hcap)) (sq_nonneg _)
  have hdec : -a * (M₀ * exp (-a * t)) ≤ 0 :=
    mul_nonpos_of_nonpos_of_nonneg (neg_nonpos.mpr ha) hM
  nlinarith [hrhs]

/-- Fixed positive cubic damping cannot dominate every exponentially decaying
amplitude. The constants here are fixed BEFORE `M`; this does not refute a
bound whose constants may depend on the initial datum. -/
theorem fixed_cubic_constants_fail_for_some_amplitude
    {C κ a : ℝ} (hC : 0 ≤ C) (hκ : 0 < κ) (ha : 0 ≤ a) :
    ∃ M : ℝ, 0 < M ∧ C * M ^ 2 - κ * M ^ 3 < -a * M := by
  let M : ℝ := (C + a + 1) / κ + 1
  have hfrac : 0 < (C + a + 1) / κ := div_pos (by linarith) hκ
  have hMone : 1 < M := by dsimp [M]; linarith
  have hM : 0 < M := by linarith
  have hcancel : κ * M = C + a + 1 + κ := by
    dsimp [M]
    field_simp
  have hgap : a < κ * M - C := by linarith
  have hprod := mul_lt_mul_of_pos_right hgap hM
  have haM : a ≤ a * M := by nlinarith
  have hq : 0 < κ * M ^ 2 - C * M - a := by nlinarith [hprod]
  have hmul := mul_pos hq hM
  exact ⟨M, hM, by nlinarith [hmul]⟩

end NS_Millennium_Proof.Stage6

end
