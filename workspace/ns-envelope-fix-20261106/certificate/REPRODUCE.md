# NS envelope correction: local proof/review bundle

Author: Frohman, Benjamin Stanley <frohmanbenjamin@gmail.com>.
Baseline: c98fe859867affeba4508b3e51583cfa6b20087c.
This is a LOCAL tested patch, not a release, published archive or PR.

## Reproduce

Use a fresh directory and the exact Lean toolchain in project/lean-toolchain.
All nine package revisions are pinned by project/lake-manifest.json. Packages and
Lean itself are NOT bundled. On the shared box reuse existing pinned caches;
do not remove work or perform a clean dependency rebuild merely for this bundle.
With dependencies available, run inside project/:

    lake build
    lake env lean scripts/AxiomAudit.lean
    lake env lean scripts/EnvelopeCorrectionAudit.lean
    lake env lean scripts/CertificateAxiomInventory.lean
    python3 scripts/generate_laTeX_lean_relationship.py

On another machine, Lake may need to fetch the pinned dependencies and Mathlib
cache first (`lake exe cache get`). That is a separate dependency installation.
For the new correction addendum, use Tectonic on
`docs/VorticityEnvelopeCorrection.tex`; this run used `tectonic --only-cached
--untrusted`, with no resource download. Earlier manuscript PDFs/Zenodo records
are unchanged. The synchronized source/PDF correction addendum is four pages.

## Checked scope

The full project Lake build passed, as did the full audit, backwards-compatible
API regression, and per-theorem axiom inventory: 497 noninternal project theorem
declarations, no nonstandard transitive axioms. Eight new explicitly named
theorems plus generated auxiliary declarations are included. See the source
correction for exact statements and evidence/ logs for the actual results.
The original envelope definition and all original Stage6 proof bodies are
preserved; the two mirrored modules are synchronized. The patch passed forward
application and reverse-application CHECKS, and its applied sources were compared
byte-for-byte with the tested snapshot. Original source/API compatibility is
checked directly; standard-axiom audits are not semantic correctness tests.

All nine dependency HEADs equal the pins. The reused Mathlib tree has six
pre-existing tracked deletions of scripts/bench/build files, not Lean proof
sources; see dependency-state.json. No dependency edits were repaired/deleted.
This run used pinned cached dependency artifacts, not a clean Mathlib rebuild.

## Mathematical boundary

The actual-u cubic predicate is an additional compact-interval hypothesis, not a
newly proved PDE estimate. Conditional compact/half-open and pointwise-curl
comparisons are proved; the zero trajectory passes. Exponential decay is checked
with data-dependent C=kappa*M0. Fixed coefficients fail for a sufficiently large
amplitude. The explicit PDE single-shear calculation disproves bare direction-
gradient coercivity at every positive maximum, even for a fixed datum, without
disproving the general data-dependent envelope. Vector-field assembly is checked
analytically, NOT newly assembled into the Lean PDE structure in this patch.
A full net-source estimate and one-sided/Dini bridge remain unproved.

## Trust, hashes and notices

MANIFEST.json records each payload file's SHA-256 and byte length. Build artifacts
are supplied for inspection, not as independently trusted proof certificates.
Rebuild Lean sources with the pinned dependencies to reproduce the conditional
statements. No artifact/hash/audit proves a missing PDE premise, the paper's
semantic correctness or mathematical novelty. PDF byte identity across font/
compiler environments is not claimed.

The original project Apache-2.0 LICENSE is preserved in project/. Dependency
license/notice copies retain their authors' terms; this is not relicensing or a
comprehensive legal audit. No remote push, merge, tag, release, deletion, history
rewrite or Zenodo publication was performed.
