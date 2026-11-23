
module
import Mathlib.Analysis.InnerProductSpace.PiL2
import NS_Millennium_Proof.Modules.NS_Equations
import NS_Millennium_Proof.Modules.ArnoldGeometric
open InnerProductSpace  
open ArnoldGeometric (pairing)  
namespace ForMathlib
open NavierStokes3D
noncomputable def Pi_u (u v : VelocityField) : VelocityField :=
  fun x => v x - (
    (∫ y, pairing (v y) (u y) ∂(volume)) /
    (∫ y, ‖u y‖^2 ∂(volume))
  ) • u x
@[simp]
theorem projection_orthogonal_to_u (u : VelocityField) (h_div : ∀ x, div u x = 0) :
    Pi_u u u = fun _ => 0 := by
  sorry   
theorem projector_orthogonality (v u : VelocityField) (h_div_u : ∀ x, div u x = 0) :
    ∀ x, pairing (Pi_u u v x) (u x) = 0 := by
  let V_div_free := { w : VelocityField | div w = 0 }
  have h_orthogonal_projection : ∀ w ∈ V_div_free, ∀ x, pairing (Pi_u u v x) (w x) = 0 := by
    intro w h_w x
    sorry
  have h_result : ∀ x, pairing (Pi_u u v x) (u x) = 0 := by
    intro x
    sorry   
  exact h_result
theorem Pi_u_is_the_L2_orthogonal_projection_onto_complement_of_u
    (u v : VelocityField) (h_div_u : ∀ x, div u x = 0) :
    (∫ x, pairing (Pi_u u v x) (u x) ∂(volume)) = 0 := by
  have h_pointwise : ∀ x, pairing (Pi_u u v x) (u x) = 0 := by
    intro x
    exact projector_orthogonality v u h_div_u x
  sorry   
end ForMathlib
