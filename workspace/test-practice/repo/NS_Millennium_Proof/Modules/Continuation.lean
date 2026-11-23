/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import Mathlib.Order.ConditionallyCompleteLattice.Basic
import Mathlib.Data.Real.Archimedean

/-!
# An abstract continuation argument

`E T` reads "a solution exists on `[0, T)`" and `Bd T` reads "on `[0, T)` the blow-up quantity
(for Navier–Stokes: `‖ω‖_{L^∞}`) stays bounded". From

* (loc)  local existence: `E T` for some `T > 0`,
* (mono) restriction: `E T → T' ≤ T → E T'`,
* (glue) gluing: if `E T'` for every `T' < T` then `E T`,
* (cont) continuation: `0 < T → E T → Bd T → E T'` for some `T' > T`,
* (bd)   a-priori bound: `0 < T → E T → Bd T`,

we prove `E T` for every `T` (`global_of_continuation`). The proof takes `s = sup {T | E T}`,
shows `E s` by gluing, and contradicts maximality with (bd) and (cont).
`NonVacuity.lean` shows that each of the five hypotheses is needed.
-/

namespace Continuation

theorem global_of_continuation {E Bd : ℝ → Prop}
    (hloc : ∃ T > 0, E T)
    (hmono : ∀ T T', E T → T' ≤ T → E T')
    (hglue : ∀ T, (∀ T' < T, E T') → E T)
    (hcont : ∀ T, 0 < T → E T → Bd T → ∃ T' > T, E T')
    (hbd : ∀ T, 0 < T → E T → Bd T) :
    ∀ T, E T := by
  intro T₀
  by_contra hT₀
  obtain ⟨T₁, hT₁pos, hT₁⟩ := hloc
  have hlt : ∀ T, E T → T < T₀ := fun T hT => by
    by_contra h
    exact hT₀ (hmono T T₀ hT (not_lt.mp h))
  have hne : ({T | E T} : Set ℝ).Nonempty := ⟨T₁, hT₁⟩
  have hbdd : BddAbove {T | E T} := ⟨T₀, fun T hT => (hlt T hT).le⟩
  set s := sSup {T | E T}
  have hT₁s : T₁ ≤ s := le_csSup hbdd hT₁
  have hEs : E s := hglue s fun T' hT' => by
    obtain ⟨T, hT, hT'T⟩ := exists_lt_of_lt_csSup hne hT'
    exact hmono T T' hT hT'T.le
  have hspos : 0 < s := lt_of_lt_of_le hT₁pos hT₁s
  obtain ⟨T', hT's, hT'⟩ := hcont s hspos hEs (hbd s hspos hEs)
  exact absurd (le_csSup hbdd hT') (not_le.mpr hT's)

end Continuation
