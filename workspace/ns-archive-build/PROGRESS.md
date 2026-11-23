# NS archive build — PROGRESS (Benjamin approved Nov 23 2:03 PM CT)
Repo clone: /workspace/ns-archive-build/repo, branch fix/no-skip-20261123 (PR #44, head 6183c50)
- Step 1 (2:10 PM CT): fetched PR #44 failing logs (kernel-cert run 45242433814, truth-gate 45242445044). 85 uncovered files -> uncovered.txt, filetable.txt (token counts/imports).
- Step 2: packages symlinked to /workspace/certify/frohmanian-tether-sdiff/.lake/packages (same manifest revs, mathlib 0c154d6710, no rebuild, no cache clear).
- Step 3: comment-stripped scan of the 85: 110 tokens = docs/Clarified_Degeneracy_and_Majorant_Blocks.lean 18 sorry; 11 historical/ files 89 (88 sorry + 1 axiom in historical .../ForMathlib/NS/Tether.lean); fixtures neg_axiom/neg_native_decide/neg_sorry 1 each. All other files token-free (hits were comments).
- Finding: ForMathlib.lean root not built because lakefile ForMathlib lib `globs` lists only submodules -> fix: add `.one `ForMathlib`.
- Finding: manuscript/lean/* are paper listings (main.tex \leanfile VerbatimInput firstline=6), fragments without imports.
- Local lake build started ~2:05 PM CT (slow, shared machine).
- 2:34 PM CT new rule: NEVER hand-write certs; v2.6.x draft attaches only the official GitHub CI artifact (manifest, toolchain, full log, #print axioms). No typed CERTIFICATE.md/summary/self-zipped cert.
- Step 4 (~2:55 PM CT): rewrote scripts/check_lean_coverage.py as build-every-file (BUILT/LAKEFILE/COMPILED/LISTING, no exclusions), lakefile ForMathlib globs += .one ForMathlib; commit 2453c2d pushed to PR #44. Waiting CI.
- 3:05 PM CT rule: any CI run/step with no progress 10 min -> cancel and retry.
- Step 5 (3:28 PM CT): run 45262967172 on 2453c2d: 131 files = 33 BUILT, 1 LAKEFILE, 23 COMPILED, 27 LISTING, 47 FAILED. Artifact in art2/, summary cov2.txt.
- Step 6 (~3:50 PM CT): fixes committed f5e26aa (signed): 9 root Modules mirrors + Symplectori synced to canonical; DataStructures import order; TrajectoryDistinction open NavierStokes3D + dangling doc; UnmodifiedLines import Real; Widgets drop root ProofWidgets import; 2 manuscript listings renamed to current decls; listing check handles `...`. Merged origin/main (3ca7180), pushed.
- Not fixable honestly (to report): Modules/GlobalRegularity.lean (stale copy of deleted module, removed decls, sorryAx via errors); PaperOverview.lean + Skeleton/PaperOverview.lean (unterminated docstring hides pseudo-Lean claiming global regularity with no proofs); drafts/AnalyticEstimates_stub.lean (self-declared stub, True theorems, nonexistent refs); docs/Clarified...lean (18 sorry, not Lean syntax); 16 historical/ files; 10 truth-gate neg fixtures (fail by design; 3 contain sorry/axiom/native_decide on purpose).
