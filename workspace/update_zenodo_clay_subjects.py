import os
import requests

token = os.environ["ZENODO_ACCESS_TOKEN"]
headers = {
    "Authorization": f"Bearer {token}",
    "Content-Type": "application/json",
    "Accept": "application/vnd.inveniordm.v1+json"
}

CLAY_NS_TAGS = [
    "Clay Millennium Problem",
    "Millennium Prize Problems",
    "Fefferman Clay Problem B",
    "Periodic 3D Navier-Stokes",
    "Conditional Regularity Theorem",
    "Frohmanian Symplectic Tether",
    "Lean 4 Formal Verification"
]

CLAY_HODGE_TAGS = [
    "Clay Millennium Problem",
    "Millennium Prize Problems",
    "Hodge Conjecture",
    "Integral Hodge Conjecture",
    "Algebraic Cycles",
    "Fourfold Cohomology",
    "Lean 4 Formal Verification"
]

RECORDS_TO_TAG = {
    # Navier-Stokes Clay Records
    "23627610": CLAY_NS_TAGS,
    "23627618": CLAY_NS_TAGS + ["Two-Point Strain Coercivity", "Obstruction Counterexample"],
    "23629480": CLAY_NS_TAGS + ["I11 Conditional Regularity Criterion", "Vorticity Direction"],
    "23629482": CLAY_NS_TAGS + ["Global-from-Local Restart Continuation"],
    "22240549": CLAY_NS_TAGS,
    "22835069": CLAY_NS_TAGS,

    # Hodge Conjecture Clay Records
    "23627612": CLAY_HODGE_TAGS + ["Atiyah-Hirzebruch Torsion Obstruction"],
    "23125636": CLAY_HODGE_TAGS + ["Cubic Fourfolds", "Kuznetsov Component", "Noether-Lefschetz"],
    "22240168": CLAY_HODGE_TAGS + ["Orlov Equivalence", "Derived Categories"],
    "23629476": CLAY_HODGE_TAGS + ["Uniruled Fourfolds", "Tate Conjecture"],
    "23629478": CLAY_HODGE_TAGS + ["Derived Categories", "Semiorthogonal Decomposition"],
    "23629486": CLAY_HODGE_TAGS + ["Grothendieck Standard Conjectures", "Lefschetz Standard Conjecture"],
    "23629488": CLAY_HODGE_TAGS + ["Noether-Lefschetz Loci", "Period Domains"],
    "23629490": CLAY_HODGE_TAGS + ["Atiyah-Hirzebruch Spectral Sequence", "Steenrod Operations"],
    "23629492": CLAY_HODGE_TAGS + ["Tate Conjecture", "Etale Cohomology"],
    "23629494": CLAY_HODGE_TAGS + ["Fermat Fourfolds", "Linear Planes"],
    "23629496": CLAY_HODGE_TAGS + ["Fermat Quintic", "Jacobian Ring"]
}

for rec_id, extra_tags in RECORDS_TO_TAG.items():
    # Create or open edit draft for published record
    r_edit = requests.post(f"https://zenodo.org/api/records/{rec_id}/draft", headers=headers)
    if r_edit.status_code not in (200, 201):
        print(f"Skip {rec_id}: edit status {r_edit.status_code}")
        continue
    draft = r_edit.json()
    meta = draft.get("metadata", {})
    existing_subjects = [s.get("subject") for s in meta.get("subjects", []) if s.get("subject")]
    merged = list(dict.fromkeys(existing_subjects + extra_tags))
    meta["subjects"] = [{"subject": s} for s in merged]

    payload = {
        "access": draft.get("access", {"record": "public", "files": "public"}),
        "files": draft.get("files", {"enabled": True}),
        "pids": draft.get("pids", {}),
        "metadata": meta
    }
    r_put = requests.put(f"https://zenodo.org/api/records/{rec_id}/draft", headers=headers, json=payload)
    if r_put.status_code != 200:
        print(f"PUT failed on {rec_id}: {r_put.status_code} {r_put.text[:200]}")
        continue
    r_pub = requests.post(f"https://zenodo.org/api/records/{rec_id}/draft/actions/publish", headers=headers)
    print(f"Updated & published Clay subjects on Zenodo {rec_id} (DOI: 10.5281/zenodo.{rec_id}): HTTP {r_pub.status_code} ({len(merged)} total tags)")
