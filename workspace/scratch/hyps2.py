import re,glob,collections
props=set()
src={}
for f in glob.glob('FrohmanianTether/**/*.lean',recursive=True):
    s=open(f).read(); src[f]=s
    for m in re.finditer(r'^(?:@\[[^\]]*\]\s*)?(?:public\s+|private\s+|noncomputable\s+)*def\s+(\S+)[^:=]*?(?:\([^)]*\)\s*|\{[^}]*\}\s*)*:\s*\n?\s*Prop\b',s,re.M):
        props.add(m.group(1))
use=collections.defaultdict(set)
for f,s in src.items():
    for m in re.finditer(r'^(?:@\[[^\]]*\]\s*)?(?:public\s+|private\s+)*theorem\s+(\S+)(.*?):=',s,re.M|re.S):
        name,stmt=m.group(1),m.group(2)
        for b in re.finditer(r"\(\s*\w+\s*:\s*([^()]*?(?:\([^()]*\))*[^()]*)\)',stmt):
            t=b.group(1)
            for p in props:
                short=p.split('.')[-1]
                if re.search(r'(?<![\w.])(?:\w+\.)*'+re.escape(short)+r'(?![\w])',t):
                    use[short].add(f.split('/')[-1]+':'+name)
for k in sorted(use): print(k, len(use[k]))
