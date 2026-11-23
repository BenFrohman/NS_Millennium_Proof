/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import NS_Millennium_Proof.Modules.SymplecticTether

/-!
# Canonical short name for the tethered bracket

`FT S κ F G ω` is the tethered bracket `{F, G}_κ(ω) = {F, G}(ω) + B_κ(ω; F, G)` of
`SymplecticTether.lean` (notation `𝔉𝕋`). The proved facts about it are listed in
`GlobalRegularity.frohmanian_tether_theorem_conditional` and `Uniqueness.lean`.
-/

namespace FrohmanianTether

/-- `FT = TetheredBracket`. -/
noncomputable abbrev FT := TetheredBracket

end FrohmanianTether
