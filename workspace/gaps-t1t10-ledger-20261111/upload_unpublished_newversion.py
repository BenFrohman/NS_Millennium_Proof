#!/usr/bin/env python3
"""Create an UNPUBLISHED new version of Zenodo concept 22835068 (record 22835069).
Does NOT publish. Requires ZENODO_ACCESS_TOKEN.
Does not touch drafts 23940666, 23794113, or 23842296.
"""
import json, os, sys, time
from pathlib import Path
import urllib.request

ROOT = Path(__file__).resolve().parent
TOKEN = os.environ.get("ZENODO_ACCESS_TOKEN")
if not TOKEN:
    sys.exit("ZENODO_ACCESS_TOKEN is not set; refusing to continue.")
API = "https://zenodo.org/api"
PARENT = "22835069"  # published version of the gaps concept
FORBIDDEN = {"23940666", "23794113", "23842296"}

def req(method, url, data=None, headers=None, raw=False):
    h = {"Authorization": f"Bearer {TOKEN}", "Accept": "application/json"}
    if headers:
        h.update(headers)
    body = data
    if data is not None and not raw and not isinstance(data, (bytes, bytearray)):
        body = json.dumps(data).encode()
        h["Content-Type"] = "application/json"
    r = urllib.request.Request(url, data=body, headers=h, method=method)
    try:
        with urllib.request.urlopen(r) as resp:
            payload = resp.read()
            ctype = resp.headers.get("Content-Type", "")
            if "json" in ctype:
                return json.loads(payload.decode() or "null")
            return payload
    except urllib.error.HTTPError as e:
        err = e.read().decode()
        raise SystemExit(f"{method} {url} -> {e.code}: {err[:2000]}")

# 0. Safety: do not operate on forbidden drafts
# 1. Start new version from the published record
import os
if os.environ.get("EXISTING_DRAFT"):
    draft = req("GET", f"{API}/deposit/depositions/{os.environ['EXISTING_DRAFT']}")
else:
    print(f"Creating newversion of {PARENT} (unpublished)...")
    created = req("POST", f"{API}/deposit/depositions/{PARENT}/actions/newversion")
    # The new draft is usually at created["links"]["latest_draft"]
    draft_url = (created.get("links") or {}).get("latest_draft")
    if not draft_url:
        # fallback: follow concept
        raise SystemExit(f"No latest_draft link in newversion response: {json.dumps(created)[:1500]}")
    draft = req("GET", draft_url)
did = str(draft["id"])
print(f"Draft id: {did}")
if did in FORBIDDEN:
    raise SystemExit(f"Refusing to touch forbidden draft {did}")

# 2. Metadata
meta = json.loads((ROOT / "zenodo-metadata.json").read_text())
print("Putting metadata...")
draft = req("PUT", f"{API}/deposit/depositions/{did}", meta)

# 3. Replace files: delete inherited files, then upload new ones in preview-first order
files = draft.get("files") or []
for f in files:
    file_id = f.get("id") or f.get("file_id")
    key = f.get("filename") or f.get("key") or f.get("name")
    print(f"Deleting inherited file {key} ({file_id})")
    req("DELETE", f"{API}/deposit/depositions/{did}/files/{file_id}")

upload_order = [
    "main.pdf",  # preview
    "main.tex",
    "00_COVER_Official_Proposed_Theorem.pdf",
    "README.md",
    "LICENSE",
    "NOTICE",
    "SHA256SUMS",
    "sdiff_AxiomAudit_run43105941627.txt",
    "sdiff_print_axioms_run43105941627.txt",
    "fefferman_AxiomAudit_v1.5.0.txt",
    "NS_CI_audit_excerpt_run43047743968.txt",
]
bucket = (draft.get("links") or {}).get("bucket")
if not bucket:
    draft = req("GET", f"{API}/deposit/depositions/{did}")
    bucket = draft["links"]["bucket"]
for name in upload_order:
    path = ROOT / name
    print(f"Uploading {name} ({path.stat().st_size} bytes)")
    data = path.read_bytes()
    req(
        "PUT",
        f"{bucket}/{name}",
        data=data,
        headers={"Content-Type": "application/octet-stream"},
        raw=True,
    )

# 4. Do NOT publish. Re-fetch and print the deposit URL.
draft = req("GET", f"{API}/deposit/depositions/{did}")
html = (draft.get("links") or {}).get("html") or f"https://zenodo.org/deposit/{did}"
state = draft.get("state") or draft.get("status")
submitted = draft.get("submitted")
print("UNPUBLISHED DRAFT READY")
print(f"id={did}")
print(f"state={state} submitted={submitted}")
print(f"html={html}")
print(f"files={[f.get('filename') or f.get('key') for f in draft.get('files') or []]}")
(ROOT / "DRAFT_RESULT.json").write_text(json.dumps({
    "id": did, "html": html, "state": state, "submitted": submitted,
    "doi": (draft.get("metadata") or {}).get("prereserve_doi"),
}, indent=2))
print("Wrote DRAFT_RESULT.json")
