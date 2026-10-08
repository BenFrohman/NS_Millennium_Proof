/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

module

public import NS_Millennium_Proof.Modules.TetheredLyapunov

/-!
Real path: `NS_Millennium_Proof/Modules/TetheredLyapunov.lean`.

This file does not redeclare `global_regularity` or
`riccati_ceiling_of_vorticity_di`. The ceiling hypothesis is `hDI` on the
lake theorem. `comparison_ode_stability` is `AnalyticPipeline.comparison_ode_stability`,
not a declaration in this namespace.
-/

export TetheredLyapunov (global_regularity riccati_ceiling_of_vorticity_di)
