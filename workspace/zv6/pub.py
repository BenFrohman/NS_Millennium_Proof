import os,re,json,requests
T=os.environ['ZENODO_ACCESS_TOKEN'];H={'Authorization':'Bearer '+T};A='https://zenodo.org/api/deposit/depositions'
jobs=[(23845551,'reduction.pdf','periodic-ns-classical-continuation','a5bf622'),
(23845554,'periodic-ns-classical-continuation.pdf','periodic-ns-classical-continuation','a5bf622')]
full={'a5bf622':'a5bf62250e27ae61abf51c7953c7bc598efec881'}
out=[]
for rid,pdf,repo,c in jobs:
  r=requests.post(f'{A}/{rid}/actions/newversion',headers=H);r.raise_for_status()
  d=requests.get(r.json()['links']['latest_draft'],headers=H).json();did=d['id']
  for f in d.get('files',[]): requests.delete(f"{A}/{did}/files/{f['id']}",headers=H).raise_for_status()
  with open(pdf,'rb') as fh: requests.put(f"{d['links']['bucket']}/{pdf}",data=fh,headers=H).raise_for_status()
  m=d['metadata'];m.pop('doi',None);m.pop('prereserve_doi',None)
  m['version']='v6 (work in progress)';m['publication_date']='2026-10-31'
  m['description']=re.sub(r'at commit [0-9a-f]{7,40}',f'at commit {c}',m['description'])
  if f'commit {c}' not in m['description']: m['description']+=f'<p>Source: https://github.com/BenFrohman/{repo} at commit {c}.</p>'
  m['title']=m['title'].replace('T^3','𝕋³').replace('H^3','H³');m['description']+='<p>New version (v6): Leray H1 blow-up criterion and the analytic Constantin-Fefferman/Beirão da Veiga-Berselli step broken into smaller named hypotheses with proved reductions (ClassicalSteps.lean); open steps remain named hypotheses. 720 theorems and lemmas, 0 sorry. Work in progress; does not solve the Clay problem.</p>'
  m['related_identifiers']=[x for x in m.get('related_identifiers',[]) if 'github.com' not in x['identifier']]+[{'identifier':f'https://github.com/BenFrohman/{repo}/tree/{full[c]}','relation':'isSupplementTo','resource_type':'software'}]
  requests.put(f'{A}/{did}',headers={**H,'Content-Type':'application/json'},data=json.dumps({'metadata':m})).raise_for_status()
  p=requests.post(f'{A}/{did}/actions/publish',headers=H);print(rid,p.status_code,p.text[:300] if p.status_code>202 else '')
  out.append((rid,did,p.json().get('doi')))
print(out)
