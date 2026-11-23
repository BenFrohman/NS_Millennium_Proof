/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import NS_Millennium_Proof.Modules.ArnoldGeometric
import NS_Millennium_Proof.Modules.ForMathlib.Projection

/-!
# The Frohmanian tether kernel and the tethered bracket

For an `ArnoldSetting` `S`, a tether strength `κ` and `u = BS(ω)`,

  `B_κ(ω; F, G) = -κ ∫_{𝕋³} ‖ω‖² ⟨Π_u δF/δω, Π_u δG/δω⟩ dx`        (`TetherKernel`)

  `{F, G}_κ = {F, G} + B_κ(·; F, G)`                                 (`TetheredBracket`)

exactly as written in the source (`B(F,G)(ω) = -κ ∫ |ω|² (Π_u δF/δω · Π_u δG/δω) dλ`).
The strength `κ` is an explicit parameter. The earlier file fixed `κ = 1` under the name
`CalderonZygmundConstant3D` and added the custom axiom `czc_3d_pos : 0 < 1`; the value of the
Calderón–Zygmund constant `C_CZ(3)` is not computed anywhere, so `κ` is now a parameter and
`0 ≤ κ` or `0 < κ` is a hypothesis where needed.

## Proved
* `tetherKernel_symm`: `B_κ(ω; F, G) = B_κ(ω; G, F)`. The kernel is **symmetric**, not
  antisymmetric.
* `tetherKernel_feedback`: for `0 ≤ κ`, `B_κ(ω; F, F) ≤ 0` (condition (C3)).
* `tetherKernel_degenerate`: under (EG) `δH/δω = u` and `‖u‖²_{L²} ≠ 0`, `B_κ(ω; F, H) = 0`.
* `tethered_reproduces_classical_euler`: under the same hypotheses `{F, H}_κ = {F, H}`.

## Not proved (statements only)
* invariance (C1) of `B_κ` under the coadjoint action;
* `TetheredJacobiIdentity`: the Jacobi identity for `{·,·}_κ`. Note that `{·,·}_κ` is not even
  antisymmetric when `B_κ(ω; F, F) ≠ 0` (see `Uniqueness.lean`).

The earlier `tethered_jacobi_identity`, `tether_coadjoint_invariance` and
`degeneracy_for_mollified_sup_norm_proxy` had statement `True` and were removed. The earlier
`mollify` was the identity function under the name of a mollifier and was removed with
`MollifiedSupNormFunctional`.
-/

open MeasureTheory
open scoped RealInnerProductSpace
open NavierStokes3D ArnoldGeometric

namespace FrohmanianTether

/-- Functionals on the phase space. -/
abbrev Functional := CoadjointOrbit → ℝ

/-- Candidate bracket corrections `B(ω; F, G)`. -/
abbrev Bracket := CoadjointOrbit → Functional → Functional → ℝ

noncomputable section

variable (S : ArnoldSetting) (κ : ℝ)

/-- The tether kernel `B_κ(ω; F, G) = -κ ∫_{𝕋³} ‖ω‖² ⟨Π_u δF/δω, Π_u δG/δω⟩ dx`. -/
def TetherKernel (ω : CoadjointOrbit) (F G : Functional) : ℝ :=
  -κ * ∫ x, ‖ω.val x‖ ^ 2 *
    ⟪ForMathlib.Pi_u (velocity_from_vorticity S ω) (S.funcDeriv F ω) x,
      ForMathlib.Pi_u (velocity_from_vorticity S ω) (S.funcDeriv G ω) x⟫ ∂torusVolume

/-- The tethered bracket `{F, G}_κ = {F, G} + B_κ(·; F, G)`. -/
def TetheredBracket (F G : Functional) (ω : CoadjointOrbit) : ℝ :=
  ClassicalBracket S F G ω + TetherKernel S κ ω F G

/-- Antisymmetry `B(ω; F, G) = -B(ω; G, F)`. -/
def IsAntisymmetric (B : Bracket) : Prop := ∀ ω F G, B ω F G = -B ω G F

/-- (C1) invariance under the coadjoint action. -/
def InvariantUnderCoadjointAction (B : Bracket) : Prop :=
  ∀ (g : T3 → T3) (F G : Functional) (ω : CoadjointOrbit),
    B (CoadjointAction S g ω) F G = B ω F G

/-- (C2) degeneracy with respect to the kinetic energy `H`. -/
def DegenerateWRTKineticEnergy (B : Bracket) : Prop :=
  ∀ (F : Functional) (ω : CoadjointOrbit), B ω F (KineticEnergyHamiltonian S) = 0

/-- (C3) sign of the feedback, `B(ω; F, F) ≤ 0`, as stated in the source. -/
def ProducesControllableNegativeFeedback (B : Bracket) : Prop :=
  ∀ (F : Functional) (ω : CoadjointOrbit), B ω F F ≤ 0

/-- The Jacobi identity for `{·,·}_κ`. A statement only; it is not proved or assumed anywhere. -/
def TetheredJacobiIdentity : Prop :=
  ∀ (F G H : Functional) (ω : CoadjointOrbit),
    TetheredBracket S κ F (TetheredBracket S κ G H) ω +
      TetheredBracket S κ G (TetheredBracket S κ H F) ω +
      TetheredBracket S κ H (TetheredBracket S κ F G) ω = 0

theorem tetherKernel_symm (ω : CoadjointOrbit) (F G : Functional) :
    TetherKernel S κ ω F G = TetherKernel S κ ω G F := by
  simp only [TetherKernel]
  congr 2; funext x; rw [real_inner_comm]

theorem tetherKernel_feedback (hκ : 0 ≤ κ) :
    ProducesControllableNegativeFeedback (TetherKernel S κ) := by
  intro F ω
  have h : 0 ≤ ∫ x, ‖ω.val x‖ ^ 2 *
      ⟪ForMathlib.Pi_u (velocity_from_vorticity S ω) (S.funcDeriv F ω) x,
        ForMathlib.Pi_u (velocity_from_vorticity S ω) (S.funcDeriv F ω) x⟫ ∂torusVolume :=
    integral_nonneg fun x => mul_nonneg (sq_nonneg _) real_inner_self_nonneg
  simp only [TetherKernel]
  exact mul_nonpos_of_nonpos_of_nonneg (neg_nonpos.mpr hκ) h

theorem tetherKernel_degenerate (hE : EnergyGradientIsVelocity S) (ω : CoadjointOrbit)
    (hω : ∫ y, ‖velocity_from_vorticity S ω y‖ ^ 2 ∂torusVolume ≠ 0) (F : Functional) :
    TetherKernel S κ ω F (KineticEnergyHamiltonian S) = 0 := by
  simp only [TetherKernel]
  rw [hE ω, ForMathlib.projection_orthogonal_to_u _ hω]
  simp

theorem tethered_reproduces_classical_euler (hE : EnergyGradientIsVelocity S)
    (ω : CoadjointOrbit)
    (hω : ∫ y, ‖velocity_from_vorticity S ω y‖ ^ 2 ∂torusVolume ≠ 0) (F : Functional) :
    TetheredBracket S κ F (KineticEnergyHamiltonian S) ω =
      ClassicalBracket S F (KineticEnergyHamiltonian S) ω := by
  simp [TetheredBracket, tetherKernel_degenerate S κ hE ω hω F]

/-- (C2) for `B_κ` when (EG) holds and every `u = BS(ω)` has `‖u‖²_{L²} ≠ 0`. -/
theorem tetherKernel_degenerateWRT (hE : EnergyGradientIsVelocity S)
    (hω : ∀ ω : CoadjointOrbit, ∫ y, ‖velocity_from_vorticity S ω y‖ ^ 2 ∂torusVolume ≠ 0) :
    DegenerateWRTKineticEnergy S (TetherKernel S κ) :=
  fun F ω => tetherKernel_degenerate S κ hE ω (hω ω) F

/-- On the diagonal the tethered bracket is the tether kernel: `{F, F}_κ = B_κ(·; F, F)`. -/
theorem tetheredBracket_self (F : Functional) (ω : CoadjointOrbit) :
    TetheredBracket S κ F F ω = TetherKernel S κ ω F F := by
  simp [TetheredBracket, classicalBracket_self]

end

notation "𝔉𝕋" => TetheredBracket

end FrohmanianTether
