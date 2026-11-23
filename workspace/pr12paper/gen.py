import re,json,hashlib,os
R='repo/'
items=[
 # (key, file, kind, name)
 ('T1','Scratch/KatoMaximal.lean','thm','katoMaximalSolution_of_feffermanDecay','KatoMaximal'),
 ('T2','Scratch/KatoMaximal.lean','thm','katoPonce_h3_energy_physicalMaximal','KatoMaximal'),
 ('T3','Scratch/KatoMaximal.lean','thm','h3IBPVanishingFlux_physicalMaximal','KatoMaximal'),
 ('T4','Scratch/KatoMaximal.lean','thm','isFeffermanSolutionOn_physicalMaximal','KatoMaximal'),
 ('T5','Scratch/KatoMaximal.lean','thm','momentum_physicalMaximal','KatoMaximal'),
 ('T6','Scratch/KatoMaximal.lean','thm','energyInequality_physicalMaximal','KatoMaximal'),
 ('T7','Scratch/KatoMaximal.lean','thm','continuousOn_hsSq_physicalMaximal','KatoMaximal'),
 ('T8','Scratch/KatoMaximal.lean','thm','hsSq_blowup_alternative','KatoMaximal'),
 ('T9','Scratch/KatoMaximal.lean','thm','Smax_eq_Ici_or_Ico','KatoMaximal'),
 ('T10','Scratch/KatoContinuation.lean','thm','r3BKMContinuation_of_pos','KatoContinuation'),
 ('T11','Scratch/KatoContinuation.lean','thm','clay_A_fefferman_of_rate','KatoContinuation'),
 ('Dvar','Scratch/KatoMaximal.lean','var',None,None),
 ('DinMax','Scratch/KatoMaximal.lean','def','inMaximal',None),
 ('DSmax','Scratch/KatoMaximal.lean','def','Smax',None),
 ('DKMS','Scratch/R3BKMContinuation.lean','def','KatoMaximalSolution',None),
 ('DsobE','Scratch/R3BKMContinuation.lean','def','sobolevEnergy',None),
 ('DhsSq','Scratch/R3BKMContinuation.lean','def','hsSq',None),
 ('DgradSup','Scratch/R3BKMContinuation.lean','def','gradSup',None),
 ('DFD','Scratch/RepairedTetherRate.lean','def','FeffermanDecay',None),
 ('DFGS','Scratch/RepairedTetherRate.lean','def','FeffermanGlobalSolution',None),
 ('DClay','Scratch/RepairedTetherRate.lean','def','Clay_A_Fefferman',None),
 ('DIFS','Scratch/RepairedTetherRate.lean','def','IsFeffermanSolutionOn',None),
 ('DMw','Scratch/RepairedTetherRate.lean','def','Mω',None),
 ('DRate','Scratch/RepairedTetherRate.lean','def','FrohmanianTetherRateSmooth',None),
 ('DContAt','Scratch/RepairedTetherRate.lean','def','R3BKMContinuationAt',None),
 ('DCont','Scratch/RepairedTetherRate.lean','def','R3BKMContinuation',None),
 ('DH3','Scratch/KatoPonce.lean','def','H3IBPVanishingFlux',None),
 ('DWord','Scratch/KatoPonce.lean','struct','WordIBP',None),
]
meta={}
for key,f,kind,name,ns in items:
    L=open(R+f).read().split('\n')
    if kind=='var':
        i=next(i for i,l in enumerate(L) if l.startswith('section Lift'))
        i=next(j for j in range(i,len(L)) if L[j].startswith('variable'))
        j=i+1
        out=L[i:j+1]
    else:
        pat=r'^(@\[expose\] public )?(noncomputable )?(theorem|def|structure) '+re.escape(name)+r'(\s|$)'
        i=next(i for i,l in enumerate(L) if re.match(pat,l))
        if kind=='thm':
            j=i
            while not re.search(r':=( by)?\s*$',L[j]): j+=1
            out=L[i:j+1]; out[-1]=re.sub(r'\s*:=( by)?\s*$','',out[-1])
        else:
            j=i
            while j+1<len(L) and L[j+1].strip()!='' and not L[j+1].startswith('/--'): j+=1
            out=L[i:j+1]
    txt='\n'.join(out)
    # verify verbatim
    assert txt in open(R+f).read() or kind=='thm'
    open(f'paper/lean/{key}.lean','w').write(txt+'\n')
    meta[key]=dict(file=f,name=(ns+'.'+name if ns else name),lines=f'{i+1}-{j+1}')
json.dump(meta,open('paper/lean/index.json','w'),indent=1)
for k,v in meta.items(): print(k,v)
