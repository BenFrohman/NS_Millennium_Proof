import Lean
import «ForMathlib».«NS».«Tether»
import «NS_Millennium_Proof»
import «NS_Millennium_Proof».«Definitions».«FrohmanianTether»
import «NS_Millennium_Proof».«Modules».«AnalyticPipeline»
import «NS_Millennium_Proof».«Modules».«ArnoldGeometric»
import «NS_Millennium_Proof».«Modules».«AssemblyGap»
import «NS_Millennium_Proof».«Modules».«Assumptions»
import «NS_Millennium_Proof».«Modules».«CeilingFromRate»
import «NS_Millennium_Proof».«Modules».«ClayStatements»
import «NS_Millennium_Proof».«Modules».«ClosureBlueprint»
import «NS_Millennium_Proof».«Modules».«Combined»
import «NS_Millennium_Proof».«Modules».«ConcreteSDiff»
import «NS_Millennium_Proof».«Modules».«ConditionalRegularity»
import «NS_Millennium_Proof».«Modules».«CubicSourceCertificate»
import «NS_Millennium_Proof».«Modules».«ForMathlib».«Projection»
import «NS_Millennium_Proof».«Modules».«HighSetDepletionAndBKM»
import «NS_Millennium_Proof».«Modules».«IndependentMajorant»
import «NS_Millennium_Proof».«Modules».«LyapunovDIStatus»
import «NS_Millennium_Proof».«Modules».«MainTheorem»
import «NS_Millennium_Proof».«Modules».«NS_Equations»
import «NS_Millennium_Proof».«Modules».«PlanSteps»
import «NS_Millennium_Proof».«Modules».«ScalingIdentities»
import «NS_Millennium_Proof».«Modules».«ShearSolution»
import «NS_Millennium_Proof».«Modules».«Stage6Calculus»
import «NS_Millennium_Proof».«Modules».«SymplecticConstraint»
import «NS_Millennium_Proof».«Modules».«SymplecticTether»
import «NS_Millennium_Proof».«Modules».«TetherRateCounterexample»
import «NS_Millennium_Proof».«Modules».«TetheredLyapunov»
import «NS_Millennium_Proof».«Modules».«TorusStrainExclusion»
import «NS_Millennium_Proof».«Modules».«Uniqueness»
import «NS_Millennium_Proof».«Semantics»
import «NS_Millennium_Proof».«TruthGate»

open Lean Elab Command

/-- Prints `#print axioms`-style lines for every theorem declared in the listed modules. -/
elab "#kernel_certificate_audit" : command => do
  let env ← getEnv
  let mods : Array Name := #[`«ForMathlib».«NS».«Tether», `«NS_Millennium_Proof», `«NS_Millennium_Proof».«Definitions».«FrohmanianTether», `«NS_Millennium_Proof».«Modules».«AnalyticPipeline», `«NS_Millennium_Proof».«Modules».«ArnoldGeometric», `«NS_Millennium_Proof».«Modules».«AssemblyGap», `«NS_Millennium_Proof».«Modules».«Assumptions», `«NS_Millennium_Proof».«Modules».«CeilingFromRate», `«NS_Millennium_Proof».«Modules».«ClayStatements», `«NS_Millennium_Proof».«Modules».«ClosureBlueprint», `«NS_Millennium_Proof».«Modules».«Combined», `«NS_Millennium_Proof».«Modules».«ConcreteSDiff», `«NS_Millennium_Proof».«Modules».«ConditionalRegularity», `«NS_Millennium_Proof».«Modules».«CubicSourceCertificate», `«NS_Millennium_Proof».«Modules».«ForMathlib».«Projection», `«NS_Millennium_Proof».«Modules».«HighSetDepletionAndBKM», `«NS_Millennium_Proof».«Modules».«IndependentMajorant», `«NS_Millennium_Proof».«Modules».«LyapunovDIStatus», `«NS_Millennium_Proof».«Modules».«MainTheorem», `«NS_Millennium_Proof».«Modules».«NS_Equations», `«NS_Millennium_Proof».«Modules».«PlanSteps», `«NS_Millennium_Proof».«Modules».«ScalingIdentities», `«NS_Millennium_Proof».«Modules».«ShearSolution», `«NS_Millennium_Proof».«Modules».«Stage6Calculus», `«NS_Millennium_Proof».«Modules».«SymplecticConstraint», `«NS_Millennium_Proof».«Modules».«SymplecticTether», `«NS_Millennium_Proof».«Modules».«TetherRateCounterexample», `«NS_Millennium_Proof».«Modules».«TetheredLyapunov», `«NS_Millennium_Proof».«Modules».«TorusStrainExclusion», `«NS_Millennium_Proof».«Modules».«Uniqueness», `«NS_Millennium_Proof».«Semantics», `«NS_Millennium_Proof».«TruthGate»]
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
