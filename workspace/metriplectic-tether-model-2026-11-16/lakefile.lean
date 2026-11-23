/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

import Lake

/-!
# lakefile

Lake configuration for `MetriplecticTetherModel`. The dependency pin (`lake-manifest.json`) and
toolchain (`lean-toolchain`) are byte-for-byte copies of those in
`BenFrohman/frohmanian-symplectic-tether-regularity` at commit `2a649d1`.
-/

open Lake DSL

package «MetriplecticTetherModel» where
  version := v!"0.1.0"

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.30.0-rc1"

@[default_target]
lean_lib «MetriplecticTetherModel» where
  roots := #[`MetriplecticTetherModel]
