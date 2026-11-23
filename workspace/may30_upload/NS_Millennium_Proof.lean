/-!
# NS Millennium Proof — Frohmanian Symplectic Tether (Main Entry)

This is the clean root for the formalization of the audited LaTeX proof
"Proof of Global Smoothness for the 3D Incompressible Navier–Stokes Equations:
The Frohmanian Symplectic Tether Theorem" (Benjamin Frohman, 2026, with PASS 1–5 referee expansions).

All modules are now under the correct `NS_Millennium_Proof` package.
The geometric core lives in ForMathlib/NS/Tether.lean (upstream candidate, full original rigor restored).
-/

import NS_Millennium_Proof.ForMathlib.NS.Tether
import NS_Millennium_Proof.Modules.NS_Equations
import NS_Millennium_Proof.Modules.ArnoldGeometric
import NS_Millennium_Proof.Modules.SymplecticTether
import NS_Millennium_Proof.Modules.TetheredLyapunov
import NS_Millennium_Proof.Modules.GlobalRegularity

-- Re-export key items for convenience
export NavierStokes3D (NS_PDE)
export ArnoldGeometric (ClassicalBracket KineticEnergyHamiltonian)
export SymplecticTether (TetheredBracket TetherKernel)
export TetheredLyapunov (global_regularity lemma_3_1_uniform_bound_and_continuation)
export GlobalRegularity (frohmanian_symplectic_tether_theorem)
