Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
SPDX-License-Identifier: Apache-2.0
Authors: Benjamin Stanley Frohman

# Assembly gap

Date: 2026-10-07. This note records the gap. It does not close it.

`hRiccati` is a label for the package ∃ C, κ'', y with y' ≤ C y² − κ'' y³ and M ≤ y.
The checked input is `proved_pairing`, M' ≤ C_CZ M². The continuation code does not
consume that inequality. It unpacks the package and sends it to `global_regularity`.
The `sorry` is the only occupant.

`conditional_riccati` expands a rate that already contains C M − κ M².
`conditional_ceiling` shows C y² − κ y³ < 0 for a real y > C/κ. Neither constructs y,
neither sets y(t) = ‖ω(t)‖_∞, and neither derives

ω · ((ω · ∇) u) ≤ (C_CZ M − κ M²) M²

from the unmodified vorticity equation.

Remove the name and keep the `sorry`, and the gap is unchanged. Remove both, and the
`obtain` does not typecheck. Drop the binder, and the theorem claims the ceiling with
no hypothesis. That claim is the gap, not a proof of it.

`hRiccati` stays marked. Statement (B) remains open.
