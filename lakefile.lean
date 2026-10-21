import Lake
open Lake DSL

package NS_Millennium_Proof where
  leanOptions := #[
    ⟨`pp.unicode.fun, true⟩,
    ⟨`autoImplicit, false⟩,
    ⟨`relaxedAutoImplicit, false⟩
  ]

require mathlib from git "https://github.com/leanprover-community/mathlib4.git" @ "v4.28.0"

@[default_target]
lean_lib NS_Millennium_Proof where
  -- Support the flat research layout of this clean copy: the package root .lean
  -- (NS_Millennium_Proof.lean) is included by default; we explicitly add globs for the
  -- sibling top-level directories ForMathlib/ and Modules/ so that bare imports
  -- `import ForMathlib.NS.Tether` and `import Modules.*` resolve (per §5 module hygiene).
  -- This restores buildability to the exact layout used for all prior CMI_CYCLE
  -- reference applications (propext, universes, ValidatedTether monad, etc.).
  globs := #[.submodules `ForMathlib, .submodules `Modules]
