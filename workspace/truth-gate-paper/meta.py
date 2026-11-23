import json
desc = """<p><strong>DRAFT, version 1.0.</strong> A methods note on the <em>Truth Gate</em>, a mechanical check that binds a Lean 4 formalization to the exact claim its paper makes.</p>
<p>Each formalization repository carries <code>Semantics.lean</code> with <code>formal_claim</code> (the statement of the main Lean theorem) and <code>paper_claim</code>, an independent Lean transcription of a verbatim sentence of the paper, recorded with the paper's path, its SHA-256 and its section. <code>paper_claim</code> is never defined as, unfolded to or aliased to <code>formal_claim</code>. The theorem <code>intended_correspondence : formal_claim &harr; paper_claim</code> must be proved by real reasoning (no <code>rfl</code>/<code>Iff.rfl</code>), with no <code>sorry</code>, <code>admit</code> or <code>native_decide</code>, and only the axioms <code>propext</code>, <code>Classical.choice</code> and <code>Quot.sound</code>. CI fails on drift, and the lock must carry the author's approval.</p>
<p>The reusable checker (BenFrohman/PipelineHalt PR #4, merge commit 56e29ecaf9b1616eaa327543d7e357d8f5d86fd8) rejects aliasing, rfl correspondences, sorry, admit, native_decide, nonstandard axioms, missing provenance and failed builds. Its CI run 43993050555 on that commit reports 15/15 locked-and-approved negative fixtures rejected and 6/6 post-approval tamper cases correct (one passing demo, five rejections).</p>
<p>The note gives a worked example (frohmanian-tether-verified, lock merged in PR #6 at 9acd434, hardened in PR #7 at fa82d34, CI axiom output), a conditional lock (frohmanian-tether-sdiff PR #10, 56b540c: the implication only, with hypothesis (i) open), a finite identity lock (eth-conflict-clause-lattice PR #4, 797f029), and two mismatches the gate reports red in NS_Millennium_Proof PR #34 (open): drift between main.tex Theorem 1.1 and global_regularity_for_NS, and the attribution of Theorem 1.1 to frohmanian_tether_theorem, whose hypothesis is proved unsatisfiable (PR #30). The author's no-partial-locks rule is described; an audit of merged locks against it is in progress.</p>
<p><strong>Scope.</strong> The gate certifies only that a kernel-checked proof inhabits the locked transcription of the paper's claim. It does not certify that any open problem, including the Navier&ndash;Stokes problem, is solved. Transcription fidelity rests on the author's approval. Conditional results stay conditional.</p>
<p><strong>Reproducibility.</strong> https://github.com/BenFrohman/frohmanian-tether-verified at commit fa82d34a15a0c61d2ba24167517896ab5276c52d; Lean leanprover/lean4:v4.30.0-rc1; Mathlib 0c154d67103f74be3a0f2c509f72ccbf5be9f2a7 (v4.30.0-rc1); axioms of intended_correspondence: [propext, Classical.choice, Quot.sound]. Verify: <code>git clone https://github.com/BenFrohman/frohmanian-tether-verified &amp;&amp; cd frohmanian-tether-verified &amp;&amp; git checkout fa82d34a15a0c61d2ba24167517896ab5276c52d &amp;&amp; lake exe cache get &amp;&amp; bash scripts/verify-lock.sh</code></p>
<p>&copy; 2026 Benjamin Stanley Frohman. Licensed under CC BY 4.0.</p>"""
gh="https://github.com/BenFrohman/"
rel=[
 (gh+"PipelineHalt/tree/56e29ecaf9b1616eaa327543d7e357d8f5d86fd8"),
 (gh+"frohmanian-tether-verified/tree/fa82d34a15a0c61d2ba24167517896ab5276c52d"),
 (gh+"frohmanian-tether-verified/tree/9acd434cd70a732c6b4c5f4616ac3f48eb640382"),
 (gh+"frohmanian-tether-sdiff/tree/56b540c80c4c76f20646e51971390cd3367bae23"),
 (gh+"eth-conflict-clause-lattice/tree/797f0296b6671bb71d724f10321464eff931f30e"),
 (gh+"NS_Millennium_Proof/pull/34"),
]
m={"metadata":{
 "upload_type":"publication","publication_type":"preprint",
 "title":"The Truth Gate: Locking Lean Formalizations to Their Papers' Exact Claims",
 "version":"1.0 (draft)",
 "creators":[{"name":"Frohman, Benjamin Stanley","orcid":"0009-0006-7068-3718","affiliation":"Independent Researcher, Texas, United States"}],
 "license":"cc-by-4.0","access_right":"open",
 "keywords":["Lean 4","formal verification","Mathlib","semantics lock","reproducibility"],
 "description":desc,
 "related_identifiers":[{"identifier":u,"relation":"isSupplementedBy","resource_type":"software","scheme":"url"} for u in rel],
 "notes":"DRAFT. Not to be published without explicit approval from Benjamin Stanley Frohman.",
 "prereserve_doi":True}}
json.dump(m,open("meta.json","w"),ensure_ascii=False)
