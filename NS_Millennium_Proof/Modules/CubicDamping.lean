/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

module

/-!
The a priori cubic damping estimate
  M'(t) ≤ C M(t)² − κ'' M(t)³
with M(t) = ‖ω(t)‖_L^∞
was derived in the drafts from the projected TetherKernel
under the tethered bracket applied to the unmodified vorticity equation.
It is not restated or proved in this file.
The conditional global regularity theorem assumes the rate as a hypothesis.
-/
