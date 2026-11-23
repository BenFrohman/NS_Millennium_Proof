# Gaps ledger v4: raw CI materials and honest provenance

This archive replaces the hand-assembled file gaps-ledger-axioms.txt
that was attached to version 3 (10.5281/zenodo.24289291).

A hand-written summary is not a Lean kernel certificate. The final pass,
if any, rests only on the Lean kernel and #print axioms from a real
lake build of that repository's own lake-manifest.json.

## 1. frohmanian-tether-sdiff at 0727e6d (raw CI artifact)

GitHub Actions run 43933623627, workflow "Lean certificate", event
pull_request, head SHA 0727e6d561ca68678eb909d8b6dd120c4a2a6e15,
conclusion success.
https://github.com/BenFrohman/frohmanian-tether-sdiff/actions/runs/43933623627

The uploaded artifact name is axioms-pull_request-43933623627, downloaded
with gh. It contains axioms.txt (full axiom audit, 1886 theorems, 0
violations) and print_axioms.txt (the #print axioms lines). The
lake-manifest.json and lean-toolchain in this folder are this
repository's own committed files at 0727e6d, with sha256, because that
CI artifact did not include them.

## 2. fefferman-clay-navier-stokes at 8d8a0cf (job log only)

GitHub Actions run 43928116535, workflow "Lean certificate", event
push, head SHA 8d8a0cf60b06d111fdee59215797b32e6029eeff, conclusion
success.
https://github.com/BenFrohman/fefferman-clay-navier-stokes/actions/runs/43928116535

No artifact was uploaded by that run. The file
github-actions-job.log is the raw log obtained with
`gh run view 43928116535 --log`. It includes the lake build and
#print axioms lines. The lake-manifest.json and lean-toolchain are
this repository's own committed files at 8d8a0cf, with sha256.

## 3. NS_Millennium_Proof at b8d2f1e (job log only)

GitHub Actions run 43928069777, workflow "Lean CI", event push,
head SHA b8d2f1eaa3e749eb2cb321b629259d199a4fd6b0, conclusion success.
https://github.com/BenFrohman/NS_Millennium_Proof/actions/runs/43928069777

No artifact was uploaded by that run. The previous version's
hand-assembled axioms file said that seven NS_Millennium_Proof
declarations were printed locally; no CI artifact exists for that
local print. The file github-actions-job.log is the raw Lean CI
job log at the cited commit, obtained with
`gh run view 43928069777 --log`. The lake-manifest.json and
lean-toolchain are this repository's own committed files at
b8d2f1e, with sha256.

Toolchain at all three commits: leanprover/lean4:v4.30.0-rc1.
Mathlib revision: 0c154d67103f74be3a0f2c509f72ccbf5be9f2a7.
