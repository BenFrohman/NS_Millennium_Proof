import json,os,requests,sys
H={'Authorization':'Bearer '+os.environ['ZENODO_ACCESS_TOKEN']}
B='https://zenodo.org/api/deposit/depositions/'
SHA='c53fb33e1cd3c33383bfda656329000d01ef919a'
st='/workspace/clay-zenodo-20261109/zen/state.json'
if os.path.exists(st): did=json.load(open(st))['draft']
else:
    r=requests.post(B+'23940667/actions/newversion',headers=H); print('newversion',r.status_code)
    did=r.json()['links']['latest_draft'].rstrip('/').split('/')[-1]; json.dump({'draft':did},open(st,'w'))
print('draft',did)
d=requests.get(B+did,headers=H).json()
for f in d.get('files',[]):
    r=requests.delete(B+did+'/files/'+f['id'],headers=H); print('remove inherited draft file',f['filename'],r.status_code)
bucket=d['links']['bucket']
for fn in ['spatial_bridge.pdf','spatial_bridge_latex_source.zip','Clay_Technical_Monograph_2026.pdf','Clay--c53fb33.tar.gz']:
    with open('/workspace/clay-zenodo-20261109/upload/'+fn,'rb') as fh:
        r=requests.put(bucket+'/'+fn,data=fh,headers=H); print('upload',fn,r.status_code)
desc=open('/workspace/clay-zenodo-20261109/zen/description.html').read()
m={
 'title':'A Kernel-Checked Spatial Bridge for Vortex-Line Comparison: Lean 4 Formalization of the Deng–Hou–Yu Spatial Identity for Smooth Periodic Navier–Stokes Fields',
 'upload_type':'publication','publication_type':'preprint','publication_date':'2026-11-09',
 'version':'1.4.0','language':'eng','access_right':'open','license':'apache-2.0',
 'creators':[{'name':'Frohman, Benjamin Stanley','affiliation':'Independent Researcher, Texas, United States','orcid':'0009-0006-7068-3718'}],
 'description':desc,
 'keywords':['Lean 4','Mathlib','formal verification','3D Navier-Stokes','vorticity direction','vortex lines','Deng-Hou-Yu','Beale-Kato-Majda criterion','Fefferman Statement (B)'],
 'related_identifiers':[
  {'identifier':'https://github.com/BenFrohman/Clay-/tree/'+SHA,'relation':'isSupplementTo','scheme':'url'},
  {'identifier':'https://github.com/BenFrohman/Clay-/pull/9','relation':'references','scheme':'url'},
  {'identifier':'https://github.com/BenFrohman/Clay-/pull/10','relation':'references','scheme':'url'},
  {'identifier':'https://github.com/BenFrohman/Clay-/pull/11','relation':'references','scheme':'url'},
  {'identifier':'arXiv:math-ph/0402032','relation':'references','scheme':'arxiv'}],
 'notes':'Copyright (c) 2026 Benjamin Stanley Frohman (frohmanbenjamin@gmail.com). Apache License 2.0 (matching the repository LICENSE). Preprint; not peer reviewed. Files built from GitHub BenFrohman/Clay- main at commit '+SHA+'.'}
r=requests.put(B+did,headers={**H,'Content-Type':'application/json'},data=json.dumps({'metadata':m})); print('put',r.status_code, r.text[:400] if r.status_code!=200 else '')
d=requests.get(B+did,headers=H).json(); json.dump(d,open('/workspace/clay-zenodo-20261109/zen/draft.json','w'),indent=1)
print([ (f['filename'],f['filesize']) for f in d['files']], d['metadata'].get('prereserve_doi'))
