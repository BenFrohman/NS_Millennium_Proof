#!/usr/bin/env python3
# Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
# Released under Apache 2.0 license as described in the file LICENSE.
# Authors: Benjamin Stanley Frohman
"""Check the output of `lake env lean TFFrohmanianTether/AxiomAudit.lean`.
Every `#print axioms` result must use only propext, Classical.choice,
Quot.sound, and the number of results must equal the number of
`#print axioms` commands in AxiomAudit.lean."""
import re, sys

ALLOWED = {'propext', 'Classical.choice', 'Quot.sound'}
out = open(sys.argv[1], encoding='utf-8').read()
src = open('TFFrohmanianTether/AxiomAudit.lean', encoding='utf-8').read()
expected = len(re.findall(r'^#print axioms ', src, re.M))
results = re.findall(r"'([^']+)' (depends on axioms: \[([^\]]*)\]|does not depend on any axioms)", out)
bad = []
for name, whole, ax in results:
    used = {a.strip() for a in ax.replace('\n', ' ').split(',') if a.strip()}
    if not used <= ALLOWED:
        bad.append((name, sorted(used - ALLOWED)))
errors = re.findall(r'^.*error.*$', out, re.M)
print(f"#print axioms commands: {expected}")
print(f"#print axioms results:  {len(results)}")
for name, extra in bad:
    print(f"FAIL {name}: extra axioms {extra}")
for e in errors:
    print(f"FAIL error line: {e}")
ok = not bad and not errors and len(results) == expected and expected > 0
print("AXIOM AUDIT PASS: every result uses only [propext, Classical.choice, Quot.sound]" if ok else "AXIOM AUDIT FAIL")
sys.exit(0 if ok else 1)
