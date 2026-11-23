# NS_Tether_Alternatives

Exploratory Lean formalizations and papers for alternative tether designs.

**Author:** Benjamin Stanley Frohman  
**Status:** Experimental. No claim that the Millennium Problem is solved.

## Tracks

1. **A-posteriori route**  
   Estimates moved outside the bracket and applied to solutions of the unmodified classical 3D incompressible Navier–Stokes equations. Geometric layer (symmetric TetherKernel, C2, route-2 canonicity) remains as motivation. Analytic bounds stay named open assumptions until discharged from upstream classical results.

2. **+κ (anti-damping) option**  
   Sign of the correction flipped to +κ. The quadratic form becomes positive-semidefinite. Under the same C2 + symmetry the contribution to ˙M remains identically zero. If the obstruction were removed the term would accelerate growth. Included for completeness of the algebraic picture.

## Clay / blow-up criteria

Any future result that produces a Beale–Kato–Majda-type criterion or a global bound is conditional on the remaining analytic hypotheses. No unconditional regularity theorem is asserted here.

## Authorship

All original mathematics by Benjamin Stanley Frohman. Lean encoding assistance disclosed only in commit messages or PR bodies when used; never as Co-authored-by.

## Status of the Lean files

The Lean files here are schematic drafts. They are **not compiled**: there is no `lakefile` or `lean-toolchain` in this repository, and nothing here is kernel-checked.

- `TrajectoryDistinction.lean` imports `NS_Millennium_Proof.Modules.ArnoldGeometric`, so it only makes sense inside [BenFrohman/NS_Millennium_Proof](https://github.com/BenFrohman/NS_Millennium_Proof). It contains two type definitions and no theorems.
- `NonSymmetric/NonSymmetricTether.lean` defines an experimental non-symmetric kernel. It contains no theorems.
- `non_symmetric/NonSymmetricTether.lean` is a placeholder skeleton. It states its C2 property as an `axiom` (`T_on_H`), not as a proved theorem, and `κ` is not yet bound.

There are 0 `sorry`s, 0 theorems and 1 `axiom` across these files.

## Citation

Cite this work with [`CITATION.cff`](CITATION.cff) (GitHub's "Cite this repository" button). There is no Zenodo record for this repository.

## License and copyright

Licensed under the Apache License, Version 2.0. See [`LICENSE`](LICENSE) and [`NOTICE`](NOTICE).

© 2026 Benjamin Stanley Frohman.
