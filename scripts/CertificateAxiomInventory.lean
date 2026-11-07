/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Frohman, Benjamin Stanley
-/
import NS_Millennium_Proof

open Lean Elab Command

-- Transitive axioms of each noninternal project theorem declaration, including
-- generated named declarations. This audits hypotheses, not PDE interpretation.
#eval show CommandElabM Unit from do
  let env ← getEnv
  let mut count := 0
  for (n, ci) in env.constants.toList do
    if n.isInternal then continue
    let some idx := env.getModuleIdxFor? n | continue
    let mod := env.header.moduleNames[idx.toNat]!
    unless (`NS_Millennium_Proof).isPrefixOf mod do continue
    unless ci matches .thmInfo _ do continue
    let axs ← liftCoreM <| Lean.collectAxioms n
    let nonstd := axs.filter (fun a => a ∉ [``propext, ``Classical.choice, ``Quot.sound])
    unless nonstd.isEmpty do throwError "nonstandard axioms: {n}: {nonstd}"
    IO.println s!"AXIOM\t{n}\t{mod}\t{axs}"
    count := count + 1
  IO.println s!"TOTAL_THEOREM_DECLARATIONS\t{count}"
