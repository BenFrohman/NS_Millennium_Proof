# Exact check: does u0 = A*U refute hDI  M' <= C M^2 - kappa M^3  with C,kappa depending only on nu?
import sympy as sp
x,y,z,A,nu,C,k=sp.symbols('x y z A nu C kappa',real=True)
U=sp.Matrix([-3*sp.sin(y)-sp.sin(x)*sp.cos(z), 3*sp.sin(x), sp.cos(x)*sp.sin(z)])
X=[x,y,z]
div=sum(sp.diff(U[i],X[i]) for i in range(3)); print('div U =',sp.simplify(div))
curl=lambda V: sp.Matrix([sp.diff(V[2],y)-sp.diff(V[1],z), sp.diff(V[0],z)-sp.diff(V[2],x), sp.diff(V[1],x)-sp.diff(V[0],y)])
W=sp.simplify(curl(U)); print('curl U =',W.T)
J=sp.Matrix(3,3,lambda i,j: sp.diff(U[i],X[j])); S=(J+J.T)/2
lap=lambda f: sum(sp.diff(f,v,2) for v in X)
# vorticity-equation RHS for u=A U at x=0:  A^2[(W.grad)U-(U.grad)W] + nu*A*lap W
str_=J*W; adv=sp.Matrix([sum(U[j]*sp.diff(W[i],X[j]) for j in range(3)) for i in range(3)])
rhs=A**2*(str_-adv)+nu*A*sp.Matrix([lap(W[i]) for i in range(3)])
r0=sp.simplify(rhs.subs({x:0,y:0,z:0})); print('vorticity RHS at 0:',r0.T, ' -> factor', sp.factor(r0[2]))
W2=sp.expand(W.dot(W)); print('|W|^2 =',W2, ' value at 0 =', W2.subs({x:0,y:0,z:0}))
# sup-norm proxy: M(0)=6A, D+M(0) >= 6A(A-nu)
M0=6*A; Mp=6*A*(A-nu)
gap=sp.expand(Mp-(C*M0**2-k*M0**3)); print('sup-norm: Mprime - RHS =',sp.collect(gap,A))
# enstrophy on T^3=(R/2piZ)^3
I=lambda f: sp.integrate(sp.integrate(sp.integrate(sp.expand(f),(x,0,2*sp.pi)),(y,0,2*sp.pi)),(z,0,2*sp.pi))
e=sp.simplify(I(W2)); s=sp.simplify(I((S*W).dot(W)))
gW=sum(sp.diff(W[i],v)**2 for i in range(3) for v in X); d=sp.simplify(I(gW))
print('int|W|^2 =',e,' int W.S.W =',s,' int|gradW|^2 =',d)
E0=A**2*e; Ep=2*A**3*s-2*nu*A**2*d
print('E(0)=',E0,'  E\'(0)=',sp.expand(Ep))
gapE=sp.expand(Ep-(C*E0**2-k*E0**3)); print('enstrophy: Eprime - RHS =',sp.collect(gapE,A))
# explicit refuting amplitudes, numeric instance
for (nv,Cv,kv) in [(1,1,1),(1,100,sp.Rational(1,100)),(sp.Rational(1,1000),10**6,10**-6)]:
    Asup=sp.Max(nv,sp.Rational(Cv,1)/(6*sp.nsimplify(kv)))+1
    print('nu,C,kappa=',nv,Cv,kv,' A=',Asup,' sup-norm gap=',sp.N(gap.subs({A:Asup,nu:nv,C:Cv,k:kv})))
