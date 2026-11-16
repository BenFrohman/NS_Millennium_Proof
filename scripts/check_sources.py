#!/usr/bin/env python3
# Copyright (c) 2026 Benjamin Stanley Frohman. Released under Apache 2.0 (see LICENSE).
"""CI gate: fail if `sorry`/`admit` or any top-level `axiom` declaration appears
in default-build Lean sources (comments and string literals are stripped first)."""
import pathlib, re, sys
ROOTS = ["NS_Millennium_Proof/Modules", "NS_Millennium_Proof/Definitions"]

def strip(src: str) -> str:
    out, i, n, depth = [], 0, len(src), 0
    while i < n:
        if depth == 0 and src.startswith("--", i):
            j = src.find("\n", i); j = n if j < 0 else j
            i = j; continue
        if src.startswith("/-", i):
            depth += 1; i += 2; continue
        if depth > 0 and src.startswith("-/", i):
            depth -= 1; i += 2; continue
        if depth > 0:
            if src[i] == "\n": out.append("\n")
            i += 1; continue
        if src[i] == '"':
            j = i + 1
            while j < n and src[j] != '"':
                j += 2 if src[j] == "\\" else 1
            out.append('""'); i = j + 1; continue
        out.append(src[i]); i += 1
    return "".join(out)

TOK = re.compile(r"(?<![\w.'])(sorry|admit)(?![\w'])")
AX = re.compile(r"^\s*(?:@\[[^\]]*\]\s*)?(?:(?:private|protected|noncomputable|unsafe)\s+)*axiom\s", re.M)
bad = 0
files = [p for r in ROOTS for p in sorted(pathlib.Path(r).rglob("*.lean"))]
for p in files:
    code = strip(p.read_text(encoding="utf-8"))
    for k, line in enumerate(code.splitlines(), 1):
        if TOK.search(line):
            print(f"::error file={p},line={k}::sorry/admit: {line.strip()}"); bad += 1
        if AX.match(line):
            print(f"::error file={p},line={k}::axiom declaration: {line.strip()}"); bad += 1
print(f"checked {len(files)} files, {bad} violation(s)")
sys.exit(1 if bad else 0)
