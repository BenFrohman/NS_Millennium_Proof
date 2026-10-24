/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

-- Axiom audit for the default build target. Run: lake env lean scripts/AxiomAudit.lean
-- Fails (non-zero exit) if any theorem depends on axioms beyond propext/Classical.choice/Quot.sound.

import NS_Millennium_Proof.Definitions.FrohmanianTether
import NS_Millennium_Proof.Modules.AnalyticPipeline
import NS_Millennium_Proof.Modules.ArnoldGeometric
import NS_Millennium_Proof.Modules.AssemblyGap
import NS_Millennium_Proof.Modules.Assumptions
import NS_Millennium_Proof.Modules.ClayStatements
import NS_Millennium_Proof.Modules.ClosureBlueprint
import NS_Millennium_Proof.Modules.CubicSourceCertificate
import NS_Millennium_Proof.Modules.ForMathlib.Projection
import NS_Millennium_Proof.Modules.GlobalRegularity
import NS_Millennium_Proof.Modules.IndependentMajorant
import NS_Millennium_Proof.Modules.NS_Equations
import NS_Millennium_Proof.Modules.SymplecticTether
import NS_Millennium_Proof.Modules.TetheredLyapunov
import NS_Millennium_Proof.Modules.Uniqueness
open Lean Elab Command
#eval show CommandElabM Unit from do
  let env ← getEnv
  let mut stats : Std.HashMap Name (Nat × Nat) := {}
  let mut bad : Array String := #[]
  for (n, ci) in env.constants.toList do
    if n.isInternal then continue
    let some idx := env.getModuleIdxFor? n | continue
    let mod := env.header.moduleNames[idx.toNat]!
    unless (`NS_Millennium_Proof).isPrefixOf mod do continue
    unless ci matches .thmInfo _ do continue
    let axs ← liftCoreM <| Lean.collectAxioms n
    let nonstd := axs.filter (fun a => a ∉ [``propext, ``Classical.choice, ``Quot.sound])
    let (c, b) := stats.getD mod (0,0)
    stats := stats.insert mod (c+1, if nonstd.isEmpty then b else b+1)
    unless nonstd.isEmpty do bad := bad.push s!"{n} : {nonstd}"
  for (m,(c,b)) in stats.toList do IO.println s!"{m}: theorems={c} nonstandard={b}"
  for s in bad do IO.println s
  let total := stats.fold (fun acc _ (c, _) => acc + c) 0
  IO.println s!"TOTAL theorems={total} nonstandard={bad.size}"
  unless bad.isEmpty do throwError "axiom audit FAILED: {bad.size} theorem(s) use non-standard axioms"

#print axioms GlobalRegularity.frohmanian_tether_theorem
#print axioms GlobalRegularity.global_regularity_for_NS
#print axioms FrohmanianTether.ClayStatements.global_regularity_for_NS_nonvacuous_at_zero
#print axioms FrohmanianTether.ClayStatements.frohmanianTetherRate_zero
#print axioms FrohmanianTether.ClayStatements.frohmanianTetherBound_zero
#print axioms FrohmanianTether.uniqueness_of_minimal_tether
#print axioms FrohmanianTether.uniqueness_of_minimal_symmetric_tether
#print axioms TetheredLyapunov.riccati_ceiling_of_vorticity_di
