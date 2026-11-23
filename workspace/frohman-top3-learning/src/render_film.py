# SPDX-License-Identifier: Apache-2.0
# Copyright 2026 Benjamin Stanley Frohman
"""Render ~180s top-3 learning film (1080p30). Visuals derived from cited sources."""
import json, sys, collections
from pathlib import Path
import numpy as np
import matplotlib; matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch, Circle, FancyArrowPatch
import matplotlib.patheffects as pe

sys.path.insert(0, '/workspace/p2q-mk1-viz/src')
import p2q

ROOT = Path(__file__).resolve().parents[1]
OUT = Path(sys.argv[1]); OUT.mkdir(parents=True, exist_ok=True)
NF, DUR = 540, 180.0  # 180s @ 30fps
BG, GOLD, MUTE, GREEN, RED, VIO, TEAL = '#07080c', '#e6cf92', '#8a93a3', '#8fe0a0', '#ff8a8a', '#b99cff', '#7ee0c6'
plt.rcParams.update({'font.family':'DejaVu Sans','text.color':'#d9dfcf','axes.facecolor':'#0c0e14','figure.facecolor':BG,'axes.edgecolor':'#2a3040'})

# --- data from sources ---
SPF = p2q.spf_sieve(200000+12)
RECS = p2q.p2q_records(200000, SPF)
ns = np.array([r[0] for r in RECS], float)
dphi = np.array([r[3]-12 for r in RECS], float)
dsig = np.array([r[4]-12 for r in RECS], float)
SOL = p2q.all_composite_solutions(200000, SPF)
# so(3) example Prop.1: κ=1.5, w=2 → -3
KAPPA, W = 1.5, 2.0
TT = -KAPPA*W  # -3
# ladder steps from NS paper abstract
LADDER = [
 ('Local existence','proved'),
 ('Energy uniqueness','proved'),
 ('H³ / BKM control','proved'),
 ('BKM criterion','proved'),
 ('PeriodicBKMIntegrability','OPEN'),
 ('Clay Statement (B)','equivalent to open rung'),
]

def watermark(fig):
  fig.text(0.98, 0.962, 'Benjamin Stanley Frohman', color='#F2E2A8', fontsize=15, ha='right', alpha=0.95,
           path_effects=[pe.withStroke(linewidth=3.5, foreground='black')])

def panel_title(fig, title, subtitle):
  fig.text(0.03, 0.955, title, color=GOLD, fontsize=20, fontweight='bold')
  fig.text(0.03, 0.915, subtitle, color=MUTE, fontsize=11)

def draw_intro(fig, s):
  panel_title(fig, 'THREE CHECKABLE CONTRIBUTIONS', 'A short learning tour of Benjamin Stanley Frohman’s strongest reproducible work')
  boxes=[('01  Number theory','Totient–divisor jumps\nTheorem 28'),
         ('02  Geometric fluids','Frohmanian tether\nmetriplectic obstruction'),
         ('03  Formal analysis','Classical NS chain\nin Lean 4')]
  for i,(h,b) in enumerate(boxes):
    ax=fig.add_axes([0.06+i*0.31, 0.28, 0.28, 0.48])
    ax.set_xlim(0,1); ax.set_ylim(0,1); ax.axis('off')
    ax.add_patch(FancyBboxPatch((0.05,0.1),0.9,0.8, boxstyle='round,pad=0.03', facecolor='#12151c', edgecolor=GOLD, lw=1.5))
    ax.text(0.5,0.7,h,ha='center',color=GOLD,fontsize=14)
    ax.text(0.5,0.4,b,ha='center',color='#d9dfcf',fontsize=12)
  fig.text(0.03,0.08,'Selection criteria: correctness of scope · nontrivial substance · reproducibility · usefulness  ·  Not a world-ranking.', color=MUTE, fontsize=10)

def draw_p2q(fig, s):
  panel_title(fig, '01 · JUMPS OF LENGTH 12', 'doi:10.5281/zenodo.22727814  ·  eq. (1), Theorem 1, Theorem 28  ·  Conjecture 3 open')
  nmax = 40 * (200000/40)**min(1, max(0,(s-0.08)/0.35))
  m = ns <= nmax
  a1=fig.add_axes([0.07,0.48,0.55,0.35]); a2=fig.add_axes([0.07,0.12,0.55,0.30])
  for a,y,lab in ((a1,dphi,r'$\varphi(n+12)-\varphi(n)-12$'),(a2,dsig,r'$\sigma(n+12)-\sigma(n)-12$')):
    a.set_xscale('log'); a.set_yscale('symlog', linthresh=10); a.set_xlim(40, 2.2e5); a.axhline(0,color=GREEN,lw=1,alpha=.7)
    a.scatter(ns[m], y[m], s=4, c=np.log10(ns[m]), cmap='plasma', lw=0, vmin=1.5, vmax=5.3)
    a.set_ylabel(lab, fontsize=10)
  a2.set_xlabel(r'$n=p^2 q$ (distinct primes)', fontsize=10)
  sol=[n for n in SOL if n<=nmax]
  a1.scatter(sol,[0]*len(sol), marker='*', s=80, color=TEAL, zorder=5, label='quadruplet solutions')
  a1.legend(loc='upper left', fontsize=8, facecolor='#12151c')
  both=int(np.sum(m & (dphi==0) & (dsig==0)))
  fig.text(0.65,0.55, f'Finite search display\nn ≤ {int(nmax):,}  (of max 200,000)\np²q values: {int(m.sum()):,}\nφ-jump alone: {int(np.sum(m&(dphi==0))):,}\nσ-jump alone: {int(np.sum(m&(dsig==0))):,}\nboth jumps: {both} in this window',
           fontsize=12, color='#d9dfcf', family='DejaVu Sans Mono',
           bbox=dict(facecolor='#12151c', edgecolor='#2a3040', boxstyle='round'))
  fig.text(0.65,0.18, 'Paper Theorem 28: if both jumps hold\nand n=p²q, then N is not rst.\nConjecture 3 (existence) remains OPEN.\nPlot = finite search only (not Conj. 3).',
           fontsize=11, color=GOLD, bbox=dict(facecolor='#12151c', edgecolor=GOLD, boxstyle='round'))

def draw_tether(fig, s):
  panel_title(fig, '02 · A TETHER THAT HOLDS NOTHING', 'doi:10.5281/zenodo.23971661 · 10.5281/zenodo.23965512  ·  this tether: metriplectic≠Poisson')
  ax=fig.add_axes([0.06,0.18,0.42,0.62]); ax.set_xlim(-1.2,1.2); ax.set_ylim(-1.2,1.2); ax.set_aspect('equal'); ax.set_title('so(3)* example (Prop. 1)', color=MUTE, fontsize=11)
  # sphere leaf schematic
  circ=Circle((0,0),1, fill=False, color='#334', lw=1); ax.add_patch(circ)
  ax.annotate('', xy=(0.9,0), xytext=(0,0), arrowprops=dict(arrowstyle='->', color=TEAL, lw=2))
  ax.text(0.95,0.05,'u = e₁', color=TEAL, fontsize=10)
  ax.annotate('', xy=(0,0.85), xytext=(0,0), arrowprops=dict(arrowstyle='->', color=VIO, lw=2))
  ax.text(0.05,0.9,'δF = e₂', color=VIO, fontsize=10)
  ax.text(0, -1.1, r'$\{F,F\}_{\mathrm{tethered}}=T(F,F)=-\kappa w=-\,%.1f$'%(-TT), ha='center', color=GOLD, fontsize=12)
  ax.axis('off')
  ax2=fig.add_axes([0.55,0.22,0.4,0.55]); ax2.axis('off'); ax2.set_xlim(0,1); ax2.set_ylim(0,1)
  rows=[('Lie–Poisson {F,F}', '0  (antisymmetric)', GREEN),
        ('Tether T(F,F)', f'−κw = {TT:g}', VIO),
        ('Tethered sum', '≠ 0  ⇒ not Poisson', RED),
        ('Energy nullity C2', 'T(H,·)=0', TEAL),
        ('Enstrophy from THIS T', 'vanishes by its symmetry', RED)]
  for i,(a,b,c) in enumerate(rows):
    y=0.85-i*0.16
    ax2.add_patch(FancyBboxPatch((0.05,y-0.06),0.9,0.12, boxstyle='round,pad=0.01', facecolor='#12151c', edgecolor=c, lw=1.2))
    ax2.text(0.1,y,a,color=MUTE,fontsize=11,va='center'); ax2.text(0.92,y,b,color=c,fontsize=11,va='center',ha='right')
  fig.text(0.55,0.12,'Diagram of the verified identity + structural obstruction (not a Navier–Stokes solve).', color=MUTE, fontsize=10)

def draw_ns(fig, s):
  panel_title(fig, '03 · CLASSICAL CONTINUATION IN LEAN', 'doi:10.5281/zenodo.23986023  ·  classical BKM formalized in Lean; Clay core still open')
  ax=fig.add_axes([0.12,0.15,0.76,0.68]); ax.set_xlim(0,1); ax.set_ylim(0,len(LADDER)+0.5); ax.axis('off')
  ax.set_title('Formalization status ladder (diagram of paper claims)', color=MUTE, fontsize=12)
  for i,(name,st) in enumerate(reversed(LADDER)):
    y=i+0.5; proved = st=='proved'
    color = GREEN if proved else (GOLD if 'OPEN' in st else VIO)
    ax.add_patch(FancyBboxPatch((0.15,y-0.35),0.7,0.7, boxstyle='round,pad=0.02', facecolor='#12151c', edgecolor=color, lw=1.5))
    ax.text(0.5,y, f'{name}\n{st}', ha='center', va='center', color=color, fontsize=12)
    if i<len(LADDER)-1:
      ax.annotate('', xy=(0.5,y+0.4), xytext=(0.5,y+0.65), arrowprops=dict(arrowstyle='->', color='#445', lw=1.5))
  fig.text(0.12,0.08,'Formalization of classical theory (not new analysis). Not a proof of global regularity.', color=MUTE, fontsize=11)

def draw_close(fig, s):
  panel_title(fig, 'SOURCES & CREDITS', 'Benjamin Stanley Frohman  ·  ORCID 0009-0006-7068-3718')
  ax=fig.add_axes([0.08,0.15,0.84,0.68]); ax.axis('off'); ax.set_xlim(0,1); ax.set_ylim(0,1)
  txt=('01  Totient–divisor jumps of length 12\n'
       '    https://doi.org/10.5281/zenodo.22727814\n\n'
       '02  A Tether That Holds Nothing / metriplectic ≠ Poisson\n'
       '    https://doi.org/10.5281/zenodo.23971661\n'
       '    https://doi.org/10.5281/zenodo.23965512\n\n'
       '03  Classical NS continuation chain in Lean 4\n'
       '    https://doi.org/10.5281/zenodo.23986023\n\n'
       'Selection rationale: SELECTION.md in this package.\n'
       'Claim→source table: sources/CLAIM_SOURCE_MAP.md')
  ax.text(0.05,0.95, txt, va='top', family='DejaVu Sans Mono', fontsize=13, color='#d9dfcf')

def frame(i):
  s=i/(NF-1); t=s*DUR
  fig=plt.figure(figsize=(19.2,10.8), dpi=100)
  if t < 15: draw_intro(fig, s)
  elif t < 88: draw_p2q(fig, s)
  elif t < 140: draw_tether(fig, s)
  elif t < 168: draw_ns(fig, s)
  else: draw_close(fig, s)
  watermark(fig)
  fig.text(0.03,0.02, f't = {t:5.1f}s / {DUR:.0f}s', color='#556', fontsize=9)
  fig.savefig(OUT/f'f{i:04d}.png'); plt.close(fig)
  if i%60==0: print('frame',i, flush=True)

for i in range(NF):
  frame(i)
print('DONE', NF)
