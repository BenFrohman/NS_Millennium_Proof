import re,subprocess,os,sys
pairs=[("inner_eq_zero_of_hasDerivAt_of_norm_eq_one","unit_direction_deriv_orthogonal"),("hasDerivAt_smul_polar","hasDerivAt_polar"),("norm_polar_deriv_sq_eq_of_hasDerivAt","polar_pythagoras_of_hasDerivAt"),("hasDerivAt_inner_self_deriv_of_hasDerivAt","bochner_leibniz_of_hasDerivAt"),("inner_eq_zero_of_isLocalMax_half_norm_sq","inner_deriv_zero_at_max"),("iSup_eq_zero_of_not_bddAbove","real_iSup_eq_zero_of_not_bddAbove"),("hasDerivAt_shearU_z","shearU_hasDerivAt_z"),("hasDerivAt_shearV_z","shearV_hasDerivAt_z"),("shearU_zero_ne_quarter","shear_nonconstant"),("shear_convective_and_div_eq_zero","shear_convective_and_div_zero"),("inner_laplacian_eq_laplacian_half_norm_sq_sub_norm_grad_sq","bochner_laplacian_3d_identity"),("norm_polar_grad_sq_eq","polar_pythagoras_3d_sum"),("vorticity_sup_norm_eq_of_attainedSpatialMaximum","vorticity_sup_norm_eq_of_isSpatialMax"),("clay_B_exact_of_hasDirectionCurvatureCoercivity","clay_reduces_to_direction_curvature_bound")]
root=sys.argv[1]
for t in subprocess.check_output(['git','ls-files'],cwd=root,text=True).split('\n'):
    if not t.endswith(('.lean','.md','.tex')) or t.startswith('audit/'): continue
    p=os.path.join(root,t); s=open(p).read(); o=s
    for new,old in pairs:
        s=re.sub(rf'(?<![\w])(Real\.)?{new}(?![\w])',lambda m:(m.group(1) or '')+old if m.group(1) else old,s) if new!="iSup_eq_zero_of_not_bddAbove" else re.sub(rf'(?<![\w.]){new}(?![\w])',old,s)
        # latex escaped
        s=s.replace(new.replace('_','\\_'),old.replace('_','\\_'))
    if s!=o: open(p,'w').write(s); print('upd',t)
