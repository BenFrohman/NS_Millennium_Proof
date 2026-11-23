import re,subprocess
H="/-\nCopyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.\nReleased under Apache 2.0 license as described in the file LICENSE.\nAuthors: Benjamin Stanley Frohman\n-/\n"
out=subprocess.run(['python3','/workspace/header_audit/audit_wt.py'],capture_output=True,text=True).stdout
for line in out.splitlines():
  st,f=line.split('\t')
  if st=='EXACT': continue
  t=open(f,encoding='utf-8').read()
  if f.startswith('historical/top-level-stubs-2026-08-26/'):
    m=re.match(r'/-!\n\*\*Copyright[^\n]*\n\n\*\*Original Author:\*\*[^\n]*\n\n(.*?)\n-/\n',t,re.S)
    assert m,f
    new=H+'/-!\n'+m.group(1)+'\n-/\n'+t[m.end():]; cat='stub'
  elif f=='historical/MathPort_Header_Template.lean':
    m=re.match(r'/-\nCopyright[^\n]*\nReleased[^\n]*\nAuthors:[^\n]*\n\n',t); assert m
    new=H+'/-\n'+t[m.end():]; cat='template'
  elif f.endswith(('Modules/NS_Equations.lean','Modules/TetheredLyapunov.lean')) and 'previous_implementations' in f:
    new=H+'\n'+re.sub(r'\n\*\*Author:\*\* Benjamin Stanley Frohman \(@Investor0x / Bit21\)\n','\n',t,count=1); cat='prev-markdown-notice'
  elif f.endswith('RelationshipDoc.lean'):
    new=H+'\n'+t.replace('**Author:** Benjamin Stanley Frohman\n','',1); cat='prev-docstring-author'
  else:
    new=H+'\n'+t; cat='prepend'
  open(f,'w',encoding='utf-8').write(new); print(cat,f)
