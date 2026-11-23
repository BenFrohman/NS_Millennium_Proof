import os,re,json,requests
T=os.environ['ZENODO_ACCESS_TOKEN'];H={'Authorization':'Bearer '+T};A='https://zenodo.org/api/deposit/depositions'
P='b21e996636d39572a19dfaec6f679dc0ddcc0fda';M='49e4d8e89451366b8a04b74154a2fbe977557aa5';C='e1f578d0b4735117f47169af4f81db4a523e45f2'
jobs=[(23850791,['reduction.pdf'],'periodic-ns-classical-continuation',P,'v9 (work in progress)','New version: PeriodicNonlinearEnergyCancellation and PeriodicEnstrophyTimeIntegrable are now proved unconditionally in Lean; concept DOI in banner. Work in progress; does not solve the Clay problem.'),
(23850793,['periodic-ns-classical-continuation.pdf'],'periodic-ns-classical-continuation',P,'v9 (work in progress)','New version: PeriodicNonlinearEnergyCancellation and PeriodicEnstrophyTimeIntegrable are now proved unconditionally in Lean; concept DOI in banner. Work in progress; does not solve the Clay problem.'),
(23850794,['tethered-ceiling-reduction.pdf'],'metriplectic-world-model',M,'v5 (work in progress)','New version: concept DOI in banner. Work in progress; does not solve the Clay problem.'),
(23850797,['metriplectic-world-model.pdf'],'metriplectic-world-model',M,'v5 (work in progress)','New version: concept DOI in banner. Work in progress; does not solve the Clay problem.'),
(23851626,['Clay_Technical_Monograph_2026.pdf','Clay--v1.1.1.zip'],'Clay-',C,'1.1.1','New version 1.1.1: concept DOI corrected to 10.5281/zenodo.23653012 in README badge, CITATION and monograph.')]
out=[]
for rid,files,repo,c,ver,note in jobs:
  r=requests.post(f'{A}/{rid}/actions/newversion',headers=H);r.raise_for_status()
  d=requests.get(r.json()['links']['latest_draft'],headers=H).json();did=d['id']
  for f in d.get('files',[]): requests.delete(f"{A}/{did}/files/{f['id']}",headers=H).raise_for_status()
  for fn in files:
    with open(fn,'rb') as fh: requests.put(f"{d['links']['bucket']}/{fn}",data=fh,headers=H).raise_for_status()
  m=d['metadata'];m.pop('doi',None);m.pop('prereserve_doi',None)
  m['version']=ver;m['publication_date']='2026-10-31'
  desc=re.sub(r'<p>New version[^<]*</p>','',m['description'])
  desc=re.sub(r'at commit [0-9a-f]{7,40}',f'at commit {c[:7]}',desc)
  if f'commit {c[:7]}' not in desc: desc+=f'<p>Source: https://github.com/BenFrohman/{repo} at commit {c[:7]}.</p>'
  m['description']=desc+f'<p>{note}</p>'
  m['related_identifiers']=[x for x in m.get('related_identifiers',[]) if 'github.com' not in x['identifier']]+[{'identifier':f'https://github.com/BenFrohman/{repo}/tree/{c}','relation':'isSupplementTo','resource_type':'software'}]
  requests.put(f'{A}/{did}',headers={**H,'Content-Type':'application/json'},data=json.dumps({'metadata':m})).raise_for_status()
  p=requests.post(f'{A}/{did}/actions/publish',headers=H);print(rid,p.status_code,p.text[:300] if p.status_code>202 else '',flush=True)
  out.append((rid,did,p.json().get('doi')))
print(out)
