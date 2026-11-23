#!/usr/bin/env python3
"""Build certificate bundles and update/create Zenodo drafts. Never publishes."""
from __future__ import annotations

import hashlib
import json
import os
import shutil
import ssl
import urllib.error
import urllib.request
import zipfile
from pathlib import Path

TOKEN = os.environ["ZENODO_ACCESS_TOKEN"]
API = "https://zenodo.org/api"
ROOT = Path("/workspace/cert-bundle-prs/zenodo-work")
ART = Path("/workspace/cert-bundle-prs/ci-artifacts")
MAN = ART / "manifests"
OUT = ROOT / "bundles"
OUT.mkdir(parents=True, exist_ok=True)
REPORT = ROOT / "report.json"

NOTICE = """Copyright (c) 2026 Benjamin Stanley Frohman (ORCID 0009-0006-7068-3718).
Independent Researcher, Texas, United States.

The paper / PDF is licensed under the Creative Commons Attribution 4.0
International License (CC BY 4.0). The Lean source and Lean kernel
certificate files are licensed under the Apache License, Version 2.0.

Any use, reproduction, or redistribution must retain this NOTICE and
credit Benjamin Stanley Frohman as the author. If you use this work in
a publication, please cite it (see the record DOI).
"""

NOTES_COMMON = (
    "Copyright (c) 2026 Benjamin Stanley Frohman (ORCID 0009-0006-7068-3718), "
    "Independent Researcher, Texas, United States. The paper / PDF is licensed "
    "CC BY 4.0. The Lean source and Lean kernel certificate files are licensed "
    "Apache-2.0. Any use, reproduction, or redistribution must retain this "
    "notice and credit Benjamin Stanley Frohman as the author; please cite "
    "this record's DOI."
)


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def write_sha256sums(folder: Path) -> None:
    rows = []
    for p in sorted(folder.rglob("*")):
        if p.is_file() and p.name != "SHA256SUMS":
            rel = p.relative_to(folder).as_posix()
            rows.append(f"{sha256(p)}  {rel}")
    (folder / "SHA256SUMS").write_text("\n".join(rows) + "\n")


def copy_manifest_bundle(src: Path, dest: Path, repo_path_note: str) -> None:
    dest.mkdir(parents=True, exist_ok=True)
    for name in [
        "lake-manifest.json",
        "lake-manifest.json.sha256",
        "lake-manifest.json.sha256sum",
        "lean-toolchain",
        "lean-toolchain.sha256",
        "lean-toolchain.sha256sum",
        "mathlib-rev.txt",
        "COMMIT.txt",
    ]:
        s = src / name
        if s.exists():
            shutil.copy2(s, dest / name)
    (dest / "MANIFEST_SOURCE.txt").write_text(
        (src / "COMMIT.txt").read_text() + f"file locations in the repository: {repo_path_note}\n"
        "These files are this repository's own committed lake-manifest.json and "
        "lean-toolchain at the cited commit, with sha256 computed from those bytes. "
        "They were not present in a CI artifact upload; they are taken from GitHub "
        "at that commit.\n"
    )


def zip_dir(src: Path, dest_zip: Path) -> None:
    if dest_zip.exists():
        dest_zip.unlink()
    with zipfile.ZipFile(dest_zip, "w", compression=zipfile.ZIP_DEFLATED) as z:
        for p in sorted(src.rglob("*")):
            if p.is_file():
                z.write(p, arcname=f"{src.name}/{p.relative_to(src).as_posix()}")


def request(method: str, url: str, data=None, content_type=None, raw=False):
    headers = {"Authorization": f"Bearer {TOKEN}", "Accept": "application/json"}
    body = None
    if data is not None and not raw:
        headers["Content-Type"] = content_type or "application/json"
        body = json.dumps(data).encode()
    elif data is not None and raw:
        if content_type:
            headers["Content-Type"] = content_type
        body = data
    req = urllib.request.Request(url, data=body, headers=headers, method=method)
    try:
        with urllib.request.urlopen(req, timeout=180) as r:
            raw_b = r.read()
            status = r.status
    except urllib.error.HTTPError as e:
        err = e.read().decode("utf-8", "replace")
        raise SystemExit(f"HTTP {e.code} {method} {url.split('?')[0]}: {err[:2000]}")
    if not raw_b:
        return status, None
    try:
        return status, json.loads(raw_b.decode())
    except json.JSONDecodeError:
        return status, raw_b


def get(url):
    return request("GET", url)[1]


def post(url, data=None):
    return request("POST", url, data=data)[1]


def put(url, data=None, raw=False, content_type=None):
    return request("PUT", url, data=data, raw=raw, content_type=content_type)[1]


def delete(url):
    return request("DELETE", url)


def metadata_for_put(md: dict) -> dict:
    skip = {"doi", "prereserve_doi", "conceptdoi", "conceptrecid"}
    out = {k: v for k, v in md.items() if k not in skip and v is not None}
    return out


def upload_file(bucket: str, path: Path, filename: str | None = None):
    name = filename or path.name
    url = bucket.rstrip("/") + "/" + name
    with path.open("rb") as f:
        data = f.read()
    put(url, data=data, raw=True, content_type="application/octet-stream")
    return name, len(data), hashlib.md5(data).hexdigest()


def delete_file(dep_id: int, file_id: str):
    delete(f"{API}/deposit/depositions/{dep_id}/files/{file_id}")


def new_version(recid: int) -> dict:
    data = post(f"{API}/deposit/depositions/{recid}/actions/newversion")
    latest = data["links"]["latest_draft"]
    draft = get(latest)
    if draft.get("state") != "unsubmitted" or draft.get("submitted"):
        raise SystemExit(f"new version of {recid} is not an unsubmitted draft: {draft.get('id')} state={draft.get('state')} submitted={draft.get('submitted')}")
    if draft.get("id") == recid:
        raise SystemExit(f"new version of {recid} returned the same id")
    return draft


def update_metadata(dep_id: int, md: dict):
    put(f"{API}/deposit/depositions/{dep_id}", {"metadata": md})
    refreshed = get(f"{API}/deposit/depositions/{dep_id}")
    if refreshed.get("submitted") or refreshed.get("state") == "done":
        raise SystemExit(f"WARNING: deposition {dep_id} is submitted after metadata put; aborting further edits")
    return refreshed


# ---------------------------------------------------------------------------
# Bundles
# ---------------------------------------------------------------------------

def build_gaps_bundle() -> Path:
    d = OUT / "gaps-ledger-raw-ci-artifacts-v4"
    if d.exists():
        shutil.rmtree(d)
    d.mkdir()
    (d / "NOTICE").write_text(NOTICE)
    (d / "README.md").write_text(
        """# Gaps ledger v4: raw CI materials and honest provenance

This archive replaces the hand-assembled file gaps-ledger-axioms.txt
that was attached to version 3 (10.5281/zenodo.24289291).

A hand-written summary is not a Lean kernel certificate. The final pass,
if any, rests only on the Lean kernel and #print axioms from a real
lake build of that repository's own lake-manifest.json.

## 1. frohmanian-tether-sdiff at 0727e6d (raw CI artifact)

GitHub Actions run 43933623627, workflow "Lean certificate", event
pull_request, head SHA 0727e6d561ca68678eb909d8b6dd120c4a2a6e15,
conclusion success.
https://github.com/BenFrohman/frohmanian-tether-sdiff/actions/runs/43933623627

The uploaded artifact name is axioms-pull_request-43933623627, downloaded
with gh. It contains axioms.txt (full axiom audit, 1886 theorems, 0
violations) and print_axioms.txt (the #print axioms lines). The
lake-manifest.json and lean-toolchain in this folder are this
repository's own committed files at 0727e6d, with sha256, because that
CI artifact did not include them.

## 2. fefferman-clay-navier-stokes at 8d8a0cf (job log only)

GitHub Actions run 43928116535, workflow "Lean certificate", event
push, head SHA 8d8a0cf60b06d111fdee59215797b32e6029eeff, conclusion
success.
https://github.com/BenFrohman/fefferman-clay-navier-stokes/actions/runs/43928116535

No artifact was uploaded by that run. The file
github-actions-job.log is the raw log obtained with
`gh run view 43928116535 --log`. It includes the lake build and
#print axioms lines. The lake-manifest.json and lean-toolchain are
this repository's own committed files at 8d8a0cf, with sha256.

## 3. NS_Millennium_Proof at b8d2f1e (job log only)

GitHub Actions run 43928069777, workflow "Lean CI", event push,
head SHA b8d2f1eaa3e749eb2cb321b629259d199a4fd6b0, conclusion success.
https://github.com/BenFrohman/NS_Millennium_Proof/actions/runs/43928069777

No artifact was uploaded by that run. The previous version's
hand-assembled axioms file said that seven NS_Millennium_Proof
declarations were printed locally; no CI artifact exists for that
local print. The file github-actions-job.log is the raw Lean CI
job log at the cited commit, obtained with
`gh run view 43928069777 --log`. The lake-manifest.json and
lean-toolchain are this repository's own committed files at
b8d2f1e, with sha256.

Toolchain at all three commits: leanprover/lean4:v4.30.0-rc1.
Mathlib revision: 0c154d67103f74be3a0f2c509f72ccbf5be9f2a7.
"""
    )

    sdiff = d / "frohmanian-tether-sdiff-0727e6d"
    sdiff.mkdir()
    shutil.copy2(ART / "gaps-sdiff" / "axioms.txt", sdiff / "axioms.txt")
    shutil.copy2(ART / "gaps-sdiff" / "print_axioms.txt", sdiff / "print_axioms.txt")
    (sdiff / "CI_SOURCE.txt").write_text(
        "repo: BenFrohman/frohmanian-tether-sdiff\n"
        "commit: 0727e6d561ca68678eb909d8b6dd120c4a2a6e15\n"
        "run: 43933623627\n"
        "run_url: https://github.com/BenFrohman/frohmanian-tether-sdiff/actions/runs/43933623627\n"
        "artifact: axioms-pull_request-43933623627\n"
        "downloaded_with: gh run download 43933623627\n"
        "kind: raw CI artifact (Lean axiom audit and #print axioms)\n"
    )
    copy_manifest_bundle(MAN / "sdiff-0727e6d", sdiff / "lake-manifest-at-commit", "lake-manifest.json and lean-toolchain at the repository root")

    feff = d / "fefferman-clay-navier-stokes-8d8a0cf"
    feff.mkdir()
    shutil.copy2(ART / "logs" / "fefferman-43928116535.log", feff / "github-actions-job.log")
    (feff / "CI_SOURCE.txt").write_text(
        "repo: BenFrohman/fefferman-clay-navier-stokes\n"
        "commit: 8d8a0cf60b06d111fdee59215797b32e6029eeff\n"
        "run: 43928116535\n"
        "run_url: https://github.com/BenFrohman/fefferman-clay-navier-stokes/actions/runs/43928116535\n"
        "artifact: NONE uploaded by this run\n"
        "downloaded_with: gh run view 43928116535 --log\n"
        "kind: GitHub Actions job log, not a CI artifact bundle\n"
    )
    copy_manifest_bundle(MAN / "fefferman-8d8a0cf", feff / "lake-manifest-at-commit", "lake-manifest.json and lean-toolchain at the repository root")

    ns = d / "NS_Millennium_Proof-b8d2f1e"
    ns.mkdir()
    shutil.copy2(ART / "logs" / "ns-43928069777-b8d2f1e.log", ns / "github-actions-job.log")
    (ns / "CI_SOURCE.txt").write_text(
        "repo: BenFrohman/NS_Millennium_Proof\n"
        "commit: b8d2f1eaa3e749eb2cb321b629259d199a4fd6b0\n"
        "run: 43928069777\n"
        "run_url: https://github.com/BenFrohman/NS_Millennium_Proof/actions/runs/43928069777\n"
        "artifact: NONE uploaded by this run\n"
        "downloaded_with: gh run view 43928069777 --log\n"
        "kind: GitHub Actions job log, not a CI artifact bundle\n"
        "note: the previous hand-assembled axioms file said 7 declarations were printed locally; no CI artifact exists for that local print.\n"
    )
    copy_manifest_bundle(MAN / "ns-b8d2f1e", ns / "lake-manifest-at-commit", "lake-manifest.json and lean-toolchain at the repository root")

    write_sha256sums(d)
    z = OUT / "gaps-ledger-raw-ci-artifacts-v4.zip"
    zip_dir(d, z)
    return z


def build_ns_bundle() -> Path:
    d = OUT / "ns-millennium-certificate-provenance-v2.6.0"
    if d.exists():
        shutil.rmtree(d)
    d.mkdir()
    (d / "NOTICE").write_text(NOTICE)
    (d / "README.md").write_text(
        """# NS Millennium Proof concept, version 2.6.0 certificate provenance

This archive accompanies a new version of concept 10.5281/zenodo.23627609,
built from the latest published version 2.5.0 (10.5281/zenodo.24144853)
at commit 6c79135d30fdd03d6b7520d47eec4fefa5ec7f03.

## What is, and is not, a Lean kernel certificate

The Lean CI workflow at that commit (GitHub Actions run 43047743968)
passed, including a real `lake build`. The workflow did not upload a
lake-certificate artifact. There is therefore no raw CI artifact
bundle from that run that contains lake-manifest.json, its sha256,
the toolchain, versions, the build log file, and the #print axioms
output as separate uploaded files.

github-actions-job-log-run43047743968.log is the raw log of that
run, obtained with `gh run view 43047743968 --log`. It is a
GitHub Actions job log, not an uploaded certificate artifact.
The lake-manifest.json and lean-toolchain in this folder are this
repository's own committed files at 6c79135, with sha256.

The file CI_audit_excerpt_run43047743968.txt already on version
2.5.0 is an excerpt, not a raw CI artifact.

## TITAN_AUDIT on version 2.4.0 (10.5281/zenodo.24126051)

Version 2.4.0 of this concept attached TITAN_AUDIT_CERTIFICATE.json.
No lake build ran for that Titan audit file. It is not a Lean
kernel certificate. Version 2.5.0 already removed it. It is not
reintroduced here.

Toolchain: leanprover/lean4:v4.30.0-rc1.
Mathlib revision: 0c154d67103f74be3a0f2c509f72ccbf5be9f2a7.
Run: https://github.com/BenFrohman/NS_Millennium_Proof/actions/runs/43047743968
"""
    )
    shutil.copy2(
        ART / "logs" / "ns-43047743968.log",
        d / "github-actions-job-log-run43047743968.log",
    )
    (d / "CI_SOURCE.txt").write_text(
        "repo: BenFrohman/NS_Millennium_Proof\n"
        "commit: 6c79135d30fdd03d6b7520d47eec4fefa5ec7f03\n"
        "run: 43047743968\n"
        "run_url: https://github.com/BenFrohman/NS_Millennium_Proof/actions/runs/43047743968\n"
        "artifact: NONE uploaded by this run\n"
        "downloaded_with: gh run view 43047743968 --log\n"
        "kind: GitHub Actions job log, not a CI artifact bundle\n"
    )
    copy_manifest_bundle(
        MAN / "ns-6c79135",
        d / "lake-manifest-at-commit",
        "lake-manifest.json and lean-toolchain at the repository root",
    )
    write_sha256sums(d)
    z = OUT / "ns-millennium-certificate-provenance-v2.6.0.zip"
    zip_dir(d, z)
    return z


def build_refutation_bundle() -> Path:
    d = OUT / "key-estimate-refutation-certificate-bundle-v1.2.0"
    if d.exists():
        shutil.rmtree(d)
    d.mkdir()
    (d / "NOTICE").write_text(NOTICE)
    (d / "README.md").write_text(
        """# Key-estimate refutation v1.2.0 certificate bundle

Lean kernel materials and outside checks from the GitHub Actions
verify-logs artifacts of runs 42916652258 (pull_request) and
42916649801 (push). Both runs are at commit
715626e2de363edd674b458dbb492cfa004c5b03, both concluded success,
and the two artifacts are byte-identical.

https://github.com/BenFrohman/ns-tether-key-estimate-refutation/actions/runs/42916652258
https://github.com/BenFrohman/ns-tether-key-estimate-refutation/actions/runs/42916649801

The files under lean-kernel/ are the Lean lake build log and the
#print axioms output from that artifact, together with this
repository's own lean/lake-manifest.json and lean/lean-toolchain
at 715626e, with sha256 (those two files were not inside the
verify-logs artifact).

The files under outside-checks/ are not Lean kernel certificates:
- v2_maxcert.log: Arb interval-arithmetic numeric check
- v1_trig_example.log: Python / sympy computation
- v2_symbolic.log and v2_sym.pkl: Python / sympy computation

Toolchain: Lean 4.22.0 (see lean-toolchain).
Mathlib revision: 79e94a093aff4a60fb1b1f92d9681e407124c2ca (v4.22.0).
"""
    )
    lean = d / "lean-kernel"
    lean.mkdir()
    src = ART / "ns-refutation-42916652258"
    shutil.copy2(src / "axioms.log", lean / "axioms.log")
    shutil.copy2(src / "lake_build.log", lean / "lake_build.log")
    (lean / "CI_SOURCE.txt").write_text(
        "repo: BenFrohman/ns-tether-key-estimate-refutation\n"
        "commit: 715626e2de363edd674b458dbb492cfa004c5b03\n"
        "runs: 42916652258 (pull_request), 42916649801 (push)\n"
        "artifact: verify-logs (byte-identical on both runs)\n"
        "downloaded_with: gh run download 42916652258 and 42916649801\n"
        "kind: raw CI artifact, Lean kernel files only in this folder\n"
    )
    copy_manifest_bundle(
        MAN / "refutation-715626e",
        lean / "lake-manifest-at-commit",
        "lean/lake-manifest.json and lean/lean-toolchain",
    )

    outside = d / "outside-checks"
    outside.mkdir()
    (outside / "README.md").write_text(
        "These files come from the same verify-logs CI artifact, but they are\n"
        "outside checks, not Lean kernel certificates.\n"
        "\n"
        "v2_maxcert.log — Arb interval-arithmetic numeric check\n"
        "  (the line beginning CERTIFIED reports a numeric bound; it is not a\n"
        "  Lean kernel certificate).\n"
        "v1_trig_example.log — Python / sympy computation\n"
        "v2_symbolic.log, v2_sym.pkl — Python / sympy computation\n"
    )
    shutil.copy2(src / "v2_maxcert.log", outside / "v2_maxcert.log")
    shutil.copy2(src / "v1_trig_example.log", outside / "v1_trig_example.log")
    shutil.copy2(src / "v2_symbolic.log", outside / "v2_symbolic.log")
    shutil.copy2(src / "v2_sym.pkl", outside / "v2_sym.pkl")
    write_sha256sums(d)
    z = OUT / "key-estimate-refutation-certificate-bundle-v1.2.0.zip"
    zip_dir(d, z)
    return z


# ---------------------------------------------------------------------------
# Descriptions
# ---------------------------------------------------------------------------

P2Q_DESCRIPTION = """<p>Version 1.4 of further constraints on simultaneous totient and divisor-sum jumps of length 12 for <em>n</em> = <em>p</em>²<em>q</em>. Concept DOI: <a href="https://doi.org/10.5281/zenodo.22713135">10.5281/zenodo.22713135</a>. This record does not close the problem.</p>
<p><strong>Theorem L is a set of necessary conditions, not a resolution.</strong> If distinct primes <em>p</em>, <em>q</em> satisfy both length-12 jumps at <em>n</em> = <em>p</em>²<em>q</em> and <em>N</em> = <em>n</em>+12, then: (i) <em>N</em> is not prime and is not a product of two distinct primes; (ii) <em>N</em> is not a product of three distinct primes; (iii) <em>N</em> is not of the form <em>r</em>²<em>st</em> with pairwise distinct primes <em>r</em>, <em>s</em>, <em>t</em> ≥ 5; (iv) if <em>N</em> = <em>r</em>³<em>s</em> with distinct primes <em>r</em>, <em>s</em> ≥ 5, then <em>p</em> &lt; <em>r</em>, <em>r</em>² divides <em>p</em>³−<em>p</em>²−12, and <em>p</em> &gt; 10⁴; (v) <em>n</em> &gt; 10⁴. These are narrowing conditions that exclude several shapes for <em>N</em>. They do not prove that no such jump exists, and Conjecture 3 remains open.</p>
<p>The Lean 4 formalization of Theorem L is kernel-checked: a clean <code>lake build</code>, an independent <code>lean4checker</code> replay of every <code>P2qJumps</code> module, a sorry/admit/native_decide scan, and an axiom audit showing only the standard axioms <code>propext</code>, <code>Classical.choice</code>, and <code>Quot.sound</code>. Lean sources commit: <code>4ae3e47f8e13edf2262528f0a8cc73657ccfc3cc</code> (unchanged through <code>main</code> at <code>6a6c05d</code>). The certificate package and source archive attached here are taken from commit <a href="https://github.com/BenFrohman/p2q-jumps-lean/commit/1e9031a840d381991632b6fcc9efecc52d6099a5">1e9031a840d381991632b6fcc9efecc52d6099a5</a>, now on <code>main</code> via merge commit <a href="https://github.com/BenFrohman/p2q-jumps-lean/commit/140af8aa1dbb8cef453f9b5b206a97707ed4195d">140af8aa1dbb8cef453f9b5b206a97707ed4195d</a> (PR <a href="https://github.com/BenFrohman/p2q-jumps-lean/pull/5">#5</a>, same tree). That commit adds <code>certificates/MANIFEST</code> (SHA-256 of each certificate, the sources commit, toolchain leanprover/lean4:v4.26.0 and Mathlib v4.26.0, and the rebuild command). The Truth Gate lock remains pending author approval: Benjamin Stanley Frohman has not yet confirmed that the Lean <code>paper_claim</code> transcribes Theorem L as meant. That pending sign-off is the only remaining Truth Gate step; it is not a kernel failure.</p>
<p>LMFDB curve 3936.b1 (the curve <em>y</em>² = <em>x</em>³ − <em>x</em>² − 12) has <strong>rank 1</strong>. An earlier version wrongly stated that the rank was 0; that claim is corrected and is not made here. The LMFDB lookups, the PARI computations, and the Python search logs are outside checks. They are not Lean kernel certificates and they do not prove or pass any Lean theorem.</p>
<p>The attached archive <code>p2q-jumps-lean-certificates-and-outside-checks-1e9031a.zip</code> is byte-identical to the previous filename <code>p2q-jumps-lean-certificates-1e9031a.zip</code>. It contains both Lean kernel materials and outside checks. The Lean kernel materials are <code>certificates/lake-build.log</code>, <code>certificates/axiom-audit.txt</code>, <code>certificates/lean4checker.log</code>, <code>certificates/scan-sorry-admit-native_decide.txt</code>, and <code>certificates/verify-lock.log</code>. The following paths are outside checks, not Lean certificates: <code>certificates/external/pari_ec_3936b1.out</code>, <code>certificates/external/pari_minimal_model.out</code>, <code>certificates/external/pari_root_numbers.out</code>, <code>certificates/external/lmfdb_curvedata.json</code>, <code>certificates/external/lmfdb_mwbsd.json</code>, <code>certificates/external/jumps_pq_A_1e4.log</code>, <code>certificates/external/jumps_pq_B_997_1e6.log</code>, and <code>certificates/external/r2_rbound_1e6.out</code>.</p>
<p>The paper PDF is licensed CC BY 4.0. The Lean source and Lean kernel certificates are licensed Apache-2.0, as in the GitHub repository.</p>
<p>© 2026 Benjamin Stanley Frohman (ORCID 0009-0006-7068-3718). Independent Researcher, Texas, United States. Please cite this work and credit Benjamin Stanley Frohman as the author.</p>
"""


def prepend_html(existing: str, block: str) -> str:
    return block.rstrip() + "\n" + existing


# ---------------------------------------------------------------------------
# Actions
# ---------------------------------------------------------------------------

def update_p2q_draft():
    dep = get(f"{API}/deposit/depositions/24180777")
    if dep.get("submitted") or dep.get("state") != "unsubmitted":
        raise SystemExit(f"24180777 is not an unsubmitted draft: state={dep.get('state')} submitted={dep.get('submitted')}")
    md = metadata_for_put(dep["metadata"])
    md["description"] = P2Q_DESCRIPTION
    md["version"] = "1.4 (Theorem L necessary conditions; Lean kernel certificates included; Truth Gate pending author approval)"
    md["notes"] = (
        "Truth Gate is pending author approval. PARI, LMFDB and Python results "
        "under certificates/external/ are outside checks, not Lean kernel certificates. "
        + NOTES_COMMON
    )
    md["license"] = "cc-by-4.0"
    # Rename the mixed zip by re-uploading identical bytes under a clearer filename.
    src = Path("/workspace/audit/24180777/p2q-jumps-lean-certificates-1e9031a.zip")
    if not src.exists():
        raise SystemExit("missing local copy of p2q certificates zip")
    bucket = dep["links"]["bucket"]
    new_name = "p2q-jumps-lean-certificates-and-outside-checks-1e9031a.zip"
    existing = {f["filename"]: f for f in dep.get("files") or []}
    if new_name not in existing:
        upload_file(bucket, src, new_name)
    if "p2q-jumps-lean-certificates-1e9031a.zip" in existing:
        delete_file(24180777, existing["p2q-jumps-lean-certificates-1e9031a.zip"]["id"])
    refreshed = update_metadata(24180777, md)
    return {
        "id": refreshed["id"],
        "state": refreshed["state"],
        "submitted": refreshed["submitted"],
        "version": refreshed["metadata"].get("version"),
        "license": refreshed["metadata"].get("license"),
        "files": [f["filename"] for f in refreshed.get("files") or []],
        "html": refreshed.get("links", {}).get("html"),
    }


def create_version_draft(base_id: int, version: str, description: str, notes: str, uploads: list[tuple[Path, str]], deletes: list[str]):
    draft = new_version(base_id)
    dep_id = draft["id"]
    bucket = draft["links"]["bucket"]
    print(f"created draft {dep_id} from {base_id}; state={draft.get('state')} submitted={draft.get('submitted')}")
    existing = {f["filename"]: f for f in draft.get("files") or []}
    uploaded = []
    for path, name in uploads:
        upload_file(bucket, path, name)
        uploaded.append(name)
        print(f"  uploaded {name} ({path.stat().st_size} bytes)")
    # refresh files after upload
    draft = get(f"{API}/deposit/depositions/{dep_id}")
    existing = {f["filename"]: f for f in draft.get("files") or []}
    deleted = []
    for name in deletes:
        if name in existing:
            delete_file(dep_id, existing[name]["id"])
            deleted.append(name)
            print(f"  deleted {name}")
        else:
            print(f"  skip delete, not present: {name}")
    md = metadata_for_put(draft["metadata"])
    md["publication_date"] = "2026-11-17"
    md["version"] = version
    md["license"] = "cc-by-4.0"
    md["description"] = description
    md["notes"] = notes
    md["access_right"] = "open"
    # keep creators/title/etc.
    refreshed = update_metadata(dep_id, md)
    if refreshed.get("submitted") or refreshed.get("state") == "done":
        raise SystemExit(f"draft {dep_id} became submitted; this script never publishes")
    return {
        "id": refreshed["id"],
        "conceptrecid": refreshed["metadata"].get("conceptrecid") or refreshed.get("conceptrecid"),
        "state": refreshed["state"],
        "submitted": refreshed["submitted"],
        "version": refreshed["metadata"].get("version"),
        "publication_date": refreshed["metadata"].get("publication_date"),
        "license": refreshed["metadata"].get("license"),
        "doi": (refreshed["metadata"].get("prereserve_doi") or {}).get("doi") or refreshed.get("doi"),
        "files": [
            {"filename": f["filename"], "filesize": f.get("filesize"), "checksum": f.get("checksum")}
            for f in refreshed.get("files") or []
        ],
        "html": refreshed.get("links", {}).get("html"),
        "uploaded": uploaded,
        "deleted": deleted,
        "based_on": base_id,
    }


def main():
    report = {"published": False}
    print("Building bundles...")
    gaps_zip = build_gaps_bundle()
    ns_zip = build_ns_bundle()
    ref_zip = build_refutation_bundle()
    notice = OUT / "NOTICE"
    notice.write_text(NOTICE)
    report["bundles"] = {
        "gaps": {"path": str(gaps_zip), "sha256": sha256(gaps_zip), "size": gaps_zip.stat().st_size},
        "ns": {"path": str(ns_zip), "sha256": sha256(ns_zip), "size": ns_zip.stat().st_size},
        "refutation": {"path": str(ref_zip), "sha256": sha256(ref_zip), "size": ref_zip.stat().st_size},
    }
    print(json.dumps(report["bundles"], indent=2))

    print("Updating p2q draft 24180777 (metadata and filename only)...")
    report["p2q_24180777"] = update_p2q_draft()
    print(json.dumps(report["p2q_24180777"], indent=2))

    # Gaps v4 from 24289291
    gaps_old = get(f"{API}/deposit/depositions/24289291")
    gaps_desc = prepend_html(
        gaps_old["metadata"]["description"],
        """<p><strong>Version 4 (17 November 2026).</strong> This version replaces the hand-assembled file <code>gaps-ledger-axioms.txt</code> with raw CI materials. A hand-written summary is not a Lean kernel certificate. The attached archive <code>gaps-ledger-raw-ci-artifacts-v4.zip</code> contains: (1) the raw GitHub Actions artifact <code>axioms-pull_request-43933623627</code> from frohmanian-tether-sdiff run <a href="https://github.com/BenFrohman/frohmanian-tether-sdiff/actions/runs/43933623627">43933623627</a> at commit <code>0727e6d</code> (full axiom audit, 1886 theorems, 0 violations), together with that repository's own <code>lake-manifest.json</code> and its sha256 at that commit; (2) the GitHub Actions job log of fefferman-clay-navier-stokes run <a href="https://github.com/BenFrohman/fefferman-clay-navier-stokes/actions/runs/43928116535">43928116535</a> at commit <code>8d8a0cf</code>, because that run uploaded no artifact, together with that repository's own <code>lake-manifest.json</code> and its sha256; (3) the GitHub Actions job log of NS_Millennium_Proof Lean CI run <a href="https://github.com/BenFrohman/NS_Millennium_Proof/actions/runs/43928069777">43928069777</a> at the cited commit <code>b8d2f1e</code>, because that run uploaded no artifact and no CI artifact exists for the local print mentioned in the previous hand-assembled file, together with that repository's own <code>lake-manifest.json</code> and its sha256. The paper and the claims are otherwise unchanged: no T-item is closed, and the Clay Millennium statement is not claimed. The paper is licensed CC BY 4.0; the Lean source and Lean kernel materials are licensed Apache-2.0.</p>
""",
    )
    print("Creating gaps ledger v4 draft from 24289291...")
    report["gaps_v4"] = create_version_draft(
        24289291,
        "4",
        gaps_desc,
        NOTES_COMMON + " Working notes. This record does not claim the Clay Millennium statement and does not close any named gap.",
        uploads=[(gaps_zip, gaps_zip.name), (notice, "NOTICE")],
        deletes=["gaps-ledger-axioms.txt"],
    )

    # NS concept latest is 24144853, not 24126051
    ns_old = get(f"{API}/deposit/depositions/24144853")
    ns_desc = prepend_html(
        ns_old["metadata"]["description"],
        """<p><strong>Version 2.6.0 (17 November 2026).</strong> Certificate provenance update of version 2.5.0 (10.5281/zenodo.24144853) at commit <code>6c79135d30fdd03d6b7520d47eec4fefa5ec7f03</code>. The mathematical claims are unchanged. GitHub Actions run <a href="https://github.com/BenFrohman/NS_Millennium_Proof/actions/runs/43047743968">43047743968</a> passed, including a real <code>lake build</code>, but that workflow uploaded no lake-certificate artifact. The attached archive <code>ns-millennium-certificate-provenance-v2.6.0.zip</code> therefore contains the raw GitHub Actions job log of that run (obtained with <code>gh run view --log</code>) and this repository's own <code>lake-manifest.json</code> and <code>lean-toolchain</code> at <code>6c79135</code>, with sha256. The file <code>CI_audit_excerpt_run43047743968.txt</code> already present from version 2.5.0 is an excerpt, not a raw CI artifact. Version 2.4.0 of this concept (10.5281/zenodo.24126051) attached <code>TITAN_AUDIT_CERTIFICATE.json</code>; no lake build ran for that Titan audit file, and it is not a Lean kernel certificate. Version 2.5.0 already removed it; it is not reintroduced here. The paper is licensed CC BY 4.0; the Lean source and Lean kernel materials are licensed Apache-2.0.</p>
""",
    )
    print("Creating NS v2.6.0 draft from 24144853 (latest of concept 23627609, which includes 24126051)...")
    report["ns_v260"] = create_version_draft(
        24144853,
        "2.6.0",
        ns_desc,
        NOTES_COMMON
        + " Conditional result. This record does not prove global regularity for the 3D Navier–Stokes equations or resolve the Clay problem. "
        "TITAN_AUDIT_CERTIFICATE.json on version 2.4.0 (10.5281/zenodo.24126051) is not a Lean kernel certificate; no lake build ran for that file.",
        uploads=[(ns_zip, ns_zip.name), (notice, "NOTICE")],
        deletes=[],
    )

    ref_old = get(f"{API}/deposit/depositions/24121364")
    # also prepare clearly labeled loose copy of maxcert
    maxcert_src = ART / "ns-refutation-42916652258" / "v2_maxcert.log"
    maxcert_named = OUT / "outside-check-arb-v2_maxcert.log"
    shutil.copy2(maxcert_src, maxcert_named)
    ref_desc = prepend_html(
        ref_old["metadata"]["description"],
        """<p><strong>Version 1.2.0 (17 November 2026).</strong> This version keeps the paper and the Lean claims of version 1.1.0 and relabels the certificate files. The Lean kernel materials are the raw GitHub Actions <code>verify-logs</code> artifacts of runs <a href="https://github.com/BenFrohman/ns-tether-key-estimate-refutation/actions/runs/42916652258">42916652258</a> and <a href="https://github.com/BenFrohman/ns-tether-key-estimate-refutation/actions/runs/42916649801">42916649801</a> at commit <code>715626e</code>, which are byte-identical and include <code>axioms.log</code> and <code>lake_build.log</code>, together with this repository's own <code>lean/lake-manifest.json</code> and <code>lean/lean-toolchain</code> at that commit, with sha256. The file previously presented as <code>v2_maxcert.log</code> is an Arb interval-arithmetic numeric check, not a Lean kernel certificate; it is now labeled <code>outside-check-arb-v2_maxcert.log</code>. The same CI artifact also contains Python / sympy logs (<code>v1_trig_example.log</code>, <code>v2_symbolic.log</code>, <code>v2_sym.pkl</code>), which are likewise outside checks. These are packed, with that labeling, in <code>key-estimate-refutation-certificate-bundle-v1.2.0.zip</code>. The mathematical claims are unchanged. No claim about the Clay Millennium Problem is made. The paper is licensed CC BY 4.0; the Lean source and Lean kernel materials are licensed Apache-2.0.</p>
""",
    )
    print("Creating refutation v1.2.0 draft from 24121364...")
    report["refutation_v120"] = create_version_draft(
        24121364,
        "1.2.0",
        ref_desc,
        NOTES_COMMON
        + " Large-data global regularity (Clay Millennium Problem) is not claimed and remains open. "
        "v2_maxcert.log / outside-check-arb-v2_maxcert.log is an Arb interval-arithmetic numeric check, not a Lean kernel certificate.",
        uploads=[
            (ref_zip, ref_zip.name),
            (notice, "NOTICE"),
            (maxcert_named, "outside-check-arb-v2_maxcert.log"),
        ],
        deletes=["v2_maxcert.log"],
    )

    # Final safety: confirm none of the new drafts are published
    for key in ["p2q_24180777", "gaps_v4", "ns_v260", "refutation_v120"]:
        rec = report[key]
        dep = get(f"{API}/deposit/depositions/{rec['id']}")
        rec["final_state"] = dep.get("state")
        rec["final_submitted"] = dep.get("submitted")
        rec["final_files"] = [f["filename"] for f in dep.get("files") or []]
        if dep.get("submitted") or dep.get("state") == "done":
            raise SystemExit(f"Safety check failed: {key} id {rec['id']} is submitted")
        print(f"SAFE unsubmitted draft {key} id={rec['id']} files={rec['final_files']}")

    report["published"] = False
    REPORT.write_text(json.dumps(report, indent=2))
    print("Wrote", REPORT)


if __name__ == "__main__":
    main()
