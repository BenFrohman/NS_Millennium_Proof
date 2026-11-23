/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import NS_Millennium_Proof.Modules.NS_Equations
import ForMathlib.NS.Tether

/-!
# Arnold's geometric framework: phase space, setting and classical Lie–Poisson bracket

* `CoadjointOrbit` is the phase space of periodic, divergence-free vorticity fields `ω`
  (the regular dual `𝔤*` of the Lie algebra of `SDiff(𝕋³)`; individual coadjoint orbits are not
  singled out).
* Mathlib has no Biot–Savart operator on `𝕋³`, no functional derivative `δF/δω` on this phase
  space and no coadjoint action of `SDiff(𝕋³)`. These three objects are therefore **fields of
  the structure `ArnoldSetting`**, and every definition below takes the setting `S` as an
  argument. Facts about them are never assumed silently: they appear as named hypotheses.
* `ClassicalBracket S F G ω = ∫_{𝕋³} ⟨ω, δF/δω × δG/δω⟩ dx` (Arnold's Lie–Poisson bracket) and
  `KineticEnergyHamiltonian S ω = ½ ∫_{𝕋³} ‖u‖² dx` with `u = S.biotSavart ω`.

Named hypothesis used later:
* `EnergyGradientIsVelocity S`: `δH/δω = u`. This is the identity the source papers use.
  Caution: for the classical `L²` functional derivative with respect to `ω` one has
  `δH/δω = ψ = (-Δ)⁻¹ ω` (the vector stream function, `u = curl ψ`), not `u`; so this hypothesis
  is an assumption of the source, not a classical fact.

Arnold's theorem that this bracket generates the Euler equations (Arnold 1966) is cited in the
paper's sources and is not formalized here. The earlier `classical_bracket_reproduces_Euler`
had statement `True` and claimed nothing, so it was removed.
-/

open MeasureTheory
open scoped RealInnerProductSpace
open NavierStokes3D

namespace ArnoldGeometric

/-- The phase space: periodic, divergence-free vorticity fields `ω`. -/
def CoadjointOrbit : Type := {ω : VorticityField // IsPeriodic ω ∧ ∀ x, div ω x = 0}

/-- The classical objects not available in Mathlib, as data. -/
structure ArnoldSetting where
  /-- The Biot–Savart operator `ω ↦ u` (an inverse of `curl` on divergence-free fields). -/
  biotSavart : VorticityField → VelocityField
  /-- The functional derivative `δF/δω` of a functional `F` at `ω`. -/
  funcDeriv : (CoadjointOrbit → ℝ) → CoadjointOrbit → VelocityField
  /-- The coadjoint action of a volume-preserving map `g` on the phase space. -/
  coadjointAction : (T3 → T3) → CoadjointOrbit → CoadjointOrbit

noncomputable section

variable (S : ArnoldSetting)

/-- `δF/δω`. -/
def FunctionalDerivative (F : CoadjointOrbit → ℝ) (ω : CoadjointOrbit) : VelocityField :=
  S.funcDeriv F ω

/-- The velocity `u = BS(ω)` of a vorticity field. -/
def velocity_from_vorticity (ω : CoadjointOrbit) : VelocityField := S.biotSavart ω.val

/-- The coadjoint action of `g` on `ω`. -/
def CoadjointAction (g : T3 → T3) (ω : CoadjointOrbit) : CoadjointOrbit :=
  S.coadjointAction g ω

/-- Arnold's Lie–Poisson bracket `{F, G}(ω) = ∫_{𝕋³} ⟨ω, δF/δω × δG/δω⟩ dx`. -/
def ClassicalBracket (F G : CoadjointOrbit → ℝ) (ω : CoadjointOrbit) : ℝ :=
  ∫ x, ⟪ω.val x, NS.FrohmanianTether.cross (S.funcDeriv F ω x) (S.funcDeriv G ω x)⟫ ∂torusVolume

/-- The kinetic energy `H(ω) = ½ ∫_{𝕋³} ‖u‖² dx`, `u = BS(ω)`. -/
def KineticEnergyHamiltonian (ω : CoadjointOrbit) : ℝ :=
  (1 / 2) * ∫ x, ‖S.biotSavart ω.val x‖ ^ 2 ∂torusVolume

/-- **Named hypothesis (EG):** `δH/δω = u` for every `ω`. See the caution in the module doc. -/
def EnergyGradientIsVelocity : Prop :=
  ∀ ω : CoadjointOrbit,
    S.funcDeriv (KineticEnergyHamiltonian S) ω = velocity_from_vorticity S ω

/-- `{F, F} = 0`: the classical bracket vanishes on the diagonal. -/
theorem classicalBracket_self (F : CoadjointOrbit → ℝ) (ω : CoadjointOrbit) :
    ClassicalBracket S F F ω = 0 := by
  simp [ClassicalBracket]

/-- The classical bracket is antisymmetric. -/
theorem classicalBracket_antisymm (F G : CoadjointOrbit → ℝ) (ω : CoadjointOrbit) :
    ClassicalBracket S G F ω = -ClassicalBracket S F G ω := by
  simp only [ClassicalBracket]
  rw [← integral_neg]
  congr 1; funext x
  rw [NS.FrohmanianTether.cross_anticomm, inner_neg_right]

end

end ArnoldGeometric
