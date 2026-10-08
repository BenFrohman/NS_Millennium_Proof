/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

module

public import NS_Millennium_Proof.Modules.TetheredLyapunov

/-!
Real path: `NS_Millennium_Proof/Modules/TetheredLyapunov.lean`.

This file does not redeclare `global_regularity`, `comparison_ode_stability`,
or `riccati_ceiling_of_vorticity_di`. The ceiling hypothesis is `hDI` on the
lake theorem. A local `sorry` in a duplicate file is not that hypothesis.
-/

export NS_Millennium_Proof.Modules.TetheredLyapunov
  (global_regularity comparison_ode_stability riccati_ceiling_of_vorticity_di)
