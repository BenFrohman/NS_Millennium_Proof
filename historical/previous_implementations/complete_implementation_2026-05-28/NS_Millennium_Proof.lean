/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

module

import ForMathlib.NS.Tether
import Modules.NS_Equations
import Modules.ArnoldGeometric
import Modules.SymplecticTether
import Modules.IndependentMajorant
import Modules.AnalyticEstimates

export SymplecticTether (TetheredBracket TetherKernel theorem_2_3_uniqueness_of_the_minimal_correction)

/-! Minimal clean root for verification (Lean 4.28.0).

This file exists primarily to pull in the full dependency tree for building/testing.
The real mathematical content lives in ForMathlib/NS/Tether.lean (the upstream candidate)
and the supporting modules.
-/
