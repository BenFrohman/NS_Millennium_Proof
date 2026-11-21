#!/usr/bin/env python3
"""Scan tracked .lean files (comments and strings stripped) for sorry, admit,
native_decide and axiom declarations.

The kernel certificate is the library `lake build` and `lake build ForMathlib`
typecheck. Three trees are kept in the repository and are reported, not
certified:

  historical/                  preserved snapshots, including the May 2026 pin
  docs/                        prose sketches, not a Lake target
  scripts/truth-gate-tests/    fixtures that must contain the forbidden tokens

A hit in any other tracked .lean file fails the certificate.
"""
import re, subprocess, sys

EXCLUDED_PREFIXES = (
    "historical/",
    "docs/",
    "scripts/truth-gate-tests/",
)

def strip(s):
    out = []; i = 0; d = 0
    while i < len(s):
        if s.startswith('/-', i): d += 1; i += 2; continue
        if d and s.startswith('-/', i): d -= 1; i += 2; continue
        if d: i += 1; continue
        if s.startswith('--', i):
            j = s.find('\n', i); i = len(s) if j < 0 else j; continue
        if s[i] == '"':
            j = i + 1
            while j < len(s) and s[j] != '"': j += 2 if s[j] == '\\' else 1
            out.append('""'); i = j + 1; continue
        out.append(s[i]); i += 1
    return ''.join(out)

def excluded(path):
    return any(path.startswith(prefix) for prefix in EXCLUDED_PREFIXES)

files = subprocess.check_output(['git', 'ls-files', '*.lean']).decode().split()
certified, archived = [], []
for f in files:
    for n, l in enumerate(strip(open(f, encoding='utf-8').read()).split('\n'), 1):
        if re.search(r'\b(sorry|admit|native_decide)\b', l) or re.match(
            r'\s*(@\[[^\]]*\]\s*)?((private|protected|noncomputable|public|unsafe)\s+)*axiom\s', l):
            hit = f'{f}:{n}: {l.strip()}'
            (archived if excluded(f) else certified).append(hit)
print(f'Scanned {len(files)} tracked .lean files for sorry / admit / native_decide / axiom declarations (comments and strings ignored).')
print('Certificate scope: every tracked .lean file except historical/, docs/, and scripts/truth-gate-tests/.')
print(f'EXCLUDED HITS (not certified): {len(archived)}')
if archived:
    print('\n'.join(archived))
if certified:
    print(f'CERTIFICATE HITS: {len(certified)}')
    print('\n'.join(certified))
    sys.exit(1)
print('RESULT: 0 hits in the certified library')
sys.exit(0)
