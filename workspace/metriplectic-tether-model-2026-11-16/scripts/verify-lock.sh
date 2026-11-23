#!/usr/bin/env bash
# Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
# Released under Apache 2.0 license as described in the file LICENSE.
# Authors: Benjamin Stanley Frohman
# Truth Gate semantics-lock checks (run after `lake build`).
set -euo pipefail
cd "$(dirname "$0")/.."
SEM=MetriplecticTetherModel/Semantics.lean
fail() { echo "FAIL: $1"; exit 1; }
[ -f "$SEM" ] || fail "missing $SEM"
grep -q "^theorem intended_correspondence : formal_claim ↔ paper_claim" "$SEM" || fail "missing intended_correspondence"
python3 - <<'PY' || exit 1
import re, sys, hashlib, json, subprocess
src = open("MetriplecticTetherModel/Semantics.lean", encoding="utf-8").read()
paper = src[src.index("def paper_claim"):src.index("/-- The inlined right-hand side")]
code = re.sub(r"--[^\n]*", "", paper)
for name in ["formal_claim", "tether", "tetheredRHS", "energy", "tetherFactorized", "formal_claim_holds"]:
    if re.search(r"(?<![\w.])" + name + r"(?![\w])", code):
        print(f"FAIL: paper_claim references `{name}`"); sys.exit(1)
corr = src[src.index("theorem intended_correspondence"):src.index("/-- The library proves")]
body = corr.split(":= by", 1)[1] if ":= by" in corr else corr.split(":=", 1)[1]
if re.fullmatch(r"\s*(Iff\.rfl|rfl|⟨id, id⟩)\s*", body):
    print("FAIL: intended_correspondence proved by rfl"); sys.exit(1)
doc = src[src.index("/-- **Paper claim**"):src.index("def paper_claim")]
claim = open("paper/main_theorem.tex", encoding="utf-8").read()
sha = hashlib.sha256(claim.encode("utf-8")).hexdigest()
if sha not in doc: print("FAIL: claim-source sha256 not in paper_claim doc"); sys.exit(1)
block = claim[claim.index("\\begin{theorem}"):claim.index("\\end{theorem}") + len("\\end{theorem}")]
if block not in doc: print("FAIL: verbatim quote differs from paper/main_theorem.tex"); sys.exit(1)
paper_tex = open("paper/metriplectic_tether_model.tex", encoding="utf-8").read()
if "\\input{main_theorem}" not in paper_tex: print("FAIL: paper does not \\input the locked claim source"); sys.exit(1)
lock = json.load(open("truth-gate.lock.json"))
cur = json.loads(subprocess.run(["python3", "scripts/lockregions.py"], capture_output=True, text=True, check=True).stdout)
for k in ["claim_source_sha256", "formal_claim_sha256", "paper_claim_sha256", "intended_correspondence_sha256", "toolchain", "lake_manifest_sha256"]:
    if lock[k] != cur[k]: print(f"FAIL: lock mismatch for {k}"); sys.exit(1)
if not lock.get("certifying"): print("FAIL: lock not certifying"); sys.exit(1)
print("paper_claim: independent (no reference to formal_claim or the named kernels)")
print("intended_correspondence: not rfl; claim source sha256 and verbatim quote match")
print("truth-gate.lock.json: all hashes match; scope:", lock["lock_scope"])
print("approver:", lock["approver"])
PY
grep -q "intended_correspondence : formal_claim ↔ paper_claim" certificates/axioms.txt || fail "#check intended_correspondence missing from axioms output"
grep -q "'MetriplecticTetherModel.intended_correspondence' depends on axioms: \[propext, Classical.choice, Quot.sound\]" certificates/axioms.txt || fail "axioms of intended_correspondence"
grep -q "'MetriplecticTetherModel.main_theorem' depends on axioms: \[propext, Classical.choice, Quot.sound\]" certificates/axioms.txt || fail "axioms of main_theorem"
echo "TRUTH GATE: PASS"
