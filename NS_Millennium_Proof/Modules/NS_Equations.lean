/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

module

public import Mathlib.Analysis.Calculus.ContDiff.Basic
public import Mathlib.Analysis.Calculus.Deriv.Basic
public import Mathlib.Analysis.Calculus.FDeriv.Add
public import Mathlib.Analysis.Calculus.FDeriv.Basic
public import Mathlib.Analysis.Calculus.FDeriv.Comp
public import Mathlib.Analysis.Calculus.FDeriv.Linear
public import Mathlib.Analysis.Calculus.FDeriv.Mul
public import Mathlib.Analysis.Calculus.FDeriv.Symmetric
public import Mathlib.Analysis.Calculus.Gradient.Basic
public import Mathlib.Analysis.InnerProductSpace.PiL2
public import Mathlib.Data.EReal.Basic
public import Mathlib.Data.ENNReal.Basic
public import Mathlib.Data.Real.Basic
public import Mathlib.Data.Real.Archimedean
public import Mathlib.Data.Set.Basic
public import Mathlib.Algebra.BigOperators.Group.Finset.Basic
public import Mathlib.MeasureTheory.Function.LocallyIntegrable
public import Mathlib.MeasureTheory.Integral.Bochner.Basic
public import Mathlib.MeasureTheory.Measure.Haar.InnerProductSpace
public import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
public import Mathlib.MeasureTheory.Measure.MeasureSpace

open scoped BigOperators Gradient
open ENNReal InnerProductSpace MeasureTheory Finset

/-!
# Navier–Stokes Equations: Classical Foundation (Lean 4)

3D incompressible Navier–Stokes on the model space `EuclideanSpace ℝ (Fin 3)`
(standing in for `𝕋³` at the type level; Haar/Lebesgue volume is inherited from mathlib).

Differential operators are the standard Lean 4 calculus objects (`deriv`, `fderiv`,
`gradient`). Local existence, Beale–Kato–Majda, and the maximal time `Tstar` remain
documented classical black boxes (Kato/Leray/BKM) with **real types**.
-/

namespace NavierStokes3D

/-- Model 3-space. `abbrev` so mathlib instances (norm, inner product, Haar measure) inherit. -/
@[expose] public abbrev T3 : Type := EuclideanSpace ℝ (Fin 3)

public abbrev VelocityField := T3 → EuclideanSpace ℝ (Fin 3)
public abbrev VorticityField := T3 → EuclideanSpace ℝ (Fin 3)
public abbrev PressureField := T3 → ℝ

public abbrev TimeDependentVelocity := ℝ → VelocityField
public abbrev TimeDependentVorticity := ℝ → VorticityField
public abbrev TimeDependentPressure := ℝ → PressureField

noncomputable section

/-- Haar / Lebesgue volume on the model space. -/
@[expose] public def volume : Measure T3 := MeasureTheory.volume

/-- Pointwise time derivative via mathlib `deriv`. -/
@[expose] public def time_deriv {α : Type*} [NormedAddCommGroup α] [NormedSpace ℝ α]
    (f : ℝ → (T3 → α)) (t : ℝ) (x : T3) : α :=
  deriv (fun s => f s x) t

notation "∂t " f:arg t:arg => time_deriv f t

/-- Convective derivative `(u · ∇) v`, as the Fréchet derivative of `v` in the direction `u`. -/
@[expose] public def convective (u v : VelocityField) : VelocityField :=
  fun x => (fderiv ℝ v x) (u x)

prefix:100 "(·∇)" => fun u v => convective u v

/-- Component sum on the 3-space. Discrete index `Fin 3` (from `Nat`).
Time, viscosity, `κ`, norms, and integrals stay over `ℝ`. -/
@[expose] public def componentSum (v : EuclideanSpace ℝ (Fin 3)) : ℝ :=
  ∑ i : Fin 3, v i

/-- i-th coordinate directional derivative of a vector field. -/
@[expose] public def directionalCoord (u : VelocityField) (comp dir : Fin 3) (x : T3) : ℝ :=
  (fderiv ℝ (fun y => u y comp) x) (EuclideanSpace.single dir 1)

/-- Laplacian as the trace of the Hessian. -/
@[expose] public def laplacian (f : VelocityField) : VelocityField :=
  fun x => ∑ i : Fin 3,
    (fderiv ℝ (fun y => (fderiv ℝ f y) (EuclideanSpace.single i 1)) x)
      (EuclideanSpace.single i 1)

notation "Δ " f:arg => laplacian f

/-- Divergence: `∑ᵢ ∂ᵢ uᵢ`. -/
@[expose] public def div (u : VelocityField) (x : T3) : ℝ :=
  ∑ i : Fin 3, (fderiv ℝ (fun y => u y i) x) (EuclideanSpace.single i 1)

/-- Coordinate of a scalar multiple. Discrete index `Fin 3`; coefficient `c : ℝ`. -/
public theorem smul_coord (c : ℝ) (v : EuclideanSpace ℝ (Fin 3)) (i : Fin 3) :
    (c • v) i = c * v i := by
  rw [PiLp.smul_apply, smul_eq_mul]

/-- Scaling a field scales its divergence. Discrete index `Fin 3`; coefficient `c : ℝ`.
Unconditional: `fderiv_const_smul_field` handles the zero-scalar and non-differentiable cases. -/
public theorem div_smul (c : ℝ) (u : VelocityField) (x : T3) :
    div (fun y => c • u y) x = c * div u x := by
  unfold div
  have hfun : ∀ i : Fin 3,
      (fun y => (c • u y) i) = c • fun y => u y i := by
    intro i
    funext y
    exact smul_coord c (u y) i
  calc
    ∑ i : Fin 3, (fderiv ℝ (fun y => (c • u y) i) x) (EuclideanSpace.single i 1)
        = ∑ i : Fin 3, (fderiv ℝ (c • fun y => u y i) x) (EuclideanSpace.single i 1) := by
          refine Finset.sum_congr rfl fun i _ => ?_
          rw [hfun i]
    _ = ∑ i : Fin 3, (c • fderiv ℝ (fun y => u y i) x) (EuclideanSpace.single i 1) := by
          refine Finset.sum_congr rfl fun i _ => ?_
          rw [fderiv_const_smul_field, Pi.smul_apply]
    _ = ∑ i : Fin 3, c * (fderiv ℝ (fun y => u y i) x) (EuclideanSpace.single i 1) := by
          refine Finset.sum_congr rfl fun i _ => ?_
          rw [ContinuousLinearMap.smul_apply, smul_eq_mul]
    _ = c * ∑ i : Fin 3, (fderiv ℝ (fun y => u y i) x) (EuclideanSpace.single i 1) := by
          rw [← Finset.mul_sum]

/-- Divergence is linear in the field, at points where every coordinate is differentiable. -/
public theorem div_add (u v : VelocityField) (x : T3)
    (hu : ∀ i, DifferentiableAt ℝ (fun y => u y i) x)
    (hv : ∀ i, DifferentiableAt ℝ (fun y => v y i) x) :
    div (fun y => u y + v y) x = div u x + div v x := by
  unfold div
  have hfun : ∀ i : Fin 3,
      (fun y => (u y + v y) i) = fun y => u y i + v y i := by
    intro i
    funext y
    rw [PiLp.add_apply]
  calc
    ∑ i : Fin 3, (fderiv ℝ (fun y => (u y + v y) i) x) (EuclideanSpace.single i 1)
        = ∑ i : Fin 3, (fderiv ℝ (fun y => u y i + v y i) x) (EuclideanSpace.single i 1) := by
          refine Finset.sum_congr rfl fun i _ => ?_
          rw [hfun i]
    _ = ∑ i : Fin 3,
          ((fderiv ℝ (fun y => u y i) x) + (fderiv ℝ (fun y => v y i) x))
            (EuclideanSpace.single i 1) := by
          refine Finset.sum_congr rfl fun i _ => ?_
          rw [fderiv_fun_add (hu i) (hv i)]
    _ = ∑ i : Fin 3, (fderiv ℝ (fun y => u y i) x) (EuclideanSpace.single i 1) +
        ∑ i : Fin 3, (fderiv ℝ (fun y => v y i) x) (EuclideanSpace.single i 1) := by
          simp only [ContinuousLinearMap.add_apply, Finset.sum_add_distrib]

/-- Affine combination of fields: `div(u + c • v) = div u + c div v`. -/
public theorem div_add_smul (u v : VelocityField) (c : ℝ) (x : T3)
    (hu : ∀ i, DifferentiableAt ℝ (fun y => u y i) x)
    (hv : ∀ i, DifferentiableAt ℝ (fun y => v y i) x) :
    div (fun y => u y + c • v y) x = div u x + c * div v x := by
  have hcv : ∀ i, DifferentiableAt ℝ (fun y => (c • v y) i) x := by
    intro i
    have hfun : (fun y => (c • v y) i) = c • fun y => v y i := by
      funext y
      exact smul_coord c (v y) i
    rw [hfun]
    exact (hv i).const_smul c
  have hadd :=
    div_add u (fun y => c • v y) x hu hcv
  rw [hadd, div_smul]

/-- Divergence of a spatially constant field vanishes (each coordinate is constant). -/
public theorem div_const (v : EuclideanSpace ℝ (Fin 3)) (x : T3) :
    div (fun _ => v) x = 0 := by
  unfold div
  simp

/-- Curl on `ℝ³` (standard orientation). -/
@[expose] public def curl (u : VelocityField) (x : T3) : EuclideanSpace ℝ (Fin 3) :=
  EuclideanSpace.single 0 (directionalCoord u 2 1 x - directionalCoord u 1 2 x) +
    EuclideanSpace.single 1 (directionalCoord u 0 2 x - directionalCoord u 2 0 x) +
    EuclideanSpace.single 2 (directionalCoord u 1 0 x - directionalCoord u 0 1 x)

/-- Scaling a field scales each directional coordinate. -/
public theorem directionalCoord_smul (c : ℝ) (u : VelocityField) (comp dir : Fin 3) (x : T3) :
    directionalCoord (fun y => c • u y) comp dir x =
      c * directionalCoord u comp dir x := by
  unfold directionalCoord
  have hfun : (fun y => (c • u y) comp) = c • fun y => u y comp := by
    funext y
    exact smul_coord c (u y) comp
  rw [hfun, fderiv_const_smul_field, Pi.smul_apply, ContinuousLinearMap.smul_apply, smul_eq_mul]

/-- Scaling a field scales its curl. Unconditional (same field identity as `div_smul`). -/
public theorem curl_smul (c : ℝ) (u : VelocityField) (x : T3) :
    curl (fun y => c • u y) x = c • curl u x := by
  ext i
  fin_cases i <;>
    simp [curl, directionalCoord_smul, smul_eq_mul] <;> ring

/-- Pressure gradient (mathlib Hilbert-space gradient). -/
@[expose] public def pressureGradient (p : PressureField) : VelocityField :=
  fun x => gradient p x

/-- `i`-th coordinate of the Hilbert-space gradient is the corresponding partial. -/
public theorem gradient_coord (p : PressureField) (x : T3) (i : Fin 3)
    (hp : DifferentiableAt ℝ p x) :
    gradient p x i = (fderiv ℝ p x) (EuclideanSpace.single i 1) := by
  have hinner : inner ℝ (gradient p x) (EuclideanSpace.single i 1) =
      (fderiv ℝ p x) (EuclideanSpace.single i 1) :=
    inner_gradient_left (y := EuclideanSpace.single i 1) hp
  have hcoord : inner ℝ (gradient p x) (EuclideanSpace.single i 1) = gradient p x i := by
    simpa using
      (EuclideanSpace.inner_single_right (i := i) (a := (1 : ℝ)) (v := gradient p x))
  exact hcoord.symm.trans hinner

/-- Mixed partials of a `C²` scalar: `∂ⱼ (∇p)ᵢ = D²p (eⱼ, eᵢ)`. -/
public theorem directionalCoord_pressureGradient
    (p : PressureField) (x : T3) (i j : Fin 3)
    (hp : ContDiffAt ℝ 2 p x) :
    directionalCoord (pressureGradient p) i j x =
      (fderiv ℝ (fderiv ℝ p) x) (EuclideanSpace.single j 1) (EuclideanSpace.single i 1) := by
  unfold directionalCoord pressureGradient
  have hfd : DifferentiableAt ℝ (fderiv ℝ p) x :=
    (hp.fderiv_right (m := 1) (by norm_num)).differentiableAt (by norm_num)
  have hnear : ∀ᶠ y in nhds x, DifferentiableAt ℝ p y := by
    filter_upwards
      [(hp.of_le (by norm_num : (1 : WithTop ℕ∞) ≤ 2)).eventually (by simp)] with y hy
    exact hy.differentiableAt (by norm_num)
  have hgrad :
      (fun y => gradient p y i) =ᶠ[nhds x]
        fun y => (fderiv ℝ p y) (EuclideanSpace.single i 1) := by
    filter_upwards [hnear] with y hy
    exact gradient_coord p y i hy
  have hcomp :
      fderiv ℝ (fun y => (fderiv ℝ p y) (EuclideanSpace.single i 1)) x =
        (ContinuousLinearMap.apply ℝ ℝ (EuclideanSpace.single i 1)).comp
          (fderiv ℝ (fderiv ℝ p) x) := by
    change fderiv ℝ (fun y =>
        (ContinuousLinearMap.apply ℝ ℝ (EuclideanSpace.single i 1)) (fderiv ℝ p y)) x = _
    rw [fderiv_comp' x (ContinuousLinearMap.differentiableAt _) hfd]
    simp [ContinuousLinearMap.fderiv]
  have hf : fderiv ℝ (fun y => gradient p y i) x =
      fderiv ℝ (fun y => (fderiv ℝ p y) (EuclideanSpace.single i 1)) x :=
    hgrad.fderiv_eq
  rw [hf, hcomp]
  rfl

/-- Curl of a gradient vanishes at `C²` points (equality of mixed partials). -/
public theorem curl_gradient (p : PressureField) (x : T3)
    (hp : ContDiffAt ℝ 2 p x) :
    curl (pressureGradient p) x = 0 := by
  have hsymm : IsSymmSndFDerivAt ℝ p x :=
    hp.isSymmSndFDerivAt (by simp [minSmoothness_of_isRCLikeNormedField])
  have hswap : ∀ i j : Fin 3,
      directionalCoord (pressureGradient p) i j x =
        directionalCoord (pressureGradient p) j i x := by
    intro i j
    rw [directionalCoord_pressureGradient p x i j hp,
        directionalCoord_pressureGradient p x j i hp]
    exact hsymm.eq (EuclideanSpace.single j 1) (EuclideanSpace.single i 1)
  unfold curl
  have h01 := hswap 2 1
  have h12 := hswap 0 2
  have h20 := hswap 1 0
  ext k
  simp [h01, h12, h20, PiLp.single_apply]

public abbrev Velocity := VelocityField
public abbrev Vorticity := VorticityField
public abbrev vol := volume

postfix:90 "_div" => fun u x => div u x

/-- Incompressible Navier–Stokes: momentum identity plus divergence-free constraint. -/
@[expose] public def navier_stokes_eq (u : TimeDependentVelocity) (p : TimeDependentPressure)
    (ν : ℝ) : Prop :=
  ∀ t ≥ (0 : ℝ), ∀ x : T3,
    time_deriv u t x + convective (u t) (u t) x + pressureGradient (p t) x =
        ν • laplacian (u t) x ∧
      div (u t) x = 0

@[expose] public def vorticity (u : Velocity) : Vorticity := fun x => curl u x

/-- Vorticity transport: `∂t ω + (u · ∇) ω = (ω · ∇) u + ν Δ ω`. -/
public theorem vorticity_transport
    (u : TimeDependentVelocity) (p : TimeDependentPressure) (ν : ℝ)
    (h_NS : navier_stokes_eq u p ν) :
    ∀ t ≥ (0 : ℝ), ∀ x : T3,
      time_deriv (fun s => vorticity (u s)) t x + convective (u t) (vorticity (u t)) x =
        convective (vorticity (u t)) (u t) x + ν • laplacian (vorticity (u t)) x := by
  sorry

/-- Same momentum + divergence-free system, named for the assembly layer. -/
@[expose] public def NS_PDE (u : ℝ → VelocityField) (p : ℝ → PressureField) (ν : ℝ) : Prop :=
  navier_stokes_eq u p ν

public theorem vorticity_transport_equation
    (u : ℝ → VelocityField) (p : ℝ → PressureField) (ν : ℝ)
    (h_ns : NS_PDE u p ν) :
    ∀ t ≥ (0 : ℝ), ∀ x : T3,
      time_deriv (fun s => vorticity (u s)) t x + convective (u t) (vorticity (u t)) x =
        convective (vorticity (u t)) (u t) x + ν • laplacian (vorticity (u t)) x :=
  vorticity_transport u p ν h_ns

/-- Material derivative `∂t + u · ∇` on scalars. -/
@[expose] public def MaterialDerivative (u : ℝ → VelocityField) (f : ℝ → (T3 → ℝ))
    (t : ℝ) (x : T3) : ℝ :=
  deriv (fun s => f s x) t + inner ℝ (u t x) (gradient (f t) x)

/-- Finite existence times: a positive `T` such that a smooth NS solution starting at `u₀`
exists on the compact interval `[0, T]`. -/
public def existenceTimes (u₀ : VelocityField) (ν : ℝ) : Set ℝ :=
  { T | 0 < T ∧ ∃ u : TimeDependentVelocity, ∃ p : TimeDependentPressure,
      u 0 = u₀ ∧ NS_PDE u p ν ∧ ∀ t ∈ Set.Icc (0 : ℝ) T, ContDiff ℝ ⊤ (u t) }

/-- Maximal existence time `T*` as an extended real: `sSup` of the existence times,
or `0` if there are none (`insert 0`). Unbounded existence times give `T* = ⊤`.
Time itself remains `ℝ`; `T*` is the one quantity that may be infinite. -/
@[expose] public noncomputable def Tstar (u₀ : VelocityField) (ν : ℝ) : EReal :=
  sSup (insert (0 : EReal) ((↑) '' existenceTimes u₀ ν))

public theorem Tstar_nonneg (u₀ : VelocityField) (ν : ℝ) :
    (0 : EReal) ≤ Tstar u₀ ν :=
  le_sSup (Set.mem_insert (0 : EReal) _)

/-- Any concrete finite existence time is `≤ T*`. -/
public theorem le_Tstar_of_mem_existenceTimes
    (u₀ : VelocityField) (ν : ℝ) {T : ℝ}
    (hT : T ∈ existenceTimes u₀ ν) :
    (T : EReal) ≤ Tstar u₀ ν :=
  le_sSup (Set.mem_insert_of_mem _ ⟨T, hT, rfl⟩)

/-- Local existence of a smooth solution on a short interval (Kato 1972 / Leray 1934). -/
public theorem local_existence
    (u₀ : VelocityField) (ν : ℝ)
    (h_smooth : ContDiff ℝ ⊤ u₀)
    (h_divfree : ∀ x, div u₀ x = 0)
    (h_finite : Integrable (fun x : T3 => ‖u₀ x‖ ^ 2))
    (hν : 0 < ν) :
    ∃ T > (0 : ℝ), ∃ u : ℝ → VelocityField,
      (∀ t ∈ Set.Icc 0 T, ContDiff ℝ ⊤ (u t)) ∧
      u 0 = u₀ ∧
      ∃ p : ℝ → PressureField, NS_PDE u p ν := by
  sorry

/-- Kato local existence forces `T* > 0`. The implication is kernel-closed; the
existence hypothesis is the remaining Kato transcription. -/
public theorem Tstar_pos_of_exists_smooth_solution
    (u₀ : VelocityField) (ν : ℝ)
    (h : ∃ T > (0 : ℝ), ∃ u : ℝ → VelocityField,
      (∀ t ∈ Set.Icc 0 T, ContDiff ℝ ⊤ (u t)) ∧
      u 0 = u₀ ∧
      ∃ p : ℝ → PressureField, NS_PDE u p ν) :
    (0 : EReal) < Tstar u₀ ν := by
  obtain ⟨T, hTpos, u, hsmooth, hu0, p, hpde⟩ := h
  have hmem : T ∈ existenceTimes u₀ ν := ⟨hTpos, u, p, hu0, hpde, hsmooth⟩
  have hpos : (0 : EReal) < (T : EReal) := EReal.coe_pos.mpr hTpos
  exact lt_of_lt_of_le hpos (le_Tstar_of_mem_existenceTimes u₀ ν hmem)

/-- Pointwise sup-norm proxy used by BKM. -/
@[expose] public noncomputable def vorticity_sup_norm (ω : VorticityField) : ℝ :=
  ⨆ x, ‖ω x‖

public theorem vorticity_sup_norm_nonneg (ω : VorticityField) :
    0 ≤ vorticity_sup_norm ω :=
  Real.iSup_nonneg fun _ => norm_nonneg _

/-- Maximum principle for a transported scalar with quadratic vorticity source:
if `∂t φ + u·∇φ = |ω|²`, then `‖φ(t)‖_∞ ≤ ‖φ(0)‖_∞ + ∫₀ᵗ ‖ω‖_∞²`.
Classical; typed on `MaterialDerivative` and `vorticity_sup_norm`. -/
public theorem transported_scalar_maximum_principle
    (u : TimeDependentVelocity) (phi : ℝ → T3 → ℝ)
    (htrans : ∀ t ≥ (0 : ℝ), ∀ x,
      MaterialDerivative u phi t x = ‖vorticity (u t) x‖ ^ 2)
    (t : ℝ) (ht : 0 ≤ t) :
    ⨆ x, |phi t x| ≤
      (⨆ x, |phi 0 x|) +
        ∫ s in Set.Icc (0 : ℝ) t, vorticity_sup_norm (vorticity (u s)) ^ 2 := by
  sorry

/-- Beale–Kato–Majda criterion (Beale–Kato–Majda 1984).

If the time-integral of `‖ω(t)‖_∞` stays finite up to the maximal time, the solution
cannot blow up and remains smooth. Classical black box; typed so the assembly theorem
can cite it. -/
public theorem beale_kato_majda
    (u : TimeDependentVelocity) (p : TimeDependentPressure) (ν : ℝ)
    (hν : 0 < ν) (hNS : NS_PDE u p ν)
    (h_bkm : ∀ T : ℝ, (T : EReal) < Tstar (u 0) ν →
      IntegrableOn (fun t => vorticity_sup_norm (vorticity (u t))) (Set.Icc 0 T)) :
    ∀ t ≥ (0 : ℝ), ContDiff ℝ ⊤ (u t) := by
  sorry

/-- Parabolic regularity upgrade: a uniform vorticity bound plus continuity of
`t ↦ ‖ω(t)‖_∞` feeds BKM, hence smoothness for all positive times. -/
public theorem parabolic_regularity_from_vorticity_bound
    (u : TimeDependentVelocity) (p : TimeDependentPressure) (ν : ℝ)
    (hν : 0 < ν) (hNS : NS_PDE u p ν)
    (M : ℝ)
    (_h_bound : ∀ t ≥ (0 : ℝ), vorticity_sup_norm (vorticity (u t)) ≤ M)
    (hcont : Continuous fun t : ℝ => vorticity_sup_norm (vorticity (u t))) :
    ∀ t ≥ (0 : ℝ), ContDiff ℝ ⊤ (u t) :=
  beale_kato_majda u p ν hν hNS fun T _hTlt => by
    by_cases hT0 : 0 ≤ T
    · exact hcont.continuousOn.integrableOn_Icc
    · have hempty : Set.Icc (0 : ℝ) T = (∅ : Set ℝ) := by
        ext x
        constructor
        · intro hx
          exact (hT0 (le_trans hx.1 hx.2)).elim
        · intro hx
          exact hx.elim
      rw [hempty]
      exact integrableOn_empty

end

end NavierStokes3D
