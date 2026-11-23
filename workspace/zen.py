import json,os,sys,urllib.request,urllib.error
tok=os.environ['ZENODO_ACCESS_TOKEN'];B='https://zenodo.org/api/deposit/depositions/'
def call(method,url,data=None):
  req=urllib.request.Request(url,method=method,headers={'Authorization':'Bearer '+tok,'Content-Type':'application/json'},data=json.dumps(data).encode() if data is not None else None)
  try: return json.load(urllib.request.urlopen(req))
  except urllib.error.HTTPError as e: print('ERR',method,url,e.code,e.read().decode()[:800]); raise
for rid in sys.argv[1:]:
  r=call('GET',B+rid)
  md=r['metadata']; old=md['description']
  new=old.replace('https://x.com/Investor0x','https://x.com/Frohmanian').replace('@Investor0x','@Frohmanian')
  if new==old: print(rid,'nothing to change'); continue
  before=json.dumps({k:v for k,v in md.items() if k!='description'},sort_keys=True)
  if r['state']!='inprogress': call('POST',B+rid+'/actions/edit')
  r2=call('GET',B+rid); md2=r2['metadata']; md2['description']=new
  call('PUT',B+rid,{'metadata':md2})
  p=call('POST',B+rid+'/actions/publish')
  after=json.dumps({k:v for k,v in p['metadata'].items() if k!='description'},sort_keys=True)
  print(rid,p['state'],p['submitted'],'Investor0x' in p['metadata']['description'],'Frohmanian' in p['metadata']['description'],'other-md-identical' if before==after else 'OTHER MD DIFF', p['links'].get('html'))
