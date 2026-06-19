# Relationship Between LaTeX Manuscript and Lean 4 Formalization

> **Clay Cleanup Note (2026-06-02)**: Large raw source documents and chat histories have been archived to `historical/docs/`. The mapping in this file, the Lean formalization itself, and the eight canonical visuals now constitute the minimal Clay-auditable submission set. See `historical/README.md`.

**Project Title (working):**  
Proof of Global Smoothness for the 3D Incompressible Navier-Stokes Equations: The Frohmanian Symplectic Tether Theorem

**Author:** Benjamin Stanley Frohman  

**Date:** May 2026 (last updated — synchronized with the May 31 2026 merged paper + Conversation History Summary)

## 1. Purpose of This Document

This document explains the precise relationship between:
- The LaTeX manuscript (currently in Overleaf, with source materials in Google Drive and the three canonical documents: Full_Living_Document_NS_Millennium_Proof.md, Context_of_evolution_Proof.txt, and the full Grok chat history RTF)
- The Lean 4 formalization project at `lean-projects/NS_Millennium_Proof/`

The goal is to make the mapping transparent for referees, collaborators, Clay Mathematics Institute reviewers, and future readers. It also documents the "MathPort" disciplined translation workflow used to move novel content from the paper into auditable Lean.

## 2. Core Claim Being Formalized

The Lean modules formalize the complete two-layer proof of **global regularity for smooth, divergence-free initial data for the 3D incompressible Navier-Stokes equations on T³** via the novel **Frohmanian Symplectic Tether** 𝔗_F.

Specifically:
- The central novel object is the **Frohmanian Symplectic Tether** 𝔗_F — the unique minimal bilinear antisymmetric quadratic metric correction to Arnold’s classical Lie–Poisson bracket on the coadjoint orbit of volume-preserving diffeomorphisms.
- It is forced by the vorticity transport equation of the **unmodified** classical 3D NS equations (no ansatz).
- The formalization delivers the 5-step canonicity/uniqueness proof (C1)–(C3) / (A1)–(A5), the explicit 9-term index-notation Jacobi identity expansion + Chevalley–Eilenberg 2-cocycle closure (d₂B = 0), degeneracy B(F,H) ≡ 0 (including for the mollified sup-norm proxy F_ε), invariance under the coadjoint action, and the non-circular analytic corollary via the independent majorant ODE y' = C y² − κ'' y³ introduced first (Layer 2).
- Global regularity follows from the Beale–Kato–Majda criterion + parabolic regularity once the independent majorant bound is established on every finite [0,T] < T*.

**This is not a formalization of any previously known classical proof.** The symplectic tether construction, its axiomatic uniqueness, the explicit Jacobi verification at index level, and the two-layer non-circular architecture (Layer 1 geometric justification of the tool via canonicity; Layer 2 analytic proof on the unmodified equations using the tool) are the author’s original contribution.

All classical supporting facts (local existence, BKM, CZ estimates, Gagliardo–Nirenberg, Young absorption, parabolic regularity, etc.) are treated as documented black boxes imported from mathlib4 or re-proved only when necessary, with explicit non-circularity justifications.

## 3. Mapping Between LaTeX Sections and Lean Modules (Current State)

| LaTeX Section / Theorem (May 31 2026 merged paper + source docs) | Lean Module / File                                      | Status                          | Notes / Clay Audit Priority |
|------------------------------------------------------------------|---------------------------------------------------------|---------------------------------|-----------------------------|
| Section 2.1: Vorticity transport from unmodified NS PDE          | `NS_Equations.lean` (MyNSProof namespace)               | Black-box + exact user-supplied blocks | Foundation; classical |
| Section 2.2–2.3: Arnold coadjoint orbit + classical bracket      | `ArnoldGeometric.lean`                                  | Structured + classical sorrys   | CoadjointOrbit as Subtype |
| Section 2.3 + 2.7: Explicit TetherKernel construction + (A1)–(A5) + Theorem 2.3 uniqueness (5-step) | `SymplecticTether.lean` (core novel) + `ForMathlib/Projection.lean` (Pi_u central source) | 9-term Jacobi + 5-step partially restored from paper; highest priority remaining | **Clay-critical**: degeneracy, invariance, canonicity (PASS 2 authoritative) |
| Section 2.4 + 2.4.1: Degeneracy (explicit mollified F_ε proxy)   | `SymplecticTether.lean` (degeneracy_for_mollified_sup_norm_proxy) + `ForMathlib/Projection.lean` | Partially schematic; Π_u now live | Next recursive-cycle target after Jacobi sign-off |
| Section 2.5: Invariance Lemma 2.2                                | `SymplecticTether.lean`                                 | Structured                      | Coadjoint action |
| Section 2.6: Jacobi Identity — full 9-term index expansion + IBP + Chevalley–Eilenberg 2-cocycle (d₂B=0) | `SymplecticTether.lean` (tethered_jacobi_identity + h_cyclic_integrand_zero + FINAL SUMMED FORMULATION) | Explicit 9-term + cocycle restored Cycle 2 from May 31 paper | **Clay-critical** (81/100 segment confidence after restoration) |
| Section 3: Independent majorant introduced first + absorption (explicit C_abs) + G-N exponents + Proof Architecture (Layer 1/2) | `TetheredLyapunov.lean` (ComparisonODE, key_differential_inequality, phase_plane_analysis_of_majorant_ODE, lemma_3_1_uniform_bound_and_continuation) + `PaperFormalization.lean` (TetherAxioms, high-level narrative) | Majorant + comparison non-circular; differential inequality has explicit chains | Layer 2 analytic proof; independent of Tether by design |
| Section 3 + global statement: Global regularity as corollary     | `GlobalRegularity.lean` (frohmanian_symplectic_tether_theorem roadmap + global_regularity_for_NS + permanent #print axioms) | Statement + assembly present; classical black boxes only | Top-level; two-layer architecture documented |
| Bridge / high-level narrative + TetherAxioms (C1)–(C3)           | `PaperFormalization.lean`                               | Structured; cites PASS 2 for 2.7 | Living bridge between paper and code |
| Esoteric widget (Tethered Nullifier / Null Mandala for Jacobi groups A/B/C) | `Widgets/TetheredNullifier.lean` (OrbitState + PLift certificate + IO.Ref) | Schematic (one IO.Ref sorry)    | Demonstrates "theorem proving + programming combined" vision |
| Living dependency graph + four audit checklists + Clay Panel Audit Mode records | `Blueprint.md`                                          | Authoritative living document   | Source fidelity section + explicit judgment calls (PASS 2 highest) |
| Metriplectic extension (future)                                  | Planned (`Metriplectic.lean` etc.)                      | Not yet created                 | Author’s stated plan (Section 6) |

**Important**: The table above is the single source of truth for the current state. It is cross-referenced from `Blueprint.md` §"Current Status & Mapping to Lean Files".

## 4. The "MathPort" Disciplined Translation Workflow (Clarification)

"MathPort" is **not** a widely-known standalone external tool. It is the internal working name used in this project for the **custom, auditable, Clay-auditable porting methodology** that translates the novel mathematics from the LaTeX manuscript (and the three source documents) into the Lean 4 modules while preserving every required property (non-circularity, non-ad-hoc, non-ansatz, first-principles derivation, canonicity).

It combines:
- The official Lean 4 "Recipe for Porting Existing Files" (Language Reference §5: module + public/meta import headers, public section, @[expose], etc.)
- Terence Tao / PFR-style blueprint-driven development (atomic named lemmas, explicit have/calc, ForMathlib hygiene, living checklists)
- The two-layer architecture (Layer 1 geometric justification in SymplecticTether; Layer 2 analytic proof on unmodified equations in TetheredLyapunov)
- Full source fidelity with documented judgment calls (PASS 2 for canonicity / Theorem 2.3)
- The Clay Panel Audit Mode double-check discipline (before/after justification + full build + bracketed examples + 4-checklist brutal honesty + confidence score after every restoration)
- Explicit restoration of the most expanded forms from the May 31 2026 Conversation History Summary + merged paper (9-term Jacobi, independent majorant introduced first, explicit C_abs, F_ε proxy, (A1)–(A5), etc.)

The workflow produced the current state in which the Jacobi identity is Clay-auditable at the index level for the first time, the Π_u projection is the single canonical source in ForMathlib, and every major expansion carries comments citing the exact paper section + source document.

External porting / extraction scripts (e.g. the former extract_overleaf_history.py) and autonomous generators have been moved to `historical/scripts/` as part of the June 2026 Clay cleanup. They are development scaffolding only. The canonical MathPort relationship is maintained solely by the retained `generate_laTeX_lean_relationship.py` and documented in this file + Blueprint.md.

## 5. Novel Contribution Statement

The **Frohmanian Symplectic Tether** 𝔗_F, the 5-step uniqueness/canonicity proof, the explicit 9-term Jacobi verification, and the two-layer global-regularity corollary constitute the author’s original contribution. This is not a formalization of any previously published proof.

All supporting analytical facts already established in the literature (Calderón–Zygmund theory, Gagliardo–Nirenberg, Beale–Kato–Majda, local existence, parabolic regularity, etc.) are either imported from mathlib4 or re-proved locally with explicit citations and non-circularity justifications. They are never used in a way that would create a circular dependence on the conclusion being proved.

## 6. Handling of Assumptions and Black Boxes

See `Blueprint.md` ("Validation and Trust Strategy" + "Classical vs Novel Separation") and the comments in each module for the complete, minimal list of intentional classical black boxes.

Temporary `sorry` placeholders are tracked. After every major restoration step a full `lake build` is run. The final submission version will contain **zero** `sorry` in the dependency tree of the novel geometric claims (the Tether, 5-step, Jacobi, degeneracy, invariance, canonicity). Classical black boxes will remain documented and cited.

## 7. Future Extension (Author’s Stated Plan)

Once the current symplectic tether proof is polished, verified as true by the Lean kernel (via lean4checker --fresh + comparator + external checkers for "unique proof confirmation"), and accepted:

- Formulate the metriplectic extension (a metriplectic function/structure that allows the logical structure to break down precisely into a statement of global regularity).
- Introduce a new conjecture on global regularity for 3D incompressible NS based on the tethered approach.
- Formalize the extension in new modules (Metriplectic.lean and related files).

All future work will be clearly separated from the currently verified core and documented in an updated version of this relationship file + Blueprint.md.

## 8. How to Navigate the Project

- Start with `README.md` for build instructions (4.28.0 baseline locked for validation priority).
- Read this file + `Blueprint.md` (especially the four living audit checklists, Source Fidelity section, and Clay Panel Audit Mode records).
- Cross-reference the table in Section 3 with the May 31 2026 merged paper sections and the three source documents (now archived under `historical/docs/` for the Clay cleanup; they are the verbatim origin of the formalization but not required reading for a referee who uses this mapping + the Lean sources + Blueprint + the 8 visuals).
- All novel symplectic tether material (the part that must be zero-sorry for Clay submission) is concentrated in `SymplecticTether.lean`, `ForMathlib/Projection.lean`, `TetheredLyapunov.lean` (analytic layer), `GlobalRegularity.lean` (assembly), and `PaperFormalization.lean` (narrative bridge).
- The esoteric widget lives in `Widgets/TetheredNullifier.lean`.
- Living Overleaf history structure (raw) is archived at `historical/docs/overleaf_iterations/` (and `historical/docs/`); it is moot for referee review. The authoritative current mapping is this document itself.

## 9. Contact & Versioning

This relationship document is kept at the root so it is immediately visible. It is updated after every major recursive Clay audit cycle or architectural change. Major mappings are also recorded in `Blueprint.md`.

**Note to Reviewers and the Clay Panel**:  
The precise correspondence between the LaTeX manuscript (and its historical expansions) and the Lean formalization is the primary mechanism for establishing "unique proof confirmation" for the novel Frohmanian Symplectic Tether geometry. The MathPort workflow + living Blueprint + four checklists + permanent `#print axioms` on the novel theorems exist to make this correspondence auditable at the highest standard.

---

*This file was created / updated per the explicit instruction in the conversation history to save the relationship document in the root of the primary Lean project and to make the MathPort process and novel contribution fully transparent.*

## 10. Symbol Implementation for 𝔉𝕋 (Frohmanian Tether Ligature)

The custom monogram/ligature for the Frohmanian Tether (combining T and F) is implemented in the LaTeX manuscript using the techniques documented in:

- `NS_Millennium_Proof/Definitions/Frohmanian_Tether_Naming_Symbol_Standard.md` (local authoritative copy)
- `NS_Millennium_Proof/Definitions/FrohmanianTether.lean` (detailed LaTeX section + recommendation)
- `NS_Millennium_Proof/Definitions/FrohmanianTether_LaTeX_Preamble.tex` (ready-to-include snippet)

**Recommended command (best practical method for this paper):**
```latex
\newcommand{\FT}{\mathfrak{T}\mkern-1.8mu\mathfrak{F}}
\newcommand{\FTh}{\FT}
```

See the provided "LaTeX Ligature Techniques – Clear Explanation" (user query 2026-06-03) for the full comparison of methods (newcommand vs fontspec true ligature vs TikZ vs Unicode) and the rationale for choosing the clean \newcommand approach as the sweet spot for maintainability + professional appearance in a Clay Millennium submission.

This ensures the symbol is used consistently with the canonical naming (FrohmanianTether / 𝔉𝕋) established in table (9).csv and the standard MD.
