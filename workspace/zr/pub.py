import os,requests,json,sys,subprocess
T=os.environ['ZENODO_ACCESS_TOKEN'];B='https://zenodo.org/api';H={'Authorization':'Bearer '+T}
R=json.load(open('reserved.json'))
def pub(key,repo,pdf,meta):
  dep=R[key];sha=subprocess.check_output(['git','-C',repo,'rev-parse','HEAD'],text=True).strip()
  tar=f'/tmp/{repo}-{sha[:7]}.tar.gz'
  subprocess.check_call(['curl','-sSfL','-o',tar,f'https://github.com/BenFrohman/{repo}/archive/{sha}.tar.gz'])
  for f in [pdf,tar]:
    with open(f,'rb') as fh: r=requests.put(dep['bucket']+'/'+os.path.basename(f),data=fh,headers=H);r.raise_for_status()
  cur=requests.get(f"{B}/deposit/depositions/{dep['id']}",headers=H).json()['metadata']
  cur.update(meta);cur['creators']=[{'name':'Frohman, Benjamin Stanley','orcid':'0009-0006-7068-3718'}]
  cur['publication_date']='2026-11-04';cur['prereserve_doi']=True
  cur['related_identifiers']=[{'identifier':f'https://github.com/BenFrohman/{repo}/tree/{sha}','relation':'isSupplementTo','scheme':'url'}]
  cur.pop('doi',None)
  r=requests.put(f"{B}/deposit/depositions/{dep['id']}",headers=H,json={'metadata':cur});
  if r.status_code>=400: print(r.text);r.raise_for_status()
  r=requests.post(f"{B}/deposit/depositions/{dep['id']}/actions/publish",headers=H)
  if r.status_code>=400: print(r.text);r.raise_for_status()
  d=r.json();print(key,sha,d['doi'],d['links']['html'],[f['filename'] for f in d['files']])
ND='Proved: kernel-checked Lean 4 + Mathlib theorems, no sorry, only standard axioms (propext, Classical.choice, Quot.sound), per #print axioms and AXIOMS.md. Conditional results are stated with their hypotheses as explicit named Props. This work does not solve the Clay Millennium problem; global regularity of 3D Navier-Stokes remains open. Files: paper PDF and the GitHub source tarball of the archived commit.'
if 'torus' in sys.argv: pub('torus','torus-fourier-ns-lemmas','torus-fourier-ns-lemmas/paper/main.pdf',{
 'title':'Fourier Lemmas on the Three-Torus: Heat Smoothing, the L2 Strain Identity, and the Curl of the Energy Derivative, Formalised in Lean 4',
 'upload_type':'publication','publication_type':'preprint','license':'apache-2.0','access_right':'open','version':'1.1.0',
 'description':'Lean 4 formalisation on T^3 of the heat semigroup and Sobolev smoothing, the L2 strain identity ||S||^2 = 1/2 ||omega||^2, the energy functional derivative and Biot-Savart curl, and finite-mode Galerkin results (local existence, structure preservation, H^s transport bound for s>5/2, uniform short-time bound, tame Gronwall propagation, continuation under an a priori bound). Build: 14 modules, 250 theorems, 0 nonstandard axioms. '+ND,
 'keywords':['Lean 4','Mathlib','Navier-Stokes','Fourier series','three-torus','Galerkin','formal verification']})
if 'clay' in sys.argv: pub('clay','Clay-','Clay-/paper/Clay_Technical_Monograph_2026.pdf',{'version':'1.3.0','upload_type':'publication','publication_type':'preprint',
 'description':'Paper and Lean 4 boundary ledger: formal tracking of the 2D clock test and the open analytic inputs for Fefferman Statement (B). Build: 60 theorems, 0 nonstandard axioms. Open: PeriodicBKMIntegrability and Statement (B) itself. '+ND})
