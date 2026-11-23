#!/usr/bin/env python3
"""Create unsubmitted v1.3 Zenodo drafts from official CI run 44049293092.
Never publishes. Never prints the access token.
"""
import hashlib, json, os, sys, time, urllib.error, urllib.parse, urllib.request
from pathlib import Path

TOKEN = os.environ["ZENODO_ACCESS_TOKEN"]
API = "https://zenodo.org/api"
PACK = Path("/workspace/tether-v13-work/zenodo-v13/pack")
META = Path("/workspace/tether-v13-work/zenodo-v13/meta")
OUT = Path("/workspace/tether-v13-work/zenodo-v13/draft_result.json")

def req(method, url, data=None, content_type=None, retries=6):
    headers = {"Authorization": f"Bearer {TOKEN}", "Accept": "application/json"}
    body = data
    if isinstance(data, (dict, list)) and content_type is None:
        body = json.dumps(data).encode()
        headers["Content-Type"] = "application/json"
    elif content_type:
        headers["Content-Type"] = content_type
    last = None
    for i in range(retries):
        try:
            r = urllib.request.Request(url, data=body, headers=headers, method=method)
            with urllib.request.urlopen(r, timeout=120) as resp:
                raw = resp.read()
                if not raw:
                    return {}, dict(resp.headers), resp.status
                try:
                    return json.loads(raw), dict(resp.headers), resp.status
                except Exception:
                    return {"_raw": raw[:500].decode("utf-8", "replace")}, dict(resp.headers), resp.status
        except urllib.error.HTTPError as e:
            err = e.read().decode("utf-8", "replace")
            last = (e.code, err)
            if e.code in (429, 500, 502, 503, 504) and i < retries - 1:
                time.sleep(3 * (i + 1))
                continue
            raise RuntimeError(f"HTTP {e.code} {method} {url}: {err[:800]}") from None
        except Exception as e:
            last = (type(e).__name__, str(e))
            if i < retries - 1:
                time.sleep(2 * (i + 1))
                continue
            raise
    raise RuntimeError(f"failed {method} {url}: {last}")

def get(url):
    return req("GET", url)[0]

def post(url, data=None):
    return req("POST", url, data=data)[0]

def put(url, data=None, content_type=None):
    return req("PUT", url, data=data, content_type=content_type)[0]

def delete(url):
    return req("DELETE", url)[0]

CREATOR = {
    "name": "Frohman, Benjamin Stanley",
    "affiliation": "Independent Researcher, Texas, United States",
    "orcid": "0009-0006-7068-3718",
}
COMMIT = "0dc35f3c74d5ca9ef30e5ad7921a10f610569c3b"
RUN = "44049293092"
REPO = "https://github.com/BenFrohman/frohmanian-tether-conditional-regularity"

SPECS = [
    {
        "key": "unified",
        "latest": 24301283,
        "concept": "24079622",
        "title": "Geometric Phase-Space Completion and Conditional Global Regularity for the 3D Incompressible Navier–Stokes Equations",
        "upload_type": "publication",
        "publication_type": "preprint",
        "keywords": ["Navier-Stokes", "Frohmanian Symplectic Tether", "conditional regularity", "Beale-Kato-Majda", "Lean 4"],
        "related": [
            {"identifier": "https://github.com/BenFrohman/NS_Millennium_Proof", "relation": "isSupplementedBy", "scheme": "url"},
            {"identifier": REPO, "relation": "isSupplementedBy", "scheme": "url"},
            {"identifier": f"{REPO}/commit/{COMMIT}", "relation": "isSupplementTo", "resource_type": "software", "scheme": "url"},
            {"identifier": f"{REPO}/actions/runs/{RUN}", "relation": "isSupplementTo", "resource_type": "software", "scheme": "url"},
            {"identifier": "10.5281/zenodo.24080309", "relation": "isSupplementedBy", "resource_type": "publication-preprint", "scheme": "doi"},
            {"identifier": "10.5281/zenodo.24102968", "relation": "isSupplementedBy", "resource_type": "publication-preprint", "scheme": "doi"},
        ],
        "files": [
            "Frohmanian_Tether_Unified.pdf",
            "Frohmanian_Tether_Unified.tex",
            "provenance-stamp-official-44049293092.tex",
            "certificate-block.tex",
            "references.bib",
            "NOTICE",
            "LICENSE",
            "LICENSE-paper",
            "Conditional_BKM_Continuation.pdf",
            "Conditional_BKM_Continuation.tex",
            "Littlewood_Paley_Conditional_and_SmallData.pdf",
            "Littlewood_Paley_Conditional_and_SmallData.tex",
            "Frohmanian_Tether_Full_Expanded.pdf",
            "Frohmanian_Tether_Full_Expanded.tex",
            "frohmanian-tether-conditional-regularity-0dc35f3-source.tar.gz",
            "lake-certificate-kernel-push-44049293092-0dc35f3.tar.gz",
            "MANIFEST_tether.txt",
        ],
        "preview": "Frohmanian_Tether_Unified.pdf",
    },
    {
        "key": "vacuity",
        "latest": 24301600,
        "concept": "24102968",
        "title": "Vacuity and model-adequacy findings in a Lean formalization of conditional Navier–Stokes regularity",
        "upload_type": "publication",
        "publication_type": "other",
        "keywords": ["Lean 4", "Mathlib", "formal verification", "vacuity", "model adequacy", "Navier-Stokes", "Beale-Kato-Majda", "erratum"],
        "related": [
            {"identifier": "10.5281/zenodo.24079622", "relation": "isSupplementTo", "resource_type": "publication-preprint", "scheme": "doi"},
            {"identifier": "10.5281/zenodo.24080309", "relation": "isSupplementTo", "resource_type": "publication-preprint", "scheme": "doi"},
            {"identifier": REPO, "relation": "isSupplementTo", "resource_type": "software", "scheme": "url"},
            {"identifier": f"{REPO}/commit/{COMMIT}", "relation": "isSupplementTo", "resource_type": "software", "scheme": "url"},
            {"identifier": f"{REPO}/actions/runs/{RUN}", "relation": "isSupplementTo", "resource_type": "software", "scheme": "url"},
        ],
        "files": [
            "vacuity_audit.pdf",
            "vacuity_audit.tex",
            "vacuity_audit_latex_source.zip",
            "provenance-stamp-official-44049293092.tex",
            "certificate-block.tex",
            "NOTICE",
            "LICENSE",
            "LICENSE-paper",
            "frohmanian-tether-conditional-regularity-0dc35f3-source.tar.gz",
            "lake-certificate-kernel-push-44049293092-0dc35f3.tar.gz",
            "MANIFEST_vacuity.txt",
        ],
        "preview": "vacuity_audit.pdf",
    },
    {
        "key": "pillars",
        "latest": 24301607,
        "concept": "24080309",
        "title": "Three Pillars of 3D Incompressible Navier–Stokes Theory: Kato Local Existence, Fujita–Kato Small-Data Globality, and the Beale–Kato–Majda Continuation Criterion (While the Roof Remains Open)",
        "upload_type": "publication",
        "publication_type": "preprint",
        "keywords": ["Navier-Stokes", "Kato local existence", "Fujita-Kato", "Beale-Kato-Majda", "fluid dynamics"],
        "related": [
            {"identifier": REPO, "relation": "isSupplementedBy", "resource_type": "software", "scheme": "url"},
            {"identifier": f"{REPO}/commit/{COMMIT}", "relation": "isSupplementTo", "resource_type": "software", "scheme": "url"},
            {"identifier": f"{REPO}/actions/runs/{RUN}", "relation": "isSupplementTo", "resource_type": "software", "scheme": "url"},
            {"identifier": "10.5281/zenodo.24102968", "relation": "isSupplementedBy", "resource_type": "publication-preprint", "scheme": "doi"},
        ],
        "files": [
            "Three_Pillars_NS.pdf",
            "Three_Pillars_NS.tex",
            "provenance-stamp-official-44049293092.tex",
            "certificate-block.tex",
            "NOTICE",
            "LICENSE",
            "LICENSE-paper",
            "Littlewood_Paley_Conditional_and_SmallData.pdf",
            "Littlewood_Paley_Conditional_and_SmallData.tex",
            "frohmanian-tether-conditional-regularity-0dc35f3-source.tar.gz",
            "lake-certificate-kernel-push-44049293092-0dc35f3.tar.gz",
            "MANIFEST_three_pillars.txt",
        ],
        "preview": "Three_Pillars_NS.pdf",
    },
]


def wait_draft(url, timeout=90):
    t0 = time.time()
    last = None
    while time.time() - t0 < timeout:
        last = get(url)
        if last.get("id") and last.get("state") in ("unsubmitted", "draft") and last.get("submitted") is False:
            return last
        # sometimes first GET is empty-ish
        if last.get("id") and last.get("state") == "unsubmitted":
            return last
        time.sleep(2)
    return last


def delete_all_files(draft):
    files = draft.get("files") or []
    for f in list(files):
        fid = f.get("id") or f.get("file_id")
        # prefer links.self
        url = (f.get("links") or {}).get("self")
        if not url:
            url = f"{API}/deposit/depositions/{draft['id']}/files/{fid}"
        print(f"  delete file {f.get('filename') or f.get('key') or fid}")
        try:
            delete(url)
        except Exception as e:
            print("   delete warn:", e)
    time.sleep(1)
    refreshed = get(f"{API}/deposit/depositions/{draft['id']}")
    leftover = refreshed.get("files") or []
    if leftover:
        raise RuntimeError("files still present after delete: " + str([x.get("filename") or x.get("key") for x in leftover]))
    return refreshed


def upload_files(draft, filenames, preview):
    bucket = (draft.get("links") or {}).get("bucket")
    if not bucket:
        raise RuntimeError("no bucket link")
    # PDF first
    ordered = list(filenames)
    if preview in ordered:
        ordered = [preview] + [n for n in ordered if n != preview]
    for name in ordered:
        path = PACK / name
        data = path.read_bytes()
        url = bucket.rstrip("/") + "/" + urllib.parse.quote(name)
        print(f"  upload {name} ({len(data)} bytes)")
        put(url, data=data, content_type="application/octet-stream")
    refreshed = get(f"{API}/deposit/depositions/{draft['id']}")
    got = [f.get("filename") or f.get("key") for f in (refreshed.get("files") or [])]
    missing = [n for n in filenames if n not in got]
    if missing:
        raise RuntimeError(f"missing uploaded files: {missing}; got {got}")
    return refreshed


def set_metadata(draft, spec):
    desc = (META / f"{spec['key']}_description.html").read_text()
    notes = (META / f"{spec['key']}_notes.txt").read_text()
    meta = {
        "title": spec["title"],
        "upload_type": spec["upload_type"],
        "publication_type": spec["publication_type"],
        "access_right": "open",
        "license": "cc-by-4.0",
        "version": "v1.3",
        "publication_date": "2026-11-17",
        "creators": [CREATOR],
        "description": desc,
        "notes": notes,
        "keywords": spec["keywords"],
        "related_identifiers": spec["related"],
        "language": "eng",
    }
    # try default preview if accepted
    payload = {"metadata": meta}
    url = f"{API}/deposit/depositions/{draft['id']}"
    updated = put(url, payload)
    return updated


def wording_ok(text):
    bad = ["unpublished", "not been published", "not published", "/workspace/", "PENDING-CERTIFYING", "42614257456", "CC0", "CCO"]
    # 'draft' as a record-status word is also banned, but "draft" might slip; check
    low = text.lower()
    hits = [b for b in bad if b.lower() in low]
    if "draft" in low:
        hits.append("draft")
    return hits


def process(spec):
    print("=" * 70)
    print(f"newversion from {spec['latest']} concept {spec['concept']} ({spec['key']})")
    nv = post(f"{API}/deposit/depositions/{spec['latest']}/actions/newversion")
    ld = (nv.get("links") or {}).get("latest_draft")
    if not ld:
        # sometimes the response IS the draft
        if nv.get("state") == "unsubmitted":
            ld = (nv.get("links") or {}).get("self")
        else:
            # try following from published again
            pub = get(f"{API}/deposit/depositions/{spec['latest']}")
            ld = (pub.get("links") or {}).get("latest_draft")
    if not ld:
        raise RuntimeError(f"no latest_draft after newversion: keys={list(nv.keys())} links={nv.get('links')}")
    print("  latest_draft", ld)
    draft = wait_draft(ld)
    if not draft or draft.get("submitted"):
        raise RuntimeError(f"draft not unsubmitted: state={draft.get('state') if draft else None} id={draft.get('id') if draft else None}")
    did = draft["id"]
    if str(draft.get("conceptrecid")) != str(spec["concept"]):
        raise RuntimeError(f"concept mismatch: {draft.get('conceptrecid')} != {spec['concept']}")
    print(f"  draft id {did} state={draft.get('state')} submitted={draft.get('submitted')} concept={draft.get('conceptrecid')}")
    if did == spec["latest"]:
        raise RuntimeError("newversion returned the published record, not a new draft")

    draft = delete_all_files(draft)
    draft = upload_files(draft, spec["files"], spec["preview"])
    draft = set_metadata(draft, spec)

    # verify
    draft = get(f"{API}/deposit/depositions/{did}")
    meta = draft.get("metadata") or {}
    files = draft.get("files") or []
    names = [f.get("filename") or f.get("key") for f in files]
    print("  after update: state", draft.get("state"), "submitted", draft.get("submitted"), "version", meta.get("version"))
    print("  license", meta.get("license"), "date", meta.get("publication_date"))
    print("  creators", meta.get("creators"))
    print("  files:", names)
    if draft.get("submitted") or draft.get("state") in ("done", "published"):
        raise RuntimeError("ERROR: draft appears submitted/published; aborting further publish risk")
    hits = wording_ok((meta.get("description") or "") + "\n" + (meta.get("notes") or "") + "\n" + (meta.get("version") or "") + "\n" + (meta.get("title") or ""))
    if hits:
        raise RuntimeError(f"banned wording in metadata: {hits}")
    # license id might be cc-by-4.0 or a dict
    lic = meta.get("license")
    lic_id = lic.get("id") if isinstance(lic, dict) else lic
    if lic_id not in ("cc-by-4.0", "CC-BY-4.0", "cc-by-4.0"):
        print("  WARN license id is", lic)
    aff = ((meta.get("creators") or [{}])[0].get("affiliation") or "")
    if "Texas" not in aff:
        raise RuntimeError(f"affiliation missing Texas: {aff}")
    if "Copyright (c) 2026 Benjamin Stanley Frohman" not in (meta.get("description") or ""):
        raise RuntimeError("copyright line missing from description")
    if spec["preview"] not in names:
        raise RuntimeError("preview PDF missing")
    # first file hopefully preview - report order
    return {
        "key": spec["key"],
        "concept": spec["concept"],
        "parent": spec["latest"],
        "draft_id": did,
        "state": draft.get("state"),
        "submitted": draft.get("submitted"),
        "version": meta.get("version"),
        "license": lic,
        "publication_date": meta.get("publication_date"),
        "creators": meta.get("creators"),
        "files": names,
        "html": (draft.get("links") or {}).get("html"),
        "latest_draft_html": (draft.get("links") or {}).get("latest_draft_html"),
        "doi": (meta.get("prereserve_doi") or {}).get("doi"),
        "run_id": RUN,
        "commit": COMMIT,
        "preview": spec["preview"],
    }


def main():
    results = []
    errors = []
    for spec in SPECS:
        try:
            results.append(process(spec))
        except Exception as e:
            print(f"FAILED {spec['key']}: {e}")
            errors.append({"key": spec["key"], "error": str(e)})
            # continue other concepts
    payload = {"run_id": RUN, "commit": COMMIT, "results": results, "errors": errors}
    OUT.write_text(json.dumps(payload, indent=2) + "\n")
    print("\n===== SUMMARY =====")
    print(json.dumps(payload, indent=2))
    if errors and not results:
        sys.exit(1)

if __name__ == "__main__":
    main()
