import os
import json
import time
import requests

TOKEN = os.environ["ZENODO_ACCESS_TOKEN"]
HEADERS = {
    "Authorization": f"Bearer {TOKEN}",
    "Content-Type": "application/json",
    "Accept": "application/vnd.inveniordm.v1+json",
}

KEYS = [
    # Track 1: 6 Commercial / Metered-Usage IP & Software Product Lines (Restricted DOIs)
    "T1_frohman_V13",
    "T1_sentinel_gate",
    "T1_agentic_dev",
    "T1_amm_flash_loan_symplectic_guard",
    "T1_pqc_symplectic_lattice_sieving",
    "T1_frohman_symplectic_qec_codes",
    # Track 2: 14 Academic Math & Physics Papers (Open-Access DOIs A1-A14)
    "A1_symplectic_turbulence_dissipation",
    "A2_coherent_structures_coadjoint_ns",
    "A3_vortex_reconnection_symplectic",
    "A4_conditional_regularity_3d_ns_routes_a_b",
    "A5_frohmanian_tether_conditional_3d_ns",
    "A6_frohman_functional_master_reduction",
    "A7_frohmanian_closure_v2_dyadic",
    "A8_fjrw_mirror_symmetry_chain_polynomials",
    "A9_milnor_algebra_two_variable_chain",
    "A10_fjrw_paper2_reconstruction_boundary",
    "A11_chain_atom_u5v_v6_monograph",
    "A12_arithmetic_cymatics_galois_descent",
    "A13_noether_lefschetz_k3_fibration_descent",
    "A14_cohomological_obstructions_conditional_cycle_fourfolds",
]

out_path = "/workspace/group_a_zenodo_and_llc_ip/reserved_20_dois.json"
if os.path.exists(out_path):
    with open(out_path) as f:
        reserved = json.load(f)
else:
    reserved = {}

for key in KEYS:
    if key in reserved and reserved[key].get("doi"):
        print(f"Already reserved {key}: {reserved[key]['doi']}")
        continue
    is_restricted = key.startswith("T1_")
    init_payload = {
        "access": {
            "record": "public",
            "files": "restricted" if is_restricted else "public",
        },
        "files": {"enabled": True},
        "metadata": {
            "title": f"Draft reservation for {key}",
            "publication_date": "2026-08-22",
            "resource_type": {"id": "publication-technicalnote" if is_restricted else "publication-preprint"},
            "creators": [
                {
                    "person_or_org": {
                        "type": "personal",
                        "given_name": "Benjamin Stanley",
                        "family_name": "Frohman",
                        "identifiers": [
                            {"scheme": "orcid", "identifier": "0009-0006-7068-3718"}
                        ],
                    }
                }
            ],
        },
    }
    r = requests.post("https://zenodo.org/api/records", headers=HEADERS, json=init_payload)
    if r.status_code not in (200, 201):
        raise RuntimeError(f"Failed creating draft for {key}: {r.status_code} {r.text}")
    rec = r.json()
    rec_id = str(rec["id"])
    r_doi = requests.post(
        f"https://zenodo.org/api/records/{rec_id}/draft/pids/doi", headers=HEADERS
    )
    if r_doi.status_code not in (200, 201):
        raise RuntimeError(f"Failed reserving DOI for {key} ({rec_id}): {r_doi.status_code} {r_doi.text}")
    rec_doi = r_doi.json()
    doi_str = rec_doi["pids"]["doi"]["identifier"]
    reserved[key] = {
        "id": rec_id,
        "parent_id": str(rec.get("parent", {}).get("id", "")),
        "doi": doi_str,
        "record_url": f"https://zenodo.org/records/{rec_id}",
        "doi_url": f"https://doi.org/{doi_str}",
        "is_restricted": is_restricted,
    }
    with open(out_path, "w") as f:
        json.dump(reserved, f, indent=2)
    print(f"Reserved {key}: id={rec_id}, doi={doi_str}")
    time.sleep(0.3)

print(f"Total reserved: {len(reserved)}")
