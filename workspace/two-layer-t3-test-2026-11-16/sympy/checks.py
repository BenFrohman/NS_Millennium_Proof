# Two-layer T^3 test: exact symbolic checks (sympy). Benjamin Stanley Frohman, 2026-11-16.
import sympy as sp
x,y,z,t,nu,A,kap=sp.symbols('x y z t nu A kappa',real=True)
X=(x,y,z); P=2*sp.pi
def integ(f):
    f=sp.expand(sp.expand_trig(f)) if False else sp.expand(f)
    return sp.simplify(sp.integrate(f,(x,0,P),(y,0,P),(z,0,P)))
def grad(f): return sp.Matrix([sp.diff(f,v) for v in X])
def div(u): return sum(sp.diff(u[i],X[i]) for i in range(3))
def curl(u): return sp.Matrix([sp.diff(u[2],y)-sp.diff(u[1],z), sp.diff(u[0],z)-sp.diff(u[2],x), sp.diff(u[1],x)-sp.diff(u[0],y)])
def lap(u): return sp.Matrix([sum(sp.diff(u[i],v,2) for v in X) for i in range(3)])
def J(u): return sp.Matrix(3,3,lambda i,j: sp.diff(u[i],X[j]))
def dot(a,b): return sum(a[i]*b[i] for i in range(3))

print("== (a) generic pointwise IBP identity for d/dt 1/2|w|^2 along NS vorticity eq ==")
uf=[sp.Function('u%d'%i)(x,y,z) for i in range(3)]; u=sp.Matrix(uf); w=curl(u)
wt = (J(u)*w) - J(w)*u + nu*lap(w)           # vorticity eq RHS (omega.grad)u - (u.grad)omega + nu Lap omega
S=(J(u)+J(u).T)/2
lhs=dot(w,wt)
rhs = dot(w,S*w) - dot(u,grad(dot(w,w)/2)) + nu*(sum(sp.diff(dot(w,w)/2,v,2) for v in X) - sum(dot(sp.diff(w,v),sp.diff(w,v)) for v in X))
print("w.(wt) - [w.Sw - u.grad(|w|^2/2) + nu(Lap(|w|^2/2) - |grad w|^2)] =", sp.simplify(sp.expand(lhs-rhs)))
print("  and -u.grad(|w|^2/2) = -div(u|w|^2/2) + div(u)|w|^2/2 :",
      sp.simplify(sp.expand(-dot(u,grad(dot(w,w)/2)) - (-div(u*dot(w,w)/2) + div(u)*dot(w,w)/2))))
print("  => on T^3 with div u = 0:  d/dt 1/2||w||^2 = INT w.Sw - nu||grad w||^2  (no other term).")

fields={
 'AU (Nov 9)': A*sp.Matrix([-3*sp.sin(y)-sp.sin(x)*sp.cos(z), 3*sp.sin(x), sp.cos(x)*sp.sin(z)]),
 'Taylor-Green': A*sp.Matrix([sp.sin(x)*sp.cos(y)*sp.cos(z), -sp.cos(x)*sp.sin(y)*sp.cos(z), 0]),
 'ABC(1,1,1)': A*sp.Matrix([sp.sin(z)+sp.cos(y), sp.sin(x)+sp.cos(z), sp.sin(y)+sp.cos(x)]),
 'shear (sin y,0,0)': A*sp.Matrix([sp.sin(y),0,0]),
}
def vecpot(u):
    # mean-zero div-free trig fields: A = curl^{-1} via Fourier: A = curl((-Lap)^{-1} u); here fields are finite sums of shells
    # solve componentwise: (-Lap)^{-1} on each trig monomial = divide by |k|^2 (detected by applying -Lap)
    def invlap(f):
        f=sp.expand(sp.expand_trig(f)); out=0
        for term in sp.Add.make_args(f):
            if term==0: continue
            k2=sp.simplify(-sum(sp.diff(term,v,2) for v in X)/term)
            out+=term/k2
        return out
    psi=sp.Matrix([invlap(c) for c in u]); return curl(psi)
res={}
for name,u in fields.items():
    print("\n==",name,"==")
    w=curl(u); S=(J(u)+J(u).T)/2; Av=vecpot(u)
    assert sp.simplify(div(u))==0
    assert sp.simplify(curl(Av)-u)==sp.zeros(3,1)
    E=integ(dot(w,w))/2; stretch=integ(dot(w,S*w)); diss=integ(sum(dot(sp.diff(w,v),sp.diff(w,v)) for v in X))
    Ep=sp.simplify(stretch-nu*diss)
    print(" enstrophy E=1/2||w||^2 =",E,"; INT w.Sw =",stretch,"; ||grad w||^2 =",diss,"; E'(0) NS =",Ep)
    uu=integ(dot(u,u))
    # momentum reading: delta H/delta u = u, Pi_u u = 0
    Pu_u = sp.simplify(u - integ(dot(u,u))/uu*u)
    print(" [momentum reading] Pi_u(dH/du) = Pi_u(u) =",list(Pu_u),"  => B_F(F,H)=0 for every F")
    # vorticity reading: delta H/delta w = vector potential Av
    au=integ(dot(Av,u)); PA=sp.simplify(Av-au/uu*u)
    Pw=sp.simplify(w-integ(dot(w,u))/uu*u)
    BEH=sp.simplify(-kap*integ(dot(w,w)*dot(Pw,PA)))
    print(" [vorticity reading] <A,u> =",au,"; Pi_u(A)==0?",PA==sp.zeros(3,1),"; B_F(E,H) = -k INT|w|^2 Pi_u w . Pi_u A =",BEH)
    # viscous part NS - Euler (Hamiltonian flow of H wrt T_F, degenerate):  nu*Lap u
    print(" NS minus (Lie-Poisson + B_F with generator H) vector field = nu*Lap u =",list(sp.simplify(nu*lap(u))))
    # Layer-2 functional S_eps = INT 1/2|w|^2 + k/4 |w|^4 phi, phi(0)=0, D phi/Dt = |w|^2 : extra term at t=0
    w6=integ(dot(w,w)**3)
    print(" d/dt (k/4)INT|w|^4 phi at t=0 = (k/4) INT|w|^6 =",sp.simplify(kap/4*w6))
    res[name]=dict(E=E,stretch=stretch,diss=diss,Ep=Ep,BEH=BEH,w6=w6)
# Constants verdict for enstrophy, AU family
r=res['AU (Nov 9)']; C,kk=sp.symbols('C kappa2',positive=True)
gap=sp.expand(r['Ep']-(C*r['E']**2-kk*r['E']**3))
print("\n== enstrophy, AU: E'(0) - (C E^2 - k'' E^3) =",gap)
