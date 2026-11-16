/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

module

public import NS_Millennium_Proof.Modules.GlobalRegularity

/-!
# Honest reduction (2026-10-13)

What this repository proves, stated without overclaiming.

* **Proved** (`conditional_global_regularity`): global smooth, unique solvability of
  3D incompressible Navier–Stokes on `T³` *given* the open hypothesis
  `TetherCoefficientBounded` (a T-uniform `L^∞` vorticity / BKM-type bound, which is
  what the paper's coefficient `C_univ M_ε² ‖φ_ε‖_∞^{3/2}` staying bounded uniformly in
  `T` amounts to), plus the classical local-theory inputs (Kato witness, restart time,
  uniqueness of smooth solutions) taken as explicit hypotheses.
* **Open**: `TetherCoefficientBounded` itself for all smooth divergence-free data.
  This is equivalent in strength to the Clay Millennium problem. It is a `Prop`
  definition here, **not** an axiom and **not** a `sorry`'d theorem.
* **Disproved as stated**: `reduced_pairing_of_unmodified_and_tether`
  (see `HWEIGHT_OBSTRUCTION.md`); it has been removed from the build.

This is a conditional result / reduction, not a solution of the Clay problem.
-/

namespace HonestReduction

open FrohmanianTether TetheredLyapunov NavierStokes3D MeasureTheory GlobalRegularity

/-- **Open hypothesis (not proved anywhere in this repository).**
T-uniform control of the vorticity sup-norm for every Navier–Stokes solution issuing
from `u₀` with viscosity `ν`: one constant `Y`, independent of `T`, bounds
`‖ω(t)‖_∞` for all `t ≥ 0`, and `t ↦ ‖ω(t)‖_∞` is continuous.
This is the form in which the paper's tether coefficient bound is used; proving it for
all smooth data is equivalent in strength to the Clay problem. -/
public def TetherCoefficientBounded (u₀ : VelocityField) (ν : ℝ) : Prop :=
  ∀ u : ℝ → VelocityField, ∀ p : ℝ → PressureField,
    NS_PDE u p ν → u 0 = u₀ →
      ∃ Y : ℝ,
        (∀ τ ≥ (0 : ℝ), GlobalRegularity.vorticity_sup_norm (vorticity (u τ)) ≤ Y) ∧
        Continuous (fun τ : ℝ => GlobalRegularity.vorticity_sup_norm (vorticity (u τ)))

/-- The global-regularity conclusion (Clay-style, on `T³`) for given data. -/
public def GlobalRegularityFor (u0 : TimeDependentVelocity) (ν : ℝ) : Prop :=
  ∃ (u : TimeDependentVelocity),
    (∀ t ≥ (0 : ℝ), IsSmooth (u t)) ∧
    (u 0 = u0 0) ∧
    (∀ t ≥ (0 : ℝ), satisfies_NavierStokes u ν) ∧
    (∀ t ≥ (0 : ℝ), GlobalRegularity.vorticity_sup_norm (vorticity (u t)) ≥ 0) ∧
    (∀ v : TimeDependentVelocity,
      (∀ t ≥ (0 : ℝ), IsSmooth (v t)) →
      v 0 = u0 0 →
      (∀ t ≥ (0 : ℝ), satisfies_NavierStokes v ν) →
      ∀ t ≥ (0 : ℝ), v t = u t)

/-- **Conditional global regularity (proved, sorry-free).**
`TetherCoefficientBounded` + classical local theory ⟹ global regularity.
Reuses `GlobalRegularity.global_regularity_for_NS`. The hypothesis
`TetherCoefficientBounded` remains open. -/
public theorem conditional_global_regularity
    (u0 : TimeDependentVelocity)
    (h_div_free : ∀ t x, div (u0 t) x = 0)
    (h_smooth : IsSmooth (u0 0))
    (h_finite_energy : Integrable (fun x : T3 => ‖u0 0 x‖ ^ 2))
    (ν : ℝ) (h_ν_pos : ν > 0)
    (w : KatoLocalWitness (u0 0) ν)
    (hBound : TetherCoefficientBounded (u0 0) ν)
    (τ : ℝ) (hτ : 0 < τ)
    (hrestart : ∀ t : ℝ, 0 ≤ t → (t : EReal) < Tstar (u0 0) ν →
      ∃ T' ∈ existenceTimes (u0 0) ν, t + τ ≤ T')
    (huniq : ∀ (T' : ℝ) (v : TimeDependentVelocity) (q : TimeDependentPressure),
      T' ∈ existenceTimes (u0 0) ν →
      v 0 = u0 0 →
      NS_PDE v q ν →
      (∀ t ∈ Set.Icc (0 : ℝ) T', ContDiff ℝ ⊤ (v t)) →
      ∀ t ∈ Set.Icc (0 : ℝ) T', w.u t = v t) :
    GlobalRegularityFor u0 ν :=
  global_regularity_for_NS u0 h_div_free h_smooth h_finite_energy ν h_ν_pos w
    hBound τ hτ hrestart huniq

/-- **Converse direction (stated, NOT proved).**
Global regularity for `u0` ⟹ `TetherCoefficientBounded (u0 0) ν`.
Smoothness for all `t` only gives a bound on each finite `[0,T]`; a `T`-uniform bound
additionally needs long-time decay (energy dissipation + parabolic smoothing on `T³`),
which is not formalized in this repository. Kept as a `Prop` (no `sorry`, no axiom):
it is the reduction's remaining bookkeeping. -/
public def ConverseReduction (u0 : TimeDependentVelocity) (ν : ℝ) : Prop :=
  GlobalRegularityFor u0 ν → TetherCoefficientBounded (u0 0) ν

end HonestReduction

#print axioms HonestReduction.conditional_global_regularity
#print axioms GlobalRegularity.frohmanian_tether_theorem
#print axioms GlobalRegularity.global_regularity_for_NS
