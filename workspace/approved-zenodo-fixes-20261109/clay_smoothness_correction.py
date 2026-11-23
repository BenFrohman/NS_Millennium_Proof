import json,os,sys,requests
T=os.environ['ZENODO_ACCESS_TOKEN']; H={'Authorization':'Bearer '+T}
B='https://zenodo.org/api/deposit/depositions/'
NOTE=('<p><strong>Correction (Nov 2026):</strong> In this version\'s Lean source, the smoothness index written ⊤ in '
 '<code>SmoothPeriodicData</code>/<code>NSOn</code> denotes analytic (ω) regularity in the pinned Mathlib, not C^∞ as intended. '
 'Corrected in GitHub BenFrohman/Clay- PR #11 (commit c53fb33), which uses ∞ (C^∞); no theorem depended on analyticity and the '
 'corrected hypotheses are weaker. See the latest version.</p>')
for id in sys.argv[1:]:
    r=requests.post(B+id+'/actions/edit',headers=H); print(id,'edit',r.status_code)
    if r.status_code not in (200,201): print(r.text[:300]); continue
    d=requests.get(B+id,headers=H).json(); m=d['metadata']
    if 'Correction (Nov 2026)' in m['description']: print(id,'already has note')
    else: m['description']=NOTE+m['description']
    r=requests.put(B+id,headers={**H,'Content-Type':'application/json'},data=json.dumps({'metadata':m})); print(id,'put',r.status_code)
    if r.status_code!=200: print(r.text[:500]); continue
    r=requests.post(B+id+'/actions/publish',headers=H); print(id,'publish',r.status_code)
    if r.status_code!=202: print(r.text[:500]); continue
    json.dump(r.json(),open(f'/workspace/approved-zenodo-fixes-20261109/after/deposition-{id}-after.json','w'),indent=1)
