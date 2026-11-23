# Claim → source map (corrected film)

## P2Q
| Script claim | Evidence | Status |
|---|---|---|
| Jump identities φ/σ length 12 | Zenodo 22727814 eq. (1) p.1 | classical setup + his paper |
| Closed shapes / Thm 28: N ≠ rst | PDF Theorem 28 p.13; abstract | **Proved in paper** |
| Lean Theorem28 | `P2qJumps/Statement.lean`: `def Theorem28`; `theorem28_from_paper` takes it as hypothesis | **Not proved in Lean** — statement scaffold only |
| Conjecture 3 open | PDF Conjecture 3 p.2; Lean `def Conjecture3` | open |
| Finite searches find none | PDF §10 Table 1; film plot uses exact φ/σ on p²q ≤ 2·10⁵ (0 both-jumps) | evidence ≠ proof of Conj. 3 |

## Tether
| Script claim | Evidence | Scope limit |
|---|---|---|
| {F,F}_tethered = T(F,F) ≠ 0 | Zenodo 23965512 Prop. 1; Lean `TetheredSelfBracket.lean`; SymPy script | this tethered sum |
| Called metriplectic not Poisson | same note §§2–3: Poisson + symmetric NSD T; **entropy compatibility {S,·}_LP=0 is explicitly not part of his definition** | thin/minimal metriplectic usage |
| Energy nullity ⇒ no enstrophy damping | Zenodo 23971661 abstract: “by symmetry the tether contributes nothing to the enstrophy balance” after C2 | **this Frohmanian tether / velocity-slot kernel**, not all energy-preserving dissipations |
| Rate hypothesis open | named `FrohmanianTetherRate` in 23971661 | open |

## NS Lean formalization
| Script claim | Lean declaration (repo `periodic-ns-classical-continuation`) | What it actually is |
|---|---|---|
| Smooth periodic NS solutions | `FeffermanClayNS.IsPeriodicSmoothSolutionOn` — ContDiffOn + momentum PDE + div-free + IC | **Genuine PDE predicate**, not a trivial wrapper |
| Local existence | `periodicLocalExistence_of_nonneg` → `PeriodicLocalExistence` via Galerkin (`LocalExistenceProof.lean`, `SmoothReconstruction.lean`) | Claimed proved in-repo about that PDE predicate (classical Galerkin route, WIP paper) |
| Energy uniqueness | `periodicEnergyDifferenceEstimate` (`Energy.lean`); `periodicVelocityUniqueness_of_energy` | Analytic L² difference estimate on solution pairs — **proved** |
| H³ / BKM | `periodicBKMHsControl_three`; `periodicBKMCriterion` (`BKMFinal.lean`) | Claimed unconditional theorems; classical BKM content formalized |
| Clay open | `PeriodicBKMIntegrability` open; `clay_B_exact_of_integrability` conditional | correctly open |
| Standard axioms | README / `AxiomAudit.lean` targets propext, Classical.choice, Quot.sound | as claimed by repo audit |

**Correction vs prior film wording:** do not say Benjamin “discovered” BKM/local existence; say he **formalized classical** results. Do not imply Lean proved Thm 28. Do not universalize the enstrophy obstruction.
