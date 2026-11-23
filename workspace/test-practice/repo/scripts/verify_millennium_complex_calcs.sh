#!/usr/bin/env bash
# Copyright (c) 2026 Benjamin Stanley Frohman. Licensed under Apache-2.0.
# Local re-run of the kernel-certificate checks (same scripts as .github/workflows/kernel-certificate.yml).
# Every step must pass; any failure stops the script with a nonzero exit code.
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p cert-out
python3 scripts/check_no_skips.py
lake exe cache get
lake build 2>&1 | tee cert-out/build.log
python3 scripts/check_build_log.py cert-out/build.log
python3 scripts/check_lean_coverage.py
git ls-files -z '*.lean' | xargs -0 python3 scripts/sorry_scan.py
python3 scripts/gen_audit.py cert-out/KernelCertificateAudit.lean cert-out/modules.txt
lake env lean cert-out/KernelCertificateAudit.lean > cert-out/axioms.raw.txt 2>&1
python3 scripts/check_audit.py cert-out/axioms.raw.txt
