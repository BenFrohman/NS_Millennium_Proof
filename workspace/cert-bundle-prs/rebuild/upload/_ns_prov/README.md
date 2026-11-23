# NS Millennium Proof concept, version 2.6.0 certificate provenance

This archive accompanies a new version of concept 10.5281/zenodo.23627609,
built from the latest published version 2.5.0 (10.5281/zenodo.24144853)
at commit 6c79135d30fdd03d6b7520d47eec4fefa5ec7f03.

## What is, and is not, a Lean kernel certificate

The Lean CI workflow at that commit (GitHub Actions run 43047743968)
passed, including a real `lake build`. The workflow did not upload a
lake-certificate artifact. There is therefore no raw CI artifact
bundle from that run that contains lake-manifest.json, its sha256,
the toolchain, versions, the build log file, and the #print axioms
output as separate uploaded files.

github-actions-job-log-run43047743968.log is the raw log of that
run, obtained with `gh run view 43047743968 --log`. It is a
GitHub Actions job log, not an uploaded certificate artifact.
The lake-manifest.json and lean-toolchain in this folder are this
repository's own committed files at 6c79135, with sha256.

The file CI_audit_excerpt_run43047743968.txt already on version
2.5.0 is an excerpt, not a raw CI artifact.

## TITAN_AUDIT on version 2.4.0 (10.5281/zenodo.24126051)

Version 2.4.0 of this concept attached TITAN_AUDIT_CERTIFICATE.json.
No lake build ran for that Titan audit file. It is not a Lean
kernel certificate. Version 2.5.0 already removed it. It is not
reintroduced here.

Toolchain: leanprover/lean4:v4.30.0-rc1.
Mathlib revision: 0c154d67103f74be3a0f2c509f72ccbf5be9f2a7.
Run: https://github.com/BenFrohman/NS_Millennium_Proof/actions/runs/43047743968

## Rebuild command

    lake exe cache get && lake build

Commit: 6c79135d30fdd03d6b7520d47eec4fefa5ec7f03
Manifest sha256: b81d814b7d2d2d2821b03ed679324d5e7ec7da674e0a977352d01c88cbe8ccb8
Toolchain: leanprover/lean4:v4.30.0-rc1
Mathlib revision: 0c154d67103f74be3a0f2c509f72ccbf5be9f2a7
Run: https://github.com/BenFrohman/NS_Millennium_Proof/actions/runs/43047743968

The historical workflow did not print elan --version. No elan version
is invented here. See ELAN_VERSION_NOTE.txt.

The excerpt file CI_audit_excerpt_run43047743968.txt from version 2.5.0
is not attached to this version. The full job log is attached instead.
