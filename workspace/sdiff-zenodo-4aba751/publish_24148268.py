#!/usr/bin/env python3
"""Replace files on unpublished newversion draft 24148268 (concept 24081999),
update metadata, and PUBLISH. User approved this in t286u.
Does not touch 23794113, 23842296, or 23940666.
"""
import json, os, sys
from pathlib import Path
import urllib.request
import urllib.error

ROOT = Path("/workspace/sdiff-zenodo-4aba751")
META = json.loads((ROOT / "upload-metadata.json").read_text())
TOKEN = os.environ.get("ZENODO_ACCESS_TOKEN")
if not TOKEN:
    sys.exit("ZENODO_ACCESS_TOKEN is not set; refusing to continue.")
API = "https://zenodo.org/api"
DID = "24148268"
CONCEPT = "24081999"
FORBIDDEN = {"23794113", "23842296", "23940666"}
PREVIEW = "frohmanian-tether-sdiff-0.1.6.pdf"
FILES = [
    "frohmanian-tether-sdiff-0.1.6.pdf",
    "frohmanian-tether-sdiff-0.1.6.tex",
    "frohmanian-tether-sdiff-0.1.6-manuscript-source.zip",
    "frohmanian-tether-sdiff-0.1.6-source.zip",
    "axioms.txt",
    "print_axioms.txt",
    "CERTIFICATE.md",
    "README.md",
    "SHA256SUMS",
]
UA = "GrokBot/1.0 coadjoint-sdiff-20261111"

def req(method, url, data=None, headers=None, raw=False, timeout=180):
    h = {"Authorization": f"Bearer {TOKEN}", "Accept": "application/json", "User-Agent": UA}
    if headers:
        h.update(headers)
    body = data
    if data is not None and not raw and not isinstance(data, (bytes, bytearray)):
        body = json.dumps(data).encode()
        h["Content-Type"] = "application/json"
    r = urllib.request.Request(url, data=body, headers=h, method=method)
    try:
        with urllib.request.urlopen(r, timeout=timeout) as resp:
            payload = resp.read()
            ctype = resp.headers.get("Content-Type", "")
            if "json" in ctype:
                return json.loads(payload.decode() or "null"), resp.status
            return payload, resp.status
    except urllib.error.HTTPError as e:
        err = e.read().decode()
        raise SystemExit(f"{method} {url} -> {e.code}: {err[:3000]}")

def get(did):
    d, _ = req("GET", f"{API}/deposit/depositions/{did}")
    return d

if DID in FORBIDDEN:
    sys.exit(f"Refusing to touch forbidden id {DID}")
draft = get(DID)
print(f"draft {DID}: state={draft.get('state')} submitted={draft.get('submitted')} concept={draft.get('conceptrecid')}")
if draft.get("submitted"):
    sys.exit("Refusing to overwrite an already-submitted record as if it were a draft")
if str(draft["id"]) != DID:
    sys.exit(f"id mismatch {draft['id']}")
if str(draft.get("conceptrecid")) != CONCEPT:
    sys.exit(f"unexpected concept {draft.get('conceptrecid')}")
title = (draft.get("metadata") or {}).get("title", "")
if "Frohmanian Tether Bound" not in title:
    sys.exit(f"unexpected title: {title!r}")

cur = dict(draft.get("metadata") or {})
incoming = dict(META["metadata"])
if cur.get("license") and "apache" in str(cur.get("license")).lower():
    incoming["license"] = cur["license"]
    print("keeping existing license slug:", cur["license"])
cur.update(incoming)
cur.pop("doi", None)
cur.pop("prereserve_doi", None)
print("Putting metadata...")
draft, _ = req("PUT", f"{API}/deposit/depositions/{DID}", {"metadata": cur})

files = draft.get("files") or []
for f in files:
    file_id = f.get("id") or f.get("file_id")
    key = f.get("filename") or f.get("key") or f.get("name")
    print(f"Deleting {key} ({file_id})")
    req("DELETE", f"{API}/deposit/depositions/{DID}/files/{file_id}")

draft = get(DID)
bucket = (draft.get("links") or {}).get("bucket")
if not bucket:
    sys.exit("no bucket link")
for name in FILES:
    path = ROOT / name
    if not path.is_file():
        sys.exit(f"missing file {path}")
    print(f"Uploading {name} ({path.stat().st_size} bytes)")
    data = path.read_bytes()
    req(
        "PUT",
        f"{bucket}/{name}",
        data=data,
        headers={"Content-Type": "application/octet-stream"},
        raw=True,
        timeout=300,
    )

print("Setting default_preview to", PREVIEW)
try:
    h = {"Authorization": f"Bearer {TOKEN}", "Accept": "application/vnd.inveniordm.v1+json", "User-Agent": UA}
    r = urllib.request.Request(f"{API}/records/{DID}/draft", headers=h, method="GET")
    with urllib.request.urlopen(r, timeout=60) as resp:
        rd = json.loads(resp.read().decode())
    rd.setdefault("files", {})["default_preview"] = PREVIEW
    rd["files"]["order"] = FILES
    body = {k: rd[k] for k in ("access", "files", "metadata", "pids", "custom_fields") if k in rd}
    h2 = dict(h)
    h2["Content-Type"] = "application/json"
    r2 = urllib.request.Request(
        f"{API}/records/{DID}/draft",
        data=json.dumps(body).encode(),
        headers=h2,
        method="PUT",
    )
    with urllib.request.urlopen(r2, timeout=60) as resp:
        rd2 = json.loads(resp.read().decode())
    print("preview now", (rd2.get("files") or {}).get("default_preview"))
except Exception as e:
    print("WARNING: preview set failed:", type(e).__name__, e)

print("Publishing", DID, "...")
published, status = req("POST", f"{API}/deposit/depositions/{DID}/actions/publish")
print("publish status", status)
md = published.get("metadata") or {}
html = (published.get("links") or {}).get("html") or f"https://zenodo.org/records/{DID}"
doi = md.get("doi") or f"10.5281/zenodo.{DID}"
print("PUBLISHED")
print("id=", published.get("id"))
print("concept=", published.get("conceptrecid"))
print("state=", published.get("state"), "submitted=", published.get("submitted"))
print("doi=", doi)
print("conceptdoi=", published.get("conceptdoi"))
print("html=", html)
print("version=", md.get("version"), "date=", md.get("publication_date"))
print("files=", [f.get("filename") or f.get("key") for f in published.get("files") or []])
out = {
    "id": published.get("id"),
    "conceptrecid": published.get("conceptrecid"),
    "doi": doi,
    "conceptdoi": published.get("conceptdoi"),
    "html": html,
    "state": published.get("state"),
    "submitted": published.get("submitted"),
    "version": md.get("version"),
    "publication_date": md.get("publication_date"),
    "files": [f.get("filename") or f.get("key") for f in published.get("files") or []],
}
(ROOT / "PUBLISHED.json").write_text(json.dumps(out, indent=2))
print("Wrote", ROOT / "PUBLISHED.json")
