import os,requests,json,sys
T=os.environ['ZENODO_ACCESS_TOKEN'];A='https://zenodo.org/api/deposit/depositions';P={'access_token':T}
r=requests.post(f'{A}/23966681/actions/newversion',params=P);print(r.status_code)
d=r.json();url=d['links']['latest_draft'];d=requests.get(url,params=P).json();i=d['id'];print('id',i)
for f in d.get('files',[]):
  print('del',f['filename'],requests.delete(f"{A}/{i}/files/{f['id']}",params=P).status_code)
b=d['links']['bucket']
with open('frohmanian-tether-sdiff/manuscript/main.pdf','rb') as fh:
  u=requests.put(f'{b}/frohmanian-tether-geometric.pdf',data=fh,params=P);print('up',u.status_code,u.json().get('checksum'),u.json().get('size'))
m=d['metadata']
print(json.dumps({k:m.get(k) for k in['title','description','related_identifiers','creators','version']},indent=1))
json.dump(m,open('ztv3_meta.json','w'))
open('ztv3_id','w').write(str(i))
