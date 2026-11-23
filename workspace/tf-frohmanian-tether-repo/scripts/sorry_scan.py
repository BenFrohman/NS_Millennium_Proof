#!/usr/bin/env python3
# Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
# Released under Apache 2.0 license as described in the file LICENSE.
# Authors: Benjamin Stanley Frohman
"""Scan every tracked .lean file for `sorry`, `admit`, `native_decide` and
`axiom` declarations, ignoring comments and string literals.
Exit status 1 if any is found."""
import re, subprocess, sys

def strip(src: str) -> str:
    out, i, n, depth = [], 0, len(src), 0
    while i < n:
        if depth == 0 and src.startswith('--', i):
            j = src.find('\n', i); i = n if j < 0 else j; continue
        if src.startswith('/-', i):
            depth += 1; i += 2; continue
        if depth > 0 and src.startswith('-/', i):
            depth -= 1; i += 2; continue
        if depth == 0 and src[i] == '"':
            j = i + 1
            while j < n and src[j] != '"':
                j += 2 if src[j] == '\\' else 1
            i = j + 1; continue
        if depth == 0:
            out.append(src[i])
        elif src[i] == '\n':
            out.append('\n')
        i += 1
    return ''.join(out)

files = subprocess.run(['git', 'ls-files', '*.lean'], capture_output=True, text=True, check=True).stdout.split()
pat = re.compile(r'(?<![\w.])(sorry|admit|native_decide)(?![\w.])|^\s*(?:private\s+|protected\s+)?axiom\s', re.M)
hits = 0
for f in files:
    code = strip(open(f, encoding='utf-8').read())
    for m in pat.finditer(code):
        line = code.count('\n', 0, m.start()) + 1
        print(f"{f}:{line}: {m.group(0).strip()}")
        hits += 1
print(f"files scanned: {len(files)}")
print(f"sorry/admit/native_decide/axiom occurrences outside comments: {hits}")
sys.exit(1 if hits else 0)
