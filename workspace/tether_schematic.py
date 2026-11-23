import numpy as np, matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
x=np.linspace(-2,2,100);y=np.linspace(-2,2,100);X,Y=np.meshgrid(x,y);Z=-Y**2
fig=plt.figure(figsize=(8,6));ax=fig.add_subplot(111,projection='3d')
ax.plot_surface(X,Y,Z,cmap='viridis',alpha=0.8)
ax.set_xlabel('Energy direction (H)');ax.set_ylabel('Projected direction (Π_u)');ax.set_zlabel('TetherKernel(F,F)')
ax.set_title('Schematic of the geometric tether (negative-semidefinite on projected directions)',fontsize=9)
plt.tight_layout();plt.savefig('/workspace/tether_schematic.png',dpi=150);print("ok")
