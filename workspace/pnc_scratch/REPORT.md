# periodic-ns-classical-continuation audit (commit 33e0cbf)

## Build
- Path: /workspace/pnc (clone of github.com/BenFrohman/periodic-ns-classical-continuation @ 33e0cbf)
- `lake build`: SUCCESS, 8369 jobs. Warnings only (unused simp args / unused vars / unused section vars). No errors.
- Packages: Mathlib + FeffermanClayNS@ebcf109 + WeightedEnstrophy@1df4652 + TorusFourierNS@e63af4e (pins match lake-manifest). Shared `.lake/packages` via symlink to prior local clone after disk pressure.
- No GitHub push or remote modification.

## Axiom audit
- `lake env lean AxiomAudit.lean`: **PASS** — 1048 theorems, 285 definitions in `PeriodicNSContinuation`; only `propext`, `Classical.choice`, `Quot.sound`. No `sorryAx`, no custom axioms.
- Source `sorry`: none (only the phrase "0 sorry" in a comment).
- `#print axioms` on headlines: all listed below use only those three.

### Unconditional (standard axioms only)
- `periodicBKMHsControl_three`, `periodicBKMCriterion`
- `periodicHsBlowupAlternative`, `periodicLocalExistence_of_nonneg`
- `Corrected.periodicEnergyDifferenceEstimate`, `Corrected.periodicMaximalSolution_of_uniqueness`
- `Corrected.periodicVelocityUniqueness_of_energy`
- `periodicLowFreqVorticityBound`, `periodicPhysicalCommutatorBound`
- `FeffermanClayNS.periodicGlobalOfTstarTop`

### Conditional reductions (still only standard axioms; hypotheses are ordinary `Prop` args)
- `clay_B_exact_of_integrability (hint : PeriodicBKMIntegrability ν)`
- `clay_B_exact_of_bkm`, `Corrected.clay_B_exact_of_corrected_route'`
- `periodicBKMIntegrability_iff_globalLifespan` and both directions
- `clay_B_exact_of_globalLifespan`

## Modeling (real NS, not abstract structure fields)
From dep `FeffermanClayNS` (pinned):
- `T3 := EuclideanSpace ℝ (Fin 3)` — ℝ³ standing in for 𝕋³ at the type level (`Defs.lean:64`), with `IsZ3Periodic` (`FeffermanStatements.lean:48`).
- Fields: `VelocityField`, `TimeDependentVelocity`, `TimeDependentPressure`, viscosity `ν : ℝ`.
- Operators: `div`, `laplacian`, `convective`, `pressureGradient` (`Defs.lean:110,102,227`).
- Momentum: `navier_stokes_eq_Ici` (`FeffermanStatements.lean:80`):
  \(\partial_t u + (u\cdot\nabla)u = \nu\Delta u - \nabla p + f\) (one-sided time deriv on `[0,\infty)`).
- Solution: `IsPeriodicSmoothSolution` (`FeffermanStatements.lean:103`): ℤ³-periodic smooth `(u,p)`, momentum, `div u=0`, `u(0)=u₀`.
- Statement (B): `Clay_B_exact` (`FeffermanStatements.lean:153`) — f≡0, all smooth div-free periodic data.
- BKM Props: `PeriodicBKMCriterion` / `PeriodicBKMIntegrability` (`HighSetDepletionAndBKM.lean:405,413`) on maximal solutions, integrating `‖ω‖_∞`.
- Energy estimates use unit-cell / `torusIntegral`, not ∫_{ℝ³} (necessary because nonzero periodic fields are not L²(ℝ³)).
- `CurveHyp` is a Fourier-mode helper structure for reconstruction; the Clay/BKM statements quantify over concrete velocity/pressure fields.

## Open input for the headline Clay reduction
- **Only** `PeriodicBKMIntegrability ν` for `clay_B_exact_of_integrability`.
- Proved equivalent to `PeriodicGlobalLifespan ν` (`T*=⊤` for all smooth periodic data) — i.e. exactly the Clay core, not a weaker leftover.
- Side routes take additional open Props (not discharged): e.g. `PeriodicTetherCubicRate`, `PeriodicVorticityAPrioriBound`, `PeriodicDirectionCriterion`+`PeriodicDirectionRegularity`, `PeriodicBendingRateHiddenProperty`, `PeriodicH1BlowupCriterion`, `PeriodicHolderStretchingEstimate`, `PeriodicH2SmoothingRateStd`, `PeriodicH2RootTimeIntegrable`, `PeriodicH3SmoothingRate`, etc.

## README vs reality
- Holds: WIP disclaimer; BKM + H³ control unconditional; Clay reduced to `PeriodicBKMIntegrability`; equivalence to global lifespan; 0 sorry; standard axioms only; Clay not solved.
- Stale/inconsistent bits: older README sections still say local existence is conditional (contradicted by later “proved” sections and by `periodicLocalExistence_of_nonneg`); theorem counts outdated (README ~755/867; now ~907 source theorem/lemma, AxiomAudit 1048 theorem constants); `Route.lean` module docstring still says local existence/BKM “not formalized here” though both are proved and used.
- Modeling caveat README understates: type is ℝ³+periodicity, not a native 𝕋³ manifold type.

## Gaps / next steps for accuracy
1. Refresh README + `Route.lean` docstring so only current status remains (delete stale “still conditional” local-existence claims).
2. Publish a one-page axiom table from `AxiomAudit` / `#print axioms` with commit hash.
3. State the ℝ³+ℤ³ model explicitly next to every Clay claim (cell integrals vs Haar-on-ℝ³).
4. Either formalize one classical remaining Prop on an alternative route (e.g. `PeriodicH1BlowupCriterion`) or mark those routes as “classical citations, not formalized”.
5. Do not claim Clay/NS regularity; keep leading with the conditional reduction + equivalence to `T*=⊤`.
