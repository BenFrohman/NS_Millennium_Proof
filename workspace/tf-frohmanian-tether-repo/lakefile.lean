/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

import Lake

/-!
# lakefile

The dependency pin (`lake-manifest.json`, sha256
`b81d814b7d2d2d2821b03ed679324d5e7ec7da674e0a977352d01c88cbe8ccb8`) and the
toolchain (`lean-toolchain`, `leanprover/lean4:v4.30.0-rc1`) are byte-for-byte
copies of those in `BenFrohman/frohmanian-symplectic-tether-regularity`
(Mathlib revision `0c154d67103f74be3a0f2c509f72ccbf5be9f2a7`).
Run `lake exe cache get` before `lake build`; do not pass `--update`.
-/

open Lake DSL

package «TFFrohmanianTether» where
  version := v!"0.1.0"

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.30.0-rc1"

@[default_target]
lean_lib «TFFrohmanianTether» where
  roots := #[`TFFrohmanianTether]
