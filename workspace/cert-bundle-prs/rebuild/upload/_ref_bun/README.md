# Key-estimate refutation v1.2.0 certificate bundle

Lean kernel materials are the raw GitHub Actions verify-logs artifacts
of runs 42916652258 and 42916649801 (byte-identical) at commit 715626e,
together with this repository's own lean/lake-manifest.json and
lean/lean-toolchain at that commit, with sha256
2dcd77f771f6f5080b5b4b83db2f22f66071c37baaf044afbcf9b3b78d305672.
Mathlib revision: 79e94a093aff4a60fb1b1f92d9681e407124c2ca.

lean-kernel/axioms.log and lean-kernel/lake_build.log are the files
from the uploaded verify-logs artifact. lean-kernel/lake_build.log is
the short artifact build log (1.8 KB). The full GitHub Actions job log
of run 42916652258, obtained with `gh run view 42916652258 --log`, is
lean-kernel/github-actions-job-log-run42916652258.log (not the artifact
tail alone).

The historical workflow did not print elan --version. No elan version
is invented here. See ELAN_VERSION_NOTE.txt.

## Outside checks (not Lean kernel certificates)

outside-checks/v2_maxcert.log is an Arb / python-flint interval-arithmetic
numeric check of ||omega_1||_inf = 12. Lean does not certify this maximum.
outside-checks/v1_trig_example.log, v2_symbolic.log and v2_sym.pkl are
Python / sympy computations. They are likewise outside checks.

Runs:
https://github.com/BenFrohman/ns-tether-key-estimate-refutation/actions/runs/42916652258
https://github.com/BenFrohman/ns-tether-key-estimate-refutation/actions/runs/42916649801
