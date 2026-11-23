#!/usr/bin/env python3
# Copyright (c) 2026 Benjamin Stanley Frohman. Licensed under Apache-2.0.
"""Build every tracked .lean file. Run after `lake build` and `lake build ForMathlib` in CI.

The file list is `git ls-files '*.lean'`. There is no exclusion list and no path is treated
specially. Every file must end in exactly one of:
  BUILT     its module .olean was produced by the lake build (module name = path under the
            repository root or under a srcDir declared in the lakefile);
  LAKEFILE  ./lakefile.lean, which Lake elaborates on every `lake` invocation;
  COMPILED  `lake env lean <file>` (the repo's lake-manifest.json, lean-toolchain and Mathlib
            cache) exits 0 with no error and no `declaration uses 'sorry'`;
  LISTING   the file does not compile on its own because it is a paper listing (a quoted
            declaration, proof bodies possibly shown as `...`). It passes only if every quoted
            declaration header occurs verbatim in a BUILT file, and `#print axioms` on each quoted
            declaration, run by `lake env lean` against the built module, shows no axiom beyond
            propext, Classical.choice and Quot.sound.
Anything else FAILS, with the file name and the first compiler errors. The full compiler output of
every file is written to cert-out/lean-files/<path>.log."""
import os, re, subprocess, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
os.chdir(ROOT)
OLEAN_ROOTS = [".lake/build/lib/lean", ".lake/build/lib"]
LOGDIR = "cert-out/lean-files"
STD = {"propext", "Classical.choice", "Quot.sound"}
DECL = re.compile(r"^(?:@\[[^\]]*\]\s*)?(?:(?:public|private|protected|noncomputable|partial|unsafe)\s+)*"
                  r"(theorem|lemma|def|abbrev|structure|class|instance|inductive)\s+([^\s:({\[]+)")

def tracked():
    return [f for f in subprocess.check_output(["git", "ls-files", "*.lean"]).decode().splitlines() if f]

def src_dirs():
    txt = "".join(open(lf, encoding="utf-8").read() for lf in ["lakefile.lean", "lakefile.toml"] if os.path.isfile(lf))
    ds = set(re.findall(r'srcDir\s*:?=\s*"([^"]*)"', txt))
    return sorted({d.strip("/").lstrip("./") for d in ds} - {"", "."}, key=len, reverse=True)

def module_of(f):
    rel = f[:-5]
    for c in [rel] + [rel[len(d) + 1:] for d in src_dirs() if rel.startswith(d + "/")]:
        for root in OLEAN_ROOTS:
            if os.path.isfile(os.path.join(root, c + ".olean")):
                return c.replace("/", ".")
    return None

def run_lean(path, log):
    os.makedirs(os.path.dirname(log), exist_ok=True)
    p = subprocess.run(["lake", "env", "lean", path], capture_output=True, text=True)
    out = p.stdout + p.stderr
    open(log, "w", encoding="utf-8").write(out + f"\n[exit {p.returncode}]\n")
    bad = p.returncode != 0 or re.search(r"(^|\s)error:", out) or "declaration uses 'sorry'" in out
    return (not bad), out

def norm(s):
    return " ".join(s.split())

def namespace_at(lines, i):
    stack = []
    for l in lines[:i]:
        m = re.match(r"\s*namespace\s+(\S+)", l)
        if m:
            stack.append(m.group(1)); continue
        m = re.match(r"\s*end\s+(\S+)\s*$", l)
        if m and stack and stack[-1] == m.group(1):
            stack.pop()
    return ".".join(stack)

def listing(f, built):
    body = open(f, encoding="utf-8").read()
    lines = body.split("\n")
    decls = [(i, m.group(2)) for i, l in enumerate(lines) for m in [DECL.match(l.strip())] if m]
    if not decls:
        return "no declaration to check"
    srcs = {b: open(b, encoding="utf-8").read().split("\n") for b in built}
    checks = []
    for k, (i, name) in enumerate(decls):
        j = decls[k + 1][0] if k + 1 < len(decls) else len(lines)
        block = [l for l in lines[i:j] if l.strip() and not l.strip().startswith("--")]
        # header = text up to the first `:=` (the statement); `...` marks an elided body
        head = norm(" ".join(block)).split(" := ")[0].split(":= ...")[0].strip()
        hit = None
        for b, L in srcs.items():
            for s in range(len(L)):
                if DECL.match(L[s].strip()) and DECL.match(L[s].strip()).group(2) == name:
                    t = norm(" ".join(L[s:s + len(block) + 40]))
                    # `...` elides part of the statement: the quoted pieces must occur in order,
                    # the first one at the start of the source declaration.
                    pieces = [x.strip() for x in head.split("...") if x.strip()]
                    pos, ok = 0, bool(pieces) and t.startswith(pieces[0])
                    for x in pieces if ok else []:
                        q = t.find(x, pos)
                        if q < 0:
                            ok = False; break
                        pos = q + len(x)
                    if ok:
                        hit = (b, s); break
            if hit: break
        if not hit:
            return f"quoted declaration `{name}` does not occur verbatim in any BUILT file"
        b, s = hit
        ns = namespace_at(srcs[b], s)
        checks.append((built[b], (ns + "." if ns else "") + name))
    gen = os.path.join(LOGDIR, f + ".axioms.lean")
    os.makedirs(os.path.dirname(gen), exist_ok=True)
    mods = sorted({m for m, _ in checks})
    open(gen, "w", encoding="utf-8").write("".join(f"import {m}\n" for m in mods) +
                                           "".join(f"#print axioms {n}\n" for _, n in checks))
    ok, out = run_lean(gen, gen[:-5] + ".log")
    if not ok:
        return "axiom check did not compile:\n" + out[-1500:]
    for n in re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]", out):
        extra = {a.strip() for a in n[1].split(",") if a.strip()} - STD
        if extra:
            return f"`{n[0]}` depends on nonstandard axioms {sorted(extra)}"
    if len(re.findall(r"depends on axioms|does not depend on any axioms", out)) != len(checks):
        return "axiom check did not report every quoted declaration:\n" + out[-1500:]
    return None

def main():
    files = tracked()
    built = {f: m for f in files for m in [module_of(f)] if m}
    counts = {"BUILT": 0, "LAKEFILE": 0, "COMPILED": 0, "LISTING": 0}
    fails = []
    for f in files:
        if f in built:
            counts["BUILT"] += 1; print(f"BUILT     {f}", flush=True); continue
        if f == "lakefile.lean":
            counts["LAKEFILE"] += 1; print(f"LAKEFILE  {f}", flush=True); continue
        ok, out = run_lean(f, os.path.join(LOGDIR, f + ".log"))
        if ok:
            counts["COMPILED"] += 1; print(f"COMPILED  {f}", flush=True); continue
        why = listing(f, built) if not re.search(r"^\s*(public\s+)?(meta\s+)?import\s", open(f, encoding="utf-8").read(), re.M) else "file has imports"
        if why is None:
            counts["LISTING"] += 1; print(f"LISTING   {f}", flush=True); continue
        errs = [l for l in out.splitlines() if "error" in l or "sorry" in l][:6]
        fails.append(f); print(f"FAIL      {f}\n  compile: " + "\n  compile: ".join(errs or [out[-400:]]) + f"\n  listing: {why}", flush=True)
    print(f"BUILD-EVERY-FILE: {len(files)} tracked .lean files: " + ", ".join(f"{v} {k}" for k, v in counts.items()) + f", {len(fails)} FAILED")
    if fails:
        print("BUILD-EVERY-FILE FAIL:\n" + "\n".join(fails)); return 1
    print("BUILD-EVERY-FILE PASS: every tracked .lean file was built by lake, compiled by lean, or is a listing of a built declaration")
    return 0

sys.exit(main())
