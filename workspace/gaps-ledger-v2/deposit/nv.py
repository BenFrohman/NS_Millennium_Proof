import json,os,sys,urllib.request,urllib.error
T=os.environ['ZENODO_ACCESS_TOKEN'];A='https://zenodo.org/api'
def req(m,u,data=None,raw=False):
    h={'Authorization':'Bearer '+T,'Accept':'application/json'}
    b=data
    if data is not None and not raw: b=json.dumps(data).encode();h['Content-Type']='application/json'
    if raw: h['Content-Type']='application/octet-stream'
    try:
        with urllib.request.urlopen(urllib.request.Request(u,data=b,headers=h,method=m)) as r:
            p=r.read(); return json.loads(p) if p and 'json' in r.headers.get('Content-Type','') else None
    except urllib.error.HTTPError as e: sys.exit(f'{m} {u} -> {e.code} {e.read().decode()[:1500]}')
cur=req('GET',f'{A}/deposit/depositions/24148258')
ld=cur['links'].get('latest_draft','')
if not ld.endswith('/24148258'): sys.exit('existing draft present: '+ld)
c=req('POST',f'{A}/deposit/depositions/24148258/actions/newversion')
d=req('GET',c['links']['latest_draft']); did=d['id']; print('draft',did)
assert d.get('submitted') is False, d.get('state')
for f in d.get('files',[]): req('DELETE',f"{A}/deposit/depositions/{did}/files/{f['id']}")
meta=json.load(open('meta.json'))
req('PUT',f'{A}/deposit/depositions/{did}',meta)
bucket=d['links']['bucket']
for n in ['main.pdf','gaps-ledger-v3-source.zip','gaps-ledger-axioms.txt']:
    req('PUT',f'{bucket}/{n}',open(n,'rb').read(),raw=True)
d=req('GET',f'{A}/deposit/depositions/{did}')
print(json.dumps({'id':did,'state':d['state'],'submitted':d['submitted'],'doi':d['metadata'].get('prereserve_doi'),'files':[(f['filename'],f['checksum']) for f in d['files']]},indent=1))
json.dump(d,open('draft.json','w'))
