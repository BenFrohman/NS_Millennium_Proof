# Exact / high-precision checks for candidate TF formulas on (R/2pi Z)^3.
# Benjamin Stanley Frohman, 2026-11-16. Local only.
import sympy as sp
import numpy as np

x, y, z, nu, A, kap = sp.symbols('x y z nu A kappa', real=True)
X = (x, y, z)
P = 2 * sp.pi

def integ(f):
    return sp.simplify(sp.integrate(sp.expand(f), (x, 0, P), (y, 0, P), (z, 0, P)))

def div(u):
    return sum(sp.diff(u[i], X[i]) for i in range(3))

def curl(u):
    return sp.Matrix([
        sp.diff(u[2], y) - sp.diff(u[1], z),
        sp.diff(u[0], z) - sp.diff(u[2], x),
        sp.diff(u[1], x) - sp.diff(u[0], y),
    ])

def lap(u):
    return sp.Matrix([sum(sp.diff(u[i], v, 2) for v in X) for i in range(3)])

def J(u):
    return sp.Matrix(3, 3, lambda i, j: sp.diff(u[i], X[j]))

def dot(a, b):
    return sum(a[i] * b[i] for i in range(3))

def vecpot(u):
    def invlap(f):
        f = sp.expand(sp.expand_trig(f))
        out = 0
        for term in sp.Add.make_args(f):
            if term == 0:
                continue
            k2 = sp.simplify(-sum(sp.diff(term, v, 2) for v in X) / term)
            out += term / k2
        return out
    psi = sp.Matrix([invlap(c) for c in u])
    return curl(psi)

fields = {
    'AU (Nov 9)': A * sp.Matrix([
        -3 * sp.sin(y) - sp.sin(x) * sp.cos(z),
        3 * sp.sin(x),
        sp.cos(x) * sp.sin(z),
    ]),
    'Taylor-Green': A * sp.Matrix([
        sp.sin(x) * sp.cos(y) * sp.cos(z),
        -sp.cos(x) * sp.sin(y) * sp.cos(z),
        0,
    ]),
    'ABC(1,1,1)': A * sp.Matrix([
        sp.sin(z) + sp.cos(y),
        sp.sin(x) + sp.cos(z),
        sp.sin(y) + sp.cos(x),
    ]),
    'shear (sin y,0,0)': A * sp.Matrix([sp.sin(y), 0, 0]),
}

print('== IBP (generic): already proved pointwise in two-layer checks.py: on T^3,')
print('   d/dt (1/2||w||^2) = INT w.Sw - nu ||grad w||^2, with no tether remainder. ==')

for name, u in fields.items():
    print('\n==', name, '==')
    w = curl(u)
    S = (J(u) + J(u).T) / 2
    Av = vecpot(u)
    assert sp.simplify(div(u)) == 0
    assert sp.simplify(curl(Av) - u) == sp.zeros(3, 1)
    ww = dot(w, w)
    uu = dot(u, u)
    E = integ(ww) / 2
    stretch = integ(dot(w, S * w))
    diss = integ(sum(dot(sp.diff(w, v), sp.diff(w, v)) for v in X))
    Ep = sp.simplify(stretch - nu * diss)
    print(' enstrophy E=1/2||w||^2 =', E)
    print(' INT w.Sw =', stretch, '; ||grad w||^2 =', diss, "; E'(0) along real NS =", Ep)

    Iu = integ(uu)
    # C2 projected B with dH = u
    print(' [projected B, dH=u] Pi_u(u)=0, so B(F,H)=0 and {F,H}_TF={F,H}_classical')

    # unprojected metric terms from displayed TF 2-form (6)
    I_uu = integ(ww * uu)          # INT |w|^2 |u|^2
    I_wu = integ(ww * dot(w, u))   # INT |w|^2 (w·u)
    I_au = integ(ww * dot(Av, u))  # INT |w|^2 (a·u)
    print(' [unprojected TF metric] INT |w|^2 |u|^2 =', I_uu)
    print('                         INT |w|^2 (w·u) =', I_wu)
    print('                         INT |w|^2 (a·u) =', I_au)

    # K_FT(u,u) = INT ( |w|^2 |u|^2 - (w·u)^2 )
    Kft_uu = integ(ww * uu - dot(w, u)**2)
    print(' [K_FT with P_w^perp] K_FT(u,u)=INT(|w|^2|u|^2-(w·u)^2) =', Kft_uu)
    print('                      K_FT(w,u)=0 identically (P_w^perp w = 0)')

    # numerical M = ||w||_inf and stretching / viscous at a near-max point
    # substitute A=1 for the shape; M scales as |A|
    wA = w.subs(A, 1)
    SA = S.subs(A, 1)
    uA = u.subs(A, 1)
    # grid search
    n = 48
    ts = np.linspace(0, 2*np.pi, n, endpoint=False)
    grid = np.array(np.meshgrid(ts, ts, ts, indexing='ij'))
    # evaluate |w|^2 via lambdify
    w2f = sp.lambdify((x, y, z), sp.expand(dot(wA, wA)), 'numpy')
    W2 = w2f(grid[0], grid[1], grid[2])
    im = np.unravel_index(np.argmax(W2), W2.shape)
    Mshape = float(np.sqrt(W2[im]))
    pt = (float(ts[im[0]]), float(ts[im[1]]), float(ts[im[2]]))
    # refine by a small local grid
    for span, n2 in ((0.2, 41), (0.05, 41), (0.01, 41)):
        xs = np.linspace(pt[0]-span, pt[0]+span, n2)
        ys = np.linspace(pt[1]-span, pt[1]+span, n2)
        zs = np.linspace(pt[2]-span, pt[2]+span, n2)
        g2 = np.array(np.meshgrid(xs, ys, zs, indexing='ij'))
        W2b = w2f(g2[0], g2[1], g2[2])
        im2 = np.unravel_index(np.argmax(W2b), W2b.shape)
        Mshape = float(np.sqrt(W2b[im2]))
        pt = (float(xs[im2[0]]), float(ys[im2[1]]), float(zs[im2[2]]))
    # values at the approximate max, A=1
    wpt = np.array([float(wA[i].subs({x: pt[0], y: pt[1], z: pt[2]})) for i in range(3)])
    Spt = np.array([[float(SA[i, j].subs({x: pt[0], y: pt[1], z: pt[2]})) for j in range(3)] for i in range(3)])
    lapw = lap(wA)
    lpt = np.array([float(lapw[i].subs({x: pt[0], y: pt[1], z: pt[2]})) for i in range(3)])
    Mn = np.linalg.norm(wpt)
    what = wpt / Mn if Mn > 0 else wpt
    stretch_pt = float(what @ (Spt @ wpt))  # what · S w = (w·S w)/|w| = O(M^2)
    visc_pt = float(what @ lpt)             # what · Δw
    print(' approx ||w||_inf at A=1:', Mshape, ' (refined point', pt, ' |w|=', Mn, ')')
    print(' at that point, (w-hat · S w) =', stretch_pt, '; (w-hat · Lap w) =', visc_pt)
    print(' D^+ ||w||_inf along REAL NS at t=0, A=1: stretch + nu * visc  (no TF term in the PDE)')
    # For A general: M = |A| Mshape, stretch_pt scales as A^2, visc as A
    # D^+ M = stretch_pt * A^2? Wait: S scales as A, w as A, what is A-independent, so what·S w scales as A^2
    # Lap w scales as A, what·Lap w scales as A
    print(' scaling: D^+ M(A) = (%g) A^2 + nu * (%g) A   [plus grid error]' % (stretch_pt, visc_pt))

print('\n== verdict notes ==')
print('On real NS, none of the TF/B kernels is a term in the vorticity equation.')
print('The IBP identity leaves only INT w.Sw - nu||grad w||^2 in the enstrophy balance.')
print('A -k M^3 sink is therefore not produced by TF on real NS solutions.')
