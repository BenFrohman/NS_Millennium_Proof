from pathlib import Path
import subprocess,os,sys
root=Path('/workspace/clay-solution-linked-20261106-v2/after/lean')
paths=subprocess.check_output(['lake','env','printenv','LEAN_PATH'],cwd=root,text=True).strip()
env=os.environ.copy();env['LEAN_PATH']=str(Path(__file__).parent)+':/workspace/clay-solution-linked-20261106-v2/verified-certificate-v2/compiled:'+':'.join(str((root/p).resolve()) for p in paths.split(':'))
compiler='/home/box/.elan/toolchains/leanprover--lean4---v4.16.0/bin/lean'
raise SystemExit(subprocess.run([compiler,'-DautoImplicit=false','-DrelaxedAutoImplicit=false']+sys.argv[1:],cwd=Path(__file__).parent,env=env).returncode)
