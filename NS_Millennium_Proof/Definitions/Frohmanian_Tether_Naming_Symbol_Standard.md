# Frohmanian Tether - Naming & Symbol Standardization

**Date**: 2026-06-03
**Purpose**: Establish consistent naming and symbols for the new core mathematical object across the entire NS_Millennium_Proof project and future work.

## Recommended Canonical Names

| Concept                          | Canonical Name                  | Lean Identifier             | LaTeX / Symbol          | Informal / Short Form     | Notes |
|----------------------------------|---------------------------------|-----------------------------|-------------------------|---------------------------|-------|
| **Core new mathematical object** | **Frohmanian Tether**           | `FrohmanianTether`          | `𝔉𝕋` (custom)           | **F-Tether**              | The central new object discovered from 3D Navier-Stokes |
| **Main theorem in this paper**   | **Frohmanian Tether Theorem**   | `FrohmanianTetherTheorem`   | `𝔉𝕋`-Theorem            | F-Tether Theorem          | Specific to the NS regularity result |
| **Broader general result**       | **Symplectic Tether Theorem**   | `SymplecticTetherTheorem`   | Symplectic Tether Theorem | —                       | The more abstract version that can apply to other fields (ML, gravity, singularities, etc.) |

## Symbol Explanation (User's Original Design)

The symbol you showed (the stylized T/F monogram) is a **custom ligature/monogram** combining **T** and **F**.

- **Visual meaning**: It merges the letters "T" and "F" into a single unique glyph representing the new object you discovered.
- **Pronunciation**: 
  - "Eff-Tether" (most natural)
  - "Frohmanian Tether"
  - "F-Tether"
- **Recommended Unicode approximation**: `𝔉𝕋` (Fraktur-style T + F, or a true ligature if you create a custom font command in LaTeX).
- **Why this is good**: It is distinctive, memorable, and directly reflects your original creative intent. It also works well visually when the theory expands into other fields.

**LaTeX recommendation**:
```latex
\newcommand{\FT}{\mathfrak{T}\mkern-2mu\mathfrak{F}}   % or your custom drawn symbol
\newcommand{\FTh}{\FT\text{-Tether}}
```

## Why We Standardize Now

- Multiple conflicting abbreviations were appearing (`FT`, `TF`, `BF`, etc.).
- Inconsistent theorem names across modules and notes.
- Future expansion into AI/ML, gravity, singularities, etc. requires a clean, extensible naming system.
- Clay Millennium submissions value clarity and consistency.

## Agent Instructions (for future use)

When editing any file in this project:
1. Use `FrohmanianTether` as the Lean identifier for the core object.
2. Use `𝔉𝕋` (or `\FT` in LaTeX) as the primary symbol.
3. Use `FrohmanianTetherTheorem` for the main result in this paper.
4. Reserve `SymplecticTetherTheorem` for the more general/abstract version.
5. Never introduce new abbreviations (FT, TF, BF, etc.) without updating this document first.
6. Every new symbol must be defined before first use, with a clear comment or lemma.

## Status

- [x] Core naming decision made (2026-06-03)
- [ ] Update all `.lean` files to follow this standard
- [ ] Update LaTeX manuscript
- [ ] Create central definition file `Definitions/FrohmanianTether.lean`

---
*This document should be treated as the single source of truth for naming in the Frohmanian Tether / Symplectic Tether theory.*

## Practical Usage

**In LaTeX (recommended):**
```latex
% In your preamble
\newcommand{\FT}{\mathfrak{T}\mkern-1.5mu\mathfrak{F}}   % or use your actual drawn symbol
\newcommand{\FTh}{\FT}
```

**In Lean 4:**

Use the identifier `FrohmanianTether`

You can add notation if you want:
```lean
notation "𝔉𝕋" => FrohmanianTether
```

See also the dedicated `FrohmanianTether_LaTeX_Preamble.tex` for a full ready-to-include version with comments on alternatives (fontspec ligatures, TikZ, Unicode).

