/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import NS_Millennium_Proof.Modules.NS_Equations
import NS_Millennium_Proof.Modules.IndependentMajorant

/-!
# The tethered majorant hypothesis and the a-priori vorticity bound

The analytic layer of the source argues that, along a classical solution, the mollified
sup-norm `M_ε(t) = ‖ω_ε(t)‖_{L^∞}` satisfies the differential inequality
`M_ε' ≤ C M_ε² - κ'' M_ε³` (tether feedback, Calderón–Zygmund, Hölder, Sobolev,
Gagliardo–Nirenberg and Young absorption). **That inequality is not proved in this repository.**
It is the named open hypothesis

* `TetherMajorantInequality ν C κ''` (TM): for every classical solution on `[0, T)` there is a
  differentiable `M` with `M' ≤ C M² - κ'' M³` on `[0, T)` and `‖ω(t, x)‖ ≤ M(t)`.

Proved from (TM) with the pure ODE lemma `IndependentMajorant.le_max_of_subsolution`:

* `apriori_vorticity_bound`: `‖ω(t, x)‖ ≤ max (M 0) (C / κ'')` on `[0, T)`;
* `vorticityBoundedOn_of_tether`: `sup_{t < T} ‖ω(t)‖_{L^∞} < ∞`.

(TM) is at least as strong as an a-priori bound on `‖ω‖_{L^∞}`, which by Beale–Kato–Majda is
the heart of the global regularity problem. Assuming it is not a proof of global regularity.

The earlier version of this file contained `sorry`-bodied definitions (`StandardMollifier`,
`MollifiedVorticity`, `EnstrophyAccumulation`, `ComparisonODE`, `Tstar`) and lemmas whose
statements were `True`; they are replaced by the hypothesis and theorems above.
-/

open Set
open NavierStokes3D

namespace TetheredLyapunov

/-- **(TM) Tethered majorant inequality** (open hypothesis). -/
def TetherMajorantInequality (ν C κ'' : ℝ) : Prop :=
  ∀ (u₀ : VelocityField), IsAdmissibleData u₀ → ∀ T > 0,
    ∀ (u : TimeDependentVelocity) (p : TimeDependentPressure),
      u 0 = u₀ → IsClassicalSolutionOn ν u p T →
        ∃ M M' : ℝ → ℝ,
          (∀ t ∈ Ico 0 T, HasDerivAt M (M' t) t ∧ M' t ≤ C * M t ^ 2 - κ'' * M t ^ 3) ∧
          ∀ t ∈ Ico 0 T, ∀ x, ‖vorticity (u t) x‖ ≤ M t

/-- Under (TM), the vorticity obeys `‖ω(t, x)‖ ≤ max M₀ (C / κ'')` on `[0, T)`. -/
theorem apriori_vorticity_bound {ν C κ'' : ℝ} (hC : 0 < C) (hκ : 0 < κ'')
    (hTM : TetherMajorantInequality ν C κ'') {u₀ : VelocityField} (hadm : IsAdmissibleData u₀)
    {T : ℝ} (hT : 0 < T) {u : TimeDependentVelocity} {p : TimeDependentPressure}
    (hu0 : u 0 = u₀) (hsol : IsClassicalSolutionOn ν u p T) :
    ∃ M₀ : ℝ, ∀ t ∈ Ico 0 T, ∀ x, ‖vorticity (u t) x‖ ≤ max M₀ (C / κ'') := by
  obtain ⟨M, M', hM, hω⟩ := hTM u₀ hadm T hT u p hu0 hsol
  refine ⟨M 0, fun t ht x => (hω t ht x).trans ?_⟩
  exact IndependentMajorant.le_max_of_subsolution hC hκ (fun s hs => (hM s hs).1)
    (fun s hs => (hM s hs).2) t ht

theorem vorticityBoundedOn_of_tether {ν C κ'' : ℝ} (hC : 0 < C) (hκ : 0 < κ'')
    (hTM : TetherMajorantInequality ν C κ'') {u₀ : VelocityField} (hadm : IsAdmissibleData u₀)
    {T : ℝ} (hT : 0 < T) {u : TimeDependentVelocity} {p : TimeDependentPressure}
    (hu0 : u 0 = u₀) (hsol : IsClassicalSolutionOn ν u p T) : VorticityBoundedOn u T := by
  obtain ⟨M₀, h⟩ := apriori_vorticity_bound hC hκ hTM hadm hT hu0 hsol
  exact ⟨_, h⟩

end TetheredLyapunov
