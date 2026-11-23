import numpy as np, matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
x=np.linspace(-2,2,400);tether=-1.0*1.0*x**2
plt.figure(figsize=(8,5));plt.plot(x,tether,'b-',linewidth=2,label=r'$\mathfrak{T}(F,F) \propto -|\Pi_u \delta F|^2$')
plt.axhline(0,color='k',linewidth=0.5);plt.xlabel(r'Projected component $\Pi_u \delta F$');plt.ylabel('Tether contribution')
plt.title('Conceptual plot of the geometric tether (negative-semidefinite)');plt.legend();plt.grid(True,alpha=0.3)
plt.tight_layout();plt.savefig('/workspace/tether_1d.png',dpi=150);print("saved")
