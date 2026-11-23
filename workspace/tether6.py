import numpy as np, matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
fig=plt.figure(figsize=(10,8));ax=fig.add_subplot(111,projection='3d')
Y,Z=np.meshgrid(np.linspace(-2,2,50),np.linspace(-2,2,50));T=-(Y**2+Z**2)
surf=ax.plot_surface(Y,Z,T,cmap='coolwarm',alpha=0.8,linewidth=0,antialiased=True)
ax.plot([-2,2],[0,0],[0,0],'k-',linewidth=3,label='Energy direction (T=0)')
ax.set_xlabel(r'Projected $y$');ax.set_ylabel(r'Projected $z$');ax.set_zlabel(r'$\mathfrak{T}$')
ax.set_title('3D schematic of the geometric tether\n(negative-semidefinite in projected plane, zero on energy direction)')
fig.colorbar(surf,shrink=0.5,aspect=5);ax.legend();plt.tight_layout()
plt.savefig('/workspace/tether_3d_v2.png',dpi=150);print("saved")
