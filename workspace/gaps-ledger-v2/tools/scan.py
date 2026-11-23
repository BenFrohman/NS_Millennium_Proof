import re,subprocess,sys
repo,rev=sys.argv[1],sys.argv[2]
files=subprocess.run(['git','-C',repo,'ls-tree','-r','--name-only',rev],capture_output=True,text=True).stdout.split()
tot={}
for f in files:
    if not f.endswith('.lean'): continue
    s=subprocess.run(['git','-C',repo,'show',f'{rev}:{f}'],capture_output=True,text=True).stdout
    # strip block comments (nested) and line comments and strings
    out=[];i=0;depth=0;n=len(s)
    while i<n:
        if s.startswith('/-',i): depth+=1;i+=2;continue
        if depth and s.startswith('-/',i): depth-=1;i+=2;continue
        if depth: out.append('\n' if s[i]=='\n' else ' ');i+=1;continue
        if s.startswith('--',i):
            j=s.find('\n',i); j=n if j<0 else j; i=j; continue
        if s[i]=='"':
            j=i+1
            while j<n and s[j]!='"':
                j+= 2 if s[j]=='\\' else 1
            out.append(' '*(j+1-i));i=j+1;continue
        out.append(s[i]);i+=1
    t=''.join(out)
    for ln,line in enumerate(t.split('\n'),1):
        for w in ['sorry','admit','native_decide']:
            if re.search(r'(?<![\w.])'+w+r'(?![\w])',line):
                print(f'{w}\t{f}:{ln}\t{line.strip()[:100]}');tot[w]=tot.get(w,0)+1
        if re.match(r'^\s*(@\[[^\]]*\]\s*)?(private\s+|public\s+|protected\s+)*axiom\s',line):
            print(f'axiom\t{f}:{ln}\t{line.strip()[:100]}');tot['axiom']=tot.get('axiom',0)+1
print('TOTALS',repo.split('/')[-1],rev,tot)
