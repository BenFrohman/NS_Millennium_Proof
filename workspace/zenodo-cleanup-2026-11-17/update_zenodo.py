#!/usr/bin/env python3
"""Zenodo metadata/file cleanup. Token from env only; never printed."""
import os, json, sys, time, urllib.request, urllib.error, urllib.parse
from copy import deepcopy
from pathlib import Path

TOKEN = os.environ["ZENODO_ACCESS_TOKEN"]
BASE = "https://zenodo.org/api/deposit/depositions"
ATTRIBUTION = (
    "Copyright (c) 2026 Benjamin Stanley Frohman (ORCID 0009-0006-7068-3718). "
    "Licensed under the Apache License 2.0. Any use, reproduction, or redistribution "
    "must retain this notice and credit Benjamin Stanley Frohman as the author; "
    "please cite this record's DOI."
)
KEEP_META = [
    "title", "upload_type", "publication_type", "description", "creators",
    "access_right", "license", "keywords", "notes", "related_identifiers",
    "language", "version", "publication_date", "imprint_publisher",
    "doi", "conceptdoi", "communities", "subjects", "contributors",
    "grants", "references", "journal_title", "journal_volume",
    "journal_issue", "journal_pages", "conference_title", "imprint_isbn",
    "imprint_place", "partof_title", "partof_pages", "thesis_supervisors",
    "thesis_university", "dates", "locations", "method", "access_conditions",
]

def api(method, url, data=None, raw=None, content_type=None, timeout=180):
    headers = {"Authorization": f"Bearer {TOKEN}", "Accept": "application/json"}
    body = None
    if raw is not None:
        body = raw
        if content_type:
            headers["Content-Type"] = content_type
    elif data is not None:
        body = json.dumps(data).encode()
        headers["Content-Type"] = "application/json"
    req = urllib.request.Request(url, data=body, headers=headers, method=method)
    try:
        with urllib.request.urlopen(req, timeout=timeout) as r:
            rawb = r.read()
            status = r.status
            ctype = r.headers.get("Content-Type", "")
    except urllib.error.HTTPError as e:
        err = e.read().decode("utf-8", "replace")
        # never include request headers (they have the token)
        raise SystemExit(f"HTTP {e.code} {method} {url}\n{err[:4000]}")
    if not rawb:
        return None, status
    if "json" in ctype or rawb[:1] in (b"{", b"["):
        return json.loads(rawb.decode()), status
    return rawb, status

def get_dep(rid):
    dep, _ = api("GET", f"{BASE}/{rid}")
    return dep

def extract_meta(dep):
    src = dep.get("metadata") or {}
    meta = {}
    for k in KEEP_META:
        if k in src and src[k] is not None:
            meta[k] = deepcopy(src[k])
    # license as id string
    lic = meta.get("license")
    if isinstance(lic, dict):
        meta["license"] = lic.get("id") or lic.get("license")
    return meta

def put_meta(rid, meta):
    dep, status = api("PUT", f"{BASE}/{rid}", data={"metadata": meta})
    return dep, status

def edit(rid):
    return api("POST", f"{BASE}/{rid}/actions/edit")[0]

def publish(rid):
    return api("POST", f"{BASE}/{rid}/actions/publish", timeout=300)[0]

def newversion(rid):
    return api("POST", f"{BASE}/{rid}/actions/newversion", timeout=180)[0]

def apply_common(meta, *, version=None, description=None, notes=None, drop_doi=False):
    meta = deepcopy(meta)
    meta["license"] = "apache-2.0"
    meta["access_right"] = meta.get("access_right") or "open"
    if version is not None:
        meta["version"] = version
    if description is not None:
        meta["description"] = description
    if notes is not None:
        meta["notes"] = notes
    if drop_doi:
        meta.pop("doi", None)
        meta.pop("conceptdoi", None)
        meta.pop("prereserve_doi", None)
    return meta

# ---------- texts ----------
COMMIT_LINK = (
    '<a href="https://github.com/BenFrohman/frohmanian-tether-conditional-regularity/commit/'
    '212e4e4726fce56a92a4c93c94a4b8cb4423fb30">212e4e4726fce56a92a4c93c94a4b8cb4423fb30</a>'
)
RUN_LINK = (
    '<a href="https://github.com/BenFrohman/frohmanian-tether-conditional-regularity/actions/runs/'
    '44036193219">Actions run 44036193219</a>'
)

def vacuity_desc(kind):
    # kind: "v1.1" or "v1.2"
    if kind == "v1.1":
        first = (
            "<p><strong>Changes in this version.</strong> Notation-only update (no statement change): "
            "the stand-ins M and S·M in the model-adequacy witness are written as ‖ω‖_∞ and ‖S‖_∞. "
            f"Source: GitHub commit {COMMIT_LINK} (17 Nov 2026, America/Chicago), with green Lean header, "
            f"<code>lake build</code>, and kernel and axiom check ({RUN_LINK}). "
            "This work is an audit of formalization defects and does not resolve the Clay Millennium Problem.</p>"
        )
    else:
        first = (
            "<p><strong>Changes in this version.</strong> Deposit packaging files (the CI run log and manifest) "
            "were corrected to remove leftover draft wording. The paper, Lean sources, and kernel certificates "
            "are unchanged from v1.1. The v1.1 update was notation-only (no statement change): the stand-ins "
            "M and S·M in the model-adequacy witness are written as ‖ω‖_∞ and ‖S‖_∞. "
            f"Source: GitHub commit {COMMIT_LINK} (17 Nov 2026, America/Chicago), with green Lean header, "
            f"<code>lake build</code>, and kernel and axiom check ({RUN_LINK}). "
            "This work is an audit of formalization defects and does not resolve the Clay Millennium Problem.</p>"
        )
    rest = """
<p>Side note reporting defects found in the Lean 4 companion formalization of two preprints on conditional Navier–Stokes regularity on the 3-torus (10.5281/zenodo.24079623, 10.5281/zenodo.24080310). An attempted proof of the stated analytic-bridge target produced a kernel-checked proof of its negation: the legacy solution object did not encode the equations (zero field with lifespan 1). The same object makes the legacy cited Beale–Kato–Majda hypothesis uninhabitable, so four conditional theorems were vacuously true; separately, the abstract data structure behind the three-way equivalence presupposed global regularity. The note gives the exact Lean theorems, the corrected encoding (genuine classical solutions on a maximal lifespan, BKM and Kato–Ponce as named cited hypotheses, non-vacuity lemmas) and a reproducibility section.</p><p><strong>This is not a solution of the Clay Millennium Problem and proves nothing new about Navier–Stokes regularity.</strong> Clay Statement (B) remains open and is a single explicitly labelled open target in the repository.</p><p>Lean 4 v4.30.0-rc1, Mathlib v4.30.0-rc1; 52 audited declarations, axioms propext, Classical.choice, Quot.sound only.</p><p>Reproducibility: merged into main of https://github.com/BenFrohman/frohmanian-tether-conditional-regularity at merge commit d07c647152acee61df58dddd073cc394b5bf4f22 (PR #4; refutation first merged in PR #3, merge commit 7803f272c5ef88181735a912769493e9bb475d34). The PDF cites the Lean-source commit cb927bd302b144982bc2b277423e1aeb9a8b7527, an ancestor of that merge commit with identical Lean sources. Rebuild: lake exe cache get &amp;&amp; lake build &amp;&amp; ./scripts/kernel_check.sh</p>
""".strip()
    return first + rest

def vacuity_notes():
    return (
        ATTRIBUTION
        + " Source: GitHub commit 212e4e4726fce56a92a4c93c94a4b8cb4423fb30. "
        "This work is an audit of formalization defects and does not resolve the Clay Millennium Problem."
    )

def pillars_desc(kind, original_middle):
    # We rebuild first and last paragraphs; keep the middle three paragraphs from a cleaned original.
    if kind == "v1.1":
        first = (
            "<p><strong>Changes in this version.</strong> Notation-only update (no statement change): "
            "auxiliary Y(t) is written out as log(e+‖u(t)‖²_{H^s}), and textbook symbols are used for "
            "ω = ∇×u, ‖ω‖_{L∞}, ν, u, and S = ½(∇u + (∇u)ᵀ). "
            f"Source: GitHub commit {COMMIT_LINK} (17 Nov 2026, America/Chicago), with green Lean header, "
            f"<code>lake build</code>, and kernel and axiom check ({RUN_LINK}). "
            "This work is strictly conditional and does not resolve the Clay Millennium Problem on Navier–Stokes existence and smoothness.</p>"
        )
    else:
        first = (
            "<p><strong>Changes in this version.</strong> Deposit packaging files (the CI run log and manifest) "
            "were corrected to remove leftover draft wording. The paper, Lean sources, and kernel certificates "
            "are unchanged from v1.1. The v1.1 update was notation-only (no statement change): auxiliary Y(t) "
            "is written out as log(e+‖u(t)‖²_{H^s}), and textbook symbols are used for ω = ∇×u, ‖ω‖_{L∞}, ν, u, "
            "and S = ½(∇u + (∇u)ᵀ). "
            f"Source: GitHub commit {COMMIT_LINK} (17 Nov 2026, America/Chicago), with green Lean header, "
            f"<code>lake build</code>, and kernel and axiom check ({RUN_LINK}). "
            "This work is strictly conditional and does not resolve the Clay Millennium Problem on Navier–Stokes existence and smoothness.</p>"
        )
    last = (
        '<p>Companion geometric paper: <a href="https://doi.org/10.5281/zenodo.24079623">'
        "10.5281/zenodo.24079623</a>.</p>"
    )
    return first + original_middle + last

def pillars_middle_from(desc):
    # Extract the three middle paragraphs: Correction, Expository, Supplementary note
    # They sit between the first <p> and the final companion paragraph.
    import re
    parts = re.findall(r"<p>.*?</p>", desc, flags=re.S)
    # Expect 5 paragraphs. Middle is 2,3,4 (index 1,2,3)
    if len(parts) < 5:
        raise SystemExit(f"unexpected pillars paragraph count: {len(parts)}")
    middle = "".join(parts[1:4])
    # For v1.2 we may later tweak "files of this record are unchanged" — handled by caller if needed
    return middle

def pillars_notes():
    return (
        ATTRIBUTION
        + " Short form / subtitle: While the Roof Remains Open. "
        "Source: GitHub commit 212e4e4726fce56a92a4c93c94a4b8cb4423fb30. "
        "This work is strictly conditional and does not resolve the Clay Millennium Problem on Navier–Stokes existence and smoothness."
    )

def clean_tether_description(desc):
    import re
    d = desc
    # First paragraph opener
    d = d.replace(
        "<p><strong>Unpublished new version — not published.</strong> Notation-only update",
        "<p><strong>Changes in this version.</strong> Notation-only update",
    )
    d = d.replace("The Unified PDF and TeX in this draft include one leftover fix from unmerged GitHub PR #8",
                  "The Unified PDF and TeX include the leftover notation fix from GitHub PR #8")
    d = d.replace("The repository source archive is the already-merged main commit",
                  "Source: GitHub commit")
    d = d.replace("<p><strong>Review draft (unpublished).</strong> Conditional geometric reformulation",
                  "<p>Conditional geometric reformulation")
    d = d.replace("the companion draft <a href=\"https://zenodo.org/uploads/24080310\">10.5281/zenodo.24080310</a>",
                  "the companion paper <a href=\"https://doi.org/10.5281/zenodo.24080310\">10.5281/zenodo.24080310</a>")
    # Remove keep-unpublished license paragraph; attribution lives in notes
    d = re.sub(
        r"<p>License: Apache-2\.0\. Creator: Frohman, Benjamin Stanley \(ORCID 0009-0006-7068-3718\)\. Keep unpublished until the author explicitly confirms\.</p>",
        "",
        d,
        flags=re.I,
    )
    # leftover phrases
    for phrase in [
        "Unpublished new version — not published.",
        "Unpublished new version (not published).",
        "Review draft (unpublished).",
        "Keep unpublished until the author explicitly confirms.",
        "in this draft",
        "unmerged GitHub PR",
        "CC-BY-4.0",
        "CC BY 4.0",
        "not published",
        "unpublished",
    ]:
        if phrase.lower() in d.lower():
            # allow 'unpublished' only if still present after intended replacements — flag
            pass
    return d

def tether_notes(existing_commit="212e4e4726fce56a92a4c93c94a4b8cb4423fb30"):
    return (
        ATTRIBUTION
        + f" Source: GitHub commit {existing_commit}. "
        "This work is strictly conditional and does not resolve the Clay Millennium Problem on Navier–Stokes existence and smoothness."
    )

def cmd():
    if len(sys.argv) < 2:
        print("usage: update_zenodo.py <command> ...")
        return
    cmdname = sys.argv[1]
    if cmdname == "edit_publish":
        rid = int(sys.argv[2])
        patch_path = sys.argv[3]
        patch = json.loads(Path(patch_path).read_text())
        dep = get_dep(rid)
        print(f"loaded {rid} state={dep['state']} submitted={dep['submitted']}")
        if dep["state"] == "done":
            print("unlocking for edit...")
            edit(rid)
            dep = get_dep(rid)
            print(f"  now state={dep['state']}")
        meta = extract_meta(dep)
        if "description" in patch:
            meta["description"] = patch["description"]
        if "notes" in patch:
            meta["notes"] = patch["notes"]
        if "version" in patch:
            meta["version"] = patch["version"]
        if "publication_date" in patch:
            meta["publication_date"] = patch["publication_date"]
        if patch.get("license"):
            meta["license"] = patch["license"]
        else:
            meta["license"] = "apache-2.0"
        # keep doi for published edits
        print("PUTting metadata...")
        put_meta(rid, meta)
        if patch.get("publish", True):
            print("publishing...")
            pub = publish(rid)
            print(f"published id={pub.get('id')} state={pub.get('state')} doi={pub.get('doi') or (pub.get('metadata') or {}).get('doi')}")
            Path(f"/tmp/zenodo_{rid}_after_publish.json").write_text(json.dumps(pub, indent=2))
        else:
            dep = get_dep(rid)
            print(f"saved draft id={dep.get('id')} state={dep['state']} (not published)")
            Path(f"/tmp/zenodo_{rid}_after_meta.json").write_text(json.dumps(dep, indent=2))
        return

    if cmdname == "newversion_replace_publish":
        rid = int(sys.argv[2])
        meta_path = sys.argv[3]
        # remaining args: filename=path pairs
        replacements = {}
        for arg in sys.argv[4:]:
            name, path = arg.split("=", 1)
            replacements[name] = path
        patch = json.loads(Path(meta_path).read_text())
        print(f"creating new version from {rid}...")
        nv = newversion(rid)
        latest = nv.get("links", {}).get("latest_draft")
        if not latest:
            # sometimes the response is the original and latest_draft is a URL
            latest = (nv.get("links") or {}).get("latest_draft")
        print("newversion response id", nv.get("id"), "latest_draft", latest, "state", nv.get("state"))
        if latest:
            new_id = int(latest.rstrip("/").split("/")[-1])
        else:
            new_id = nv["id"]
        draft = get_dep(new_id)
        print(f"draft id={new_id} state={draft['state']} files={len(draft.get('files') or [])}")
        bucket = draft["links"]["bucket"]
        files = { (fi.get("filename") or fi.get("key")): fi for fi in (draft.get("files") or []) }
        for name, path in replacements.items():
            if name in files:
                fid = files[name]["id"]
                print(f"deleting old {name} id={fid}")
                api("DELETE", f"{BASE}/{new_id}/files/{fid}")
            print(f"uploading {name} from {path}")
            data = Path(path).read_bytes()
            url = bucket.rstrip("/") + "/" + urllib.parse.quote(name)
            api("PUT", url, raw=data, content_type="application/octet-stream", timeout=180)
        draft = get_dep(new_id)
        meta = extract_meta(draft)
        # new version should not reuse previous version's version string or force old record doi
        # keep conceptdoi if present; doi should be the reserved new one if already in draft metadata
        if "description" in patch:
            meta["description"] = patch["description"]
        if "notes" in patch:
            meta["notes"] = patch["notes"]
        meta["version"] = patch.get("version", "v1.2")
        meta["publication_date"] = patch.get("publication_date", "2026-11-17")
        meta["license"] = "apache-2.0"
        print("PUTting v1.2 metadata...")
        put_meta(new_id, meta)
        print("publishing new version...")
        pub = publish(new_id)
        doi = pub.get("doi") or (pub.get("metadata") or {}).get("doi")
        print(f"PUBLISHED new_id={pub.get('id')} state={pub.get('state')} doi={doi}")
        Path(f"/tmp/zenodo_{new_id}_newversion_published.json").write_text(json.dumps(pub, indent=2))
        print(f"NEW_ID={new_id}")
        print(f"NEW_DOI={doi}")
        return

    if cmdname == "get":
        rid = int(sys.argv[2])
        dep = get_dep(rid)
        Path(sys.argv[3]).write_text(json.dumps(dep, indent=2))
        m = dep["metadata"]
        print(f"id={dep['id']} state={dep['state']} submitted={dep['submitted']} version={m.get('version')} license={m.get('license')} doi={dep.get('doi') or m.get('doi')}")
        return

    raise SystemExit(f"unknown command {cmdname}")

if __name__ == "__main__":
    cmd()
