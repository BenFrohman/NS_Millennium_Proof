#!/usr/bin/env python3
# Copyright (c) 2026 Benjamin Stanley Frohman. Licensed under Apache-2.0.
"""Coverage check, run after `lake build` in CI. EVERY tracked .lean file (`git ls-files '*.lean'`,
only .lake/ left out) must be exactly one of:
  BUILT    a module whose .olean exists after the CI build (module name = path under a srcDir
           declared in the lakefile, or under the repository root);
  CI-RUN   lakefile.lean, or a .lean file that a workflow or CI shell script runs by its path;
  EXCERPT  a statement excerpt whose `-- <file>.lean, line N` header names a BUILT file and whose
           code lines occur verbatim and contiguously in that file (proof bodies shown as `...`).
Any other file FAILS, by name. There is no exclusion list."""
import os, re, subprocess, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
os.chdir(ROOT)
OLEAN_ROOTS = [".lake/build/lib/lean", ".lake/build/lib"]

def tracked():
    return [f for f in subprocess.check_output(["git", "ls-files", "*.lean"]).decode().splitlines()
            if f and not f.startswith(".lake/") and "/.lake/" not in f]

def src_dirs():
    txt = ""
    for lf in ["lakefile.lean", "lakefile.toml"]:
        if os.path.isfile(lf):
            txt += open(lf, encoding="utf-8").read()
    ds = set(re.findall(r'srcDir\s*:?=\s*"([^"]*)"', txt))
    return sorted({d.strip("/").lstrip("./") for d in ds} - {"", "."}, key=len, reverse=True)

def module_of(f):
    rel = f[:-5]
    cands = [rel] + [rel[len(d) + 1:] for d in src_dirs() if rel.startswith(d + "/")]
    for root in OLEAN_ROOTS:
        for c in cands:
            if os.path.isfile(os.path.join(root, c + ".olean")):
                return c.replace("/", ".")
    return None

def ci_text():
    txt = ""
    for top in [".github/workflows", "scripts", "certificates/tools"]:
        if not os.path.isdir(top):
            continue
        for dp, dn, fs in os.walk(top):
            for n in sorted(fs):
                if n.endswith((".yml", ".yaml", ".sh")):
                    txt += open(os.path.join(dp, n), encoding="utf-8", errors="replace").read() + "\n"
    if os.path.isfile("Makefile"):
        txt += open("Makefile", encoding="utf-8").read()
    return txt

def check_excerpt(path, built):
    t = open(path, encoding="utf-8", errors="replace").read()
    m = re.search(r"^-- ([\w./-]+\.lean), lines? (\d+)(?:-\d+)?\s*$", t, re.M)
    if not m:
        return "no '-- <file>.lean, line N' provenance header"
    src = m.group(1)
    if src not in built:
        return f"provenance file {src} is not a BUILT module"
    body = re.sub(r"^\s*/-!.*?-/\s*", "", t[m.end():], count=1, flags=re.S)
    lines = [l.strip() for l in body.split("\n") if l.strip()]
    if not lines:
        return "empty excerpt"
    S = [l.strip() for l in open(src, encoding="utf-8").read().split("\n")]
    def same(l, s, last):
        if l == s:
            return True
        if "..." in l and s.startswith(l.split("...")[0].rstrip()):
            return True
        return last and s.startswith(l) and s[len(l):].strip() in (":=", ":= by")
    for i in range(len(S)):
        if all(i + k < len(S) and same(l, S[i + k], k == len(lines) - 1) for k, l in enumerate(lines)):
            return None
    return f"code is not a verbatim contiguous block of {src}"

def main():
    files = tracked()
    built = {f: module_of(f) for f in files}
    built = {f: m for f, m in built.items() if m}
    ci = ci_text()
    counts = {"BUILT": 0, "CI-RUN": 0, "EXCERPT": 0}
    fails = []
    for f in files:
        if f in built:
            counts["BUILT"] += 1; continue
        if f == "lakefile.lean" or f in ci:
            counts["CI-RUN"] += 1; print(f"  CI-RUN  {f}"); continue
        r = check_excerpt(f, built)
        if r is None:
            counts["EXCERPT"] += 1; continue
        fails.append(f"{f}: not built, not run by CI, not a verified excerpt ({r})")
    print(f"COVERAGE: {len(files)} tracked .lean files: {counts['BUILT']} BUILT, {counts['CI-RUN']} CI-RUN, "
          f"{counts['EXCERPT']} EXCERPT, {len(fails)} uncovered")
    if fails:
        print("COVERAGE FAIL:\n" + "\n".join(fails)); return 1
    print("COVERAGE PASS: every tracked .lean file is built, run by CI, or a verified excerpt of a built file")
    return 0

sys.exit(main())
