#!/usr/bin/env bash
# Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
# Released under Apache 2.0 license as described in the file LICENSE.
# Authors: Benjamin Stanley Frohman
#
# One-command rebuild and verification for MetriplecticTetherModel.
#   ./verify.sh            rebuild, run the Truth Gate checks, write certificates/ and CERTIFICATE.md
# Every value in CERTIFICATE.md is produced by the commands below; nothing is hand-written.
set -euo pipefail
cd "$(dirname "$0")"
ROOT=$(pwd)
OUT=certificates
mkdir -p "$OUT"
STAMP=$(date '+%Y-%m-%d %H:%M:%S %Z')

# Pinned dependency files: byte-for-byte copies of BenFrohman/frohmanian-symplectic-tether-regularity @ 2a649d1
EXPECT_MANIFEST=b81d814b7d2d2d2821b03ed679324d5e7ec7da674e0a977352d01c88cbe8ccb8
EXPECT_TOOLCHAIN=1098ca8368e0db12138f33b070187e1f6527984ae0451a587b20e3e661f96a76
MAN_SHA=$(sha256sum lake-manifest.json | cut -d' ' -f1)
TC_SHA=$(sha256sum lean-toolchain | cut -d' ' -f1)
[ "$MAN_SHA" = "$EXPECT_MANIFEST" ] || { echo "FAIL: lake-manifest.json differs from the pinned manifest"; exit 1; }
[ "$TC_SHA" = "$EXPECT_TOOLCHAIN" ] || { echo "FAIL: lean-toolchain differs from the pinned toolchain"; exit 1; }
MATHLIB_REV=$(python3 -c "import json;print([p['rev'] for p in json.load(open('lake-manifest.json'))['packages'] if p['name']=='mathlib'][0])")

# 1. Mathlib olean cache for exactly the manifest revision (only the modules this library imports).
lake exe cache get Mathlib.Analysis.InnerProductSpace.PiL2 Mathlib.MeasureTheory.Integral.Bochner.Set \
  Mathlib.MeasureTheory.Function.LocallyIntegrable Mathlib.MeasureTheory.Measure.Lebesgue.Basic \
  Mathlib.Analysis.Calculus.ContDiff.Basic Mathlib.Analysis.Calculus.Deriv.Pow \
  Mathlib.Analysis.Calculus.Deriv.Mul Mathlib.Analysis.Calculus.Deriv.Add \
  Mathlib.Analysis.SpecialFunctions.Trigonometric.Deriv Mathlib.Analysis.Calculus.Deriv.Prod \
  > "$OUT/cache.log" 2>&1

# 2. Clean rebuild of this library (previous build products are moved aside, never deleted).
if [ -d .lake/build ]; then mv .lake/build ".lake/build.prev.$(date +%Y%m%d%H%M%S)"; fi
set +e
lake build -v > "$OUT/build.log" 2>&1
BUILD_RC=$?
set -e
[ $BUILD_RC -eq 0 ] || { echo "FAIL: lake build (see $OUT/build.log)"; exit 1; }

# 3. Forbidden tokens and header check.
python3 scripts/source_scan.py > "$OUT/source-scan.txt"

# 4. #print axioms for every theorem, and the semantics lock.
lake env lean scripts/PrintAxioms.lean > "$OUT/axioms.txt" 2>&1
python3 scripts/check_axioms.py "$OUT/axioms.txt" > "$OUT/axioms-summary.txt"
bash scripts/verify-lock.sh > "$OUT/truth-gate.txt"

# 5. Kernel replay of every module, one module at a time, with the toolchain's own leanchecker
#    source (src/lean/LeanChecker.lean) patched to exact module matching (upstream matches by
#    prefix, which would replay all modules of the root in parallel). Run with `lean --run`.
TC_DIR="$(dirname "$(dirname "$(lake env which lean)")")"
mkdir -p .lake/checker
sed 's/if !fresh \&\& target.isPrefixOf m || target == m then/if target == m then/' \
  "$TC_DIR/src/lean/LeanChecker.lean" > .lake/checker/LeanCheckerExact.lean
grep -q "if target == m then" .lake/checker/LeanCheckerExact.lean || { echo "FAIL: could not patch leanchecker"; exit 1; }
{ echo "checker: $TC_DIR/src/lean/LeanChecker.lean (sha256 $(sha256sum "$TC_DIR/src/lean/LeanChecker.lean" | cut -d' ' -f1)), patched to exact module match, run with lean --run";
  diff "$TC_DIR/src/lean/LeanChecker.lean" .lake/checker/LeanCheckerExact.lean | sed 's/^/  patch: /' || true; } > "$OUT/leanchecker.txt"
for m in $(python3 scripts/modules.py); do
  if lake env lean --run .lake/checker/LeanCheckerExact.lean --verbose "$m" >> "$OUT/leanchecker.txt" 2>&1; then
    echo "$m: OK" >> "$OUT/leanchecker.txt"
  else
    echo "$m: FAIL" >> "$OUT/leanchecker.txt"; echo "FAIL: leanchecker $m"; exit 1
  fi
done

# 6. Paper and source archive hashes.
COMMIT=$(git rev-parse HEAD)
git diff --quiet HEAD -- MetriplecticTetherModel MetriplecticTetherModel.lean lakefile.lean lake-manifest.json lean-toolchain paper scripts verify.sh \
  || { echo "FAIL: working tree differs from HEAD in certified paths"; exit 1; }
ARCHIVE="MetriplecticTetherModel-source-${COMMIT:0:7}.zip"
git archive --format=zip --prefix="MetriplecticTetherModel-${COMMIT:0:7}/" -o "$OUT/$ARCHIVE" HEAD
python3 scripts/make_certificate.py "$COMMIT" "$MATHLIB_REV" "$MAN_SHA" "$TC_SHA" "$ARCHIVE" "$STAMP"
echo "PASS: build, source scan, axioms, Truth Gate lock, kernel replay. Certificate: CERTIFICATE.md"
