import numpy as np
N=64;L=8.0;h=L/N
x=np.arange(N)*h-L/2;X,Y,Z=np.meshgrid(x,x,x,indexing='ij')
k=2*np.pi*np.fft.fftfreq(N,h);KX,KY,KZ=np.meshgrid(k,k,k,indexing='ij');K2=KX**2+KY**2+KZ**2;K2[0,0,0]=1
def d(f,K):return np.real(np.fft.ifftn(1j*K*np.fft.fftn(f)))
def bs(w):  # u = curl(-Lap^-1 w)
    psi=[np.real(np.fft.ifftn(np.fft.fftn(c)/K2)) for c in w]
    return [d(psi[2],KY)-d(psi[1],KZ), d(psi[0],KZ)-d(psi[2],KX), d(psi[1],KX)-d(psi[0],KY)]
def proj(w): # make div-free
    wh=[np.fft.fftn(c) for c in w];dv=(KX*wh[0]+KY*wh[1]+KZ*wh[2])/K2
    return [np.real(np.fft.ifftn(wh[i]-K*dv)) for i,K in enumerate((KX,KY,KZ))]
R=np.sqrt(X**2+Y**2)
fields={
 'Lamb-Oseen tube (localized in z)':[0*X,0*X,np.exp(-R**2)*np.exp(-Z**2/4)],
 'shear layer (localized)':[0*X,np.exp(-Z**2)*np.exp(-(X**2+Y**2)/8),0*X],
 'Gaussian blob':[ -Y*np.exp(-(X**2+Y**2+Z**2)), X*np.exp(-(X**2+Y**2+Z**2)), 0.3*np.exp(-(X**2+Y**2+Z**2))],
 'vortex ring':[ -Y/(R+1e-9)*np.exp(-((R-1.5)**2+Z**2)/0.3), X/(R+1e-9)*np.exp(-((R-1.5)**2+Z**2)/0.3),0*X],
 'Burgers-like (tube+axial strain)':None}
kappa=1.5
print("field | A | M | stretch<w,Sw> | C=|grad u|/M | target RHS (C-kM)M^2*M | holds? | hweight ratio M^4/∫|w|^2|Pi dF|^2")
for name,w in fields.items():
  for A in [0.1,1,10]:
    if w is None:
      wz=A*np.exp(-R**2);w3=[0*X,0*X,wz];M=wz.max();alpha=1.0
      # Burgers: u = BS + (-a x/2,-a y/2, a z); at axis grad u = rot(M/2)+diag strain
      G=np.array([[-alpha/2,-M/2,0],[M/2,-alpha/2,0],[0,0,alpha]]);i=(N//2,N//2,N//2)
      s=alpha*M**2;wv=w3
    else:
      wv=proj([A*c for c in w]);u=bs(wv);n=np.sqrt(sum(c**2 for c in wv));i=np.unravel_index(n.argmax(),n.shape);M=n[i]
      G=np.array([[d(u[a],K)[i] for K in (KX,KY,KZ)] for a in range(3)])
      wp=np.array([c[i] for c in wv]);s=wp@G@wp
      n=np.sqrt(sum(c**2 for c in wv))
    C=np.linalg.norm(G,2)/M;rhs=(C*M-kappa*M**2)*M**2
    n=np.sqrt(sum(c**2 for c in wv));eta=np.exp(-((X-X[i])**2+(Y-Y[i])**2+(Z-Z[i])**2)/0.25)
    dF=[c/(n+1e-12)*eta for c in wv]; uu=bs(wv)
    coef=sum((dF[a]*uu[a]).sum() for a in range(3))/sum((c**2).sum() for c in uu)
    P=[dF[a]-coef*uu[a] for a in range(3)]
    I=(n**2*sum(c**2 for c in P)).sum()*h**3
    print(f"{name} | {A} | {M:.3g} | {s:.3g} | {C:.3g} | {rhs:.3g} | {s<=rhs} | {M**4/I:.3g}")
