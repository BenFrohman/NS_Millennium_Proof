#!/usr/bin/env python3
"""Scan tracked .lean files (comments and strings stripped) for sorry, admit,
native_decide and axiom declarations.

Every tracked .lean file (`git ls-files '*.lean'`) is scanned. There is no exclusion
list: a hit in any tracked .lean file fails the certificate.
"""
import re, subprocess, sys

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

files = subprocess.check_output(['git', 'ls-files', '*.lean']).decode().split()
certified = []
for f in files:
    for n, l in enumerate(strip(open(f, encoding='utf-8').read()).split('\n'), 1):
        if re.search(r'\b(sorry|admit|native_decide)\b', l) or re.match(
            r'\s*(@\[[^\]]*\]\s*)?((private|protected|noncomputable|public|unsafe)\s+)*axiom\s', l):
            hit = f'{f}:{n}: {l.strip()}'
            certified.append(hit)
print(f'Scanned {len(files)} tracked .lean files for sorry / admit / native_decide / axiom declarations (comments and strings ignored).')
print('Certificate scope: every tracked .lean file.')
if not files:
    print('FAIL: no tracked .lean files'); sys.exit(1)
if certified:
    print(f'CERTIFICATE HITS: {len(certified)}')
    print('\n'.join(certified))
    sys.exit(1)
print('RESULT: 0 hits')
sys.exit(0)
