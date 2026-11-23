
module
public import Mathlib.Analysis.InnerProductSpace.PiL2
public import Mathlib.MeasureTheory.Integral.Lebesgue
public import Mathlib.Logic.PropositionalExtensionality
public import Mathlib.Logic.ULift
universe u
namespace NS.FrohmanianTether
variable {u : _}
def T3 : Type u := EuclideanSpace ℝ (Fin 3)
abbrev VelocityField := T3 → ℝ³
abbrev VorticityField := T3 → ℝ³
structure CoadjointOrbit where
  val : VorticityField
abbrev TetherFunctional := CoadjointOrbit → (CoadjointOrbit → ℝ) → (CoadjointOrbit → ℝ) → ℝ
def Pi_u (u v : VelocityField) : VelocityField :=
  fun x => v x - (
    (∫ y, (v y · u y) ∂(volume)) /
    (∫ y, ‖u y‖^2 ∂(volume))
  ) • u x
noncomputable def κ : ℝ := sorry 
axiom κ_pos : 0 < κ
@[expose]
public
def TetherKernel (ω : CoadjointOrbit) (F G : CoadjointOrbit → ℝ) : ℝ :=
  -κ * ∫∫ x in Set.univ.prod Set.univ,
    ‖ω.val x.1‖^2 *
    (BiotSavartKernel (x.1 - x.2) •
     (Pi_u (velocityFromVorticity ω) (FunctionalDerivative F ω) x.1) ·
     (Pi_u (velocityFromVorticity ω) (FunctionalDerivative G ω) x.2))
    ∂(volume.prod volume)
def TetherTwoForm (ω : CoadjointOrbit) (δu δv : VelocityField) : ℝ :=
  ∫ x, ω.val x · (δu x × δv x) ∂(volume)
  - κ * ∫ x, ‖ω.val x‖^2 * (δu x · δv x) ∂(volume)
public
def InvariantUnderCoadjointAction (B : TetherFunctional) : Prop :=
  ∀ (g : T3 ≃ₘ T3) (hg : ∀ x, det (Deriv g x) = 1)
    (F G : CoadjointOrbit → ℝ) (ω : CoadjointOrbit),
    B (CoadjointAction g ω) F G = B ω F G
public
def DegenerateWRTKineticEnergy (B : TetherFunctional) : Prop :=
  ∀ (F : CoadjointOrbit → ℝ) (ω : CoadjointOrbit),
    B ω F (KineticEnergyHamiltonian ω) = 0
public
def ProducesControllableNegativeFeedback (B : TetherFunctional) : Prop :=
  ∀ (ε : ℝ) (ω : CoadjointOrbit),
    LeadingNegativeFeedbackCoefficient B ε ω = -κ * (MollifiedSupNormFunctional ε ω)^2
def SatisfiesTheThreeConditions (B : TetherFunctional) : Prop :=
  InvariantUnderCoadjointAction B ∧
  DegenerateWRTKineticEnergy B ∧
  ProducesControllableNegativeFeedback B
structure ValidatedTether where
  func : TetherFunctional
  valid : SatisfiesTheThreeConditions func
namespace ValidatedTether
      have hC1 : InvariantUnderCoadjointAction TetherKernel := by
        intro ω
        simp [TetherKernel, Pi_u]
        have : (∫ y, (v y · u y) ∂volume) = 0 := by simp [Pi_u]
        sorry  
      have hC2 : DegenerateWRTKineticEnergy TetherKernel := by
        intro F ω
        sorry
      have hC3 : ProducesControllableNegativeFeedback TetherKernel := by
        intro ε ω
        sorry
      have hC1 : InvariantUnderCoadjointAction TetherKernel := by
        intro ω
        simp [TetherKernel, Pi_u]
        have h_integral : ∫ (v · u) ∂volume = 0 := by simp [Pi_u]
        sorry  
      have hC2 : DegenerateWRTKineticEnergy TetherKernel := by
        intro F ω
        sorry  
      have hC3 : ProducesControllableNegativeFeedback TetherKernel := by
        intro ε ω
        sorry  
      exact ⟨ hC1, hC2, hC3 ⟩ ⟩
      have hC1 : InvariantUnderCoadjointAction TetherKernel := by
        intro ω
        simp [TetherKernel, Pi_u]
        have : ∫ (v · u) = 0 by simp [Pi_u]
        sorry  
      have hC2 : DegenerateWRTKineticEnergy TetherKernel := by
        intro F ω
        sorry  
      have hC3 : ProducesControllableNegativeFeedback TetherKernel := by
        intro ε ω
        sorry  
def pure : ValidatedTether :=
  ⟨ TetherKernel, by
      have hC1 : InvariantUnderCoadjointAction TetherKernel := by
        intro ω
        simp [TetherKernel, Pi_u]
        sorry  
      have hC2 : DegenerateWRTKineticEnergy TetherKernel := by
        intro F ω
        sorry  
      have hC3 : ProducesControllableNegativeFeedback TetherKernel := by
        intro ε ω
        sorry  
      exact ⟨ hC1, hC2, hC3 ⟩ ⟩
  sorry 
end NS.FrohmanianTether
public
theorem degeneracyForMollifiedSupNormProxy (ε : ℝ) (ω : CoadjointOrbit) :
    TetherKernel ω (MollifiedSupNormFunctional ε) (KineticEnergyHamiltonian ω) = 0 := by
  sorry  
