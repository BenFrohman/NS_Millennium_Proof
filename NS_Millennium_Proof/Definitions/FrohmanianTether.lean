module

public import NS_Millennium_Proof.Modules.SymplecticTether

/-!
# Central Definitions / Naming for the Frohmanian Tether (Canonical)

**Original Author:** Benjamin Stanley Frohman (@Investor0x / Bit21)  
**Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.**

Core object: `FrohmanianTether` / 𝔉𝕋  
Main theorem: `frohmanian_tether_theorem`
-/

namespace FrohmanianTether

public noncomputable abbrev FT := TetheredBracket

notation "𝔉𝕋" => FT
notation "FT" => FT

end FrohmanianTether
