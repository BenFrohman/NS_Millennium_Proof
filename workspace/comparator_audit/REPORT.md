# Comparator / comparison audit: BenFrohman/NS_Millennium_Proof (origin/main + all history)

## Verdict
The earlier conclusion was WRONG, or at best only half right. The literal words "comparator", "nanoda", "lean4checker" and "gold-standard" only ever refer to external Lean validation tools. But the repo also has a real, user-authored comparison component that is proved and in the default build: the scalar Riccati ODE comparison principle that carries the majorant step (Lemma 3.1). Treating the whole "compar*" family as an external reference missed it.

## Classified hits
| Class | Where | What |
|---|---|---|
| A built | NS_Millennium_Proof/Modules/AnalyticPipeline.lean | comparison_ode_stability (barrier: y' <= Cy^2 - k''y^3 => y t <= max(y 0, C/k'')), comparison_ode_nonneg |
| A built | NS_Millennium_Proof/Modules/TetheredLyapunov.lean | comparison_ode_local_exists, IsComparisonODESolution, ComparisonODE (choice def), comparison_ode_clipped_on_Icc, comparison_ode_exists, ComparisonODE_spec, uniform_majorant_bound, majorant_comparison_principle (non-public, applies barrier to MollifiedSupNorm), comparison_majorant_global_bound (non-public) |
| A built re-exports | ClosureBlueprint.lean; IndependentMajorant.lean | comparison_ode_stability, comparison_ode_bound_of_equality, comparison_ode_solution_existence; ComparisonODE abbrev, comparison_majorant_global_bound |
| A not built | top-level Modules/*.lean mirror | duplicates |
| A draft, sorry, not built | docs/Clarified_Degeneracy_and_Majorant_Blocks.lean | comparison_majorant_ODE := sorry, majorant_comparison_principle, riccati_majorant_global_bound, comparison_principle (superseded) |
| B tool/CI | none | workflows (codeql, lean, release), .grok skills, lakefile and lake-manifest: no comparator, nanoda or lean4checker step, dependency or exe. No artifacts or logs. None of the 42 BenFrohman public repos is a fork or a comparator/nanoda repo. |
| C external doc | Blueprint.md 359-548; GlobalRegularity.lean (both copies); TetheredLyapunov.lean ~324-340 (both); LaTeX_Lean_Relationship.md:58 + scripts/generate_laTeX_lean_relationship.py:238; NS_Millennium_Proof/Modules/Uniqueness.lean:423; historical/*.bak | validation ladder lean4checker --fresh -> leanprover/comparator + nanoda; aspirational, no run claimed |
| D | many comments | plain English |

Provenance: comparison proofs from 2a50bd1/c3d8734 on 2026-08-26 by Frohmanian (BenFrohman). External validation text from the initial commit 236244d on 2026-06-19 by Benjamin Stanley Frohman. Remote branch: main only.

## Axioms (ns_trial build)
All public comparison declarations: [propext, Classical.choice, Quot.sound]. The two non-public ones are module-private, so they can't be queried from outside. They are one-liners onto the clean lemmas, and the module builds with no sorry.

## Mistags fixed (comparator_fixes.patch, comments/docs only)
1. TetheredLyapunov.lean (both copies) cites nonexistent `riccati_majorant_global_bound`. The real name is `comparison_majorant_global_bound`, now labeled user-authored.
2. The pointer to the docs draft listed draft names as if they were built. Clarified.
3. Blueprint Level 4 now has a terminology note: links to leanprover/comparator and ammkrn/nanoda_lib, a statement that neither is vendored or run and no run is recorded, and the distinction from the user-authored comparison lemmas.
Noted, not patched: the "4.28.0 pin" wording versus lakefile v4.30.0-rc1, and the sorry in the docs draft.

## Build test
Throwaway worktree of origin/main + patch: lake build succeeded (2703 jobs), standard axioms only. Worktree removed. git apply --check passes.

## Remaining ambiguity
None in the repo. No evidence of any comparator/nanoda run outside it.
