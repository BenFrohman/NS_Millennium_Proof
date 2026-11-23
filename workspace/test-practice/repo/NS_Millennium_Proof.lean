/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import ForMathlib.NS.Tether
import NS_Millennium_Proof.Modules.NS_Equations
import NS_Millennium_Proof.Modules.ArnoldGeometric
import NS_Millennium_Proof.Modules.ForMathlib.Projection
import NS_Millennium_Proof.Modules.SymplecticTether
import NS_Millennium_Proof.Modules.Uniqueness
import NS_Millennium_Proof.Modules.IndependentMajorant
import NS_Millennium_Proof.Modules.TetheredLyapunov
import NS_Millennium_Proof.Modules.Continuation
import NS_Millennium_Proof.Modules.GlobalRegularity
import NS_Millennium_Proof.Modules.NonVacuity
import NS_Millennium_Proof.Modules.Assumptions
import NS_Millennium_Proof.Definitions.FrohmanianTether
import NS_Millennium_Proof.Skeleton.UniquenessOverview
import NS_Millennium_Proof.Widgets.TetheredNullifier

/-!
# NS_Millennium_Proof: conditional global regularity via the Frohmanian tether

**Not a solution of the Clay Millennium problem.** The main theorem,
`GlobalRegularity.conditional_global_regularity_for_NS`, proves global existence and uniqueness
of classical solutions on `𝕋³` *from* four named hypotheses: Kato–Leray local existence (KL),
uniqueness (U), Beale–Kato–Majda continuation (BKM) and the open tethered majorant inequality
(TM). `FrohmanianTether.not_minimalTetherUniqueness` refutes the claimed uniqueness of the
minimal tether. Everything is checked by the Lean kernel with the standard axioms only.
-/
