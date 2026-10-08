/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

/-!
# The standard stack

Environment harness for a functional Lean 4 project.
This is not a theorem about Navier–Stokes, Hodge, or any paper claim.
A paper claim is certified only by a compiling declaration with no `sorryAx`.

Scaffolding of this harness used Grok Heavy (xAI). Authorship remains
Benjamin Stanley Frohman.
-/

/-- The five obligations of a functional Lean 4 environment. -/
structure StandardStack where
  /-- `lean-toolchain` is pinned and elan selects it. -/
  elanPinned : Bool
  /-- The editor is opened on a Lake project, not a lone file. -/
  lakeProject : Bool
  /-- InfoView is the acceptance surface. -/
  editorInfoView : Bool
  /-- `lake exe cache get` runs before a Mathlib build. -/
  cacheBeforeMathlibBuild : Bool
  /-- `lake build` is green before any contribution PR. -/
  buildBeforePR : Bool

deriving Repr, DecidableEq

/-- The standard stack, as the agent must instantiate it. -/
def theStandardStack : StandardStack where
  elanPinned := true
  lakeProject := true
  editorInfoView := true
  cacheBeforeMathlibBuild := true
  buildBeforePR := true

/-- The standard stack holds. Closes by computation; no `sorry`. -/
theorem the_standard_stack :
    theStandardStack.elanPinned
      ∧ theStandardStack.lakeProject
      ∧ theStandardStack.editorInfoView
      ∧ theStandardStack.cacheBeforeMathlibBuild
      ∧ theStandardStack.buildBeforePR := by
  decide

/-- A contribution is not ready while any stack obligation is false. -/
theorem standard_stack_ready_iff :
    (theStandardStack.elanPinned
      ∧ theStandardStack.lakeProject
      ∧ theStandardStack.editorInfoView
      ∧ theStandardStack.cacheBeforeMathlibBuild
      ∧ theStandardStack.buildBeforePR)
      ↔ True := by
  decide
