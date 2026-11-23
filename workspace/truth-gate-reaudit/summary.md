# Truth Gate re-audit — Phase 1 inventory (2026-11-17, CT)

55 non-archived BenFrohman repos contain Lean. 11464 theorem/lemma/def declarations inventoried (Mathlib and .lake excluded); 47 named in a Truth Gate lock; 6691 kernel-verified on HEAD by official CI (`#print axioms`/audit lines in the full logs); 3457 cited by a paper or Zenodo description but unlocked.

Full per-declaration data: inventory.csv. Per-repo counts: counts.csv. Skips: skips.csv. Tally: tally.csv / tally.md.

| repo | HEAD | gate | total | locked | kernel-verified on HEAD | cited but unlocked | CI non-success | sorry in build log |
|---|---|---|---|---|---|---|---|---|
| frohmanian-tether-sdiff | 1ea649e | yes | 3312 | 6 | 2226 | 382 |  |  |
| NS_Millennium_Proof | 58af452 | yes | 1289 | 21 | 551 | 242 |  |  |
| periodic-ns-classical-continuation | 58651f8 | yes | 922 | 1 | 414 | 111 | truth-gate:failure |  |
| HODGE | 52579a0 | yes | 822 | 4 | 695 | 318 |  |  |
| metriplectic-world-model | 0d876af | yes | 696 | 1 | 192 | 93 |  |  |
| frohmanian-tether-verified | cb75617 | yes | 543 | 1 | 190 | 76 | truth-gate:failure |  |
| frohmanian-symplectic-tether-regularity | 2a649d1 | yes | 534 | 2 | 267 | 52 | truth-gate:failure |  |
| frohmanian-tether-geometric | 96c4f7b | no | 490 | 0 | 256 | 98 |  |  |
| p2q-jumps-lean | c34cc37 | yes | 346 | 2 | 0 | 200 | Lean certificate:-;truth-gate:- |  |
| frohmanian-symplectic-tether | b4df79b | yes | 294 | 1 | 286 | 287 | truth-gate:failure |  |
| frohmanian-symplectic-tether-may-form | 606525b | yes | 294 | 1 | 286 | 287 | truth-gate:failure |  |
| fefferman-clay-navier-stokes | febd036 | no | 236 | 0 | 232 | 232 |  |  |
| torus-fourier-ns-lemmas | 7aac989 | yes | 202 | 1 | 201 | 199 |  |  |
| collatz-teaming-lemma | cbc2833 | no | 146 | 0 | 146 | 146 |  |  |
| OmegaZero34 | 2ed7fac | no | 145 | 0 | 143 | 145 |  |  |
| periodic-navier-stokes-smooth-uniqueness | 096c913 | no | 119 | 0 | 22 | 0 |  |  |
| weighted-enstrophy-identities | 5a8442d | yes | 106 | 4 | 85 | 67 |  |  |
| PipelineHalt | f6dde4f | no | 88 | 0 | 19 | 44 |  |  |
| frohmanian-tether-conditional-regularity | 0dc35f3 | no | 86 | 0 | 0 | 30 |  | 44049293092:FrohmanianTetherConditional/ClassicalNSOpenTarget.lean:31:8 |
| HODGE-DISPROOF | 79b1331 | no | 82 | 0 | 0 | 0 |  |  |
| uniruled-fourfolds | b9837ff | no | 74 | 0 | 0 | 0 |  | 43953956904:UniruledFourfolds/Blueprint.lean:68:8 |
| Clay- | 259d54a | no | 69 | 0 | 20 | 37 |  |  |
| eth-conflict-clause-lattice | 77c37f2 | yes | 65 | 1 | 56 | 54 |  |  |
| frohmanian-metriplectic-ns | 9542809 | no | 64 | 0 | 64 | 34 |  |  |
| torus-velocity-tether | a761df7 | no | 61 | 0 | 61 | 61 |  |  |
| r3-biot-savart-stream | 9fa657d | no | 43 | 0 | 43 | 43 |  |  |
| SingularityLab | df90b13 | no | 42 | 0 | 0 | 0 |  |  |
| ns-tether-key-estimate-refutation | 0184b2d | no | 40 | 0 | 40 | 29 |  |  |
| DerivedCategories | e90f335 | no | 36 | 0 | 36 | 36 |  |  |
| frohmanian-strain-eigenvalue | baddc04 | yes | 30 | 1 | 17 | 12 |  |  |
| DHL-3-2-implies-liminf-prime-gap-le-6 | 728c2b0 | no | 26 | 0 | 26 | 25 |  |  |
| triadic-homogenization-lean | 3cae715 | no | 20 | 0 | 0 | 0 |  |  |
| mk1-kernel-limits | 114a45b | no | 17 | 0 | 16 | 16 |  |  |
| FermatPlanes | 6870ed4 | no | 16 | 0 | 16 | 16 |  |  |
| frohmanian-tether-manuscript-2026-06-01 | f3a89f2 | no | 16 | 0 | 10 | 14 | truth-gate:failure |  |
| FermatQuinticHost | 66a67d0 | no | 10 | 0 | 10 | 10 |  |  |
| mk1-quantum-kernel | 2b50cfc | no | 10 | 0 | 10 | 9 |  |  |
| titan-audit | 4b4af1e | no | 10 | 0 | 8 | 3 |  |  |
| collatz-terras-density | 43ff9d4 | no | 9 | 0 | 9 | 9 |  |  |
| quadratic-residues-lean | 5335407 | no | 9 | 0 | 0 | 2 |  |  |
| Clay-CD-not-certified | 8260dce | no | 8 | 0 | 8 | 8 |  |  |
| HodgeDisproof | cedbcc4 | no | 6 | 0 | 6 | 6 |  |  |
| bohm-identities | 444fe64 | no | 5 | 0 | 5 | 5 |  |  |
| NoetherLefschetz | 78f9270 | no | 4 | 0 | 4 | 4 |  |  |
| orlov-equivalence-VF | 6d834f8 | no | 4 | 0 | 4 | 4 |  |  |
| FermatQuinticJacobian | 8daeea4 | no | 3 | 0 | 3 | 3 |  |  |
| local-hodge-lean-variants-2026 | 08b1700 | no | 3 | 0 | 0 | 1 |  |  |
| RCW-Residuals-Lean | 44bc3df | no | 2 | 0 | 0 | 0 |  |  |
| StandardConjectures | 8871c2b | no | 2 | 0 | 2 | 2 |  |  |
| TateConjecture | 178c5e1 | no | 2 | 0 | 2 | 2 |  |  |
| global-from-local-restart | c393312 | no | 2 | 0 | 2 | 2 |  |  |
| CubicFourfold | cf8ac56 | no | 1 | 0 | 0 | 0 |  |  |
| collatz-covering-claim | c1740d1 | no | 1 | 0 | 1 | 1 |  |  |
| frohmanian-tether-early-may-2026-snapshot | cff5e11 | no | 1 | 0 | 0 | 0 |  |  |
| symplectohydronamics | c2a9123 | no | 1 | 0 | 1 | 0 |  |  |

## Repos with no Truth Gate (41)

Clay-, Clay-CD-not-certified, CubicFourfold, DHL-3-2-implies-liminf-prime-gap-le-6, DerivedCategories, FermatPlanes, FermatQuinticHost, FermatQuinticJacobian, HODGE-DISPROOF, HodgeDisproof, NoetherLefschetz, OmegaZero34, PipelineHalt, RCW-Residuals-Lean, SingularityLab, StandardConjectures, TateConjecture, bohm-identities, collatz-covering-claim, collatz-teaming-lemma, collatz-terras-density, fefferman-clay-navier-stokes, frohmanian-metriplectic-ns, frohmanian-tether-conditional-regularity, frohmanian-tether-early-may-2026-snapshot, frohmanian-tether-geometric, frohmanian-tether-manuscript-2026-06-01, global-from-local-restart, local-hodge-lean-variants-2026, mk1-kernel-limits, mk1-quantum-kernel, ns-tether-key-estimate-refutation, orlov-equivalence-VF, periodic-navier-stokes-smooth-uniqueness, quadratic-residues-lean, r3-biot-savart-stream, symplectohydronamics, titan-audit, torus-velocity-tether, triadic-homogenization-lean, uniruled-fourfolds

## Sorry in official HEAD build logs (every line read, no exclusions)

* frohmanian-tether-conditional-regularity run 44049293092: FrohmanianTetherConditional/ClassicalNSOpenTarget.lean:31:8 declaration uses `sorry` (analytic_bridge_unconditional).
* uniruled-fourfolds run 43953956904: UniruledFourfolds/Blueprint.lean:68:8 declaration uses `sorry`.
* All other hits were grep-command echoes or audit PASS lines.

## Systemic defects found

* 12 repos: scripts/verify-lock.sh greps `declaration uses 'sorry'` with straight quotes; Lean prints backticks, so the check can never fire. 3 more repos have the same pattern in workflows.
* 13 repos: draft_dirs carve-outs in verify-lock.sh / truth_gate_check.py; 4 repos: --exclude / STRICT AUDIT EXCLUDED MODULE in check_forbidden_tokens.py / StrictAxiomAudit.lean.
* 478 skip constructs in 47 repos (skips.csv, each with the commit that last wrote the line).
* sdiff kernel-certificate replayed only the 43 FrohmanianTether modules: Scratch (where T1–T11 live) and vendor were silently left out; the Scratch axiom audit covered a hand list of 235 theorems. Fixed in PR #16.
