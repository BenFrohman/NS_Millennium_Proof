# TF Frohmanian Tether: Lean audit of the TF kernels

Copyright (c) 2026 Benjamin Stanley Frohman
([ORCID 0009-0006-7068-3718](https://orcid.org/0009-0006-7068-3718)).
Lean code: Apache-2.0 (see `LICENSE`, `NOTICE`). Paper in `paper/`: CC-BY-4.0.
Please cite as described in `CITATION.cff`.

## What this repository is

A Lean 4 / Mathlib formalization of **exact pointwise algebraic facts** about the
densities of the "Frohmanian Symplectic Tether" (TF) kernels written in the
May 14 and May 21, 2026 notes and in the October 2026 uniqueness paper.

Notation is the textbook one: $u$ is the velocity, $\omega=\nabla\times u$
the vorticity, $\nu$ the viscosity, $\Vert \omega\Vert _{L^2}^2$ the enstrophy,
$H=\tfrac12\int\vert u\vert ^2\,dx$ the kinetic energy (so $\delta H=u$),
$\tau=\omega/\vert \omega\vert $ the vorticity direction and $\theta$ the angle between
two vorticity vectors. Each Lean statement is about vectors in
$\mathbb{R}^3$ (`Fin 3 → ℝ`) at one point; nothing is integrated over
$\mathbb{R}^3$ or $\mathbb{T}^3$.

## What is NOT proved

**This is not a regularity result.** Nothing here proves global regularity,
a blow-up criterion, or any bound for Navier–Stokes solutions. In particular,
the velocity–vorticity (Beltrami) alignment $u\parallel\omega$ and the
Constantin–Fefferman / Beirão da Veiga–Berselli direction condition
$\vert \sin\theta\vert \le C\vert x-y\vert ^{1/2}$ are **not** proved for every solution.

## What is proved (Lean names)

| Lean theorem | Statement |
|---|---|
| `TF_not_antisymmetric`, `paper_claim_refuted` | The May 14 / May 21 displayed 2-form density $\mathrm{TF}_\kappa(\omega;\delta u,\delta v)=\omega\cdot(\delta u\times\delta v)-\kappa\,\vert \omega\vert ^2(\delta u\cdot\delta v)$ is **not** antisymmetric (witness $\kappa=1,\ \omega=\delta u=\delta v=e_1$). The papers' claim that it is a bilinear antisymmetric correction is refuted. |
| `TF_not_symmetric` | It is not symmetric either (witness $\kappa=0,\ \omega=e_1,\ \delta u=e_2,\ \delta v=e_3$). |
| `intended_correspondence` | `formal_claim ↔ paper_claim`, where `paper_claim` is the literal antisymmetry claim and `formal_claim := False`; proved from the witness, not by `Iff.rfl`. |
| `Pi_u_self`, `Pi_u_pairing_with_u` | $\Pi_u u=0$ and $\langle\Pi_u\,\delta F,\Pi_u u\rangle=0$, where $\Pi_u v=v-\frac{v\cdot u}{\vert u\vert ^2}u$ ($\Pi_0=\mathrm{id}$). |
| `projected_TF_adds_nothing_along_H` (= `Pi_u_tether_contribution_along_H`) | $-\kappa\,\vert \omega\vert ^2\langle\Pi_u\,\delta F,\Pi_u u\rangle=0$: in the projected-kernel reading, with $\delta H=u$, the tether term adds **zero** along the energy direction, so it adds no term to the Navier–Stokes equations. |
| `omega_sq_dot_not_degenerate_on_u` | Without the projection, $\vert \omega\vert ^2(u\cdot u)$ need not vanish. |
| `K_FT_vanishes_on_δC`, `K_FT_vanishes_on_δC_right` | The October kernel $K_{FT}(\omega;v,w)=\vert \omega\vert ^2\langle P_\omega^\perp v,P_\omega^\perp w\rangle$ vanishes when either slot is $\omega$. |
| `K_FT_uu_eq_cross_sq` | $K_{FT}(\omega;u,u)=\vert \omega\times u\vert ^2$ (Lagrange's identity). |
| `K_FT_uu_eq_zero_of_collinear`, `K_FT_uu_eq_zero_iff` | $K_{FT}(\omega;u,u)=0$ **iff** $\omega=0$ or $u=c\,\omega$ for some real $c$: it vanishes exactly at Beltrami (velocity–vorticity) alignment $u\parallel\omega$. |
| `K_FT_uu_not_identically_zero` | It is not identically zero (witness $\omega=e_1,\ u=e_2$). |
| `K_FT_uu_nonneg` | $K_{FT}(\omega;u,u)\ge 0$. |
| `sin_theta_sq_of_parallel`, `sin_theta_sq_of_antiparallel` | $\vert \tau\times\tau\vert ^2=0$ and $\vert \tau\times(-\tau)\vert ^2=0$. |
| `antiparallel_direction_gap` | For $\tau=e_1,\ \eta=-e_1$: $\vert \tau\times\eta\vert ^2=0$ (so $\sin\theta=0$) while $\vert \tau-\eta\vert ^2=4$. Hence $\vert \sin\theta\vert $ and $\vert \tau-\eta\vert $ are different quantities and cannot be interchanged. |

The integrated statement $\int\vert \omega\times u\vert ^2\,dx=0\iff u\parallel\omega$ almost
everywhere is not formalized here; only the pointwise density is.

## Files

- `TFFrohmanianTether/Basic.lean`: dot and cross products, the TF density, $\Pi_u$, $K_{FT}$.
- `TFFrohmanianTether/Semantics.lean`: verbatim source of the antisymmetry claim, `paper_claim`, `formal_claim`, `intended_correspondence`.
- `TFFrohmanianTether/Direction.lean`: vorticity-direction facts.
- `TFFrohmanianTether/Alignment.lean`: $K_{FT}(\omega;u,u)=\vert \omega\times u\vert ^2$ and its zero set.
- `TFFrohmanianTether/AxiomAudit.lean`: `#print axioms` for every theorem above.
- `sympy/`: independent SymPy checks of the same identities (not part of the certificate).
- `paper/`: the matching paper (LaTeX and PDF).

## Build

```
lake exe cache get
lake build
lake env lean TFFrohmanianTether/AxiomAudit.lean
```

Pins: `lean-toolchain` = `leanprover/lean4:v4.30.0-rc1`; Mathlib
`0c154d67103f74be3a0f2c509f72ccbf5be9f2a7`; `lake-manifest.json` sha256
`b81d814b7d2d2d2821b03ed679324d5e7ec7da674e0a977352d01c88cbe8ccb8`.
Do not pass `--update`.

## Certificate

The official certificate is the GitHub Actions run of
`.github/workflows/lean-kernel.yml` on the exact commit, and its uploaded
artifact `lean-kernel-certificate` (environment with commit, toolchain,
Mathlib revision, elan/lake/lean versions and manifest sha256; full build log;
sorry scan; `#print axioms` output and check; kernel replay log). A pass means:
`lake build` succeeds, 0 `sorry`, and every `#print axioms` lists only
`propext`, `Classical.choice`, `Quot.sound`. Local build logs are not certificates.

CI certificate run: _to be filled in from the first green CI run._

## Author

Benjamin Stanley Frohman (B.S. Frohman), Independent Researcher, Texas, United States.
ORCID 0009-0006-7068-3718. frohmanbenjamin@gmail.com
