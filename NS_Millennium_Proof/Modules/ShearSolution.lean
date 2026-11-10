/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Author: Benjamin Stanley Frohman

# The decaying periodic shear as an actual solution (envelope-correction addendum)

`shearU A ν t x = A e^{-ν k² t} sin(k x₃) e₁` with `k = 2π`, pressure `0`.

Proved here, against the repository's own definitions (`IsPeriodicSmoothSolutionOn`,
`curl`, `laplacian`, `convective`, `div`, `vorticity_sup_norm`,
`CubicVorticityDifferentialBound`):

* `shear_isPeriodicSmoothSolutionOn`: it is a smooth `ℤ³`-periodic solution on every `[0,T)`.
* `shear_vorticity_sup_norm`: its vorticity sup-norm is exactly `k A e^{-ν k² t}` (`A > 0`).
* `shear_cubic_bound_data_dependent`: it satisfies `CubicVorticityDifferentialBound`
  with the DATA-DEPENDENT constant `C = κ · k A`.
* `shear_fixed_cubic_constants_fail`: for any FIXED `C ≥ 0`, `κ > 0` (and `ν ≥ 0`) some
  amplitude `A > 0` gives an actual solution violating the cubic bound already at `t = 0`.
* `shear_envelope_nonvacuous`: the conditional envelope theorem applies to a NONZERO
  actual solution.

This is one explicit solution family. It neither proves nor refutes any estimate for
general solutions, and it is not a statement about the Clay problem.
-/
import NS_Millennium_Proof.Modules.HighSetDepletionAndBKM
import NS_Millennium_Proof.Modules.Stage6Calculus

open NavierStokes3D FrohmanianTether.ClayStatements FrohmanianTether.HighSetDepletionAndBKM
open Real
open scoped ContDiff

namespace NS_Millennium_Proof.ShearSolution

noncomputable section

/-- The wavenumber `2π`. -/
def K : ℝ := 2 * π

/-- The first unit vector `e₁ = (1,0,0)`. -/
def e0 : EuclideanSpace ℝ (Fin 3) := EuclideanSpace.single 0 1

/-- A scalar profile of the third coordinate, times `e₁`. -/
def F (g : ℝ → ℝ) : VelocityField := fun x => g (x 2) • e0

/-- The decaying shear velocity. -/
def shearU (A ν : ℝ) : TimeDependentVelocity :=
  fun t => F (fun s => A * exp (-(ν * K ^ 2) * t) * sin (K * s))

/-- Zero pressure. -/
def zeroP : TimeDependentPressure := fun _ _ => 0

theorem K_pos : 0 < K := by unfold K; positivity

theorem e0_apply (i : Fin 3) : e0 i = if i = 0 then 1 else 0 := by
  simp [e0, PiLp.single_apply]

theorem single_apply_two (i : Fin 3) :
    (EuclideanSpace.single i (1 : ℝ) : T3) 2 = if i = 2 then 1 else 0 := by
  simp [PiLp.single_apply, eq_comm]

theorem hasFDerivAt_F {g g' : ℝ → ℝ} (hg : ∀ s, HasDerivAt g (g' s) s) (y : T3) :
    HasFDerivAt (F g) ((g' (y 2) • (EuclideanSpace.proj (2 : Fin 3) : T3 →L[ℝ] ℝ)).smulRight e0) y := by
  have h1 : HasFDerivAt (fun x : T3 => x 2) (EuclideanSpace.proj (2 : Fin 3) : T3 →L[ℝ] ℝ) y :=
    (EuclideanSpace.proj (2 : Fin 3) : T3 →L[ℝ] ℝ).hasFDerivAt
  have h2 : HasFDerivAt (fun x : T3 => g (x 2))
      (g' (y 2) • (EuclideanSpace.proj (2 : Fin 3) : T3 →L[ℝ] ℝ)) y :=
    (hg (y 2)).comp_hasFDerivAt y h1
  exact h2.smul_const e0

theorem fderiv_F_apply {g g' : ℝ → ℝ} (hg : ∀ s, HasDerivAt g (g' s) s) (y h : T3) :
    fderiv ℝ (F g) y h = (g' (y 2) * h 2) • e0 := by
  rw [(hasFDerivAt_F hg y).fderiv]
  simp [ContinuousLinearMap.smulRight_apply]

/-- Coordinate `i` of `F g` as a scalar function, and its derivative. -/
theorem hasFDerivAt_F_coord {g g' : ℝ → ℝ} (hg : ∀ s, HasDerivAt g (g' s) s) (i : Fin 3)
    (y : T3) :
    HasFDerivAt (fun x => F g x i)
      ((e0 i * g' (y 2)) • (EuclideanSpace.proj (2 : Fin 3) : T3 →L[ℝ] ℝ)) y := by
  have h1 : HasFDerivAt (fun x : T3 => x 2) (EuclideanSpace.proj (2 : Fin 3) : T3 →L[ℝ] ℝ) y :=
    (EuclideanSpace.proj (2 : Fin 3) : T3 →L[ℝ] ℝ).hasFDerivAt
  have h2 := ((hg (y 2)).comp_hasFDerivAt y h1).const_mul (e0 i)
  have hfun : (fun x => F g x i) = fun x => e0 i * g (x 2) := by
    funext x; simp [F, mul_comm]
  rw [hfun]
  convert h2 using 1
  rw [smul_smul]

theorem fderiv_F_coord_apply {g g' : ℝ → ℝ} (hg : ∀ s, HasDerivAt g (g' s) s) (i : Fin 3)
    (y h : T3) :
    fderiv ℝ (fun x => F g x i) y h = e0 i * g' (y 2) * h 2 := by
  rw [(hasFDerivAt_F_coord hg i y).fderiv]
  simp

theorem convective_F {g g' : ℝ → ℝ} (hg : ∀ s, HasDerivAt g (g' s) s) (x : T3) :
    convective (F g) (F g) x = 0 := by
  simp only [convective]
  rw [fderiv_F_apply hg]
  simp [F, e0]

theorem div_F {g g' : ℝ → ℝ} (hg : ∀ s, HasDerivAt g (g' s) s) (x : T3) :
    div (F g) x = 0 := by
  simp only [div]
  simp [fderiv_F_coord_apply hg, Fin.sum_univ_three, e0_apply, single_apply_two]

theorem laplacian_F {g g' g'' : ℝ → ℝ} (hg : ∀ s, HasDerivAt g (g' s) s)
    (hg' : ∀ s, HasDerivAt g' (g'' s) s) (x : T3) :
    laplacian (F g) x = g'' (x 2) • e0 := by
  simp only [laplacian]
  have hinner : ∀ i : Fin 3, (fun y => fderiv ℝ (F g) y (EuclideanSpace.single i 1)) =
      F (fun s => g' s * (EuclideanSpace.single i (1 : ℝ) : T3) 2) := by
    intro i; funext y; rw [fderiv_F_apply hg]; rfl
  have hd : ∀ i : Fin 3, ∀ s, HasDerivAt (fun s => g' s * (EuclideanSpace.single i (1 : ℝ) : T3) 2)
      (g'' s * (EuclideanSpace.single i (1 : ℝ) : T3) 2) s :=
    fun i s => (hg' s).mul_const _
  simp only [hinner, fderiv_F_apply (hd _)]
  simp [Fin.sum_univ_three, single_apply_two]

theorem curl_F {g g' : ℝ → ℝ} (hg : ∀ s, HasDerivAt g (g' s) s) (x : T3) :
    curl (F g) x = EuclideanSpace.single 1 (g' (x 2)) := by
  simp only [curl, directionalCoord, fderiv_F_coord_apply hg, e0_apply, single_apply_two]
  ext i
  fin_cases i <;> simp [PiLp.single_apply]

/-! ## The shear profile -/

theorem sin_profile_deriv (c : ℝ) (s : ℝ) :
    HasDerivAt (fun s => c * sin (K * s)) (c * K * cos (K * s)) s := by
  have h := ((hasDerivAt_id s).const_mul K).sin.const_mul c
  convert h using 1; simp; ring

theorem cos_profile_deriv (c : ℝ) (s : ℝ) :
    HasDerivAt (fun s => c * K * cos (K * s)) (-(c * K ^ 2) * sin (K * s)) s := by
  have h := ((hasDerivAt_id s).const_mul K).cos.const_mul (c * K)
  convert h using 1; simp; ring

theorem shearU_eq (A ν t : ℝ) :
    shearU A ν t = F (fun s => (A * exp (-(ν * K ^ 2) * t)) * sin (K * s)) := rfl

theorem shearU_zero (A ν : ℝ) (x : T3) :
    shearU A ν 0 x = (A * sin (K * x 2)) • e0 := by
  simp [shearU, F]

theorem shear_time_deriv (A ν t : ℝ) (x : T3) :
    HasDerivAt (fun s => shearU A ν s x)
      ((-(ν * K ^ 2) * (A * exp (-(ν * K ^ 2) * t)) * sin (K * x 2)) • e0) t := by
  have h := ((((hasDerivAt_id t).const_mul (-(ν * K ^ 2))).exp).const_mul A).mul_const
    (sin (K * x 2))
  have h2 := h.smul_const e0
  have hfun : (fun s => shearU A ν s x) =
      fun y => (A * exp (-(ν * K ^ 2) * id y) * sin (K * x 2)) • e0 := by
    funext s; simp [shearU, F]
  rw [hfun]
  convert h2 using 2
  simp only [id]; ring

theorem gradient_zero (x : T3) : pressureGradient (zeroP 0) x = 0 := by
  show gradient (fun _ : T3 => (0 : ℝ)) x = 0
  simp [gradient]

theorem latticeVec_two (k : Fin 3 → ℤ) : latticeVec k 2 = (k 2 : ℝ) := by
  simp [latticeVec, Fin.sum_univ_three]

theorem shear_periodic (A ν t : ℝ) : IsZ3Periodic (shearU A ν t) := by
  intro k x
  simp only [shearU, F, PiLp.add_apply, latticeVec_two]
  congr 2
  have : K * (x 2 + (k 2 : ℝ)) = K * x 2 + (k 2 : ℤ) * (2 * π) := by unfold K; ring
  rw [this, sin_add_int_mul_two_pi]

theorem shear_contDiff (A ν : ℝ) :
    ContDiff ℝ ∞ (fun q : ℝ × T3 => shearU A ν q.1 q.2) := by
  have hproj : ContDiff ℝ ∞ (fun q : ℝ × T3 => q.2 2) :=
    (EuclideanSpace.proj (2 : Fin 3) : T3 →L[ℝ] ℝ).contDiff.comp contDiff_snd
  have hs : ContDiff ℝ ∞ (fun q : ℝ × T3 =>
      A * exp (-(ν * K ^ 2) * q.1) * sin (K * q.2 2)) :=
    (contDiff_const.mul ((contDiff_const.mul contDiff_fst).exp)).mul
      ((contDiff_const.mul hproj).sin)
  exact hs.smul contDiff_const

/-- **The shear is an actual smooth periodic solution on every `[0,T)`.** -/
theorem shear_isPeriodicSmoothSolutionOn (A ν T : ℝ) :
    IsPeriodicSmoothSolutionOn ν T (shearU A ν 0) (shearU A ν) zeroP := by
  refine ⟨(shear_contDiff A ν).contDiffOn, contDiffOn_const, ?_, rfl, ?_⟩
  · intro t ht x
    have hg := fun s => sin_profile_deriv (A * exp (-(ν * K ^ 2) * t)) s
    have hg' := fun s => cos_profile_deriv (A * exp (-(ν * K ^ 2) * t)) s
    refine ⟨?_, ?_⟩
    · rw [((shear_time_deriv A ν t x).hasDerivWithinAt).derivWithin
        (uniqueDiffOn_Ici 0 t ht.1)]
      rw [shearU_eq, convective_F hg, laplacian_F hg hg']
      have hp : pressureGradient (zeroP t) x = 0 := gradient_zero x
      rw [hp, smul_smul]
      simp only [add_zero]
      congr 1; ring
    · rw [shearU_eq]; exact div_F hg x
  · intro t _
    exact ⟨shear_periodic A ν t, fun _ _ => rfl⟩

/-! ## Vorticity sup-norm -/

theorem shear_vorticity (A ν t : ℝ) (x : T3) :
    vorticity (shearU A ν t) x =
      EuclideanSpace.single 1 (A * exp (-(ν * K ^ 2) * t) * K * cos (K * x 2)) := by
  simp only [vorticity]
  rw [shearU_eq, curl_F (fun s => sin_profile_deriv _ s)]

theorem shear_vorticity_norm (A ν t : ℝ) (x : T3) :
    ‖vorticity (shearU A ν t) x‖ = |A * exp (-(ν * K ^ 2) * t) * K * cos (K * x 2)| := by
  rw [shear_vorticity, PiLp.norm_single, Real.norm_eq_abs]

theorem shear_vorticity_bdd (A ν t : ℝ) :
    BddAbove (Set.range (fun x => ‖vorticity (shearU A ν t) x‖)) := by
  refine ⟨|A * exp (-(ν * K ^ 2) * t) * K|, ?_⟩
  rintro _ ⟨x, rfl⟩
  show ‖vorticity (shearU A ν t) x‖ ≤ _
  rw [shear_vorticity_norm, abs_mul (A * exp (-(ν * K ^ 2) * t) * K)]
  exact mul_le_of_le_one_right (abs_nonneg _) (abs_cos_le_one _)

/-- **Exact vorticity sup-norm of the actual shear solution.** -/
theorem shear_vorticity_sup_norm {A : ℝ} (hA : 0 < A) (ν t : ℝ) :
    vorticity_sup_norm (vorticity (shearU A ν t)) = K * A * exp (-(ν * K ^ 2) * t) := by
  have hc : 0 < A * exp (-(ν * K ^ 2) * t) * K := by
    have := K_pos; positivity
  apply le_antisymm
  · apply ciSup_le
    intro x
    rw [shear_vorticity_norm, abs_mul (A * exp (-(ν * K ^ 2) * t) * K), abs_of_pos hc]
    calc A * exp (-(ν * K ^ 2) * t) * K * |cos (K * x 2)|
        ≤ A * exp (-(ν * K ^ 2) * t) * K * 1 :=
          mul_le_mul_of_nonneg_left (abs_cos_le_one _) hc.le
      _ = K * A * exp (-(ν * K ^ 2) * t) := by ring
  · have h0 := le_ciSup (shear_vorticity_bdd A ν t) 0
    rw [shear_vorticity_norm] at h0
    simp only [PiLp.zero_apply, mul_zero, cos_zero, mul_one, abs_of_pos hc] at h0
    unfold vorticity_sup_norm
    linarith

theorem shear_M_eq {A : ℝ} (hA : 0 < A) (ν : ℝ) :
    (fun s => vorticity_sup_norm (vorticity (shearU A ν s))) =
      fun s => (K * A) * exp (-(ν * K ^ 2) * s) := by
  funext s; rw [shear_vorticity_sup_norm hA]

/-! ## Cubic differential bound: data-dependent constants work, fixed ones fail -/

/-- With the data-dependent constant `C = κ · (k A)`, the actual shear satisfies the
cubic differential hypothesis on every compact `[0,τ]`. -/
theorem shear_cubic_bound_data_dependent {A ν κ τ : ℝ} (hA : 0 < A) (hν : 0 ≤ ν)
    (hκ : 0 < κ) (hτ : 0 ≤ τ) :
    CubicVorticityDifferentialBound (shearU A ν) τ (κ * (K * A)) κ := by
  have hKA : 0 < K * A := mul_pos K_pos hA
  have ha : 0 ≤ ν * K ^ 2 := mul_nonneg hν (sq_nonneg _)
  refine ⟨hτ, mul_pos hκ hKA, hκ, fun t ht => ⟨shear_vorticity_bdd A ν t, ?_, ?_⟩⟩
  · rw [shear_M_eq hA]
    exact (NS_Millennium_Proof.Stage6.exponential_profile_hasDerivAt _ _ t).differentiableAt
  · rw [shear_M_eq hA, shear_vorticity_sup_norm hA]
    exact NS_Millennium_Proof.Stage6.exponential_profile_satisfies_cubic_bound hKA ha hκ ht.1

/-- For FIXED constants, some amplitude gives an actual solution violating the bound. -/
theorem shear_fixed_cubic_constants_fail {C κ ν : ℝ} (hC : 0 ≤ C) (hκ : 0 < κ) (hν : 0 ≤ ν) :
    ∃ A : ℝ, 0 < A ∧ IsPeriodicSmoothSolutionOn ν 1 (shearU A ν 0) (shearU A ν) zeroP ∧
      ¬ CubicVorticityDifferentialBound (shearU A ν) 0 C κ := by
  have ha : 0 ≤ ν * K ^ 2 := mul_nonneg hν (sq_nonneg _)
  obtain ⟨M, hM, hlt⟩ :=
    NS_Millennium_Proof.Stage6.fixed_cubic_constants_fail_for_some_amplitude hC hκ ha
  refine ⟨M / K, div_pos hM K_pos, shear_isPeriodicSmoothSolutionOn _ ν 1, ?_⟩
  rintro ⟨-, -, -, h⟩
  have hA : 0 < M / K := div_pos hM K_pos
  have hKA : K * (M / K) = M := mul_div_cancel₀ M K_pos.ne'
  have h0 := (h 0 ⟨le_rfl, le_rfl⟩).2.2
  rw [shear_M_eq hA, shear_vorticity_sup_norm hA, hKA,
    (NS_Millennium_Proof.Stage6.exponential_profile_hasDerivAt M (ν * K ^ 2) 0).deriv] at h0
  simp only [mul_zero, exp_zero, mul_one] at h0
  linarith

/-- The conditional envelope theorem applies to a nonzero actual solution. -/
theorem shear_envelope_nonvacuous {A ν κ T : ℝ} (hA : 0 < A) (hν : 0 ≤ ν) (hκ : 0 < κ) :
    (shearU A ν 0 ≠ 0) ∧
    ∀ t ∈ Set.Ico (0 : ℝ) T,
      vorticity_sup_norm (vorticity (shearU A ν t)) ≤
        max (vorticity_sup_norm (vorticity (shearU A ν 0))) (κ * (K * A) / κ) := by
  refine ⟨?_, periodic_solution_envelope_of_compact_cubic_bounds
    (shear_isPeriodicSmoothSolutionOn A ν T)
    (fun τ hτ _ => shear_cubic_bound_data_dependent hA hν hκ hτ)⟩
  intro h
  have := congrFun h (EuclideanSpace.single 2 (1 / 4))
  have h2 := congrArg (fun v : EuclideanSpace ℝ (Fin 3) => v 0) this
  simp [shearU_zero, e0] at h2
  rcases h2 with h2 | h2
  · exact hA.ne' h2
  · have : K * 4⁻¹ = π / 2 := by unfold K; ring
    rw [this, sin_pi_div_two] at h2; norm_num at h2

end
end NS_Millennium_Proof.ShearSolution
