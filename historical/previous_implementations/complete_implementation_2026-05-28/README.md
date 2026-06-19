# Frohmanian Symplectic Tether — Lean Formalization

**Project**: Formalization of the 3D Navier-Stokes global regularity proof  
**Author**: Benjamin Frohman (with Lean expansions)  
**Date of this snapshot**: 2026-05-28  
**Location**: This is a clean mirror in Google Drive

## Current Status

This folder contains a cleaned, import-fixed, and partially expanded Lean 4 formalization of the "Frohmanian Symplectic Tether" approach to the Navier-Stokes Millennium Problem.

It is directly derived from the audited living LaTeX document (with all PASS 1–5 referee expansions for non-circularity).

### Key Files

- `lakefile.lean` — Correct modern configuration
- `NS_Millennium_Proof.lean` — Clean project root
- `Modules/SymplecticTether.lean` — Core geometric construction
  - Conditions (C1)–(C3)
  - Theorem 2.3: Uniqueness of the Minimal Tether (5-step classification)
  - Explicit degeneracy for mollified sup-norm proxy (Section 2.4.1)
- `Modules/TetheredLyapunov.lean` — Analytic estimates + unconditional global regularity
  - Corrected Lemma 3.1 (PASS 5 version with finite-subinterval continuation)
- `Modules/GlobalRegularity.lean` — Main theorem assembly
- Supporting modules: `NS_Equations.lean`, `ArnoldGeometric.lean`

## How to Build

```bash
cd Lean_Formalization_2026-05-28
lake update
lake build
```

First build will download mathlib (can take 10–30+ minutes depending on your machine).

## Relationship to Other Copies

- **Primary development**: iCloud version (`Tao-Analysis-Lean/NS_Millennium_Proof`)
- **This folder**: Clean snapshot + backup in Google Drive, co-located with your LaTeX, living document, and submission materials.
- Worktree copies (in `.grok/`) are for temporary experimentation.

## Roadmap / Next Expansions (to be filled)

- [ ] Full 5-step proof of `uniqueness_of_minimal_tether` with named sub-lemmas
- [ ] Detailed proof of `lemma_3_1_uniform_bound_and_continuation`
- [ ] Explicit Moser isotopy construction
- [ ] Calderón-Zygmund constant properties
- [ ] Beale-Kato-Majda criterion formalization
- [ ] Test examples in `Examples/`

## Style Goals

Following the "Tao style" requested in the document:
- Every major logical step is a named lemma.
- No hidden reasoning in the top-level theorem.
- Comments reference specific sections of the audited LaTeX.

---

This formalization is ambitious. The geometric skeleton and non-circularity structure from the LaTeX audits are now in Lean. The remaining heavy analysis (estimates, embeddings, etc.) will be expanded iteratively.

Feel free to open this folder in VSCode and start the Lean server.

## Documentation

See `LaTeX_Lean_Relationship.md` for the precise mapping between the LaTeX manuscript and these Lean modules.
A Lean-readable version is also available in `RelationshipDoc.lean`.
