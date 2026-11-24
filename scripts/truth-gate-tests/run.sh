#!/usr/bin/env bash
# Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
# Released under Apache 2.0 license as described in the file LICENSE.
# Authors: Benjamin Stanley Frohman
#
# Runs every Truth Gate fixture. `good` must pass; every `neg_*` must fail with a non-zero exit
# and print its expected failure code(s). Exit 0 only if all behave as expected.
set -uo pipefail
cd "$(dirname "$0")/../.."
status=0
for f in scripts/truth-gate-tests/good.lean scripts/truth-gate-tests/neg_*.lean; do
  case=$(basename "$f" .lean)
  expect=$(python3 -c "import json,sys;print(json.load(open('scripts/truth-gate-tests/$case.json'))['expect'])")
  out=$(lake env lean "$f" 2>&1); rc=$?
  if [ "$case" = good ]; then
    if [ $rc -eq 0 ] && grep -q 'TRUTH GATE PASS good' <<<"$out"; then echo "ok   $case: passes"
    else echo "BAD  $case: expected pass, exit $rc"; echo "$out"; status=1; fi
    continue
  fi
  missing=""
  IFS=',' read -ra codes <<<"$expect"
  for c in "${codes[@]}"; do c=$(echo "$c" | xargs); grep -q "TRUTH GATE FAIL $c " <<<"$out" || missing="$missing $c"; done
  if [ $rc -ne 0 ] && [ -z "$missing" ]; then
    echo "ok   $case: gate RED as expected (exit $rc): $(grep -o 'TRUTH GATE FAIL [A-Z_]*' <<<"$out" | sed 's/TRUTH GATE FAIL //' | sed '/^$/d' | sort -u | paste -sd, -)"
  else
    echo "BAD  $case: expected failure codes [$expect], exit $rc, missing [$missing]"; echo "$out"; status=1
  fi
done
exit $status
