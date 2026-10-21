# Relationship Between LaTeX Manuscript and Lean 4 Formalization

**Project Title (working):**  
Frohmanian Symplectic and Holographic Dual Approach to 3D Incompressible Navier-Stokes Regularity

**Author:** Benjamin Stanley Frohman

**Date:** May 2026 (last updated)

## 1. Purpose of This Document

This document explains the precise relationship between:
- The LaTeX manuscript (currently in Overleaf / Google Drive)
- The Lean 4 formalization project (this directory and its submodules)

The goal is to make the mapping transparent for referees, collaborators, and future readers (including Clay Mathematics Institute reviewers).

## 2. Core Claim Being Formalized

The Lean modules formalize key parts of the proof strategy for **regularity of solutions to the 3D incompressible Navier-Stokes equations** using a novel **symplectic tether** construction (the “Frohmanian Symplectic Tether”).

Specifically:
- The central novel object is the **Frohmanian Symplectic Tether** and the associated **Tether Regularity Theorem**.
- This construction uses symplectic geometry on the coadjoint orbit of volume-preserving diffeomorphisms, together with holographic dual ideas, to control the supercritical vortex-stretching term and establish global regularity.
- The formalization aims to show that this tether-based approach yields global regularity for the 3D incompressible Navier-Stokes system on the torus (or conditional global regularity under the stated geometric hypotheses).

This is **not** a formalization of a previously known classical proof. The symplectic tether mechanism itself is the author’s original contribution.

## 3. Mapping Between LaTeX Sections and Lean Modules

| LaTeX Section / Theorem (in manuscript)                          | Lean Module / File (in this project)                  | Status             | Notes |
|------------------------------------------------------------------|-------------------------------------------------------|--------------------|-------|
| Symplectic Tether Construction (Section 2.3)                     | `ForMathlib/NS/Tether.lean`                           | In active development (full original statements restored) | Core novel definition – upstream candidate |
| Frohmanian Symplectic Tether Regularity Theorem                  | `SymplecticTether.lean` + `TetherRegularity.lean` (planned) | In development     | Main novel theorem |
| Three Necessary Conditions (C1)–(C3) + 5-Step Uniqueness (Section 2.7 + PASS 2) | `ForMathlib/NS/Tether.lean` + `SymplecticTether.lean` | Partially formalized | Full predicate strength restored from LaTeX + PASS audits |
| Explicit Degeneracy for Mollified Sup-Norm Proxy (Section 2.4.1 + PASS 1) | `ForMathlib/NS/Tether.lean`                           | Formalized (structured) | Critical non-circularity lemma – proved in geometric layer |
| Independent Comparison Majorant + Corrected Lemma 3.1 (Section 3 + PASS 5) | `Modules/IndependentMajorant.lean`                    | Formalized (structured) | Key non-circularity safeguard |
| Differential Inequality & Analytic Closure (Section 3 + PASS 3/4) | `Modules/AnalyticEstimates.lean`                      | In development     | Depends on tether + majorant |
| Global Regularity Statement (current version)                    | `NS_Global_Regularity_Theorem.lean` + `Modules/GlobalRegularity.lean` | In development     | Top-level assembly |
| Energy Estimates & A Priori Bounds                               | `Modules/EnergyEstimates.lean` (planned)              | Partial            | Will use mathlib + custom lemmas |
| Metriplectic Structure (future extension)                        | `Metriplectic.lean` (planned)                         | Not yet created    | See Section 6 |

## 4. Novel Contribution Statement

The **Frohmanian Symplectic Tether** and the associated regularity theorem constitute the author’s original contribution. This is not a formalization of a previously known classical proof. The symplectic tether mechanism and its application to controlling Navier-Stokes singularities via symplectic geometry and holographic dual ideas are new.

All supporting analytical facts that are already established in the literature are either:
- Imported from `mathlib4`, or
- Re-proved as lemmas inside this project (never declared as axioms unless explicitly documented in `Assumptions.lean`).

The formalization deliberately follows the exact logical architecture and non-circularity refinements developed in the LaTeX manuscript and its PASS audit blocks.

## 5. Handling of Assumptions and Black Boxes

See the separate file `Assumptions.lean` (and the corresponding section in the LaTeX manuscript) for the complete, minimal list of intentional axioms.

Temporary `sorry` placeholders used during development are tracked in the `Proof_Completeness_Report.md` and will be eliminated before any submission version. The final verified code will contain **zero** `sorry` in the dependency tree of the main theorems.

## 6. Future Extension (Author’s Stated Plan)

Once the current symplectic tether proof is polished, verified as true by the Lean kernel, and accepted, the author intends to:

- Formulate a new **conjecture on global regularity** for the 3D incompressible Navier-Stokes equations based on the symplectic tether method.
- Introduce a **Metriplectic function** (or metriplectic structure) that allows the logical structure to break down precisely into a statement of global regularity.
- Formalize this extended conjecture and the metriplectic construction in future modules (`Metriplectic.lean` and related files).

This future work will be clearly separated from the current verified proof and will be documented in an updated version of this relationship file.

## 7. How to Navigate the Project

- Start with `README.md` for build instructions and project overview.
- Use `LaTeX_Lean_Relationship.md` (this file) together with the LaTeX manuscript for the mapping.
- Use the Lean Blueprint (when generated) for the visual dependency graph.
- Cross-reference the table in Section 3 with the LaTeX section headings.
- All novel symplectic tether material is concentrated in `ForMathlib/NS/Tether.lean` and the modules that depend on it.

## 8. Contact & Versioning

This relationship document will be kept in sync with both the LaTeX manuscript and the Lean codebase. Major changes to the mapping will be recorded here with dates.

---

**Note to Reviewers:**  
This document is intentionally kept at the root of the Lean project so that the precise correspondence between the manuscript and the formalization is immediately visible.
