/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
SPDX-License-Identifier: Apache-2.0
Authors: Benjamin Stanley Frohman
-/

module

/-!
# Assembly gap

Record only. This file does not discharge `hRiccati`,
`global_regularity_for_NS`, or `frohmanian_tether_theorem`.

`hRiccati` is a label for the package `∃ C κ'' y` with
`y' ≤ C y² - κ'' y³` and `M ≤ y`. The checked input is the cubic source
`M' ≤ C_CZ M²`. The continuation code does not consume that inequality.
It unpacks the package and sends it to `global_regularity`. The `sorry`
is the only occupant.

`conditional_riccati` expands `CorrectedMaxRate`. `conditional_ceiling`
is the phase line of that hypothesized field. Neither constructs `y`,
neither sets `y(t) = ‖ω(t)‖_∞`, and neither derives
`ω · ((ω · ∇) u) ≤ (C_CZ M - κ M²) M²` from the unmodified vorticity equation.

Remove the name and keep the `sorry`, and the gap is unchanged.
Remove both, and the `obtain` does not typecheck.
Drop the binder, and the theorem claims the ceiling with no hypothesis.
That claim is the gap, not a proof of it.

Statement (B) remains open.
-/

namespace Frohmanian.AssemblyGap

/-- The ceiling package is not an identity of the unmodified equation. -/
public def CeilingPackage (C κ y M0 : ℝ) : Prop :=
  0 < C ∧ 0 < κ ∧ 0 ≤ M0 ∧ M0 ≤ max M0 (C / κ)

/-- Dropping the binder claims this package with no hypothesis.
This definition does not inhabit it. -/
unimplemented_feature 
end Frohmanian.AssemblyGap
