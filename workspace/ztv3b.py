import os,requests,json
T=os.environ['ZENODO_ACCESS_TOKEN'];A='https://zenodo.org/api/deposit/depositions';P={'access_token':T}
i=open('ztv3_id').read();m=json.load(open('ztv3_meta.json'))
d=m['description']
d=d.replace('<p>Version 2. Scope matched to the green Lean 4 build of the <strong>private repository</strong> frohmanian-tether-sdiff (branch gateaux-pairing, Lean commit b2f9b2f; manuscript commit be523a9). <code>lake build</code> succeeds (2713 jobs); scripts/AxiomAudit.lean audits 526 theorems with no nonstandard axioms (only propext, Classical.choice, Quot.sound).</p>',
 '<p>Version 3. Scope matched to the Lean 4 build of the <strong>public repository</strong> <a href="https://github.com/BenFrohman/frohmanian-tether-geometric">BenFrohman/frohmanian-tether-geometric</a> (branch gateaux-pairing, commit 9e40ae7, which contains Lean commit b2f9b2f). scripts/AxiomAudit.lean checks that the audited theorems use only the standard axioms (propext, Classical.choice, Quot.sound). This version replaces the v2 PDF, which cited a private repository.</p>')
assert 'Version 3' in d
m['description']=d;m['version']='3'
m['related_identifiers']=[{"identifier":"https://github.com/BenFrohman/frohmanian-tether-geometric","relation":"isSupplementedBy","resource_type":"software","scheme":"url"}]
m.pop('doi',None)
r=requests.put(f'{A}/{i}',params=P,json={'metadata':m});print(r.status_code)
x=r.json();print(x.get('metadata',{}).get('prereserve_doi'),x.get('state'),x.get('submitted'))
print(json.dumps(x['metadata']['related_identifiers']));print([(f['filename'],f['checksum'],f['filesize']) for f in x['files']])
if r.status_code>=300:print(r.text)
