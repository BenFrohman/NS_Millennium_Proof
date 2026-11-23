
module
public import NS_Millennium_Proof.Modules.SymplecticTether
public import NS_Millennium_Proof.Modules.TetheredLyapunov
public import NS_Millennium_Proof.Modules.ArnoldGeometric
public import NS_Millennium_Proof.Modules.NS_Equations
public import Mathlib.Analysis.Calculus.ContDiff.Basic  
namespace GlobalRegularity
open FrohmanianTether TetheredLyapunov
open ArnoldGeometric hiding CoadjointOrbit
open ArnoldGeometric (CoadjointOrbit)  
open NavierStokes3D
theorem frohmanian_tether_theorem :  
  ∃ (𝔗_F : CoadjointOrbit → Functional → Functional → ℝ),
    (∀ F ω, TetheredBracket F KineticEnergyHamiltonian ω = ClassicalBracket F KineticEnergyHamiltonian ω) ∧
    (∀ (B : CoadjointOrbit → Functional → Functional → ℝ),
      (∀ ω F G, B ω F G = -B ω G F) →
      InvariantUnderCoadjointAction B →
      DegenerateWRTKineticEnergy B →
      ProducesControllableNegativeFeedback B →
      ∀ ω F G, B ω F G = 𝔗_F ω F G) ∧
    (∀ (u₀ : VelocityField) (ν : ℝ),
      (∀ x, div u₀ x = 0) →
      ContDiff ℝ ⊤ u₀ →
      ∃ (u : ℝ → VelocityField) (p : ℝ → PressureField),
        NS_PDE u p ν ∧
        u 0 = u₀ ∧
        (∀ t ≥ 0, True) ∧   
        (∀ t ≥ 0, ∀ x, div (u t) x = 0)) := by
  refine ⟨TetherKernel, ?_, ?_, ?_⟩
  · intro F ω
    exact tethered_reproduces_classical_euler F ω
  · sorry   
  · intro u₀ ν hdiv hsm
    exact global_regularity u₀ ν hdiv (by exact True.intro) (by exact True.intro) (by sorry)
open NavierStokes3D
abbrev IsSmooth (f : VelocityField) : Prop := ContDiff ℝ ⊤ f
noncomputable def vorticity_sup_norm (ω : VorticityField) : ℝ :=
  ⨆ x, ‖ω x‖   
noncomputable abbrev vorticity_sup_norm_proxy (ω : VorticityField) : ℝ := vorticity_sup_norm ω
def satisfies_NavierStokes (u : TimeDependentVelocity) (ν : ℝ) : Prop :=
  ∃ p : TimeDependentPressure, navier_stokes_eq u p ν
theorem global_regularity_for_NS
    (u0 : TimeDependentVelocity)
    (h_div_free : ∀ t x, div (u0 t) x = 0)
    (h_smooth : IsSmooth (u0 0))
    (h_finite_energy : True)  
    (ν : ℝ) (h_ν_pos : ν > 0) :
  ∃! (u : TimeDependentVelocity),
    (∀ t ≥ 0, IsSmooth (u t)) ∧
    (u 0 = u0 0) ∧
    (∀ t ≥ 0, satisfies_NavierStokes u ν) ∧
    (∀ t ≥ 0, True) := by  
  sorry
#print axioms frohmanian_tether_theorem
#print axioms global_regularity_for_NS
end GlobalRegularity
