<!-- Copyright (c) 2026 Benjamin Stanley Frohman. Licensed under Apache-2.0. -->

# Named open hypotheses, gaps T1–T10, and the current Lean implications

Working notes. **Does not claim the Clay Millennium statement.** Does not derive a bound that would close any named gap.

Author: Benjamin Stanley Frohman (ORCID [0009-0006-7068-3718](https://orcid.org/0009-0006-7068-3718); Independent Researcher, Texas, United States).  
Contact: frohmanbenjamin@gmail.com  
License: Apache License, Version 2.0 (`LICENSE`, `NOTICE`).

This deposit is prepared as a new version of the existing concept [10.5281/zenodo.22835068](https://doi.org/10.5281/zenodo.22835068) (published version [10.5281/zenodo.22835069](https://doi.org/10.5281/zenodo.22835069)).

## Files

1. `main.pdf` — this note (Zenodo preview).
2. `main.tex` — LaTeX source.
3. `00_COVER_Official_Proposed_Theorem.pdf` — the original published PDF of 22835069, included unchanged.
4. `sdiff_AxiomAudit_run43105941627.txt` and `sdiff_print_axioms_run43105941627.txt` — reused CI axiom output for `frohmanian-tether-sdiff` commit `4aba751`.
5. `fefferman_AxiomAudit_v1.5.0.txt` — reused axiom output from Zenodo 10.5281/zenodo.24144846.
6. `NS_CI_audit_excerpt_run43047743968.txt` — reused axiom excerpt from Zenodo 10.5281/zenodo.24144853 (Lean unchanged by the later paper-only commit `aa9d28c`).
7. `README.md`, `LICENSE`, `NOTICE`, `SHA256SUMS`.

## Rebuild this PDF

```bash
tectonic main.tex
```

## Rebuild the cited Lean formalizations

Toolchain: `leanprover/lean4:v4.30.0-rc1`. Mathlib: `0c154d67103f74be3a0f2c509f72ccbf5be9f2a7`. One command in each clone, at the cited commit:

```bash
lake build && lake env lean scripts/AxiomAudit.lean
```

- sdiff: https://github.com/BenFrohman/frohmanian-tether-sdiff/commit/4aba751d2d365faf0cc48c5b46e9aa0113519273
- fefferman: https://github.com/BenFrohman/fefferman-clay-navier-stokes/commit/3512caab49a26abc333c15552ed7644e5bc903a1 (Lean correction of the old two-sided hypothesis: `afaab80`)
- NS_Millennium_Proof: https://github.com/BenFrohman/NS_Millennium_Proof/commit/aa9d28c4969b562113e4f6ac03cdca77eb77dae5
