#!/usr/bin/env python3
"""Replace files and metadata on four unpublished Zenodo drafts. NEVER publish."""
from __future__ import annotations
import json, os, subprocess, sys, tempfile, time
from pathlib import Path

TOKEN = os.environ['ZENODO_ACCESS_TOKEN']
API = 'https://zenodo.org/api/deposit/depositions'
ROOT = Path('/workspace/cert-bundle-prs/rebuild/upload')
META = Path('/workspace/cert-bundle-prs/rebuild/zenodo-meta')

COPYRIGHT_P = (
    "<p>Copyright (c) 2026 Benjamin Stanley Frohman (ORCID 0009-0006-7068-3718). "
    "Independent Researcher, Texas, United States. The paper (PDF and TeX source) "
    "is licensed CC BY 4.0. The Lean source and Lean kernel certificates are licensed "
    "Apache-2.0. Please cite this work and credit Benjamin Stanley Frohman as the author.</p>"
)

NOTES = (
    "Copyright (c) 2026 Benjamin Stanley Frohman (ORCID 0009-0006-7068-3718), "
    "Independent Researcher, Texas, United States. The paper / PDF is licensed CC BY 4.0. "
    "The Lean source and Lean kernel certificate files are licensed Apache-2.0. "
    "Any use, reproduction, or redistribution must retain this notice and credit "
    "Benjamin Stanley Frohman as the author; please cite this record's DOI."
)

def curl(args, input_bytes=None, timeout=300):
    """Run curl; do not log the Authorization header value."""
    cmd = ['curl', '-sS', '--fail-with-body', '--retry', '5', '--retry-delay', '3',
           '--max-time', str(timeout), *args]
    r = subprocess.run(cmd, input=input_bytes, capture_output=True)
    if r.returncode != 0:
        # scrub token if it leaked into args (it should not)
        err = r.stderr.decode('utf-8', 'replace') + '\n' + r.stdout.decode('utf-8', 'replace')
        err = err.replace(TOKEN, '[redacted]')
        raise RuntimeError(f'curl failed ({r.returncode}): {err[:2000]}')
    return r.stdout

def api(method, path, *, json_body=None, timeout=180):
    hdr_file = Path(tempfile.mkstemp(prefix='zhdr_')[1])
    hdr_file.write_text(f'Authorization: Bearer {TOKEN}\nContent-Type: application/json\n')
    hdr_file.chmod(0o600)
    try:
        args = ['-X', method, '-H', f'@{hdr_file}', f'{API}{path}']
        body = None
        if json_body is not None:
            args += ['--data-binary', '@-']
            body = json.dumps({'metadata': json_body}).encode()
        out = curl(args, input_bytes=body, timeout=timeout)
        return json.loads(out) if out else None
    finally:
        hdr_file.unlink(missing_ok=True)

def get_dep(recid):
    return api('GET', f'/{recid}')

def put_meta(recid, metadata):
    return api('PUT', f'/{recid}', json_body=metadata, timeout=180)

def delete_file(recid, file_id):
    hdr_file = Path(tempfile.mkstemp(prefix='zhdr_')[1])
    hdr_file.write_text(f'Authorization: Bearer {TOKEN}\n')
    hdr_file.chmod(0o600)
    try:
        curl(['-X', 'DELETE', '-H', f'@{hdr_file}',
              f'{API}/{recid}/files/{file_id}'], timeout=120)
    finally:
        hdr_file.unlink(missing_ok=True)

def upload_file(bucket, filepath: Path):
    hdr_file = Path(tempfile.mkstemp(prefix='zhdr_')[1])
    hdr_file.write_text(f'Authorization: Bearer {TOKEN}\n')
    hdr_file.chmod(0o600)
    try:
        # URL-encode filename minimally
        name = filepath.name
        url = f'{bucket}/{name}'
        curl(['-H', f'@{hdr_file}', '--upload-file', str(filepath), url], timeout=600)
    finally:
        hdr_file.unlink(missing_ok=True)

def strip_doi_fields(md):
    md = dict(md)
    md.pop('doi', None)
    md.pop('prereserve_doi', None)
    return md

def load_base(recid):
    return json.loads((META / f'{recid}.json').read_text())

# -------------------- metadata builders --------------------

def meta_p2q():
    md = strip_doi_fields(load_base(24180777))
    md['publication_date'] = '2026-11-17'
    md['version'] = '1.4'
    md['license'] = 'cc-by-4.0'
    md['notes'] = NOTES + (
        " Truth Gate is pending author approval. PARI, LMFDB and Python results are outside checks, "
        "not Lean kernel certificates. The p=7 descent and Hypothesis H1 are outside-Lean checks "
        "(computer-assisted trust for H1) and are not kernel-checked."
    )
    md['related_identifiers'] = [
        {'identifier': '10.5281/zenodo.24180774', 'relation': 'isNewVersionOf', 'scheme': 'doi'},
        {'identifier': 'https://github.com/BenFrohman/p2q-jumps-lean/commit/4fcb9aaec87502ea77cc9efa777aaa1c9279a064',
         'relation': 'isSupplementTo', 'scheme': 'url'},
        {'identifier': 'https://github.com/BenFrohman/p2q-jumps-lean/actions/runs/44045838056',
         'relation': 'isSupplementedBy', 'scheme': 'url'},
        {'identifier': 'https://github.com/BenFrohman/p2q-jumps-lean/commit/1e9031a840d381991632b6fcc9efecc52d6099a5',
         'relation': 'references', 'scheme': 'url'},
        {'identifier': 'https://github.com/BenFrohman/p2q-jumps-lean/commit/140af8aa1dbb8cef453f9b5b206a97707ed4195d',
         'relation': 'references', 'scheme': 'url'},
    ]
    md['description'] = COPYRIGHT_P + """
<p>Version 1.4 (17 November 2026) of further constraints on simultaneous totient and divisor-sum jumps of length 12 for <em>n</em> = <em>p</em>²<em>q</em>. Concept DOI: <a href="https://doi.org/10.5281/zenodo.22713135">10.5281/zenodo.22713135</a>. This record is a new version of <a href="https://doi.org/10.5281/zenodo.24180774">10.5281/zenodo.24180774</a>. This record does not close the problem.</p>
<p><strong>Theorem L is a set of necessary conditions, not a resolution.</strong> If distinct primes <em>p</em>, <em>q</em> satisfy both length-12 jumps at <em>n</em> = <em>p</em>²<em>q</em> and <em>N</em> = <em>n</em>+12, then: (i) <em>N</em> is not prime and is not a product of two distinct primes; (ii) <em>N</em> is not a product of three distinct primes; (iii) <em>N</em> is not of the form <em>r</em>²<em>st</em> with pairwise distinct primes <em>r</em>, <em>s</em>, <em>t</em> ≥ 5; (iv) if <em>N</em> = <em>r</em>³<em>s</em> with distinct primes <em>r</em>, <em>s</em> ≥ 5, then <em>p</em> &lt; <em>r</em>, <em>r</em>² divides <em>p</em>³−<em>p</em>²−12, and <em>p</em> &gt; 10⁴; (v) <em>n</em> &gt; 10⁴. These are narrowing conditions that exclude several shapes for <em>N</em>. They do not prove that no such jump exists, and Conjecture 3 remains open.</p>
<p>The Lean 4 formalization of Theorem L that is present on the certified commit is kernel-checked: a clean <code>lake build</code> and an axiom audit showing only the standard axioms <code>propext</code>, <code>Classical.choice</code>, and <code>Quot.sound</code>. Lean kernel certificates in this version are taken from the GitHub Actions artifact of run <a href="https://github.com/BenFrohman/p2q-jumps-lean/actions/runs/44045838056">44045838056</a> (push of pull request #9, commit <code>4fcb9aaec87502ea77cc9efa777aaa1c9279a064</code>). That artifact records <code>elan 4.2.4</code> (227caca13 2026-08-25), Lake 5.0.0-src+d8204c9, Lean 4.26.0, and Mathlib by commit hash <code>2df2f0150c275ad53cb3c90f7c98ec15a56a1a67</code> (input revision <code>v4.26.0</code>) from this repository's own <code>lake-manifest.json</code> (sha256 <code>4d3ae22e8ed4d49aca48ed63bd17a6e491c1a7d22469f20494b7c147a85f0dcc</code>). The attached full job log of that run also records the line &quot;OK: no sorry/admit/native_decide, no axiom declarations&quot;. Rebuild: <code>lake exe cache get &amp;&amp; lake build &amp;&amp; lake env lean AxiomAudit.lean</code>.</p>
<p>The <em>p</em>=7 descent and Hypothesis H1 are not in the Lean sources of that commit. They remain outside-Lean checks. Hypothesis H1 is a computer-assisted-trust argument, not a Lean kernel certificate, and it is not presented as kernel-checked. An attempt to formalize those statements remains in unmerged pull request #7 and is not part of this certificate. The Truth Gate lock remains pending author approval: Benjamin Stanley Frohman has not yet confirmed that the Lean <code>paper_claim</code> transcribes Theorem L as meant. That pending sign-off is the only remaining Truth Gate step; it is not a kernel failure.</p>
<p>LMFDB curve 3936.b1 (the curve <em>y</em>² = <em>x</em>³ − <em>x</em>² − 12) has <strong>rank 1</strong>. An earlier version wrongly stated that the rank was 0; that claim is corrected and is not made here. The LMFDB lookups, the PARI computations, and the Python search logs are outside checks. They are not Lean kernel certificates and they do not prove or pass any Lean theorem.</p>
"""
    return md

def meta_gaps():
    md = strip_doi_fields(load_base(24302371))
    md['publication_date'] = '2026-11-17'
    md['version'] = '4'
    md['license'] = 'cc-by-4.0'
    md['notes'] = NOTES + (
        " Historical workflows at the cited commits did not print elan --version; no elan version is invented."
    )
    rel = []
    for r in md.get('related_identifiers') or []:
        if r.get('relation') == 'isNewVersionOf':
            continue
        rel.append(r)
    rel.insert(0, {'identifier': '10.5281/zenodo.24289291', 'relation': 'isNewVersionOf', 'scheme': 'doi'})
    md['related_identifiers'] = rel
    # surgical description from existing, with replacements
    desc = Path('/workspace/cert-bundle-prs/rebuild/zenodo-meta/24302371.description.html').read_text()
    desc = desc.replace(
        'Third version of the gaps record 10.5281/zenodo.22835069 (concept 10.5281/zenodo.22835068; second version 10.5281/zenodo.24148258).',
        'Fourth version of the gaps record, a new version of 10.5281/zenodo.24289291 (concept 10.5281/zenodo.22835068; first version 10.5281/zenodo.22835069; second version 10.5281/zenodo.24148258; third version 10.5281/zenodo.24289291).'
    )
    desc = desc.replace(
        'Kernel axiom certificate: <code>#print axioms</code> for all 42 cited declarations (31 sdiff and 7 NS_Millennium_Proof printed locally, 4 fefferman from CI run 43928116535) shows only propext, Classical.choice, Quot.sound.',
        'Kernel axiom certificate, from raw CI output only: every cited declaration appears in the sdiff artifact of run 43933623627, the fefferman job log of run 43928116535, or the NS_Millennium_Proof job log of run 43928069777. In particular, that last raw log contains the tabulated lines <code>AXIOM FrohmanianTether.HighSetDepletionAndBKM.clay_reduces_to_direction_curvature_bound NS_Millennium_Proof.Modules.MainTheorem # [propext, Classical.choice, Quot.sound]</code> and <code>AXIOM TetherRateCounterexample.not_frohmanianTetherRate_U NS_Millennium_Proof.Modules.TetherRateCounterexample # [propext, Classical.choice, Quot.sound]</code> (lines 1118 and 1238 of the saved job log). This version does not cite a local print or the withdrawn file gaps-ledger-axioms.txt. Every axiom set in those raw outputs is contained in {propext, Classical.choice, Quot.sound}.'
    )
    desc = desc.replace(
        'Rebuild (sdiff at 0727e6d): <code>lake exe cache get &amp;&amp; lake build &amp;&amp; lake env lean scripts/PrintGapsLedgerAxioms.lean</code>. Files: main.pdf (this note), the LaTeX source zip, and gaps-ledger-axioms.txt (the certificate).',
        'Rebuild (sdiff at 0727e6d): <code>lake exe cache get &amp;&amp; lake build</code>. The historical workflows did not print <code>elan --version</code>; no elan version is invented. Files: gaps-ledger-v4.pdf (this note), gaps-ledger-v4-source.zip, and gaps-ledger-raw-ci-artifacts-v4.zip (the raw CI materials). The hand-assembled file gaps-ledger-axioms.txt is withdrawn.'
    )
    desc = desc.replace(
        'Copyright &copy; 2026 Benjamin Stanley Frohman. Released under the Apache License, Version 2.0. Author: Frohman, Benjamin Stanley (ORCID 0009-0006-7068-3718; Independent Researcher, Texas, United States). Contact: frohmanbenjamin@gmail.com.',
        'Copyright (c) 2026 Benjamin Stanley Frohman. The paper is licensed CC BY 4.0. The Lean source and Lean kernel certificates are licensed Apache-2.0. Author: Frohman, Benjamin Stanley (ORCID 0009-0006-7068-3718; Independent Researcher, Texas, United States). Contact: frohmanbenjamin@gmail.com.'
    )
    if not desc.strip().startswith('<p>Copyright (c) 2026 Benjamin Stanley Frohman'):
        desc = COPYRIGHT_P + desc
    md['description'] = desc
    return md

def meta_ns():
    md = strip_doi_fields(load_base(24302372))
    md['publication_date'] = '2026-11-17'
    md['version'] = '2.6.0'
    md['license'] = 'cc-by-4.0'
    md['notes'] = NOTES + (
        " Historical workflow at 6c79135 / run 43047743968 did not print elan --version; no elan version is invented. "
        "Rebuild: lake exe cache get && lake build. The excerpt CI_audit_excerpt_run43047743968.txt is not attached to this version."
    )
    rel = []
    for r in md.get('related_identifiers') or []:
        if r.get('relation') == 'isNewVersionOf':
            continue
        rel.append(r)
    rel.insert(0, {'identifier': '10.5281/zenodo.24144853', 'relation': 'isNewVersionOf', 'scheme': 'doi'})
    md['related_identifiers'] = rel
    dates = md.get('dates') or []
    fixed = []
    for d in dates:
        d = dict(d)
        if d.get('type') == 'created' and not d.get('start'):
            d['start'] = '2026-10-28'
        if d.get('type') in ('created', 'collected', 'valid', 'issued') and not d.get('start'):
            # skip undated entries
            continue
        fixed.append(d)
    md['dates'] = fixed
    desc = Path('/workspace/cert-bundle-prs/rebuild/zenodo-meta/24302372.description.html').read_text()
    desc = desc.replace(
        'The file <code>CI_audit_excerpt_run43047743968.txt</code> already present from version 2.5.0 is an excerpt, not a raw CI artifact.',
        'The excerpt file <code>CI_audit_excerpt_run43047743968.txt</code> from version 2.5.0 is not attached to this version; the full job log of run 43047743968 is attached instead.'
    )
    # add rebuild + elan into the first strong version paragraph if missing
    needle = 'The paper is licensed CC BY 4.0; the Lean source and Lean kernel materials are licensed Apache-2.0.</p>'
    insert = (
        ' Rebuild: <code>lake exe cache get &amp;&amp; lake build</code>. '
        'The historical workflow did not print <code>elan --version</code>; no elan version is invented. '
        'Manifest sha256: <code>b81d814b7d2d2d2821b03ed679324d5e7ec7da674e0a977352d01c88cbe8ccb8</code>. '
        'The paper is licensed CC BY 4.0; the Lean source and Lean kernel materials are licensed Apache-2.0.</p>'
    )
    if 'elan --version' not in desc:
        if needle not in desc:
            raise SystemExit('NS license sentence not found for elan insert')
        desc = desc.replace(needle, insert, 1)
    if not desc.strip().startswith('<p>Copyright (c) 2026 Benjamin Stanley Frohman'):
        desc = COPYRIGHT_P + desc
    md['description'] = desc
    return md

def meta_ref():
    md = strip_doi_fields(load_base(24302373))
    md['publication_date'] = '2026-11-17'
    md['version'] = '1.2.0'
    md['license'] = 'cc-by-4.0'
    md['notes'] = NOTES + (
        " The maximum ||ω₁||_∞ = 12 rests on sympy/Arb (scripts/v2_maxcert.py, python-flint/Arb) and is an outside check; "
        "Lean does not certify it. The attached lean-kernel/github-actions-job-log-run42916652258.log is the full job log of run 42916652258, not the 1.8 KB artifact tail. "
        "The historical workflow did not print elan --version; no elan version is invented."
    )
    rel = list(md.get('related_identifiers') or [])
    if not any(r.get('relation')=='isNewVersionOf' for r in rel):
        rel.insert(0, {'identifier': '10.5281/zenodo.24121364', 'relation': 'isNewVersionOf', 'scheme': 'doi'})
    md['related_identifiers'] = rel
    desc = Path('/workspace/cert-bundle-prs/rebuild/zenodo-meta/24302373.description.html').read_text()
    old0 = (
        '<p><strong>Version 1.2.0 (17 November 2026).</strong> This version keeps the paper and the Lean claims of version 1.1.0 and relabels the certificate files. The Lean kernel materials are the raw GitHub Actions <code>verify-logs</code> artifacts of runs <a href="https://github.com/BenFrohman/ns-tether-key-estimate-refutation/actions/runs/42916652258">42916652258</a> and <a href="https://github.com/BenFrohman/ns-tether-key-estimate-refutation/actions/runs/42916649801">42916649801</a> at commit <code>715626e</code>, which are byte-identical and include <code>axioms.log</code> and <code>lake_build.log</code>, together with this repository\'s own <code>lean/lake-manifest.json</code> and <code>lean/lean-toolchain</code> at that commit, with sha256. The file previously presented as <code>v2_maxcert.log</code> is an Arb interval-arithmetic numeric check, not a Lean kernel certificate; it is now labeled <code>outside-check-arb-v2_maxcert.log</code>. The same CI artifact also contains Python / sympy logs (<code>v1_trig_example.log</code>, <code>v2_symbolic.log</code>, <code>v2_sym.pkl</code>), which are likewise outside checks. These are packed, with that labeling, in <code>key-estimate-refutation-certificate-bundle-v1.2.0.zip</code>. The mathematical claims are unchanged. No claim about the Clay Millennium Problem is made. The paper is licensed CC BY 4.0; the Lean source and Lean kernel materials are licensed Apache-2.0.</p>'
    )
    new0 = (
        '<p><strong>Version 1.2.0 (17 November 2026).</strong> This version is a new version of <a href="https://doi.org/10.5281/zenodo.24121364">10.5281/zenodo.24121364</a> and keeps the mathematical claims of version 1.1.0, with accurate labels of what is kernel-checked. This record contains a single paper PDF, <code>ns-key-estimate-refutation-v1.2.0.pdf</code>. The Lean kernel materials are the raw GitHub Actions <code>verify-logs</code> artifacts of runs <a href="https://github.com/BenFrohman/ns-tether-key-estimate-refutation/actions/runs/42916652258">42916652258</a> and <a href="https://github.com/BenFrohman/ns-tether-key-estimate-refutation/actions/runs/42916649801">42916649801</a> at commit <code>715626e</code>, which are byte-identical and include <code>axioms.log</code> and the short artifact <code>lake_build.log</code>, together with this repository\'s own <code>lean/lake-manifest.json</code> and <code>lean/lean-toolchain</code> at that commit, with sha256. The attached archive also contains the full GitHub Actions job log of run 42916652258 (not the 1.8 KB artifact tail alone). The maximum ‖ω₁‖<sub>∞</sub> = 12 rests on sympy/Arb (<code>scripts/v2_maxcert.py</code>, python-flint/Arb) and is an outside numeric check; Lean does not certify this maximum. The same CI artifact also contains Python / sympy logs (<code>v1_trig_example.log</code>, <code>v2_symbolic.log</code>, <code>v2_sym.pkl</code>), which are likewise outside checks. These are packed, with that labeling, in <code>key-estimate-refutation-certificate-bundle-v1.2.0.zip</code>. No claim about the Clay Millennium Problem is made. The paper is licensed CC BY 4.0; the Lean source and Lean kernel materials are licensed Apache-2.0. The historical workflow did not print <code>elan --version</code>; no elan version is invented.</p>'
    )
    if old0 not in desc:
        raise SystemExit('refutation para 0 not found exactly')
    desc = desc.replace(old0, new0)
    desc = desc.replace(
        'The counterexample is a Navier–Stokes-scaled localized vortex, with its sup-vorticity maximum certified by rigorous interval arithmetic (Arb).',
        'The counterexample is a Navier–Stokes-scaled localized vortex, with its sup-vorticity maximum reported by an outside Arb interval-arithmetic check; Lean does not certify this maximum.'
    )
    desc = desc.replace(
        '<li>the Arb interval certificate and sympy values;</li>',
        '<li>the Arb interval-arithmetic outside check of ‖ω₁‖<sub>∞</sub> = 12, and sympy values (Lean does not certify this maximum);</li>'
    )
    desc = desc.replace(
        'and the Arb certificate result (<code>v2_maxcert.log</code>) containing the line "CERTIFIED: max |omega1|^2 = 144 attained only at the origin; M_1 = ||omega1||_inf = 12"',
        'and the Arb outside-check result (<code>v2_maxcert.log</code>) containing the line "CERTIFIED: max |omega1|^2 = 144 attained only at the origin; M_1 = ||omega1||_inf = 12" (that line is an Arb numeric check, not a Lean kernel certificate)'
    )
    desc = desc.replace(
        'The source repository, with one-command verification (verify.sh), is at https://github.com/BenFrohman/ns-tether-key-estimate-refutation. The work is licensed under the Apache License 2.0.',
        'The source repository, with one-command verification (verify.sh), is at https://github.com/BenFrohman/ns-tether-key-estimate-refutation. The paper is licensed CC BY 4.0. The Lean source and Lean kernel certificates are licensed Apache-2.0.'
    )
    if not desc.strip().startswith('<p>Copyright (c) 2026 Benjamin Stanley Frohman'):
        desc = COPYRIGHT_P + desc
    md['description'] = desc
    return md

# file order: PDF first
FILES = {
    24180777: [
        'p2q-jumps-v1.4.pdf',
        'p2q-jumps-v1.4-source.zip',
        'NOTICE',
        'p2q-jumps-lean-kernel-certificate-4fcb9aa-run44045838056.zip',
        'p2q-jumps-outside-checks-4fcb9aa.zip',
        'p2q-jumps-lean-4fcb9aaec87502ea77cc9efa777aaa1c9279a064.zip',
        'SHA256SUMS',
    ],
    24302371: [
        'gaps-ledger-v4.pdf',
        'gaps-ledger-v4-source.zip',
        'NOTICE',
        'gaps-ledger-raw-ci-artifacts-v4.zip',
        'SHA256SUMS',
    ],
    24302372: [
        'Frohman_NS_Millennium_Proof_v2.6.0.pdf',
        'Frohman_NS_Millennium_Proof_v2.6.0.tex',
        'NOTICE',
        'ns-millennium-certificate-provenance-v2.6.0.zip',
        'NS_Millennium_Proof-6c79135d30fdd03d6b7520d47eec4fefa5ec7f03.zip',
        'SHA256SUMS',
    ],
    24302373: [
        'ns-key-estimate-refutation-v1.2.0.pdf',
        'ns-key-estimate-refutation-v1.2.0-source.zip',
        'NOTICE',
        'key-estimate-refutation-certificate-bundle-v1.2.0.zip',
        'ns-tether-key-estimate-refutation-715626e.zip',
        'SHA256SUMS',
    ],
}

BUILDERS = {
    24180777: meta_p2q,
    24302371: meta_gaps,
    24302372: meta_ns,
    24302373: meta_ref,
}

def process(recid):
    print(f'\n========== {recid} ==========', flush=True)
    dep = get_dep(recid)
    state = dep.get('state')
    submitted = dep.get('submitted')
    print(f'  state={state} submitted={submitted}', flush=True)
    if submitted or state == 'done':
        raise SystemExit(f'REFUSING to touch published record {recid}')
    # never follow a publish link
    if 'publish' in (dep.get('links') or {}) and False:
        pass
    md = BUILDERS[recid]()
    # sanity
    desc = md['description']
    assert 'Copyright (c) 2026 Benjamin Stanley Frohman' in desc
    assert '/workspace' not in desc
    assert md['publication_date'] == '2026-11-17'
    assert 'draft' not in (md.get('version') or '').lower()
    print(f'  PUTting metadata version={md["version"]} date={md["publication_date"]}', flush=True)
    put_meta(recid, md)
    dep = get_dep(recid)
    if dep.get('submitted') or dep.get('state') == 'done':
        raise SystemExit(f'Unexpected published state after metadata PUT for {recid}')
    # delete existing files
    files = list(dep.get('files') or [])
    print(f'  deleting {len(files)} existing files', flush=True)
    for f in files:
        fid = f.get('id')
        name = f.get('filename') or f.get('key')
        print(f'    delete {name}', flush=True)
        delete_file(recid, fid)
        time.sleep(0.3)
    dep = get_dep(recid)
    leftover = dep.get('files') or []
    if leftover:
        raise SystemExit(f'leftover files after delete on {recid}: {leftover}')
    bucket = dep['links']['bucket']
    # upload in order, PDF first
    for name in FILES[recid]:
        path = ROOT / str(recid) / name
        if not path.is_file():
            raise SystemExit(f'missing file {path}')
        print(f'    upload {name} ({path.stat().st_size} bytes)', flush=True)
        upload_file(bucket, path)
        time.sleep(0.4)
    dep = get_dep(recid)
    names = [f.get('filename') or f.get('key') for f in dep.get('files') or []]
    print(f'  final state={dep.get("state")} submitted={dep.get("submitted")} files={names}', flush=True)
    if dep.get('submitted') or dep.get('state') == 'done':
        raise SystemExit(f'Unexpected published state after upload for {recid}')
    md2 = dep.get('metadata') or {}
    print(f'  version={md2.get("version")!r} date={md2.get("publication_date")} license={md2.get("license")}', flush=True)
    rel = [r for r in (md2.get('related_identifiers') or []) if r.get('relation')=='isNewVersionOf']
    print(f'  isNewVersionOf={rel}', flush=True)
    assert 'Copyright (c) 2026 Benjamin Stanley Frohman' in (md2.get('description') or '')
    # first file should be the PDF
    if names and not names[0].endswith('.pdf'):
        print(f'  WARNING: first file is not PDF: {names[0]}', flush=True)
    return {
        'id': recid,
        'state': dep.get('state'),
        'submitted': dep.get('submitted'),
        'version': md2.get('version'),
        'date': md2.get('publication_date'),
        'files': names,
        'isNewVersionOf': rel,
        'doi': (md2.get('prereserve_doi') or {}).get('doi') or md2.get('doi'),
        'concept': dep.get('conceptrecid'),
    }

def main():
    results = []
    recids = [24180777, 24302371, 24302372, 24302373]
    if len(sys.argv) > 1:
        recids = [int(x) for x in sys.argv[1:]]
    for recid in recids:
        results.append(process(recid))
    out = Path('/workspace/cert-bundle-prs/rebuild/upload/RESULT.json')
    out.write_text(json.dumps(results, indent=2))
    print('\nWrote', out)
    print(json.dumps(results, indent=2))

if __name__ == '__main__':
    main()
