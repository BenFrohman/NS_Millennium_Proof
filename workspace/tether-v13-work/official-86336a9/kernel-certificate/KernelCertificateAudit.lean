import Lean
import «FrohmanianTetherConditional»
import «FrohmanianTetherConditional».«AnalyticBridgeRefutation»
import «FrohmanianTetherConditional».«AnalyticBridgeTarget»
import «FrohmanianTetherConditional».«ClassicalEstimatePieces»
import «FrohmanianTetherConditional».«ClassicalNS»
import «FrohmanianTetherConditional».«ClassicalNSOpenTarget»
import «FrohmanianTetherConditional».«FrohmanianTripleArchitecture»
import «FrohmanianTetherConditional».«FrohmanianTripleArchitectureLifespan»
import «FrohmanianTetherConditional».«Semantics»
import «FrohmanianTetherConditional».«SemanticsPillars»
import «FrohmanianTetherConditional».«SemanticsUnifiedHs»
import «FrohmanianTetherConditional».«SemanticsVacuity»

open Lean Elab Command

/-- Prints `#print axioms`-style lines for every theorem declared in the listed modules. -/
elab "#kernel_certificate_audit" : command => do
  let env ← getEnv
  let mods : Array Name := #[`«FrohmanianTetherConditional», `«FrohmanianTetherConditional».«AnalyticBridgeRefutation», `«FrohmanianTetherConditional».«AnalyticBridgeTarget», `«FrohmanianTetherConditional».«ClassicalEstimatePieces», `«FrohmanianTetherConditional».«ClassicalNS», `«FrohmanianTetherConditional».«ClassicalNSOpenTarget», `«FrohmanianTetherConditional».«FrohmanianTripleArchitecture», `«FrohmanianTetherConditional».«FrohmanianTripleArchitectureLifespan», `«FrohmanianTetherConditional».«Semantics», `«FrohmanianTetherConditional».«SemanticsPillars», `«FrohmanianTetherConditional».«SemanticsUnifiedHs», `«FrohmanianTetherConditional».«SemanticsVacuity»]
  for m in mods do
    match env.getModuleIdx? m with
    | none => IO.println s!"MODULE NOT LOADED {m}"
    | some i =>
      for n in (env.header.moduleData[i.toNat]!).constNames do
        match env.find? n with
        | some (.thmInfo _) =>
          if !n.isInternal then
            let ax ← collectAxioms n
            let axs := ", ".intercalate (ax.toList.map toString)
            if ax.isEmpty then IO.println s!"'{n}' does not depend on any axioms [module {m}]"
            else IO.println s!"'{n}' depends on axioms: [{axs}] [module {m}]"
        | _ => pure ()

#kernel_certificate_audit
