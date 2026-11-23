from pathlib import Path
import subprocess,os,re
root=Path(__file__).parent/'after/lean'
out=root/'.direct-build';out.mkdir(exist_ok=True)
env=os.environ.copy()
paths=subprocess.check_output(['lake','env','printenv','LEAN_PATH'],cwd=root,text=True).strip()
env['LEAN_PATH']=str(out)+':'+paths
lean='/home/box/.elan/toolchains/leanprover--lean4---v4.16.0/bin/lean'
sources={'.'.join(p.relative_to(root).with_suffix('').parts):p for p in root.rglob('*.lean') if '.lake' not in p.parts and p.name not in ['lakefile.lean','AxiomReport.lean','AxiomAudit.lean']}
done=set()
def build(name):
 if name in done:return
 p=sources[name]
 for dep in re.findall(r'^import\s+(\S+)',p.read_text(),re.M):
  if dep in sources:build(dep)
 dest=out/Path(*name.split('.')).with_suffix('.olean');dest.parent.mkdir(exist_ok=True,parents=True)
 subprocess.run([lean,'-DautoImplicit=false','-DrelaxedAutoImplicit=false','-o',str(dest),str(p.relative_to(root))],cwd=root,env=env,check=True)
 print('TYPECHECKED',name,flush=True);done.add(name)
for name in sources:build(name)
log=Path(__file__).parent/'clay-axiom-audit.log'
result=subprocess.run([lean,'AxiomReport.lean'],cwd=root,env=env,text=True,capture_output=True)
log.write_text(result.stdout+result.stderr)
print('AXIOM AUDIT EXIT',result.returncode,flush=True)
if result.returncode:print(result.stdout,result.stderr)
result.check_returncode()
print('FULL CLAY SOURCE LIBRARY:',len(done),'modules rebuilt, audit passed',flush=True)
