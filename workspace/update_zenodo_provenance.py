import os
import sys
import json
import time
import urllib.request
import urllib.error

TOKEN = os.environ["ZENODO_ACCESS_TOKEN"]
BASE_URL = "https://zenodo.org/api/deposit/depositions"

PROVENANCE_LEDGER_HTML = """<hr>
<h3>Provenance &amp; Chronological Priority Ledger (April 2026 – October 2026)</h3>
<p><strong>Sole Author &amp; Mathematical Originator:</strong> Benjamin Stanley Frohman (ORCID: <a href="https://orcid.org/0009-0006-7068-3718">0009-0006-7068-3718</a>; Independent Researcher, Texas, United States; GitHub: <a href="https://github.com/BenFrohman">@BenFrohman</a>; X.com: <a href="https://x.com/Investor0x">@Investor0x</a>).<br>
<strong>License &amp; Copyright:</strong> Copyright &copy; 2026 Benjamin Stanley Frohman. All rights reserved. Released under the Apache License, Version 2.0 (SPDX: <code>Apache-2.0</code>).</p>

<p>This record is part of the unified, cryptographically cross-linked <strong>Frohmanian Symplectohydrodynamics (FSymHD) &amp; 3D Navier–Stokes Regularity</strong> research corpus. The chronological lineage of the theoretical framework, analytical reductions, and Lean 4 formalizations is anchored by the following verifiable cryptographic digests and persistent identifiers:</p>

<h4>Tier 1 — April–May 2026 Foundational Prior-Art Archives (SHA-256 &amp; MD5 Cryptographic Digests)</h4>
<ul>
  <li><strong>2026-04-29 (09:26:38 AM CDT / 14:26:38 UTC):</strong> <code>Mathematical_Food_Forethought.pdf</code> — Foundational mathematical notes and early symplectic/structural conceptualization (Google Drive File ID: <code>1fbHzbd4f8rB8ry-uC9Zeb-2G8nCAxR3M</code>; Size: <code>127,523</code> bytes; MD5: <code>46f660856892bcd241b58e35971a6d3c</code>; SHA-256: <code>20dd3b53e02a5a3a5a02fd9f753844b162ad920cfd3e4c5f6f89106d7d66dac5</code>).</li>
  <li><strong>2026-05-04 (05:21:24 PM CDT / 22:21:24 UTC):</strong> <code>NS_Polished.pdf</code> — Early 3D Navier–Stokes symplectic tether manuscript iteration (Google Drive File ID: <code>15RmvaT2uvH1L7CXmXmWejS5U8xKklM9i</code>) and <code>appendix.tex</code> (<code>2026-05-04 11:01:00 AM CDT</code>).</li>
  <li><strong>2026-05-09 (01:19:45 PM CDT / 18:19:45 UTC):</strong> <code>Triple_conjecture_a_rigorous_refinement.pdf</code> — Rigorous refinement of the Frohmanian triple regularization architecture (Google Drive File ID: <code>1cK7a4805-y-y5f31-8vU118c0Q81b8e9</code>; Size: <code>667,751</code> bytes; MD5: <code>e2f771dc85f2358f49c888c50ab6a49d</code>; SHA-256: <code>a7e3cd19697eed920549cdfa2f6177a45312b9c2cf8e2e33fe220691f550ba61</code>).</li>
  <li><strong>2026-05-16 to 2026-05-26:</strong> Dated LaTeX/PDF manuscript iterations in <code>drafts/</code>: <code>5:17 DRAFTV1.pdf</code> (<code>2026-05-16 10:43:08 AM CDT</code>, SHA-256: <code>f3f20f391b865932d0d5cbbf4ff2af7fe1fcb52e203629daa772300b34c0f042</code>), <code>Final draftv1 Frohmanian_Tether_Theorem.pdf</code> (<code>2026-05-18 09:30:28 AM CDT</code>), <code>FINAL (1).pdf</code> (<code>2026-05-18 04:54:41 PM CDT</code>), <code>5:19 EDITS.pdf</code> (<code>2026-05-19 09:51:12 AM CDT</code>, SHA-256: <code>ee6ce9b88dd650e6858afa5727c818b454963abf02659db34de6f410772afdb7</code>), <code>NEXT.pdf</code> (<code>2026-05-21 11:21:13 AM CDT</code>), and <code>Full_Living_Document_NS_Millennium_Proof_with_All_PASS_Blocks_and_Insertions.pdf</code> (<code>2026-05-26 23:32:20 CDT</code>).</li>
  <li><strong>2026-05-27 to 2026-05-30 (CDT):</strong> Initial Lean 4 formalization archives (<code>Lean_Formalization_2026-05-28</code>, Google Drive IDs <code>1t6gNjlug13-j2amIgXashkoMoLwQ2-sv</code> and <code>1VtDm0DBEpiNeh3fepG5S9P9gTRzfc2sy</code>), establishing the 5-step minimal tether uniqueness proof and coadjoint orbit degeneracy lemmas.</li>
</ul>

<h4>Tier 2 — June 1, 2026 GitHub Origin Commit &amp; June–August 2026 Archival Snapshots</h4>
<ul>
  <li><strong>2026-06-01 (01:20:57 AM CDT / 06:20:57 UTC):</strong> Earliest public GitHub root commit <a href="https://github.com/BenFrohman/frohmanian-tether-manuscript-2026-06-01/commit/6c6cac908304d1ed3c90bddc907c4d2c3f4a8d79"><code>6c6cac908304d1ed3c90bddc907c4d2c3f4a8d79</code></a> in <a href="https://github.com/BenFrohman/frohmanian-tether-manuscript-2026-06-01"><code>BenFrohman/frohmanian-tether-manuscript-2026-06-01</code></a> (<em>"Resolution of the 3D Navier-Stokes Regularity Problem via the Frohmanian Symplectic Tether"</em>; <code>main.pdf</code> SHA-256: <code>d4d1753f12e580a8675ca4a51aa0c0832ed3b31c01a2ef71aacb030fdaf075c4</code>; <code>main.tex</code> SHA-256: <code>710c97158f736d57e2c63370e54beb194698fad1ff489aff326cdb8736db9980</code>), archived on Zenodo at <a href="https://doi.org/10.5281/zenodo.23629499"><code>10.5281/zenodo.23629499</code></a> (Concept DOI: <a href="https://doi.org/10.5281/zenodo.23629498"><code>10.5281/zenodo.23629498</code></a>).</li>
  <li><strong>2026-06-01 (12:10:20 AM CDT) &amp; 2026-06-22 (04:05:10 PM CDT):</strong> Companion monographs <code>Frohmanian_Tether_Neural_Scaling_Secondary_Paper.pdf</code> (SHA-256: <code>573f4fcc326708d8c6b5f4ceeef67d113d472170234cfb3105ec123663e20a1a</code>) and <code>Frohmanian_Symplectic_Tether_and_Frohmanian_Curve.pdf</code> (SHA-256: <code>3cf0e2a1be2a03cb165659fa5315f6d6642579341b3bd90f21de455dac451e7e</code>), preserved in <a href="https://doi.org/10.5281/zenodo.23629499"><code>10.5281/zenodo.23629499</code></a>.</li>
  <li><strong>2026-06-19 (04:29:21 PM CDT / 21:15:05 UTC):</strong> Creation of the primary Lean 4 formalization repository <a href="https://github.com/BenFrohman/NS_Millennium_Proof"><code>BenFrohman/NS_Millennium_Proof</code></a> (oldest author-dated commit <code>c4fc018</code>).</li>
  <li><strong>2026-08-19 (CDT):</strong> Historical Zenodo archival snapshot <a href="https://doi.org/10.5281/zenodo.21856430"><code>10.5281/zenodo.21856430</code></a> (Concept DOI: <a href="https://doi.org/10.5281/zenodo.21856429"><code>10.5281/zenodo.21856429</code></a>; <code>Frohmanian_Symplectic_Tether_Zenodo_21856430.pdf</code> SHA-256: <code>54cb95bf8fd87ba325f7bdc68597bba8406d499c9bcccad0f576fc3671325120</code>).</li>
</ul>

<h4>Tier 3 — September–October 2026 Analytical Criteria, Boundary Ledgers &amp; Zero-<code>sorry</code> Lean 4 Formalizations</h4>
<ul>
  <li><strong>2026-09-01:</strong> Vorticity direction and high-set Campanato regularity criteria: <a href="https://doi.org/10.5281/zenodo.22240168"><code>10.5281/zenodo.22240168</code></a> (<em>Direction of vorticity in 3D Navier–Stokes: closed identities, a geometric reduction, and a scale-sharp remaining estimate</em>) and <a href="https://doi.org/10.5281/zenodo.22240549"><code>10.5281/zenodo.22240549</code></a> (<em>Direction of vorticity on the high set: what is closed, what is false, and the remaining Campanato bound</em>).</li>
  <li><strong>2026-09-16 / 2026-09-18:</strong> September 2026 working notes and referee audits: <a href="https://doi.org/10.5281/zenodo.22835028"><code>10.5281/zenodo.22835028</code></a> (<em>September 2026 Working Notes on 3D Navier–Stokes Conditional Regularity Criteria, the Hodge–Navier–Stokes Architecture Referee Audit, and Triadic Multiscale Homogenization</em>) and <a href="https://doi.org/10.5281/zenodo.22835069"><code>10.5281/zenodo.22835069</code></a> (<em>Identified strain kernel A(&theta;,&omega;) and a conditional regularity criterion for 3D Navier–Stokes (&kappa; = 3/2; working notes)</em>, <a href="https://github.com/BenFrohman/ns-i11-conditional-criterion"><code>BenFrohman/ns-i11-conditional-criterion</code></a>).</li>
  <li><strong>2026-09-11 / 2026-09-25:</strong> Two-point strain coercivity analysis: <a href="https://doi.org/10.5281/zenodo.23627618"><code>10.5281/zenodo.23627618</code></a> (<em>On Local Two-Point Strain Coercivity in the 3D Vorticity Equation</em>, <a href="https://github.com/BenFrohman/two-point-strain-coercivity"><code>BenFrohman/two-point-strain-coercivity</code></a>).</li>
  <li><strong>2026-10-06 / 2026-10-07:</strong> Zero-<code>sorry</code> Lean 4 modular formalizations and boundary ledgers:
    <ul>
      <li><a href="https://doi.org/10.5281/zenodo.23629497"><code>10.5281/zenodo.23629497</code></a> (Concept: <a href="https://doi.org/10.5281/zenodo.23629496"><code>10.5281/zenodo.23629496</code></a>) — <code>BenFrohman/bohm-identities</code> (Pointwise Bohm quantum-potential identities).</li>
      <li><a href="https://doi.org/10.5281/zenodo.23653003"><code>10.5281/zenodo.23653003</code></a> (Concept: <a href="https://doi.org/10.5281/zenodo.23653002"><code>10.5281/zenodo.23653002</code></a>) — <code>BenFrohman/global-from-local-restart</code> (Uniform local continuation implies global existence on <code>[0,&infin;)</code> in Lean 4).</li>
      <li><a href="https://doi.org/10.5281/zenodo.23653013"><code>10.5281/zenodo.23653013</code></a> (<code>BenFrohman/Clay-</code>) &amp; <a href="https://doi.org/10.5281/zenodo.23653015"><code>10.5281/zenodo.23653015</code></a> (<code>BenFrohman/Clay-CD-not-certified</code>) — Formal boundary ledgers separating conditional regularity from the open unconditional Clay problems (A)–(D).</li>
      <li><a href="https://doi.org/10.5281/zenodo.23629465"><code>10.5281/zenodo.23629465</code></a> (<code>BenFrohman/functional-equation-tether-b4</code>) &amp; <a href="https://doi.org/10.5281/zenodo.23629467"><code>10.5281/zenodo.23629467</code></a> (<code>BenFrohman/triadic-homogenization-lean</code>).</li>
    </ul>
  </li>
  <li><strong>2026-10-24:</strong> Symplectohydrodynamics &amp; Master Functional Monograph Series: <a href="https://doi.org/10.5281/zenodo.23632786"><code>10.5281/zenodo.23632786</code></a> (<em>The Frohman Symplectic and Holographic Dual Regularization Conjecture: Master Functional Reduction and Metriplectic Enstrophy Control</em>) and companion preprints <a href="https://doi.org/10.5281/zenodo.23632776"><code>10.5281/zenodo.23632776</code></a>, <a href="https://doi.org/10.5281/zenodo.23632778"><code>10.5281/zenodo.23632778</code></a>, <a href="https://doi.org/10.5281/zenodo.23632780"><code>10.5281/zenodo.23632780</code></a>, <a href="https://doi.org/10.5281/zenodo.23632782"><code>10.5281/zenodo.23632782</code></a>, <a href="https://doi.org/10.5281/zenodo.23632784"><code>10.5281/zenodo.23632784</code></a>, and <a href="https://doi.org/10.5281/zenodo.23632788"><code>10.5281/zenodo.23632788</code></a>.</li>
  <li><strong>2026-10-25 / 2026-10-27:</strong> Primary Lean 4 Formalization Releases:
    <ul>
      <li><a href="https://doi.org/10.5281/zenodo.23717082"><code>10.5281/zenodo.23717082</code></a> (Concept: <a href="https://doi.org/10.5281/zenodo.23652842"><code>10.5281/zenodo.23652842</code></a>; v1.0.0: <a href="https://doi.org/10.5281/zenodo.23652843"><code>10.5281/zenodo.23652843</code></a>) — <code>BenFrohman/frohmanian-symplectic-tether-regularity</code> (v1.1.0, 29 Lean 4 modules, zero <code>sorry</code>).</li>
      <li><a href="https://doi.org/10.5281/zenodo.23717083"><code>10.5281/zenodo.23717083</code></a> (Concept: <a href="https://doi.org/10.5281/zenodo.23652840"><code>10.5281/zenodo.23652840</code></a>; v1.0.0: <a href="https://doi.org/10.5281/zenodo.23652841"><code>10.5281/zenodo.23652841</code></a>) — <code>BenFrohman/fefferman-clay-navier-stokes</code> (v1.1.0, 34 Lean 4 modules, zero <code>sorry</code>).</li>
      <li><a href="https://doi.org/10.5281/zenodo.23717084"><code>10.5281/zenodo.23717084</code></a> (Concept: <a href="https://doi.org/10.5281/zenodo.23627609"><code>10.5281/zenodo.23627609</code></a>; v2.1.0: <a href="https://doi.org/10.5281/zenodo.23627610"><code>10.5281/zenodo.23627610</code></a>) — <code>BenFrohman/NS_Millennium_Proof</code> (v2.2.0, 48 Lean 4 files, 360 theorems/lemmas, zero <code>sorry</code>).</li>
    </ul>
  </li>
  <li><strong>Verification &amp; Containment Scaffolding:</strong> <a href="https://doi.org/10.5281/zenodo.23630648"><code>10.5281/zenodo.23630648</code></a> (<code>BenFrohman/titan-audit</code>), <a href="https://doi.org/10.5281/zenodo.23631670"><code>10.5281/zenodo.23631670</code></a> (<code>BenFrohman/sealguard</code>), <a href="https://doi.org/10.5281/zenodo.23632766"><code>10.5281/zenodo.23632766</code></a> (<code>BenFrohman/sentinel-gate</code>), and <a href="https://doi.org/10.5281/zenodo.23632768"><code>10.5281/zenodo.23632768</code></a> (<code>BenFrohman/Agentic-Dev</code>).</li>
</ul>

<h4>AI-Assisted Formalization &amp; Tooling Disclosure</h4>
<p>All mathematical definitions, physical models, geometric constructions (including the Frohmanian Symplectic Tether, coadjoint-orbit projection operators, and tethered Lyapunov functionals), and proof architectures are the sole original work of <strong>Benjamin Stanley Frohman</strong>. AI coding and formalization assistants (specifically <strong>Grok / Grok Bot, xAI</strong>) were utilized strictly under the author's direction for Lean 4 proof-term translation, Mathlib4 tactic elaboration, LaTeX typesetting, and repository/provenance audit scaffolding. Every formal theorem in the released Lean 4 artifacts is independently verified by the deterministic Lean 4 kernel (<code>leanprover/lean4:v4.29.0-rc2</code> / <code>v4.30.0-rc1</code>) against Mathlib4 with zero <code>sorry</code> axioms and zero custom axioms.</p>
"""

CANONICAL_NS_DOIS = [
    ("10.5281/zenodo.23629499", "2026-06-01", "text"),      # June 1, 2026 origin manuscript
    ("10.5281/zenodo.21856430", "2026-08-19", "text"),      # Aug 19, 2026 Zenodo snapshot
    ("10.5281/zenodo.22240168", "2026-09-01", "text"),      # Sept 1, 2026 Vorticity direction
    ("10.5281/zenodo.22240549", "2026-09-01", "text"),      # Sept 1, 2026 High-set Campanato
    ("10.5281/zenodo.22835028", "2026-09-18", "text"),      # Sept 18, 2026 NS/Hodge/Triadic working notes
    ("10.5281/zenodo.22835069", "2026-09-18", "text"),      # Sept 18, 2026 Strain kernel A(theta,omega)
    ("10.5281/zenodo.23627618", "2026-09-25", "text"),      # Sept 25, 2026 Two-point strain coercivity
    ("10.5281/zenodo.23629497", "2026-10-06", "software"),  # Oct 6, 2026 bohm-identities
    ("10.5281/zenodo.23653003", "2026-10-07", "software"),  # Oct 7, 2026 global-from-local-restart
    ("10.5281/zenodo.23653013", "2026-10-07", "software"),  # Oct 7, 2026 Clay-
    ("10.5281/zenodo.23653015", "2026-10-07", "software"),  # Oct 7, 2026 Clay-CD-not-certified
    ("10.5281/zenodo.23629465", "2026-10-24", "software"),  # functional-equation-tether-b4
    ("10.5281/zenodo.23629467", "2026-10-24", "software"),  # triadic-homogenization-lean
    ("10.5281/zenodo.23632786", "2026-10-24", "text"),      # Master functional monograph
    ("10.5281/zenodo.23717082", "2026-10-27", "software"),  # frohmanian-symplectic-tether-regularity v1.1.0
    ("10.5281/zenodo.23717083", "2026-10-27", "software"),  # fefferman-clay-navier-stokes v1.1.0
    ("10.5281/zenodo.23717084", "2026-10-27", "software"),  # NS_Millennium_Proof v2.2.0
    ("10.5281/zenodo.23630648", "2026-10-24", "software"),  # titan-audit
    ("10.5281/zenodo.23631670", "2026-10-24", "software"),  # sealguard
    ("10.5281/zenodo.23632766", "2026-10-24", "software"),  # sentinel-gate
    ("10.5281/zenodo.23632768", "2026-10-24", "software"),  # Agentic-Dev
]

ORIGIN_URLS = [
    ("https://github.com/BenFrohman/frohmanian-tether-manuscript-2026-06-01/commit/6c6cac908304d1ed3c90bddc907c4d2c3f4a8d79", "isDerivedFrom", "text"),
    ("https://github.com/BenFrohman/frohmanian-tether-manuscript-2026-06-01", "references", "software"),
    ("https://github.com/BenFrohman/NS_Millennium_Proof", "references", "software"),
    ("https://github.com/BenFrohman/frohmanian-symplectic-tether-regularity", "references", "software"),
    ("https://github.com/BenFrohman/fefferman-clay-navier-stokes", "references", "software"),
]

RECORD_CREATED_DATES = {
    23629499: ("2026-06-01", "Original June 1, 2026 Overleaf import and GitHub root commit 6c6cac908304d1ed3c90bddc907c4d2c3f4a8d79 (2026-06-01 01:20:57 AM CDT); bundles April 29 – June 22, 2026 foundational manuscripts."),
    21856430: ("2026-08-19", "Historical August 19, 2026 Zenodo archival snapshot of the Frohmanian Symplectic Tether manuscript (derived from the April–June 2026 manuscripts)."),
    22240168: ("2026-09-01", "September 1, 2026 vorticity direction identities and scale-sharp regularity reduction."),
    22240549: ("2026-09-01", "September 1, 2026 high-set vorticity direction and Campanato regularity criterion."),
    22835028: ("2026-09-18", "September 16–18, 2026 working notes on 3D Navier–Stokes conditional regularity criteria, the Hodge–Navier–Stokes Lean 4 referee audit, and triadic multiscale homogenization."),
    22835069: ("2026-09-18", "September 18, 2026 Biot–Savart strain kernel A(theta,omega) identification (kappa = 3/2) and conditional regularity criterion."),
    23627618: ("2026-09-11", "September 11–25, 2026 local two-point strain coercivity analysis in the 3D vorticity equation."),
    23629497: ("2026-10-06", "October 6, 2026 zero-sorry Lean 4 formalization of pointwise Bohm identities (BenFrohman/bohm-identities)."),
    23653003: ("2026-10-07", "October 7, 2026 zero-sorry Lean 4 formalization of global-from-local restart continuation (BenFrohman/global-from-local-restart)."),
    23653013: ("2026-10-07", "October 7, 2026 formal boundary ledger for the Clay Navier–Stokes problem (BenFrohman/Clay-)."),
    23653015: ("2026-10-07", "October 7, 2026 formal boundary ledger on uncertified external equations (BenFrohman/Clay-CD-not-certified)."),
    23629465: ("2026-04-29", "April–May 2026 functional equation tether application note and October 2026 Lean 4 formalization (BenFrohman/functional-equation-tether-b4)."),
    23629467: ("2026-05-28", "May 2026 multiscale triadic homogenization notes and October 2026 Lean 4 formalization (BenFrohman/triadic-homogenization-lean)."),
    23632786: ("2026-06-01", "June 1, 2026 Frohman Symplectic and Holographic Dual Regularization Conjecture and October 24, 2026 Master Functional Lean 4 reduction."),
    23717082: ("2026-05-28", "May 28, 2026 initial Lean 4 tether formalization through October 27, 2026 v1.1.0 29-module zero-sorry release (BenFrohman/frohmanian-symplectic-tether-regularity)."),
    23717083: ("2026-06-01", "June 1, 2026 initial Navier–Stokes tether manuscript through October 27, 2026 v1.1.0 34-module zero-sorry release (BenFrohman/fefferman-clay-navier-stokes)."),
    23717084: ("2026-06-19", "June 19, 2026 NS_Millennium_Proof repository creation (commit c4fc018) through October 27, 2026 v2.2.0 48-file, 360-theorem zero-sorry release."),
}

RESTRICTED_RECORDS = {23631670, 23632766, 23632768}

def api_request(url, method="GET", data=None):
    headers = {"Authorization": f"Bearer {TOKEN}"}
    body = None
    if data is not None:
        headers["Content-Type"] = "application/json"
        body = json.dumps(data).encode("utf-8")
    req = urllib.request.Request(url, data=body, headers=headers, method=method)
    for attempt in range(4):
        try:
            with urllib.request.urlopen(req, timeout=30) as resp:
                raw = resp.read().decode("utf-8")
                return json.loads(raw) if raw else {}
        except urllib.error.HTTPError as e:
            err_body = e.read().decode("utf-8", errors="replace")
            if e.code in (429, 500, 502, 503, 504) and attempt < 3:
                time.sleep(2 * (attempt + 1))
                continue
            raise RuntimeError(f"HTTP {e.code} on {method} {url}: {err_body}")

def build_updated_metadata(rec_id, dep):
    meta = dep.get("metadata", {})
    self_doi = meta.get("doi") or f"10.5281/zenodo.{rec_id}"
    concept_recid = dep.get("conceptrecid")
    concept_doi = f"10.5281/zenodo.{concept_recid}" if concept_recid else None
    pub_date = meta.get("publication_date", "2026-10-24")

    desc = meta.get("description", "")
    marker = "<h3>Provenance &amp; Chronological Priority Ledger (April 2026 – October 2026)</h3>"
    if marker in desc:
        base_desc = desc.split("<hr>\n" + marker)[0].split(marker)[0].rstrip()
    else:
        base_desc = desc.rstrip()
    if rec_id == 21856430 and "<h3>Provenance &amp; Related Repositories</h3>" in base_desc:
        base_desc = base_desc.split("<h3>Provenance &amp; Related Repositories</h3>")[0].rstrip()

    new_desc = base_desc + "\n" + PROVENANCE_LEDGER_HTML

    existing_rels = meta.get("related_identifiers", [])
    rel_map = {}
    for r in existing_rels:
        ident = r.get("identifier", "").strip()
        if not ident:
            continue
        if ident in (self_doi, concept_doi, f"https://doi.org/{self_doi}"):
            continue
        if r.get("relation") == "isVersionOf":
            continue
        rel_val = r.get("relation", "references")
        if rel_val.lower() == "isrelatedto":
            rel_val = "references"
        entry = {
            "identifier": ident,
            "relation": rel_val,
        }
        # Zenodo Deposit PUT auto-detects scheme and validates resource_type strictly; omit optional fields
        rel_map[ident] = entry

    for url, rel, rtype in ORIGIN_URLS:
        if url not in rel_map:
            rel_map[url] = {
                "identifier": url,
                "relation": "isDerivedFrom" if (url.endswith("6c6cac908304d1ed3c90bddc907c4d2c3f4a8d79") and rec_id != 23629499) else ("isIdenticalTo" if (rec_id == 23629499 and url.endswith("frohmanian-tether-manuscript-2026-06-01")) else rel),

            }

    for target_doi, target_date, target_rtype in CANONICAL_NS_DOIS:
        if target_doi in (self_doi, concept_doi):
            continue
        if rec_id in (23652843, 23717082) and target_doi in ("10.5281/zenodo.23652842", "10.5281/zenodo.23652843", "10.5281/zenodo.23717082"):
            continue
        if rec_id in (23652841, 23717083) and target_doi in ("10.5281/zenodo.23652840", "10.5281/zenodo.23652841", "10.5281/zenodo.23717083"):
            continue
        if rec_id in (23627610, 23717084) and target_doi in ("10.5281/zenodo.23627609", "10.5281/zenodo.23627610", "10.5281/zenodo.23717084"):
            continue

        if target_doi == "10.5281/zenodo.23629499" and rec_id != 23629499:
            relation = "isDerivedFrom"
        elif target_doi == "10.5281/zenodo.21856430" and rec_id not in (23629499, 21856430):
            relation = "references"
        elif rec_id == 23629499:
            relation = "isReferencedBy"
        elif rec_id == 21856430 and target_doi != "10.5281/zenodo.23629499":
            relation = "isReferencedBy"
        elif pub_date > target_date:
            relation = "references"
        elif pub_date < target_date:
            relation = "isReferencedBy"
        else:
            relation = "references"

        rel_map[target_doi] = {
            "identifier": target_doi,
            "relation": relation,

        }

    created_start, created_desc = RECORD_CREATED_DATES.get(
        rec_id,
        (pub_date, f"Original creation and formalization date ({pub_date}, America/Chicago CDT) within the Frohmanian Navier–Stokes & Symplectic Tether programme.")
    )
    dates_list = [
        {
            "start": "2026-04-29",
            "end": "2026-06-01",
            "type": "collected",
            "description": "Foundational prior-art manuscripts: Mathematical_Food_Forethought.pdf (2026-04-29 CDT, SHA-256 20dd3b53...), Triple_conjecture_a_rigorous_refinement.pdf (2026-05-09 CDT, SHA-256 a7e3cd19...), Lean_Formalization_2026-05-28, and GitHub root commit 6c6cac908304d1ed3c90bddc907c4d2c3f4a8d79 (2026-06-01 01:20:57 AM CDT)."
        },
        {
            "start": created_start,
            "end": pub_date if pub_date >= created_start else created_start,
            "type": "created",
            "description": created_desc
        }
    ]

    existing_kw = meta.get("keywords", [])
    must_kw = [
        "3D Navier-Stokes",
        "Frohmanian Symplectic Tether",
        "Lean 4",
        "Mathlib4",
        "Beale-Kato-Majda",
        "Calderon-Zygmund",
        "Coadjoint Orbits",
        "Metriplectic Dynamics",
        "Prior Art Provenance"
    ]
    kw_set = list(existing_kw)
    for k in must_kw:
        if k not in kw_set:
            kw_set.append(k)

    is_restricted = (rec_id in RESTRICTED_RECORDS)
    access_right = "restricted" if is_restricted else "open"

    clean_meta = {
        "title": meta["title"],
        "upload_type": meta.get("upload_type", "publication"),
        "description": new_desc,
        "creators": [
            {
                "name": "Frohman, Benjamin Stanley",
                "affiliation": "Independent Researcher, Texas, United States",
                "orcid": "0009-0006-7068-3718"
            }
        ],
        "publication_date": pub_date,
        "access_right": access_right,
        "keywords": kw_set,
        "related_identifiers": list(rel_map.values()),
        "dates": dates_list,
        "language": "eng",
    }
    if not is_restricted:
        lic = meta.get("license")
        if isinstance(lic, dict):
            lic_id = lic.get("id", "apache-2.0")
        elif isinstance(lic, str) and lic:
            lic_id = lic
        else:
            lic_id = "apache-2.0"
        if lic_id == "apache2.0":
            lic_id = "apache-2.0"
        clean_meta["license"] = lic_id
    else:
        clean_meta["access_conditions"] = meta.get(
            "access_conditions",
            "Proprietary commercial software and verification architecture of Benjamin Stanley Frohman (ORCID: 0009-0006-7068-3718). Metadata and cryptographic provenance digests are public; source archive access is restricted to authorized reviewers under NDA."
        )
    if meta.get("upload_type") == "publication":
        clean_meta["publication_type"] = meta.get("publication_type", "preprint")
    if meta.get("version"):
        clean_meta["version"] = meta["version"]
    notes_str = (
        "Copyright (c) 2026 Benjamin Stanley Frohman (ORCID: 0009-0006-7068-3718). All rights reserved. "
        "Released under the Apache License, Version 2.0 (SPDX: Apache-2.0). "
        "Prior-Art Lineage: Mathematical_Food_Forethought.pdf (2026-04-29 CDT, SHA-256: 20dd3b53e02a5a3a5a02fd9f753844b162ad920cfd3e4c5f6f89106d7d66dac5); "
        "Triple_conjecture_a_rigorous_refinement.pdf (2026-05-09 CDT, SHA-256: a7e3cd19697eed920549cdfa2f6177a45312b9c2cf8e2e33fe220691f550ba61); "
        "BenFrohman/frohmanian-tether-manuscript-2026-06-01 commit 6c6cac908304d1ed3c90bddc907c4d2c3f4a8d79 (2026-06-01 01:20:57 AM CDT, DOI: 10.5281/zenodo.23629499); "
        "Historical Zenodo snapshot 10.5281/zenodo.21856430 (2026-08-19 CDT); "
        "September 2026 Working Notes 10.5281/zenodo.22835028 & 10.5281/zenodo.22835069 (2026-09-18 CDT); "
        "Lean 4 Formalizations: 10.5281/zenodo.23717082, 10.5281/zenodo.23717083, 10.5281/zenodo.23717084. "
        "AI Tooling Disclosure: Mathematical architecture and proofs by Benjamin Stanley Frohman; Lean 4 tactic translation, LaTeX typesetting, and audit scaffolding assisted by Grok (xAI)."
    )
    clean_meta["notes"] = notes_str
    return clean_meta

def update_and_publish(rec_id):
    print(f"=== Updating {rec_id} ===", flush=True)
    dep = api_request(f"{BASE_URL}/{rec_id}", "GET")
    state = dep.get("state")
    submitted = dep.get("submitted")
    print(f"  Initial state={state}, submitted={submitted}", flush=True)
    if state == "done" and submitted:
        dep = api_request(f"{BASE_URL}/{rec_id}/actions/edit", "POST")
        print(f"  Unlocked for edit -> state={dep.get('state')}", flush=True)

    new_meta = build_updated_metadata(rec_id, dep)
    updated = api_request(f"{BASE_URL}/{rec_id}", "PUT", {"metadata": new_meta})
    print(f"  PUT metadata succeeded (related_identifiers={len(updated['metadata'].get('related_identifiers', []))}, access_right={updated['metadata'].get('access_right')})", flush=True)

    published = api_request(f"{BASE_URL}/{rec_id}/actions/publish", "POST")
    print(f"  Published -> state={published.get('state')}, submitted={published.get('submitted')}, doi={published.get('doi')}", flush=True)
    return published

if __name__ == "__main__":
    ids = [int(x) for x in sys.argv[1:]]
    for rid in ids:
        update_and_publish(rid)
