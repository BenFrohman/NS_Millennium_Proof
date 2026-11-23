import os,requests,json,sys
T=os.environ['ZENODO_ACCESS_TOKEN'];A='https://zenodo.org/api';H={'Authorization':'Bearer '+T}
r=requests.get(f'{A}/records/23842555/versions/latest' if False else f'{A}/deposit/depositions/23851666',headers=H).json()
print('v9 state',r.get('state'),r['metadata'].get('version'),r['metadata'].get('license'))
nv=requests.post(f'{A}/deposit/depositions/23851666/actions/newversion',headers=H).json()
d=requests.get(nv['links']['latest_draft'],headers=H).json();did=d['id'];print('draft',did)
for f in d.get('files',[]): requests.delete(f"{A}/deposit/depositions/{did}/files/{f['id']}",headers=H)
p='/workspace/pnc/paper/periodic-ns-classical-continuation.pdf'
with open(p,'rb') as fh: print('upload',requests.put(f"{d['links']['bucket']}/periodic-ns-classical-continuation.pdf",data=fh,headers=H).status_code)
m=d['metadata']
m['title']="A Lean 4 Formalization of the Classical Continuation Chain for Periodic Navier–Stokes on 𝕋³: Local Theory, BKM Criterion, and a Conditional Reduction of Statement (B)"
m['description']="<p>A machine-checked Lean 4/Mathlib formalization (repository BenFrohman/periodic-ns-classical-continuation, commit 9e43113 (Lean audit as of parent 36fa434)) of the classical continuation theory for smooth incompressible Navier–Stokes on the periodic torus, modelled as ℝ³ with ℤ³-periodicity and unit-cell integrals. It is proved using only the standard axioms (propext, Classical.choice, Quot.sound), with 1048 theorems, 285 definitions and no sorry. The results are: local existence for ν ≥ 0, energy-estimate uniqueness, maximal solutions, the Hˢ blow-up alternative for s &gt; 5/2, H³ Beale–Kato–Majda control, and the BKM criterion. It is further proved that PeriodicBKMIntegrability ⇔ PeriodicGlobalLifespan ⇒ Clay_B_exact. PeriodicBKMIntegrability is the sole open input and is equivalent to the full Millennium-problem content. This work does not solve the Clay problem or prove global regularity of 3D Navier–Stokes. Includes an axiom-audit appendix.</p>"
m['keywords']=["Navier–Stokes","periodic torus","Beale–Kato–Majda criterion","Lean 4","Mathlib","formal verification","local existence","blow-up alternative","conditional reduction","axiom audit"]
m['creators']=[{'name':'Frohman, Benjamin Stanley','orcid':'0009-0006-7068-3718','affiliation':'Independent Researcher'}]
m['version']='v10'; m.pop('doi',None); m.pop('prereserve_doi',None); m['publication_date']='2026-11-05'
u=requests.put(f"{A}/deposit/depositions/{did}",headers={**H,'Content-Type':'application/json'},data=json.dumps({'metadata':m}));print('meta',u.status_code,u.text[:300] if u.status_code>299 else '')
open('/tmp/pnc_draft','w').write(str(did))
