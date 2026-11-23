
module
public import Mathlib.MeasureTheory.Measure.MeasureSpace
public import Mathlib.Analysis.InnerProductSpace.PiL2
public import Mathlib.Analysis.Calculus.ContDiff.Basic
public import Mathlib.Analysis.Calculus.Deriv.Basic
public import Mathlib.Analysis.SpecialFunctions.Exp
public import Mathlib.Data.Real.Basic
public import Mathlib.Data.ENNReal.Basic
public import Mathlib.Data.Set.Basic
public import Mathlib.MeasureTheory.Integral.Bochner.Basic
public import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
open ENNReal  
namespace NavierStokes3D
@[expose] public def T3 : Type := EuclideanSpace ℝ (Fin 3)
@[expose] public noncomputable instance : MeasurableSpace T3 := sorry
@[expose] public instance : NormedAddCommGroup T3 := sorry
@[expose] public instance : NormedSpace ℝ T3 := sorry
public abbrev VelocityField := T3 → (EuclideanSpace ℝ (Fin 3))
public abbrev VorticityField := T3 → (EuclideanSpace ℝ (Fin 3))
public abbrev PressureField := T3 → ℝ
public abbrev TimeDependentVelocity := ℝ → VelocityField
public abbrev TimeDependentVorticity := ℝ → VorticityField
public abbrev TimeDependentPressure := ℝ → (T3 → ℝ)
noncomputable section
open MeasureTheory
public def volume : Measure T3 := sorry
public def time_deriv {α : Type} (f : ℝ → (T3 → α)) (t : ℝ) (x : T3) : α := sorry
notation "∂t " f:arg t:arg => time_deriv f t
public def convective (u v : VelocityField) : VelocityField :=
  fun x => sorry
prefix:100 "(·∇)" => fun u v => convective u v
public def laplacian (f : VelocityField) : VelocityField := fun x => sorry
notation "Δ " f:arg => laplacian f
public abbrev Velocity := VelocityField      
public abbrev Vorticity := VorticityField
public abbrev vol := volume                  
public def div (u : VelocityField) (x : T3) : ℝ := sorry
public def curl (u : VelocityField) (x : T3) : (EuclideanSpace ℝ (Fin 3)) := sorry
postfix:90 "_div" => fun u x => div u x
public def navier_stokes_eq (u : TimeDependentVelocity) (_p : TimeDependentPressure) (_ν : ℝ) : Prop :=
  ∀ t ≥ 0, (True ∧ ∀ x, div (u t) x = 0)
public def vorticity (u : Velocity) : Vorticity := fun x => curl u x
public theorem vorticity_transport (u : TimeDependentVelocity) (_p : TimeDependentPressure) (_ν : ℝ)
    (h_NS : navier_stokes_eq u _p _ν) :
  True := by
  sorry
public def NS_PDE (u : ℝ → VelocityField) (_p : ℝ → PressureField) (_ν : ℝ) : Prop :=
  (∀ (_t : ℝ) (_x : T3), (True : Prop)) ∧
  (∀ (t : ℝ) (x : T3), div (u t) x = 0)
public theorem vorticity_transport_equation
    (u : ℝ → VelocityField) (_p : ℝ → PressureField) (_ν : ℝ)
    (h_ns : NS_PDE u _p _ν) :
  let ω := fun t x => curl (u t) x
  ∀ (t : ℝ) (x : T3), (True : Prop) := by
  sorry
public def MaterialDerivative (u : ℝ → VelocityField) (f : ℝ → (T3 → ℝ)) (t : ℝ) (x : T3) : ℝ := sorry
public theorem local_existence
    (u₀ : VelocityField) (ν : ℝ)
    (h_smooth : ContDiff ℝ ⊤ u₀)
    (h_divfree : ∀ x, div u₀ x = 0)
    (h_finite : True)  
    : ∃ T, T > 0 ∧
        ∃ u : ℝ → VelocityField,
          (∀ t ∈ Set.Icc 0 T, ContDiff ℝ ⊤ (u t)) ∧
          u 0 = u₀ ∧
          ∃ p : ℝ → PressureField, NS_PDE u p ν := by
  sorry
where
  Tstar (u₀ : VelocityField) (ν : ℝ) : ℝ := sorry
end   
end NavierStokes3D
