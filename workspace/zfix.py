import json,os,requests
T=os.environ['ZENODO_ACCESS_TOKEN'];H={'Authorization':f'Bearer {T}'};B='https://zenodo.org/api/deposit/depositions/24083331'
d=requests.get(B,headers=H).json()
P='/workspace/frohmanian-tether-conditional-regularity/paper/'
for f in d['files']:
    if f['filename'] in ('Frohmanian_Tether_Unified.tex','Frohmanian_Tether_Unified.pdf'):
        r=requests.delete(f"{B}/files/{f['id']}",headers=H);print('del',f['filename'],r.status_code)
bucket=d['links']['bucket']
for n in ('Frohmanian_Tether_Unified.tex','Frohmanian_Tether_Unified.pdf'):
    with open(P+n,'rb') as fh: r=requests.put(f"{bucket}/{n}",data=fh,headers=H);print('up',n,r.status_code,r.json().get('checksum'))
m=d['metadata']
m['notes']=(m.get('notes') or '')+'Copyright © 2026 Benjamin Stanley Frohman. Distributed under the Apache License 2.0. Source repository commit d14fe3ce1ff6077f705dfd3ffd2cd1177cc31cf1.'
r=requests.put(B,headers={**H,'Content-Type':'application/json'},data=json.dumps({'metadata':m}));print('meta',r.status_code,r.json().get('metadata',{}).get('notes') if r.ok else r.text[:500])
d=requests.get(B,headers=H).json();print(d['state'],len(d['files']));[print(f['filename'],f['checksum']) for f in d['files'] if 'Unified' in f['filename']]
