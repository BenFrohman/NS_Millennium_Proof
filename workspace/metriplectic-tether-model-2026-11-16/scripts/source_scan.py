# Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
# Released under Apache 2.0 license as described in the file LICENSE.
# Authors: Benjamin Stanley Frohman
"""Scan Lean sources: forbidden tokens (sorry, admit, native_decide, axiom, opaque stand-ins)
outside comments, and the required copyright header before the imports."""
import glob, re, sys
HEADER = ("/-\nCopyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.\n"
          "Released under Apache 2.0 license as described in the file LICENSE.\n"
          "Authors: Benjamin Stanley Frohman\n-/\n")
FORBIDDEN = [r"\bsorry\b", r"\badmit\b", r"\bnative_decide\b", r"^\s*axiom\b", r"^\s*opaque\b",
             r"implemented_by", r"\bextern\b", r"set_option\s+debug\.skipKernelTC"]
def strip_comments(s):
    s = re.sub(r"/-.*?-/", "", s, flags=re.S)
    return re.sub(r"--[^\n]*", "", s)
files = ["MetriplecticTetherModel.lean", "lakefile.lean", "scripts/PrintAxioms.lean"] + sorted(glob.glob("MetriplecticTetherModel/*.lean"))
bad = 0
for f in files:
    src = open(f, encoding="utf-8").read()
    ok_header = src.startswith(HEADER)
    code = strip_comments(src)
    hits = [p for p in FORBIDDEN if re.search(p, code, re.M)]
    print(f"{f}: header={'OK' if ok_header else 'MISSING'} forbidden={hits if hits else 'none'}")
    bad += (not ok_header) + len(hits)
print(f"RESULT: {len(files)} files scanned, {bad} problems")
sys.exit(1 if bad else 0)
