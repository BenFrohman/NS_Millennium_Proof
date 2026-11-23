# Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
# Released under Apache 2.0 license as described in the file LICENSE.
# Authors: Benjamin Stanley Frohman
"""Check `#print axioms` output: every theorem may depend only on propext, Classical.choice, Quot.sound."""
import re, sys
txt = open(sys.argv[1], encoding="utf-8").read()
allowed = {"propext", "Classical.choice", "Quot.sound"}
ok, bad = 0, []
for m in re.finditer(r"'([^']+)' (depends on axioms: \[([^\]]*)\]|does not depend on any axioms)", txt):
    axs = {a.strip() for a in (m.group(3) or "").split(",") if a.strip()}
    if axs <= allowed: ok += 1
    else: bad.append((m.group(1), axs - allowed))
if "error" in txt.lower() or "sorryAx" in txt: bad.append(("<output>", {"error or sorryAx in output"}))
print(f"theorems audited: {ok + len(bad)}; only [propext, Classical.choice, Quot.sound]: {ok}; violations: {len(bad)}")
for b in bad: print("VIOLATION", b)
sys.exit(1 if bad else 0)
