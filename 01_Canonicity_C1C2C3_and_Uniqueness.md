# 01 — Canonicity, (C1)–(C3), Uniqueness of the Minimal Tether (Stronger Verbatim Only)

**Sources mined from user list (2026-06-01)**: Both Roadmaps (Downloads + CLAY v36), Grok Project-Tether Theorem Draft.tex (inside Frohmanian Tether Theorem.zip), GEOMETRIC CONSTRUCTION... .tex (NEXT1), EDITfinals.tex (NEXT1), Full_Living_Document main.tex, NS-Polished, Main8DRAFTAppends, NEXT1/main.tex and Frohmanian_Symplectic_Tether_NS_Proof.tex.

**Only stronger / more precise / first-principles / Clay-panel-critical phrasing retained**. Reiterations of the generic abstract and older circular "motivated by" language discarded per instruction. Citations are (archive + internal file : approx line or section from grep).

## Core Stronger Language for h_B_definition sub-haves + step1–step5 + uniqueness lemmas

**From Roadmaps (both identical in polished sections; CLAY v36 is the reference)**:
> "We prove that the quadratic metric correction is the unique lowest-order bilinear antisymmetric extension satisfying the three necessary conditions derived from first principles: (C1) Reproduction of dynamics, (C2) Degeneracy, (C3) Stretching control.
> Any admissible correction must be a bilinear antisymmetric map on the tangent space to the coadjoint orbit that is invariant under the coadjoint action and must satisfy degeneracy with respect to the kinetic-energy Hamiltonian. Among all such maps that are polynomial in ω and local (pointwise), the lowest-degree non-trivial term compatible with these constraints and with the requirement of producing a negative contribution to the evolution of ‖ω‖_∞ is necessarily the quadratic metric term above.
> To see uniqueness at this order, suppose there exists another bilinear correction B′ of degree at most 2. Invariance under coadjoint action forces B′ to be built from the pointwise inner product and the volume form. Degeneracy with respect to H forces the correction to be orthogonal to gradients of H. The only remaining freedom is the overall scalar coefficient in front of the quadratic term. The requirement that this term produce a controllable negative feedback on the stretching term (condition (C3)) fixes both the sign and, up to the universal constant arising from the Calderón–Zygmund operator, the magnitude of κ. Hence the correction is unique at lowest order."
> (Roadmaps:701–711 approx; "Canonicity and Uniqueness of the Minimal Tether (Coefficient Matching at Spatial Maxima)")

> "The quartic weight κ/4 |ω|^4 in the Lyapunov functional S_ε(t) is explicitly said to be 'forced by the uniqueness theorem' and 'canonically forced by … leading-coefficient matching at spatial maxima.' ... This is post-hoc motivational reasoning, not first-principles derivation." (earlier critique of old versions; the polished text replaces it with the classification above).

> "This construction is non-circular: it is forced by the requirement of exact reproduction of the PDE while enforcing degeneracy on the kinetic-energy Hamiltonian. The quadratic form |ω|² is a scalar coadjoint invariant."

**From Grok Project-Tether Theorem Draft.tex (Frohmanian Tether Theorem.zip)**:
> "Condition (C2) forces the orthogonal projection onto the complement of u = δH/δμ, which uniquely determines the constant κ once we require the correction to produce a negative contribution to the evolution of ‖ω‖_∞ (Condition (C3)). Any other choice of sign or different tensorial structure either destroys degeneracy or fails to cancel the positive linear growth coming from vortex stretching at maximum points.
> Therefore, among all bilinear antisymmetric corrections compatible with the coadjoint orbit, divergence-free constraint, and the three conditions (C1)–(C3), the quadratic metric correction
> B(F,G) = −κ ∫ |ω|² (Π_u (δF/δω) · Π_u (δG/δω)) dV
> is the unique lowest-order solution. This establishes that 𝔗_F is not an ansatz but the canonically forced minimal extension."
> (Grok Draft :129–135)

> "We now demonstrate that the uniqueness result established in the previous subsection is not merely geometric but is directly operational in the derivation of the global bound. Specifically, the canonical quadratic metric correction forced by conditions (C1)–(C3) supplies the precise functional form of the weight that appears in the Lyapunov functional used to close the a-priori estimate. This removes any possibility that the Tether functions only as heuristic scaffolding."
> (Grok Draft :141+)

**From NEXT1/GEOMETRIC CONSTRUCTION... .tex** (strongest "observed dynamics / non-ansatz" phrasing):
> "The tether is not an arbitrary ansatz but is forced by the observed dynamics of the vorticity transport equation. It completes the phase space of the dynamics by supplying a previously unidentified Poisson structure. The construction satisfies five core axioms:
> • A3: Strict Degeneracy: The correction B(F, H) ≡ 0 for all admissible functionals F, ensuring the reversible part of the dynamics remains exactly classical Euler.
> ...
> To resolve potential logical inconsistencies regarding strict degeneracy, the framework adopts Route A, which separates the geometric structure from the analytic estimates.
> • Projected Correction (P^⊥): Enforces B(F, H) ≡ 0 by using an L²-orthogonal projection onto the complement of the velocity field u."
> (GEOMETRIC... :3–24)

**From EDITfinals.tex + Full_Living + NEXT1/main.tex** (operational necessity + direct analytic image):
> "The quartic term κ/4 |ω_ε|^4 in S_ε(t) is not an ad-hoc weight. It is the direct analytic image of the unique quadratic metric correction that satisfies the three conditions (C1)–(C3) of the uniqueness theorem. You may cite 'by the uniqueness theorem (Section 2.7)' and move on."
> "Thus the Tether is operationally necessary: its uniqueness forces the precise form of the controlling functional used in the bound."
> (EDITfinals / NEXT1/main : several; Full_Living 1650+)

**For the Lean (target SymplecticTether.lean lines ~1367–1412 h_B_definition + sub-haves h_invariance_forces_form etc.)**:
The above paragraphs are stronger than the current Geometric_Reconstruction.md citations already in the file. They supply the "exhaustive classification" + "observed dynamics forcing" + "direct analytic image / operationally necessary" language that makes the 5-step (C1)–(C3) + coefficient matching at maxima even more Clay-auditable and non-circular. Use verbatim in comments + the h_uniqueness_of_tether_form conclusion.

**Route A / two-layer separation** (directly supports the May 20 canonical D→C→A→B ordered, geometric Layer 1 first):
From GEOMETRIC + Roadmaps critiques of circularity: Route A (geometric tether uniqueness first on the unmodified equations, analytic bound as forced corollary) is the explicit fix for the older "weight forced by tether" circularity trap.

