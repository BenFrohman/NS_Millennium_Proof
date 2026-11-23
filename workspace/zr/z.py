import os,requests,json,sys
T=os.environ['ZENODO_ACCESS_TOKEN'];B='https://zenodo.org/api';H={'Authorization':'Bearer '+T}
out={}
def new():
  r=requests.post(B+'/deposit/depositions',headers=H,json={'metadata':{'prereserve_doi':True,'upload_type':'publication','publication_type':'preprint'}});r.raise_for_status();return r.json()
def newver(rid):
  r=requests.post(f'{B}/deposit/depositions/{rid}/actions/newversion',headers=H);
  if r.status_code>=400: print(rid,r.status_code,r.text[:300]);r.raise_for_status()
  d=r.json();lid=d['links']['latest_draft'];d=requests.get(lid,headers=H).json()
  for f in d.get('files',[]): requests.delete(f"{lid}/files/{f['id']}",headers=H)
  return d
for k,f in [('torus',new),('tether',new)]:
  d=f();out[k]={'id':d['id'],'doi':d['metadata']['prereserve_doi']['doi'],'bucket':d['links']['bucket']}
for k,rid in [('clay',23898964),('claycd',23898967)]:
  d=newver(rid);out[k]={'id':d['id'],'doi':d['metadata']['prereserve_doi']['doi'] if 'prereserve_doi' in d['metadata'] else None,'bucket':d['links']['bucket']}
json.dump(out,open('reserved.json','w'),indent=1);print(json.dumps(out,indent=1))
