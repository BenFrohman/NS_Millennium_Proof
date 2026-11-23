# Reproduce, do not independently trust this bundle

Install the pinned Lean toolchain, obtain the dependency revisions recorded in
sources/lean/lake-manifest.json, then from sources/lean run:

    lake exe cache get
    lake build
    lake env lean AxiomReport.lean
    lake env lean SolutionLinkedRegression.lean

Alternatively run the bundled sources/scripts/build_lean_certificate.py after
fetching the pinned dependency cache. It freshly compiles all project sources
against external pinned cached dependency artifacts and audits their statements.
Compiled project artifacts are included; Lean and all dependency binaries are
not bundled. SHA-256 checks detect changed files, not mathematical meaning,
novelty, security or a Millennium solution. Source/log reproducibility is not
a promise of bit-for-bit identical archives across machines.
