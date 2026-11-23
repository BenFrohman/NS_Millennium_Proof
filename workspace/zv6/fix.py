import os,json,requests
H={'Authorization':'Bearer '+os.environ['ZENODO_ACCESS_TOKEN']};A='https://zenodo.org/api/deposit/depositions'
for rid in (23845551,23845554):
  requests.post(f'{A}/{rid}/actions/edit',headers=H).raise_for_status()
  m=requests.get(f'{A}/{rid}',headers=H).json()['metadata']
  print(rid,'old',m.get('version'),'|',m['title'])
  m['version']='v5 (work in progress)'
  requests.put(f'{A}/{rid}',headers={**H,'Content-Type':'application/json'},data=json.dumps({'metadata':m})).raise_for_status()
  p=requests.post(f'{A}/{rid}/actions/publish',headers=H);print(rid,p.status_code,requests.get(f'{A}/{rid}',headers=H).json()['metadata']['version'])
