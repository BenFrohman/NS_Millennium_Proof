#!/usr/bin/env python3
"""Metadata-only Zenodo edits for records approved 2026-11-09.

Never prints the access token. On any failure after entering edit mode,
calls actions/discard so nothing is left half-edited.
"""
from __future__ import annotations

import copy
import json
import os
import sys
import time
import urllib.error
import urllib.request
from pathlib import Path

BASE = "https://zenodo.org/api/deposit/depositions"
ROOT = Path("/workspace/approved-zenodo-fixes-20261109")
OUT_AFTER = ROOT / "after"
OUT_PROPOSED = ROOT / "proposed"
OUT_AFTER.mkdir(parents=True, exist_ok=True)
OUT_PROPOSED.mkdir(parents=True, exist_ok=True)

TOKEN = os.environ.get("ZENODO_ACCESS_TOKEN")
if not TOKEN:
    sys.exit("ZENODO_ACCESS_TOKEN is not set")

NS_NOTE_HTML = (
    "<p><strong>Version 2.3.0 provenance note (updated 2026-11-09, America/Chicago):</strong> "
    "This record is labeled version 2.3.0, but the archived Lean source is the same snapshot as "
    "the v2.2.0 record <a href=\"https://doi.org/10.5281/zenodo.23717084\">10.5281/zenodo.23717084</a>. "
    "The source zip <code>NS_Millennium_Proof-v2.2.0.zip</code> is byte-identical to that earlier "
    "record (MD5 <code>a4cf4e5466f12d4f2d7f46a8610506ba</code>) and matches GitHub tag "
    "<code>v2.2.0</code> / commit "
    "<a href=\"https://github.com/BenFrohman/NS_Millennium_Proof/commit/8a5ec50aa602318c0c611269731e7d41cd30b75b\">"
    "8a5ec50aa602318c0c611269731e7d41cd30b75b</a>. There is no GitHub tag <code>v2.3.0</code>. "
    "The only added file relative to v2.2.0 is the companion PDF "
    "<code>Frohman_NS_Lean_Reduction_Final_2026.pdf</code>. That PDF reports an "
    "<code>NS_Millennium_Proof</code> audit of 470 theorems and names "
    "<code>clay_reduces_to_direction_curvature_bound</code> (in <code>MainTheorem.lean</code>); "
    "neither that declaration nor <code>MainTheorem.lean</code> is present in the bundled source, "
    "whose signed audit is 437 theorems. The 470-theorem count and that named theorem are not "
    "certificates of this archive.</p>"
)

NS_NOTE_TEXT = (
    "Version 2.3.0 provenance note (2026-11-09, America/Chicago): labeled 2.3.0, but the archived "
    "Lean source is the v2.2.0 snapshot (GitHub tag v2.2.0 / commit "
    "8a5ec50aa602318c0c611269731e7d41cd30b75b; zip MD5 a4cf4e5466f12d4f2d7f46a8610506ba). "
    "There is no GitHub tag v2.3.0. The added PDF Frohman_NS_Lean_Reduction_Final_2026.pdf "
    "reports 470 NS_Millennium_Proof theorems and names clay_reduces_to_direction_curvature_bound "
    "in MainTheorem.lean; those are absent from the bundled source, whose signed audit is 437 theorems."
)

SDIFF_CONTACT = (
    "<p>Contact: Benjamin Stanley Frohman &lt;frohmanbenjamin@gmail.com&gt; "
    "(ORCID: <a href=\"https://orcid.org/0009-0006-7068-3718\">0009-0006-7068-3718</a>).</p>"
)

SDIFF_PEER = (
    "<p>This record is not peer reviewed. It is not a proof of global regularity of the 3D "
    "Navier-Stokes equations and makes no claim toward the Clay Millennium Problem.</p>"
)

HODGE_NOTE = (
    "CI fix on Nov 9 2026 repaired a build step and renamed audit entries; no theorem "
    "statements changed; audit now 423 declarations, standard axioms only."
)

HODGE_NOTE_HTML = f"<p>{HODGE_NOTE}</p>"

HODGE_RELS = [
    {
        "identifier": "https://github.com/BenFrohman/HODGE/commit/d5a01012275373a2a99022905d75d07242a4b66b",
        "relation": "references",
        "scheme": "url",
        "resource_type": "software",
    },
    {
        "identifier": "https://github.com/BenFrohman/HODGE/pull/40",
        "relation": "references",
        "scheme": "url",
    },
]


def request(method: str, url: str, body=None, timeout=120):
    data = None
    headers = {
        "Authorization": f"Bearer {TOKEN}",
        "Accept": "application/json",
    }
    if body is not None:
        data = json.dumps(body).encode("utf-8")
        headers["Content-Type"] = "application/json"
    req = urllib.request.Request(url, data=data, headers=headers, method=method)
    try:
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            raw = resp.read()
            parsed = json.loads(raw.decode("utf-8")) if raw else {}
            return resp.status, parsed, ""
    except urllib.error.HTTPError as e:
        err = e.read().decode("utf-8", errors="replace")
        return e.code, None, err


def discard(rec_id: int) -> None:
    status, data, err = request("POST", f"{BASE}/{rec_id}/actions/discard")
    print(f"  discard {rec_id}: HTTP {status}", flush=True)
    if status not in (200, 201, 202, 204) and "already" not in (err or "").lower():
        print(f"  discard body: {err[:500]}", flush=True)


def ident_key(rel: dict) -> tuple:
    return (
        (rel.get("identifier") or "").rstrip("/"),
        rel.get("relation"),
        rel.get("scheme"),
    )


def ensure_rel(rels: list, new: dict) -> list:
    out = list(rels)
    keys = {ident_key(r) for r in out}
    if ident_key(new) not in keys:
        # also skip if same identifier already present with same relation
        out.append(new)
    return out


def patch_ns(md: dict) -> dict:
    rels = list(md.get("related_identifiers") or [])
    updated = []
    for r in rels:
        ident = r.get("identifier") or ""
        if ident == "https://github.com/BenFrohman/NS_Millennium_Proof/commit/8a5ec50":
            r = dict(r)
            r["identifier"] = (
                "https://github.com/BenFrohman/NS_Millennium_Proof/commit/"
                "8a5ec50aa602318c0c611269731e7d41cd30b75b"
            )
        updated.append(r)
    md["related_identifiers"] = updated
    # Existing 'created' date entry has a description but no start/end; PUT rejects it.
    # Preserve the entry by supplying the date already stated in its description and publication_date.
    dates = []
    for d in md.get("dates") or []:
        d = dict(d)
        if d.get("type") == "created" and not d.get("start"):
            d["start"] = "2026-10-28"
        dates.append(d)
    if dates:
        md["dates"] = dates
    desc = md.get("description") or ""
    if "Version 2.3.0 provenance note" not in desc:
        md["description"] = NS_NOTE_HTML + desc
    notes = md.get("notes") or ""
    if "There is no GitHub tag v2.3.0" not in notes:
        md["notes"] = (notes + " " + NS_NOTE_TEXT).strip() if notes else NS_NOTE_TEXT
    return md


def patch_sdiff(md: dict) -> dict:
    rels = list(md.get("related_identifiers") or [])
    rels = ensure_rel(
        rels,
        {
            "identifier": "https://github.com/BenFrohman/frohmanian-tether-sdiff/commit/0722b164507c42cb417a144578315d344f07ce81",
            "relation": "isSupplementTo",
            "scheme": "url",
            "resource_type": "software",
        },
    )
    md["related_identifiers"] = rels
    md["keywords"] = [
        "Navier-Stokes",
        "Lean 4",
        "formal verification",
        "conditional regularity",
        "metriplectic dynamics",
        "SDiff",
    ]
    desc = md.get("description") or ""
    if "frohmanbenjamin@gmail.com" not in desc:
        desc = desc + SDIFF_CONTACT
    if "not peer reviewed" not in desc.lower():
        # keep existing no-Clay wording; add the missing peer-review clause once
        desc = desc + SDIFF_PEER
    md["description"] = desc
    return md


def patch_hodge(md: dict) -> dict:
    rels = list(md.get("related_identifiers") or [])
    for rel in HODGE_RELS:
        rels = ensure_rel(rels, rel)
    md["related_identifiers"] = rels
    desc = md.get("description") or ""
    if "audit now 423 declarations" not in desc:
        desc = desc + HODGE_NOTE_HTML
    md["description"] = desc
    notes = md.get("notes") or ""
    if "audit now 423 declarations" not in (notes or ""):
        md["notes"] = (notes + " " + HODGE_NOTE).strip() if notes else HODGE_NOTE
    return md


PATCHERS = {
    23749850: patch_ns,
    24082000: patch_sdiff,
    24082011: patch_hodge,
    24082012: patch_hodge,
}


def apply_one(rec_id: int, dry_run: bool = False) -> bool:
    print(f"\n=== Record {rec_id} ===", flush=True)
    status, dep, err = request("GET", f"{BASE}/{rec_id}")
    if status != 200:
        print(f"  GET failed HTTP {status}: {err[:500]}", flush=True)
        return False
    state = dep.get("state")
    submitted = dep.get("submitted")
    print(f"  initial state={state} submitted={submitted} doi={dep.get('doi')}", flush=True)
    if state != "done" or not submitted:
        print("  STOP: record is not in published done/submitted state; will not edit.", flush=True)
        return False

    original_md = copy.deepcopy(dep["metadata"])
    proposed = PATCHERS[rec_id](copy.deepcopy(original_md))
    (OUT_PROPOSED / f"{rec_id}-proposed-metadata.json").write_text(
        json.dumps(proposed, indent=2, ensure_ascii=False)
    )
    print(f"  wrote proposed metadata; description len {len(original_md.get('description') or '')} -> {len(proposed.get('description') or '')}", flush=True)
    print(f"  related_identifiers {len(original_md.get('related_identifiers') or [])} -> {len(proposed.get('related_identifiers') or [])}", flush=True)

    if dry_run:
        print("  dry-run only", flush=True)
        return True

    unlocked = False
    try:
        status, dep, err = request("POST", f"{BASE}/{rec_id}/actions/edit")
        if status not in (200, 201, 202):
            print(f"  edit failed HTTP {status}: {err[:800]}", flush=True)
            return False
        unlocked = True
        print(f"  unlocked for edit, state={dep.get('state')}", flush=True)

        # Re-get metadata in edit mode and re-apply patch on the live edit copy
        status, dep, err = request("GET", f"{BASE}/{rec_id}")
        if status != 200:
            raise RuntimeError(f"GET after edit failed HTTP {status}: {err[:500]}")
        live_md = dep["metadata"]
        patched = PATCHERS[rec_id](copy.deepcopy(live_md))

        status, updated, err = request("PUT", f"{BASE}/{rec_id}", {"metadata": patched})
        if status not in (200, 201):
            raise RuntimeError(f"PUT failed HTTP {status}: {err[:1500]}")
        print("  PUT ok", flush=True)

        status, published, err = request("POST", f"{BASE}/{rec_id}/actions/publish")
        if status not in (200, 201, 202):
            raise RuntimeError(f"publish failed HTTP {status}: {err[:1500]}")
        unlocked = False  # published; do not discard
        (OUT_AFTER / f"deposition-{rec_id}-after.json").write_text(
            json.dumps(published, indent=2, ensure_ascii=False)
        )
        print(f"  published state={published.get('state')} doi={published.get('doi')}", flush=True)
        return True
    except Exception as e:
        print(f"  ERROR: {e}", flush=True)
        if unlocked:
            print("  discarding unlocked edit", flush=True)
            discard(rec_id)
        return False


def main():
    dry = "--dry-run" in sys.argv
    ids = [int(x) for x in sys.argv[1:] if x.isdigit()] or [23749850, 24082000, 24082011, 24082012]
    results = {}
    for rec_id in ids:
        results[rec_id] = apply_one(rec_id, dry_run=dry)
    print("\n=== SUMMARY ===", flush=True)
    for rec_id, ok in results.items():
        print(f"  {rec_id}: {'OK' if ok else 'FAILED'}", flush=True)
    if not all(results.values()):
        sys.exit(1)


if __name__ == "__main__":
    main()
