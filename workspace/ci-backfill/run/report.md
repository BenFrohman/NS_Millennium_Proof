# CI backfill report
Includes the pre-CI backfill (precI/, Benjamin t593u/t594u Nov 23 2:27-2:28 PM CT): commits that had no runnable workflow are built on ci-backfill/<sha7> = the commit + one signed commit adding the repo's current Lean CI. Those rows say '+CI from <branch>@<head>'. pending = still queued/running. See PROGRESS-precI.md.
Totals: built_with_added_ci=10, fail=75, needed=2642, not-run=464, notrun:no-lean-source=464, orig_cancelled=54, orig_failed=656, orig_in-progress=2, orig_no-run=1930, pass=1, pending=2102

## 3n-plus-c-cycle-census
needed=32, not-run=32, notrun:no-lean-source=32, orig_no-run=32

## AtiyahHirzebruch
needed=10, not-run=10, notrun:no-lean-source=10, orig_no-run=10

## BenFrohman
needed=13, not-run=13, notrun:no-lean-source=13, orig_no-run=13

## BohmIdentities
needed=6, not-run=6, notrun:no-lean-source=6, orig_no-run=6

## ChainAtom-u5v-v6
needed=31, not-run=31, notrun:no-lean-source=31, orig_no-run=31

## Clay-
needed=41, not-run=1, notrun:no-lean-source=1, orig_failed=2, orig_no-run=39, pending=40

## Clay-CD-not-certified
needed=6, not-run=1, notrun:no-lean-source=1, orig_no-run=6, pending=5

## ClosedClaims-Ledger
needed=17, not-run=17, notrun:no-lean-source=17, orig_no-run=17

## CollatzConjecture
built_with_added_ci=1, fail=1, needed=5, not-run=1, notrun:no-lean-source=1, orig_no-run=5, pending=3
- 0e92141 [main:main +CI from main@450b672] FAIL: run 45266575399 Lean certificate failure: ##[error]Process completed with exit code 1. — later fixed at: 22d4939 (main)

## CubicFourfold
fail=2, needed=19, not-run=1, notrun:no-lean-source=1, orig_failed=2, orig_no-run=17, pending=16
- ca98493 [main:main] FAIL: run 45248734745 Kernel certificate failure: error: no default toolchain configured. run `elan default stable` to install & configure the latest Lean 4 stable re — later fixed at: df2ae77 (main)
- f29d0a9 [main:main] FAIL: run 45248907050 Kernel certificate failure: error: no default toolchain configured. run `elan default stable` to install & configure the latest Lean 4 stable re — later fixed at: df2ae77 (main)

## DHL-3-2-implies-liminf-prime-gap-le-6
needed=8, orig_no-run=8, pending=8

## DerivedCategories
needed=59, not-run=4, notrun:no-lean-source=4, orig_failed=3, orig_no-run=56, pending=55

## FJRW-ThreeBlock-F
needed=21, not-run=21, notrun:no-lean-source=21, orig_no-run=21

## FermatPlanes
needed=23, not-run=1, notrun:no-lean-source=1, orig_no-run=23, pending=22

## FermatQuinticHost
needed=13, not-run=2, notrun:no-lean-source=2, orig_no-run=13, pending=11

## FermatQuinticJacobian
needed=5, not-run=1, notrun:no-lean-source=1, orig_no-run=5, pending=4

## Frohman-MixedCorrelators-FJ
needed=51, not-run=51, notrun:no-lean-source=51, orig_no-run=51

## Frohman-S-UnitCorrection
needed=8, not-run=2, notrun:no-lean-source=2, orig_failed=6, orig_no-run=2, pending=6

## HODGE-DISPROOF
fail=2, needed=83, not-run=3, notrun:no-lean-source=3, orig_failed=3, orig_no-run=80, pending=78
- 74cfd88 [main:main] FAIL: run 45252152261 Kernel certificate failure: ##[error]Process completed with exit code 1. | run 45252152124 Selected schema regressions nonstandard axioms: depends on axioms: [Hodge.RealFourfoldSpec.ChowSurfacesQ,
 Hodge.RealFourfoldSpec.IsProjective,
 — later fixed at: not yet fixed on main
- d6d96ef [main:main] FAIL: run 45252306823 Kernel certificate failure: ##[error]Process completed with exit code 1. | run 45252306591 Selected schema regressions nonstandard axioms: depends on axioms: [Hodge.RealFourfoldSpec.ChowSurfacesQ,
 Hodge.RealFourfoldSpec.IsProjective,
 — later fixed at: not yet fixed on main

## HODGE
needed=404, not-run=1, notrun:no-lean-source=1, orig_cancelled=2, orig_failed=341, orig_no-run=61, pending=403

## HodgeDisproof
needed=38, not-run=2, notrun:no-lean-source=2, orig_no-run=38, pending=36

## NS_Millennium_Proof
fail=18, needed=601, not-run=2, notrun:no-lean-source=2, orig_cancelled=23, orig_failed=43, orig_no-run=535, pending=581
- 61afded [PR#41:fix/restore-stated-local-existence] FAIL: run 45242553540 Lean CI failure: error: NS_Millennium_Proof.lean:59:0: axiom audit FAILED: 7 theorem(s) use non-standard axioms | run 45242553540 Lean CI sorry: info: NS_Millennium_Proof/Modules/NS_Equations.lean:3768:0: 'NavierStokes3D.local_existence' depends on axioms: [propext, sorryAx | run 45242553540 Lean CI nonstandard axioms: depends on axioms: [propext, sorryAx, Classical.choice, Quot.sound] — later fixed at: not yet fixed on fix/restore-stated-local-existence
- bfe4215 [PR#41:fix/restore-stated-local-existence] FAIL: run 45242559877 Lean CI failure: error: NS_Millennium_Proof.lean:59:0: axiom audit FAILED: 7 theorem(s) use non-standard axioms | run 45242559877 Lean CI sorry: info: NS_Millennium_Proof/Modules/NS_Equations.lean:3768:0: 'NavierStokes3D.local_existence' depends on axioms: [propext, sorryAx | run 45242559877 Lean CI nonstandard axioms: depends on axioms: [propext, sorryAx, Classical.choice, Quot.sound] — later fixed at: dd98922 (fix/restore-stated-local-existence)
- fc1b384 [PR#41:fix/restore-stated-local-existence] FAIL: run 45244035921 truth-gate failure: ##[error]Process completed with exit code 1. | run 45244035921 truth-gate sorry: info: NS_Millennium_Proof/Modules/NS_Equations.lean:3764:0: 'NavierStokes3D.local_existence' depends on axioms: [propext, sorr | run 45244035921 truth-gate nonstandard axioms: depends on axioms: [propext, sorryAx, Classical.choice, Quot.sound] — later fixed at: dd98922 (fix/restore-stated-local-existence)
- ee053fb [PR#41:fix/restore-stated-local-existence] FAIL: run 45244216427 Lean CI failure: error: NS_Millennium_Proof.lean:59:0: axiom audit FAILED: 7 theorem(s) use non-standard axioms | run 45244216427 Lean CI sorry: info: NS_Millennium_Proof/Modules/NS_Equations.lean:3764:0: 'NavierStokes3D.local_existence' depends on axioms: [propext, sorryAx | run 45244216427 Lean CI nonstandard axioms: depends on axioms: [propext, sorryAx, Classical.choice, Quot.sound] — later fixed at: dd98922 (fix/restore-stated-local-existence)
- bd45e80 [PR#41:fix/restore-stated-local-existence] FAIL: run 45245166738 Kernel certificate failure: error: NS_Millennium_Proof.lean:59:0: axiom audit FAILED: 3 theorem(s) use non-standard axioms | run 45245166738 Kernel certificate sorry: info: NS_Millennium_Proof/Modules/NS_Equations.lean:3764:0: 'NavierStokes3D.local_existence' depends on axioms: [prope | run 45245166738 Kernel certificate nonstandard axioms: depends on axioms: [propext, sorryAx, Classical.choice, Quot.sound] — later fixed at: dd98922 (fix/restore-stated-local-existence)
- a97f91b [PR#41:fix/restore-stated-local-existence] FAIL: run 45246317261 truth-gate failure: ##[error]Process completed with exit code 1. | run 45246317261 truth-gate sorry: info: NS_Millennium_Proof/Modules/NS_Equations.lean:3764:0: 'NavierStokes3D.local_existence' depends on axioms: [propext, sorr | run 45246317261 truth-gate nonstandard axioms: depends on axioms: [propext, sorryAx, Classical.choice, Quot.sound] — later fixed at: dd98922 (fix/restore-stated-local-existence)
- c989743 [PR#41:fix/restore-stated-local-existence] FAIL: run 45246494970 Kernel certificate failure: error: NS_Millennium_Proof/Modules/TetheredLyapunov.lean:1966:4: Unknown identifier `local_existence_of_witness` | run 45246494970 Kernel certificate sorry: info: NS_Millennium_Proof/Modules/TetheredLyapunov.lean:2326:0: 'TetheredLyapunov.conditional_regularity_of_bkmIntegra | run 45246494970 Kernel certificate nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] — later fixed at: dd98922 (fix/restore-stated-local-existence)
- 6f32cce [PR#41:fix/restore-stated-local-existence] FAIL: run 45246703057 Lean CI failure: error: NS_Millennium_Proof/Modules/ClosureBlueprint.lean:108:2: Unknown identifier `NavierStokes3D.local_existence_of_witness` | run 45246703057 Lean CI nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] | run 45246703063 Kernel certificate failure: error: NS_Millennium_Proof/Modules/ClosureBlueprint.lean:108:2: Unknown identifier `NavierStokes3D.local_existence_o — later fixed at: dd98922 (fix/restore-stated-local-existence)
- 46f136d [PR#41:fix/restore-stated-local-existence] FAIL: run 45246860453 Kernel certificate failure: error: NS_Millennium_Proof/Modules/ClosureBlueprint.lean:108:2: Unknown identifier `NavierStokes3D.local_existence_o | run 45246860453 Kernel certificate nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] | run 45246860262 Lean CI failure: error: NS_Millennium_Proof/Modules/ClosureBlueprint.lean:108:2: Unknown identifier `NavierStokes3D.local_existence_of_witness` — later fixed at: dd98922 (fix/restore-stated-local-existence)
- f28622f [main:main] FAIL: run 45247226343 Kernel certificate nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] | run 45247226406 Lean CI sorry: STRICT AUDIT PASS: only propext, Classical.choice, Quot.sound; no sorryAx; no axiom declarations | run 45247226406 Lean CI nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] — later fixed at: dd98922 (main)
- 4415cdc [main:main] FAIL: run 45247572254 Kernel certificate failure: error: NS_Millennium_Proof/Modules/ConditionalRegularity.lean:171:69: Application type mismatch: The argument | run 45247572254 Kernel certificate sorry: info: NS_Millennium_Proof/Modules/ConditionalRegularity.lean:395:0: 'ConditionalRegularity.frohmanian_tether_theorem'  | run 45247572254 Kernel certificate nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] — later fixed at: 2d80b70 (main)
- fb73043 [main:main] FAIL: run 45247750872 Kernel certificate failure: error: NS_Millennium_Proof/Modules/ConditionalRegularity.lean:171:69: Application type mismatch: The argument | run 45247750872 Kernel certificate sorry: info: NS_Millennium_Proof/Modules/ConditionalRegularity.lean:395:0: 'ConditionalRegularity.frohmanian_tether_theorem'  | run 45247750872 Kernel certificate nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] — later fixed at: 2d80b70 (main)
- 365dc7e [main:main] FAIL: run 45248066656 Kernel certificate failure: error: NS_Millennium_Proof/Modules/TorusStrainExclusion.lean:61:10: Ambiguous term | run 45248066656 Kernel certificate nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] | run 45248067119 Lean CI failure: error: NS_Millennium_Proof/Modules/TorusStrainExclusion.lean:61:10: Ambiguous term — later fixed at: 2d80b70 (main)
- b8800d1 [main:main] FAIL: run 45248230914 Kernel certificate failure: error: NS_Millennium_Proof/Modules/TorusStrainExclusion.lean:61:10: Ambiguous term | run 45248230914 Kernel certificate nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] | run 45248230929 Lean CI failure: error: NS_Millennium_Proof/Modules/TorusStrainExclusion.lean:61:10: Ambiguous term — later fixed at: 2d80b70 (main)
- c0774d6 [main:main] FAIL: run 45248580193 Kernel certificate nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] | run 45248580706 Lean CI sorry: STRICT AUDIT PASS: only propext, Classical.choice, Quot.sound; no sorryAx; no axiom declarations | run 45248580706 Lean CI nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] — later fixed at: 2d80b70 (main)
- c7946dd [main:main] FAIL: run 45248913358 Lean CI sorry: STRICT AUDIT PASS: only propext, Classical.choice, Quot.sound; no sorryAx; no axiom declarations | run 45248913358 Lean CI nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] | run 45248913401 Kernel certificate failure: ##[error]Process completed with exit code 1. — later fixed at: 2d80b70 (main)
- 85b2c53 [main:main] FAIL: run 45250571022 Lean CI sorry: STRICT AUDIT PASS: only propext, Classical.choice, Quot.sound; no sorryAx; no axiom declarations | run 45250571022 Lean CI nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] | run 45250721999 truth-gate nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] — later fixed at: 2d80b70 (main)
- cd9792a [main:main] FAIL: run 45259232272 Lean CI sorry: STRICT AUDIT PASS: only propext, Classical.choice, Quot.sound; no sorryAx; no axiom declarations | run 45259232272 Lean CI nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] | run 45259383996 truth-gate nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] — later fixed at: 5159934 (main)

## NS_Tether_Alternatives
built_with_added_ci=1, fail=3, needed=15, not-run=3, notrun:no-lean-source=3, orig_cancelled=1, orig_failed=1, orig_no-run=13, pending=9
- 977b7e8 [main:main] FAIL: run 45249114157 Lean CI sorry: STRICT AUDIT PASS: only propext, Classical.choice, Quot.sound; no sorryAx; no axiom declarations | run 45249114157 Lean CI nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] | run 45249114374 Kernel certificate failure: ##[error]Process completed with exit code 1. — later fixed at: not yet fixed on main
- 03c8214 [main:main] FAIL: run 45250562893 Lean CI sorry: STRICT AUDIT PASS: only propext, Classical.choice, Quot.sound; no sorryAx; no axiom declarations | run 45250562893 Lean CI nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] | skip/exclusion in Lean/sorry/axiom check: .github/workflows/lean.yml:64:          if grep -v '^STRICT AUDIT PASS' strict-axiom-audit.txt | grep -qE 'STRICT AUDI — later fixed at: not yet fixed on main
- aff5016 [main:main +CI from main@58c82b9 (substituted lean-toolchain,lake-manifest.json,lakefile.lean)] FAIL: run 45265895035 Lean CI failure: error: NonSymmetric/NonSymmetricTether.lean:21:27: Application type mismatch: The argument | run 45265895035 Lean CI nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] | run 45265895041 Kernel certificate failure: error: NonSymmetric/NonSymmetricTether.lean:21:27: Application type mismatch: The argument — later fixed at: 092852b (main)

## NoetherLefschetz
needed=28, not-run=1, notrun:no-lean-source=1, orig_no-run=28, pending=27

## OmegaZero34
needed=20, orig_cancelled=4, orig_failed=1, orig_no-run=15, pending=20

## PipelineHalt
needed=9, orig_failed=7, orig_no-run=2, pending=9

## RCW-Residuals-Lean
built_with_added_ci=1, fail=12, needed=21, not-run=1, notrun:no-lean-source=1, orig_failed=11, orig_no-run=10, pending=8
- 1bd97c5 [main:main] FAIL: run 45251193416 Kernel certificate failure: error: ././././RCW/EllipticTorsion.lean:109:2: expected type must not contain free or meta variables — later fixed at: 8a55ab0 (main)
- 59c1b58 [main:main] FAIL: run 45251350021 Kernel certificate failure: error: ././././RCW/EllipticTorsion.lean:67:23: expected type must not contain free or meta variables — later fixed at: 8a55ab0 (main)
- c0598f8 [main:main] FAIL: run 45251358108 Kernel certificate failure: error: ././././RCW/EllipticTorsion.lean:25:30: linarith failed to find a contradiction — later fixed at: 8a55ab0 (main)
- c9de54b [main:main] FAIL: run 45251505409 Kernel certificate failure: error: ././././RCW/EllipticTorsion.lean:24:4: linarith failed to find a contradiction — later fixed at: 8a55ab0 (main)
- 0afcf7c [main:main] FAIL: run 45251668983 Kernel certificate failure: error: ././././RCW/EllipticTorsion.lean:26:2: tactic 'cases' failed, nested error: — later fixed at: 8a55ab0 (main)
- bf15346 [main:main] FAIL: run 45251676293 Kernel certificate failure: error: ././././RCW/EllipticTorsion.lean:27:2: omega could not prove the goal: — later fixed at: 8a55ab0 (main)
- d4f00da [main:main] FAIL: run 45251685544 Kernel certificate failure: error: ././././RCW/EllipticTorsion.lean:25:2: omega could not prove the goal: — later fixed at: 8a55ab0 (main)
- e46ede8 [main:main] FAIL: run 45251834984 Kernel certificate failure: error: ././././RCW/EllipticTorsion.lean:25:2: omega could not prove the goal: — later fixed at: 8a55ab0 (main)
- adb2d23 [main:main] FAIL: run 45251981822 Kernel certificate failure: error: ././././RCW/EllipticTorsion.lean:26:2: tactic 'cases' failed, nested error: — later fixed at: 8a55ab0 (main)
- b2291da [main:main] FAIL: run 45252139156 Kernel certificate failure: error: ././././RCW/EllipticTorsion.lean:30:2: tactic 'cases' failed, nested error: — later fixed at: 8a55ab0 (main)
- 3424a56 [main:main] FAIL: run 45252144527 Kernel certificate failure: ##[error]Process completed with exit code 1. — later fixed at: 8a55ab0 (main)
- 4221808 [main:main +CI from main@e97f2ec] FAIL: run 45266520575 Lean header failure: ##[error]Process completed with exit code 1. — later fixed at: c4fc0b7 (main)

## RCW-Version15-Certificates
built_with_added_ci=1, fail=1, needed=5, not-run=2, notrun:no-lean-source=2, orig_failed=2, orig_no-run=3, pending=2
- 6d0bd7a [main:main +CI from main@5501dde] FAIL: run 45266721262 Lean header failure: ##[error]Process completed with exit code 1. | run 45266721412 Kernel certificate failure: error: no such file or directory (error code: 2) — later fixed at: cfffb11 (main)

## RecurringAlignment
needed=5, not-run=5, notrun:no-lean-source=5, orig_failed=3, orig_no-run=2

## SingularityLab
needed=91, not-run=12, notrun:no-lean-source=12, orig_no-run=91, pending=79

## StandardConjectures
needed=8, not-run=1, notrun:no-lean-source=1, orig_no-run=8, pending=7

## TFFrohmanianTether
built_with_added_ci=1, fail=6, needed=8, not-run=1, notrun:no-lean-source=1, orig_cancelled=1, orig_failed=4, orig_no-run=3, pending=1
- 7038e3a [main:main] FAIL: run 45249258856 Kernel certificate failure: error: TFFrohmanianTether/Direction.lean:75:25: Function expected at | run 45249258026 Lean CI failure: error: TFFrohmanianTether/Direction.lean:75:25: Function expected at | run 45249257952 Lean header failure: ##[error]Process completed with exit code 1. — later fixed at: not yet fixed on main
- 037492f [main:main] FAIL: run 45249867107 Lean CI failure: error: TFFrohmanianTether/Direction.lean:75:25: Function expected at — later fixed at: not yet fixed on main
- 174b9c6 [main:main] FAIL: run 45252460756 Lean CI failure: error: TFFrohmanianTether/Direction.lean:75:25: Function expected at — later fixed at: not yet fixed on main
- 394cd9a [main:main] FAIL: run 45252615548 Lean CI failure: error: no such file or directory (error code: 4294967294) — later fixed at: not yet fixed on main
- 81f7f34 [main:main] FAIL: run 45252780923 Lean CI failure: error: no such file or directory (error code: 4294967294) — later fixed at: not yet fixed on main
- 9ecf156 [main:main +CI from main@b3e4e8d] FAIL: run 45262291178 Kernel certificate failure: error: dependency 'plausible' of 'mathlib' not in manifest; this suggests that the manifest is corrupt; use `lake up | run 45262290851 Lean header failure: ##[error]Process completed with exit code 1. | run 45262290909 Lean CI failure: error: dependency 'plausible' of 'mathlib' not in manifest; this suggests that the manifest is corrupt; use `lake update` to ge — later fixed at: not yet fixed on main

## TateConjecture
needed=11, not-run=1, notrun:no-lean-source=1, orig_no-run=11, pending=10

## TateLedger
needed=10, not-run=10, notrun:no-lean-source=10, orig_no-run=10

## Test-Practice-Repo
fail=2, needed=5, not-run=1, notrun:no-lean-source=1, orig_failed=2, orig_no-run=3, pending=2
- b4001a7 [main:main] FAIL: run 45247046556 Kernel certificate startup_failure: None — later fixed at: not yet fixed on main
- f4a8cbb [main:main] FAIL: run 45247889503 Kernel certificate startup_failure: None — later fixed at: not yet fixed on main

## ThreeChainJacobian
needed=11, not-run=11, notrun:no-lean-source=11, orig_no-run=11

## agentic-dev
needed=4, not-run=4, notrun:no-lean-source=4, orig_no-run=4

## amm-flash-loan-symplectic-guard
needed=4, not-run=4, notrun:no-lean-source=4, orig_no-run=4

## bohm-identities
needed=11, not-run=1, notrun:no-lean-source=1, orig_no-run=11, pending=10

## collatz-covering-claim
needed=8, not-run=1, notrun:no-lean-source=1, orig_no-run=8, pending=7

## collatz-teaming-lemma
needed=105, not-run=1, notrun:no-lean-source=1, orig_failed=50, orig_no-run=55, pending=104

## collatz-terras-density
needed=9, not-run=1, notrun:no-lean-source=1, orig_failed=1, orig_no-run=8, pending=8

## collatz-tmap-census-2026
needed=4, not-run=4, notrun:no-lean-source=4, orig_no-run=4

## collatz-tmap-census
needed=6, not-run=6, notrun:no-lean-source=6, orig_no-run=6

## displacement-without-redundancy
needed=12, not-run=12, notrun:no-lean-source=12, orig_no-run=12

## eth-conflict-clause-lattice
needed=8, orig_failed=3, orig_no-run=5, pending=8

## fefferman-clay-navier-stokes
needed=20, orig_failed=1, orig_no-run=19, pending=20

## fourfold-structural-template
needed=8, not-run=8, notrun:no-lean-source=8, orig_no-run=8

## frohman-V13
needed=4, not-run=4, notrun:no-lean-source=4, orig_no-run=4

## frohman-symplectic-qec-codes
needed=4, not-run=4, notrun:no-lean-source=4, orig_no-run=4

## frohmanian-ns-symplectic-tether
needed=10, not-run=10, notrun:no-lean-source=10, orig_no-run=10

## frohmanian-strain-eigenvalue
fail=1, needed=7, orig_failed=7, pending=6
- 0a7dad4 [main:main] FAIL: run 45249488755 Kernel certificate failure: ##[error]Process completed with exit code 1. | skip/exclusion in Lean/sorry/axiom check: scripts/kernel_check.sh:44:if printf '%s\n' "$out" | grep -v sorryAx | grep -qiE 'error:'; then — later fixed at: d9cee76 (main)

## frohmanian-symplectic-tether-may-form
fail=3, needed=42, not-run=6, notrun:no-lean-source=6, orig_failed=6, orig_no-run=36, pending=33
- f5f04ba [main:fresh-public] FAIL: run 45257564938 truth-gate failure: ##[error]see the TRUTH GATE VERDICT block in this log | skip/exclusion in Lean/sorry/axiom check: scripts/tests/test_truth_gate_classify.py:164:            write(d, "sorry.txt", "sorry in build outside draft dirs: wa — later fixed at: not yet fixed on fresh-public
- 9fb2b86 [main:fresh-public] FAIL: run 45265783019 truth-gate failure: ##[error]see the TRUTH GATE VERDICT block in this log | skip/exclusion in Lean/sorry/axiom check: scripts/tests/test_truth_gate_classify.py:164:            write(d, "sorry.txt", "sorry in build outside draft dirs: wa — later fixed at: not yet fixed on fresh-public
- 6558fc9 [main:fresh-public] FAIL: run 45269112825 truth-gate failure: ##[error]see the TRUTH GATE VERDICT block in this log | skip/exclusion in Lean/sorry/axiom check: scripts/tests/test_truth_gate_classify.py:164:            write(d, "sorry.txt", "sorry in build outside draft dirs: wa — later fixed at: not yet fixed on fresh-public

## frohmanian-symplectic-tether-regularity
fail=2, needed=51, orig_cancelled=2, orig_failed=5, orig_no-run=44, pending=49
- d6fa547 [main:main] FAIL: run 45253264930 Lean certificate nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] | run 45253264876 Kernel certificate nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] | run 45253402675 truth-gate failure: ##[error]see the TRUTH GATE VERDICT block in this log — later fixed at: not yet fixed on main
- 4e4db8f [main:main] FAIL: run 45265622568 Lean certificate nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] | run 45265622440 Kernel certificate nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] | run 45265798466 truth-gate failure: ##[error]see the TRUTH GATE VERDICT block in this log — later fixed at: not yet fixed on main

## frohmanian-symplectic-tether
fail=2, needed=9, orig_cancelled=1, orig_failed=5, orig_no-run=3, pending=7
- 33b0df1 [main:main] FAIL: run 45254564266 truth-gate failure: ##[error]see the TRUTH GATE VERDICT block in this log | skip/exclusion in Lean/sorry/axiom check: scripts/tests/test_truth_gate_classify.py:164:            write(d, "sorry.txt", "sorry in build outside draft dirs: wa — later fixed at: not yet fixed on main
- ee52bf5 [main:main] FAIL: run 45269099842 truth-gate failure: ##[error]see the TRUTH GATE VERDICT block in this log | skip/exclusion in Lean/sorry/axiom check: scripts/tests/test_truth_gate_classify.py:164:            write(d, "sorry.txt", "sorry in build outside draft dirs: wa — later fixed at: not yet fixed on main

## frohmanian-tether-conditional-regularity
fail=1, needed=9, not-run=1, notrun:no-lean-source=1, orig_failed=3, orig_in-progress=1, orig_no-run=5, pending=7
- 81b5e7f [main:main] FAIL: run 45249685258 Kernel certificate failure: ##[error]Process completed with exit code 1. | run 45249685137 Lean build and kernel check sorry: STRICT AUDIT PASS: only propext, Classical.choice, Quot.sound; no sorryAx; no axiom declarations | skip/exclusion in Lean/sorry/axiom check: .github/workflows/lean.yml:67:            --exclude FrohmanianTetherConditional/ClassicalNSOpenTarget.lean \ — later fixed at: not yet fixed on main

## frohmanian-tether-discrete-scaling-proximity
needed=9, not-run=9, notrun:no-lean-source=9, orig_no-run=9

## frohmanian-tether-early-may-2026-snapshot
built_with_added_ci=1, fail=1, needed=3, not-run=1, notrun:no-lean-source=1, orig_no-run=3, pending=1
- ebcd333 [main:main +CI from main@cff5e11] FAIL: run 45265746002 Lean header failure: ##[error]Process completed with exit code 1. — later fixed at: f289aa2 (main)

## frohmanian-tether-geometric
built_with_added_ci=1, fail=1, needed=25, orig_cancelled=1, orig_failed=1, orig_no-run=23, pending=24
- ac27181 [main:gateaux-pairing +CI from gateaux-pairing@96c4f7b] FAIL: run 45269112477 Lean header failure: ##[error]Process completed with exit code 1. | run 45269113386 Kernel certificate nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] | run 45269112165 Lean build and axiom audit sorry: STRICT AUDIT PASS: only propext, Classical.choice, Quot.sound; no sorryAx; no axiom declarations — later fixed at: a8286b6 (gateaux-pairing)

## frohmanian-tether-manuscript-2026-06-01
fail=2, needed=16, not-run=6, notrun:no-lean-source=6, orig_cancelled=1, orig_failed=9, orig_no-run=6, pending=8
- 075c217 [main:main] FAIL: run 45258322273 lean sorry: STRICT AUDIT PASS: only propext, Classical.choice, Quot.sound; no sorryAx; no axiom declarations | run 45258462443 truth-gate failure: ##[error]see the TRUTH GATE VERDICT block in this log | skip/exclusion in Lean/sorry/axiom check: .github/workflows/lean.yml:30:          if grep -v '^STRICT AUDIT PASS' strict-audit.txt | grep -qE 'STRICT AUDIT FAIL — later fixed at: not yet fixed on main
- 0243ed0 [main:main] FAIL: run 45266109786 lean sorry: STRICT AUDIT PASS: only propext, Classical.choice, Quot.sound; no sorryAx; no axiom declarations | run 45266253821 truth-gate failure: ##[error]see the TRUTH GATE VERDICT block in this log | skip/exclusion in Lean/sorry/axiom check: .github/workflows/lean.yml:30:          if grep -v '^STRICT AUDIT PASS' strict-audit.txt | grep -qE 'STRICT AUDIT FAIL — later fixed at: not yet fixed on main

## frohmanian-tether-sdiff
fail=4, needed=45, orig_cancelled=14, orig_failed=11, orig_in-progress=1, orig_no-run=19, pending=41
- fc19f22 [main:main] FAIL: run 45252787784 Kernel certificate failure: ##[error]Process completed with exit code 1. | run 45252787784 Kernel certificate sorry: check_build_log: read all 1823 lines of cert-out/build.log, cert-out/build-scratch.log: no sorry, sorryAx, ofReduceBoo | run 45252787784 Kernel certificate nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] — later fixed at: c3a9160 (main)
- 49c15fb [main:main] FAIL: run 45253981908 Lean certificate sorry: check_build_log: read all 1823 lines of cert-bundle/lake-build.log, cert-bundle/lake-build-scratch.log: no sorry, sorryA | run 45253981908 Lean certificate nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] | run 45253981810 Kernel certificate failure: ##[error]Process completed with exit code 1. — later fixed at: c3a9160 (main)
- c86c09d [main:main] FAIL: run 45257082056 Lean certificate sorry: check_build_log: read all 1823 lines of cert-bundle/lake-build.log, cert-bundle/lake-build-scratch.log: no sorry, sorryA | run 45257082056 Lean certificate nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] | run 45257082009 Kernel certificate failure: ##[error]Process completed with exit code 1. — later fixed at: c3a9160 (main)
- 641b033 [main:main] FAIL: run 45266637891 Lean 4 nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] | run 45266471919 Lean certificate sorry: AUDIT PASS: only propext, Classical.choice, Quot.sound; no sorryAx; no axiom declarations | run 45266471919 Lean certificate nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] — later fixed at: e45b2de (main)

## frohmanian-tether-verified
fail=2, needed=14, orig_failed=9, orig_no-run=5, pending=12
- fb6d57f [main:main] FAIL: run 45252962175 Lean sorry: STRICT AUDIT PASS: only propext, Classical.choice, Quot.sound; no sorryAx; no axiom declarations | run 45252962175 Lean nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] | run 45252962208 Kernel certificate nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] — later fixed at: not yet fixed on main
- d7be7d7 [main:main] FAIL: run 45266467177 Lean sorry: STRICT AUDIT PASS: only propext, Classical.choice, Quot.sound; no sorryAx; no axiom declarations | run 45266467177 Lean nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] | run 45266467312 Kernel certificate nonstandard axioms: depends on axioms: [propext, choice, Quot.sound] — later fixed at: not yet fixed on main

## functional-equation-tether-b4
needed=3, not-run=3, notrun:no-lean-source=3, orig_no-run=3

## global-from-local-restart
needed=11, not-run=2, notrun:no-lean-source=2, orig_no-run=11, pending=9

## hlex-latent-exchange-fabric
needed=2, not-run=2, notrun:no-lean-source=2, orig_no-run=2

## intelligence-partial-order-and-formalization-audits
needed=2, not-run=2, notrun:no-lean-source=2, orig_no-run=2

## local-hodge-lean-variants-2026
built_with_added_ci=1, fail=1, needed=7, not-run=1, notrun:no-lean-source=1, orig_no-run=7, pending=5
- f3ae677 [main:main +CI from main@08b1700] FAIL: run 45268912968 Lean header failure: ##[error]Process completed with exit code 1. — later fixed at: 08b1700 (main)

## metriplectic-world-model
needed=38, orig_failed=2, orig_no-run=36, pending=38

## mk1-kernel-limits
needed=1, orig_failed=1, pending=1

## mk1-quantum-kernel
needed=2, orig_failed=2, pending=2

## modular-forms-totient-jumps
needed=3, not-run=3, notrun:no-lean-source=3, orig_no-run=3

## modular-robotic-excitation-arms
needed=6, not-run=6, notrun:no-lean-source=6, orig_no-run=6

## ns-i11-conditional-criterion
needed=10, not-run=10, notrun:no-lean-source=10, orig_no-run=10

## ns-tether-key-estimate-refutation
needed=8, orig_failed=1, orig_no-run=7, pending=8

## orlov-equivalence-VF
needed=8, not-run=2, notrun:no-lean-source=2, orig_no-run=8, pending=6

## overemployed-job-bot
needed=35, not-run=32, notrun:no-lean-source=32, orig_failed=29, orig_no-run=6, pending=3

## p2q-jumps-lean
fail=2, needed=69, not-run=1, notrun:no-lean-source=1, orig_failed=56, orig_no-run=13, pending=66
- c34cc37 [main:main] FAIL: run 45259545644 Lean certificate failure: None | run 45259691969 truth-gate failure: ##[error]Process completed with exit code 2. — later fixed at: 24b5aec (main)
- 85a91d1 [main:main] FAIL: run 44060690152 truth-gate failure: 2026-11-17T10:00:03.4795073Z ##[error]Process completed with exit code 2. — later fixed at: e2903cb (main)

## periodic-navier-stokes-smooth-uniqueness
built_with_added_ci=1, fail=1, needed=1, orig_no-run=1
- aaabf41 [main:main +CI from main@096c913] FAIL: run 45269105337 Kernel certificate failure: curl: (22) The requested URL returned error: 503 | run 45269105339 Lean header failure: ##[error]Process completed with exit code 1. — later fixed at: de92662 (main)

## periodic-ns-classical-continuation
fail=2, needed=100, orig_failed=6, orig_no-run=94, pending=98
- b5154f3 [main:main] FAIL: run 45253099495 Lean sorry: ===== build/4_No new axiom declarations (sorry is caught as sorryAx by the audit).txt | run 45253110046 truth-gate failure: ##[error]paper_claim reuses PeriodicBKMIntegrability (FeffermanClayNS.PeriodicBKMIntegrability, declared at FeffermanClayNS: | skip/exclusion in Lean/sorry/axiom check: scripts/tests/test_truth_gate_classify.py:164:            write(d, "sorry.txt", "sorry in build outside draft dirs: wa — later fixed at: not yet fixed on main
- 0b37360 [main:main] FAIL: run 45265945290 Lean sorry: ===== build/4_No new axiom declarations (sorry is caught as sorryAx by the audit).txt | run 45265811816 Kernel certificate failure: error: external command 'git' exited with code 128 | run 45265951943 truth-gate failure: ##[error]paper_claim reuses PeriodicBKMIntegrability (FeffermanClayNS.PeriodicBKMIntegrability, declared at FeffermanClayNS: — later fixed at: not yet fixed on main

## poincare-wigner-motion-geometry
needed=3, not-run=3, notrun:no-lean-source=3, orig_no-run=3

## pqc-symplectic-lattice-sieving
needed=4, not-run=4, notrun:no-lean-source=4, orig_no-run=4

## quadratic-residues-lean
built_with_added_ci=1, fail=1, needed=16, not-run=1, notrun:no-lean-source=1, orig_failed=6, orig_no-run=10, pending=14
- 83d81ad [main:main +CI from main@5335407 (substituted lake-manifest.json)] FAIL: run 45268762114 Lean header failure: ##[error]Process completed with exit code 1. | run 45268762185 Kernel certificate failure: error: ././././QuadraticResidues.lean:1:0: unexpected token '/'; expected command | run 45268898255 Lean Build failure: error: ././././QuadraticResidues.lean:1:0: unexpected token '/'; expected command — later fixed at: 2c7c4d3 (main)

## r3-biot-savart-stream
needed=4, orig_no-run=4, pending=4

## sealguard
needed=7, not-run=7, notrun:no-lean-source=7, orig_no-run=7

## sentinel-gate
needed=4, not-run=4, notrun:no-lean-source=4, orig_no-run=4

## symplectic-tether-sim
needed=1, not-run=1, notrun:no-lean-source=1, orig_no-run=1

## symplectohydronamics
needed=12, not-run=11, notrun:no-lean-source=11, orig_failed=1, orig_no-run=11, pending=1

## the-3n-plus-1-machine
needed=19, not-run=19, notrun:no-lean-source=19, orig_no-run=19

## titan-audit
needed=8, orig_failed=1, orig_no-run=7, pending=8

## torus-fourier-ns-lemmas
fail=1, needed=22, orig_cancelled=2, orig_failed=1, orig_no-run=19, pending=21
- 5f4da03 [main:main] FAIL: skip/exclusion in Lean/sorry/axiom check: scripts/tests/test_truth_gate_classify.py:164:            write(d, "sorry.txt", "sorry in build outside draft dirs: wa — later fixed at: 6e92248 (main)

## torus-velocity-tether
needed=6, orig_failed=2, orig_no-run=4, pending=6

## triadic-homogenization-lean
needed=5, orig_no-run=5, pending=5

## two-point-strain-coercivity
needed=11, not-run=11, notrun:no-lean-source=11, orig_no-run=11

## two-point-strain-direction-pairing-2026-11
needed=3, not-run=3, notrun:no-lean-source=3, orig_no-run=3

## uniruled-fourfolds
fail=1, needed=6, orig_failed=2, orig_no-run=4, pending=5
- db2055f [main:main] FAIL: run 45250888127 Kernel certificate failure: ##[error]Process completed with exit code 1. — later fixed at: not yet fixed on main

## weighted-enstrophy-identities
needed=16, orig_cancelled=2, orig_failed=4, orig_no-run=10, pass=1, pending=15

## zucker-cubic-fourfold-lean-skeleton
needed=1, not-run=1, notrun:no-lean-source=1, orig_no-run=1
