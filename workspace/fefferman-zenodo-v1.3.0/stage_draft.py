#!/usr/bin/env python3
import json, os, sys, requests
from pathlib import Path

H = {'Authorization': 'Bearer ' + os.environ['ZENODO_ACCESS_TOKEN']}
A = 'https://zenodo.org/api/deposit/depositions'
CONCEPT = '23652840'
LATEST = '23749846'
STATE = Path('/workspace/fefferman-zenodo-v1.3.0/state.json')
UPLOAD = Path('/workspace/fefferman-zenodo-v1.3.0/upload')
KEEP_OR_NEW = [
    'fefferman-clay-navier-stokes-v1.3.0.zip',
    'SHA256SUMS',
    'Fefferman_Clay_Navier_Stokes_Periodic_Regularity_2026.pdf',
    'Fefferman_Clay_Navier_Stokes_Periodic_Regularity_2026.tex',
    'Frohman_NS_Lean_Reduction_Final_2026.pdf',
]

# 1. Reuse existing unpublished draft on this concept if any; never create a duplicate concept.
r = requests.get(A, headers=H, params={'size': 100, 'status': 'draft'})
r.raise_for_status()
drafts = [d for d in r.json() if str(d.get('conceptrecid')) == CONCEPT and not d.get('submitted')]
print('open drafts on concept', CONCEPT, [d['id'] for d in drafts], 'states', [d.get('state') for d in drafts])

if STATE.exists():
    did = str(json.load(open(STATE))['draft'])
    print('state.json draft', did)
    # verify it still exists and is a draft
    g = requests.get(f'{A}/{did}', headers=H)
    if g.status_code == 200 and not g.json().get('submitted') and str(g.json().get('conceptrecid')) == CONCEPT:
        print('reusing state draft')
    else:
        print('state draft unusable', g.status_code, g.text[:300])
        did = None
else:
    did = None

if drafts:
    ids = [str(d['id']) for d in drafts]
    if did and did not in ids:
        sys.exit(f'state draft {did} is not in open drafts {ids}')
    if did is None:
        if len(drafts) != 1:
            sys.exit(f'refuse to choose among multiple drafts: {ids}')
        did = ids[0]
        print('reusing existing unpublished draft', did)
elif did is None:
    print('no unpublished draft; calling newversion on', LATEST)
    nv = requests.post(f'{A}/{LATEST}/actions/newversion', headers=H)
    print('newversion', nv.status_code, nv.text[:500])
    nv.raise_for_status()
    body = nv.json()
    # latest_draft is a URL
    draft_url = body['links']['latest_draft']
    did = draft_url.rstrip('/').split('/')[-1]
    print('created draft', did, 'concept', body.get('conceptrecid'))
    if str(body.get('conceptrecid')) != CONCEPT:
        # newversion returns the original? need to GET draft
        pass
    g = requests.get(f'{A}/{did}', headers=H)
    g.raise_for_status()
    if str(g.json().get('conceptrecid')) != CONCEPT:
        sys.exit(f'FATAL: new draft concept {g.json().get("conceptrecid")} != {CONCEPT}')
else:
    print('using did', did)

json.dump({'draft': did}, open(STATE, 'w'))
d = requests.get(f'{A}/{did}', headers=H).json()
print('draft id', d['id'], 'concept', d.get('conceptrecid'), 'submitted', d.get('submitted'), 'state', d.get('state'))
print('reserved doi', (d.get('metadata') or {}).get('prereserve_doi'))
print('inherited files', [(f['filename'], f['filesize']) for f in d.get('files') or []])

# 2. Remove inherited files, then upload the intended set.
for f in list(d.get('files') or []):
    dr = requests.delete(f"{A}/{did}/files/{f['id']}", headers=H)
    print('delete', f['filename'], dr.status_code, dr.text[:200] if dr.status_code not in (204, 200) else '')
    if dr.status_code not in (204, 200, 201):
        sys.exit(f'delete failed for {f["filename"]}')

# refresh bucket
d = requests.get(f'{A}/{did}', headers=H).json()
bucket = d['links']['bucket']
print('bucket', bucket)

for fn in KEEP_OR_NEW:
    path = UPLOAD / fn
    if not path.is_file():
        sys.exit(f'missing upload file {path}')
    with open(path, 'rb') as fh:
        u = requests.put(f'{bucket}/{fn}', data=fh, headers=H)
    print('upload', fn, u.status_code, end=' ')
    try:
        j = u.json()
        print(j.get('checksum'), j.get('size') or j.get('filesize'))
    except Exception:
        print(u.text[:300])
    u.raise_for_status()

# 3. PUT metadata (no old DOI)
md = json.load(open('/workspace/fefferman-zenodo-v1.3.0/metadata.json'))
put = requests.put(f'{A}/{did}', headers={**H, 'Content-Type': 'application/json'}, data=json.dumps({'metadata': md}))
print('put metadata', put.status_code)
if put.status_code != 200:
    print(put.text[:2000])
    sys.exit('metadata PUT failed')

d = requests.get(f'{A}/{did}', headers=H).json()
json.dump(d, open('/workspace/fefferman-zenodo-v1.3.0/draft.json', 'w'), indent=2)
print('SAVED draft.json')
print('files', [(f['filename'], f['filesize']) for f in d.get('files') or []])
mdout = d['metadata']
print('version', mdout.get('version'), 'date', mdout.get('publication_date'))
print('doi', d.get('doi') or mdout.get('prereserve_doi') or mdout.get('doi'))
print('title', mdout.get('title')[:80])
desc = mdout.get('description') or ''
print('has 224', '224 theorem/lemma declarations' in desc)
print('old 186 claim present', '186 kernel-verified theorems across 6 modules' in desc)
print('creators', mdout.get('creators'))
print('license', mdout.get('license'))
print('state', d.get('state'), 'submitted', d.get('submitted'))
