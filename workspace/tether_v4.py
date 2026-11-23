import os,requests,json,hashlib
T=os.environ['ZENODO_ACCESS_TOKEN'];A='https://zenodo.org/api';H={'Authorization':'Bearer '+T}
r=requests.post(f'{A}/deposit/depositions/23985904/actions/newversion',headers=H);print('nv',r.status_code)
j=r.json();url=j['links']['latest_draft'];d=requests.get(url,headers=H).json();did=d['id'];print('draft',did)
for f in d['files']: print('del',f['filename'],requests.delete(f"{A}/deposit/depositions/{did}/files/{f['id']}",headers=H).status_code)
b=d['links']['bucket'];D='/workspace/tether_v4'
for n in sorted(os.listdir(D)):
  with open(f'{D}/{n}','rb') as fh: print('up',n,requests.put(f'{b}/{n}',data=fh,headers=H).status_code)
m=d['metadata'];m['version']='4'
m['description']=m['description']+'<p>Version 4 adds the Lean 4 sources (SymplecticTether, Projection, ArnoldGeometric, ClayStatements, VelocitySlotTether, ConditionalRegularity, Uniqueness, Combined), HWEIGHT_OBSTRUCTION.md and the LaTeX source, all extracted from github.com/BenFrohman/frohmanian-tether-geometric at commit 9e40ae7 (branch gateaux-pairing). Scope unchanged: conditional/obstruction results only; no claim to resolve the Clay Millennium Problem.</p>'
m.pop('doi',None);m.pop('prereserve_doi',None)
r=requests.put(f'{A}/deposit/depositions/{did}',headers={**H,'Content-Type':'application/json'},data=json.dumps({'metadata':m}));print('meta',r.status_code,r.text[:300] if r.status_code>299 else '')
r=requests.post(f'{A}/deposit/depositions/{did}/actions/publish',headers=H);print('pub',r.status_code)
p=r.json();print(p.get('doi'),p.get('links',{}).get('record_html'),p.get('metadata',{}).get('version'))
print(json.dumps(p.get('metadata',{}).get('related_identifiers'),indent=0))
for f in p.get('files',[]):print(f['filename'],f['checksum'])
print(p.get('message'),p.get('errors'))
