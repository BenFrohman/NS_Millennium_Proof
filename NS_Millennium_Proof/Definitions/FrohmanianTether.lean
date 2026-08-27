/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

module

public import NS_Millennium_Proof.Modules.SymplecticTether
public import NS_Millennium_Proof.Modules.NS_Equations
public import NS_Millennium_Proof.Modules.ArnoldGeometric

/-!
# Central Definitions / Naming for the Frohmanian Tether (Canonical)

**Original Author:** Benjamin Stanley Frohman (X.com : Investor0x / Bit21)
**Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.**

This module is the public initialization root for Frohman's novel objects.
The live definitions are:

* `kappa` / `CalderonZygmundConstant3D` / `kappa'`
* `TetherKernel` / `TetheredBracket` / notation 𝔉𝕋
* `frohmanian_tether_theorem`
* paper §2.1 operators in `NavierStokes3D`: `curl`, `convective`, `laplacian`,
  `curl_gradient`, `curl_convective`, `curl_time_deriv`, `curl_laplacian`,
  `VorticityTransportRegularity`, `vorticity_transport`

ASCII identifiers only for defs (`TetheredBracket`, `TetherKernel`, `kappa`).
`FT` / `TF` / `BF` are not used.
-/

open ArnoldGeometric

namespace FrohmanianTether

/-- Initialization: `κ` is the live Calderón–Zygmund constant. -/
public theorem kappa_is_initialized : kappa = CalderonZygmundConstant3D :=
  kappa_eq_three_halves.trans CalderonZygmundConstant3D_eq_three_halves.symm

end FrohmanianTether
