#!/usr/bin/env python3
import json, os, sys, requests
from pathlib import Path

H = {'Authorization': 'Bearer ' + os.environ['ZENODO_ACCESS_TOKEN'],
     'User-Agent': 'GrokBot/1.0 (fefferman-clay-navier-stokes v1.4.0)'}
A = 'https://zenodo.org/api/deposit/depositions'
CONCEPT = '23652840'
LATEST = '24125518'
STATE = Path('/workspace/fefferman-zenodo-v1.4.0/state.json')
UPLOAD = Path('/workspace/fefferman-zenodo-v1.4.0/upload')
# PDF first so it is the default preview if order is respected.
FILES = [
    'Fefferman_Clay_Navier_Stokes_Periodic_Regularity_2026.pdf',
    'Fefferman_Clay_Navier_Stokes_Periodic_Regularity_2026.tex',
    'Frohman_NS_Lean_Reduction_Final_2026.pdf',
    'Frohman_NS_Lean_Reduction_Final_2026.tex',
    'fefferman-clay-navier-stokes-v1.4.0.zip',
    'SHA256SUMS',
]
PREVIEW = 'Fefferman_Clay_Navier_Stokes_Periodic_Regularity_2026.pdf'

all_drafts=[]
page=1
while True:
    r = requests.get(A, headers=H, params={'size': 100, 'status': 'draft', 'page': page})
    r.raise_for_status()
    batch=r.json()
    if not batch:
        break
    all_drafts.extend(batch)
    if len(batch)<100:
        break
    page += 1
    if page>20:
        break
drafts = [d for d in all_drafts if str(d.get('conceptrecid')) == CONCEPT and not d.get('submitted')]
print('scanned', len(all_drafts), 'draft-list entries')
print('open unpublished drafts on concept', CONCEPT, [d['id'] for d in drafts],
      'states', [d.get('state') for d in drafts])

did = None
if STATE.exists():
    did = str(json.load(open(STATE))['draft'])
    g = requests.get(f'{A}/{did}', headers=H)
    if g.status_code == 200 and not g.json().get('submitted') and str(g.json().get('conceptrecid')) == CONCEPT:
        print('reusing state draft', did)
    else:
        print('state draft unusable', did, g.status_code)
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
    draft_url = body['links']['latest_draft']
    did = draft_url.rstrip('/').split('/')[-1]
    print('created draft from newversion response', did, 'returned id', body.get('id'))
    g = requests.get(f'{A}/{did}', headers=H)
    g.raise_for_status()
    if str(g.json().get('conceptrecid')) != CONCEPT:
        sys.exit(f'FATAL: new draft concept {g.json().get("conceptrecid")} != {CONCEPT}')
    if g.json().get('submitted'):
        sys.exit('FATAL: latest_draft is already submitted')

json.dump({'draft': did}, open(STATE, 'w'))
d = requests.get(f'{A}/{did}', headers=H).json()
print('draft id', d['id'], 'concept', d.get('conceptrecid'), 'submitted', d.get('submitted'), 'state', d.get('state'))
print('reserved doi', (d.get('metadata') or {}).get('prereserve_doi'))
print('inherited files', [(f['filename'], f['filesize']) for f in d.get('files') or []])

for f in list(d.get('files') or []):
    dr = requests.delete(f"{A}/{did}/files/{f['id']}", headers=H)
    print('delete', f['filename'], dr.status_code, dr.text[:200] if dr.status_code not in (204, 200) else '')
    if dr.status_code not in (204, 200, 201):
        sys.exit(f'delete failed for {f["filename"]}')

d = requests.get(f'{A}/{did}', headers=H).json()
bucket = d['links']['bucket']
print('bucket', bucket)

uploaded_ids = []
for fn in FILES:
    path = UPLOAD / fn
    if not path.is_file():
        sys.exit(f'missing upload file {path}')
    with open(path, 'rb') as fh:
        # Prefer new bucket API; also keep name
        u = requests.put(f'{bucket}/{fn}', data=fh, headers=H)
    print('upload', fn, u.status_code, end=' ')
    try:
        j = u.json()
        print(j.get('checksum'), j.get('size') or j.get('filesize'), 'id', j.get('id') or j.get('key'))
    except Exception:
        print(u.text[:300])
    u.raise_for_status()

d = requests.get(f'{A}/{did}', headers=H).json()
files = d.get('files') or []
print('files after upload', [(f['filename'], f['id'], f['filesize']) for f in files])
byname = {f['filename']: f['id'] for f in files}
missing = [fn for fn in FILES if fn not in byname]
if missing:
    sys.exit(f'missing uploaded files: {missing}')

# Reorder so the monograph PDF is first (default preview on classic API).
order = [{'id': byname[fn]} for fn in FILES]
sr = requests.put(f'{A}/{did}/files', headers={**H, 'Content-Type': 'application/json'}, data=json.dumps(order))
print('sort files', sr.status_code, sr.text[:400] if sr.status_code not in (200, 201) else [(x.get('filename') or x.get('id')) for x in (sr.json() if sr.headers.get('content-type','').startswith('application/json') and isinstance(sr.json(), list) else [])])
if sr.status_code not in (200, 201):
    print('WARN: file sort failed; will still try default_preview')

md = json.load(open('/workspace/fefferman-zenodo-v1.4.0/metadata.json'))
# Do not send an existing version DOI.
md.pop('doi', None)
md.pop('prereserve_doi', None)
put = requests.put(f'{A}/{did}', headers={**H, 'Content-Type': 'application/json'}, data=json.dumps({'metadata': md}))
print('put metadata', put.status_code)
if put.status_code != 200:
    print(put.text[:3000])
    sys.exit('metadata PUT failed')

# Try InvenioRDM-style default_preview if the deposition accepts it.
for payload in (
    {'metadata': md, 'files': {'default_preview': PREVIEW}},
    {'metadata': {**md, 'default_preview': PREVIEW}},
):
    pr = requests.put(f'{A}/{did}', headers={**H, 'Content-Type': 'application/json'}, data=json.dumps(payload))
    print('try default_preview payload keys', list(payload.keys()), pr.status_code)
    if pr.status_code != 200:
        print('  body', pr.text[:400])

# Also try the files API endpoint used by some Invenio versions
for url, body in (
    (f'{A}/{did}/files/default_preview', {'default_preview': PREVIEW}),
    (f'https://zenodo.org/api/records/{did}/files', {'default_preview': PREVIEW}),
):
    try:
        pr = requests.put(url, headers={**H, 'Content-Type': 'application/json'}, data=json.dumps(body), timeout=30)
        print('try', url, pr.status_code, pr.text[:200])
    except Exception as e:
        print('try', url, 'ERR', e)

d = requests.get(f'{A}/{did}', headers=H).json()
json.dump(d, open('/workspace/fefferman-zenodo-v1.4.0/draft.json', 'w'), indent=2)
print('SAVED draft.json')
print('files', [(f['filename'], f['filesize']) for f in d.get('files') or []])
mdout = d['metadata']
print('version', mdout.get('version'), 'date', mdout.get('publication_date'))
print('doi', d.get('doi') or mdout.get('prereserve_doi') or mdout.get('doi'))
print('title', mdout.get('title')[:80])
desc = mdout.get('description') or ''
print('has 224', '224 theorem/lemma declarations' in desc)
print('creators', mdout.get('creators'))
print('license', mdout.get('license'))
print('state', d.get('state'), 'submitted', d.get('submitted'))
print('default_preview fields:', {k: mdout[k] for k in mdout if 'preview' in k.lower() or 'default' in k.lower()})
print('top-level preview-ish', {k: d[k] for k in d if 'preview' in k.lower() or k == 'files' and not isinstance(d[k], list)})
