from pathlib import Path
import hashlib,json,difflib,subprocess,shutil,tarfile,datetime
root=Path(__file__).resolve().parent; before=root/'before';after=root/'after'
def files(d):
 return {p.relative_to(d).as_posix():p for p in d.rglob('*') if p.is_file() and not any(x in {'.lake','.git','__pycache__'} for x in p.relative_to(d).parts) and p.suffix not in {'.pyc','.aux','.out','.log'}}
a=files(before);b=files(after);chunks=[];changed=[]
for name in sorted(set(a)|set(b)):
 old=a[name].read_bytes() if name in a else b'';new=b[name].read_bytes() if name in b else b''
 if old==new:continue
 changed.append(name)
 if name.endswith('.pdf'):
  assert name not in a,'Unexpected existing binary change'
  proc=subprocess.run(['git','diff','--no-index','--binary','--no-ext-diff','/dev/null',str(b[name])],capture_output=True)
  assert proc.returncode==1,proc.stderr
  lines=proc.stdout.decode().splitlines(keepends=True);lines[0]=f'diff --git a/{name} b/{name}\n';chunks.append(''.join(lines));continue
 chunks.append(f'diff --git a/{name} b/{name}\n')
 if name not in a:chunks.append('new file mode 100644\n')
 diff=difflib.unified_diff(old.decode().splitlines(keepends=True),new.decode().splitlines(keepends=True),fromfile=f'a/{name}' if name in a else '/dev/null',tofile=f'b/{name}' if name in b else '/dev/null')
 for line in diff:
  chunks.append(line if line.endswith('\n') else line+'\n\\ No newline at end of file\n')
patch=root/'ns-envelope-correction.patch';patch.write_text(''.join(chunks));(root/'changed-files.json').write_text(json.dumps(changed,indent=2)+'\n')
validation=root/'patch-validation-v2';assert not validation.exists();validation.mkdir()
for name,p in a.items():q=validation/name;q.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(p,q)
logs=[]
for command in [['git','init'],['git','apply','--check',str(patch)],['git','apply',str(patch)],['git','apply','--reverse','--check',str(patch)]]:
 p=subprocess.run(command,cwd=validation,capture_output=True,text=True);logs.append(f'$ {" ".join(command)}\nexit={p.returncode}\n{p.stdout}{p.stderr}');assert p.returncode==0,logs[-1]
for name,p in b.items():assert (validation/name).read_bytes()==p.read_bytes(),name
logs.append('PASS: every validated project file equals the final tested snapshot byte-for-byte\n')
(root/'patch-validation.log').write_text('\n'.join(logs))
bundle=root/'certificate';assert not bundle.exists();bundle.mkdir()
for name,p in b.items():q=bundle/'project'/name;q.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(p,q)
shutil.copy2(patch,bundle/patch.name)
for name in ['review-build.log','review-axiom-audit.log','review-correction-audit.log','review-per-theorem-audit.log','per-theorem-axioms.tsv','structural-validation.log','patch-validation.log','dependency-state.json','environment.json','changed-files.json','fresh-main-sha.txt','correction-pdf-final-verified.log','correction-pdf-final-info.log','correction-pdf-final-text.txt','document-generation.log']:
 q=bundle/'evidence'/name;q.parent.mkdir(exist_ok=True);shutil.copy2(root/name,q)
artifacts=[];lib=after/'.lake/build/lib/lean'
for p in lib.rglob('*'):
 if not p.is_file():continue
 rel=p.relative_to(lib)
 if not rel.as_posix().startswith('NS_Millennium_Proof'):continue
 if not ('.olean' in p.name or p.suffix=='.ilean'):continue
 q=bundle/'build-artifacts'/rel;q.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(p,q);artifacts.append(rel.as_posix())
for pkg in json.loads((after/'lake-manifest.json').read_text())['packages']:
 d=after/'.lake/packages'/pkg['name']
 for pattern in ['LICENSE*','NOTICE*','COPYING*']:
  for p in d.glob(pattern):
   if p.is_file():q=bundle/'dependency-notices'/pkg['name']/p.name;q.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(p,q)
(bundle/'REPRODUCE.md').write_text('''# NS envelope correction: local proof/review bundle

Author: Frohman, Benjamin Stanley <frohmanbenjamin@gmail.com>.
Baseline: c98fe859867affeba4508b3e51583cfa6b20087c.
This is a LOCAL tested patch, not a release, published archive or PR.

## Reproduce

Use a fresh directory and the exact Lean toolchain in project/lean-toolchain.
All nine package revisions are pinned by project/lake-manifest.json. Packages and
Lean itself are NOT bundled. On the shared box reuse existing pinned caches;
do not remove work or perform a clean dependency rebuild merely for this bundle.
With dependencies available, run inside project/:

    lake build
    lake env lean scripts/AxiomAudit.lean
    lake env lean scripts/EnvelopeCorrectionAudit.lean
    lake env lean scripts/CertificateAxiomInventory.lean
    python3 scripts/generate_laTeX_lean_relationship.py

On another machine, Lake may need to fetch the pinned dependencies and Mathlib
cache first (`lake exe cache get`). That is a separate dependency installation.
For the new correction addendum, use Tectonic on
`docs/VorticityEnvelopeCorrection.tex`; this run used `tectonic --only-cached
--untrusted`, with no resource download. Earlier manuscript PDFs/Zenodo records
are unchanged. The synchronized source/PDF correction addendum is four pages.

## Checked scope

The full project Lake build passed, as did the full audit, backwards-compatible
API regression, and per-theorem axiom inventory: 497 noninternal project theorem
declarations, no nonstandard transitive axioms. Eight new explicitly named
theorems plus generated auxiliary declarations are included. See the source
correction for exact statements and evidence/ logs for the actual results.
The original envelope definition and all original Stage6 proof bodies are
preserved; the two mirrored modules are synchronized. The patch passed forward
application and reverse-application CHECKS, and its applied sources were compared
byte-for-byte with the tested snapshot. Original source/API compatibility is
checked directly; standard-axiom audits are not semantic correctness tests.

All nine dependency HEADs equal the pins. The reused Mathlib tree has six
pre-existing tracked deletions of scripts/bench/build files, not Lean proof
sources; see dependency-state.json. No dependency edits were repaired/deleted.
This run used pinned cached dependency artifacts, not a clean Mathlib rebuild.

## Mathematical boundary

The actual-u cubic predicate is an additional compact-interval hypothesis, not a
newly proved PDE estimate. Conditional compact/half-open and pointwise-curl
comparisons are proved; the zero trajectory passes. Exponential decay is checked
with data-dependent C=kappa*M0. Fixed coefficients fail for a sufficiently large
amplitude. The explicit PDE single-shear calculation disproves bare direction-
gradient coercivity at every positive maximum, even for a fixed datum, without
disproving the general data-dependent envelope. Vector-field assembly is checked
analytically, NOT newly assembled into the Lean PDE structure in this patch.
A full net-source estimate and one-sided/Dini bridge remain unproved.

## Trust, hashes and notices

MANIFEST.json records each payload file's SHA-256 and byte length. Build artifacts
are supplied for inspection, not as independently trusted proof certificates.
Rebuild Lean sources with the pinned dependencies to reproduce the conditional
statements. No artifact/hash/audit proves a missing PDE premise, the paper's
semantic correctness or mathematical novelty. PDF byte identity across font/
compiler environments is not claimed.

The original project Apache-2.0 LICENSE is preserved in project/. Dependency
license/notice copies retain their authors' terms; this is not relicensing or a
comprehensive legal audit. No remote push, merge, tag, release, deletion, history
rewrite or Zenodo publication was performed.
''')
payload={p.relative_to(bundle).as_posix():{'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'bytes':p.stat().st_size} for p in sorted(bundle.rglob('*')) if p.is_file()}
manifest={'created_local':datetime.datetime.now().astimezone().isoformat(),'timezone':'America/Chicago (CST, UTC-6)','baseline':'c98fe859867affeba4508b3e51583cfa6b20087c','new_named_theorems':8,'audited_noninternal_project_theorem_declarations':497,'compiled_project_artifact_files':len(artifacts),'files':payload}
(bundle/'MANIFEST.json').write_text(json.dumps(manifest,indent=2)+'\n')
archive=root/'ns-envelope-correction-certificate.tar.gz'
assert not archive.exists()
with tarfile.open(archive,'w:gz') as tar:tar.add(bundle,arcname='ns-envelope-correction-certificate')
for name,entry in payload.items():assert hashlib.sha256((bundle/name).read_bytes()).hexdigest()==entry['sha256']
with tarfile.open(archive,'r:gz') as tar:
 for name,entry in payload.items():
  f=tar.extractfile('ns-envelope-correction-certificate/'+name);assert f is not None
  data=f.read();assert hashlib.sha256(data).hexdigest()==entry['sha256'] and len(data)==entry['bytes'],name
result={'changed_files':changed,'payload_files':len(payload),'artifact_files':len(artifacts),'patch_sha256':hashlib.sha256(patch.read_bytes()).hexdigest(),'bundle_sha256':hashlib.sha256(archive.read_bytes()).hexdigest(),'bundle_bytes':archive.stat().st_size,'tar_entries_hash_verified':True}
(root/'delivery-validation.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
