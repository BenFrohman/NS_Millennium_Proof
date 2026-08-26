/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

/-!
# NS Millennium Proof — Frohmanian Symplectic Tether (Main Entry)

**Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.**

Original work by Benjamin Stanley Frohman (@Investor0x / Bit21).

**WIP (2026-08-26):** kernel-path restoration of the Lean 4 formalization
(`kappa`, `TetherKernel` / 𝔉𝕋, BKM, uniqueness types). This is an in-progress
build. Classical black boxes remain documented `sorry`s. This entry point does
not claim a completed Clay Navier–Stokes solution.
-/

import NS_Millennium_Proof.Modules.NS_Equations
import NS_Millennium_Proof.Modules.ArnoldGeometric
import NS_Millennium_Proof.Modules.SymplecticTether
import NS_Millennium_Proof.Modules.Uniqueness
import NS_Millennium_Proof.Modules.TetheredLyapunov
import NS_Millennium_Proof.Modules.AnalyticPipeline
import NS_Millennium_Proof.Modules.ClosureBlueprint
import NS_Millennium_Proof.Modules.IndependentMajorant
import NS_Millennium_Proof.Modules.GlobalRegularity
import NS_Millennium_Proof.Definitions.FrohmanianTether

export FrohmanianTether (TetheredBracket TetherKernel kappa)
export GlobalRegularity (frohmanian_tether_theorem)
