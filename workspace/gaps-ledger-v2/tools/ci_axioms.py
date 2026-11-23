import re,sys
txt=open(sys.argv[1],errors='replace').read().split('\n')
body=[]
for l in txt:
    parts=l.split('\t',2)
    s=parts[2] if len(parts)==3 else l
    s=re.sub(r'^\ufeff?\d{4}-\d\d-\d\dT[\d:.]+Z ?','',s)
    body.append(s)
j=' '.join(body)
res={}
for m in re.finditer(r"'([^']+)' (depends on axioms: \[([^\]]*)\]|does not depend on any axioms)",j):
    ax=[a.strip() for a in (m.group(3) or '').split(',') if a.strip()]
    res[m.group(1)]=ax
std={'propext','Classical.choice','choice','Quot.sound'}
bad={k:v for k,v in res.items() if not set(v)<=std}
print('parsed',len(res),'nonstandard',len(bad),bad)
want=sys.argv[2:]
for w in want:
    hits=[k for k in res if k==w or k.endswith('.'+w)]
    for h in hits: print(f"'{h}' depends on axioms: [{', '.join(res[h])}]" if res[h] else f"'{h}' does not depend on any axioms")
    if not hits: print('MISSING',w)
