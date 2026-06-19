# Living Proof Methodology — Overleaf Iterations

This directory will contain the historical evolution of the paper **"Proof of Global Smoothness for the 3D Incompressible Navier-Stokes Equations: The Frohmanian Symplectic Tether Theorem"** as it developed on Overleaf.

## Purpose

The goal is to maintain a **living, traceable record** of the proof's development. Every major conceptual shift, refinement of the two-layer architecture, expansion of the Jacobi identity, absorption estimates, canonicity argument, and non-circularity refinements will be linked back to specific Overleaf iterations.

This serves several critical functions for the Lean 4 formalization:

- **Auditability**: Any referee or future reader can see exactly when and why a particular formulation (e.g., "a priori independent majorant" vs. "tether-forced corollary") was adopted.
- **Non-circularity verification**: The evolution shows that the independent majorant was introduced as a deliberate strength, not a bootstrap.
- **Canonicity justification**: The progression of the (C1)–(C3) / (A1)–(A5) conditions and the uniqueness theorem can be traced.
- **Lean synchronization**: The formalization in `SymplecticTether.lean`, `TetheredLyapunov.lean`, and `PaperFormalization.lean` can cite specific iterations for each major expansion (especially the 9-term Jacobi cyclic sum and the explicit C_abs remainder chain).

## Expected Contents (when data arrives)

- Raw or exported Overleaf project snapshots / git history (if available).
- A script (to be provided) that extracts dated versions, commit messages, and key section diffs.
- A curated timeline or index (`EVOLUTION_TIMELINE.md`) mapping specific paper sections and Lean modules to Overleaf versions.
- Annotated diffs for the most important turning points (e.g., the May 13–14 → May 20 shift in Section 3).

## How This Integrates with the Lean Project

- `Blueprint.md` will maintain a "Source Fidelity" section that cross-references both the final LaTeX and the historical iterations.
- Major Lean lemmas and theorems (especially in `SymplecticTether.lean` and `TetheredLyapunov.lean`) will carry comments like:
  > "See docs/overleaf_iterations/EVOLUTION_TIMELINE.md §2.6 (iteration 2026-05-28) for the 9-term expansion and cocycle argument."
- `PaperFormalization.lean` acts as the high-level narrative layer that stays in sync with the latest accepted version while the detailed calcs reference the historical development.

## Status

**Structure prepared. Awaiting data + extraction script from user.**

A placeholder script has been created at:
```
scripts/extract_overleaf_history.py
```

When you provide the Overleaf export data (and/or your extraction script), run or replace the script to populate this directory with:

- `EVOLUTION_TIMELINE.md` (dated iterations + key conceptual shifts)
- Section-specific diffs (especially the evolution of §3) — the original raw CSV table is preserved at `../source_materials/Section3_Evolution_Diff_Raw.csv`. This is intended as source material for drafting paper commentary on the architectural shift in Section 3 (a priori majorant vs tether-forced corollary). See the main chat history file for context.
- Machine-readable anchors that the Lean modules (`SymplecticTether.lean`, `TetheredLyapunov.lean`, `PaperFormalization.lean`) and `Blueprint.md` can cite

Once populated, every major expansion in the formalization will carry citations like:
> "See docs/overleaf_iterations/EVOLUTION_TIMELINE.md §2.6 (Overleaf iteration 2026-05-28)"

This completes the "living methodology" vision for the proof journey.

**Primary consolidated history**: The full chat history + side-by-side §3 diff is maintained at:
`../proof_evolution/Frohmanian_Tether_Complete_Chat_History.md`

Overleaf iteration data will be merged into or cross-referenced from there.

---

*Last updated: by Grok (structure + placeholder script prepared per user request).*