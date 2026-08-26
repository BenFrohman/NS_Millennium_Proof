import Lake
open Lake DSL

package NS_Millennium_Proof where
  leanOptions := #[
    ⟨`pp.unicode.fun, true⟩,
    ⟨`autoImplicit, false⟩,
    ⟨`relaxedAutoImplicit, false⟩
  ]

-- Current stable pin for Clay submission (reproducible, kernel-clean):
-- Lean 4.30.0-rc1 + Mathlib @ v4.30.0-rc1 (official tag).
-- Novel core must remain free of `Lean.trustCompiler`.
require mathlib from git "https://github.com/leanprover-community/mathlib4.git" @ "v4.30.0-rc1"

-- Reusable, Mathlib-oriented lemmas as a standalone target so downstream
-- projects can depend on just the general results without the novel core:
--   lake build ForMathlib
lean_lib ForMathlib where
  roots := #[`ForMathlib]
  globs := #[.submodules `ForMathlib]

@[default_target]
lean_lib NS_Millennium_Proof where
  roots := #[`NS_Millennium_Proof]
  -- Full restored proof modules (WIP, Benjamin Stanley Frohman, 2026-08-26).
  -- Top-level `Modules/` copies match `NS_Millennium_Proof/Modules/` (CI structure check).
  -- Skeleton (`import Mathlib`) and Widgets (ProofWidgets) stay in-tree but out of
  -- the default target so `lake build` remains kernel-passable.
  globs := #[
    .submodules `NS_Millennium_Proof.Modules,
    .submodules `NS_Millennium_Proof.Definitions
  ]
  -- The library uses Lean's module system (§5 of the Language Reference).
  -- Individual .lean files are prefixed with `module` and use `public import` / `public meta import`
  -- to control public API vs private implementation and meta-phase code (widgets, tactics).
  -- This enables faster incremental builds and clearer separation of the novel geometric core
  -- (public theorems) from classical black boxes (implementation details).
set_option linter.unusedVariables false
set_option linter.unusedVariables false
