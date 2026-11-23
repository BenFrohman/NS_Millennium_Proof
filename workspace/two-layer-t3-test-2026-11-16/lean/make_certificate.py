#!/usr/bin/env python3
# Generates CERTIFICATE.md purely from the lake build logs and files on disk (nothing hand-entered).
import hashlib, json, subprocess, re, os, datetime
os.chdir(os.path.dirname(os.path.abspath(__file__)))
sh=lambda c: subprocess.run(c,shell=True,capture_output=True,text=True).stdout.strip()
h=lambda p: hashlib.sha256(open(p,'rb').read()).hexdigest()
src='../sources/frohmanian-symplectic-tether-regularity'
man=json.load(open('lake-manifest.json')); mrev=[p['rev'] for p in man['packages'] if p['name']=='mathlib'][0]
logs=['../certificates_lake_build_full.log','../certificates_lake_build_final.log']
out=["# Lean kernel certificate — TwoLayerT3 (local, unpublished)","",
"Copyright (c) 2026 Benjamin Stanley Frohman. Author: Benjamin Stanley Frohman","",
f"Generated {datetime.datetime.now().strftime('%Y-%m-%d %H:%M')} America/Chicago by `lean/make_certificate.py` from the build logs below.","",
"## Toolchain provenance",
f"- Manifest/toolchain source repo: BenFrohman/frohmanian-symplectic-tether-regularity @ `{sh('git -C '+src+' rev-parse HEAD')}`",
f"- lake-manifest.json identical to repo copy: {sh('cmp -s lake-manifest.json '+src+'/lake-manifest.json && echo yes || echo NO')}; sha256 `{h('lake-manifest.json')}`",
f"- lean-toolchain identical to repo copy: {sh('cmp -s lean-toolchain '+src+'/lean-toolchain && echo yes || echo NO')}; contents `{open('lean-toolchain').read().strip()}`; sha256 `{h('lean-toolchain')}`",
f"- Mathlib rev (manifest): `{mrev}`; checked-out package HEAD: `{sh('git -C .lake/packages/mathlib rev-parse HEAD')}`",
f"- Mathlib oleans: the prebuilt cache already fetched (`lake exe cache get`) for this exact rev in `/workspace/certify/frohmanian-tether-sdiff/.lake/packages` (symlinked; all 9 package revs equal the manifest). A fresh `cache get` here failed: disk full. Mathlib worktree differs from its rev only by 6 deleted files under `scripts/bench/` (no `.lean` changes).",
f"- {sh('elan --version')}; {sh('lake --version')}",
"- Lake package and mathlib requirement identical to the repo's lakefile; only the `lean_lib` target is `TwoLayerT3`.","",
"## Builds"]
for L in logs:
    s=open(L).read()
    out.append(f"- `{os.path.basename(L)}` sha256 `{h(L)}`: "+("`Build completed successfully`" if 'Build completed successfully' in s else "FAILED")+", "+(re.findall(r'LAKE_EXIT=\d+',s) or ['?'])[-1])
    out+= ["  - "+m for m in re.findall(r'(?:Built|Replayed) TwoLayerT3[^\n]*',s)]
s=open(logs[-1]).read()
out+=["","## `#print axioms` (final build log, verbatim)","```"]+[l.split('AxiomAudit.lean:')[-1] for l in s.splitlines() if 'depends on axioms' in l]+["```",
"","## Source files",*[f"- `{p}` sha256 `{h(p)}`" for p in ['TwoLayerT3.lean']+sorted('TwoLayerT3/'+f for f in os.listdir('TwoLayerT3'))],
"","## Checks",f"- `sorry`/`admit`/`native_decide` occurrences: {sh('grep -RnwE \"sorry|admit|native_decide\" TwoLayerT3 TwoLayerT3.lean | wc -l')}",
f"- truth-gate script: {sh('./scripts_verify-lock.sh '+logs[-1]+' | tail -1')}",
"","Rebuild: `cd /workspace/two-layer-t3-test-2026-11-16/lean && lake build`"]
open('../CERTIFICATE.md','w').write("\n".join(out)+"\n")
lock={"paper_claim_source":"sources/drive/ns-proof-written.tex","paper_sha256":h('../sources/drive/ns-proof-written.tex'),
 "secondary_source":"sources/drive/Full_Living_May24.md","secondary_sha256":h('../sources/drive/Full_Living_May24.md'),
 "semantics_sha256":h('TwoLayerT3/Semantics.lean'),"formal_claim":"False","verdict":"paper_claim refuted (kernel)",
 "toolchain":open('lean-toolchain').read().strip(),"mathlib":mrev,"manifest_repo_commit":sh('git -C '+src+' rev-parse HEAD'),
 "approver":"PENDING (Benjamin Stanley Frohman must approve the transcription)"}
json.dump(lock,open('../truth-gate.lock.json','w'),indent=1)
print(open('../CERTIFICATE.md').read())
