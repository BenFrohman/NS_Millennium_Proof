# Certification log Mon Nov  2 20:32:55 CST 2026
- OmegaZero34: native_decide (59 uses) replaced by decide/norm_num/ext+fin_cases+simp; statements unchanged; audit 147 OK; pushed
- FermatQuinticJacobian: CERTIFIED (3 thms), CI pass, appendix added, release v1.1.0
- HodgeDisproof: CERTIFIED (6 thms), CI pass, appendix added, release v1.1.0
- global-from-local-restart: CERTIFIED (3 thms), appendix, release v1.1.0
- StandardConjectures: CERTIFIED (2 thms), appendix, release v1.1.0
- p2q-jumps-lean: CERTIFIED (4 thms), no paper -> paper/verification_certificate.tex/.pdf, release v1.1.0
- collatz-terras-density: CERTIFIED (9 thms), appendix, release v1.1.0 (verified exists)
- weighted-enstrophy-identities, torus-velocity-tether: secret scan clean, CI pass, made PUBLIC Mon Nov  2 21:27:40 CST 2026
- weighted-enstrophy-identities: CERTIFIED (72), appendix in paper/main.tex, release v1.0.0
- torus-velocity-tether: CERTIFIED (63), no paper -> paper/verification_certificate, release v1.0.0
- r3-biot-savart-stream: audit OK (49), pushed, awaiting CI
- r3-biot-savart-stream: CERTIFIED (49), CI pass, made PUBLIC, no paper -> standalone certificate, release v1.0.0
- torus-fourier-ns-lemmas, fefferman-clay-navier-stokes, collatz-teaming-lemma (92), HODGE (156): audit OK, pushed
## Final batch
- appendices committed+pushed; releases: torus-fourier v1.0.0, fefferman v1.2.0, teaming v1.1.0, HODGE v1.1.0, OmegaZero34 v1.1.0
## Coverage extension (2026-11-03)
- HODGE 34a788d: AxiomPrint+HodgeAttempt in default build; 39 Attempt theorems added (195 audited); FermatPlanes import fix; FermatRecipeScope excluded (doesn't compile + duplicate name). CI 41655477620 pass.
- collatz-teaming-lemma 7f1d7bc: FirstDescent, MissingTerm, ZeroPath in root (107 audited); ParentRule, Scenes(decide +kernel), TerrasDensity standalone audits; ReverseTree already covered; Derived excluded. CI 41655846660 pass.
2026-11-04 batch6: released bohm v1.1.0, FQH v1.1.0, FermatPlanes v1.1.0, eth v1.2.0 (CI green). Clay release held (other agent reserved DOI 23940668). triadic skipped (missing modules).

## frohmanian-tether-sdiff v0.1.1 (2026-11-09)
- Verified commit 36e150e (CI 42610807892 cert, 42610807893 lean); release commit 0722b16 (CI 42611328698, 42611328688), both green.
- Strict audit: 761 decls, 519 thm constants (483 source + 36 auto), std axioms only, 0 violations. No sorry/native_decide/axiom.
- Release https://github.com/BenFrohman/frohmanian-tether-sdiff/releases/tag/v0.1.1 with frohmanian-tether-sdiff-v0.1.1.pdf (20 pp). Zenodo NOT done.

## frohmanian-tether-sdiff: remove KineticEnergyDerivIsVelocity (2026-11-09, branch remove-kinetic-energy-hypothesis, NOT merged/released)
- Refuted in Lean: KineticEnergyDerivative.not_forall_functionalDerivative_kineticEnergy_eq_velocity (+ not_unique_isGateauxRepresentative, not_unique_velocity_representative).
- Deleted KEDIV + C2 theorems (tetherKernel_C2_of_KEDeriv, tetherKernel_degenerates_on_kinetic_energy, tetherKernel_C2_of_identifications), tethered_reproduces_classical_euler, degeneracy_for_mollified_sup_norm_proxy, 3 vacuous unique-repr lemmas; clause (1) of frohmanian_tether_theorem; hδ/C2/no-damping parts of combined_conditional_capstone.
- Commit e84c04f (CI cert 42614959392 green, Lean 4 dispatch 42614969344 green); cert-doc commit c9865f4 (CI 42615497093).
- Audit: 536 thm (496+40), 783 decls, 23 modules, std axioms only. PDF 21 pp (v0.1.2 draft).
- Found (scratch, not committed, /workspace/certify/notes/PhysicalSolutionAtRest.lean): IsPhysicalNSSolution forces d/dt u(0,x)=0, so every KatoLocalWitness has steady data.
