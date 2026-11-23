/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import NS_Millennium_Proof.Modules.Continuation
import NS_Millennium_Proof.Modules.TetheredLyapunov
import NS_Millennium_Proof.Modules.SymplecticTether

/-!
# Conditional global regularity for 3D Navier–Stokes on `𝕋³`

**This file does not prove global regularity of the Navier–Stokes equations and does not
solve the Clay Millennium problem.** It proves that global regularity *follows from* four named
hypotheses, three classical and one open:

* (KL)  `KatoLocalExistence ν`          — classical (Kato 1972), not formalized here;
* (U)   `ClassicalUniqueness ν`         — classical, not formalized here;
* (BKM) `BealeKatoMajdaContinuation ν`  — classical (Beale–Kato–Majda 1984), not formalized here;
* (TM)  `TetherMajorantInequality ν C κ''` — **open**; it is the analytic claim of the source.

Main results:

* `glue`: classical solutions with the same data glue to a solution on the union of their
  intervals (from (U)).
* `conditional_global_regularity_for_NS`: (KL) + (U) + (BKM) + (TM) imply that every smooth,
  divergence-free, periodic `u₀` generates a classical solution on `[0, ∞)`, unique on `[0, ∞)`.
* `frohmanian_tether_theorem_conditional`: the proved properties of the tether kernel.

Uniqueness is stated on `[0, ∞)`. The earlier statement used `∃! u : ℝ → VelocityField`, which
is false as written because the values of `u` at negative times are unconstrained.
-/

open Set Filter Topology MeasureTheory
open NavierStokes3D ArnoldGeometric FrohmanianTether TetheredLyapunov

namespace GlobalRegularity

/-- Gluing: if, for each `t ∈ [0, T)`, `S (τ t)` is a classical solution on `[0, τ t)` with
data `u₀` and `t < τ t`, then `t ↦ S (τ t) t` is a classical solution on `[0, T)`. -/
theorem glue {ν T : ℝ} (hU : ClassicalUniqueness ν) {u₀ : VelocityField}
    (S : ℝ → TimeDependentVelocity) (P : ℝ → TimeDependentPressure) (τ : ℝ → ℝ)
    (hS : ∀ t ∈ Ico 0 T,
      IsClassicalSolutionOn ν (S (τ t)) (P (τ t)) (τ t) ∧ S (τ t) 0 = u₀ ∧ t < τ t) :
    IsClassicalSolutionOn ν (fun t => S (τ t) t) (fun t => P (τ t) t) T := by
  have hagree : ∀ s ∈ Ico 0 T, ∀ t ∈ Ico 0 T, s < τ t → S (τ s) s = S (τ t) s :=
    fun s hs t ht hst => hU _ _ _ _ (τ s) (τ t) (hS s hs).1 (hS t ht).1
      ((hS s hs).2.1.trans (hS t ht).2.1.symm) s hs.1 (hS s hs).2.2 hst
  refine ⟨fun t ht => (hS t ht).1.1 t ⟨ht.1, (hS t ht).2.2⟩, fun t ht x => ?_, fun x => ?_⟩
  · have htT : t ∈ Ico 0 T := ⟨ht.1.le, ht.2⟩
    have hd := (hS t htT).1.2.1 t ⟨ht.1, (hS t htT).2.2⟩ x
    refine hd.congr_of_eventuallyEq ?_
    filter_upwards [Ioo_mem_nhds ht.1 (lt_min ht.2 (hS t htT).2.2)] with s hs
    have hsT : s ∈ Ico 0 T := ⟨hs.1.le, hs.2.trans_le (min_le_left _ _)⟩
    show S (τ s) s x = S (τ t) s x
    rw [hagree s hsT t htT (hs.2.trans_le (min_le_right _ _))]
  · by_cases hT : 0 < T
    · have h0 : (0 : ℝ) ∈ Ico 0 T := ⟨le_rfl, hT⟩
      have hc := (hS 0 h0).1.2.2 x
      have hmem : Ico 0 (τ 0) ∈ 𝓝[Ico 0 T] (0 : ℝ) :=
        mem_nhdsWithin.mpr ⟨Iio (τ 0), isOpen_Iio, (hS 0 h0).2.2, fun s hs => ⟨hs.2.1, hs.1⟩⟩
      refine (hc.mono_of_mem_nhdsWithin hmem).congr_of_eventuallyEq ?_ rfl
      filter_upwards [inter_mem self_mem_nhdsWithin
        (mem_nhdsWithin_of_mem_nhds (Iio_mem_nhds (hS 0 h0).2.2))] with s hs
      show S (τ s) s x = S (τ 0) s x
      rw [hagree s hs.1 0 h0 hs.2]
    · rw [Ico_eq_empty hT]
      exact continuousWithinAt_empty

/-- **Conditional global regularity.** Under (KL), (U), (BKM) and (TM), every admissible
`u₀` generates a classical solution of the Navier–Stokes equations on `[0, ∞)`, and any two
such solutions agree on `[0, ∞)`. -/
theorem conditional_global_regularity_for_NS {ν C κ'' : ℝ} (hC : 0 < C) (hκ : 0 < κ'')
    (hKL : KatoLocalExistence ν) (hU : ClassicalUniqueness ν)
    (hBKM : BealeKatoMajdaContinuation ν) (hTM : TetherMajorantInequality ν C κ'')
    (u₀ : VelocityField) (hadm : IsAdmissibleData u₀) :
    (∃ (u : TimeDependentVelocity) (p : TimeDependentPressure),
        u 0 = u₀ ∧ ∀ T, IsClassicalSolutionOn ν u p T) ∧
      ∀ (u v : TimeDependentVelocity) (p q : TimeDependentPressure),
        u 0 = u₀ → (∀ T, IsClassicalSolutionOn ν u p T) →
        v 0 = u₀ → (∀ T, IsClassicalSolutionOn ν v q T) → ∀ t ≥ 0, u t = v t := by
  obtain ⟨T₁, hT₁, u₁, p₁, hu₁, hs₁⟩ := hKL u₀ hadm
  have hall : ∀ T, ∃ (u : TimeDependentVelocity) (p : TimeDependentPressure),
      u 0 = u₀ ∧ IsClassicalSolutionOn ν u p T := by
    refine Continuation.global_of_continuation
      (E := fun T => ∃ (u : TimeDependentVelocity) (p : TimeDependentPressure),
        u 0 = u₀ ∧ IsClassicalSolutionOn ν u p T)
      (Bd := fun T => ∀ (u : TimeDependentVelocity) (p : TimeDependentPressure),
        u 0 = u₀ → IsClassicalSolutionOn ν u p T → VorticityBoundedOn u T)
      ⟨T₁, hT₁, u₁, p₁, hu₁, hs₁⟩ ?_ ?_ ?_ ?_
    · rintro T T' ⟨u, p, h0, hs⟩ hle
      exact ⟨u, p, h0, hs.mono hle⟩
    · intro T h
      by_cases hT : 0 < T
      · choose! S P hSP using h
        refine ⟨fun t => S ((t + T) / 2) t, fun t => P ((t + T) / 2) t, ?_, ?_⟩
        · exact (hSP ((0 + T) / 2) (by linarith)).1
        · refine glue hU S P (fun t => (t + T) / 2) fun t ht => ?_
          exact ⟨(hSP _ (by linarith [ht.2])).2, (hSP _ (by linarith [ht.2])).1,
            by linarith [ht.2]⟩
      · exact ⟨u₁, p₁, hu₁, hs₁.mono (by linarith)⟩
    · rintro T hT ⟨u, p, h0, hs⟩ hbd
      obtain ⟨T', hT', v, q, hv0, hv⟩ := hBKM u₀ hadm T hT u p h0 hs (hbd u p h0 hs)
      exact ⟨T', hT', v, q, hv0, hv⟩
    · intro T hT _ u p h0 hs
      exact vorticityBoundedOn_of_tether hC hκ hTM hadm hT h0 hs
  refine ⟨?_, fun u v p q hu0 hu hv0 hv t ht =>
    hU u v p q (t + 1) (t + 1) (hu (t + 1)) (hv (t + 1)) (hu0.trans hv0.symm) t ht
      (by linarith) (by linarith)⟩
  choose! S P hSP using hall
  refine ⟨fun t => S (t + 1) t, fun t => P (t + 1) t, (hSP (0 + 1)).1, fun T => ?_⟩
  exact glue hU S P (fun t => t + 1) fun t _ => ⟨(hSP _).2, (hSP _).1, by linarith⟩

/-- **The proved properties of the tether kernel** `B_κ` (for `0 ≤ κ`): it is symmetric in
`(F, G)`, satisfies the sign condition (C3), and, under (EG) `δH/δω = u` and
`‖u‖²_{L²} ≠ 0`, it is degenerate on `H` so that `{F, H}_κ = {F, H}`. -/
theorem frohmanian_tether_theorem_conditional (S : ArnoldSetting) {κ : ℝ} (hκ : 0 ≤ κ) :
    (∀ ω F G, TetherKernel S κ ω F G = TetherKernel S κ ω G F) ∧
      ProducesControllableNegativeFeedback (TetherKernel S κ) ∧
      (EnergyGradientIsVelocity S → ∀ ω : CoadjointOrbit,
        ∫ y, ‖velocity_from_vorticity S ω y‖ ^ 2 ∂torusVolume ≠ 0 → ∀ F,
          TetheredBracket S κ F (KineticEnergyHamiltonian S) ω =
            ClassicalBracket S F (KineticEnergyHamiltonian S) ω) :=
  ⟨tetherKernel_symm S κ, tetherKernel_feedback S κ hκ,
    fun hE ω hω F => tethered_reproduces_classical_euler S κ hE ω hω F⟩

#print axioms conditional_global_regularity_for_NS
#print axioms frohmanian_tether_theorem_conditional

end GlobalRegularity
