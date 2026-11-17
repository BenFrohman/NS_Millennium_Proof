/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import Mathlib
import NS_Millennium_Proof.Modules.TetheredLyapunov

/-!
# Status of the N1 Lyapunov differential inequality (`lyapunov_differential_inequality`)

The paper's N1 row once listed `lyapunov_differential_inequality` as "Proved axiom-clean". No
declaration of that name has ever existed in this repository (it appeared only in a comment of the
stub `Modules/AnalyticEstimates.lean`, now kept unbuilt at `drafts/AnalyticEstimates_stub.lean`).

**Intended statement** (paper `eq:orig_dS`, the stub's comment): along a local smooth solution,
for the mollified quartic functional `S_ε = ∫ (½|ω_ε|² + (κ/4)|ω_ε|⁴ φ_ε)`,
`dS_ε/dt ≤ C_abs (1 + M_ε³ ‖φ_ε‖_∞^{3/2}) − κ' ∫ |ω_ε|⁶`.

**What exists.** `TetheredLyapunov.differential_inequality_after_tether_and_absorption` (and its
wrapper `key_differential_inequality`), both module-private, conclude exactly this inequality, but
from hypotheses that include
* `hIdent : dS_ε/dt ≤ 4 C_CZ M_ε ∫|ω_ε|⁴|φ| − κ ∫|ω_ε|⁶` (the transport / viscosity / stretching
  identification; OPEN, and its pointwise-CZ derivation uses an `L∞` Calderón–Zygmund bound, which
  is false classically), and
* `h1 : MemLp (fun _ : T3 => 1) 3 volume`, which is **false** on the model space `T3 = ℝ³`
  (infinite Lebesgue measure). This file proves that (`key_di_h1_hypothesis_unsatisfiable`).

Hence those lemmas are vacuous as stated, and the differential inequality is **not proved** here.
On the genuine torus, the exact identity for `dS/dt` is proved in the separate repository
`weighted-enstrophy-identities` (`WeightedEnstrophy.Lyapunov.dS_identity_smooth`, commit
`9e4cfd22`); the closing steps `CalderonZygmundLp`, `WeightedToSupReduction`, `PhiSupControl`
there are open.
-/

open MeasureTheory hiding volume
open NavierStokes3D

namespace LyapunovDIStatus

/-- The hypothesis `h1` of `differential_inequality_after_tether_and_absorption` /
`key_differential_inequality` (`MemLp (fun _ : T3 => 1) 3 volume`) is false: `volume` on
`T3 = EuclideanSpace ℝ (Fin 3)` is infinite. -/
theorem key_di_h1_hypothesis_unsatisfiable :
    ¬ MemLp (fun _ : T3 => (1 : ℝ)) (ENNReal.ofReal 3) NavierStokes3D.volume := by
  intro h
  have hv : NavierStokes3D.volume = (MeasureTheory.volume : Measure T3) := rfl
  rw [hv, memLp_const_iff (by simp) (by simp)] at h
  rcases h with h | h
  · exact one_ne_zero h
  · simp at h

end LyapunovDIStatus

#print axioms LyapunovDIStatus.key_di_h1_hypothesis_unsatisfiable
