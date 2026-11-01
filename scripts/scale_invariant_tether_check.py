"""Scale-invariant variants of the Frohmanian tether rate: dimensional + numerical checks.

Sibling of hweight_plausibility_check.py. Evidence only, not proof.
Pointwise variants are tested at x* = argmax |w| on a periodic spectral grid, kinematically
(any smooth divergence-free field is admissible initial data, so the claimed inequality must
hold at t = 0). Notation: M=|w(x*)|, s=<w,Sw>(x*) (stretching), C=|grad u(x*)|_op / M,
E=int|u|^2, Om=int|w|^2, P=int|grad w|^2, U=max|u|, nu = viscosity.
Run: python3 scripts/scale_invariant_tether_check.py
"""
import numpy as np

KAPPA = 1.5  # C_CZ(3) = 3/2, the repository's kappa

def grid(N, L):
    h = L / N
    x = np.arange(N) * h - L / 2
    X, Y, Z = np.meshgrid(x, x, x, indexing="ij")
    return X, Y, Z, h

class Spectral:
    def __init__(self, N, h):
        k = 2 * np.pi * np.fft.fftfreq(N, h)
        self.K = np.meshgrid(k, k, k, indexing="ij")
        K2 = sum(c**2 for c in self.K); K2[0, 0, 0] = 1.0
        self.K2 = K2; self.h = h
    def d(self, f, a):
        return np.real(np.fft.ifftn(1j * self.K[a] * np.fft.fftn(f)))
    def proj(self, v):
        vh = [np.fft.fftn(c) for c in v]
        dv = sum(self.K[a] * vh[a] for a in range(3)) / self.K2
        return [np.real(np.fft.ifftn(vh[a] - self.K[a] * dv)) for a in range(3)]
    def curl(self, u):
        d = self.d
        return [d(u[2], 1) - d(u[1], 2), d(u[0], 2) - d(u[2], 0), d(u[1], 0) - d(u[0], 1)]
    def biot_savart(self, w):
        psi = [np.real(np.fft.ifftn(np.fft.fftn(c) / self.K2)) for c in w]
        return self.curl(psi)

def quantities(u, sp, nu):
    """All quantities for a velocity field u (list of 3 arrays) on spectral grid sp."""
    h3 = sp.h**3
    w = sp.curl(u)
    nw = np.sqrt(sum(c**2 for c in w))
    i = np.unravel_index(nw.argmax(), nw.shape)
    M = nw[i]
    G = np.array([[sp.d(u[a], b)[i] for b in range(3)] for a in range(3)])
    wp = np.array([c[i] for c in w])
    s = wp @ G @ wp
    C = np.linalg.norm(G, 2) / M
    E = sum((c**2).sum() for c in u) * h3
    Om = (nw**2).sum() * h3
    P = sum((sp.d(w[a], b)**2).sum() for a in range(3) for b in range(3)) * h3
    U = np.sqrt(sum(c**2 for c in u)).max()
    S_int = sum((w[a] * sum(w[b] * sp.d(u[a], b) for b in range(3))).sum() for a in range(3)) * h3
    # direction field xi = w/|w| and its gradient near x* (ball of radius ell)
    xi = [c / (nw + 1e-300) for c in w]
    gxi = np.sqrt(sum(sp.d(xi[a], b)**2 for a in range(3) for b in range(3)))
    ell = (Om / M**2) ** (1 / 3)
    N = nw.shape[0]
    idx = np.indices(nw.shape)
    dist = np.sqrt(sum(((idx[a] - i[a] + N // 2) % N - N // 2)**2 for a in range(3))) * sp.h
    ball = (dist <= max(ell, 2 * sp.h)) & (nw > 0.5 * M)   # where xi is well defined
    gxi_ball = gxi[ball].max()
    return dict(M=M, s=s, C=C, E=E, Om=Om, P=P, U=U, S_int=S_int, gxi=gxi_ball, ell=ell, nu=nu)

def variants(q):
    """Return {name: (lhs, rhs_with_unit_kappa_pieces)}; inequality is lhs <= rhs."""
    M, s, C, E, Om, P, U, nu = (q[k] for k in ("M", "s", "C", "E", "Om", "P", "U", "nu"))
    ReE = np.sqrt(M) * E / nu**2.5            # dimensionless, amplitude degree 5/2
    g = ReE / (1 + ReE)
    out = {
        "V0 original: s <= C M^3 - kappa M^4": (s, C * M**3 - KAPPA * M**4),
        "V1 viscous: s <= C M^3 - kappa nu M^4/U^2": (s, C * M**3 - KAPPA * nu * M**4 / U**2),
        "V2+ energy: s <= C M^3 - kappa M^3 Re_E": (s, C * M**3 - KAPPA * M**3 * ReE),
        "V2- energy: s <= C M^3 - kappa M^3 / Re_E": (s, C * M**3 - KAPPA * M**3 / ReE),
        "V3 bounded: s <= C M^3 (1 - k3 g(Re_E))": None,  # report k3* instead
        "V4 direction: s <= K M^3 ell |grad xi|": None,   # report K*
        "V5 integrated: int wSw <= K Om^3/4 P^3/4": None,  # report K*
    }
    sigma = s / (C * M**3)
    k3 = (1 - sigma) / g if g > 0 else np.inf
    K4 = s / (M**3 * q["ell"] * q["gxi"]) if q["gxi"] > 1e-12 else (np.inf if s > 1e-12 else 0.0)
    K5 = q["S_int"] / (Om**0.75 * P**0.75)
    return out, dict(sigma=sigma, k3=k3, K4=K4, K5=K5)

# ---------------- test fields (velocity), all made divergence-free spectrally ----------------
def fields():
    F = {}
    # localized fields on [-4,4)^3 (decay => periodic extension harmless)
    X, Y, Z, h = grid(48, 8.0)
    R2 = X**2 + Y**2
    sw = np.exp(-Z**2 / 4)
    # Lamb-Oseen swirl u_theta = (1-e^{-r^2})/r, cut off in z
    fac = (1 - np.exp(-R2)) / (R2 + 1e-12)
    F["Lamb-Oseen tube"] = (h, [-Y * fac * sw, X * fac * sw, 0 * X])
    # Burgers vortex: same swirl + axisymmetric strain (-a x/2,-a y/2,a z), strain localized
    a = 1.0; loc = np.exp(-(R2 + Z**2) / 6)
    F["Burgers vortex (localized strain)"] = (h, [(-Y * fac - a * X / 2) * loc, (X * fac - a * Y / 2) * loc, a * Z * loc])
    # shear layer u = (tanh(y)) localized
    F["shear layer"] = (h, [np.tanh(Y) * np.exp(-(X**2 + Z**2) / 8) * np.exp(-Y**2 / 16), 0 * X, 0 * X])
    # periodic fields on [0,2pi)^3
    X, Y, Z, h = grid(32, 2 * np.pi)
    F["Taylor-Green"] = (h, [np.sin(X) * np.cos(Y) * np.cos(Z), -np.cos(X) * np.sin(Y) * np.cos(Z), 0 * X])
    F["ABC (A=B=C=1)"] = (h, [np.sin(Z) + np.cos(Y), np.sin(X) + np.cos(Z), np.sin(Y) + np.cos(X)])
    rng = np.random.default_rng(20261022)
    sp = Spectral(32, h)
    kk = np.sqrt(sp.K2)
    for seed in range(3):
        amp = kk**(-11 / 6) * np.exp(-(kk / 6)**2)     # Kolmogorov-like, smooth cutoff
        v = [np.real(np.fft.ifftn(amp * np.fft.fftn(rng.standard_normal(kk.shape)))) for _ in range(3)]
        F[f"random spectral #{seed}"] = (h, v)
    return F

def main():
    print("Scaling exponents under u_l(x)=l u(l x) (w_l=l^2 w), nu fixed, measured numerically:")
    amps = [1e-2, 1e-1, 1, 10, 100]
    nus = [1e-2, 1.0]
    results = {}
    for name, (h, u) in fields().items():
        N = u[0].shape[0]
        sp = Spectral(N, h)
        u = sp.proj(u)
        base = quantities(u, sp, 1.0)
        u = [c / base["U"] for c in u]  # normalize max|u|=1
        # numerical scaling check (lambda = 2): same samples, spacing h/2, values *2
        lam = 2.0
        q1 = quantities(u, sp, 1.0)
        sp2 = Spectral(N, h / lam)
        q2 = quantities([lam * c for c in u], sp2, 1.0)
        if name == "Taylor-Green":
            for key in ("M", "s", "E", "Om", "P", "S_int"):
                print(f"   {key:6s} exponent {np.log(abs(q2[key]) / abs(q1[key])) / np.log(lam):+.2f}")
        for nu in nus:
            for A in amps:
                q = quantities([A * c for c in u], sp, nu)
                ineq, extra = variants(q)
                for v, val in ineq.items():
                    r = results.setdefault(name, {}).setdefault(v, {"fail": [], "n": 0, "extra": []})
                    r["n"] += 1
                    if val is not None and val[0] > val[1] + 1e-12 * max(1, abs(val[1])):
                        r["fail"].append((A, nu))
                    r["extra"].append(extra)
    print()
    print("field | variant | failures (A, nu) of", len(amps) * len(nus), "| notes")
    for name, rv in results.items():
        for v, r in rv.items():
            ex = r["extra"]
            if v.startswith("V3"):
                note = f"sigma=s/(CM^3)={ex[0]['sigma']:.3f}; largest admissible k3 = {min(e['k3'] for e in ex):.3g}"
                print(f"{name} | {v} | n/a | {note}")
            elif v.startswith("V4"):
                print(f"{name} | {v} | n/a | needed K >= {max(e['K4'] for e in ex):.3g}")
            elif v.startswith("V5"):
                print(f"{name} | {v} | n/a | needed K >= {max(e['K5'] for e in ex):.3g}")
            else:
                f = r["fail"]
                print(f"{name} | {v} | {len(f)} | e.g. {f[:2]}")

def burgers_exact():
    """Exact Burgers vortex on its axis: grad u = rotation(M/2) + diag(-a/2,-a/2,a).
    Direction xi = e_z is constant (|grad xi| = 0) while s = a M^2 > 0."""
    print()
    print("Exact Burgers vortex at the axis (analytic, unbounded strain field):")
    print("a/M | sigma=s/(C M^3) | largest admissible k3 for V3 | V4 needs K >=")
    for r in [0.1, 1, 10, 100, 1000]:
        M = 1.0; a = r * M
        G = np.array([[-a / 2, -M / 2, 0], [M / 2, -a / 2, 0], [0, 0, a]])
        C = np.linalg.norm(G, 2) / M
        s = a * M**2
        sigma = s / (C * M**3)
        print(f"{r:g} | {sigma:.4f} | {1 - sigma:.4f} (g<=1) | inf (grad xi = 0, s > 0)")

if __name__ == "__main__":
    main()
    burgers_exact()
