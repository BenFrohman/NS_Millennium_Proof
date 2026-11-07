#!/usr/bin/env python3
# Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
# Released under Apache 2.0 license as described in the file LICENSE.
# Authors: Frohman, Benjamin Stanley
"""Regenerate the current paper/source mapping without inventing proof status.

The maintained correction supplies the mapping; this script is not a Lean parser
or a proof audit. Kernel checks are the separate Lake/Lean commands below.
"""
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parents[1]
CORRECTION = PROJECT_ROOT / "docs" / "VORTICITY_ENVELOPE_CORRECTION.md"
OUTPUT = PROJECT_ROOT / "LaTeX_Lean_Relationship.md"


def render_markdown() -> str:
    correction = CORRECTION.read_text(encoding="utf-8")
    start = correction.index("## 1. Exact source correction")
    end = correction.index("## 3. Bounded PDE attempt")
    return (
        "# Relationship Between Manuscript and Lean Formalization\n\n"
        "Author: Frohman, Benjamin Stanley\n\n"
        "This mapping describes conditional statements, not an unconditional proof "
        "of Navier–Stokes regularity. The published manuscript PDFs/archives are "
        "unchanged by the source correction.\n\n"
        + correction[start:end]
        + "## Remaining analytic obligations and reproduction\n\n"
        "See [the full correction](docs/VORTICITY_ENVELOPE_CORRECTION.md) for the "
        "explicit shear calculations, failed direction-only coercivity, endpoint "
        "differentiability obstruction, pinned source links and evidence boundary.\n\n"
        "Reproduce with `lake build`, `lake env lean scripts/AxiomAudit.lean`, "
        "`lake env lean scripts/EnvelopeCorrectionAudit.lean` and "
        "`lake env lean scripts/CertificateAxiomInventory.lean`.\n\n"
        "Generated deterministically by `scripts/generate_laTeX_lean_relationship.py` "
        "from the maintained correction. This is a documentation mapping, not "
        "automatic semantic verification or a novelty assessment.\n"
    )


def main() -> None:
    OUTPUT.write_text(render_markdown(), encoding="utf-8")
    print(f"Wrote {OUTPUT}")


if __name__ == "__main__":
    main()
