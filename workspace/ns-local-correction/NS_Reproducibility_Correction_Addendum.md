# Unpublished correction addendum: NS paper/source correspondence

Author: Frohman, Benjamin Stanley
ORCID: 0009-0006-7068-3718
Contact: frohmanbenjamin@gmail.com
Status: LOCAL REVIEW DRAFT. Not published; no new theorem or signature certified.

## Record and source scope
This addendum addresses the added paper in Zenodo record 23749850 (version 2.3.0; concept DOI 10.5281/zenodo.23627609). Its bundled v2.2.0 ZIP exactly matches Git ref 8a5ec50 (297 files). That archive does not contain MainTheorem.lean or Stage6Calculus.lean and cannot reproduce the added paper's named new declarations.

The earliest inspected revision introducing those source modules is b04619c120852a33523363eb3fc3225d3fc5ae0e. Its saved report says 470 theorems, but requests no fresh build. A later tested source is c98fe859867affeba4508b3e51583cfa6b20087c, with successful Lean CI run 42311131768 and actual logged count 488, nonstandard=0, over 19 module entries. These are different scopes and must not be interchanged.

## Corrected definition correspondence
The paper's Conjecture 1 describes differentiability of M(t), the actual vorticity supremum, and the cubic differential inequality M'(t) <= C M(t)^2 - kappa M(t)^3. This is NOT the actual Lean definition of DirectionCurvatureBound in the inspected revisions.

Actual Lean: DirectionCurvatureBound nu is an abbreviation for PeriodicDirectionDepletionBound nu. Its conclusion is a uniform envelope: for smooth divergence-free periodic initial data there exist positive C and kappa such that every relevant local periodic smooth solution satisfies M(t) <= max(M(0), C/kappa), with M evaluated by vorticity_sup_norm. Call this the UNIFORM VORTICITY-ENVELOPE HYPOTHESIS in prose. The historical Lean alias is retained here solely to identify existing code, not as evidence of direction curvature or a derivative estimate.

The actual proved reduction takes BOTH the uniform-envelope hypothesis for every positive viscosity and PeriodicBKMContinuation for every positive viscosity, and concludes Clay_B_exact. It does not prove either premise.

## Separate cubic differential-estimate obligation
A differential-estimate hypothesis on an actual solution must specify M(t) = vorticity_sup_norm(vorticity(u(t))), the relevant time interval, boundedness or attainment needed for real supremum semantics, differentiability on the interval required by the comparison lemma, positive constants, and the cubic differential inequality. No such PDE estimate is proved or introduced as a new axiom by this addendum.

Existing comparison_ode_ceiling is an abstract real-function comparison lemma. It requires C>0, kappa>0, differentiability and the differential inequality on [0,T], and concludes the uniform ceiling there. Instantiating it on an actual PDE norm requires proofs of its premises; a theorem about an arbitrary M is not such a proof. Open-time [0,T) conclusions also require correct restriction to compact subintervals. No endpoint extension or PDE bridge is claimed here.

## Source-to-paper map
- Main reduction: NS_Millennium_Proof/Modules/MainTheorem.lean, clay_reduces_to_direction_curvature_bound. Uniform bound + explicit BKM continuation; not an unconditional regularity proof.
- Actual alias target and ODE ceiling: NS_Millennium_Proof/Modules/HighSetDepletionAndBKM.lean, PeriodicDirectionDepletionBound and comparison_ode_ceiling.
- PDE and supremum semantics: NS_Millennium_Proof/Modules/NS_Equations.lean. IsPhysicalNSSolution alone is not the PDE; NS_PDE is separately required. Pointwise real-supremum bounds require BddAbove or an appropriate proved attainment result.
- Supporting one-variable calculus and shear identities: NS_Millennium_Proof/Modules/Stage6Calculus.lean. These do not prove the universal differential-estimate premise.

## Reproduction pins and evidence
Candidate with existing successful CI: c98fe859867affeba4508b3e51583cfa6b20087c.
Lean: leanprover/lean4:v4.30.0-rc1.
Mathlib: 0c154d67103f74be3a0f2c509f72ccbf5be9f2a7.
CI: https://github.com/BenFrohman/NS_Millennium_Proof/actions/runs/42311131768
Exact source: https://github.com/BenFrohman/NS_Millennium_Proof/tree/c98fe859867affeba4508b3e51583cfa6b20087c
Published paper: https://zenodo.org/records/23749850/files/Frohman_NS_Lean_Reduction_Final_2026.pdf

No fresh build was run for this addendum. The existing root audit covers imported theorem constants under the NS_Millennium_Proof module prefix, excluding internal names; it is not a whole-archive certificate or a physical-model validation. The published TITAN signature verifies against its embedded public key; independent signer identity remains unverified. Cryptographic integrity is not mathematical applicability.

## Review and publication boundary
Proposed repair: align the paper's named hypothesis with its actual Lean uniform-envelope meaning; present the cubic estimate separately as an unproved sufficient-condition program, and prove an exact PDE-to-comparison bridge before describing it as formalized. Retain historical sources/records. No original record, repository file, license, branch or tag has been changed. This draft is not a replacement published certificate and carries no invented signature.
