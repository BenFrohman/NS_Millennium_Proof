# Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
# Released under Apache 2.0 license as described in the file LICENSE.
# Authors: Benjamin Stanley Frohman
"""Extract the locked regions of Semantics.lean and compute their hashes.
`python3 scripts/lockregions.py write` (re)writes truth-gate.lock.json; without arguments it
prints the current hashes as JSON."""
import hashlib, json, re, sys
SEM = "MetriplecticTetherModel/Semantics.lean"
CLAIM = "paper/main_theorem.tex"
src = open(SEM, encoding="utf-8").read()
def region(start, end):
    i = src.index(start); j = src.index(end, i)
    return src[i:j]
formal = region("def formal_claim", "/-- **Paper claim**")
paper = region("def paper_claim", "/-- The inlined right-hand side")
corr = region("theorem intended_correspondence", "/-- The library proves")
h = lambda s: hashlib.sha256(s.encode("utf-8")).hexdigest()
cur = {
  "semantics_file": SEM,
  "semantics_module": "MetriplecticTetherModel.Semantics",
  "claim_source": CLAIM,
  "claim_source_sha256": hashlib.sha256(open(CLAIM, "rb").read()).hexdigest(),
  "formal_claim_sha256": h(formal),
  "paper_claim_sha256": h(paper),
  "intended_correspondence_sha256": h(corr),
  "main_theorems": ["MetriplecticTetherModel.main_theorem", "MetriplecticTetherModel.intended_correspondence"],
  "toolchain": open("lean-toolchain").read().strip(),
  "lake_manifest_sha256": hashlib.sha256(open("lake-manifest.json", "rb").read()).hexdigest(),
  "lock_scope": "full: the entire Main Theorem (items (a)-(j)) is locked; no partial lock",
  "approver": "PENDING - Benjamin Stanley Frohman must approve the paper_claim transcription",
  "certifying": True,
}
if len(sys.argv) > 1 and sys.argv[1] == "write":
    json.dump(cur, open("truth-gate.lock.json", "w"), indent=2); open("truth-gate.lock.json", "a").write("\n")
else:
    print(json.dumps(cur, indent=2))
