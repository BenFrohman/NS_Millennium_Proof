/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.Calculus.ContDiff.Basic
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.MeasureTheory.Measure.Haar.InnerProductSpace
import Mathlib.MeasureTheory.Integral.Bochner.Basic

/-!
# The 3D incompressible Navier–Stokes equations on the torus `𝕋³`

Every object in this file is a genuine definition built from Mathlib (`fderiv`, `HasDerivAt`,
`ContDiff`, Lebesgue measure). Nothing here is assumed or left unproved.

* The torus `𝕋³ = ℝ³ / ℤ³` is represented by its universal cover `T3 = ℝ³`
  (`EuclideanSpace ℝ (Fin 3)`): a field on `𝕋³` is a `ℤ³`-periodic field on `T3`
  (`IsPeriodic`). Integrals over `𝕋³` are integrals over the unit cell `[0, 1)³`
  (`torusVolume`).
* `div u`, `curl u`, `Δ u` (`laplacian`), `∇ p` (`gradient`) and `(u · ∇) v` (`convective`) are
  the classical operators, defined from the Fréchet derivative `fderiv ℝ`.
* `IsClassicalSolutionOn ν u p T` says that `(u, p)` is a classical solution of
  `∂ₜu + (u · ∇)u + ∇p = ν Δu`, `div u = 0` on `[0, T)`, smooth and periodic in space.

The three classical theorems used later are **not** proved here. They are stated as named
hypotheses (`Prop`s) and passed explicitly as arguments wherever they are used:

* `KatoLocalExistence ν` (Kato 1972; Leray 1934),
* `ClassicalUniqueness ν` (uniqueness of classical solutions),
* `BealeKatoMajdaContinuation ν` (Beale–Kato–Majda 1984, in the sup-norm form).
-/

open MeasureTheory Set
open scoped RealInnerProductSpace

namespace NavierStokes3D

/-- The universal cover `ℝ³` of the torus `𝕋³ = ℝ³/ℤ³`. -/
abbrev T3 : Type := EuclideanSpace ℝ (Fin 3)

abbrev VelocityField := T3 → EuclideanSpace ℝ (Fin 3)
abbrev VorticityField := T3 → EuclideanSpace ℝ (Fin 3)
abbrev PressureField := T3 → ℝ
abbrev TimeDependentVelocity := ℝ → VelocityField
abbrev TimeDependentVorticity := ℝ → VorticityField
abbrev TimeDependentPressure := ℝ → PressureField

noncomputable section

/-- The standard basis vector `eᵢ` of `ℝ³`. -/
def e (i : Fin 3) : T3 := EuclideanSpace.single i 1

/-- `f` is `ℤ³`-periodic, i.e. `f` is a function on the torus `𝕋³`. -/
def IsPeriodic {α : Type*} (f : T3 → α) : Prop :=
  ∀ (x : T3) (k : Fin 3 → ℤ), f (x + ∑ i, (k i : ℝ) • e i) = f x

/-- The unit cell `[0, 1)³`, a fundamental domain of `ℤ³` acting on `ℝ³`. -/
def cell : Set T3 := {x | ∀ i, x i ∈ Ico (0 : ℝ) 1}

/-- Lebesgue measure on the unit cell: integration over `𝕋³`. -/
def torusVolume : Measure T3 := volume.restrict cell

/-- The partial derivative `∂ᵢ f = Df(x) eᵢ`. -/
def partialDeriv {F : Type*} [NormedAddCommGroup F] [NormedSpace ℝ F]
    (i : Fin 3) (f : T3 → F) (x : T3) : F :=
  fderiv ℝ f x (e i)

/-- `div u = ∑ᵢ ∂ᵢ uᵢ`. -/
def div (u : VelocityField) (x : T3) : ℝ := ∑ i, (partialDeriv i u x) i

/-- `curl u = (∂₂u₃ - ∂₃u₂, ∂₃u₁ - ∂₁u₃, ∂₁u₂ - ∂₂u₁)` (indices `0, 1, 2` in Lean). -/
def curl (u : VelocityField) (x : T3) : EuclideanSpace ℝ (Fin 3) :=
  ((partialDeriv 1 u x) 2 - (partialDeriv 2 u x) 1) • e 0 +
  ((partialDeriv 2 u x) 0 - (partialDeriv 0 u x) 2) • e 1 +
  ((partialDeriv 0 u x) 1 - (partialDeriv 1 u x) 0) • e 2

/-- The vector Laplacian `Δu = ∑ᵢ ∂ᵢ∂ᵢ u`. -/
def laplacian (u : VelocityField) (x : T3) : EuclideanSpace ℝ (Fin 3) :=
  ∑ i, partialDeriv i (partialDeriv i u) x

/-- The pressure gradient `∇p = ∑ᵢ (∂ᵢ p) eᵢ`. -/
def gradient (p : PressureField) (x : T3) : EuclideanSpace ℝ (Fin 3) :=
  ∑ i, partialDeriv i p x • e i

/-- The convective derivative `(u · ∇) v = Dv(x) u(x)`. -/
def convective (u v : VelocityField) (x : T3) : EuclideanSpace ℝ (Fin 3) :=
  fderiv ℝ v x (u x)

/-- The vorticity `ω = curl u`. -/
def vorticity (u : VelocityField) : VorticityField := curl u

/-- Admissible initial data: `u₀` smooth, divergence-free and periodic. -/
def IsAdmissibleData (u₀ : VelocityField) : Prop :=
  ContDiff ℝ ⊤ u₀ ∧ (∀ x, div u₀ x = 0) ∧ IsPeriodic u₀

/-- `(u, p)` is a classical solution of the incompressible Navier–Stokes equations with
viscosity `ν` on the time interval `[0, T)`:
* for `t ∈ [0, T)`, `u(t)` is smooth, periodic and divergence-free;
* for `t ∈ (0, T)` and every `x`, `∂ₜ u(t, x) = ν Δu - (u · ∇)u - ∇p` (a genuine derivative);
* `u(t, x) → u(0, x)` as `t → 0⁺`. -/
def IsClassicalSolutionOn (ν : ℝ) (u : TimeDependentVelocity) (p : TimeDependentPressure)
    (T : ℝ) : Prop :=
  (∀ t ∈ Ico 0 T, ContDiff ℝ ⊤ (u t) ∧ IsPeriodic (u t) ∧ ∀ x, div (u t) x = 0) ∧
  (∀ t ∈ Ioo 0 T, ∀ x, HasDerivAt (fun s => u s x)
      (ν • laplacian (u t) x - convective (u t) (u t) x - gradient (p t) x) t) ∧
  (∀ x, ContinuousWithinAt (fun s => u s x) (Ico 0 T) 0)

/-- The vorticity of `u` stays bounded on `[0, T)`: `sup_{t < T} ‖ω(t)‖_{L^∞} < ∞`. -/
def VorticityBoundedOn (u : TimeDependentVelocity) (T : ℝ) : Prop :=
  ∃ M : ℝ, ∀ t ∈ Ico 0 T, ∀ x, ‖vorticity (u t) x‖ ≤ M

/-! ## Named classical hypotheses (not proved in this repository) -/

/-- **(KL) Kato–Leray local existence.** Every admissible initial datum has a classical solution
on some interval `[0, T)` with `T > 0`. -/
def KatoLocalExistence (ν : ℝ) : Prop :=
  ∀ u₀ : VelocityField, IsAdmissibleData u₀ →
    ∃ T > 0, ∃ (u : TimeDependentVelocity) (p : TimeDependentPressure),
      u 0 = u₀ ∧ IsClassicalSolutionOn ν u p T

/-- **(U) Uniqueness of classical solutions.** Two classical solutions with the same initial
velocity agree on their common interval of existence. -/
def ClassicalUniqueness (ν : ℝ) : Prop :=
  ∀ (u v : TimeDependentVelocity) (p q : TimeDependentPressure) (T₁ T₂ : ℝ),
    IsClassicalSolutionOn ν u p T₁ → IsClassicalSolutionOn ν v q T₂ → u 0 = v 0 →
      ∀ t, 0 ≤ t → t < T₁ → t < T₂ → u t = v t

/-- **(BKM) Beale–Kato–Majda continuation**, sup-norm form: a classical solution on `[0, T)`
whose vorticity stays bounded extends to a classical solution on a longer interval. -/
def BealeKatoMajdaContinuation (ν : ℝ) : Prop :=
  ∀ (u₀ : VelocityField), IsAdmissibleData u₀ → ∀ T > 0,
    ∀ (u : TimeDependentVelocity) (p : TimeDependentPressure),
      u 0 = u₀ → IsClassicalSolutionOn ν u p T → VorticityBoundedOn u T →
        ∃ T' > T, ∃ (v : TimeDependentVelocity) (q : TimeDependentPressure),
          v 0 = u₀ ∧ IsClassicalSolutionOn ν v q T'

/-! ## Proved facts -/

theorem IsClassicalSolutionOn.mono {ν : ℝ} {u : TimeDependentVelocity}
    {p : TimeDependentPressure} {T T' : ℝ} (h : IsClassicalSolutionOn ν u p T) (hT : T' ≤ T) :
    IsClassicalSolutionOn ν u p T' := by
  obtain ⟨h1, h2, h3⟩ := h
  refine ⟨fun t ht => h1 t ⟨ht.1, ht.2.trans_le hT⟩,
    fun t ht => h2 t ⟨ht.1, ht.2.trans_le hT⟩,
    fun x => (h3 x).mono (Ico_subset_Ico_right hT)⟩

@[simp] theorem partialDeriv_zero {F : Type*} [NormedAddCommGroup F] [NormedSpace ℝ F]
    (i : Fin 3) (x : T3) : partialDeriv i (fun _ : T3 => (0 : F)) x = 0 := by
  simp [partialDeriv]

/-- Sanity check that the solution notion is satisfiable: `u = 0`, `p = 0` is a classical
solution on every interval, for every `ν`. -/
theorem zero_isClassicalSolutionOn (ν T : ℝ) :
    IsClassicalSolutionOn ν (fun _ _ => 0) (fun _ _ => 0) T := by
  refine ⟨fun t _ => ⟨contDiff_const, fun _ _ => rfl, fun x => by simp [div]⟩,
    fun t _ x => ?_, fun x => continuousWithinAt_const⟩
  have hlap : laplacian (fun _ : T3 => (0 : EuclideanSpace ℝ (Fin 3))) x = 0 := by
    simp only [laplacian]
    refine Finset.sum_eq_zero fun i _ => ?_
    have : partialDeriv i (fun _ : T3 => (0 : EuclideanSpace ℝ (Fin 3))) =
        fun _ => (0 : EuclideanSpace ℝ (Fin 3)) := by
      funext y; simp
    rw [this]; simp
  have hconv : convective (fun _ : T3 => (0 : EuclideanSpace ℝ (Fin 3)))
      (fun _ => 0) x = 0 := by simp [convective]
  have hgrad : gradient (fun _ : T3 => (0 : ℝ)) x = 0 := by simp [gradient]
  rw [hlap, hconv, hgrad]
  simpa using hasDerivAt_const t (0 : EuclideanSpace ℝ (Fin 3))

end

end NavierStokes3D
