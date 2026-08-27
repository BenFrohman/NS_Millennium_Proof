/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

module

public import Mathlib.Analysis.Calculus.ContDiff.Basic
public import Mathlib.Analysis.Calculus.ContDiff.WithLp
public import Mathlib.Analysis.Calculus.Deriv.Basic
public import Mathlib.Analysis.Calculus.FDeriv.Add
public import Mathlib.Analysis.Calculus.FDeriv.Basic
public import Mathlib.Analysis.Calculus.FDeriv.Comp
public import Mathlib.Analysis.Calculus.FDeriv.Linear
public import Mathlib.Analysis.Calculus.FDeriv.Mul
public import Mathlib.Analysis.Calculus.FDeriv.Prod
public import Mathlib.Analysis.Calculus.FDeriv.Symmetric
public import Mathlib.Analysis.Calculus.Deriv.Add
public import Mathlib.Analysis.Calculus.Gradient.Basic
public import Mathlib.Analysis.InnerProductSpace.Calculus
public import Mathlib.Analysis.InnerProductSpace.PiL2
public import Mathlib.Data.EReal.Basic
public import Mathlib.Data.ENNReal.Basic
public import Mathlib.Data.Real.Basic
public import Mathlib.Data.Real.Archimedean
public import Mathlib.Data.Set.Basic
public import Mathlib.Algebra.BigOperators.Group.Finset.Basic
public import Mathlib.Tactic.Ring
public import Mathlib.MeasureTheory.Function.LocallyIntegrable
public import Mathlib.MeasureTheory.Integral.Bochner.Basic
public import Mathlib.MeasureTheory.Measure.Haar.InnerProductSpace
public import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
public import Mathlib.MeasureTheory.Measure.MeasureSpace

open scoped BigOperators Gradient Topology
open ENNReal InnerProductSpace MeasureTheory Finset Filter

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

/-- Coordinate projections on the model 3-space are differentiable. -/
public theorem differentiableAt_coord (x : T3) (i : Fin 3) :
    DifferentiableAt ℝ (fun z : T3 => z i) x :=
  (PiLp.proj (p := 2) (fun _ : Fin 3 => ℝ) i).differentiableAt

/-- Fréchet derivative of the `i`-th coordinate is that coordinate of the increment. -/
public theorem fderiv_coord (x : T3) (i : Fin 3) (dz : T3) :
    (fderiv ℝ (fun z : T3 => z i) x) dz = dz i := by
  let L : EuclideanSpace ℝ (Fin 3) →L[ℝ] ℝ :=
    PiLp.proj (p := 2) (fun _ : Fin 3 => ℝ) i
  have hfun : (fun z : T3 => z i) = fun z => L z := rfl
  rw [hfun, ContinuousLinearMap.fderiv]
  rfl

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

/-- Product rule for divergence: `div(φ V) = ∇φ · V + φ div V`. -/
public theorem div_smul_field (φ : PressureField) (V : VelocityField) (x : T3)
    (hφ : DifferentiableAt ℝ φ x)
    (hV : ∀ i, DifferentiableAt ℝ (fun y => V y i) x) :
    div (fun y => φ y • V y) x =
      inner ℝ (gradient φ x) (V x) + φ x * div V x := by
  have hcoord : ∀ i : Fin 3,
      (fun y => (φ y • V y) i) = fun y => φ y * V y i := by
    intro i
    funext y
    exact smul_coord (φ y) (V y) i
  have hprod : ∀ i : Fin 3,
      fderiv ℝ (fun y => φ y * V y i) x =
        φ x • fderiv ℝ (fun y => V y i) x +
          V x i • fderiv ℝ φ x :=
    fun i => fderiv_fun_mul hφ (hV i)
  unfold div
  simp_rw [hcoord, hprod, ContinuousLinearMap.add_apply, ContinuousLinearMap.smul_apply,
    smul_eq_mul]
  have hsplit :
      (∑ i : Fin 3,
          (φ x * (fderiv ℝ (fun y => V y i) x) (EuclideanSpace.single i 1) +
            V x i * (fderiv ℝ φ x) (EuclideanSpace.single i 1))) =
        φ x * (∑ i : Fin 3,
            (fderiv ℝ (fun y => V y i) x) (EuclideanSpace.single i 1)) +
          ∑ i : Fin 3, V x i * (fderiv ℝ φ x) (EuclideanSpace.single i 1) := by
    rw [Finset.sum_add_distrib, Finset.mul_sum]
  rw [hsplit]
  have hgrad :
      ∑ i : Fin 3, V x i * (fderiv ℝ φ x) (EuclideanSpace.single i 1) =
        inner ℝ (gradient φ x) (V x) := by
    have hmap : ∀ i,
        V x i * (fderiv ℝ φ x) (EuclideanSpace.single i 1) =
          (fderiv ℝ φ x) (V x i • EuclideanSpace.single i 1) := by
      intro i
      rw [ContinuousLinearMap.map_smul, smul_eq_mul]
    simp_rw [hmap]
    have hsumV :
        (∑ i : Fin 3, V x i • EuclideanSpace.single i 1) = V x := by
      ext j
      simp [Finset.sum_apply, smul_eq_mul, EuclideanSpace.single, Pi.single_apply,
        Finset.sum_ite_eq, Finset.mem_univ]
    rw [← map_sum, hsumV]
    exact (inner_gradient_left (y := V x) hφ).symm
  rw [hgrad, add_comm]

/-- Integration by parts given vanishing flux:
`∫ ⟨u, ∇φ⟩ = −∫ (div u) φ` once `∫ div(φ u) = 0`. On `𝕋³` the flux vanishes
by the divergence theorem; on this Haar model the flux identity is the
decay / compact-support hypothesis. The paper's convective cancellation
is this identity with `φ = ½|u|²`. -/
public theorem integration_by_parts_of_vanishing_flux
    (u : VelocityField) (φ : T3 → ℝ)
    (hφ : ∀ x, DifferentiableAt ℝ φ x)
    (hu : ∀ i x, DifferentiableAt ℝ (fun y => u y i) x)
    (hInt_pair : Integrable (fun x => inner ℝ (u x) (gradient φ x)))
    (hInt_div : Integrable (fun x => div u x * φ x))
    (hflux : ∫ x, div (fun y => φ y • u y) x ∂volume = 0) :
    ∫ x, inner ℝ (u x) (gradient φ x) ∂volume =
      -∫ x, div u x * φ x ∂volume := by
  have hfun :
      (fun x => div (fun y => φ y • u y) x) =
        fun x => inner ℝ (u x) (gradient φ x) + div u x * φ x := by
    funext x
    have hprod := div_smul_field φ u x (hφ x) (fun i => hu i x)
    rw [hprod, real_inner_comm, mul_comm (φ x)]
  have hsplit :=
    integral_add (μ := volume) hInt_pair hInt_div
  have hflux' :
      ∫ x, inner ℝ (u x) (gradient φ x) + div u x * φ x ∂volume = 0 := by
    rwa [← hfun]
  linarith [hsplit, hflux']

/-- Pointwise: `⟨u, (u·∇)u⟩ = ⟨u, ∇(½|u|²)⟩`. This is the integrand of
the paper's convective IBP. -/
public theorem inner_self_convective_eq_inner_grad_half_norm_sq
    (u : VelocityField) (x : T3)
    (hu : DifferentiableAt ℝ u x) :
    inner ℝ (u x) (convective u u x) =
      inner ℝ (u x) (gradient (fun y => (1 / 2 : ℝ) * ‖u y‖ ^ 2) x) := by
  have hF : HasFDerivAt (fun y => ‖u y‖ ^ 2)
      ((2 • innerSL ℝ (u x)).comp (fderiv ℝ u x)) x :=
    hu.hasFDerivAt.norm_sq
  have hsq : DifferentiableAt ℝ (fun y => ‖u y‖ ^ 2) x :=
    hF.differentiableAt
  have hhalf : DifferentiableAt ℝ (fun y => (1 / 2 : ℝ) * ‖u y‖ ^ 2) x :=
    hsq.const_mul (1 / 2 : ℝ)
  have hval :
      fderiv ℝ (fun y => ‖u y‖ ^ 2) x (u x) =
        2 * inner ℝ (u x) (convective u u x) := by
    rw [hF.fderiv]
    simp [ContinuousLinearMap.comp_apply, ContinuousLinearMap.smul_apply,
      innerSL_apply_apply, convective]
  have hgrad :
      inner ℝ (u x) (gradient (fun y => (1 / 2 : ℝ) * ‖u y‖ ^ 2) x) =
        (1 / 2) * fderiv ℝ (fun y => ‖u y‖ ^ 2) x (u x) := by
    rw [real_inner_comm, inner_gradient_left hhalf,
      fderiv_const_mul hsq (1 / 2 : ℝ), ContinuousLinearMap.smul_apply,
      smul_eq_mul]
  linarith [hval, hgrad]

/-- Coordinate projections of a Fréchet-differentiable field are differentiable.
C¹ of `u : T3 → ℝ³` is the right regularity for IBP; mixed partials are not. -/
public theorem differentiableAt_coord_of_differentiableAt_field
    (u : VelocityField) (x : T3) (i : Fin 3)
    (hu : DifferentiableAt ℝ u x) :
    DifferentiableAt ℝ (fun y => u y i) x := by
  let L : EuclideanSpace ℝ (Fin 3) →L[ℝ] ℝ :=
    PiLp.proj (p := 2) (fun _ : Fin 3 => ℝ) i
  have hfun : (fun y => u y i) = fun y => L (u y) := rfl
  rw [hfun]
  exact L.differentiableAt.comp x hu

/-- `½|u|²` is C¹ wherever `u` is C¹. Used as the convective IBP test function. -/
public theorem differentiableAt_half_norm_sq
    (u : VelocityField) (x : T3) (hu : DifferentiableAt ℝ u x) :
    DifferentiableAt ℝ (fun y => (1 / 2 : ℝ) * ‖u y‖ ^ 2) x :=
  (hu.hasFDerivAt.norm_sq).differentiableAt.const_mul (1 / 2 : ℝ)

/-- Convective IBP: if `div u = 0` and the flux of `½|u|² u` vanishes, then
`∫ ⟨u, (u·∇)u⟩ = 0`. Paper energy identity, not a dropped term.
Regularity is C¹ of the field (no mixed partials). -/
public theorem convective_energy_pairing_vanishes
    (u : VelocityField)
    (hdiv : ∀ x, div u x = 0)
    (hu : ∀ x, DifferentiableAt ℝ u x)
    (hInt_pair : Integrable
      (fun x => inner ℝ (u x) (gradient (fun y => (1 / 2 : ℝ) * ‖u y‖ ^ 2) x)))
    (hInt_div : Integrable
      (fun x => div u x * ((1 / 2 : ℝ) * ‖u x‖ ^ 2)))
    (hflux : ∫ x,
        div (fun y => ((1 / 2 : ℝ) * ‖u y‖ ^ 2) • u y) x ∂volume = 0) :
    ∫ x, inner ℝ (u x) (convective u u x) ∂volume = 0 := by
  have hφ : ∀ x, DifferentiableAt ℝ (fun y => (1 / 2 : ℝ) * ‖u y‖ ^ 2) x :=
    fun x => differentiableAt_half_norm_sq u x (hu x)
  have hu_coord : ∀ i x, DifferentiableAt ℝ (fun y => u y i) x :=
    fun i x => differentiableAt_coord_of_differentiableAt_field u x i (hu x)
  have hpt :
      (fun x => inner ℝ (u x) (convective u u x)) =
        fun x =>
          inner ℝ (u x) (gradient (fun y => (1 / 2 : ℝ) * ‖u y‖ ^ 2) x) := by
    funext x
    exact inner_self_convective_eq_inner_grad_half_norm_sq u x (hu x)
  have hibp :=
    integration_by_parts_of_vanishing_flux u
      (fun y => (1 / 2 : ℝ) * ‖u y‖ ^ 2)
      hφ hu_coord hInt_pair hInt_div hflux
  have hzero :
      ∫ x, div u x * ((1 / 2 : ℝ) * ‖u x‖ ^ 2) ∂volume = 0 := by
    have hfun :
        (fun x => div u x * ((1 / 2 : ℝ) * ‖u x‖ ^ 2)) = fun _ => 0 := by
      funext x
      simp [hdiv x]
    rw [hfun]
    exact integral_zero (α := T3) (G := ℝ) (μ := volume)
  rw [hpt, hibp, hzero, neg_zero]

/-- Pressure IBP: if `div u = 0` and the flux of `p u` vanishes, then
`∫ ⟨u, ∇p⟩ = 0`. C¹ of `u` and of `p`; mixed partials are not used here
(`curl ∇p = 0` is the C² identity `curl_gradient`). -/
public theorem pressure_energy_pairing_vanishes
    (u : VelocityField) (p : PressureField)
    (hdiv : ∀ x, div u x = 0)
    (hu : ∀ x, DifferentiableAt ℝ u x)
    (hp : ∀ x, DifferentiableAt ℝ p x)
    (hInt_pair : Integrable (fun x => inner ℝ (u x) (gradient p x)))
    (hInt_div : Integrable (fun x => div u x * p x))
    (hflux : ∫ x, div (fun y => p y • u y) x ∂volume = 0) :
    ∫ x, inner ℝ (u x) (pressureGradient p x) ∂volume = 0 := by
  have hu_coord : ∀ i x, DifferentiableAt ℝ (fun y => u y i) x :=
    fun i x => differentiableAt_coord_of_differentiableAt_field u x i (hu x)
  have hfun :
      (fun x => inner ℝ (u x) (pressureGradient p x)) =
        fun x => inner ℝ (u x) (gradient p x) := by
    funext x
    rfl
  have hibp :=
    integration_by_parts_of_vanishing_flux u p hp hu_coord hInt_pair hInt_div
      hflux
  have hzero : ∫ x, div u x * p x ∂volume = 0 := by
    have hz :
        (fun x => div u x * p x) = fun _ => 0 := by
      funext x
      simp [hdiv x]
    rw [hz]
    exact integral_zero (α := T3) (G := ℝ) (μ := volume)
  rw [hfun, hibp, hzero, neg_zero]

/-- Mixed partials of a `C²` scalar: `∂ⱼ (∇p)ᵢ = D²p (eⱼ, eᵢ)`. -/
public theorem directionalCoord_pressureGradient
    (p : PressureField) (x : T3) (i j : Fin 3)
    (hp : ContDiffAt ℝ 2 p x) :
    directionalCoord (pressureGradient p) i j x =
      (fderiv ℝ (fderiv ℝ p) x) (EuclideanSpace.single j 1) (EuclideanSpace.single i 1) := by
  unfold directionalCoord pressureGradient
  have hfd : DifferentiableAt ℝ (fderiv ℝ p) x :=
    (hp.fderiv_right (m := 1) (by norm_num)).differentiableAt (by norm_num)
  -- `ContDiffAt.eventually` needs a finite order and returns `ContDiffAt`,
  -- not `DifferentiableAt`. Bare `∞` is `ℝ≥0∞`; write `⊤` or let `simp`
  -- infer `WithTop ℕ∞`. There is no `DifferentiableAt.eventually`.
  have hnear : ∀ᶠ y in nhds x, DifferentiableAt ℝ p y := by
    have hp1 : ContDiffAt ℝ 1 p x :=
      hp.of_le (by norm_num : (1 : WithTop ℕ∞) ≤ 2)
    filter_upwards [hp1.eventually (by simp)] with y hy
    exact hy.differentiableAt_one
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

/-- Coordinates of `curl` (standard orientation). -/
public theorem curl_apply (u : VelocityField) (x : T3) :
    curl u x 0 = directionalCoord u 2 1 x - directionalCoord u 1 2 x ∧
    curl u x 1 = directionalCoord u 0 2 x - directionalCoord u 2 0 x ∧
    curl u x 2 = directionalCoord u 1 0 x - directionalCoord u 0 1 x := by
  refine ⟨?_, ?_, ?_⟩
  · simp [curl]
  · simp [curl]
  · simp [curl]

/-- Curl is linear at points where both fields have differentiable coordinates. -/
public theorem curl_add (u v : VelocityField) (x : T3)
    (hu : ∀ i, DifferentiableAt ℝ (fun y => u y i) x)
    (hv : ∀ i, DifferentiableAt ℝ (fun y => v y i) x) :
    curl (fun y => u y + v y) x = curl u x + curl v x := by
  have hfun : ∀ i,
      (fun y => (u y + v y) i) = fun y => u y i + v y i := by
    intro i
    funext y
    rw [PiLp.add_apply]
  have hdir : ∀ comp dir,
      directionalCoord (fun y => u y + v y) comp dir x =
        directionalCoord u comp dir x + directionalCoord v comp dir x := by
    intro comp dir
    unfold directionalCoord
    rw [hfun, fderiv_fun_add (hu comp) (hv comp)]
    simp [ContinuousLinearMap.add_apply]
  ext i
  fin_cases i <;> simp [curl, hdir, PiLp.add_apply] <;> ring

/-- Coordinate of `(u · ∇)v` is the directional derivative of that coordinate
along `u`. C¹ of `v`. -/
public theorem convective_coord (u v : VelocityField) (x : T3) (i : Fin 3)
    (hv : DifferentiableAt ℝ v x) :
    convective u v x i = (fderiv ℝ (fun y => v y i) x) (u x) := by
  unfold convective
  let L : EuclideanSpace ℝ (Fin 3) →L[ℝ] ℝ :=
    PiLp.proj (p := 2) (fun _ : Fin 3 => ℝ) i
  have hL : HasFDerivAt (fun y => L (v y)) (L.comp (fderiv ℝ v x)) x :=
    (L.hasFDerivAt).comp x hv.hasFDerivAt
  have hf : fderiv ℝ (fun y => v y i) x = L.comp (fderiv ℝ v x) := by
    change fderiv ℝ (fun y => L (v y)) x = _
    exact hL.fderiv
  rw [hf]
  rfl

/-- `(u · ∇)v` expands as `∑_k u_k ∂_k v`. -/
public theorem convective_eq_sum_directional
    (u v : VelocityField) (x : T3) (i : Fin 3)
    (hv : DifferentiableAt ℝ v x)
    (_hvi : DifferentiableAt ℝ (fun y => v y i) x) :
    convective u v x i =
      ∑ k : Fin 3, directionalCoord v i k x * u x k := by
  rw [convective_coord u v x i hv]
  have hdecomp :
      u x = ∑ k : Fin 3, u x k • EuclideanSpace.single k 1 := by
    ext j
    simp [Finset.sum_apply, smul_eq_mul, EuclideanSpace.single, Pi.single_apply,
      Finset.sum_ite_eq, Finset.mem_univ]
  have hmap : ∀ k,
      (fderiv ℝ (fun y => v y i) x) (u x k • EuclideanSpace.single k 1) =
        directionalCoord v i k x * u x k := by
    intro k
    rw [ContinuousLinearMap.map_smul, smul_eq_mul, directionalCoord, mul_comm]
  calc
    (fderiv ℝ (fun y => v y i) x) (u x)
        = (fderiv ℝ (fun y => v y i) x)
            (∑ k : Fin 3, u x k • EuclideanSpace.single k 1) := by
          conv_lhs => rw [hdecomp]
    _ = ∑ k : Fin 3,
          (fderiv ℝ (fun y => v y i) x)
            (u x k • EuclideanSpace.single k 1) := by
          simp [map_sum]
    _ = ∑ k : Fin 3, directionalCoord v i k x * u x k := by
          refine Finset.sum_congr rfl fun k _ => hmap k

/-- Mixed partials of a coordinate: `∂ⱼ (∂ᵢ u_k) = D² u_k (eⱼ, eᵢ)`. -/
public theorem fderiv_directionalCoord
    (u : VelocityField) (x : T3) (comp i j : Fin 3)
    (hu : ContDiffAt ℝ 2 (fun y => u y comp) x) :
    (fderiv ℝ (fun y => directionalCoord u comp i y) x) (EuclideanSpace.single j 1) =
      (fderiv ℝ (fderiv ℝ (fun y => u y comp)) x)
        (EuclideanSpace.single j 1) (EuclideanSpace.single i 1) := by
  unfold directionalCoord
  have hfd : DifferentiableAt ℝ (fderiv ℝ (fun y => u y comp)) x :=
    (hu.fderiv_right (m := 1) (by norm_num)).differentiableAt (by norm_num)
  have hcomp :
      fderiv ℝ (fun y =>
          (fderiv ℝ (fun z => u z comp) y) (EuclideanSpace.single i 1)) x =
        (ContinuousLinearMap.apply ℝ ℝ (EuclideanSpace.single i 1)).comp
          (fderiv ℝ (fderiv ℝ (fun z => u z comp)) x) := by
    change fderiv ℝ (fun y =>
        (ContinuousLinearMap.apply ℝ ℝ (EuclideanSpace.single i 1))
          (fderiv ℝ (fun z => u z comp) y)) x = _
    rw [fderiv_comp' x (ContinuousLinearMap.differentiableAt _) hfd]
    simp [ContinuousLinearMap.fderiv]
  rw [hcomp]
  rfl

/-- Equality of mixed partials on a `C²` coordinate. -/
public theorem directionalCoord_symm
    (u : VelocityField) (x : T3) (comp i j : Fin 3)
    (hu : ContDiffAt ℝ 2 (fun y => u y comp) x) :
    (fderiv ℝ (fun y => directionalCoord u comp i y) x) (EuclideanSpace.single j 1) =
      (fderiv ℝ (fun y => directionalCoord u comp j y) x) (EuclideanSpace.single i 1) := by
  have hsymm : IsSymmSndFDerivAt ℝ (fun y => u y comp) x :=
    hu.isSymmSndFDerivAt (by simp [minSmoothness_of_isRCLikeNormedField])
  rw [fderiv_directionalCoord u x comp i j hu,
      fderiv_directionalCoord u x comp j i hu]
  exact hsymm.eq (EuclideanSpace.single j 1) (EuclideanSpace.single i 1)

/-- `directionalCoord` of a `C²` coordinate is differentiable (it is `C¹`). -/
public theorem differentiableAt_directionalCoord
    (u : VelocityField) (x : T3) (comp i : Fin 3)
    (hu : ContDiffAt ℝ 2 (fun y => u y comp) x) :
    DifferentiableAt ℝ (fun y => directionalCoord u comp i y) x := by
  unfold directionalCoord
  have hfd : DifferentiableAt ℝ (fderiv ℝ (fun y => u y comp)) x :=
    (hu.fderiv_right (m := 1) (by norm_num)).differentiableAt (by norm_num)
  exact (ContinuousLinearMap.apply ℝ ℝ (EuclideanSpace.single i 1)).differentiableAt.comp x hfd

/-- `div ∘ curl = 0` at `C²` points (equality of mixed partials). -/
public theorem div_curl (u : VelocityField) (x : T3)
    (hu : ∀ k : Fin 3, ContDiffAt ℝ 2 (fun y => u y k) x) :
    div (curl u) x = 0 := by
  have h0 : (fun y => curl u y 0) =
      fun y => directionalCoord u 2 1 y - directionalCoord u 1 2 y := by
    funext y
    exact (curl_apply u y).1
  have h1 : (fun y => curl u y 1) =
      fun y => directionalCoord u 0 2 y - directionalCoord u 2 0 y := by
    funext y
    exact (curl_apply u y).2.1
  have h2 : (fun y => curl u y 2) =
      fun y => directionalCoord u 1 0 y - directionalCoord u 0 1 y := by
    funext y
    exact (curl_apply u y).2.2
  have hC1 (comp i : Fin 3) :
      DifferentiableAt ℝ (fun y => directionalCoord u comp i y) x :=
    differentiableAt_directionalCoord u x comp i (hu comp)
  have hsub0 :
      fderiv ℝ (fun y => curl u y 0) x =
        fderiv ℝ (fun y => directionalCoord u 2 1 y) x -
          fderiv ℝ (fun y => directionalCoord u 1 2 y) x := by
    rw [h0, fderiv_fun_sub (hC1 2 1) (hC1 1 2)]
  have hsub1 :
      fderiv ℝ (fun y => curl u y 1) x =
        fderiv ℝ (fun y => directionalCoord u 0 2 y) x -
          fderiv ℝ (fun y => directionalCoord u 2 0 y) x := by
    rw [h1, fderiv_fun_sub (hC1 0 2) (hC1 2 0)]
  have hsub2 :
      fderiv ℝ (fun y => curl u y 2) x =
        fderiv ℝ (fun y => directionalCoord u 1 0 y) x -
          fderiv ℝ (fun y => directionalCoord u 0 1 y) x := by
    rw [h2, fderiv_fun_sub (hC1 1 0) (hC1 0 1)]
  have hAD := directionalCoord_symm u x 2 1 0 (hu 2)
  have hBE := directionalCoord_symm u x 1 2 0 (hu 1)
  have hCF := directionalCoord_symm u x 0 2 1 (hu 0)
  have hsum :
      (fderiv ℝ (fun y => curl u y 0) x) (EuclideanSpace.single 0 1) +
        (fderiv ℝ (fun y => curl u y 1) x) (EuclideanSpace.single 1 1) +
          (fderiv ℝ (fun y => curl u y 2) x) (EuclideanSpace.single 2 1) = 0 := by
    rw [hsub0, hsub1, hsub2]
    simp only [ContinuousLinearMap.sub_apply]
    rw [hAD, hBE, hCF]
    ring
  unfold div
  rw [Fin.sum_univ_succ, Fin.sum_univ_succ, Fin.sum_univ_one, ← add_assoc]
  exact hsum

/-- A field that is a `C²` curl is pointwise divergence-free. -/
public theorem div_of_eq_curl (u A : VelocityField)
    (hA : ∀ x k, ContDiffAt ℝ 2 (fun y => A y k) x)
    (hcurl : u = curl A) :
    ∀ x, div u x = 0 := by
  intro x
  rw [hcurl]
  exact div_curl A x (fun k => hA x k)

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

/-- Spatial partial of `(u · ∇)u` by the product rule. C² of each coordinate
(paper §2.1 expansion of the stretching term). -/
public theorem directionalCoord_convective
    (u : VelocityField) (x : T3) (comp dir : Fin 3)
    (hu : ∀ k, ContDiffAt ℝ 2 (fun y => u y k) x) :
    directionalCoord (convective u u) comp dir x =
      ∑ k : Fin 3,
        ((fderiv ℝ (fun y => directionalCoord u comp k y) x)
            (EuclideanSpace.single dir 1) * u x k +
          directionalCoord u comp k x * directionalCoord u k dir x) := by
  have hC1 : ∀ k, DifferentiableAt ℝ (fun y => u y k) x :=
    fun k =>
      ((hu k).of_le (by norm_num : (1 : WithTop ℕ∞) ≤ 2)).differentiableAt_one
  have hnear : ∀ k, ∀ᶠ y in nhds x, DifferentiableAt ℝ (fun z => u z k) y := by
    intro k
    have hk1 : ContDiffAt ℝ 1 (fun y => u y k) x :=
      (hu k).of_le (by norm_num : (1 : WithTop ℕ∞) ≤ 2)
    filter_upwards [hk1.eventually (by simp)] with y hy
    exact hy.differentiableAt_one
  have hvnear : ∀ᶠ y in nhds x, DifferentiableAt ℝ u y := by
    filter_upwards [hnear 0, hnear 1, hnear 2] with y h0 h1 h2
    exact (differentiableAt_piLp (p := 2) (𝕜 := ℝ)
        (E := fun _ : Fin 3 => ℝ)).mpr (fun i => by
      fin_cases i
      · exact h0
      · exact h1
      · exact h2)
  have heq :
      (fun y => convective u u y comp) =ᶠ[nhds x]
        fun y => ∑ k : Fin 3, directionalCoord u comp k y * u y k := by
    filter_upwards [hvnear, hnear comp] with y hyu hyc
    exact convective_eq_sum_directional u u y comp hyu hyc
  have hf :
      fderiv ℝ (fun y : T3 => convective u u y comp) x =
        fderiv ℝ (fun y : T3 => ∑ k : Fin 3, directionalCoord u comp k y * u y k) x :=
    heq.fderiv_eq
  unfold directionalCoord
  rw [hf]
  have hCLM :
      fderiv ℝ (fun y : T3 => ∑ k : Fin 3, directionalCoord u comp k y * u y k) x =
        ∑ k : Fin 3, fderiv ℝ (fun y => directionalCoord u comp k y * u y k) x :=
    fderiv_fun_sum (fun k (_ : k ∈ (Finset.univ : Finset (Fin 3))) =>
      (differentiableAt_directionalCoord u x comp k (hu comp)).mul (hC1 k))
  rw [hCLM]
  simp only [ContinuousLinearMap.sum_apply]
  refine Finset.sum_congr rfl fun k _ => ?_
  have hmul :
      fderiv ℝ (fun y => directionalCoord u comp k y * u y k) x =
        directionalCoord u comp k x • fderiv ℝ (fun y => u y k) x +
          u x k • fderiv ℝ (fun y => directionalCoord u comp k y) x :=
    fderiv_fun_mul (differentiableAt_directionalCoord u x comp k (hu comp)) (hC1 k)
  rw [hmul]
  simp [ContinuousLinearMap.add_apply, ContinuousLinearMap.smul_apply, smul_eq_mul,
    directionalCoord]
  ring

/-- `∑_{k : Fin 3} f k = f 0 + f 1 + f 2`. -/
public theorem sum_univ_fin3 (f : Fin 3 → ℝ) :
    ∑ k : Fin 3, f k = f 0 + f 1 + f 2 := by
  have huniv : (Finset.univ : Finset (Fin 3)) = {0, 1, 2} := by
    ext i
    fin_cases i <;> simp
  rw [huniv]
  simp [Finset.sum_insert]
  rw [← add_assoc]

/-- C² of coordinates implies C¹ of the field. -/
public theorem differentiableAt_of_contDiffAt_coords
    (u : VelocityField) (x : T3)
    (hu : ∀ k, ContDiffAt ℝ 2 (fun y => u y k) x) :
    DifferentiableAt ℝ u x :=
  (differentiableAt_piLp (p := 2) (𝕜 := ℝ) (E := fun _ : Fin 3 => ℝ)).mpr
    (fun i => ((hu i).of_le (by norm_num : (1 : WithTop ℕ∞) ≤ 2)).differentiableAt_one)

/-- Each `curl` coordinate is C¹ at a C² point of `u`. -/
public theorem differentiableAt_curl_coord
    (u : VelocityField) (x : T3) (i : Fin 3)
    (hu : ∀ k, ContDiffAt ℝ 2 (fun y => u y k) x) :
    DifferentiableAt ℝ (fun y => curl u y i) x := by
  fin_cases i
  · change DifferentiableAt ℝ (fun y => curl u y 0) x
    have h0 : (fun y => curl u y 0) =
        fun y => directionalCoord u 2 1 y - directionalCoord u 1 2 y := by
      funext y
      exact (curl_apply u y).1
    rw [h0]
    exact (differentiableAt_directionalCoord u x 2 1 (hu 2)).sub
      (differentiableAt_directionalCoord u x 1 2 (hu 1))
  · change DifferentiableAt ℝ (fun y => curl u y 1) x
    have h1 : (fun y => curl u y 1) =
        fun y => directionalCoord u 0 2 y - directionalCoord u 2 0 y := by
      funext y
      exact (curl_apply u y).2.1
    rw [h1]
    exact (differentiableAt_directionalCoord u x 0 2 (hu 0)).sub
      (differentiableAt_directionalCoord u x 2 0 (hu 2))
  · change DifferentiableAt ℝ (fun y => curl u y 2) x
    have h2 : (fun y => curl u y 2) =
        fun y => directionalCoord u 1 0 y - directionalCoord u 0 1 y := by
      funext y
      exact (curl_apply u y).2.2
    rw [h2]
    exact (differentiableAt_directionalCoord u x 1 0 (hu 1)).sub
      (differentiableAt_directionalCoord u x 0 1 (hu 0))

/-- `curl u` is C¹ at a C² point of `u`. -/
public theorem differentiableAt_curl
    (u : VelocityField) (x : T3)
    (hu : ∀ k, ContDiffAt ℝ 2 (fun y => u y k) x) :
    DifferentiableAt ℝ (curl u) x :=
  (differentiableAt_piLp (p := 2) (𝕜 := ℝ) (E := fun _ : Fin 3 => ℝ)).mpr
    (fun i => differentiableAt_curl_coord u x i hu)

/-- Spatial partials of `curl` coordinates at a `C²` point. -/
public theorem directionalCoord_curl
    (u : VelocityField) (x : T3) (dir : Fin 3)
    (hu : ∀ k, ContDiffAt ℝ 2 (fun y => u y k) x) :
    directionalCoord (curl u) 0 dir x =
      (fderiv ℝ (fun y => directionalCoord u 2 1 y) x) (EuclideanSpace.single dir 1) -
        (fderiv ℝ (fun y => directionalCoord u 1 2 y) x) (EuclideanSpace.single dir 1) ∧
    directionalCoord (curl u) 1 dir x =
      (fderiv ℝ (fun y => directionalCoord u 0 2 y) x) (EuclideanSpace.single dir 1) -
        (fderiv ℝ (fun y => directionalCoord u 2 0 y) x) (EuclideanSpace.single dir 1) ∧
    directionalCoord (curl u) 2 dir x =
      (fderiv ℝ (fun y => directionalCoord u 1 0 y) x) (EuclideanSpace.single dir 1) -
        (fderiv ℝ (fun y => directionalCoord u 0 1 y) x) (EuclideanSpace.single dir 1) := by
  have hC1 (comp i : Fin 3) :
      DifferentiableAt ℝ (fun y => directionalCoord u comp i y) x :=
    differentiableAt_directionalCoord u x comp i (hu comp)
  have h0 : (fun y => curl u y 0) =
      fun y => directionalCoord u 2 1 y - directionalCoord u 1 2 y := by
    funext y
    exact (curl_apply u y).1
  have h1 : (fun y => curl u y 1) =
      fun y => directionalCoord u 0 2 y - directionalCoord u 2 0 y := by
    funext y
    exact (curl_apply u y).2.1
  have h2 : (fun y => curl u y 2) =
      fun y => directionalCoord u 1 0 y - directionalCoord u 0 1 y := by
    funext y
    exact (curl_apply u y).2.2
  refine ⟨?_, ?_, ?_⟩
  · change (fderiv ℝ (fun y => curl u y 0) x) (EuclideanSpace.single dir 1) = _
    rw [h0, fderiv_fun_sub (hC1 2 1) (hC1 1 2)]
    simp [ContinuousLinearMap.sub_apply]
  · change (fderiv ℝ (fun y => curl u y 1) x) (EuclideanSpace.single dir 1) = _
    rw [h1, fderiv_fun_sub (hC1 0 2) (hC1 2 0)]
    simp [ContinuousLinearMap.sub_apply]
  · change (fderiv ℝ (fun y => curl u y 2) x) (EuclideanSpace.single dir 1) = _
    rw [h2, fderiv_fun_sub (hC1 1 0) (hC1 0 1)]
    simp [ContinuousLinearMap.sub_apply]

/-- Paper §2.1 vector identity at a `C²` point, before imposing `div u = 0`.
`div (curl u) = 0` is already used via mixed partials, so the remaining
stretching identity is
`curl((u·∇)u) = (u·∇)ω − (ω·∇)u + (div u) ω`. -/
public theorem curl_convective
    (u : VelocityField) (x : T3)
    (hu : ∀ k, ContDiffAt ℝ 2 (fun y => u y k) x) :
    curl (convective u u) x =
      convective u (curl u) x - convective (curl u) u x + div u x • curl u x := by
  have hC1 : ∀ k, DifferentiableAt ℝ (fun y => u y k) x :=
    fun k =>
      ((hu k).of_le (by norm_num : (1 : WithTop ℕ∞) ≤ 2)).differentiableAt_one
  have hDiffU : DifferentiableAt ℝ u x :=
    differentiableAt_of_contDiffAt_coords u x hu
  have hDiffCurl : DifferentiableAt ℝ (curl u) x :=
    differentiableAt_curl u x hu
  have htrans0 :
      convective u (curl u) x 0 =
        ∑ k : Fin 3, directionalCoord (curl u) 0 k x * u x k :=
    convective_eq_sum_directional u (curl u) x 0 hDiffCurl
      (differentiableAt_curl_coord u x 0 hu)
  have htrans1 :
      convective u (curl u) x 1 =
        ∑ k : Fin 3, directionalCoord (curl u) 1 k x * u x k :=
    convective_eq_sum_directional u (curl u) x 1 hDiffCurl
      (differentiableAt_curl_coord u x 1 hu)
  have htrans2 :
      convective u (curl u) x 2 =
        ∑ k : Fin 3, directionalCoord (curl u) 2 k x * u x k :=
    convective_eq_sum_directional u (curl u) x 2 hDiffCurl
      (differentiableAt_curl_coord u x 2 hu)
  have hstretch0 :
      convective (curl u) u x 0 =
        ∑ k : Fin 3, directionalCoord u 0 k x * curl u x k :=
    convective_eq_sum_directional (curl u) u x 0 hDiffU (hC1 0)
  have hstretch1 :
      convective (curl u) u x 1 =
        ∑ k : Fin 3, directionalCoord u 1 k x * curl u x k :=
    convective_eq_sum_directional (curl u) u x 1 hDiffU (hC1 1)
  have hstretch2 :
      convective (curl u) u x 2 =
        ∑ k : Fin 3, directionalCoord u 2 k x * curl u x k :=
    convective_eq_sum_directional (curl u) u x 2 hDiffU (hC1 2)
  have hω := curl_apply u x
  have hdiv : div u x =
      directionalCoord u 0 0 x + directionalCoord u 1 1 x + directionalCoord u 2 2 x := by
    unfold div directionalCoord
    rw [sum_univ_fin3]
  ext i
  fin_cases i
  · -- component 0: paper stretching identity
    have hL := directionalCoord_convective u x 2 1 hu
    have hR := directionalCoord_convective u x 1 2 hu
    have hcurl0 := (curl_apply (convective u u) x).1
    have hswap2k (k : Fin 3) := directionalCoord_symm u x 2 k 1 (hu 2)
    have hswap1k (k : Fin 3) := directionalCoord_symm u x 1 k 2 (hu 1)
    have hdc := directionalCoord_curl u x
    have hdomega (k : Fin 3) :
        directionalCoord (curl u) 0 k x =
          (fderiv ℝ (fun y => directionalCoord u 2 1 y) x) (EuclideanSpace.single k 1) -
            (fderiv ℝ (fun y => directionalCoord u 1 2 y) x) (EuclideanSpace.single k 1) :=
      (hdc k hu).1
    have hfirst :
        ∑ k : Fin 3,
            ((fderiv ℝ (fun y => directionalCoord u 2 k y) x)
                (EuclideanSpace.single 1 1) * u x k -
              (fderiv ℝ (fun y => directionalCoord u 1 k y) x)
                (EuclideanSpace.single 2 1) * u x k) =
          convective u (curl u) x 0 := by
      have hterm (k : Fin 3) :
          (fderiv ℝ (fun y => directionalCoord u 2 k y) x)
              (EuclideanSpace.single 1 1) * u x k -
            (fderiv ℝ (fun y => directionalCoord u 1 k y) x)
              (EuclideanSpace.single 2 1) * u x k =
            directionalCoord (curl u) 0 k x * u x k := by
        rw [hswap2k k, hswap1k k, hdomega k]
        ring
      calc
        ∑ k : Fin 3,
              ((fderiv ℝ (fun y => directionalCoord u 2 k y) x)
                  (EuclideanSpace.single 1 1) * u x k -
                (fderiv ℝ (fun y => directionalCoord u 1 k y) x)
                  (EuclideanSpace.single 2 1) * u x k)
            = ∑ k : Fin 3, directionalCoord (curl u) 0 k x * u x k := by
              refine Finset.sum_congr rfl fun k _ => hterm k
        _ = convective u (curl u) x 0 := htrans0.symm
    have hS :
        ∑ k : Fin 3,
            (directionalCoord u 2 k x * directionalCoord u k 1 x -
              directionalCoord u 1 k x * directionalCoord u k 2 x) =
          -convective (curl u) u x 0 + div u x * curl u x 0 := by
      rw [sum_univ_fin3, hstretch0, sum_univ_fin3, hdiv, hω.1, hω.2.1, hω.2.2]
      ring
    calc
      curl (convective u u) x 0
          = directionalCoord (convective u u) 2 1 x -
              directionalCoord (convective u u) 1 2 x := hcurl0
      _ = (∑ k : Fin 3,
              ((fderiv ℝ (fun y => directionalCoord u 2 k y) x)
                  (EuclideanSpace.single 1 1) * u x k +
                directionalCoord u 2 k x * directionalCoord u k 1 x)) -
            (∑ k : Fin 3,
              ((fderiv ℝ (fun y => directionalCoord u 1 k y) x)
                  (EuclideanSpace.single 2 1) * u x k +
                directionalCoord u 1 k x * directionalCoord u k 2 x)) := by
            rw [hL, hR]
      _ = (∑ k : Fin 3,
              ((fderiv ℝ (fun y => directionalCoord u 2 k y) x)
                  (EuclideanSpace.single 1 1) * u x k -
                (fderiv ℝ (fun y => directionalCoord u 1 k y) x)
                  (EuclideanSpace.single 2 1) * u x k)) +
            ∑ k : Fin 3,
              (directionalCoord u 2 k x * directionalCoord u k 1 x -
                directionalCoord u 1 k x * directionalCoord u k 2 x) := by
            simp only [Finset.sum_add_distrib, Finset.sum_sub_distrib]
            ring
      _ = convective u (curl u) x 0 +
            (-convective (curl u) u x 0 + div u x * curl u x 0) := by
            rw [hfirst, hS]
      _ = (convective u (curl u) x - convective (curl u) u x +
            div u x • curl u x) 0 := by
            simp [PiLp.sub_apply, PiLp.add_apply, smul_eq_mul]
            ring
  · -- component 1
    have hL := directionalCoord_convective u x 0 2 hu
    have hR := directionalCoord_convective u x 2 0 hu
    have hcurl1 := (curl_apply (convective u u) x).2.1
    have hswap0k (k : Fin 3) := directionalCoord_symm u x 0 k 2 (hu 0)
    have hswap2k (k : Fin 3) := directionalCoord_symm u x 2 k 0 (hu 2)
    have hdc := directionalCoord_curl u x
    have hdomega (k : Fin 3) :
        directionalCoord (curl u) 1 k x =
          (fderiv ℝ (fun y => directionalCoord u 0 2 y) x) (EuclideanSpace.single k 1) -
            (fderiv ℝ (fun y => directionalCoord u 2 0 y) x) (EuclideanSpace.single k 1) :=
      (hdc k hu).2.1
    have hfirst :
        ∑ k : Fin 3,
            ((fderiv ℝ (fun y => directionalCoord u 0 k y) x)
                (EuclideanSpace.single 2 1) * u x k -
              (fderiv ℝ (fun y => directionalCoord u 2 k y) x)
                (EuclideanSpace.single 0 1) * u x k) =
          convective u (curl u) x 1 := by
      have hterm (k : Fin 3) :
          (fderiv ℝ (fun y => directionalCoord u 0 k y) x)
              (EuclideanSpace.single 2 1) * u x k -
            (fderiv ℝ (fun y => directionalCoord u 2 k y) x)
              (EuclideanSpace.single 0 1) * u x k =
            directionalCoord (curl u) 1 k x * u x k := by
        rw [hswap0k k, hswap2k k, hdomega k]
        ring
      calc
        ∑ k : Fin 3,
              ((fderiv ℝ (fun y => directionalCoord u 0 k y) x)
                  (EuclideanSpace.single 2 1) * u x k -
                (fderiv ℝ (fun y => directionalCoord u 2 k y) x)
                  (EuclideanSpace.single 0 1) * u x k)
            = ∑ k : Fin 3, directionalCoord (curl u) 1 k x * u x k := by
              refine Finset.sum_congr rfl fun k _ => hterm k
        _ = convective u (curl u) x 1 := htrans1.symm
    have hS :
        ∑ k : Fin 3,
            (directionalCoord u 0 k x * directionalCoord u k 2 x -
              directionalCoord u 2 k x * directionalCoord u k 0 x) =
          -convective (curl u) u x 1 + div u x * curl u x 1 := by
      rw [sum_univ_fin3, hstretch1, sum_univ_fin3, hdiv, hω.1, hω.2.1, hω.2.2]
      ring
    calc
      curl (convective u u) x 1
          = directionalCoord (convective u u) 0 2 x -
              directionalCoord (convective u u) 2 0 x := hcurl1
      _ = (∑ k : Fin 3,
              ((fderiv ℝ (fun y => directionalCoord u 0 k y) x)
                  (EuclideanSpace.single 2 1) * u x k +
                directionalCoord u 0 k x * directionalCoord u k 2 x)) -
            (∑ k : Fin 3,
              ((fderiv ℝ (fun y => directionalCoord u 2 k y) x)
                  (EuclideanSpace.single 0 1) * u x k +
                directionalCoord u 2 k x * directionalCoord u k 0 x)) := by
            rw [hL, hR]
      _ = (∑ k : Fin 3,
              ((fderiv ℝ (fun y => directionalCoord u 0 k y) x)
                  (EuclideanSpace.single 2 1) * u x k -
                (fderiv ℝ (fun y => directionalCoord u 2 k y) x)
                  (EuclideanSpace.single 0 1) * u x k)) +
            ∑ k : Fin 3,
              (directionalCoord u 0 k x * directionalCoord u k 2 x -
                directionalCoord u 2 k x * directionalCoord u k 0 x) := by
            simp only [Finset.sum_add_distrib, Finset.sum_sub_distrib]
            ring
      _ = convective u (curl u) x 1 +
            (-convective (curl u) u x 1 + div u x * curl u x 1) := by
            rw [hfirst, hS]
      _ = (convective u (curl u) x - convective (curl u) u x +
            div u x • curl u x) 1 := by
            simp [PiLp.sub_apply, PiLp.add_apply, smul_eq_mul]
            ring
  · -- component 2
    have hL := directionalCoord_convective u x 1 0 hu
    have hR := directionalCoord_convective u x 0 1 hu
    have hcurl2 := (curl_apply (convective u u) x).2.2
    have hswap1k (k : Fin 3) := directionalCoord_symm u x 1 k 0 (hu 1)
    have hswap0k (k : Fin 3) := directionalCoord_symm u x 0 k 1 (hu 0)
    have hdc := directionalCoord_curl u x
    have hdomega (k : Fin 3) :
        directionalCoord (curl u) 2 k x =
          (fderiv ℝ (fun y => directionalCoord u 1 0 y) x) (EuclideanSpace.single k 1) -
            (fderiv ℝ (fun y => directionalCoord u 0 1 y) x) (EuclideanSpace.single k 1) :=
      (hdc k hu).2.2
    have hfirst :
        ∑ k : Fin 3,
            ((fderiv ℝ (fun y => directionalCoord u 1 k y) x)
                (EuclideanSpace.single 0 1) * u x k -
              (fderiv ℝ (fun y => directionalCoord u 0 k y) x)
                (EuclideanSpace.single 1 1) * u x k) =
          convective u (curl u) x 2 := by
      have hterm (k : Fin 3) :
          (fderiv ℝ (fun y => directionalCoord u 1 k y) x)
              (EuclideanSpace.single 0 1) * u x k -
            (fderiv ℝ (fun y => directionalCoord u 0 k y) x)
              (EuclideanSpace.single 1 1) * u x k =
            directionalCoord (curl u) 2 k x * u x k := by
        rw [hswap1k k, hswap0k k, hdomega k]
        ring
      calc
        ∑ k : Fin 3,
              ((fderiv ℝ (fun y => directionalCoord u 1 k y) x)
                  (EuclideanSpace.single 0 1) * u x k -
                (fderiv ℝ (fun y => directionalCoord u 0 k y) x)
                  (EuclideanSpace.single 1 1) * u x k)
            = ∑ k : Fin 3, directionalCoord (curl u) 2 k x * u x k := by
              refine Finset.sum_congr rfl fun k _ => hterm k
        _ = convective u (curl u) x 2 := htrans2.symm
    have hS :
        ∑ k : Fin 3,
            (directionalCoord u 1 k x * directionalCoord u k 0 x -
              directionalCoord u 0 k x * directionalCoord u k 1 x) =
          -convective (curl u) u x 2 + div u x * curl u x 2 := by
      rw [sum_univ_fin3, hstretch2, sum_univ_fin3, hdiv, hω.1, hω.2.1, hω.2.2]
      ring
    calc
      curl (convective u u) x 2
          = directionalCoord (convective u u) 1 0 x -
              directionalCoord (convective u u) 0 1 x := hcurl2
      _ = (∑ k : Fin 3,
              ((fderiv ℝ (fun y => directionalCoord u 1 k y) x)
                  (EuclideanSpace.single 0 1) * u x k +
                directionalCoord u 1 k x * directionalCoord u k 0 x)) -
            (∑ k : Fin 3,
              ((fderiv ℝ (fun y => directionalCoord u 0 k y) x)
                  (EuclideanSpace.single 1 1) * u x k +
                directionalCoord u 0 k x * directionalCoord u k 1 x)) := by
            rw [hL, hR]
      _ = (∑ k : Fin 3,
              ((fderiv ℝ (fun y => directionalCoord u 1 k y) x)
                  (EuclideanSpace.single 0 1) * u x k -
                (fderiv ℝ (fun y => directionalCoord u 0 k y) x)
                  (EuclideanSpace.single 1 1) * u x k)) +
            ∑ k : Fin 3,
              (directionalCoord u 1 k x * directionalCoord u k 0 x -
                directionalCoord u 0 k x * directionalCoord u k 1 x) := by
            simp only [Finset.sum_add_distrib, Finset.sum_sub_distrib]
            ring
      _ = convective u (curl u) x 2 +
            (-convective (curl u) u x 2 + div u x * curl u x 2) := by
            rw [hfirst, hS]
      _ = (convective u (curl u) x - convective (curl u) u x +
            div u x • curl u x) 2 := by
            simp [PiLp.sub_apply, PiLp.add_apply, smul_eq_mul]
            ring

/-- Paper §2.1 after `div u = 0` (and `div ω = 0` from C² mixed partials):
`∇ × (u·∇)u = (u·∇)ω − (ω·∇)u`. -/
public theorem curl_convective_div_free
    (u : VelocityField) (x : T3)
    (hu : ∀ k, ContDiffAt ℝ 2 (fun y => u y k) x)
    (hdiv : div u x = 0) :
    curl (convective u u) x =
      convective u (curl u) x - convective (curl u) u x := by
  have h := curl_convective u x hu
  rw [h, hdiv, zero_smul, add_zero]

/-- Curl of a three-term sum. C¹ of each field's coordinates.
`hbc` is C¹ of the `v+w` coordinates, so `curl_add` applies twice.
`add_assoc` is the `AddCommGroup` law on `EuclideanSpace ℝ (Fin 3)`
(inherited by `PiLp`); on each slot it is `PiLp.add_apply` then `add_assoc` on `ℝ`.
The identity is checked on curl components `0, 1, 2`. -/
public theorem curl_add3 (u v w : VelocityField) (x : T3)
    (hu : ∀ i, DifferentiableAt ℝ (fun y => u y i) x)
    (hv : ∀ i, DifferentiableAt ℝ (fun y => v y i) x)
    (hw : ∀ i, DifferentiableAt ℝ (fun y => w y i) x) :
    curl (fun y => u y + v y + w y) x = curl u x + curl v x + curl w x := by
  have hbc : ∀ i, DifferentiableAt ℝ (fun y => (v y + w y) i) x := by
    intro i
    have hfun : (fun y => (v y + w y) i) = fun y => v y i + w y i := by
      funext y
      rw [PiLp.add_apply]
    rw [hfun]
    exact (hv i).add (hw i)
  have hassoc : (fun y => u y + v y + w y) = fun y => u y + (v y + w y) := by
    funext y
    exact add_assoc (u y) (v y) (w y)
  have hdir (comp dir : Fin 3) :
      directionalCoord (fun y => u y + v y + w y) comp dir x =
        directionalCoord u comp dir x + directionalCoord v comp dir x +
          directionalCoord w comp dir x := by
    have hfun : (fun y => (u y + v y + w y) comp) =
        fun y => u y comp + (v y + w y) comp := by
      funext y
      rw [add_assoc (u y) (v y) (w y), PiLp.add_apply]
    have hbcfun : (fun y => (v y + w y) comp) =
        fun y => v y comp + w y comp := by
      funext y
      rw [PiLp.add_apply]
    unfold directionalCoord
    rw [hfun, fderiv_fun_add (hu comp) (hbc comp), hbcfun,
      fderiv_fun_add (hv comp) (hw comp)]
    simp only [ContinuousLinearMap.add_apply]
    ring
  -- Curl components 0, 1, 2: each is `∂_j u_k − ∂_k u_j`, and `hdir` splits.
  have hsum0 := (curl_apply (fun y => u y + v y + w y) x).1
  have hsum1 := (curl_apply (fun y => u y + v y + w y) x).2.1
  have hsum2 := (curl_apply (fun y => u y + v y + w y) x).2.2
  have hu0 := (curl_apply u x).1
  have hu1 := (curl_apply u x).2.1
  have hu2 := (curl_apply u x).2.2
  have hv0 := (curl_apply v x).1
  have hv1 := (curl_apply v x).2.1
  have hv2 := (curl_apply v x).2.2
  have hw0 := (curl_apply w x).1
  have hw1 := (curl_apply w x).2.1
  have hw2 := (curl_apply w x).2.2
  ext i
  fin_cases i
  · change curl (fun y => u y + v y + w y) x 0 =
        (curl u x + curl v x + curl w x) 0
    rw [hsum0]
    simp only [PiLp.add_apply]
    rw [hu0, hv0, hw0, hdir 2 1, hdir 1 2]
    ring
  · change curl (fun y => u y + v y + w y) x 1 =
        (curl u x + curl v x + curl w x) 1
    rw [hsum1]
    simp only [PiLp.add_apply]
    rw [hu1, hv1, hw1, hdir 0 2, hdir 2 0]
    ring
  · change curl (fun y => u y + v y + w y) x 2 =
        (curl u x + curl v x + curl w x) 2
    rw [hsum2]
    simp only [PiLp.add_apply]
    rw [hu2, hv2, hw2, hdir 1 0, hdir 0 1]
    ring

/-- Spatial slice of a joint scalar: `y ↦ F(t,y)` has derivative `DF(t,x) ∘ inr`. -/
public theorem fderiv_prod_snd_slice
    (F : ℝ × T3 → ℝ) (t : ℝ) (x : T3)
    (hF : DifferentiableAt ℝ F (t, x)) :
    fderiv ℝ (fun y : T3 => F (t, y)) x =
      (fderiv ℝ F (t, x)).comp (ContinuousLinearMap.inr ℝ ℝ T3) := by
  have hinr : HasFDerivAt (fun y : T3 => (t, y))
      (ContinuousLinearMap.inr ℝ ℝ T3) x :=
    hasFDerivAt_prodMk_right t x
  have hcomp : HasFDerivAt (F ∘ fun y : T3 => (t, y))
      ((fderiv ℝ F (t, x)).comp (ContinuousLinearMap.inr ℝ ℝ T3)) x :=
    hF.hasFDerivAt.comp (x := x) hinr
  have hfun : (fun y : T3 => F (t, y)) = F ∘ fun y : T3 => (t, y) := rfl
  rw [hfun]
  exact hcomp.fderiv

/-- Time slice of a joint scalar: `s ↦ F(s,x)` has derivative `DF(t,x) (1,0)`. -/
public theorem deriv_prod_fst_slice
    (F : ℝ × T3 → ℝ) (t : ℝ) (x : T3)
    (hF : DifferentiableAt ℝ F (t, x)) :
    deriv (fun s : ℝ => F (s, x)) t = (fderiv ℝ F (t, x)) (1, 0) := by
  have hinl : HasFDerivAt (fun s : ℝ => (s, x))
      (ContinuousLinearMap.inl ℝ ℝ T3) t :=
    hasFDerivAt_prodMk_left t x
  have hcomp : HasFDerivAt (F ∘ fun s : ℝ => (s, x))
      ((fderiv ℝ F (t, x)).comp (ContinuousLinearMap.inl ℝ ℝ T3)) t :=
    hF.hasFDerivAt.comp (x := t) hinl
  have hder := hasFDerivAt_iff_hasDerivAt.mp hcomp
  have hfun : (fun s : ℝ => F (s, x)) = F ∘ fun s : ℝ => (s, x) := rfl
  rw [hfun, hder.deriv]
  rfl

/-- Schwarz: `∂_x ∂_t f = ∂_t ∂_x f` at a `C²` spacetime point.
Uses `IsSymmSndFDerivAt` on `(t,x) ↦ f t x`, not an energy IBP. -/
public theorem time_space_mixed_partials
    (f : ℝ → T3 → ℝ) (t : ℝ) (x : T3) (v : T3)
    (hf : ContDiffAt ℝ 2 (fun p : ℝ × T3 => f p.1 p.2) (t, x)) :
    (fderiv ℝ (fun y => deriv (fun s => f s y) t) x) v =
      deriv (fun s => (fderiv ℝ (fun y => f s y) x) v) t := by
  let F : ℝ × T3 → ℝ := fun p => f p.1 p.2
  have hF1 : ContDiffAt ℝ 1 F (t, x) :=
    hf.of_le (by norm_num : (1 : WithTop ℕ∞) ≤ 2)
  have hnearF : ∀ᶠ p in nhds (t, x), DifferentiableAt ℝ F p := by
    filter_upwards [hF1.eventually (by simp)] with p hp
    exact hp.differentiableAt_one
  have hnearY : ∀ᶠ y in nhds x, DifferentiableAt ℝ F (t, y) :=
    (tendsto_const_nhds.prodMk_nhds tendsto_id).eventually hnearF
  have hnearS : ∀ᶠ s in nhds t, DifferentiableAt ℝ F (s, x) :=
    (tendsto_id.prodMk_nhds tendsto_const_nhds).eventually hnearF
  have _hFdiff : DifferentiableAt ℝ F (t, x) := hF1.differentiableAt_one
  have hfd : DifferentiableAt ℝ (fderiv ℝ F) (t, x) :=
    (hf.fderiv_right (m := 1) (by norm_num)).differentiableAt (by norm_num)
  have hsymm : IsSymmSndFDerivAt ℝ F (t, x) :=
    hf.isSymmSndFDerivAt (by simp [minSmoothness_of_isRCLikeNormedField])
  have heqY :
      (fun y => deriv (fun s => f s y) t) =ᶠ[nhds x]
        fun y => (fderiv ℝ F (t, y)) (1, 0) := by
    filter_upwards [hnearY] with y hy
    exact deriv_prod_fst_slice F t y hy
  have happlyY :
      fderiv ℝ (fun y => (fderiv ℝ F (t, y)) (1, 0)) x =
        (ContinuousLinearMap.apply ℝ ℝ ((1, 0) : ℝ × T3)).comp
          ((fderiv ℝ (fderiv ℝ F) (t, x)).comp (ContinuousLinearMap.inr ℝ ℝ T3)) := by
    have hinr : HasFDerivAt (fun y : T3 => (t, y))
        (ContinuousLinearMap.inr ℝ ℝ T3) x :=
      hasFDerivAt_prodMk_right t x
    have hcompF : HasFDerivAt (fun y : T3 => fderiv ℝ F (t, y))
        ((fderiv ℝ (fderiv ℝ F) (t, x)).comp (ContinuousLinearMap.inr ℝ ℝ T3)) x :=
      hfd.hasFDerivAt.comp (x := x) hinr
    have happ : HasFDerivAt (fun y => (fderiv ℝ F (t, y)) (1, 0))
        ((ContinuousLinearMap.apply ℝ ℝ ((1, 0) : ℝ × T3)).comp
          ((fderiv ℝ (fderiv ℝ F) (t, x)).comp (ContinuousLinearMap.inr ℝ ℝ T3))) x :=
      (ContinuousLinearMap.apply ℝ ℝ ((1, 0) : ℝ × T3)).hasFDerivAt.comp (x := x) hcompF
    exact happ.fderiv
  have hLHS :
      (fderiv ℝ (fun y => deriv (fun s => f s y) t) x) v =
        (fderiv ℝ (fderiv ℝ F) (t, x)) (0, v) (1, 0) := by
    rw [heqY.fderiv_eq, happlyY]
    rfl
  have heqS :
      (fun s => (fderiv ℝ (fun y => f s y) x) v) =ᶠ[nhds t]
        fun s => (fderiv ℝ F (s, x)) (0, v) := by
    filter_upwards [hnearS] with s hs
    have hfY := fderiv_prod_snd_slice F s x hs
    change (fderiv ℝ (fun y => F (s, y)) x) v = (fderiv ℝ F (s, x)) (0, v)
    rw [hfY]
    rfl
  have happS :
      HasFDerivAt (fun s : ℝ => (fderiv ℝ F (s, x)) (0, v))
        ((ContinuousLinearMap.apply ℝ ℝ ((0, v) : ℝ × T3)).comp
          ((fderiv ℝ (fderiv ℝ F) (t, x)).comp (ContinuousLinearMap.inl ℝ ℝ T3))) t := by
    have hinl : HasFDerivAt (fun s : ℝ => (s, x))
        (ContinuousLinearMap.inl ℝ ℝ T3) t :=
      hasFDerivAt_prodMk_left t x
    have hcompF : HasFDerivAt (fun s : ℝ => fderiv ℝ F (s, x))
        ((fderiv ℝ (fderiv ℝ F) (t, x)).comp (ContinuousLinearMap.inl ℝ ℝ T3)) t :=
      hfd.hasFDerivAt.comp (x := t) hinl
    exact (ContinuousLinearMap.apply ℝ ℝ ((0, v) : ℝ × T3)).hasFDerivAt.comp
      (x := t) hcompF
  have hderS := hasFDerivAt_iff_hasDerivAt.mp happS
  have hRHS :
      deriv (fun s => (fderiv ℝ (fun y => f s y) x) v) t =
        (fderiv ℝ (fderiv ℝ F) (t, x)) (1, 0) (0, v) := by
    have hcong : deriv (fun s => (fderiv ℝ (fun y => f s y) x) v) t =
        deriv (fun s => (fderiv ℝ F (s, x)) (0, v)) t :=
      heqS.deriv_eq
    rw [hcong, hderS.deriv]
    rfl
  rw [hLHS, hRHS]
  exact hsymm.eq (0, v) (1, 0)

/-- Coordinate of a time-differentiable Euclidean path is the time derivative of that coordinate. -/
public theorem deriv_euclidean_coord
    (g : ℝ → EuclideanSpace ℝ (Fin 3)) (t : ℝ) (i : Fin 3)
    (hg : DifferentiableAt ℝ g t) :
    deriv g t i = deriv (fun s => g s i) t := by
  let L : EuclideanSpace ℝ (Fin 3) →L[ℝ] ℝ :=
    PiLp.proj (p := 2) (fun _ : Fin 3 => ℝ) i
  have hfun : (fun s => g s i) = fun s => L (g s) := rfl
  have hL : HasFDerivAt (fun s => L (g s)) (L.comp (fderiv ℝ g t)) t :=
    L.hasFDerivAt.comp t hg.hasFDerivAt
  have hder : HasDerivAt (fun s => L (g s)) ((L.comp (fderiv ℝ g t)) 1) t :=
    hasFDerivAt_iff_hasDerivAt.mp hL
  rw [hfun, hder.deriv]
  change L (fderiv ℝ g t 1) = L (deriv g t)
  rw [fderiv_apply_one_eq_deriv]

/-- `curl ∂t u = ∂t (curl u)` by Schwarz on each coordinate (paper §2.1). -/
public theorem curl_time_deriv
    (u : TimeDependentVelocity) (t : ℝ) (x : T3)
    (hC2 : ∀ k, ContDiffAt ℝ 2 (fun q : ℝ × T3 => u q.1 q.2 k) (t, x)) :
    curl (fun y => time_deriv u t y) x =
      time_deriv (fun s => curl (u s)) t x := by
  have hk (k : Fin 3) :
      ∀ᶠ y in nhds x, DifferentiableAt ℝ (fun s => u s y k) t := by
    have hF1 : ContDiffAt ℝ 1 (fun q : ℝ × T3 => u q.1 q.2 k) (t, x) :=
      (hC2 k).of_le (by norm_num : (1 : WithTop ℕ∞) ≤ 2)
    have hnearY : ∀ᶠ y in nhds x,
        DifferentiableAt ℝ (fun q : ℝ × T3 => u q.1 q.2 k) (t, y) :=
      (tendsto_const_nhds.prodMk_nhds tendsto_id).eventually
        (by
          filter_upwards [hF1.eventually (by simp)] with p hp
          exact hp.differentiableAt_one)
    filter_upwards [hnearY] with y hy
    have hinl : HasFDerivAt (fun s : ℝ => (s, y))
        (ContinuousLinearMap.inl ℝ ℝ T3) t :=
      hasFDerivAt_prodMk_left t y
    exact (hy.hasFDerivAt.comp (x := t) hinl).differentiableAt
  have hnearVec : ∀ᶠ y in nhds x, DifferentiableAt ℝ (fun s => u s y) t := by
    filter_upwards [hk 0, hk 1, hk 2] with y h0 h1 h2
    exact (differentiableAt_piLp (p := 2) (𝕜 := ℝ)
        (E := fun _ : Fin 3 => ℝ)).mpr (fun i => by
      fin_cases i
      · exact h0
      · exact h1
      · exact h2)
  have heqCoord (comp : Fin 3) :
      (fun y => time_deriv u t y comp) =ᶠ[nhds x]
        fun y => deriv (fun s => u s y comp) t := by
    filter_upwards [hnearVec] with y hy
    change deriv (fun s => u s y) t comp = deriv (fun s => u s y comp) t
    exact deriv_euclidean_coord (fun s => u s y) t comp hy
  have hswap (comp dir : Fin 3) :
      directionalCoord (fun y => time_deriv u t y) comp dir x =
        deriv (fun s => directionalCoord (u s) comp dir x) t := by
    unfold directionalCoord
    rw [(heqCoord comp).fderiv_eq]
    exact time_space_mixed_partials (fun s y => u s y comp) t x
      (EuclideanSpace.single dir (1 : ℝ)) (hC2 comp)
  have hcoord_diff (comp dir : Fin 3) :
      DifferentiableAt ℝ (fun s => directionalCoord (u s) comp dir x) t := by
    have hF : ContDiffAt ℝ 2 (fun p : ℝ × T3 => u p.1 p.2 comp) (t, x) := hC2 comp
    have hfd : DifferentiableAt ℝ
        (fderiv ℝ (fun p : ℝ × T3 => u p.1 p.2 comp)) (t, x) :=
      (hF.fderiv_right (m := 1) (by norm_num)).differentiableAt (by norm_num)
    have hinl : HasFDerivAt (fun s : ℝ => (s, x))
        (ContinuousLinearMap.inl ℝ ℝ T3) t :=
      hasFDerivAt_prodMk_left t x
    have hcompF : HasFDerivAt
        (fun s : ℝ => fderiv ℝ (fun p : ℝ × T3 => u p.1 p.2 comp) (s, x))
        ((fderiv ℝ (fderiv ℝ (fun p : ℝ × T3 => u p.1 p.2 comp)) (t, x)).comp
          (ContinuousLinearMap.inl ℝ ℝ T3)) t :=
      hfd.hasFDerivAt.comp (x := t) hinl
    have happ : HasFDerivAt
        (fun s => (fderiv ℝ (fun p : ℝ × T3 => u p.1 p.2 comp) (s, x))
          (0, EuclideanSpace.single dir (1 : ℝ)))
        ((ContinuousLinearMap.apply ℝ ℝ
            ((0, EuclideanSpace.single dir (1 : ℝ)) : ℝ × T3)).comp
          ((fderiv ℝ (fderiv ℝ (fun p : ℝ × T3 => u p.1 p.2 comp)) (t, x)).comp
            (ContinuousLinearMap.inl ℝ ℝ T3))) t :=
      (ContinuousLinearMap.apply ℝ ℝ
          ((0, EuclideanSpace.single dir (1 : ℝ)) : ℝ × T3)).hasFDerivAt.comp
        (x := t) hcompF
    have hF1 : ContDiffAt ℝ 1 (fun p : ℝ × T3 => u p.1 p.2 comp) (t, x) :=
      hF.of_le (by norm_num : (1 : WithTop ℕ∞) ≤ 2)
    have hnearS : ∀ᶠ s in nhds t,
        DifferentiableAt ℝ (fun p : ℝ × T3 => u p.1 p.2 comp) (s, x) :=
      (tendsto_id.prodMk_nhds tendsto_const_nhds).eventually
        (by
          filter_upwards [hF1.eventually (by simp)] with p hp
          exact hp.differentiableAt_one)
    have heq : (fun s => directionalCoord (u s) comp dir x) =ᶠ[nhds t]
        fun s => (fderiv ℝ (fun p : ℝ × T3 => u p.1 p.2 comp) (s, x))
          (0, EuclideanSpace.single dir (1 : ℝ)) := by
      filter_upwards [hnearS] with s hs
      have hfY := fderiv_prod_snd_slice (fun p => u p.1 p.2 comp) s x hs
      unfold directionalCoord
      change (fderiv ℝ (fun y => u s y comp) x)
          (EuclideanSpace.single dir (1 : ℝ)) = _
      rw [hfY]
      rfl
    exact happ.differentiableAt.congr_of_eventuallyEq heq
  have hcurl_t : DifferentiableAt ℝ (fun s => curl (u s) x) t := by
    refine (differentiableAt_piLp (p := 2) (𝕜 := ℝ)
        (E := fun _ : Fin 3 => ℝ)).mpr ?_
    intro i
    fin_cases i
    · change DifferentiableAt ℝ (fun s => curl (u s) x 0) t
      have h0 : (fun s => curl (u s) x 0) =
          fun s => directionalCoord (u s) 2 1 x - directionalCoord (u s) 1 2 x := by
        funext s
        exact (curl_apply (u s) x).1
      rw [h0]
      exact (hcoord_diff 2 1).sub (hcoord_diff 1 2)
    · change DifferentiableAt ℝ (fun s => curl (u s) x 1) t
      have h1 : (fun s => curl (u s) x 1) =
          fun s => directionalCoord (u s) 0 2 x - directionalCoord (u s) 2 0 x := by
        funext s
        exact (curl_apply (u s) x).2.1
      rw [h1]
      exact (hcoord_diff 0 2).sub (hcoord_diff 2 0)
    · change DifferentiableAt ℝ (fun s => curl (u s) x 2) t
      have h2 : (fun s => curl (u s) x 2) =
          fun s => directionalCoord (u s) 1 0 x - directionalCoord (u s) 0 1 x := by
        funext s
        exact (curl_apply (u s) x).2.2
      rw [h2]
      exact (hcoord_diff 1 0).sub (hcoord_diff 0 1)
  have hcurl_apply := curl_apply (fun y => time_deriv u t y) x
  have ht0 :
      time_deriv (fun s => curl (u s)) t x 0 =
        deriv (fun s => directionalCoord (u s) 2 1 x) t -
          deriv (fun s => directionalCoord (u s) 1 2 x) t := by
    unfold time_deriv
    have hfun : (fun s => curl (u s) x 0) =
        fun s => directionalCoord (u s) 2 1 x - directionalCoord (u s) 1 2 x := by
      funext s
      exact (curl_apply (u s) x).1
    rw [deriv_euclidean_coord (fun s => curl (u s) x) t 0 hcurl_t, hfun,
      deriv_fun_sub (hcoord_diff 2 1) (hcoord_diff 1 2)]
  have ht1 :
      time_deriv (fun s => curl (u s)) t x 1 =
        deriv (fun s => directionalCoord (u s) 0 2 x) t -
          deriv (fun s => directionalCoord (u s) 2 0 x) t := by
    unfold time_deriv
    have hfun : (fun s => curl (u s) x 1) =
        fun s => directionalCoord (u s) 0 2 x - directionalCoord (u s) 2 0 x := by
      funext s
      exact (curl_apply (u s) x).2.1
    rw [deriv_euclidean_coord (fun s => curl (u s) x) t 1 hcurl_t, hfun,
      deriv_fun_sub (hcoord_diff 0 2) (hcoord_diff 2 0)]
  have ht2 :
      time_deriv (fun s => curl (u s)) t x 2 =
        deriv (fun s => directionalCoord (u s) 1 0 x) t -
          deriv (fun s => directionalCoord (u s) 0 1 x) t := by
    unfold time_deriv
    have hfun : (fun s => curl (u s) x 2) =
        fun s => directionalCoord (u s) 1 0 x - directionalCoord (u s) 0 1 x := by
      funext s
      exact (curl_apply (u s) x).2.2
    rw [deriv_euclidean_coord (fun s => curl (u s) x) t 2 hcurl_t, hfun,
      deriv_fun_sub (hcoord_diff 1 0) (hcoord_diff 0 1)]
  ext i
  fin_cases i
  · change curl (fun y => time_deriv u t y) x 0 =
        time_deriv (fun s => curl (u s)) t x 0
    rw [hcurl_apply.1, ht0, hswap 2 1, hswap 1 2]
  · change curl (fun y => time_deriv u t y) x 1 =
        time_deriv (fun s => curl (u s)) t x 1
    rw [hcurl_apply.2.1, ht1, hswap 0 2, hswap 2 0]
  · change curl (fun y => time_deriv u t y) x 2 =
        time_deriv (fun s => curl (u s)) t x 2
    rw [hcurl_apply.2.2, ht2, hswap 1 0, hswap 0 1]

/-- Coordinate of a Fréchet derivative is the derivative of that coordinate. -/
public theorem fderiv_field_coord
    (G : VelocityField) (x : T3) (j : Fin 3) (v : T3)
    (hG : DifferentiableAt ℝ G x) :
    (fderiv ℝ G x v) j = (fderiv ℝ (fun y => G y j) x) v := by
  let L : EuclideanSpace ℝ (Fin 3) →L[ℝ] ℝ :=
    PiLp.proj (p := 2) (fun _ : Fin 3 => ℝ) j
  have hfun : (fun y => G y j) = fun y => L (G y) := rfl
  have hL : HasFDerivAt (fun y => L (G y)) (L.comp (fderiv ℝ G x)) x :=
    L.hasFDerivAt.comp x hG.hasFDerivAt
  rw [hfun, hL.fderiv]
  rfl

/-- Vector Laplacian is the scalar Laplacian of each coordinate. C² of the field. -/
public theorem laplacian_coord
    (u : VelocityField) (x : T3) (j : Fin 3)
    (hu : ContDiffAt ℝ 2 u x) :
    laplacian u x j =
      ∑ i : Fin 3,
        (fderiv ℝ (fun y => directionalCoord u j i y) x)
          (EuclideanSpace.single i 1) := by
  have _hC1 : DifferentiableAt ℝ u x :=
    (hu.of_le (by norm_num : (1 : WithTop ℕ∞) ≤ 2)).differentiableAt_one
  have hnear : ∀ᶠ y in nhds x, DifferentiableAt ℝ u y := by
    have hu1 : ContDiffAt ℝ 1 u x :=
      hu.of_le (by norm_num : (1 : WithTop ℕ∞) ≤ 2)
    filter_upwards [hu1.eventually (by simp)] with y hy
    exact hy.differentiableAt_one
  have hfd : DifferentiableAt ℝ (fderiv ℝ u) x :=
    (hu.fderiv_right (m := 1) (by norm_num)).differentiableAt (by norm_num)
  have hdir (i : Fin 3) :
      DifferentiableAt ℝ
        (fun y => (fderiv ℝ u y) (EuclideanSpace.single i (1 : ℝ))) x :=
    (ContinuousLinearMap.apply ℝ (EuclideanSpace ℝ (Fin 3))
        (EuclideanSpace.single i (1 : ℝ))).differentiableAt.comp x hfd
  have heq (i : Fin 3) :
      (fun y => ((fderiv ℝ u y) (EuclideanSpace.single i (1 : ℝ))) j) =ᶠ[nhds x]
        fun y => directionalCoord u j i y := by
    filter_upwards [hnear] with y hy
    exact fderiv_field_coord u y j (EuclideanSpace.single i (1 : ℝ)) hy
  unfold laplacian
  let w : Fin 3 → EuclideanSpace ℝ (Fin 3) := fun i =>
    (fderiv ℝ (fun y => (fderiv ℝ u y) (EuclideanSpace.single i (1 : ℝ))) x)
      (EuclideanSpace.single i (1 : ℝ))
  let P : EuclideanSpace ℝ (Fin 3) →L[ℝ] ℝ :=
    PiLp.proj (p := 2) (fun _ : Fin 3 => ℝ) j
  have hsum : P (∑ i : Fin 3, w i) = ∑ i : Fin 3, P (w i) :=
    map_sum P.toLinearMap (fun i => w i) Finset.univ
  have hj : (∑ i : Fin 3, w i) j = P (∑ i : Fin 3, w i) := rfl
  rw [hj, hsum]
  refine Finset.sum_congr rfl fun i _ => ?_
  have hcoord :=
    fderiv_field_coord (fun y => (fderiv ℝ u y) (EuclideanSpace.single i (1 : ℝ)))
      x j (EuclideanSpace.single i (1 : ℝ)) (hdir i)
  change P (w i) = _
  have hPw : P (w i) = w i j := rfl
  rw [hPw, hcoord, (heq i).fderiv_eq]

/-- `curl Δu = Δ curl u` at `C³` points (third mixed partials commute). -/
public theorem curl_laplacian
    (u : VelocityField) (x : T3)
    (hu : ∀ k, ContDiffAt ℝ 3 (fun y => u y k) x) :
    curl (laplacian u) x = laplacian (curl u) x := by
  sorry

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

/-- Vorticity transport: take the curl of NS (paper §2.1). -/
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

#print axioms curl_gradient
#print axioms div_curl
#print axioms div_of_eq_curl
#print axioms div_smul_field
#print axioms curl_add
#print axioms convective_coord
#print axioms convective_eq_sum_directional
#print axioms directionalCoord_convective
#print axioms curl_convective
#print axioms curl_convective_div_free
#print axioms curl_add3
#print axioms fderiv_prod_snd_slice
#print axioms deriv_prod_fst_slice
#print axioms time_space_mixed_partials
#print axioms deriv_euclidean_coord
#print axioms curl_time_deriv
#print axioms fderiv_field_coord
#print axioms laplacian_coord
#print axioms time_space_mixed_partials
#print axioms differentiableAt_coord
#print axioms fderiv_coord
#print axioms integration_by_parts_of_vanishing_flux
#print axioms inner_self_convective_eq_inner_grad_half_norm_sq
#print axioms differentiableAt_coord_of_differentiableAt_field
#print axioms differentiableAt_half_norm_sq
#print axioms convective_energy_pairing_vanishes
#print axioms pressure_energy_pairing_vanishes

end

end NavierStokes3D
