# Lie–Poisson Jacobi identity on the regular dual of sdiff(T^3) — every cancellation shown

Author: Frohman, Benjamin Stanley · ORCID 0009-0006-7068-3718 · frohmanbenjamin@gmail.com
Status: expository note, unpublished, not peer reviewed. Classical theorem (Arnold 1966; Marsden–Weinstein 1983) re-derived; no new result; no PDE/Clay claim.

## Contents
- `lie_poisson_jacobi.tex` / `.pdf` — the note (13 pages).
- `scripts/sympy_identities.py` → `outputs/sympy_identities.txt` — symbolic checks (generic fields; exact trig fields; counterexample to the draft's step; Euler sign; so(3)*, sl(2,R)* Jacobi for arbitrary F,G,H). ~3–4 min.
- `scripts/torus_fft_check.py` → `outputs/torus_fft_check.txt` — exact-quadrature (48^3 grid, trig polynomials, no bracket truncation) checks of the formula for δ{G,H}/δm (vs finite differences) and of the Jacobi identity incl. the six Hessian terms. ~10 s.
- `lean/LiePoissonJacobiCore.lean` → `outputs/lean_core_output.txt` — Lean 4/mathlib proof of ONLY the final algebraic cancellation (Steps 4–5). Axioms: [propext, Quot.sound]. Lean v4.30.0-rc1, mathlib 0c154d67103f74be3a0f2c509f72ccbf5be9f2a7.
- `outputs/sympy_fields.txt` — the explicit fields of the counterexample.

## Key formula
δ{G,H}_+/δm = [g,h] + Hess_G(m)(K_h m) − Hess_H(m)(K_g m),  K_w m = P(w × curl m),  [v,w] = (w·∇)v − (v·∇)w.
The six Hessian terms in the cyclic sum cancel in pairs by symmetry of second derivatives; the rest is ⟨m, vector-field Jacobiator⟩ = 0.

## Reproduce
    python3 scripts/sympy_identities.py
    python3 scripts/torus_fft_check.py
    (cd <lake project on v4.30.0-rc1 + that mathlib> && lake env lean /path/lean/LiePoissonJacobiCore.lean)
    tectonic lie_poisson_jacobi.tex

Not formalized in Lean: everything analytic (torus, Leray projection, functional class, derivative of the bracket).
Not covered: any symmetric/metriplectic "tether" term; Fourier/Galerkin models; rough phase spaces.
