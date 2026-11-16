#!/usr/bin/env bash
# Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
# Released under Apache 2.0 license as described in the file LICENSE.
# Authors: Benjamin Stanley Frohman
#
# Truth Gate verification (see TRUTH_GATE.md). Exit 0 only if every check passes. Fails on:
# a failed `lake build` (the root module runs the gate in-build), a missing Semantics module or
# in-build gate call, sorry/admit/native_decide/axiom tokens, any lock failure reported by
# scripts/SemanticsLock.lean (ALIAS, RFL, TRIVIAL, SORRY, NATIVE_DECIDE, AXIOM, HASH, PAPER_SHA,
# QUOTE, UNTRANSPORTED, NO_SEMANTICS_IMPORT, UNREGISTERED, MISSING, SHAPE, DRIFT), or a negative
# fixture that unexpectedly passes.
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p truth-gate-report
fail() { echo "TRUTH GATE FAIL: $*"; exit 1; }

echo "== 1/5 static checks"
python3 scripts/truth_gate_check.py | tee truth-gate-report/static-lock.txt
[ -f NS_Millennium_Proof/Semantics.lean ] || fail "NS_Millennium_Proof/Semantics.lean missing"
[ -f truth-gate.lock.json ] || fail "truth-gate.lock.json missing"
grep -q '^import NS_Millennium_Proof.Semantics$' NS_Millennium_Proof.lean || fail "root does not import NS_Millennium_Proof.Semantics"
grep -q '^#eval TruthGate.runTruthGate "truth-gate.lock.json"$' NS_Millennium_Proof.lean || fail "root does not run the in-build gate"
grep -q 'theorem intended_correspondence' NS_Millennium_Proof/Semantics.lean || fail "no intended_correspondence"
grep -q 'PENDING AUTHOR APPROVAL' NS_Millennium_Proof/Semantics.lean || echo "note: transcriptions no longer marked PENDING AUTHOR APPROVAL"
python3 scripts/check_forbidden_tokens.py NS_Millennium_Proof.lean NS_Millennium_Proof/Semantics.lean \
  NS_Millennium_Proof/TruthGate.lean NS_Millennium_Proof/Modules NS_Millennium_Proof/Definitions \
  | tee truth-gate-report/static.txt

echo "== 2/5 lake build (runs the axiom audit and the in-build Truth Gate)"
set +e
lake build 2>&1 | tee truth-gate-report/build.log
rc=${PIPESTATUS[0]}
set -e
[ "$rc" -eq 0 ] || fail "lake build failed (exit $rc); see TRUTH GATE FAIL lines in truth-gate-report/build.log"

echo "== 3/5 standalone gate: observation pass, gate, axioms (uncached)"
set +e
lake env lean scripts/SemanticsLock.lean 2>&1 | tee truth-gate-report/semantics-lock.txt
rc=${PIPESTATUS[0]}
set -e
[ "$rc" -eq 0 ] || fail "scripts/SemanticsLock.lean failed (exit $rc)"
grep -q 'TRUTH GATE SUMMARY .* failures=0' truth-gate-report/semantics-lock.txt || fail "gate summary not clean"
if grep -E "^'.*' depends on axioms" truth-gate-report/semantics-lock.txt | grep -vE "depends on axioms: \[(propext|Classical.choice|Quot.sound)(, (propext|Classical.choice|Quot.sound))*\]$" ; then
  fail "non-standard axiom in a locked or public declaration"
fi

echo "== 4/5 negative fixtures (each must FAIL with its expected code)"
bash scripts/truth-gate-tests/run.sh 2>&1 | tee truth-gate-report/negative-tests.txt

echo "== 5/5 provenance"
sha256sum truth-gate.lock.json NS_Millennium_Proof/Semantics.lean NS_Millennium_Proof/TruthGate.lean \
  > truth-gate-report/sha256.txt
cat truth-gate-report/sha256.txt
echo "TRUTH GATE PASS at $(git rev-parse HEAD 2>/dev/null || echo unknown) toolchain $(cat lean-toolchain)"
