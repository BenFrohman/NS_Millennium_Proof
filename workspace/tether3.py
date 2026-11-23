import numpy as np, matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
X,Y=np.meshgrid(np.linspace(-2,2,100),np.linspace(-2,2,100));Z=-Y**2
fig=plt.figure(figsize=(7,5));ax=fig.add_subplot(111,projection='3d')
ax.plot_surface(X,Y,Z,cmap='RdBu_r',alpha=0.8)
ax.set_xlabel('component ∥ u (energy direction)');ax.set_ylabel('component ⊥ u (projected)');ax.set_zlabel('T(F,F)')
ax.set_title('Quadratic form of the tether (schematic 2-D slice)\nNegative-semidefinite, degenerate on the kinetic-energy direction',fontsize=9)
plt.tight_layout();plt.savefig('/workspace/tether_quadratic.png',dpi=120);print("saved")
