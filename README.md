# NS_Millennium_Proof — Frohmanian Symplectic Tether Regularity Theorem

**Author:** Benjamin Stanley Frohman (@Investor0x / Bit21)  
**Date:** 2026

Formalization in Lean 4 of the global regularity for the 3D incompressible Navier–Stokes equations using the Frohmanian Symplectic Tether framework.

**Status:** Build clean. Geometric core complete. Remaining `sorry` placeholders in analytic estimates.

## Structure
- `ForMathlib/NS/Tether.lean`: Upstream-candidate geometric kernel.
- `Modules/`: Core modules (SymplecticTether, GlobalRegularity, etc.).
- `Definitions/FrohmanianTether.lean`: Canonical naming (`𝔉𝕋`).

See `HISTORY.md`, `Blueprint.md`, and `LaTeX_Lean_Relationship.md` for full details.
