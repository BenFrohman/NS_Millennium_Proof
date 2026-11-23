# Pseudo-spectral 3D NS on (R/2piZ)^3, 2/3 dealiasing, RK4, vorticity sup-norm and enstrophy tracking.
import numpy as np, json, sys
def run(name,u0f,N=64,nu=0.05,T=2.0,dt=2e-3):
    k=np.fft.fftfreq(N,1/N); KX,KY,KZ=np.meshgrid(k,k,k,indexing='ij'); K2=KX**2+KY**2+KZ**2; K2i=np.where(K2==0,1,K2)
    deal=(np.abs(KX)<N/3)&(np.abs(KY)<N/3)&(np.abs(KZ)<N/3)
    x=np.arange(N)*2*np.pi/N; X,Y,Z=np.meshgrid(x,x,x,indexing='ij')
    u=np.array(u0f(X,Y,Z)); uh=np.fft.fftn(u,axes=(1,2,3))
    Kv=np.array([KX,KY,KZ])
    def proj(vh):
        d=(Kv*vh).sum(0)/K2i; return vh-Kv*d
    def curlh(vh): return 1j*np.array([KY*vh[2]-KZ*vh[1],KZ*vh[0]-KX*vh[2],KX*vh[1]-KY*vh[0]])
    def rhs(uh):
        u=np.real(np.fft.ifftn(uh,axes=(1,2,3))); w=np.real(np.fft.ifftn(curlh(uh),axes=(1,2,3)))
        nl=np.fft.fftn(np.cross(u,w,axis=0),axes=(1,2,3))*deal
        return proj(nl)-nu*K2*uh
    def diag(uh):
        wh=curlh(uh); w=np.real(np.fft.ifftn(wh,axes=(1,2,3)))
        M=np.sqrt((w**2).sum(0)).max(); E=0.5*(w**2).sum(0).mean()*(2*np.pi)**3
        return M,E
    ts=[];Ms=[];Es=[]; n=int(round(T/dt))
    for i in range(n+1):
        if i%5==0:
            M,E=diag(uh); ts.append(i*dt);Ms.append(M);Es.append(E)
        if i==n: break
        k1=rhs(uh);k2=rhs(uh+dt/2*k1);k3=rhs(uh+dt/2*k2);k4=rhs(uh+dt*k3)
        uh=uh+dt/6*(k1+2*k2+2*k3+k4)
    return dict(name=name,N=N,nu=nu,T=T,dt=dt,t=ts,M=Ms,E=Es)
AU=lambda X,Y,Z:[-3*np.sin(Y)-np.sin(X)*np.cos(Z),3*np.sin(X),np.cos(X)*np.sin(Z)]
TG=lambda X,Y,Z:[np.sin(X)*np.cos(Y)*np.cos(Z),-np.cos(X)*np.sin(Y)*np.cos(Z),0*X]
out=[]
for nm,f,amp in [("AU A=1",AU,1.0),("AU A=3",AU,3.0),("TaylorGreen A=3",TG,3.0)]:
    r=run(nm,lambda X,Y,Z,f=f,a=amp:[a*c for c in f(X,Y,Z)]); out.append(r)
    t=np.array(r['t']);M=np.array(r['M']);E=np.array(r['E'])
    Mp=np.gradient(M,t)
    print(nm,"M(0)=%.4f maxM=%.4f at t=%.3f  M(T)=%.4f  E(0)=%.4f E(T)=%.4f"%(M[0],M.max(),t[M.argmax()],M[-1],E[0],E[-1]),flush=True)
    for C,kk in [(1.5,1.5),(1.0,0.01),(0.1,1.0)]:
        g=Mp-(C*M**2-kk*M**3); print("   C=%g k''=%g: max_t [M' - (C M^2 - k'' M^3)] = %.4f (violation if >0) at t=%.3f"%(C,kk,g.max(),t[g.argmax()]))
    # smallest C making it hold with k''=given: C_needed(t)=(M'+k''M^3)/M^2
    for kk in [0.01,0.1,1.5]:
        print("   k''=%g: minimal C over run = %.4f"%(kk,((Mp+kk*M**3)/M**2).max()))
json.dump(out,open('ns_sim_results.json','w'))
