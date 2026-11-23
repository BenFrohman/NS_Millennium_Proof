# Header & License Audit — BenFrohman/NS_Millennium_Proof @ origin/main 1c15546 (moved from a52c4d8)
DRAFT for user review. Nothing committed, pushed, or applied to real trees.

## !! Blocker found
Commits 1818a76 (02:05 CDT) and 1c15546 (02:15 CDT, Oct 23) replaced top-level `Modules/Uniqueness.lean`
with a single literal line `$(cat /home/workdir/artifacts/Uniqueness_corrected.lean)` (shell substitution never ran).
File is 56 bytes, no Lean. Not in default build, so lake build stays green, but the mirror is destroyed.
No header patch proposed; fix = restore content (e.g. copy NS_Millennium_Proof/Modules/Uniqueness.lean, which is EXACT).

## 1. Already correct (EXACT, byte-exact at line 1) — active tree, 36 files
In default build: ForMathlib.lean, ForMathlib/NS/Tether.lean, NS_Millennium_Proof.lean,
NS_Millennium_Proof/Definitions/FrohmanianTether.lean, NS_Millennium_Proof/Modules/{AnalyticPipeline, ArnoldGeometric,
Assumptions, ClosureBlueprint, ForMathlib/Projection, GlobalRegularity, IndependentMajorant, NS_Equations,
SymplecticTether, TetheredLyapunov, Uniqueness}.lean
Not in build: lakefile.lean, Tether.lean, Projection.lean, PaperOverview.lean, UniquenessOverview.lean,
Modules/{AnalyticEstimates, AnalyticPipeline, ArnoldGeometric, Assumptions, ClosureBlueprint, DataStructures,
ForMathlib/Projection, GlobalRegularity, IndependentMajorant, NS_Equations, SymplecticTether, TetheredLyapunov}.lean
Header always precedes `module`/`import`; no ordering problems.

## 2. Needs standard header — 4 patchable + 1 broken
| File | Build | Status | Fix |
|---|---|---|---|
| NS_Millennium_Proof/Modules/AssemblyGap.lean | yes | VARIANT: extra line `SPDX-License-Identifier: Apache-2.0` | drop that line |
| NS_Millennium_Proof/Modules/CubicSourceCertificate.lean | yes | VARIANT: same SPDX line | drop that line |
| NS_Millennium_Proof/UnmodifiedLines.lean | no | MISSING (doc block ends `Author: Benjamin Stanley Frohman.`) | prepend header, keep doc block |
| Modules/ClayStatements.lean | no | MISSING (starts with `/-!` doc) | prepend header |
| Modules/Uniqueness.lean | no | BROKEN (see blocker) | restore content |
Patch: header_fixes.patch (12+/2-, header lines only). Patched copies: patched/<path>.

## 3. Noted only (not modified)
- historical/MathPort_Header_Template.lean: VARIANT, `Authors: ... with formalization assistance from Grok (xAI)` + long MathPort text.
- historical/top-level-stubs-2026-08-26/*.lean (8): VARIANT `/-!` block with bold Copyright and `Original Author: ... (@Investor0x / Bit21)`.
- historical/previous_implementations/** (16 .lean) and historical/docs/proof_evolution/PaperSkeleton.lean: MISSING.
- EXACT already: .grok/skills/lean-standard-stack/StandardStack.lean, docs/Clarified_Degeneracy_and_Majorant_Blocks.lean,
  NS_Millennium_Proof/Skeleton/{PaperOverview,UniquenessOverview}.lean, NS_Millennium_Proof/Widgets/TetheredNullifier.lean.
- .bak: ForMathlib/NS/Tether.lean.bak, NS_Millennium_Proof/Definitions/FrohmanianTether.lean.bak,
  historical/.../Modules/SymplecticTether.lean.bak (suggest delete or move to historical/).

## Trial copy (/workspace/ns_trial) differences
- NS_Millennium_Proof/Modules/ClayStatements.lean (trial-only, in build): EXACT.
- Same 4 non-exact files as origin (AssemblyGap, CubicSourceCertificate, UnmodifiedLines, Modules/ClayStatements); patch applies equally.

## 4. LICENSE / COPYRIGHT.md
- LICENSE: full Apache-2.0 text (202 lines), unmodified; appendix keeps the template `Copyright [yyyy] [name of copyright owner]` (normal; optional: add a NOTICE file with `Copyright (c) 2026 Benjamin Stanley Frohman`).
- COPYRIGHT.md: exists. Says All rights reserved, author Benjamin Stanley Frohman (X: Investor0x / Bit21), Apache-2.0.
  Contains a disclaimer that the Lean encoding "was compiled in collaboration with an AI assistant (Grok, xAI)". Conflicts with "no AI name" rule; user decision whether to keep (honest disclosure) or reword. Not edited. "All rights reserved" + Apache-2.0 is the Mathlib convention, fine.

## 5. Non-Lean files suggested for a short notice
- Python (scripts/generate_laTeX_lean_relationship.py, Frohman's Curve/create_frohmanian_pdf.py), shell (scripts/verify_millennium_complex_calcs.sh), CI yml (.github/workflows/lean.yml, release.yml, codeql.yml):
  `# Copyright (c) 2026 Benjamin Stanley Frohman. Licensed under Apache-2.0.` (after shebang line in .sh/.py)
- .tex (artifacts/*.tex, certs/CubicSourceGap.tex, Definitions/FrohmanianTether_LaTeX_Preamble.tex):
  `% Copyright (c) 2026 Benjamin Stanley Frohman. Licensed under Apache-2.0.`
- Markdown (README.md, Blueprint.md, Proof_Completeness_Report.md, 01/03/04_*.md, LaTeX_Lean_Relationship.md, certs/*.md, docs/*.md, STATUS-*.md, HISTORY.md, CONTRIBUTING.md, SECURITY.md, AUTHORS.md, README files):
  `<!-- Copyright (c) 2026 Benjamin Stanley Frohman. Licensed under Apache-2.0. -->` (README: visible footer line instead)
- *.tex__key_extracts.txt, GEOMETRIC_CONSTRUCTION*.txt, EDITfinals*.txt (root + next1/): first line `Copyright (c) 2026 Benjamin Stanley Frohman. Licensed under Apache-2.0.`
- Must NOT get the notice: lake-manifest.json, lean-toolchain, .lake/**, lean_inventory.json & PROVENANCE-SHA256.txt (generated; regenerate after edits), certs/lake-build-*.txt (build log), .github/dependabot.yml & ISSUE_TEMPLATE (optional, trivial), .vscode/settings.json, LICENSE.
