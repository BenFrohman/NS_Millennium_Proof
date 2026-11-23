# Local review: solution-linked Clay implementation

Base: BenFrohman/Clay- main 4f45cecde0e362e7323fee46a1472bb02a9ad506.
PR #7 was confirmed merged before source inspection. No remote write, commit,
push, PR, release, tag, publication, deletion or history rewrite was performed.

## Principal implementation

New module: after/lean/Clay/Depletion/SolutionLinkedVortexLines.lean.
Packet u T binds every observed quantity to actual u and curl u: near-maximal
point, far endpoint, positive-length active curves, actual unit vorticity tangent,
nonzero vorticity along the segment, actual integrated direction divergence,
and measurable moving endpoints/length/observations. Endpoint-integral finiteness
is NOT a field. BKM integrability is NOT a field. No new axiom or sorry was added.

Proved: unit direction norm; actual endpoint nonvanishing on active segments;
zero length forces actual curl to vanish everywhere; actual nonzero vorticity
anywhere forces positive length; actual zero NS solution and its packet pass;
pointwise spatial comparison PLUS separately finite actual endpoint integral
imply BKM finiteness. All old theorem statements/diagnostics are preserved.

The construction explicitly specializes DHY Theorem 1 to NONDEGENERATE segments
at nonzero peak vorticity. This additional restriction is documented rather than
silently advertised as a verbatim formalization of every degenerate paper case.
No moving-line Euler Theorem 2 is transferred to viscous NS.

## Exact unsupplied mathematical work

SpatialBridgeObligation is a genuine smaller spatial goal, but UNPROVED: derive
spatial curl regularity and div(curl u)=0 from NSOn, differentiate log|omega|
along the actual vortex line, and apply FTC to obtain the exponential endpoint
comparison. It contains no temporal BKM integral or regularity conclusion.
The implementation does not claim that merely inhabiting Packet proves a
geometric regularity criterion. Suitable uniform packet bounds and actual
endpoint-time-integral finiteness for arbitrary solutions remain unsupplied.

## Tests actually completed

- Fresh source typecheck: all 16 library modules (root plus 15 submodules) AND
  SolutionLinkedRegression.lean. The full existing AxiomReport passed.
- Final tested certificate-builder invocation freshly repeated those checks:
  17 checked modules, 113 theorem declarations INCLUDING generated projections
  and auxiliaries, 223 declarations, nonstandard axioms 0.
- All 9 dependency HEADs matched exact lake-manifest pins and tracked dependency
  source trees were clean. Lean toolchain/commit version is recorded in bundle.
- New regressions are also invoked in the proposed existing CI workflow.
- Main monograph TeX/PDF synchronized (5 pages); previous archive DOI is labelled
  as a previous archived version, not a new Zenodo publication.
- Forward and reverse binary patch application checks passed.

A full Lake dependency rebuild was NOT claimed locally: complete project source
modules were independently rebuilt against the external pinned cached artifacts.
CI after a future reviewed push must still run lake build and the full audit.

## Reproducibility bundle

verified-certificate.tar.gz contains proof sources, exact toolchain/dependency
pins, per-theorem audit and command/typecheck logs, 17 project .olean artifacts,
dependency-license copies, reproduction instructions and a SHA-256 manifest.
The 59 manifested payload files and serialized tar entries were hash-verified;
all bundled source files were compared byte-for-byte to the final patch snapshot.
It is NOT a standalone independent trusted proof certificate: Lean, pinned
external dependency artifacts and their trust chain remain necessary.
The repository script scripts/build_lean_certificate.py generated this bundle
successfully and rejects existing output directories rather than deleting work.

## Narrow repository hygiene

AUTHORS/README/NOTICE use Frohman, Benjamin Stanley. Existing justified 2026
copyright text and the exact root Apache-2.0 LICENSE are preserved. No relicensing
or third-party ownership assertion; dependency notices are retained/copied.
CITATION.cff already has correct given/family name and Apache-2.0 metadata and
is unchanged. README also fixes its stale differential interpretation of the
integer Riccati declaration and its old classification of free DHY data.

SECURITY.md uses the user-designated sole contact address. GitHub API verified
private vulnerability reporting is DISABLED and issues are enabled; the policy
accurately states this, avoids claiming a private GitHub form is available,
and makes no response-time promise. No security setting was changed.
No licensing conflict requiring a new license choice was found in this bounded
check; this is not a comprehensive legal or dependency-security audit.

## Files for parent review/application

- solution-linked-clay.patch (includes binary monograph PDF)
- verified-certificate.tar.gz
- after/ source snapshot
- clay-axiom-audit.log and certificate-build.log

Apply only on a reviewed new branch, using the user's correct commit identity.
No merge, release, tag or Zenodo action is authorized by this local deliverable.
