/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

module

public import Mathlib.Analysis.Fourier.AddCircleMulti
public import Mathlib.Analysis.ODE.PicardLindelof
public import Mathlib.Analysis.ODE.Gronwall
public import Mathlib.Analysis.Calculus.ContDiff.RCLike

/-!
# Galerkin truncation of the incompressible Navier–Stokes equations on `𝕋ᵈ`

Let `𝕋ᵈ = UnitAddTorus d` and let `K` be a finite set of wavevectors `n : d → ℤ`.
A velocity field in the span of the Fourier modes in `K` is
`u(x) = ∑ n ∈ K, û n • mFourier n x`, where `mFourier n x = exp (2πi n · x)`.
The Galerkin truncation of the Navier–Stokes equations
`∂ₜu + (u · ∇)u + ∇p = ν Δu`, `div u = 0`
is the system of ordinary differential equations for the coefficients `û n : d → ℂ`,
`n ∈ K`,
`dû n / dt = -4π²ν|n|² û n - P(n) (∑_{m + l = n, m, l ∈ K} 2πi (û m · l) û l)`,
where `P(n) v = v - (n · v / |n|²) n` is the Fourier symbol of the Leray projector,
which removes the pressure gradient. This is an ordinary differential equation with a
polynomial right-hand side on the finite-dimensional space `K → d → ℂ`.

## Main definitions

* `NavierStokes.Galerkin.wavevectorNormSq n`: the squared Euclidean length `|n|²`.
* `NavierStokes.Galerkin.lerayProj n v`: the Leray projector `P(n) v` at frequency `n`.
* `NavierStokes.Galerkin.convection K a n`: the `n`-th Fourier coefficient of `(u · ∇)u`
  for `u = ∑ m ∈ K, a m • mFourier m`, keeping only interactions of modes in `K`.
* `NavierStokes.Galerkin.vectorField ν K`: the right-hand side of the Galerkin system.
* `NavierStokes.Galerkin.velocity K a`: the velocity field `∑ n ∈ K, a n • mFourier n` on `𝕋ᵈ`.

## Main statements

* `NavierStokes.Galerkin.contDiff_vectorField`: the right-hand side is `C^∞`.
* `NavierStokes.Galerkin.exists_hasDerivAt`: local existence (Picard–Lindelöf).
* `NavierStokes.Galerkin.eqOn_Icc_of_hasDerivWithinAt`: uniqueness on any compact interval.
* `NavierStokes.Galerkin.dotProduct_lerayProj`: the image of `P(n)` is divergence-free,
  `n · P(n) v = 0`.

## References

* [P. Constantin and C. Foias, *Navier–Stokes Equations*][constantin_foias_1988], Chapter 7.
* [R. Temam, *Navier–Stokes Equations: Theory and Numerical Analysis*][temam_1977],
  Chapter III, §3.
* [A. Majda and A. Bertozzi, *Vorticity and Incompressible Flow*][majda_bertozzi_2002],
  Chapter 3.
-/

@[expose] public section

noncomputable section

open Complex Set Metric
open scoped Real

namespace NavierStokes.Galerkin

variable {d : Type*} [Fintype d]

/-- The squared Euclidean length `|n|² = ∑ i, nᵢ²` of a wavevector `n : d → ℤ`. -/
def wavevectorNormSq (n : d → ℤ) : ℝ := ∑ i, (n i : ℝ) ^ 2

lemma wavevectorNormSq_nonneg (n : d → ℤ) : 0 ≤ wavevectorNormSq n :=
  Finset.sum_nonneg fun _ _ ↦ sq_nonneg _

lemma wavevectorNormSq_eq_zero_iff (n : d → ℤ) : wavevectorNormSq n = 0 ↔ n = 0 := by
  rw [wavevectorNormSq, Finset.sum_eq_zero_iff_of_nonneg fun _ _ ↦ sq_nonneg _, funext_iff]
  simp

/-- The Fourier symbol of the Leray (Helmholtz) projector at frequency `n`:
`P(n) v = v - (n · v / |n|²) n`. For `n = 0` this is the identity. -/
def lerayProj (n : d → ℤ) (v : d → ℂ) : d → ℂ :=
  fun i ↦ v i - (∑ j, (n j : ℂ) * v j) / (wavevectorNormSq n : ℂ) * n i

/-- The Leray projector maps into divergence-free vectors: `n · P(n) v = 0`. -/
theorem dotProduct_lerayProj (n : d → ℤ) (v : d → ℂ) :
    ∑ i, (n i : ℂ) * lerayProj n v i = 0 := by
  by_cases hn : n = 0
  · simp [hn]
  have h : (wavevectorNormSq n : ℂ) ≠ 0 := by
    exact_mod_cast (wavevectorNormSq_eq_zero_iff n).not.mpr hn
  have hsq : (wavevectorNormSq n : ℂ) = ∑ i, (n i : ℂ) * n i := by
    simp [wavevectorNormSq, sq]
  simp only [lerayProj, mul_sub, Finset.sum_sub_distrib]
  have : ∑ i, (n i : ℂ) * ((∑ j, (n j : ℂ) * v j) / (wavevectorNormSq n : ℂ) * n i) =
      (∑ j, (n j : ℂ) * v j) / (wavevectorNormSq n : ℂ) * ∑ i, (n i : ℂ) * n i := by
    rw [Finset.mul_sum]
    exact Finset.sum_congr rfl fun i _ ↦ by ring
  rw [this, ← hsq, div_mul_cancel₀ _ h, sub_self]

/-- The Leray projector fixes divergence-free vectors. -/
theorem lerayProj_of_dotProduct_eq_zero {n : d → ℤ} {v : d → ℂ}
    (hv : ∑ j, (n j : ℂ) * v j = 0) : lerayProj n v = v := by
  ext i
  simp [lerayProj, hv]

/-- The `n`-th Fourier coefficient of the convection term `(u · ∇)u` for the velocity field
`u = ∑ m ∈ K, a m • mFourier m`, keeping only the triads `m + l = n` with `m, l ∈ K`:
`∑_{m + l = n} 2πi (a m · l) a l`. -/
def convection (K : Finset (d → ℤ)) (a : K → d → ℂ) (n : d → ℤ) : d → ℂ :=
  fun i ↦ ∑ m : K, ∑ l : K,
    (if (m : d → ℤ) + l = n then (1 : ℂ) else 0) *
      (2 * π * I * (∑ j, a m j * ((l : d → ℤ) j : ℂ)) * a l i)

/-- The right-hand side of the Galerkin system for the incompressible Navier–Stokes equations
with viscosity `ν` on the modes `K`:
`a n ↦ -4π²ν|n|² a n - P(n) (convection K a n)`. -/
def vectorField (ν : ℝ) (K : Finset (d → ℤ)) (a : K → d → ℂ) : K → d → ℂ :=
  fun n i ↦ -((4 * π ^ 2 * ν * wavevectorNormSq (n : d → ℤ) : ℝ) : ℂ) * a n i -
    lerayProj n (convection K a n) i

/-- The velocity field `u = ∑ n ∈ K, a n • mFourier n` on `𝕋ᵈ` with Fourier coefficients `a`. -/
def velocity (K : Finset (d → ℤ)) (a : K → d → ℂ) : UnitAddTorus d → d → ℂ :=
  fun x i ↦ ∑ n : K, a n i * UnitAddTorus.mFourier (n : d → ℤ) x

variable (ν : ℝ) (K : Finset (d → ℤ))

/-- The convection coefficient depends smoothly on the Galerkin coefficients. -/
theorem contDiff_convection (n : d → ℤ) :
    ContDiff ℝ ⊤ (fun a : K → d → ℂ ↦ convection K a n) := by
  refine contDiff_pi.2 fun i ↦ ?_
  unfold convection
  refine ContDiff.sum fun m _ ↦ ContDiff.sum fun l _ ↦ ?_
  refine contDiff_const.mul ?_
  have hm : ∀ j, ContDiff ℝ ⊤ (fun a : K → d → ℂ ↦ a m j) := fun j ↦
    (contDiff_apply ℝ ℂ j).comp (contDiff_apply ℝ (d → ℂ) m)
  have hl : ContDiff ℝ ⊤ (fun a : K → d → ℂ ↦ a l i) :=
    (contDiff_apply ℝ ℂ i).comp (contDiff_apply ℝ (d → ℂ) l)
  exact (contDiff_const.mul (ContDiff.sum fun j _ ↦ (hm j).mul contDiff_const)).mul hl

/-- The right-hand side of the Galerkin system is smooth. -/
theorem contDiff_vectorField : ContDiff ℝ ⊤ (vectorField (d := d) ν K) := by
  refine contDiff_pi.2 fun n ↦ contDiff_pi.2 fun i ↦ ?_
  unfold vectorField lerayProj
  have hc : ∀ i, ContDiff ℝ ⊤ (fun a : K → d → ℂ ↦ convection K a n i) := fun i ↦
    (contDiff_apply ℝ ℂ i).comp (contDiff_convection K n)
  have ha : ContDiff ℝ ⊤ (fun a : K → d → ℂ ↦ a n i) :=
    (contDiff_apply ℝ ℂ i).comp (contDiff_apply ℝ (d → ℂ) n)
  exact (contDiff_const.mul ha).sub ((hc i).sub
    (((ContDiff.sum fun j _ ↦ contDiff_const.mul (hc j)).div_const _).mul contDiff_const))

/-- **Local existence for the Galerkin–Navier–Stokes system** (Picard–Lindelöf): for every
initial datum `a₀` and initial time `t₀` there is `ε > 0` and a solution `a` of
`da/dt = vectorField ν K a` on `(t₀ - ε, t₀ + ε)` with `a t₀ = a₀`. -/
theorem exists_hasDerivAt (a₀ : K → d → ℂ) (t₀ : ℝ) :
    ∃ ε > (0 : ℝ), ∃ a : ℝ → K → d → ℂ, a t₀ = a₀ ∧
      ∀ t ∈ Ioo (t₀ - ε) (t₀ + ε), HasDerivAt a (vectorField ν K (a t)) t := by
  obtain ⟨a, ha₀, ε, hε, ha⟩ :=
    ContDiffAt.exists_forall_mem_closedBall_exists_eq_forall_mem_Ioo_hasDerivAt₀
      ((contDiff_vectorField ν K).contDiffAt.of_le le_top) t₀
  exact ⟨ε, hε, a, ha₀, ha⟩

/-- **Uniqueness for the Galerkin–Navier–Stokes system**: two solutions on `[t₀, T]` that agree
at `t₀` agree on `[t₀, T]`. -/
theorem eqOn_Icc_of_hasDerivWithinAt {t₀ T : ℝ} {a b : ℝ → K → d → ℂ}
    (ha : ContinuousOn a (Icc t₀ T))
    (ha' : ∀ t ∈ Ico t₀ T, HasDerivWithinAt a (vectorField ν K (a t)) (Ici t) t)
    (hb : ContinuousOn b (Icc t₀ T))
    (hb' : ∀ t ∈ Ico t₀ T, HasDerivWithinAt b (vectorField ν K (b t)) (Ici t) t)
    (h₀ : a t₀ = b t₀) :
    EqOn a b (Icc t₀ T) := by
  obtain ⟨Ra, hRa⟩ := isCompact_Icc.exists_bound_of_continuousOn ha
  obtain ⟨Rb, hRb⟩ := isCompact_Icc.exists_bound_of_continuousOn hb
  set R := max Ra Rb
  obtain ⟨L, hL⟩ :=
    ((contDiff_vectorField ν K).contDiffOn (s := closedBall 0 R)).exists_lipschitzOnWith
      (by simp) (convex_closedBall 0 R) (isCompact_closedBall 0 R)
  refine ODE_solution_unique_of_mem_Icc_right (s := fun _ ↦ closedBall 0 R) (K := L)
    (fun _ _ ↦ hL) ha ha' (fun t ht ↦ ?_) hb hb' (fun t ht ↦ ?_) h₀
  · exact mem_closedBall_zero_iff.2 ((hRa t (Ico_subset_Icc_self ht)).trans (le_max_left _ _))
  · exact mem_closedBall_zero_iff.2 ((hRb t (Ico_subset_Icc_self ht)).trans (le_max_right _ _))

end NavierStokes.Galerkin
