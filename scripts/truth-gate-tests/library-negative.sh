#!/usr/bin/env bash
# Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
# Released under Apache 2.0 license as described in the file LICENSE.
# Authors: Benjamin Stanley Frohman
#
# Library-mode negative tests: break the real lock in two ways and check the gate turns red.
#  A. a public theorem proved directly instead of by `intended_correspondence.mp` -> UNTRANSPORTED
#  B. a paper_claim aliasing formal_claim with an Iff.rfl correspondence -> ALIAS, RFL, TRIVIAL, HASH
# Uses only the `locked` locks (so the recorded DRIFT does not mask the result). Restores the
# sources and rebuilds on exit. Run from the repository root on a clean tree.
set -uo pipefail
cd "$(dirname "$0")/../.."
git diff --quiet -- NS_Millennium_Proof || { echo "tree not clean"; exit 2; }
tmp=$(mktemp -d)
restore() { git checkout -q -- NS_Millennium_Proof; lake build NS_Millennium_Proof.Modules.MainTheorem >/dev/null 2>&1; }
trap restore EXIT
python3 - "$tmp" <<'PY'
import json, sys
j = json.load(open("truth-gate.lock.json"))
j["locks"] = [l for l in j["locks"] if l["status"] == "locked"]
json.dump(j, open(sys.argv[1] + "/locked-only.json", "w"), ensure_ascii=False)
PY
{ grep '^import NS_Millennium_Proof\.' scripts/SemanticsLock.lean; echo; echo "#eval TruthGate.runTruthGate \"$tmp/locked-only.json\""; } > "$tmp/Gate.lean"
check() { # name, expected codes...
  local name=$1; shift
  lake build NS_Millennium_Proof.Modules.MainTheorem >/dev/null 2>&1 || { echo "BAD  $name: mutated library does not build"; return 1; }
  out=$(lake env lean "$tmp/Gate.lean" 2>&1); rc=$?
  for c in "$@"; do grep -q "TRUTH GATE FAIL $c " <<<"$out" || { echo "BAD  $name: missing $c (exit $rc)"; echo "$out" | grep 'TRUTH GATE'; return 1; }; done
  [ $rc -ne 0 ] || { echo "BAD  $name: gate passed"; return 1; }
  echo "ok   $name: gate RED (exit $rc)"; grep 'TRUTH GATE FAIL' <<<"$out" | cut -c1-200
}
status=0
python3 - <<'PY'
p = "NS_Millennium_Proof/Modules/MainTheorem.lean"; s = open(p).read()
old = ("  NS_Millennium_Proof.Semantics.DirectionCurvatureReduction.intended_correspondence.mp\n"
       "    clay_reduces_to_direction_curvature_bound_formal")
assert old in s
s = s.replace(old, "  fun hB hC => clay_reduces_to_direction_curvature_bound_formal hB\n"
  "    (fun ν hν => (NS_Millennium_Proof.Semantics.DirectionCurvatureReduction.paperUniformCeiling_iff ν).1 (hC ν hν))")
open(p, "w").write(s)
PY
check "A untransported public theorem" UNTRANSPORTED || status=1
git checkout -q -- NS_Millennium_Proof
python3 - <<'PY'
p = "NS_Millennium_Proof/Semantics.lean"; s = open(p).read()
i = s.index("namespace PeriodicTetherReduction"); j = s.index("end PeriodicTetherReduction")
new = ("namespace PeriodicTetherReduction\n\ndef formal_claim : Prop :=\n"
       "  (∀ ν > (0 : ℝ), PeriodicTetherClosingBound ν) →\n"
       "    (∀ ν > (0 : ℝ), PeriodicBKMContinuation ν) → Clay_B_exact\n\n"
       "def paper_claim : Prop := formal_claim\n\n"
       "theorem intended_correspondence : formal_claim ↔ paper_claim := Iff.rfl\n\n")
open(p, "w").write(s[:i] + new + s[j:])
PY
check "B aliased paper_claim + Iff.rfl" ALIAS RFL TRIVIAL HASH || status=1
python3 scripts/truth_gate_check.py >/dev/null 2>&1 && { echo "BAD  B: static check passed"; status=1; } || echo "ok   B: static lock-region check RED"
exit $status
