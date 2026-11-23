import subprocess,difflib,sys
def show(repo,rev,f): return subprocess.run(['git','-C',repo,'show',f'{rev}:{f}'],capture_output=True,text=True).stdout.split('\n')
refs=[l.split() for l in sys.stdin.read().strip().split('\n')]
for repo,old,new,f,*lines in refs:
    a=show(repo,old,f);b=show(repo,new,f)
    sm=difflib.SequenceMatcher(None,a,b,autojunk=False)
    mp={}
    for tag,i1,i2,j1,j2 in sm.get_opcodes():
        if tag=='equal':
            for k in range(i2-i1): mp[i1+k+1]=j1+k+1
    out=[]
    for ln in lines:
        n=int(ln); out.append(f"{n}->{mp.get(n,'CHANGED')}")
    print(f.split('/')[-1],' '.join(out))
