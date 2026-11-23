<!-- Copyright (c) 2026 Benjamin Stanley Frohman. Licensed under Apache-2.0. -->

# Named open hypotheses, gaps T1–T10, and the current Lean implications (third version)

Working notes. **Does not claim the Clay Millennium statement.** No T-item is closed.

Author: Benjamin Stanley Frohman (ORCID 0009-0006-7068-3718; Independent Researcher, Texas, United States). Contact: frohmanbenjamin@gmail.com. License: Apache-2.0.

Third version of concept 10.5281/zenodo.22835068 (versions 10.5281/zenodo.22835069 and 10.5281/zenodo.24148258).

## Files
- `main.tex` — LaTeX source of `main.pdf` (build: `tectonic main.tex`).
- `00_COVER_Official_Proposed_Theorem.pdf` — the published PDF of 22835069, unchanged.
- `gaps-ledger-axioms.txt` — kernel axiom certificate (42 declarations, standard axioms only).
- `LICENSE`, `NOTICE`.

## Lean
Toolchain `leanprover/lean4:v4.30.0-rc1`, Mathlib `0c154d67103f74be3a0f2c509f72ccbf5be9f2a7`.
- sdiff `0727e6d561ca68678eb909d8b6dd120c4a2a6e15` (PR #8):
  `lake exe cache get && lake build && lake env lean scripts/PrintGapsLedgerAxioms.lean`
- fefferman-clay-navier-stokes `8d8a0cf60b06d111fdee59215797b32e6029eeff`: `bash scripts/verify.sh`
- NS_Millennium_Proof `b8d2f1eaa3e749eb2cb321b629259d199a4fd6b0`: `lake build`
