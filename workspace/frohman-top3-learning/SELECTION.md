# Top-3 selection (reasoned, subjective)

Criteria: (1) correctness / honesty of claimed scope, (2) nontrivial mathematical or formal substance, (3) reproducibility (paper + code/Lean/tests), (4) usefulness to others. Not world-first rankings. Spectacle and unsolved Clay/quantum-advantage claims were down-weighted.

## Selected

### 1. Simultaneous totient–divisor jumps for n = p²q (Theorem 28 / closed shapes)
- **Primary:** https://doi.org/10.5281/zenodo.22727814 (concept https://doi.org/10.5281/zenodo.22713135), paper v0.10; Lean statement repo https://doi.org/10.5281/zenodo.23905258 / github.com/BenFrohman/p2q-jumps-lean
- **What is his:** proved constraints on the next open family after Roy Choudhury–Wei; Theorem 1 closed shapes; Theorem 28 empties unbalanced triples N = rst; residual shapes reduced to Diophantine conditions; computational survey evidence for Conjecture 3.
- **Not his / classical:** Euler φ and σ; the jump problem setup of Roy Choudhury–Wei; Hardy–Littlewood heuristics (unused).
- **Open:** Conjecture 3 (no p²q solution at all); Hypotheses R2–R3.

### 2. Metriplectic tether obstruction (“holds nothing” / not Poisson)
- **Primary:** https://doi.org/10.5281/zenodo.23971661 (*A Tether That Holds Nothing*); companion terminology note https://doi.org/10.5281/zenodo.23965512; geometric build https://doi.org/10.5281/zenodo.23990195
- **What is his:** designed the Frohmanian tether T; proved (Lean + SymPy) that the tethered sum is metriplectic not Poisson ({F,F}_tethered = T(F,F) ≠ 0); showed energy-nullity (C2) forces vanishing enstrophy contribution — consistency with Euler blocks cubic enstrophy damping.
- **Not his / classical:** Arnold Lie–Poisson fluid geometry; Morrison/Grmela–Öttinger metriplectic framework.
- **Open:** analytic rate hypothesis FrohmanianTetherRate; no Clay claim.

### 3. Classical continuation chain for periodic Navier–Stokes in Lean 4
- **Primary:** https://doi.org/10.5281/zenodo.23986023 (draft companion to build); repo BenFrohman/periodic-ns-classical-continuation
- **What is his:** sorry-free formalization of local theory, energy estimates, H³ BKM control and BKM criterion on T³; explicit reduction of Clay Statement (B) to the single open Prop `PeriodicBKMIntegrability`; axiom audit to standard axioms only.
- **Not his / classical:** Beale–Kato–Majda 1984; Kato–Ponce; the Clay problem statement itself.
- **Open:** PeriodicBKMIntegrability (the Clay core, named as hypothesis).

## Why not other strong candidates
- **MK-1 quantum kernel:** excellent reproducible teaching package, but the ZZ fidelity kernel is the known Havlíček et al. (2019) construction; novelty is packaging/Lean checks, not the algorithm.
- **Hodge “disproof” / counterexample type:** carefully shows types are uninhabited; does not produce a rational Hodge counterexample; Clay Hodge remains open.
- **Titan-Audit / PipelineHalt:** high engineering usefulness; less a mathematical discovery for a 3-minute science film.
- **Collatz drift / covering claims:** valuable negative/structural Collatz work, but narrower audience than the three chosen; overlapping “honest negative result” niche already covered by the tether obstruction.
- **Any global NS regularity / quantum advantage claim:** not selected — sources themselves refuse those claims.

## Accuracy note (post-audit)
See `sources/ACCURACY_AUDIT.md` and updated `CLAIM_SOURCE_MAP.md`. Film file overwritten with corrected narration/captions/visuals; prior encode kept as `films/frohman_top3_learning_v1_preaccuracy.mp4`.
