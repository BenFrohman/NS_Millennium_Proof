#!/usr/bin/env python3
"""Assemble unpublished Zenodo draft payloads. No network, no publish."""
from __future__ import annotations
import hashlib, shutil, zipfile
from pathlib import Path

ROOT = Path('/workspace/cert-bundle-prs/rebuild/upload')
if ROOT.exists():
    shutil.rmtree(ROOT)
ROOT.mkdir(parents=True)

NOTICE = Path('/workspace/cert-bundle-prs/zenodo-work/bundles/NOTICE').read_text()

def sha256(p: Path) -> str:
    h = hashlib.sha256()
    with p.open('rb') as f:
        for chunk in iter(lambda: f.read(1 << 20), b''):
            h.update(chunk)
    return h.hexdigest()

def write(p: Path, text: str) -> Path:
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(text if text.endswith('\n') else text + '\n')
    return p

def copy(src: Path, dest: Path) -> Path:
    dest.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(src, dest)
    return dest

def zip_dir(src: Path, dest: Path, arc_root: str | None = None) -> Path:
    dest.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(dest, 'w', compression=zipfile.ZIP_DEFLATED) as z:
        for f in sorted(src.rglob('*')):
            if f.is_file():
                rel = f.relative_to(src)
                arc = f'{arc_root}/{rel}' if arc_root else str(rel)
                z.write(f, arcname=arc)
    return dest

def write_sums(files: list[Path], dest: Path) -> Path:
    lines = []
    for f in files:
        lines.append(f'{sha256(f)}  {f.name}')
    write(dest, '\n'.join(lines) + '\n')
    return dest

ELAN_NOTE = """The GitHub Actions workflow at the cited historical commit did not print
elan --version. No elan version is invented here. The toolchain pin is
this repository's own lean-toolchain file at that commit, recorded with
its sha256 in this archive.
"""

# -------------------- p2q --------------------
p2q = ROOT / '24180777'
p2q.mkdir()
copy(Path('/workspace/cert-bundle-prs/rebuild/papers/p2q/p2q-jumps-v1.4.pdf'), p2q / 'p2q-jumps-v1.4.pdf')
# paper source
psrc = ROOT / '_p2q_paper_src'
psrc.mkdir()
copy(Path('/workspace/cert-bundle-prs/rebuild/papers/p2q/p2q-jumps-v1.4.tex'), psrc / 'p2q-jumps-v1.4.tex')
copy(Path('/workspace/cert-bundle-prs/rebuild/papers/p2q/theorem-L.tex'), psrc / 'theorem-L.tex')
write(psrc / 'NOTICE', NOTICE)
zip_dir(psrc, p2q / 'p2q-jumps-v1.4-source.zip', 'p2q-jumps-v1.4-source')
write(p2q / 'NOTICE', NOTICE)

# kernel certificate from PR #9 push artifact + full job log
kdir = ROOT / '_p2q_cert'
kdir.mkdir()
write(kdir / 'NOTICE', NOTICE)
write(kdir / 'README.md', """# p2q-jumps-lean kernel certificate (pull request #9, push run)

This archive is the Lean kernel certificate for version 1.4. It is rebuilt
from the GitHub Actions artifact of run 44045838056 (event: push of
pull request #9), not from a local build.

Commit: 4fcb9aaec87502ea77cc9efa777aaa1c9279a064
Run: https://github.com/BenFrohman/p2q-jumps-lean/actions/runs/44045838056
Repository: BenFrohman/p2q-jumps-lean

The folder kernel-certificate-run44045838056/ contains the uploaded
artifact files, byte-for-byte as downloaded with gh. They include this
repository's own lake-manifest.json and its sha256
4d3ae22e8ed4d49aca48ed63bd17a6e491c1a7d22469f20494b7c147a85f0dcc,
lean-toolchain, versions.txt (elan 4.2.4 (227caca13 2026-08-25),
Lake 5.0.0-src+d8204c9, Lean 4.26.0), mathlib-rev.txt pinning Mathlib
by commit hash 2df2f0150c275ad53cb3c90f7c98ec15a56a1a67
(input revision v4.26.0), lake-build.log ("Build completed successfully
(7796 jobs)"), and axioms.txt (#print axioms; every listed declaration
uses only propext, Classical.choice, and/or Quot.sound).

github-actions-job-log-run44045838056.log is the full job log of that
run, obtained with `gh run view 44045838056 --log`. It records the same
elan version and the line "OK: no sorry/admit/native_decide, no axiom
declarations".

Rebuild: lake exe cache get && lake build && lake env lean AxiomAudit.lean

The p=7 descent and Hypothesis H1 (computer-assisted trust) are not in
the Lean sources of this commit. They remain outside-Lean checks. They
are not kernel-checked. An attempt to formalize them remains in unmerged
pull request #7 and is not part of this certificate.

PARI, LMFDB and Python results are in the separate archive
p2q-jumps-outside-checks-4fcb9aa.zip. They are not Lean kernel certificates.
""")
art = kdir / 'kernel-certificate-run44045838056'
art.mkdir()
for f in Path('/workspace/cert-bundle-prs/rebuild/p2q-art-push').iterdir():
    if f.is_file():
        shutil.copy2(f, art / f.name)
copy(Path('/workspace/cert-bundle-prs/rebuild/p2q-logs/job-44045838056.log'),
     kdir / 'github-actions-job-log-run44045838056.log')
zip_dir(kdir, p2q / 'p2q-jumps-lean-kernel-certificate-4fcb9aa-run44045838056.zip',
        'p2q-jumps-lean-kernel-certificate-4fcb9aa-run44045838056')

# outside checks from the same commit
odir = ROOT / '_p2q_out'
odir.mkdir()
write(odir / 'NOTICE', NOTICE)
write(odir / 'README.md', """# p2q outside checks (not Lean kernel certificates)

These files are from certificates/external/ at commit
4fcb9aaec87502ea77cc9efa777aaa1c9279a064. They are PARI, LMFDB and
Python results. They are not Lean kernel certificates and they do not
prove or pass any Lean theorem.

The p=7 descent and Hypothesis H1 (computer-assisted trust) are also
outside-Lean checks. They are not in the Lean sources of this commit
and are not kernel-checked.
""")
ext = Path('/workspace/cert-bundle-prs/p2q-jumps-lean/certificates/external')
# copy from git show to be sure we use the commit tree
import subprocess, tempfile
td = Path(tempfile.mkdtemp())
subprocess.check_call([
    'git', '-C', '/workspace/cert-bundle-prs/p2q-jumps-lean',
    'archive', '4fcb9aaec87502ea77cc9efa777aaa1c9279a064',
    'certificates/external',
], cwd=str(td), stdout=open(td / 'ext.tar', 'wb'))
subprocess.check_call(['tar', '-xf', str(td / 'ext.tar'), '-C', str(td)])
shutil.copytree(td / 'certificates' / 'external', odir / 'certificates-external')
zip_dir(odir, p2q / 'p2q-jumps-outside-checks-4fcb9aa.zip',
        'p2q-jumps-outside-checks-4fcb9aa')

# Lean source git archive
subprocess.check_call([
    'git', '-C', '/workspace/cert-bundle-prs/p2q-jumps-lean',
    'archive', '--format=zip',
    '--prefix=p2q-jumps-lean-4fcb9aaec87502ea77cc9efa777aaa1c9279a064/',
    '4fcb9aaec87502ea77cc9efa777aaa1c9279a064',
    '-o', str(p2q / 'p2q-jumps-lean-4fcb9aaec87502ea77cc9efa777aaa1c9279a064.zip'),
])

write_sums([p for p in p2q.iterdir() if p.is_file() and p.name != 'SHA256SUMS'], p2q / 'SHA256SUMS')

# -------------------- gaps --------------------
gaps = ROOT / '24302371'
gaps.mkdir()
copy(Path('/workspace/cert-bundle-prs/rebuild/papers/gaps/main.pdf'), gaps / 'gaps-ledger-v4.pdf')
gsrc = ROOT / '_gaps_src'
gsrc.mkdir()
copy(Path('/workspace/cert-bundle-prs/rebuild/papers/gaps/main.tex'), gsrc / 'main.tex')
write(gsrc / 'NOTICE', NOTICE)
zip_dir(gsrc, gaps / 'gaps-ledger-v4-source.zip', 'gaps-ledger-v4-source')
write(gaps / 'NOTICE', NOTICE)

# refresh raw CI zip from the existing tree + README/ELAN updates
graw = ROOT / '_gaps_raw'
if graw.exists():
    shutil.rmtree(graw)
shutil.copytree(Path('/workspace/cert-bundle-prs/zenodo-work/bundles/gaps-ledger-raw-ci-artifacts-v4'), graw)
# drop old SHA256SUMS; we'll regenerate after edits
(graw / 'SHA256SUMS').unlink(missing_ok=True)
write(graw / 'NOTICE', NOTICE)
write(graw / 'ELAN_VERSION_NOTE.txt', ELAN_NOTE)
readme = (graw / 'README.md').read_text()
add = """
## Cited NS_Millennium_Proof declarations in the raw job log

The declarations clay_reduces_to_direction_curvature_bound and
not_frohmanianTetherRate_U are present in the raw job log of run
43928069777 (NS_Millennium_Proof-b8d2f1e/github-actions-job.log).
They appear in that workflow's tabulated AXIOM format, not as a
separate uploaded artifact and not in a `#print axioms` `.msg` extract.

Exact lines from that log (line numbers of the saved file):

    1118  AXIOM	FrohmanianTether.HighSetDepletionAndBKM.clay_reduces_to_direction_curvature_bound	NS_Millennium_Proof.Modules.MainTheorem	#[propext, Classical.choice, Quot.sound]
    1238  AXIOM	TetherRateCounterexample.not_frohmanianTetherRate_U	NS_Millennium_Proof.Modules.TetherRateCounterexample	#[propext, Classical.choice, Quot.sound]

The other five cited NS_Millennium_Proof declarations are in the same
raw AXIOM table. This version does not cite a local print or the
withdrawn file gaps-ledger-axioms.txt.

## elan version

The historical workflows at the three cited commits did not print
elan --version. No elan version is invented here. See
ELAN_VERSION_NOTE.txt.
"""
if 'Cited NS_Millennium_Proof declarations' not in readme:
    write(graw / 'README.md', readme.rstrip() + '\n' + add)
# regenerate SHA256SUMS inside the zip (relative names only)
sum_lines = []
for f in sorted(graw.rglob('*')):
    if f.is_file():
        sum_lines.append(f'{sha256(f)}  {f.relative_to(graw)}')
write(graw / 'SHA256SUMS', '\n'.join(sum_lines) + '\n')
zip_dir(graw, gaps / 'gaps-ledger-raw-ci-artifacts-v4.zip', 'gaps-ledger-raw-ci-artifacts-v4')
write_sums([p for p in gaps.iterdir() if p.is_file() and p.name != 'SHA256SUMS'], gaps / 'SHA256SUMS')

# -------------------- NS --------------------
ns = ROOT / '24302372'
ns.mkdir()
copy(Path('/workspace/cert-bundle-prs/rebuild/papers/ns/main.pdf'), ns / 'Frohman_NS_Millennium_Proof_v2.6.0.pdf')
copy(Path('/workspace/cert-bundle-prs/rebuild/papers/ns/main.tex'), ns / 'Frohman_NS_Millennium_Proof_v2.6.0.tex')
write(ns / 'NOTICE', NOTICE)
# reuse official source zip
srczip = Path('/workspace/corr20261111/upC/NS_Millennium_Proof-6c79135d30fdd03d6b7520d47eec4fefa5ec7f03.zip')
copy(srczip, ns / srczip.name)

nprov = ROOT / '_ns_prov'
if nprov.exists():
    shutil.rmtree(nprov)
shutil.copytree(Path('/workspace/cert-bundle-prs/zenodo-work/bundles/ns-millennium-certificate-provenance-v2.6.0'), nprov)
(nprov / 'SHA256SUMS').unlink(missing_ok=True)
write(nprov / 'NOTICE', NOTICE)
write(nprov / 'ELAN_VERSION_NOTE.txt', ELAN_NOTE)
write(nprov / 'REBUILD.txt', 'lake exe cache get && lake build\n')
readme = (nprov / 'README.md').read_text()
extra = """
## Rebuild command

    lake exe cache get && lake build

Commit: 6c79135d30fdd03d6b7520d47eec4fefa5ec7f03
Manifest sha256: b81d814b7d2d2d2821b03ed679324d5e7ec7da674e0a977352d01c88cbe8ccb8
Toolchain: leanprover/lean4:v4.30.0-rc1
Mathlib revision: 0c154d67103f74be3a0f2c509f72ccbf5be9f2a7
Run: https://github.com/BenFrohman/NS_Millennium_Proof/actions/runs/43047743968

The historical workflow did not print elan --version. No elan version
is invented here. See ELAN_VERSION_NOTE.txt.

The excerpt file CI_audit_excerpt_run43047743968.txt from version 2.5.0
is not attached to this version. The full job log is attached instead.
"""
if 'Rebuild command' not in readme:
    write(nprov / 'README.md', readme.rstrip() + '\n' + extra)
sum_lines = []
for f in sorted(nprov.rglob('*')):
    if f.is_file():
        sum_lines.append(f'{sha256(f)}  {f.relative_to(nprov)}')
write(nprov / 'SHA256SUMS', '\n'.join(sum_lines) + '\n')
zip_dir(nprov, ns / 'ns-millennium-certificate-provenance-v2.6.0.zip',
        'ns-millennium-certificate-provenance-v2.6.0')
write_sums([p for p in ns.iterdir() if p.is_file() and p.name != 'SHA256SUMS'], ns / 'SHA256SUMS')

# -------------------- refutation --------------------
ref = ROOT / '24302373'
ref.mkdir()
copy(Path('/workspace/cert-bundle-prs/rebuild/papers/refutation/ns-key-estimate-refutation-v1.2.0.pdf'),
     ref / 'ns-key-estimate-refutation-v1.2.0.pdf')
# paper source + compile inputs
rsrc = ROOT / '_ref_src'
rsrc.mkdir()
copy(Path('/workspace/cert-bundle-prs/rebuild/papers/refutation/ns-key-estimate-refutation-v1.2.0.tex'),
     rsrc / 'ns-key-estimate-refutation-v1.2.0.tex')
for name in ['axioms.txt', 'lake_build-display.log', 'v2_maxcert.log']:
    copy(Path('/workspace/cert-bundle-prs/rebuild/papers/refutation') / name, rsrc / name)
write(rsrc / 'NOTICE', NOTICE)
zip_dir(rsrc, ref / 'ns-key-estimate-refutation-v1.2.0-source.zip',
        'ns-key-estimate-refutation-v1.2.0-source')
write(ref / 'NOTICE', NOTICE)

rbun = ROOT / '_ref_bun'
if rbun.exists():
    shutil.rmtree(rbun)
shutil.copytree(Path('/workspace/cert-bundle-prs/zenodo-work/bundles/key-estimate-refutation-certificate-bundle-v1.2.0'), rbun)
(rbun / 'SHA256SUMS').unlink(missing_ok=True)
write(rbun / 'NOTICE', NOTICE)
write(rbun / 'ELAN_VERSION_NOTE.txt', ELAN_NOTE)
# full job log, not the 1.8 KB tail
copy(Path('/workspace/cert-bundle-prs/rebuild/refutation-logs/job-42916652258.log'),
     rbun / 'lean-kernel' / 'github-actions-job-log-run42916652258.log')
# keep the artifact lake_build.log but label it in README as the artifact tail
readme = """# Key-estimate refutation v1.2.0 certificate bundle

Lean kernel materials are the raw GitHub Actions verify-logs artifacts
of runs 42916652258 and 42916649801 (byte-identical) at commit 715626e,
together with this repository's own lean/lake-manifest.json and
lean/lean-toolchain at that commit, with sha256
2dcd77f771f6f5080b5b4b83db2f22f66071c37baaf044afbcf9b3b78d305672.
Mathlib revision: 79e94a093aff4a60fb1b1f92d9681e407124c2ca.

lean-kernel/axioms.log and lean-kernel/lake_build.log are the files
from the uploaded verify-logs artifact. lean-kernel/lake_build.log is
the short artifact build log (1.8 KB). The full GitHub Actions job log
of run 42916652258, obtained with `gh run view 42916652258 --log`, is
lean-kernel/github-actions-job-log-run42916652258.log (not the artifact
tail alone).

The historical workflow did not print elan --version. No elan version
is invented here. See ELAN_VERSION_NOTE.txt.

## Outside checks (not Lean kernel certificates)

outside-checks/v2_maxcert.log is an Arb / python-flint interval-arithmetic
numeric check of ||omega_1||_inf = 12. Lean does not certify this maximum.
outside-checks/v1_trig_example.log, v2_symbolic.log and v2_sym.pkl are
Python / sympy computations. They are likewise outside checks.

Runs:
https://github.com/BenFrohman/ns-tether-key-estimate-refutation/actions/runs/42916652258
https://github.com/BenFrohman/ns-tether-key-estimate-refutation/actions/runs/42916649801
"""
write(rbun / 'README.md', readme)
sum_lines = []
for f in sorted(rbun.rglob('*')):
    if f.is_file():
        sum_lines.append(f'{sha256(f)}  {f.relative_to(rbun)}')
write(rbun / 'SHA256SUMS', '\n'.join(sum_lines) + '\n')
zip_dir(rbun, ref / 'key-estimate-refutation-certificate-bundle-v1.2.0.zip',
        'key-estimate-refutation-certificate-bundle-v1.2.0')

# Lean source from GitHub at 715626e
import subprocess, tempfile, os
# try several clones, else GitHub zipball
got = False
for repo in Path('/workspace').glob('**/ns-tether-key-estimate-refutation/.git'):
    root = repo.parent
    r = subprocess.run(['git', '-C', str(root), 'rev-parse', '--verify', '715626e^{commit}'],
                       capture_output=True, text=True)
    if r.returncode == 0:
        subprocess.check_call([
            'git', '-C', str(root), 'archive', '--format=zip',
            '--prefix=ns-tether-key-estimate-refutation-715626e/',
            '715626e',
            '-o', str(ref / 'ns-tether-key-estimate-refutation-715626e.zip'),
        ])
        got = True
        print('archived refutation from', root)
        break
if not got:
    print('WARNING: no local 715626e; will fetch zipball in a follow-up')
    Path('/tmp/need-refutation-zipball').write_text('yes\n')

write_sums([p for p in ref.iterdir() if p.is_file() and p.name != 'SHA256SUMS'], ref / 'SHA256SUMS')

# final scan
print('\n=== packed files ===')
for rec in ['24180777', '24302371', '24302372', '24302373']:
    print(f'\n{rec}')
    for f in sorted((ROOT / rec).iterdir()):
        if f.is_file():
            print(f'  {f.name:80} {f.stat().st_size:10d}')

# forbidden wording scan of packed files (except historical phrases)
bad = []
for f in ROOT.rglob('*'):
    if not f.is_file():
        continue
    if f.suffix in {'.pdf', '.zip', '.pkl', '.log'}:
        # scan zip members' text later; logs may be CI logs
        if f.suffix == '.log':
            continue
        if f.suffix == '.zip':
            with zipfile.ZipFile(f) as z:
                for info in z.infolist():
                    if '/workspace' in info.filename:
                        bad.append((f, info.filename, 'zip path'))
                    if info.filename.endswith(('.txt', '.md', '.tex', '.json', '.sha256', '.sha256sum')):
                        try:
                            data = z.read(info).decode('utf-8', 'replace')
                        except Exception:
                            continue
                        if '/workspace' in data:
                            bad.append((f, info.filename, '/workspace in member'))
        continue
    try:
        data = f.read_text(encoding='utf-8', errors='replace')
    except Exception:
        continue
    if '/workspace' in data:
        bad.append((f, '', '/workspace'))
print('\n=== scan issues ===')
for item in bad:
    print(' BAD', item)
if not bad:
    print('no /workspace paths in packed text/zip members')
