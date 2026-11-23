#!/usr/bin/env python3
"""Build a Lean reproducibility bundle, not an independent trusted certificate.
Copyright (c) 2026 Benjamin Stanley Frohman. Apache-2.0.
Author: Frohman, Benjamin Stanley
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import tarfile


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=Path("artifacts/clay-lean-certificate"))
    parser.add_argument("--source-base", default="unspecified-local-source")
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    leanroot = root / "lean"
    out = args.output.resolve()
    # Never overwrite a previous evidence bundle.
    out.mkdir(parents=True, exist_ok=False)
    logs = out / "logs"
    logs.mkdir()
    objects = out / "compiled"
    objects.mkdir()

    def capture(command, env=None):
        result = subprocess.run(command, cwd=leanroot, env=env, text=True,
                                stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        if result.returncode:
            raise RuntimeError(f"Failed {command!r}\n{result.stdout}")
        return result.stdout

    version = capture(["lake", "env", "lean", "--version"]).strip()
    toolchain = (leanroot / "lean-toolchain").read_text().strip()
    if "4.16.0" not in version or toolchain != "leanprover/lean4:v4.16.0":
        raise RuntimeError(f"Unexpected pinned toolchain: {toolchain}: {version}")
    pins = json.loads((leanroot / "lake-manifest.json").read_text())
    dependencies = []
    for package in pins["packages"]:
        dep = leanroot / pins.get("packagesDir", ".lake/packages") / package["name"]
        head = capture(["git", "-C", str(dep), "rev-parse", "HEAD"]).strip()
        if head != package["rev"]:
            raise RuntimeError(f"Dependency revision mismatch: {package['name']}")
        if capture(["git", "-C", str(dep), "status", "--porcelain", "--untracked-files=no"]).strip():
            raise RuntimeError(f"Tracked dependency modifications: {package['name']}")
        dependencies.append({"name": package["name"], "revision": head,
                             "url": package.get("url")})
        for name in ["LICENSE", "LICENSE.md", "LICENSE.txt", "COPYING", "NOTICE"]:
            source = dep / name
            if source.is_file():
                dest = out / "dependency-notices" / package["name"] / name
                dest.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(source, dest)

    env = os.environ.copy()
    paths = capture(["lake", "env", "printenv", "LEAN_PATH"]).strip()
    env["LEAN_PATH"] = str(objects) + ":" + paths
    compiler = capture(["lake", "env", "which", "lean"]).strip()
    sources = {".".join(path.relative_to(leanroot).with_suffix("").parts): path
               for path in [leanroot / "Clay.lean", *sorted((leanroot / "Clay").rglob("*.lean")),
                            leanroot / "SolutionLinkedRegression.lean"]}
    checked = set()
    with (logs / "source-typecheck.log").open("w") as log:
        def check(name):
            if name in checked:
                return
            source = sources[name]
            for dep in re.findall(r"^import\s+(\S+)", source.read_text(), re.M):
                if dep in sources:
                    check(dep)
            dest = objects / Path(*name.split(".")).with_suffix(".olean")
            dest.parent.mkdir(parents=True, exist_ok=True)
            command = [compiler, "-DautoImplicit=false", "-DrelaxedAutoImplicit=false",
                       "-o", str(dest), str(source.relative_to(leanroot))]
            result = subprocess.run(command, cwd=leanroot, env=env, text=True,
                                    stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
            log.write(f"COMMAND {command!r}\n{result.stdout}\nEXIT {result.returncode}\n")
            log.flush()
            result.check_returncode()
            checked.add(name)
            print("TYPECHECKED", name, flush=True)
        for name in sources:
            check(name)
    audit = capture([compiler, "AxiomReport.lean"], env=env)
    (logs / "per-theorem-axioms.log").write_text(audit)
    summary = re.search(r"AXSUMMARY (\d+) theorems, (\d+) declarations in Clay; nonstandard: 0", audit)
    if not summary or "sorryAx" in audit:
        raise RuntimeError("Missing clean complete-library axiom audit")
    (logs / "toolchain.txt").write_text(version + "\n" + toolchain + "\n")
    for source in [*sources.values(), leanroot / "AxiomReport.lean", leanroot / "AxiomAudit.lean",
                   leanroot / "lakefile.lean", leanroot / "lake-manifest.json", leanroot / "lean-toolchain",
                   root / "LICENSE", root / "NOTICE", root / "AUTHORS.md", root / "README.md",
                   root / "SECURITY.md", root / "docs/SOLUTION_LINKED_VORTEX_LINES.md", Path(__file__)]:
        dest = out / "sources" / source.relative_to(root)
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, dest)
    (out / "REPRODUCE.md").write_text(
        "# Reproduce, do not independently trust this bundle\n\n"
        "Install the pinned Lean toolchain, obtain the dependency revisions recorded in\n"
        "sources/lean/lake-manifest.json, then from sources/lean run:\n\n"
        "    lake exe cache get\n    lake build\n    lake env lean AxiomReport.lean\n"
        "    lake env lean SolutionLinkedRegression.lean\n\n"
        "Alternatively run the bundled sources/scripts/build_lean_certificate.py after\n"
        "fetching the pinned dependency cache. It freshly compiles all project sources\n"
        "against external pinned cached dependency artifacts and audits their statements.\n"
        "Compiled project artifacts are included; Lean and all dependency binaries are\n"
        "not bundled. SHA-256 checks detect changed files, not mathematical meaning,\n"
        "novelty, security or a Millennium solution. Source/log reproducibility is not\n"
        "a promise of bit-for-bit identical archives across machines.\n")
    files = {}
    for source in sorted(out.rglob("*")):
        if source.is_file():
            files[str(source.relative_to(out))] = {
                "sha256": hashlib.sha256(source.read_bytes()).hexdigest(),
                "bytes": source.stat().st_size}
    manifest = {"source_base": args.source_base, "scope": "local source snapshot plus recorded changes",
                "verification": "fresh complete project source typecheck against pinned external cached dependencies",
                "lean_version": version, "toolchain": toolchain, "dependencies": dependencies,
                "checked_modules": sorted(checked), "theorems_including_generated": int(summary[1]),
                "declarations": int(summary[2]), "nonstandard_axioms": 0,
                "independent_trusted_certificate": False, "files": files}
    (out / "MANIFEST.json").write_text(json.dumps(manifest, indent=2) + "\n")
    archive = out.parent / (out.name + ".tar.gz")
    if archive.exists():
        raise FileExistsError(archive)
    with tarfile.open(archive, "w:gz") as tar:
        tar.add(out, arcname=out.name)
    print(summary.group(0), flush=True)
    print("REPRODUCIBILITY BUNDLE", archive, flush=True)


if __name__ == "__main__":
    main()
