#!/usr/bin/env python3
# Copyright (c) 2026 Benjamin Stanley Frohman. Released under Apache 2.0 (see LICENSE).
"""Quick T^3 check: integer rescaling u_l(x)=l*u(l x) maps 1-periodic fields to 1-periodic
fields. Measures how cell energy E, enstrophy Om and sup|omega| M scale, and the
Poincare constant (first nonzero eigenvalue of -Lap on R^3/Z^3 is 4 pi^2)."""
import numpy as np
N=48; x=np.arange(N)/N; X,Y,Z=np.meshgrid(x,x,x,indexing='ij')
k=np.fft.fftfreq(N,1/N)*2*np.pi; KX,KY,KZ=np.meshgrid(k,k,k,indexing='ij')
def field(l):
    a=2*np.pi*l  # Taylor-Green at wavenumber l, times amplitude l
    return [l*np.sin(a*X)*np.cos(a*Y)*np.cos(a*Z), -l*np.cos(a*X)*np.sin(a*Y)*np.cos(a*Z), 0*X]
def d(f,K): return np.real(np.fft.ifftn(1j*K*np.fft.fftn(f)))
for l in [1,2,3,4]:
    u,v,w=field(l)
    ox=d(w,KY)-d(v,KZ); oy=d(u,KZ)-d(w,KX); oz=d(v,KX)-d(u,KY)
    E=np.mean(u*u+v*v+w*w); Om=np.mean(ox**2+oy**2+oz**2); M=np.sqrt(ox**2+oy**2+oz**2).max()
    print(f"l={l}: E={E:.4f} (E/E1={E/0.25:.1f}) Om={Om:.2f} M={M:.2f}  Om/E={Om/E:.2f} >= 4pi^2={4*np.pi**2:.2f}")
print("Integer rescaling: E ~ l^2, Om ~ l^4, M ~ l^2 at fixed nu: no bound M<=F(E,nu) uniform in data follows from compactness alone;")
print("Poincare Om >= 4pi^2 E gives exponential energy decay E(t)<=E(0)exp(-8pi^2 nu t) (mean-zero), a known T^3 advantage that is subcritical-irrelevant for large data.")
