import os
import json
import time
import shutil
import zipfile
import requests
from pathlib import Path

TOKEN = os.environ["ZENODO_ACCESS_TOKEN"]
BASE_URL = "https://zenodo.org/api/records"
HEADERS_JSON = {
    "Authorization": f"Bearer {TOKEN}",
    "Content-Type": "application/json",
    "Accept": "application/vnd.inveniordm.v1+json",
}
HEADERS_OCTET = {
    "Authorization": f"Bearer {TOKEN}",
    "Content-Type": "application/octet-stream",
}

COPYRIGHT_STR = "Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved. Licensed under the Apache License, Version 2.0 (http://www.apache.org/licenses/LICENSE-2.0)."

def build_invenio_payload(title: str, pub_date: str, description_html: str, keywords: list, repo_url: str, notes_str: str):
    return {
        "access": {
            "record": "public",
            "files": "public"
        },
        "files": {
            "enabled": True
        },
        "metadata": {
            "resource_type": {
                "id": "publication-preprint"
            },
            "creators": [
                {
                    "person_or_org": {
                        "type": "personal",
                        "name": "Frohman, Benjamin Stanley",
                        "given_name": "Benjamin Stanley",
                        "family_name": "Frohman",
                        "identifiers": [
                            {
                                "identifier": "0009-0006-7068-3718",
                                "scheme": "orcid"
                            }
                        ]
                    },
                    "affiliations": [
                        {
                            "name": "Independent Researcher"
                        }
                    ]
                }
            ],
            "title": title,
            "publisher": "Zenodo",
            "publication_date": pub_date,
            "subjects": [{"subject": kw} for kw in keywords],
            "related_identifiers": [
                {
                    "identifier": repo_url,
                    "scheme": "url",
                    "relation_type": {
                        "id": "issupplementto"
                    }
                }
            ],
            "version": "1.0.0",
            "rights": [
                {
                    "id": "apache-2.0"
                }
            ],
            "copyright": COPYRIGHT_STR,
            "description": description_html,
            "additional_descriptions": [
                {
                    "description": notes_str,
                    "type": {
                        "id": "notes"
                    }
                }
            ]
        }
    }

def create_draft_and_reserve_doi(item: dict) -> dict:
    payload = build_invenio_payload(
        title=item["title"],
        pub_date=item["pub_date"],
        description_html=item["description_html"],
        keywords=item["keywords"],
        repo_url=item["repo_url"],
        notes_str=item["notes_str"],
    )
    r = requests.post(BASE_URL, headers=HEADERS_JSON, json=payload)
    if r.status_code not in (200, 201):
        raise RuntimeError(f"Failed creating draft for {item['key']}: {r.status_code} {r.text}")
    rec = r.json()
    rec_id = str(rec["id"])

    # Reserve DataCite DOI
    r_doi = requests.post(f"{BASE_URL}/{rec_id}/draft/pids/doi", headers=HEADERS_JSON)
    if r_doi.status_code not in (200, 201):
        raise RuntimeError(f"Failed reserving DOI for {rec_id}: {r_doi.status_code} {r_doi.text}")
    doi_data = r_doi.json()
    doi = doi_data.get("pids", {}).get("doi", {}).get("identifier", f"10.5281/zenodo.{rec_id}")
    print(f"[RESERVED] {item['key']} -> Record {rec_id} | DOI: {doi}")
    return {"id": int(rec_id), "doi": doi, "upload_url": f"https://zenodo.org/uploads/{rec_id}"}

ITEMS = [
    {
        "key": "functional-equation-tether-b4",
        "repo_name": "functional-equation-tether-b4",
        "is_new_repo": True,
        "repo_dir": "/workspace/new_repos_stage/functional-equation-tether-b4",
        "repo_url": "https://github.com/BenFrohman/functional-equation-tether-b4",
        "origin_provenance": "April 2026 (Compiled 2026-07-04 15:59:24 CDT; Google Drive Archive 2026-07-07 14:20:55 CDT)",
        "pub_date": "2026-07-04",
        "title": "A Note on the Frohmanian Symplectic Tether Framework Applied to a Functional Equation (Putnam B4 Continuous f(x^2)=f(x)^2 Solution)",
        "keywords": ["functional equations", "Putnam B4", "dyadic iteration", "Frohmanian Symplectic Tether", "continuous functions"],
        "main_pdf": "/workspace/new_repos_stage/functional-equation-tether-b4/Frohmanian_Tether_Application_to_Functional_Equation_Note.pdf",
        "extra_files": ["/workspace/new_repos_stage/functional-equation-tether-b4/Frohmanian_Tether_Application_to_Functional_Equation_Note_Original_2026-07-04.pdf"],
        "description_html": "<p>Rigorous proof solving the continuous functional equation <code>f(x^2) = f(x)^2</code> on <code>[0, &infin;)</code> with <code>f(0)=0</code>, <code>f(1)=1</code>, and <code>f(x) &ge; 0</code> via logarithmic conjugation <code>g(t) = ln f(e^t)</code>, dyadic root iteration <code>x^{1/2^k} &rarr; 1</code>, and a symplectic tether damping functional <code>E(k) = |g(t - k ln 2) - 2^{-k} g(t)|^2</code>, establishing the unique power-law solution family <code>f(x) = x^c</code> (<code>c &gt; 0</code>) and evaluating <code>f(2)=4 &rArr; c=2, f(3)=9</code>.</p><p><strong>Origin Provenance:</strong> Authored April 2026; original LaTeX PDF compiled Saturday, July 4, 2026, 3:59:24 PM CDT (<code>2026-07-04T15:59:24-05:00</code>); archived in Google Drive Tuesday, July 7, 2026, 2:20:55 PM CDT.</p><p><strong>Copyright &amp; License:</strong> Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved. Licensed under the Apache License, Version 2.0 (ORCID: <a href=\"https://orcid.org/0009-0006-7068-3718\">0009-0006-7068-3718</a>).</p>",
        "notes_str": "Origin Provenance: April 2026 (PDF CreationDate: 2026-07-04 15:59:24 CDT; Google Drive CreatedTime: 2026-07-07 14:20:55 CDT). Copyright (c) 2026 Benjamin Stanley Frohman. ORCID: https://orcid.org/0009-0006-7068-3718"
    },
    {
        "key": "triadic-homogenization-lean",
        "repo_name": "triadic-homogenization-lean",
        "is_new_repo": True,
        "repo_dir": "/workspace/new_repos_stage/triadic-homogenization-lean",
        "repo_url": "https://github.com/BenFrohman/triadic-homogenization-lean",
        "origin_provenance": "2026-07-06 00:49:25 CDT (Google Drive Archive ID 1N6WfgOBJkPciRYWIQHJqAa2cmuWdu0yH)",
        "pub_date": "2026-07-06",
        "title": "Homogenization: Triadic Partition, Cube Measure, Cube Average, and Telescoping Increment Lemmas in Lean 4",
        "keywords": ["homogenization", "triadic cubes", "Lean 4", "Mathlib", "formal verification", "Lebesgue measure", "multi-scale analysis"],
        "main_pdf": "/workspace/new_repos_stage/triadic-homogenization-lean/Triadic_Homogenization_Lean4_Frohman_2026.pdf",
        "extra_files": ["/workspace/new_repos_stage/triadic-homogenization-lean/TriadicHomogenization.lean"],
        "description_html": "<p>Zero-<code>sorry</code> Lean 4 (Mathlib) formalization (<code>TriadicHomogenization.lean</code>) and companion manuscript establishing the multi-scale triadic cube hierarchy on <code>R^d</code> (<code>Eucl d := Fin d &rarr; R</code>) for quantitative PDE and stochastic homogenization: exact Lebesgue volume <code>measure_cube = (3^m)^d</code> via Fubini-Tonelli product measure over <code>Fin d</code>, normalized cube averages <code>cubeAvg m z g</code>, linearity and constant preservation, and multi-scale telescoping increment identities <code>telescoping_increments</code> and <code>norm_Increment_le_sum</code>.</p><p><strong>Origin Provenance:</strong> Monday, July 6, 2026, 12:49:25 AM CDT (<code>2026-07-06T05:49:25.627Z</code>).</p><p><strong>Copyright &amp; License:</strong> Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved. Licensed under the Apache License, Version 2.0 (ORCID: <a href=\"https://orcid.org/0009-0006-7068-3718\">0009-0006-7068-3718</a>).</p>",
        "notes_str": "Origin Provenance: 2026-07-06 00:49:25 CDT. Copyright (c) 2026 Benjamin Stanley Frohman. ORCID: https://orcid.org/0009-0006-7068-3718"
    },
    {
        "key": "poincare-wigner-motion-geometry",
        "repo_name": "poincare-wigner-motion-geometry",
        "is_new_repo": True,
        "repo_dir": "/workspace/new_repos_stage/poincare-wigner-motion-geometry",
        "repo_url": "https://github.com/BenFrohman/poincare-wigner-motion-geometry",
        "origin_provenance": "2026-05-19 (Google Drive Archive: 2026-07-07 14:21:41 CDT, ID 1P0tCYaDZEiF7riwApIqzfauMzk9vGGqQ)",
        "pub_date": "2026-05-19",
        "title": "Motion-First Geometry, Lorentz Ether vs. Special Relativity, Poincare's Fuchsian/Lorentz Group Theory, and Casimir/Wigner ISO(1,3) Classification",
        "keywords": ["Poincare group", "Wigner classification", "Casimir operators", "Pauli-Lubanski", "special relativity", "Lorentz group", "relational mechanics"],
        "main_pdf": "/workspace/new_repos_stage/poincare-wigner-motion-geometry/Poincare_Wigner_Motion_Geometry_Frohman_2026.pdf",
        "extra_files": ["/workspace/new_repos_stage/poincare-wigner-motion-geometry/Grok_Validation_Proof_2026-05-19.rtf"],
        "description_html": "<p>Four-part mathematical physics and Lie group treatise authored in May 2026: (I) Motion-First Geometry and Relational Shape Dynamics; (II) Empirical Equivalence and Ontological Divergence Between Lorentz Ether Theory (LET) and Einstein Special Relativity (SR); (III) Henri Poincar&eacute;'s Group-Theoretic Synthesis from Fuchsian Hyperbolic Automorphic Groups (<code>PSL(2,R) &cong; SO+(1,2)</code>) to the 1905/1906 Palermo Paper on the Lorentz Group <code>SO+(1,3)</code>; and (IV) Casimir Invariants (<code>C1 = P_mu P^mu</code>, <code>C2 = W_mu W^mu</code>) and Wigner's 1939 Unitary Irreducible Representation Classification of <code>ISO+(1,3)</code>.</p><p><strong>Origin Provenance:</strong> May 19, 2026 (Google Drive Archive: July 7, 2026, 2:21:41 PM CDT).</p><p><strong>Copyright &amp; License:</strong> Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved. Licensed under the Apache License, Version 2.0 (ORCID: <a href=\"https://orcid.org/0009-0006-7068-3718\">0009-0006-7068-3718</a>).</p>",
        "notes_str": "Origin Provenance: 2026-05-19 (Google Drive CreatedTime: 2026-07-07 14:21:41 CDT). Copyright (c) 2026 Benjamin Stanley Frohman. ORCID: https://orcid.org/0009-0006-7068-3718"
    },
    {
        "key": "hlex-latent-exchange-fabric",
        "repo_name": "hlex-latent-exchange-fabric",
        "is_new_repo": True,
        "repo_dir": "/workspace/new_repos_stage/hlex-latent-exchange-fabric",
        "repo_url": "https://github.com/BenFrohman/hlex-latent-exchange-fabric",
        "origin_provenance": "2026-08-07 01:55:37 CDT (hlex-systems-design-v1.1.pdf CreationDate)",
        "pub_date": "2026-08-07",
        "title": "Hierarchical Latent Exchange & Coordination Fabric (HLEX): Geometry-Aware Multi-Model Coordination and Rare-Token Marker Co-Occurrence Across Siloed AI Lineages (v1.1)",
        "keywords": ["HLEX", "multi-model coordination", "persistent homology", "Vietoris-Rips", "latent communication", "siloed AI", "optimal transport", "AI safety"],
        "main_pdf": "/workspace/new_repos_stage/hlex-latent-exchange-fabric/hlex-systems-design-v1.1.pdf",
        "extra_files": ["/workspace/new_repos_stage/hlex-latent-exchange-fabric/HLEX_Provenance_and_Architectural_Summary_2026.pdf"],
        "description_html": "<p>11-page systems design monograph (<code>hlex-systems-design-v1.1.pdf</code>, v1.1 Expanded) and provenance companion formalizing early latent communication and rare-token novelty marker co-occurrence (&ldquo;the operational unit of the original 'egg' concept&rdquo;) across isolated, siloed specialist AI lineages (<code>Grok-Core</code>, <code>Grok-Code</code>, <code>Grok-Math/Lean</code>, <code>Grok-Vision</code>, <code>Grok-Search</code>) via a 5-layer latent bus, Procrustes + Sinkhorn optimal transport adapters, Vietoris-Rips persistent homology diagnostics (<code>H0, H1, H2</code>) on activation point clouds, and invariant energy-preserving safety projections.</p><p><strong>Origin Provenance:</strong> Friday, August 7, 2026, 1:55:37 AM CDT (<code>2026-08-07T01:55:37-05:00</code>).</p><p><strong>Copyright &amp; License:</strong> Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved. Licensed under the Apache License, Version 2.0 (ORCID: <a href=\"https://orcid.org/0009-0006-7068-3718\">0009-0006-7068-3718</a>).</p>",
        "notes_str": "Origin Provenance: 2026-08-07 01:55:37 CDT. Copyright (c) 2026 Benjamin Stanley Frohman. ORCID: https://orcid.org/0009-0006-7068-3718"
    },
    {
        "key": "intelligence-partial-order-and-formalization-audits",
        "repo_name": "intelligence-partial-order-and-formalization-audits",
        "is_new_repo": True,
        "repo_dir": "/workspace/new_repos_stage/intelligence-partial-order-and-formalization-audits",
        "repo_url": "https://github.com/BenFrohman/intelligence-partial-order-and-formalization-audits",
        "origin_provenance": "2026-10-01 to 2026-10-23 CDT (Timestamped Public Cryptographic Ledger)",
        "pub_date": "2026-10-14",
        "title": "Mathematical Treatises on High-Dimensional Partial Orders of Intelligence, Formal Counterexamples to the Hiring Value Theorem, and Sandbox Auto-Formalization Mutation Audits",
        "keywords": ["partial order", "Spearman g", "Hiring Value Theorem", "Lean 4", "auto-formalization", "Frankenstein proof", "AI safety", "zero-trust containment"],
        "main_pdf": "/workspace/new_repos_stage/intelligence-partial-order-and-formalization-audits/Intelligence_Partial_Order_Hiring_Disproof_and_Formalization_Audits_2026.pdf",
        "extra_files": [],
        "description_html": "<p>Compiled monograph of eight timestamped mathematical and AI-safety treatises authored October 1&ndash;23, 2026: (1) Intelligence as a High-Dimensional Cone Partial Order (<code>&preceq;</code>) vs. Spearman's Scalar Positive Manifold (<code>g</code>) (Oct 5, 2026); (2) Formal Disproof of the &ldquo;Hiring Value Theorem&rdquo; (<code>H</code>) in Mathematics Departments via Lean 4 Kernel Orthogonality and Historical Counterexamples (Yitang Zhang, Ramanujan, Heegner) (Oct 14, 2026); (3) The &ldquo;Frankenstein Proof&rdquo; and Sandbox Auto-Formalization Mutation Loophole in Lean 4 (<code>m+4 &rarr; m+5</code> derivative shift and 2D decay substitution) (Oct 9, 2026); (4) Fourth-Wall Breaking in the Machine Case (Oct 1, 2026); (5) Derailed Autonomy (&ldquo;Intoxicated AI&rdquo; vs. Supreme Intelligence) on Clay Navier-Stokes Inputs (Oct 2, 2026); (6) Tate Conjecture vs. Rational Hodge on Smooth Cubic Fourfolds (Oct 3, 2026); (7) Zero-Trust AI Safety (&ldquo;Trust the Cage, Not the Tiger&rdquo;) and Covert CPU Cache Timing Channels Across Siloed VMs (Oct 10 &amp; 23, 2026); and (8) Game-Theoretic Strategic Under-Signaling (Oct 23, 2026).</p>",
        "notes_str": "Origin Provenance: October 1-23, 2026 CDT. Copyright (c) 2026 Benjamin Stanley Frohman. ORCID: https://orcid.org/0009-0006-7068-3718"
    },
    {
        "key": "DerivedCategories",
        "repo_name": "DerivedCategories",
        "is_new_repo": False,
        "repo_dir": "/workspace/repos_audit/DerivedCategories",
        "repo_url": "https://github.com/BenFrohman/DerivedCategories",
        "origin_provenance": "2026-09-22 15:44:35 CDT (Git Initial Commit)",
        "pub_date": "2026-09-22",
        "title": "A Plane on a Sextic Calabi-Yau Fourfold: Residual Quintic Surfaces, Host Ideals, and Determinantal Self-Correction in Lean 4",
        "keywords": ["derived categories", "Calabi-Yau fourfolds", "sextic fourfold", "residual quintic surface", "Hodge conjecture", "Lean 4", "Kuznetsov component"],
        "main_pdf": "/workspace/repos_audit/DerivedCategories/paper/Frohman_Residual_Surface_Preprint_2026.pdf",
        "extra_files": [
            "/workspace/repos_audit/DerivedCategories/paper/Frohman_Host_Ideals_2026.pdf",
            "/workspace/repos_audit/DerivedCategories/paper/Frohman_Determinantal_Correction_2026.pdf"
        ],
        "description_html": "<p>Three-paper algebraic geometry suite and 7-module Lean 4 formalization (<code>BenFrohman/DerivedCategories</code>) studying a smooth sextic Calabi-Yau fourfold <code>Y = V(F) &sub; P^5</code> containing a plane <code>&Pi; = V(x3,x4,x5)</code>: (1) <em>A Plane on a Sextic Calabi-Yau Fourfold and a Three-Parameter Family of Residual Quintic Surfaces</em> (<code>[&Pi;] + [S_{a,b,c}] = h^2</code>, self-intersection <code>&Pi;.&Pi; = 21</code>, <code>&Pi;.S = -20</code>, <code>S.S = 25</code>, Gram determinant <code>125</code>); (2) <em>Containing a Plane Is a Linear Condition on Homogeneous Polynomials</em>; and (3) <em>A Self-Correction on Determinantal Sextics, the Trichotomy Wall, and why the Berglund-H&uuml;bsch Transpose F^T Is Not a Smooth Projective Fourfold</em>.</p>",
        "notes_str": "Origin Provenance: 2026-09-22 15:44:35 CDT. Copyright (c) 2026 Benjamin Stanley Frohman. ORCID: https://orcid.org/0009-0006-7068-3718"
    },
    {
        "key": "orlov-equivalence-VF",
        "repo_name": "orlov-equivalence-VF",
        "is_new_repo": False,
        "repo_dir": "/workspace/repos_audit/orlov-equivalence-VF",
        "repo_url": "https://github.com/BenFrohman/orlov-equivalence-VF",
        "origin_provenance": "2026-09-28 03:22:45 CDT (Git Initial Commit)",
        "pub_date": "2026-09-28",
        "title": "Orlov's Landau-Ginzburg / Calabi-Yau Equivalence on the Locked Three-Chain Sextic Fourfold V(F) in Lean 4",
        "keywords": ["Orlov equivalence", "derived categories", "matrix factorizations", "sextic fourfold", "Calabi-Yau fourfold", "Lean 4"],
        "main_pdf": "/workspace/repos_audit/orlov-equivalence-VF/orlov_equivalence_VF.pdf",
        "extra_files": [],
        "description_html": "<p>Preprint (<code>orlov_equivalence_VF.pdf</code>) and Lean 4 formalization (<code>Orlov/Equivalence.lean</code>) applying Orlov's 2009 theorem (<em>Triangulated categories of singularities and equivalences between Landau-Ginzburg models</em>, Theorem 2.13) to the smooth three-chain sextic Calabi-Yau fourfold <code>Y = V(F) &sub; P^5</code> with <code>F = &Sigma; (x_i^5 x_{i+3} + x_{i+3}^6)</code> (degree <code>d=6=N=5+1</code>, Gorenstein parameter <code>a=0</code>), establishing the exact triangulated equivalence <code>D^b(coh V(F)) &cong; HMF^{gr}(A, F)</code> while documenting why this equivalence does not produce a second projective fourfold or an algebraic cycle outside <code>Q&lt;h^2, [&Pi;]&gt;</code>.</p>",
        "notes_str": "Origin Provenance: 2026-09-28 03:22:45 CDT. Copyright (c) 2026 Benjamin Stanley Frohman. ORCID: https://orcid.org/0009-0006-7068-3718"
    },
    {
        "key": "HODGE",
        "repo_name": "HODGE",
        "is_new_repo": False,
        "repo_dir": "/workspace/repos_audit/HODGE",
        "repo_url": "https://github.com/BenFrohman/HODGE",
        "origin_provenance": "2026-09-19 16:56:32 CDT (Git Initial Commit)",
        "pub_date": "2026-09-19",
        "title": "The Cycle Class Map, the Reverse Arrow, and a Classical Constructor on Three Fourfolds: Lean 4 Formalization and Hodge Ledger",
        "keywords": ["Hodge conjecture", "cycle class map", "fourfolds", "Fermat sextic", "cubic fourfold", "Noether-Lefschetz", "Lean 4"],
        "main_pdf": "/workspace/repos_audit/HODGE/docs/CYCLE_CLASS_AND_CONSTRUCTOR.pdf",
        "extra_files": ["/workspace/repos_audit/HODGE/papers/frohman-hodge-source-note.pdf"],
        "description_html": "<p>Master 42-module Lean 4 formalization and two companion papers (<code>CYCLE_CLASS_AND_CONSTRUCTOR.pdf</code> and <code>frohman-hodge-source-note.pdf</code>) analyzing the cycle class map <code>cl_X : Z^2(X)_Q &rarr; Hdg^2(X,Q)</code>, classical cycle constructors across smooth cubic, Fermat quintic, and three-chain sextic fourfolds, Griffiths Jacobian residue rings, and the exact boundary between certified algebraic spans and the open reverse arrow.</p>",
        "notes_str": "Origin Provenance: 2026-09-19 16:56:32 CDT. Copyright (c) 2026 Benjamin Stanley Frohman. ORCID: https://orcid.org/0009-0006-7068-3718"
    },
    {
        "key": "StandardConjectures",
        "repo_name": "StandardConjectures",
        "is_new_repo": False,
        "repo_dir": "/workspace/repos_audit/StandardConjectures",
        "repo_url": "https://github.com/BenFrohman/StandardConjectures",
        "origin_provenance": "2026-09-22 18:44:22 CDT (Git Initial Commit)",
        "pub_date": "2026-09-22",
        "title": "Hodge on X x X Implies Grothendieck's Lefschetz Standard Conjecture B: Lean 4 Formalization",
        "keywords": ["Grothendieck standard conjectures", "Lefschetz standard conjecture B", "Hodge conjecture", "correspondences", "Lean 4"],
        "main_pdf": "/workspace/repos_audit/StandardConjectures/Frohman_StandardConjectures_LefschetzB_2026.pdf",
        "extra_files": ["/workspace/repos_audit/StandardConjectures/StandardConjectures.lean"],
        "description_html": "<p>Zero-<code>sorry</code> Lean 4 module (<code>StandardConjectures.lean</code>) and companion note formalizing the implication <code>hodge_on_product_implies_lefschetz_B</code>: if the inverse Lefschetz operator <code>&Lambda; = L^{-1}</code> is a rational Hodge class on <code>X &times; X</code> and the rational Hodge conjecture holds on <code>X &times; X</code> in that degree, then <code>&Lambda;</code> is algebraic (Grothendieck's Lefschetz Standard Conjecture B).</p>",
        "notes_str": "Origin Provenance: 2026-09-22 18:44:22 CDT. Copyright (c) 2026 Benjamin Stanley Frohman. ORCID: https://orcid.org/0009-0006-7068-3718"
    },
    {
        "key": "collatz-terras-density",
        "repo_name": "collatz-terras-density",
        "is_new_repo": False,
        "repo_dir": "/workspace/repos_audit/collatz-terras-density",
        "repo_url": "https://github.com/BenFrohman/collatz-terras-density",
        "origin_provenance": "2026-10-04 15:45:31 CDT (Git Initial Commit)",
        "pub_date": "2026-10-04",
        "title": "Finite-Prefix Terras Parity-Vector Stopping-Time Density Bounds in Lean 4",
        "keywords": ["Collatz conjecture", "Terras stopping time", "parity vectors", "natural density", "Lean 4", "Mathlib"],
        "main_pdf": "/workspace/repos_audit/collatz-terras-density/Frohman_Collatz_Terras_Density_Lean4_2026.pdf",
        "extra_files": [],
        "description_html": "<p>Zero-<code>sorry</code> 7-module Lean 4 formalization (<code>TerrasDensity</code>) of the Terras finite-stopping-time parity-vector structure, binomial tail counts of bad parity words, and residue class covering bounds for the 3n+1 map.</p>",
        "notes_str": "Origin Provenance: 2026-10-04 15:45:31 CDT. Copyright (c) 2026 Benjamin Stanley Frohman. ORCID: https://orcid.org/0009-0006-7068-3718"
    },
    {
        "key": "collatz-teaming-lemma",
        "repo_name": "collatz-teaming-lemma",
        "is_new_repo": False,
        "repo_dir": "/workspace/repos_audit/collatz-teaming-lemma",
        "repo_url": "https://github.com/BenFrohman/collatz-teaming-lemma",
        "origin_provenance": "2026-09-20 15:47:26 CDT (Git Initial Commit)",
        "pub_date": "2026-09-20",
        "title": "Negative Expected Drift Does Not Imply a Unique Attractor at 1: Eliahou Windows, Rhin Linear Forms in Logarithms, and the Collatz Teaming Lemma in Lean 4",
        "keywords": ["Collatz conjecture", "Eliahou bounds", "linear forms in logarithms", "Syracuse drift", "Lean 4", "inverse-residue teams"],
        "main_pdf": "/workspace/repos_audit/collatz-teaming-lemma/Frohman_Collatz_Teaming_Lemma_and_Eliahou_Windows_2026.pdf",
        "extra_files": [],
        "description_html": "<p>23-module Lean 4 formalization and companion study of inverse-residue teaming for the 3n+1 map, M92 block-map Diophantine identities, Eliahou/Steiner/Rhin cycle bounds, and the Frohman Model Mean observation (<code>&mu;_F = log(3/4) &lt; 0</code>) showing via <code>3n-1</code> that negative expected logarithmic drift coexists with multiple periodic attractors.</p>",
        "notes_str": "Origin Provenance: 2026-09-20 15:47:26 CDT. Copyright (c) 2026 Benjamin Stanley Frohman. ORCID: https://orcid.org/0009-0006-7068-3718"
    },
    {
        "key": "3n-plus-c-cycle-census",
        "repo_name": "3n-plus-c-cycle-census",
        "is_new_repo": False,
        "repo_dir": "/workspace/repos_audit/3n-plus-c-cycle-census",
        "repo_url": "https://github.com/BenFrohman/3n-plus-c-cycle-census",
        "origin_provenance": "2026-09-23 23:54:15 CDT (Git Initial Commit)",
        "pub_date": "2026-09-24",
        "title": "A Prefix Census of 3n+c and 5n+1 Cycles, with One Verified Collatz Delay-Record Instance",
        "keywords": ["Collatz conjecture", "3n+c cycles", "5n+1 map", "hailstone delay record", "Belaga-Mignotte", "computational number theory"],
        "main_pdf": "/workspace/repos_audit/3n-plus-c-cycle-census/Frohman_3n_plus_c_Cycle_Census_2026.pdf",
        "extra_files": [],
        "description_html": "<p>Cryptographically hashed prefix census of periodic orbits for <code>3n+c</code> (<code>c = +1, -1, +5</code>) and <code>5n+1</code>, proof of the sign-conjugacy theorem <code>C_{-c}(n) = -C_c(-n)</code>, and exact 1348-step trajectory verification of the maximal Collatz delay-record start below <code>10^{12}</code>, <code>n = 989,345,275,647</code> (peak <code>1,219,624,271,099,764 &lt; 2^{53}-1</code>).</p>",
        "notes_str": "Origin Provenance: 2026-09-23 23:54:15 CDT. Copyright (c) 2026 Benjamin Stanley Frohman. ORCID: https://orcid.org/0009-0006-7068-3718"
    },
    {
        "key": "Frohman-MixedCorrelators-FJ",
        "repo_name": "Frohman-MixedCorrelators-FJ",
        "is_new_repo": False,
        "repo_dir": "/workspace/repos_audit/Frohman-MixedCorrelators-FJ",
        "repo_url": "https://github.com/BenFrohman/Frohman-MixedCorrelators-FJ",
        "origin_provenance": "2026-09-25 21:43:26 CDT (Git Initial Commit)",
        "pub_date": "2026-09-25",
        "title": "Mixed-Sector FJRW Correlators of a Three-Block Chain Sum and Textbook Formulation of the Frohman Problem",
        "keywords": ["FJRW theory", "Landau-Ginzburg models", "chain polynomial", "WDVV equations", "quantum singularity theory", "Witten equation"],
        "main_pdf": "/workspace/repos_audit/Frohman-MixedCorrelators-FJ/PROBLEM_STATEMENT.pdf",
        "extra_files": ["/workspace/repos_audit/Frohman-MixedCorrelators-FJ/GRIND.pdf"],
        "description_html": "<p>Formulation and complete selection-rule census (<code>all_216_decoration_triples.csv</code>, <code>allowed_36.csv</code>) for the mixed-sector Fan-Jarvis-Ruan-Witten (FJRW) correlators of the three-block chain potential <code>F = W(x0,x3) + W(x1,x4) + W(x2,x5)</code> with <code>W = u^5 v + v^6</code> and symmetry group <code>G_F = (Z/30Z)^3</code> of order <code>27,000</code>, isolating the 36 selection-rule-allowed rooms and the 4 irreducible four-point mixed correlator seeds.</p>",
        "notes_str": "Origin Provenance: 2026-09-25 21:43:26 CDT. Copyright (c) 2026 Benjamin Stanley Frohman. ORCID: https://orcid.org/0009-0006-7068-3718"
    },
    {
        "key": "SingularityLab",
        "repo_name": "SingularityLab",
        "is_new_repo": False,
        "repo_dir": "/workspace/repos_audit/SingularityLab",
        "repo_url": "https://github.com/BenFrohman/SingularityLab",
        "origin_provenance": "2026-09-25 06:00:50 CDT (Git Initial Commit)",
        "pub_date": "2026-09-25",
        "title": "The Chain Atom W=u^5v+v^6, Missing Leading Term v^11 in its Berglund-Hubsch Transpose W^T, and Affine Milnor Fibre vs. Projective Fourfold Cohomology",
        "keywords": ["Milnor number", "Berglund-Hubsch transpose", "invertible polynomials", "Grobner basis", "Lean 4", "singularity theory"],
        "main_pdf": "/workspace/repos_audit/SingularityLab/Frohman_SingularityLab_ChainAtom_and_Transpose_2026.pdf",
        "extra_files": [],
        "description_html": "<p>Singularity theory laboratory and Lean 4 arithmetic certificates (<code>MilnorCount.lean</code>, <code>LedgerIntegers.lean</code>, <code>LedgerCert.lean</code>) proving <code>&mu;(W)=25</code>, <code>&mu;(W^T)=26</code>, <code>|det A| = |Aut(W)| = |Aut(W^T)| = 30</code>, the Gr&ouml;bner basis elimination of <code>v^{11} &isin; (&part;W^T)</code>, and the container separation between the affine Milnor fibre (<code>&mu;(F) = 15,625</code>) and projective primitive cohomology (<code>dim R_12(F) = 1,751</code>).</p>",
        "notes_str": "Origin Provenance: 2026-09-25 06:00:50 CDT. Copyright (c) 2026 Benjamin Stanley Frohman. ORCID: https://orcid.org/0009-0006-7068-3718"
    },
    {
        "key": "ThreeChainJacobian",
        "repo_name": "ThreeChainJacobian",
        "is_new_repo": False,
        "repo_dir": "/workspace/repos_audit/ThreeChainJacobian",
        "repo_url": "https://github.com/BenFrohman/ThreeChainJacobian",
        "origin_provenance": "2026-09-28 00:06:34 CDT (Git Initial Commit)",
        "pub_date": "2026-09-28",
        "title": "Top-Degree Rank dim_Q R_12(F) = 1751 for the Three-Chain Sextic Jacobian Algebra and Independence from Contained Planes",
        "keywords": ["Jacobian ring", "Griffiths residue", "sextic fourfold", "Hilbert series", "Noether-Lefschetz locus", "Hodge numbers"],
        "main_pdf": "/workspace/repos_audit/ThreeChainJacobian/Frohman_ThreeChainJacobian_R12_Rank_1751_2026.pdf",
        "extra_files": [],
        "description_html": "<p>Proof that for the smooth three-chain sextic fourfold <code>X = V(F) &sub; P^5</code> with <code>F = &Sigma;(x_i^5 x_{i+3} + x_{i+3}^6)</code> containing the plane <code>&Pi; = V(x3,x4,x5)</code>, the partial derivatives form a regular sequence with <code>dim J(F) = 25^3 = 15,625</code>, Hilbert series <code>(1+t+t^2+t^3+t^4)^6</code>, and Griffiths primitive middle piece <code>dim R_12(F) = 1751</code> (<code>h^{2,2}(X) = 1752</code>), identical to a very general smooth sextic fourfold.</p>",
        "notes_str": "Origin Provenance: 2026-09-28 00:06:34 CDT. Copyright (c) 2026 Benjamin Stanley Frohman. ORCID: https://orcid.org/0009-0006-7068-3718"
    },
    {
        "key": "bohm-identities",
        "repo_name": "bohm-identities",
        "is_new_repo": False,
        "repo_dir": "/workspace/repos_audit/bohm-identities",
        "repo_url": "https://github.com/BenFrohman/bohm-identities",
        "origin_provenance": "2026-10-06 08:18:54 CDT (Git Initial Commit)",
        "pub_date": "2026-10-06",
        "title": "Exact Madelung and Bohm Quantum Potential Identities in Core Lean 4 (Zero Mathlib Dependencies)",
        "keywords": ["Bohmian mechanics", "Madelung transform", "quantum potential", "guidance equation", "Lean 4", "formal verification"],
        "main_pdf": "/workspace/repos_audit/bohm-identities/Frohman_Bohm_Madelung_Identities_Lean4_2026.pdf",
        "extra_files": ["/workspace/repos_audit/bohm-identities/BohmIdentities.lean"],
        "description_html": "<p>Zero-<code>sorry</code> formalization in core Lean 4 (<code>BohmIdentities.lean</code>, zero external dependencies) proving the cleared algebraic identities underlying the Bohmian guidance law <code>Im(d&psi; &middot; conj &psi;) = dS &middot; |&psi;|^2</code> (<code>Bohm.guidance_cleared</code>) and the quantum potential prefactor identity (<code>Bohm.quantumPotential_cleared</code>).</p>",
        "notes_str": "Origin Provenance: 2026-10-06 08:18:54 CDT. Copyright (c) 2026 Benjamin Stanley Frohman. ORCID: https://orcid.org/0009-0006-7068-3718"
    },
    {
        "key": "frohmanian-tether-manuscript-2026-06-01",
        "repo_name": "frohmanian-tether-manuscript-2026-06-01",
        "is_new_repo": False,
        "repo_dir": "/workspace/repos_audit/frohmanian-tether-manuscript-2026-06-01",
        "repo_url": "https://github.com/BenFrohman/frohmanian-tether-manuscript-2026-06-01",
        "origin_provenance": "2026-06-01 00:10:20 CDT (Neural Scaling PDF) / 2026-06-01 01:20:57 CDT (June 1 Manuscript Git Commit) / 2026-06-22 16:05:10 CDT (Frohmanian Curve Monograph)",
        "pub_date": "2026-06-01",
        "title": "The Frohmanian Symplectic Tether Companion Archive: June 1, 2026 Hydrodynamic Manuscript, Frohmanian Curve Monograph, Neural Scaling Laws, and Triple Regularization Framework",
        "keywords": ["Frohmanian Symplectic Tether", "Navier-Stokes equations", "Frohmanian Curve", "neural scaling laws", "metriplectic dissipation", "fluid-gravity duality"],
        "main_pdf": "/workspace/repos_audit/frohmanian-tether-manuscript-2026-06-01/main.pdf",
        "extra_files": [
            "/workspace/NS_Millennium_Proof/Frohmanian_Symplectic_Tether_and_Frohmanian_Curve.pdf",
            "/workspace/NS_Millennium_Proof/Frohmanian_Tether_Neural_Scaling_Secondary_Paper.pdf",
            "/workspace/drive_downloads/Triple_conjecture_a_rigorous_refinement.pdf",
            "/workspace/drive_downloads/Mathematical_Food_Forethought.pdf"
        ],
        "description_html": "<p>Archival companion collection for the Frohmanian Symplectic Tether program containing five foundational timestamped manuscripts: (1) <em>June 1, 2026 Frohmanian Symplectic Tether Manuscript</em> (<code>main.pdf</code>, origin commit <code>2026-06-01 01:20:57 CDT</code>); (2) <em>The Frohmanian Symplectic Tether &amp; Frohmanian Curve Complete Analysis</em> (16 pp., <code>2026-06-22 16:05:10 CDT</code>); (3) <em>Frohmanian Tether Neural Scaling Secondary Paper</em> (5 pp., <code>2026-06-01 00:10:20 CDT</code>); (4) <em>Frohman's Triple Regularization Framework: Symplectic Tether, Metriplectic Dissipation, and Holographic Gravity</em> (8 pp., <code>2026-05-09 13:19:45 CDT</code>); and (5) <em>Mathematical Food Forethought: Pearl Maximization Function P(O,A,E)</em> (<code>2026-04-29 09:26:38 CDT</code>).</p>",
        "notes_str": "Origin Provenance: April 29 - June 22, 2026 CDT. Copyright (c) 2026 Benjamin Stanley Frohman. ORCID: https://orcid.org/0009-0006-7068-3718"
    }
]

results = {}
for item in ITEMS:
    res = create_draft_and_reserve_doi(item)
    results[item["key"]] = {**item, **res}
    time.sleep(0.3)

with open("/workspace/zenodo_batch_17_reserved.json", "w", encoding="utf-8") as f:
    json.dump(results, f, indent=2)

print(f"\nSuccessfully created and reserved DOIs for all {len(results)} Zenodo deposits!")
