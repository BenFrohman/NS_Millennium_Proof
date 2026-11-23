import json,re,html,glob,os,collections,csv
D={str(x['id']):x for x in json.load(open('deps_all.json'))}
rows=json.load(open('rows4.json'))
art=json.load(open('art.json'))
st=json.load(open('repos_state.json'))
trees={os.path.basename(f)[:-5]:json.load(open(f)) for f in glob.glob('trees/*.json') if os.path.getsize(f)>0}
runinfo={}
for f in glob.glob('runinfo/*.tsv'):
    t=open(f).read().strip()
    if t: p=t.split('\t'); runinfo[p[0]]=p
OKS={'24303097','24480427','24480435'}
SORRY_RUN_COMMITS={'0dc35f3','212e4e4','963b2f7'}
EXCL=re.compile(r'(/docs/|/historical/|/archive|provenance/|_original)',re.I)
SERVE={ # repo: (workflow, run, sha, note)
 'frohmanian-tether-conditional-regularity':('Lean build and kernel check',45249571059,'86336a9','verified OK Nov 23'),
 'frohmanian-tether-sdiff':('Lean certificate',45248920680,'50928f3','candidate, artifact not yet inspected'),
 'p2q-jumps-lean':('Kernel certificate',45254500178,'1f2b324','candidate, artifact not yet inspected'),
 'NS_Millennium_Proof':('Lean CI',45241230406,'6b78ba7','candidate; blocked on decision about archived .lean files with sorry'),
 'uniruled-fourfolds':('Kernel certificate',45259582237,'40e9307','candidate, artifact not yet inspected'),
 'fefferman-clay-navier-stokes':('Lean certificate',44061020672,'dd2d1ef','candidate from Nov 17, not fresh'),
 'metriplectic-world-model':('Kernel certificate',44056715862,'97d11a3','candidate from Nov 17, not fresh'),
 'ns-tether-key-estimate-refutation':('Kernel certificate',44057518507,'bdf6858','candidate from Nov 17, not fresh'),
 'Clay-':('Kernel certificate',44056686733,'85efb15','candidate from Nov 17, not fresh'),
}
POS=re.compile(r'(formali[sz]ed in Lean|Lean[- ]?4? ?(formali[sz]ation|development|proof|code|project|library|certificate|kernel|module|build)|kernel[- ]checked|kernel[- ]verified|machine[- ]checked|Lean[- ]certified|verified in Lean|in Lean 4|checked by Lean|lake build|#print axioms|proved in Lean|Lean[- ]verified|Lean[- ]synchronized|Lean (Gröbner|Stage|arithmetic)|Lean 4 / |Lean implications|Lean[- ]checked|Lean 4 Formali[sz]ation)',re.I)
WEAK=re.compile(r'(Lean 4 skeleton|Lean skeleton|statement skeleton|existential skeleton|does not compile|sorry placeholder|contains \d* *sorry)',re.I)
conrepos={}
for r in rows:
    for rp in r['repos']:
        n=rp.split('/')[1]
        conrepos.setdefault(r['concept'],[])
        if n not in conrepos[r['concept']]: conrepos[r['concept']].append(n)
out=[]
for r in rows:
    i=str(r['id']); x=D[i]; m=x['metadata']
    txt=html.unescape(re.sub('<[^>]+>',' ',m.get('description','') or '')); full=m['title']+' '+txt
    # primary repo = first mentioned
    reps=[]
    for mm in re.finditer(r'github\.com/BenFrohman/([\w.-]+?)(?:\.git)?(?=[/\s"\)\],;]|$)',full+' '+' '.join(ri.get('identifier','') for ri in m.get('related_identifiers',[]) or []),re.I):
        n=mm.group(1).rstrip('.')
        if n not in reps and n!='BenFrohman': reps.append(n)
    srcsorry=[f for f in r['src']['files_sorry'] if not EXCL.search(f)]
    exsorry=[f for f in r['src']['files_sorry'] if EXCL.search(f)]
    certfiles=r['off']+r['hw']
    md5={f:mm.replace('md5:','') for f,mm in r['files']}
    notes=[]; cls=None
    leanrepo=any((n in st and (st[n]['manifest'] or n=='symplectohydronamics')) or (n in trees and any(t.endswith('.lean') for t in trees[n])) for n in reps)
    haslean = r['src']['lean']>0 or leanrepo
    pos=len(POS.findall(full))
    if i in OKS: cls='OK'; notes.append('verified Nov 23: run 45249571059 @86336a9, manifest sha256 0024851d…, 0 sorry, standard axioms')
    elif not r['lean'] or (pos==0 and r['src']['lean']==0 and not certfiles) or (not haslean and pos==0 and not certfiles):
        cls='NO CLAIM'
        if r['lean']: notes.append('mentions Lean only incidentally / no Lean development cited')
        if r['hw']: notes.append('carries typed provenance/audit files: '+', '.join(r['hw'][:3]))
    else:
        broken=[]; hand=[]; rerun=[]
        for f in r['off']:
            a=None
            for af,ai in art.get(i,[]):
                if af==f: a=ai
            rid=re.search(r'run-?(\d{10,})',f); rid=rid and rid.group(1)
            sh=re.search(r'-([0-9a-f]{7})(?:[0-9a-f]*)?\.(tar\.gz|zip)$',f); sh=sh and sh.group(1)
            if sh in SORRY_RUN_COMMITS: broken.append(f'{f}: built commit {sh} still has the sorry in ClassicalNSOpenTarget.lean')
            if rid and rid in runinfo and runinfo[rid][6]!='success': broken.append(f'cited run {rid} concluded {runinfo[rid][6]}')
            if isinstance(a,dict):
                if not a['manifest']: rerun.append(f'{f}: official artifact but no lake-manifest.json/sha256')
                if not a['elan']: rerun.append(f'{f}: no elan version recorded')
                if not any('build' in l for l in a['logs']): rerun.append(f'{f}: no full lake build log')
        if srcsorry: broken.append(f"deposited Lean source has {r['src']['sorry']} sorry/admit (e.g. {srcsorry[0].split('/')[-1]})")
        axf=[a for a in r['src'].get('files_axiom',[]) if not EXCL.search(a)]
        if axf: broken.append(f"deposited Lean source declares custom axiom(s) (e.g. {axf[0].split('/')[-1]})")
        if WEAK.search(full) and not r['off']: broken.append('description itself says the Lean part is a skeleton, has sorry placeholders, or does not compile')
        if reps and not haslean and pos>0: broken.append('claims a Lean result but neither the record nor the cited repo contains Lean files')
        for rr in r['runs']:
            if rr in runinfo and runinfo[rr][6]!='success': broken.append(f'cited run {rr} concluded {runinfo[rr][6]}')
        if r['hw']: hand.append('hand-written/typed or local certificate files: '+', '.join(r['hw'][:6]))
        if i=='24377388': hand.insert(0,'zenodo_certificate.zip = hand-typed CERTIFICATE.md for a different repo (RCW-Residuals-Lean b2291da)')
        if i=='24302258': rerun.append('certificate from run 44047249311 @1ea649e; truth-gate PASS is at dd8e086 (run 45089388200) — certificate and locked commit differ')
        if i in ('24180777',): rerun.append('official artifact w/ manifest (sha256 4d3ae22e…) from run 44045838056 @4fcb9aa on branch chore/certify-upload-artifact (Nov 17); lock covers only L/L2; some claims rest on outside checks (PARI/Python)')
        if exsorry: notes.append(f'{len(exsorry)} archived/provenance .lean files with sorry (not in the built library; scan exclusion issue)')
        if broken: cls='BROKEN'; notes+=broken+hand+rerun
        elif hand: cls='HAND-WRITTEN/FAKE'; notes+=hand+rerun
        else:
            cls='NEEDS RERUN'; notes+= rerun or (['no certificate attached at all'] if not r['off'] else [])
    # rerun target
    if not reps: reps=conrepos.get(r['concept'],[])
    tgt=[n for n in reps if n in st and st[n]['manifest']] or [n for n in reps if n in st]
    repo=tgt[0] if tgt else (reps[0] if reps else '')
    s=st.get(repo,{})
    serve=SERVE.get(repo)
    kcw = 'yes' if repo in SERVE else ('no (kernel-certificate.yml lacks manifest+sha256/elan)' if s.get('kc') else ('no workflow' if s else ''))
    out.append(dict(id=i,concept=r['concept'],latest='Y' if r.get('latest') else '',title=m['title'],version=m.get('version',''),pub=m.get('publication_date',''),
        claims_lean='yes' if cls not in ('NO CLAIM',) else ('mention' if r['lean'] else 'no'),
        cert_files='; '.join(f"{f} ({md5[f]})" for f in certfiles),
        repos=', '.join(reps), commits=', '.join(c[:12] for c in r['commits'])+((' | '+', '.join(r['short'])) if r['short'] else ''), runs=', '.join(r['runs']),
        cls=cls, notes=' | '.join(dict.fromkeys(notes)),
        rerun_repo=repo if cls not in ('OK','NO CLAIM') else '', rerun_commit=(s.get('head','')[:12]+' ('+s.get('branch','')+')') if cls not in ('OK','NO CLAIM') and s else '',
        ci_manifest_workflow=kcw if cls not in ('OK','NO CLAIM') else '', serving_run=(f"{serve[0]} {serve[1]} @{serve[2]} ({serve[3]})" if serve else 'none') if cls not in ('OK','NO CLAIM') else ''))
# latest flag
lat={}
for o in out:
    if o['concept'] not in lat or int(o['id'])>int(lat[o['concept']]): lat[o['concept']]=o['id']
for o in out: o['latest']='Y' if lat[o['concept']]==o['id'] else ''
json.dump(out,open('final.json','w'),indent=1)
print(collections.Counter(o['cls'] for o in out))
print(collections.Counter(o['cls'] for o in out if o['latest']))
