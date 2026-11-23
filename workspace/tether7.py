import numpy as np, matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
X,Y=np.meshgrid(np.linspace(-2,2,80),np.linspace(-2,2,80));Z=-Y**2
fig=plt.figure(figsize=(8,6));ax=fig.add_subplot(111,projection='3d')
surf=ax.plot_surface(X,Y,Z,cmap='RdBu_r',edgecolor='none',alpha=0.9)
ax.set_xlabel('component parallel to u (energy direction)');ax.set_ylabel('component orthogonal to u (projected)');ax.set_zlabel('TetherKernel(F,F)')
ax.set_title('3D schematic of the geometric tether\nNegative-semidefinite quadratic form, degenerate on the kinetic-energy direction',fontsize=9)
fig.colorbar(surf,shrink=0.5,aspect=10);plt.tight_layout()
plt.savefig('/workspace/tether_3d_clean.png',dpi=150);print("saved")
