import sys,re
# usage: name file startline mode(stmt|def)
def ext(path,start,mode):
    L=open(path,encoding='utf8').read().split('\n')
    out=[];i=start-1
    while i<len(L):
        l=L[i]
        if mode=='stmt' and ':=' in l:
            out.append(l[:l.index(':=')].rstrip()+' := ...'); break
        if mode=='def' and l.strip()=='' : break
        if mode=='full' and l.strip()=='' : break
        out.append(l); i+=1
    return '\n'.join(out).rstrip()+'\n'
P='/workspace/ns_push/NS_Millennium_Proof/Modules/'; T='/workspace/ns_trial/NS_Millennium_Proof/Modules/'
S=[('frohmanian_tether_theorem_main',P+'GlobalRegularity.lean',74,'stmt'),
('global_regularity_for_NS_main',P+'GlobalRegularity.lean',197,'stmt'),
('global_regularity_for_NS_blueprint',P+'ClosureBlueprint.lean',234,'stmt'),
('comparison_ode_stability',P+'AnalyticPipeline.lean',85,'stmt'),
('comparison_majorant_global_bound',P+'IndependentMajorant.lean',27,'full'),
('riccati_ceiling_of_vorticity_di',P+'TetheredLyapunov.lean',1968,'stmt'),
('reduced_pairing',P+'SymplecticTether.lean',591,'full'),
('tethered_stretching_of_weight',P+'SymplecticTether.lean',643,'stmt'),
('stretching_inner_le_at_max',P+'NS_Equations.lean',2820,'stmt'),
('tetherKernel_degenerates',P+'SymplecticTether.lean',933,'stmt'),
('TetherKernel',P+'SymplecticTether.lean',350,'def'),
('Pi_u',P+'ForMathlib/Projection.lean',35,'def'),
('CoadjointAction',P+'ArnoldGeometric.lean',179,'def'),
('tether_coadjoint_invariance',P+'SymplecticTether.lean',905,'stmt'),
('uniqueness_of_minimal_tether',P+'Uniqueness.lean',358,'stmt'),
('SaturatesTetherQuadratic',P+'Uniqueness.lean',329,'def'),
('tethered_jacobi_identity',P+'SymplecticTether.lean',1038,'stmt'),
('IsEnstrophyAccumulation',P+'TetheredLyapunov.lean',509,'def'),
('LyapunovS',P+'TetheredLyapunov.lean',520,'def'),
('IsPeriodicSmoothSolution',T+'ClayStatements.lean',245,'def'),
('Clay_B_exact',T+'ClayStatements.lean',255,'def'),
('library_huniq',T+'ClayStatements.lean',351,'stmt'),
('closing_bound_family',T+'ClayStatements.lean',377,'stmt'),
('PeriodicTetherClosingBound',T+'ClayStatements.lean',None,'def'),
('PeriodicBKMContinuation',T+'ClayStatements.lean',None,'def'),
('clay_B_exact_of_periodic',T+'ClayStatements.lean',440,'full'),
('FrohmanianTetherBound_trial',T+'SymplecticTether.lean',631,'def'),
]
for n,f,s,m in S:
    if s is None:
        L=open(f,encoding='utf8').read().split('\n'); s=[i+1 for i,l in enumerate(L) if re.search(r'def '+n.split('_')[0]+r'\b',l) or ('def '+n+' ') in l][0]
    open('lean/'+n+'.lean','w',encoding='utf8').write(ext(f,s,m))
