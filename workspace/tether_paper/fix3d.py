import numpy as np, matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
fig=plt.figure(figsize=(10,8));ax=fig.add_subplot(111,projection='3d')
Y,Z=np.meshgrid(np.linspace(-2,2,50),np.linspace(-2,2,50));T=-(Y**2+Z**2)
surf=ax.plot_surface(Y,Z,T,cmap='coolwarm',alpha=0.85,linewidth=0)
ax.scatter([0],[0],[0],color='k',s=80,label='Energy direction (⊥ to this plane): T = 0')
ax.set_xlabel(r'Projected direction 1 ($\Pi_u$)');ax.set_ylabel(r'Projected direction 2 ($\Pi_u$)');ax.set_zlabel(r'$\mathfrak{T}(F,F)$')
ax.set_title('Tether on the projected plane (corrected)\nNegative-definite here; the energy direction is orthogonal to this plane, where T = 0')
fig.colorbar(surf,shrink=0.5,aspect=5);ax.legend();plt.tight_layout()
plt.savefig('tether_3d_corrected.png',dpi=150)
