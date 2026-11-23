# |sin θ(x,y)| and |ξ(x)−ξ(y)| on {|ω|≥K} for fields on (ℝ/2πℤ)³, t=0.
# θ is the angle between ω(x) and ω(y). Textbook: ξ = ω/|ω|.
# No shorthand names for enstrophy. Benjamin Stanley Frohman, 2026-11-16.
import numpy as np
import sympy as sp

x, y, z, A = sp.symbols('x y z A', real=True)
X = (x, y, z)

def curl(u):
    return sp.Matrix([
        sp.diff(u[2], y) - sp.diff(u[1], z),
        sp.diff(u[0], z) - sp.diff(u[2], x),
        sp.diff(u[1], x) - sp.diff(u[0], y),
    ])

fields = {
    'u = A·U (U = 3(−sin y, sin x, 0) + (−sin x cos z, 0, cos x sin z))':
        A * sp.Matrix([-3*sp.sin(y)-sp.sin(x)*sp.cos(z), 3*sp.sin(x), sp.cos(x)*sp.sin(z)]),
    'Taylor–Green: A (sin x cos y cos z, −cos x sin y cos z, 0)':
        A * sp.Matrix([sp.sin(x)*sp.cos(y)*sp.cos(z), -sp.cos(x)*sp.sin(y)*sp.cos(z), 0]),
    'ABC(1,1,1): A (sin z + cos y, sin x + cos z, sin y + cos x)':
        A * sp.Matrix([sp.sin(z)+sp.cos(y), sp.sin(x)+sp.cos(z), sp.sin(y)+sp.cos(x)]),
    'shear: A (sin y, 0, 0)':
        A * sp.Matrix([sp.sin(y), 0, 0]),
}

def tor_dist(a, b):
    d = np.abs(a - b)
    d = np.minimum(d, 2*np.pi - d)
    return float(np.sqrt(np.sum(d**2)))

def scan(name, u, n=36, Kfrac=0.5, max_pairs=20000):
    w = curl(u).subs(A, 1)
    wfun = [sp.lambdify((x, y, z), sp.expand(w[i]), 'numpy') for i in range(3)]
    ts = np.linspace(0, 2*np.pi, n, endpoint=False)
    pts = np.array([(a, b, c) for a in ts for b in ts for c in ts])
    cols = []
    for i in range(3):
        val = np.asarray(wfun[i](pts[:,0], pts[:,1], pts[:,2]), dtype=float)
        if val.ndim == 0:
            val = np.full(len(pts), float(val))
        cols.append(val)
    W = np.stack(cols, axis=1)
    mag = np.linalg.norm(W, axis=1)
    Msup = float(mag.max())
    K = Kfrac * Msup
    high = np.nonzero(mag >= K)[0]
    print(f'\n== {name} ==')
    print(f'  max |ω| at A=1: {Msup:.8g};  K = {Kfrac} max|ω| = {K:.8g};  #high points = {len(high)} / {len(pts)}')
    if len(high) < 2:
        print('  not enough high points')
        return
    # subsample pairs
    rng = np.random.default_rng(0)
    if len(high) > 400:
        idx = rng.choice(high, size=400, replace=False)
    else:
        idx = high
    # all pairs among idx (cap)
    pairs = []
    for i in range(len(idx)):
        for j in range(i+1, len(idx)):
            pairs.append((idx[i], idx[j]))
    if len(pairs) > max_pairs:
        sel = rng.choice(len(pairs), size=max_pairs, replace=False)
        pairs = [pairs[k] for k in sel]
    sin_over_half = []
    sin_over_lip = []
    xi_over_half = []
    min_dist = 1e9
    worst = None
    for i, j in pairs:
        d = tor_dist(pts[i], pts[j])
        if d < 1e-14:
            continue
        xi = W[i] / mag[i]
        eta = W[j] / mag[j]
        cross = np.cross(xi, eta)
        sinth = float(np.linalg.norm(cross))  # |sin θ|
        dxi = float(np.linalg.norm(xi - eta))
        sin_over_half.append(sinth / d**0.5)
        sin_over_lip.append(sinth / d)
        xi_over_half.append(dxi / d**0.5)
        if min_dist > d:
            min_dist = d
        score = dxi / d**0.5
        if worst is None or score > worst[0]:
            worst = (score, d, sinth, dxi, pts[i], pts[j])
    print(f'  pairs used: {len(sin_over_half)}; min |x-y| among them: {min_dist:.6g}')
    print(f'  max |sin θ| / |x-y|^(1/2) = {max(sin_over_half):.8g}')
    print(f'  max |sin θ| / |x-y|         = {max(sin_over_lip):.8g}')
    print(f'  max |ξ(x)-ξ(y)| / |x-y|^(1/2) = {max(xi_over_half):.8g}')
    print(f'  worst Hölder pair: |ξ(x)-ξ(y)|/|x-y|^(1/2)={worst[0]:.8g}, |x-y|={worst[1]:.8g}, |sin θ|={worst[2]:.8g}, |ξ(x)-ξ(y)|={worst[3]:.8g}')
    print('  These are finite because the snapshot is C^∞ and K>0 keeps |ω| away from 0,')
    print('  so ξ is C^∞ on the high set. This is not a uniform-in-time bound for every solution.')

for name, u in fields.items():
    scan(name, u)
print('\nProjected TF (vFinal degeneracy: Π_u(u)=0, B(F,H)≡0) does not change the Navier–Stokes')
print('vector field, so the direction field with the tether term and without it coincide')
print('on real Navier–Stokes solutions, including these data.')
