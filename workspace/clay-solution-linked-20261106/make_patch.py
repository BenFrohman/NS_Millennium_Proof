from pathlib import Path
import subprocess
r=Path(__file__).parent
paths=['lean/Clay/Depletion/SolutionLinkedVortexLines.lean','lean/Clay.lean',
 'lean/SolutionLinkedRegression.lean','.github/workflows/lean.yml',
 'docs/SOLUTION_LINKED_VORTEX_LINES.md','paper/Clay_Technical_Monograph_2026.tex',
 'paper/Clay_Technical_Monograph_2026.pdf','AXIOMS.md',
 'AUTHORS.md','NOTICE','README.md','SECURITY.md','scripts/build_lean_certificate.py']
chunks=[]
for rel in paths:
 old=r/'before'/rel;new=r/'after'/rel
 p=subprocess.run(['git','diff','--no-index','--binary','--',str(old) if old.exists() else '/dev/null',str(new)],capture_output=True)
 assert p.returncode in [0,1],p.stderr
 lines=p.stdout.decode().splitlines(keepends=True)
 for i,line in enumerate(lines):
  if line.startswith('diff --git '):lines[i]=f'diff --git a/{rel} b/{rel}\n'
  elif line.startswith('--- ') and '/dev/null' not in line:lines[i]=f'--- a/{rel}\n'
  elif line.startswith('+++ '):lines[i]=f'+++ b/{rel}\n'
 chunks.append(''.join(lines))
(r/'solution-linked-clay.patch').write_text(''.join(chunks))
print(r/'solution-linked-clay.patch')
