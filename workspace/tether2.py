import numpy as np, matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
theta=np.linspace(0,2*np.pi,200);r=1+0.3*np.sin(3*theta);x=r*np.cos(theta);y=r*np.sin(theta)
np.random.seed(42);pts=np.random.randn(30,2);pts/=np.linalg.norm(pts,axis=1)[:,None]*1.5
fig,ax=plt.subplots(figsize=(6,6))
ax.plot(x,y,'b-',lw=2,label='coadjoint orbit (schematic)')
ax.quiver(pts[:,0]*0.6,pts[:,1]*0.6,pts[:,0],pts[:,1],color='r',scale=15,width=0.005,label='Π_u δF (projected)')
ax.set_aspect('equal');ax.set_title('Schematic of the projected pairing that defines the tether');ax.legend();ax.grid(True,alpha=0.3)
plt.tight_layout();plt.savefig('/workspace/tether_schematic2.png',dpi=120);print("saved")
