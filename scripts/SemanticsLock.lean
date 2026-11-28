/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

import NS_Millennium_Proof.Semantics
import NS_Millennium_Proof.TruthGate
import NS_Millennium_Proof.Definitions.FrohmanianTether
import NS_Millennium_Proof.Modules.AnalyticPipeline
import NS_Millennium_Proof.Modules.Stage6Calculus
import NS_Millennium_Proof.Modules.MainTheorem
import NS_Millennium_Proof.Modules.ArnoldGeometric
import NS_Millennium_Proof.Modules.AssemblyGap
import NS_Millennium_Proof.Modules.Assumptions
import NS_Millennium_Proof.Modules.ClayStatements
import NS_Millennium_Proof.Modules.ClosureBlueprint
import NS_Millennium_Proof.Modules.CubicSourceCertificate
import NS_Millennium_Proof.Modules.ForMathlib.Projection
import NS_Millennium_Proof.Modules.ConditionalRegularity
import NS_Millennium_Proof.Modules.IndependentMajorant
import NS_Millennium_Proof.Modules.NS_Equations
import NS_Millennium_Proof.Modules.SymplecticTether
import NS_Millennium_Proof.Modules.SymplecticConstraint
import NS_Millennium_Proof.Modules.TetheredLyapunov
import NS_Millennium_Proof.Modules.TetherRateCounterexample
import NS_Millennium_Proof.Modules.HighSetDepletionAndBKM
import NS_Millennium_Proof.Modules.ShearSolution
import NS_Millennium_Proof.Modules.TorusStrainExclusion
import NS_Millennium_Proof.Modules.Uniqueness
import NS_Millennium_Proof.Modules.PlanSteps
import NS_Millennium_Proof.Modules.Combined
import NS_Millennium_Proof.Modules.ConcreteSDiff
import NS_Millennium_Proof.Modules.ScalingIdentities
import NS_Millennium_Proof.Modules.CeilingFromRate
import NS_Millennium_Proof.Modules.LyapunovDIStatus

/-!
# scripts.SemanticsLock

Standalone run of the Truth Gate. It imports the root's modules (not the root itself), so it
still runs, and reports every failure, when the root's in-build gate has failed. Run from the repository root:

    lake env lean scripts/SemanticsLock.lean

Step 1 is the observation pass required of every agent before it touches a Lean obligation or
writes a public claim: it prints the locked correspondences and both sides of every lock. Step 2
re-runs the gate (the same check `lake build` runs in `NS_Millennium_Proof.lean`) and fails with
a non-zero exit unless every lock passes. Step 3 prints the axioms of every lock declaration and
public theorem; only `propext`, `Classical.choice` and `Quot.sound` may appear.
-/

/-! ## 1. Observation pass (changes nothing) -/

#check @NS_Millennium_Proof.Semantics.intended_correspondence
#print NS_Millennium_Proof.Semantics.paper_claim
#print NS_Millennium_Proof.Semantics.formal_claim

#check @NS_Millennium_Proof.Semantics.EnvelopeReduction.intended_correspondence
#print NS_Millennium_Proof.Semantics.EnvelopeReduction.paper_claim
#print NS_Millennium_Proof.Semantics.EnvelopeReduction.formal_claim
#print NS_Millennium_Proof.Semantics.PaperUniformEnvelope

#check @NS_Millennium_Proof.Semantics.DirectionCurvatureReduction.intended_correspondence
#print NS_Millennium_Proof.Semantics.DirectionCurvatureReduction.paper_claim
#print NS_Millennium_Proof.Semantics.DirectionCurvatureReduction.formal_claim
#print NS_Millennium_Proof.Semantics.PaperUniformCeiling

#check @NS_Millennium_Proof.Semantics.PeriodicTetherReduction.intended_correspondence
#print NS_Millennium_Proof.Semantics.PeriodicTetherReduction.paper_claim
#print NS_Millennium_Proof.Semantics.PeriodicTetherReduction.formal_claim

#check @NS_Millennium_Proof.Semantics.ConditionalGlobalRegularity.intended_correspondence
#print NS_Millennium_Proof.Semantics.ConditionalGlobalRegularity.paper_claim
#print NS_Millennium_Proof.Semantics.ConditionalGlobalRegularity.formal_claim
#check @NS_Millennium_Proof.Semantics.TetherTheorem.intended_correspondence
#print NS_Millennium_Proof.Semantics.TetherTheorem.paper_claim
#print NS_Millennium_Proof.Semantics.TetherTheorem.formal_claim

/-! ## 2. The gate -/

#eval TruthGate.runTruthGate "truth-gate.lock.json"

/-! ## 3. Axioms -/

#print axioms NS_Millennium_Proof.Semantics.intended_correspondence
#print axioms NS_Millennium_Proof.Semantics.EnvelopeReduction.intended_correspondence
#print axioms NS_Millennium_Proof.Semantics.DirectionCurvatureReduction.intended_correspondence
#print axioms NS_Millennium_Proof.Semantics.PeriodicTetherReduction.intended_correspondence
#print axioms NS_Millennium_Proof.Semantics.ConditionalGlobalRegularity.intended_correspondence
#print axioms NS_Millennium_Proof.Semantics.TetherTheorem.intended_correspondence
#print axioms FrohmanianTether.HighSetDepletionAndBKM.clay_reduces_to_uniform_vorticity_envelope
#print axioms FrohmanianTether.HighSetDepletionAndBKM.clay_reduces_to_direction_curvature_bound
#print axioms FrohmanianTether.ClayStatements.clay_B_exact_of_periodic_tether_bound
#print axioms CeilingFromRate.classical_vorticity_ceiling
#print axioms CeilingFromRate.theorem_1_1
#print axioms NavierStokes3D.zero_isPeriodicSmoothSolution
#print axioms LyapunovDIStatus.key_di_h1_hypothesis_unsatisfiable
#print axioms TetherRateCounterexample.zero_classical_periodic_solution
