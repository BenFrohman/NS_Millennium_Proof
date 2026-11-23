/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

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

-- Reusable, Mathlib-oriented lemmas. This is a default target, so plain
-- `lake build` compiles it together with the main library.
@[default_target]
lean_lib ForMathlib where
  roots := #[`ForMathlib]
  globs := #[.submodules `ForMathlib]

@[default_target]
lean_lib NS_Millennium_Proof where
  roots := #[`NS_Millennium_Proof]
  -- Restored proof modules (Benjamin Stanley Frohman, 2026-08-26).
  -- Skeleton and Widgets are in the default build. They still contain `sorry`
  -- in the narrative skeleton and the widget ref; those are not the kernel
  -- certificate of `NS_Millennium_Proof.Modules`.
  globs := #[
    .submodules `NS_Millennium_Proof.Modules,
    .submodules `NS_Millennium_Proof.Definitions,
    .submodules `NS_Millennium_Proof.Skeleton,
    .submodules `NS_Millennium_Proof.Widgets,
    .submodules `NS_Millennium_Proof.Lean_Formalization_2026_05_28
  ]

-- Top-level mirror. `Modules.AnalyticEstimates` is the file that still names
-- the May module path; that path is a re-export of the live majorant.
@[default_target]
lean_lib Modules where
  roots := #[`Modules]
  globs := #[.submodules `Modules]
  -- The library uses Lean's module system (§5 of the Language Reference).
  -- Individual .lean files are prefixed with `module` and use `public import` / `public meta import`
  -- to control public API vs private implementation and meta-phase code (widgets, tactics).
  -- This enables faster incremental builds and clearer separation of the novel geometric core
  -- (public theorems) from classical black boxes (implementation details).
set_option linter.unusedVariables false
set_option linter.unusedVariables false
