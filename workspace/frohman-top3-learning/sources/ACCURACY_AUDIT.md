# Accuracy audit (2026-11-05)

## Watermark
Present on every rendered frame (top-right gold “Benjamin Stanley Frohman”). Prior automated review “no watermark” was an OCR miss; crop verification confirms imprint. Corrected render uses larger type + stronger shadow.

## P2Q “1 billion”
No film text ever said “search up to 1 billion.” Plot bound is finite (display up to 200,000). Conjecture 3 openness is labeled separately from the search window. Corrected panel: “Plot = finite search only (not Conj. 3).”

## Theorem 28
Proved in Zenodo PDF 10.5281/zenodo.22727814 (p.13). Lean `p2q-jumps-lean` only defines `Theorem28` and `theorem28_from_paper (h : Theorem28)`; **not** a Lean proof.

## NS Lean claims
`IsPeriodicSmoothSolutionOn` is a real PDE predicate (ContDiff + NS momentum + div-free).  
Proved in-repo (as of local checkout): `periodicEnergyDifferenceEstimate`, `periodicVelocityUniqueness_of_energy`, `periodicBKMHsControl_three`, `periodicBKMCriterion`, `periodicLocalExistence_of_nonneg` (Galerkin route).  
Open: `PeriodicBKMIntegrability`.  
Script corrected to say **formalized classical** results, not new discoveries.

## Tether / metriplectic
`{F,F}_tethered = T(F,F) ≠ 0` verified for his tethered sum.  
Metriplectic label matches his note’s minimal definition (entropy Casimir condition explicitly **not** required).  
Enstrophy vanishing after C2 is **by symmetry of this tether**, not a universal law for all energy-preserving dissipations — script corrected.
