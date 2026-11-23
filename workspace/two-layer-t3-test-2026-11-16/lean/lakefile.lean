/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

import Lake

/-!
# lakefile

Local test project. Same package name, mathlib requirement, lake-manifest.json and
lean-toolchain as BenFrohman/frohmanian-symplectic-tether-regularity @ 2a649d1d.
-/

open Lake DSL

package «FrohmanianSymplecticTether» where
  version := v!"1.1.0"

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.30.0-rc1"

@[default_target]
lean_lib «TwoLayerT3» where
  roots := #[`TwoLayerT3]
