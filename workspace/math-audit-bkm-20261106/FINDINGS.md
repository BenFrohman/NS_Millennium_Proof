# Mathematical boundary investigation (current remote main, 2026-11-06)

Pinned commits: Clay- 7191626ef238ba661a07c2e006c46c3958a5a7d9; HODGE-DISPROOF 5d6449517545fb00cf367bc7d9eba4414242d633. Sources downloaded read-only through authenticated gh API. No repository edits or external writes.

## Clay

StatementB.lean 109-130 proves only the reduction from maximal local solution + BKM integrability to global solution. Endpoint-finite BKM integrability is not implied by smoothness on [0,T): compactness only bounds vorticity on [0,t] for t<T.

New exact diagnostic: DirectionAlignment.lean 43-46 dhyImpliesRegularity is equivalent to PeriodicBKMIntegrability. The existential DHYPacket can have every component identically zero, C=0; no field relates it to u or an actual vortex line. BoundaryChecks.lean proves this equivalence using the exact current Clay definitions, typechecked Lean 4.16 in cached matching environment after byte comparisons. This is not a new PDE proof or a valid imported DHY criterion.

The actual DHY paper math-ph/0402032 Theorem 1 applies to Euler/NS and requires a line connecting a near-maximal point to an endpoint whose vorticity magnitude is integrable in time, and bounded integrated direction divergence. Its Theorem 2 is for Euler, requiring materially nested vortex-line segments, comparable maximal vorticity, curvature/direction-divergence control, tangential/normal velocity growth and a quantitative lower bound on segment length. The arbitrary packet does not encode these hypotheses. Do not treat Theorem 2 as an automatic viscous NS theorem.

Correct conditional analytic estimate: q=|omega|^2 obeys (dt+u.grad-nu Delta)q=2 omega.S.omega-2nu|grad omega|^2. If a(t)=sup_x max(alpha(t,x),0) has finite integral A on [0,T), maximum principle gives M(t)<=M(0) exp(int_0^t a), hence int_0^T M <= T M(0) exp(A). The missing input is the solution-derived finite integral of a (or another genuine critical estimate), not the algebraic Gronwall step.

Manuscript section10_gaps.tex 19-23 still writes stretching <= universal C M_epsilon^2 with only a vague logarithm correction. Actual bound is |omega_epsilon . grad u . omega_epsilon| <= M_epsilon^2 ||grad u||_infty. The omitted strain factor is essential. section10_gaps.tex 27-31 cannot convert L6 dissipation into maximum damping without a concentration lower bound. Smooth periodic divergence-free shear initial data can have vorticity of fixed height on arbitrarily narrow strips, so no universal positive lower bound int|omega|^6 >= c M^4 holds for all such initial data. This does not exclude additional solution/data-dependent concentration estimates if proved.

## HODGE-DISPROOF

Disproof.lean 63-81 uses cl=0 on Q, gamma=1. This cannot be the full codimension-two geometric cycle map of a nonempty smooth projective complex fourfold: h=c1(O_X(1)), cl(H^2)=h^2 and int_X h^4=deg(X)>0, hence h^2 !=0 and cl !=0. If H^4_Q is one-dimensional, h^2 already spans it, so cl is surjective. This does not say a primitive-projected map can never vanish.

The integer parity obstruction EvenOddGadget.lean 38-55 also disappears over Q: any y is 2*(y/2). BoundaryChecks.lean typechecks rational surjectivity and the nonzero-cycle one-dimensional-target result.

Important remaining semantic defect: GeometricHost.lean 29-47 has a string host and arbitrary C independent of that host. Its ClayDisproof at 82-84 can be inhabited with X=P4 label, CH=H2k=Q, cl=0, hdg=top, gamma=1. GeometricInterfaceDiagnostic.lean contains the exact three source files (Basic, Disproof, GeometricHost, imports consolidated) plus this explicit inhabitant. It is an interface regression diagnostic, not a mathematical counterexample. Corrected predicates in other modules still require an independently interpreted geometric realization.

Actual missing geometric target: a genuine smooth projective X/C, actual CH^2(X)_Q and H^4_B(X,Q), comparison identifying a rational (2,2) class gamma, actual cycle-class compatibility, and proof gamma outside the image of ALL algebraic surfaces, not just a displayed finite candidate list. No such X,gamma or missing-cycle proof was found in the inspected source. A valid formal specification must bind the data to the actual X, not an arbitrary map with a string label.

Named hosts P4, P2xP2, Q4 have algebraic bases of H4: respectively h^2; a^2,ab,b^2; two families of maximal planes. They are not counterexample candidates to rational Hodge.

All diagnostic results are standard algebraic checks / semantic regressions; none resolves the general open PDE or Hodge problem. No PR, tag, release, merge, publication, or deletion performed.

## Validation results
BoundaryChecks.lean: Lean 4.16.0, exit 0, all four named diagnostic lemmas print only propext/Classical.choice/Quot.sound. Current StatementB.lean and DirectionAlignment.lean compared byte-for-byte to imported cached source.
GeometricInterfaceDiagnostic.lean: repository-matching Lean 4.22.0 / HODGE mathlib cache, exit 0. The exact three pinned source files have only their import lines consolidated under import Mathlib; explicit labelOnly_ClayDisproof prints only propext/Classical.choice/Quot.sound. No sorry/axiom was added. Initial unannotated numeral failed elaboration; final explicit rational annotation passes. These diagnostics establish source semantics, not geometric truth.
