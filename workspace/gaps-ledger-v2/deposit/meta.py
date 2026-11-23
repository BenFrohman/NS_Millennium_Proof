import json
desc = """<p><strong>Working notes. Does NOT claim the Clay Millennium statement. Does not derive any estimate that would close a named gap or prove an open hypothesis. No T-item is closed.</strong></p>
<p>Third version of the gaps record 10.5281/zenodo.22835069 (concept 10.5281/zenodo.22835068; second version 10.5281/zenodo.24148258). It restates the Biot&ndash;Savart identification of the strain kernel <em>A</em>(&theta;,&omega;), the prefactor value &kappa; = <em>C</em><sub>CZ</sub>(3) = 3/2, and the conditional regularity criterion of the gaps record, with the named gaps T1&ndash;T10 restated faithfully from the published PDF, and the exact Lean statements of the named open hypotheses and of the conditional implications NamedHypothesis &rarr; GlobalRegularity.</p>
<p><strong>New in this version.</strong> (a) Every Lean citation is re-pinned to a commit whose CI passed: frohmanian-tether-sdiff <code>0727e6d</code> (pull request #8; Lean sources identical to main <code>c213b5a</code>), fefferman-clay-navier-stokes <code>8d8a0cf</code>, NS_Millennium_Proof <code>b8d2f1e</code>, with line numbers re-checked. (b) Source scan: 0 sorry, admit, native_decide or axiom declarations in every .lean file of sdiff and fefferman and in every built module of NS_Millennium_Proof (NS_Millennium_Proof also keeps archival, unbuilt files under docs/ and historical/ with 105 sorry and 1 axiom declaration; none is imported by a built module or cited). (c) Kernel axiom certificate: <code>#print axioms</code> for all 42 cited declarations (31 sdiff and 7 NS_Millennium_Proof printed locally, 4 fefferman from CI run 43928116535) shows only propext, Classical.choice, Quot.sound. (d) A status table for T1&ndash;T10: T1, T2, T4, T6, T10 open; T5 enters Lean as the named hypotheses FrohmanianTetherRateSmooth / PeriodicDirectionDepletionBound, with only the scalar ODE comparison formalized; T3 and T7 have only a classical sub-piece formalized (transport maximum principle; pointwise cyclic Jacobi identity); T8 has its logic formalized and its geometry open; T9 is a scope statement. (e) Cites 10.5281/zenodo.24152113.</p>
<p>What is proved in Lean: implications from named Prop hypotheses to global regularity statements, periodic BKM continuation (<code>periodicBKMContinuation_of_classical</code>), uniqueness, zero-datum instances, and refutations of the old physical-class rate and the old two-sided depletion hypothesis. What is open: <code>PeriodicTetherClosingBound</code>, <code>FrohmanianTetherRateSmooth</code>, <code>R3BKMContinuation</code>, <code>PeriodicDirectionDepletionBound</code> for general data. By Beale&ndash;Kato&ndash;Majda, the remaining periodic closing bound is as hard as Fefferman&rsquo;s Statement (B).</p>
<p>Toolchain: leanprover/lean4:v4.30.0-rc1. Mathlib: 0c154d67103f74be3a0f2c509f72ccbf5be9f2a7. Rebuild (sdiff at 0727e6d): <code>lake exe cache get &amp;&amp; lake build &amp;&amp; lake env lean scripts/PrintGapsLedgerAxioms.lean</code>. Files: main.pdf (this note), the LaTeX source zip, and gaps-ledger-axioms.txt (the certificate).</p>
<p>Copyright &copy; 2026 Benjamin Stanley Frohman. Released under the Apache License, Version 2.0. Author: Frohman, Benjamin Stanley (ORCID 0009-0006-7068-3718; Independent Researcher, Texas, United States). Contact: frohmanbenjamin@gmail.com.</p>"""
old = json.load(open('/tmp/d.json'))['metadata']
rel = [
 {"identifier":"https://github.com/BenFrohman/frohmanian-tether-sdiff/tree/0727e6d561ca68678eb909d8b6dd120c4a2a6e15","relation":"isSupplementedBy","scheme":"url"},
 {"identifier":"https://github.com/BenFrohman/fefferman-clay-navier-stokes/tree/8d8a0cf60b06d111fdee59215797b32e6029eeff","relation":"isSupplementedBy","scheme":"url"},
 {"identifier":"https://github.com/BenFrohman/NS_Millennium_Proof/tree/b8d2f1eaa3e749eb2cb321b629259d199a4fd6b0","relation":"isSupplementedBy","scheme":"url"},
 {"identifier":"10.5281/zenodo.24148258","relation":"isNewVersionOf","scheme":"doi"},
 {"identifier":"10.5281/zenodo.22835069","relation":"isNewVersionOf","scheme":"doi"},
 {"identifier":"10.5281/zenodo.24152113","relation":"references","scheme":"doi"},
]
for r in old['related_identifiers']:
    if r['relation'] in ('cites','references') and r['identifier'] not in [x['identifier'] for x in rel] and '23717084' not in r['identifier']:
        if r['identifier']=='10.5281/zenodo.24122596': r={"identifier":"10.5281/zenodo.24148268","relation":"cites","scheme":"doi"}
        rel.append(r)
meta = {"metadata":{
 "upload_type":"publication","publication_type":"preprint",
 "title": old['title'],
 "publication_date":"2026-11-16","version":"3",
 "description":desc,"access_right":"open","license":old.get("license"),
 "creators":[{"name":"Frohman, Benjamin Stanley","affiliation":"Independent Researcher, Texas, United States","orcid":"0009-0006-7068-3718"}],
 "keywords": old['keywords']+["axiom certificate"],
 "related_identifiers":rel}}
json.dump(meta,open('/workspace/gaps-ledger-v2/deposit/meta.json','w'),indent=1)
print(json.dumps(rel,indent=0)); print(old.get('upload_type'),old.get('publication_type'),old.get('license'))
