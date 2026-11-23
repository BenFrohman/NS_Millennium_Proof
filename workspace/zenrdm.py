import json,os,sys,urllib.request,urllib.error
tok=os.environ['ZENODO_ACCESS_TOKEN'];B='https://zenodo.org/api/records/'
def call(method,url,data=None):
  req=urllib.request.Request(url,method=method,headers={'Authorization':'Bearer '+tok,'Content-Type':'application/json'},data=json.dumps(data).encode() if data is not None else None)
  try: return json.load(urllib.request.urlopen(req))
  except urllib.error.HTTPError as e: print('ERR',method,url,e.code,e.read().decode()[:1000]); raise
for rid in sys.argv[1:]:
  pub=call('GET',B+rid)
  try: d=call('GET',B+rid+'/draft')
  except Exception: d=call('POST',B+rid+'/draft')
  old=d['metadata']['description']
  new=old.replace('https://x.com/Investor0x','https://x.com/Frohmanian').replace('@Investor0x','@Frohmanian')
  d['metadata']['description']=new
  body={k:d[k] for k in ('metadata','access','files','pids','custom_fields') if k in d}
  u=call('PUT',B+rid+'/draft',body)
  if u.get('errors'): print(rid,'DRAFT ERRORS',u['errors']); continue
  p=call('POST',B+rid+'/draft/actions/publish')
  a={k:v for k,v in p['metadata'].items() if k!='description'}; b={k:v for k,v in pub['metadata'].items() if k!='description'}
  print(rid,p.get('status'),'Investor0x' in p['metadata']['description'],'Frohmanian' in p['metadata']['description'],'other-md-identical' if json.dumps(a,sort_keys=True)==json.dumps(b,sort_keys=True) else 'OTHER MD DIFF')
