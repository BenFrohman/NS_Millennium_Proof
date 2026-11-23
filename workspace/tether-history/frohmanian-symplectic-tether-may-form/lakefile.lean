import Lake
open Lake DSL

package «TetherMayForm» where
  version := v!"0.1.0"

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.30.0-rc1"

@[default_target]
lean_lib «TetherMayForm» where
  roots := #[`TetherMayForm]

lean_lib «MayForm31» where
  roots := #[`MayForm31.Statement, `MayForm31.Proofs, `MayForm31.Orbit]
