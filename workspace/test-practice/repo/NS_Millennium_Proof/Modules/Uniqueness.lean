/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import NS_Millennium_Proof.Modules.SymplecticTether
import Mathlib.MeasureTheory.Constructions.Pi

/-!
# The claimed uniqueness of the minimal tether (5-step canonicity) is refuted

The source claims (Theorem 2.3, "5-step canonicity") that the tether kernel `B_κ` is the unique
bracket correction `B` that is antisymmetric and satisfies (C1)–(C3). Formalized with the
definitions of `SymplecticTether.lean` this is `MinimalTetherUniqueness S κ`.

Proved here:
* `zero_bracket_satisfies_conditions`: the zero bracket `B = 0` is antisymmetric and satisfies
  (C1), (C2) and (C3) in every setting.
* `antisymmetric_feedback_vacuous`: for an antisymmetric `B`, `B(ω; F, F) = 0`, so (C3) holds
  automatically and carries no information.
* `uniqueness_forces_zero_kernel`: `MinimalTetherUniqueness S κ` implies `B_κ ≡ 0`.
* `tetheredBracket_antisymm_forces_zero`: if `{·,·}_κ` is antisymmetric then
  `B_κ(ω; F, F) = 0` for all `ω, F`.
* `not_minimalTetherUniqueness`: in the explicit setting `S₀` (constant fields) and for every
  `κ ≠ 0`, `B_κ(ω₀; F, F) = -κ ≠ 0`; hence `MinimalTetherUniqueness S₀ κ` is false and `{·,·}_κ`
  is not antisymmetric there.

So the uniqueness claim cannot be used as a hypothesis: it is false. The earlier lemmas
`step1_locality` … `step5_higher_order`, `uniqueness_of_minimal_tether` and
`uniqueness_of_global_regular_solutions_placeholder` all had statement `True` and were removed.
-/

open MeasureTheory Set
open scoped RealInnerProductSpace
open NavierStokes3D ArnoldGeometric

namespace FrohmanianTether

noncomputable section

/-- The source's uniqueness claim: every antisymmetric `B` with (C1)–(C3) equals `B_κ`. -/
def MinimalTetherUniqueness (S : ArnoldSetting) (κ : ℝ) : Prop :=
  ∀ B : Bracket, IsAntisymmetric B → InvariantUnderCoadjointAction S B →
    DegenerateWRTKineticEnergy S B → ProducesControllableNegativeFeedback B →
      B = TetherKernel S κ

theorem zero_bracket_satisfies_conditions (S : ArnoldSetting) :
    IsAntisymmetric (fun _ _ _ => (0 : ℝ)) ∧
      InvariantUnderCoadjointAction S (fun _ _ _ => 0) ∧
      DegenerateWRTKineticEnergy S (fun _ _ _ => 0) ∧
      ProducesControllableNegativeFeedback (fun _ _ _ => 0) :=
  ⟨fun _ _ _ => by simp, fun _ _ _ _ => rfl, fun _ _ => rfl, fun _ _ => le_rfl⟩

theorem antisymmetric_feedback_vacuous (B : Bracket) (h : IsAntisymmetric B)
    (ω : CoadjointOrbit) (F : Functional) : B ω F F = 0 := by
  have := h ω F F
  linarith

theorem uniqueness_forces_zero_kernel (S : ArnoldSetting) (κ : ℝ)
    (h : MinimalTetherUniqueness S κ) (ω : CoadjointOrbit) (F G : Functional) :
    TetherKernel S κ ω F G = 0 := by
  obtain ⟨h1, h2, h3, h4⟩ := zero_bracket_satisfies_conditions S
  exact (congrFun (congrFun (congrFun (h _ h1 h2 h3 h4) ω) F) G).symm

theorem tetheredBracket_antisymm_forces_zero (S : ArnoldSetting) (κ : ℝ)
    (h : ∀ (F G : Functional) ω, TetheredBracket S κ F G ω = -TetheredBracket S κ G F ω)
    (ω : CoadjointOrbit) (F : Functional) : TetherKernel S κ ω F F = 0 := by
  have := h F F ω
  rw [tetheredBracket_self] at this
  linarith

/-! ## An explicit setting in which `B_κ ≠ 0` -/

theorem volume_cell : volume cell = 1 := by
  have hcell : cell = (MeasurableEquiv.toLp 2 (Fin 3 → ℝ)).symm ⁻¹'
      (Set.pi univ fun _ => Ico (0 : ℝ) 1) := by
    ext x; simp [cell, Set.mem_pi]
  rw [hcell, (EuclideanSpace.volume_preserving_symm_measurableEquiv_toLp (Fin 3)).measure_preimage
    (MeasurableSet.univ_pi fun _ => measurableSet_Ico).nullMeasurableSet]
  simp [volume_pi_pi, Real.volume_Ico]

/-- The constant vorticity field `ω₀ = e₃` (periodic and divergence-free). -/
def ω₀ : CoadjointOrbit :=
  ⟨fun _ => e 2, fun _ _ => rfl, fun x => by simp [div, partialDeriv]⟩

/-- The setting `S₀`: `BS(ω) = e₁`, `δF/δω = e₂`, trivial action. -/
def S₀ : ArnoldSetting where
  biotSavart := fun _ _ => e 0
  funcDeriv := fun _ _ _ => e 1
  coadjointAction := fun _ ω => ω

theorem tetherKernel_S₀ (κ : ℝ) (F : Functional) : TetherKernel S₀ κ ω₀ F F = -κ := by
  have h10 : ⟪e 1, e 0⟫ = (0 : ℝ) := by simp [e, EuclideanSpace.inner_single_left]
  have hPi : ForMathlib.Pi_u (velocity_from_vorticity S₀ ω₀) (S₀.funcDeriv F ω₀) =
      fun _ => e 1 := by
    funext x
    simp [ForMathlib.Pi_u, NS.FrohmanianTether.Pi_u, velocity_from_vorticity, S₀, h10]
  have h11 : ⟪e 1, e 1⟫ = (1 : ℝ) := by simp [e, EuclideanSpace.inner_single_left]
  have hω : ∀ x, ‖ω₀.val x‖ = 1 := fun x => by simp [ω₀, e]
  simp only [TetherKernel, hPi, hω, h11]
  simp [torusVolume, Measure.real, volume_cell]

theorem not_minimalTetherUniqueness (κ : ℝ) (hκ : κ ≠ 0) :
    ¬ MinimalTetherUniqueness S₀ κ := fun h => by
  have := uniqueness_forces_zero_kernel S₀ κ h ω₀ (fun _ => 0) (fun _ => 0)
  rw [tetherKernel_S₀] at this
  exact hκ (neg_eq_zero.mp this)

theorem tetheredBracket_S₀_not_antisymm (κ : ℝ) (hκ : κ ≠ 0) :
    ¬ ∀ (F G : Functional) ω, TetheredBracket S₀ κ F G ω = -TetheredBracket S₀ κ G F ω :=
  fun h => by
    have := tetheredBracket_antisymm_forces_zero S₀ κ h ω₀ (fun _ => 0)
    rw [tetherKernel_S₀] at this
    exact hκ (neg_eq_zero.mp this)

end

end FrohmanianTether
