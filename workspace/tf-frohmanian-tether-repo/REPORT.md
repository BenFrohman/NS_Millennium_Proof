# TF / Frohmanian Tether: definitions, tests, and vorticity-direction alignment

Benjamin Stanley Frohman. Prepared 17 November 2026, America/Chicago (CST, UTC−6).
Local only. Nothing was pushed, merged, staged, or published. Originals were not deleted.

This report uses textbook letters and the symbols written in the cited sources.
It does not treat distinct quantities as interchangeable.

## 1. There is no single definition of TF

The name **TF** appears as the Frohmanian Symplectic Tether in the May 21 2026
note `vFinal.txt` (Drive, sha256
`d5b6508eca165379bebd46185557cef5fc7864a94a8bc39d73aec142361e6c05`).
The May 14 papers and `Full_Living_May24.md` write the same object as
\(\mathfrak{T}_F\). These writings do not agree with one another, and they
do not agree with the later kernel \(\mathcal{K}_{\mathrm{FT}}\) that uses
\(P_{\delta C}^\perp\).

### Candidate 1. May 3, `main3_May03.tex`
sha256 `2f971411966a08c0d02d35297096cee26c5f15342ab1495edbbb6e16a09e7aac`.

\(\mathfrak{T}_F\) is hypothesized as a (possibly multisymplectic) 2-form
inducing a Poisson bracket with
\[
\frac{dF}{dt}=\{F,H\}_{\mathfrak{T}_F},\qquad H=\frac12\int|u|^2\,dV,
\]
and a “Tether Bounding Inequality”
\[
\frac{d}{dt}\|\omega\|_{L^\infty}\le C-\kappa\|\omega\|_{L^\infty}^2.
\]
No integral formula for \(\mathfrak{T}_F\) is given.

### Candidate 2. May 14 construction (recovered Drive tex)
`Frohmanian_Symplectic_Tether_Theorem_Proof_Clean_v1.tex`, sha256
`98717d941535df4d96d9fa18b6367c3de6350212a112ab09458c0a47bea026ff`
(the copy previously stored under
`/workspace/two-layer-t3-test-2026-11-16/sources/drive/` is corrupted:
its line 41 is a tool-truncation marker, not the original text).
The same formulas appear in `Frohmanian_Tether_Theorem_Final_Submission_Ready.tex`,
sha256 `09ef57aca2448b8a4858c1203e94b3b98ad452bb156a53aa2e03d82fef182a19`.
The tex `\date` line says April 2026; the Drive `modifiedTime` is 14 May 2026.

Verbatim:
> To tame the stretching while preserving the exact reversible vector field,
> introduce the minimal quadratic metric correction
> \[
> B(F,G)=-\kappa\int|\omega|^2\Bigl(\frac{\delta F}{\delta\omega}\cdot\frac{\delta G}{\delta\omega}\Bigr)\,dV.
> \]
> The full bracket is
> \[
> \{F,G\}_{\mathfrak{T}_F}=\{F,G\}_{\mathrm{classical}}+B(F,G).
> \]
> The associated 2-form is
> \[
> \mathfrak{T}_F(\delta\mathbf{u},\delta\mathbf{v})=\int\omega\cdot(\delta\mathbf{u}\times\delta\mathbf{v})\,dV-\kappa\int|\omega|^2(\delta\mathbf{u}\cdot\delta\mathbf{v})\,dV.
> \]

The displayed \(B(F,G)\) and the displayed 2-form have **no** \(\Pi_u\).
The next subsection claims degeneracy “by construction using the \(L^2\)-orthogonal
projection,” which is not present in these two displayed formulas.

The abstract calls \(\mathfrak{T}_F\) a “bilinear antisymmetric 2-form.”
The second summand of the displayed 2-form is symmetric, so the displayed
2-form is not antisymmetric (Lean: `TF_not_antisymmetric`).

### Candidate 3. May 21 `vFinal.txt` / May 24 `Full_Living_May24.md`
`Full_Living_May24.md` sha256
`384270d1e4411d4546b569f963068b7d30f0dd60f51138e2e26f09629749c824`.
Date in `vFinal.txt`: May 21, 2026. This is the source that writes the name **TF**.

Verbatim from `vFinal.txt` §5:
> \(B(F,G)=-\kappa\iint_{T^3\times T^3}|\omega(x)|^2 K_{\mathrm{BS}}(x-y)\,
> \bigl(\Pi_u(\delta F/\delta\omega)(x)\bigr)\cdot\bigl(\Pi_u(\delta G/\delta\omega)(y)\bigr)\,dy\,dx\),
> where \(K_{\mathrm{BS}}\) is the Biot–Savart kernel, \(\Pi_u\) is the \(L^2\)-orthogonal
> projection onto the complement of \(\mathrm{span}\{u\}\) (with \(u=\delta H/\delta\omega\)),
> and \(\kappa=C_{\mathrm{CZ}}(3)\).
> The full tethered bracket is
> \(\{F,G\}_{\mathrm{TF}}=\{F,G\}_{\mathrm{classical}}+B(F,G)\).
> The associated 2-form is
> \(\mathrm{TF}(\delta u,\delta v)=\int_{T^3}\omega\cdot(\delta u\times\delta v)\,d\lambda
> -\kappa\int_{T^3}|\omega|^2(\delta u\cdot\delta v)\,d\lambda\).
> Degeneracy: \(\Pi_u(u)=0\), hence \(B(F,H)\equiv 0\), hence
> \(\{F,H\}_{\mathrm{TF}}=\{F,H\}_{\mathrm{classical}}\).

The kernel \(B\) (Biot–Savart, with \(\Pi_u\)) and the associated 2-form
(local, **without** \(\Pi_u\)) are **not the same bilinear form**.
`Tether_May31.lean` (sha256
`80df3079b0cf5e75801eacbf4285991b8a90b436be3e160ee9735ca3e8367185`)
restores both formulas side by side as `TetherKernel` and `TetherTwoForm`.

### Candidate 4. May 21 `Geometric_Reconstruction.md`, “final form”
sha256 `21f6c1f51f81e80abfdaadddd8de12e29a539f54e715b5b2fdf15f3193cbdb35`.
Date of creation: 2026-05-21.

\[
B(F,G)=-C_{\mathrm{CZ}}(3)\int_{T^3}|\omega|^2\Bigl(\Pi_u\frac{\delta F}{\delta\omega}\cdot\Pi_u\frac{\delta G}{\delta\omega}\Bigr)\,d\lambda.
\]
This is the local projected kernel later written \(B_F\) in
`ns-proof-written.tex` (sha256
`72b18b9787ed69458d86cf4e558092e5127d898b9f1a0b43dde7868d255fbfcf`).

### Candidate 5. October uniqueness paper, \(\{F,G\}_{\mathrm{FT}}\)
`Frohmanian_Symplectic_Tether_Uniqueness_and_Global_Regularity_2026.tex`,
sha256 `400889e100ea8e14ddd1d523a2c7731a26caa2eb6306dc381f925b25c4e7ae49`,
status paragraph dated 2026-10-30.

\[
\mathcal{K}_{\mathrm{FT}}(v,w;\omega)=\int_{T^3}\|\omega(x)\|^2\bigl\langle P_{\delta C}^\perp v(x),P_{\delta C}^\perp w(x)\bigr\rangle\,dx,
\]
\[
\{F,G\}_{\mathrm{FT}}(\omega)=\{F,G\}_{\mathrm{LP}}(\omega)-\kappa(\nu)\,\mathcal{K}_{\mathrm{FT}}(\delta F,\delta G;\omega),
\]
with
\[
P_{\delta C}^\perp(v)(x)=v(x)-\frac{\langle v(x),\omega(x)\rangle}{\|\omega(x)\|^2}\omega(x)
\]
(\(P_{\delta C}^\perp(v)(x)=v(x)\) if \(\omega(x)=0\)). This projection is
orthogonal to \(\omega\) (the Casimir direction), **not** to \(u\).

The five candidates are not the same object.

## 2. Tests of each candidate

Domain of the exact integrals and the numerical scan: \((\mathbb{R}/2\pi\mathbb{Z})^3\).
Fields, with amplitude \(A\):

- \(u=A\cdot U\), \(U=3(-\sin y,\sin x,0)+(-\sin x\cos z,0,\cos x\sin z)\)
- Taylor–Green: \(A(\sin x\cos y\cos z,-\cos x\sin y\cos z,0)\)
- \(\mathrm{ABC}(1,1,1)\): \(A(\sin z+\cos y,\sin x+\cos z,\sin y+\cos x)\)
- shear: \(A(\sin y,0,0)\)

Logs: `sympy/tf_checks.log`, `sympy/direction_check.log`.

### (a) Well-defined on \(T^3\)

The local formulas are well-defined for smooth fields. The Biot–Savart double
integral is well-defined on the mean-zero, divergence-free subspace. The
displayed associated 2-form is a bilinear form on \(\mathbb{R}^3\)-valued
fields, but it is not antisymmetric (see Lean). The May 3 description is
not an integral formula.

### (b) Does the correction vanish on the kinetic-energy Hamiltonian \(H\)?

- Projected kernels with \(\delta H=u\) and \(\Pi_u u=0\): yes,
  \(B(F,H)\equiv 0\), so \(\{F,H\}_{\mathrm{TF}}=\{F,H\}_{\mathrm{classical}}\).
  Lean: `Pi_u_self`, `Pi_u_tether_contribution_along_H`.
- Displayed 2-form / unprojected \(B\) of May 14, second integrand
  \(|\omega|^2(\delta F\cdot u)\): not identically zero.
  Lean: `omega_sq_dot_not_degenerate_on_u`.
  (`omega_sq_dot` is the Lean identifier for the integrand \(|\omega|^2(\delta u\cdot\delta v)\)
  of vFinal (6); that identifier is not a name in the papers.)
- \(\mathcal{K}_{\mathrm{FT}}(u,u)=\int\bigl(|\omega|^2|u|^2-(\omega\cdot u)^2\bigr)\,dx\):
  vanishes if \(u\) is collinear with \(\omega\) (or \(\omega=0\)), and not otherwise.
  Exact values at the four fields: \(1041\pi^3 A^4/2\) (\(A\cdot U\)),
  \(23\pi^3 A^4/16\) (Taylor–Green), \(0\) (\(\mathrm{ABC}(1,1,1)\), Beltrami),
  \(\pi^3 A^4\) (shear). Lean: `K_FT_vanishes_on_δC`,
  `K_FT_uu_eq_zero_of_collinear`, `K_FT_uu_not_identically_zero`.

### (c) Does it change real Navier–Stokes dynamics?

- Projected reading with \(\delta H=u\): no. The reversible part remains
  Euler, and viscosity is a separate dissipative bracket. Real Navier–Stokes
  solutions satisfy the tethered bracket dynamics only because the tether
  term is zero.
- Unprojected 2-form, used as a bracket: would change the vector field, and
  is not a Poisson 2-form (it is not antisymmetric). That modified system
  is not the Navier–Stokes equations.
- \(\mathcal{K}_{\mathrm{FT}}\) with \(\delta H=u\): changes the dynamics
  except on Beltrami fields. That modified system is not the Navier–Stokes
  equations.

Integration by parts on the unmodified vorticity equation, for a general
smooth divergence-free field on \(T^3\), leaves
\[
\frac{d}{dt}\frac12\int|\omega|^2=\int\omega\cdot S\omega-\nu\int|\nabla\omega|^2,
\]
with no remainder that is a tether kernel (pointwise identity checked in
`sympy/tf_checks.py`; same identity as in the 16 November two-layer check).

At \(t=0\) for all four fields, \(\int\omega\cdot S\omega=0\), and
\[
\frac{d}{dt}\frac12\int|\omega|^2=-\nu\int|\nabla\omega|^2
\]
equals \(-88\pi^3 A^2\nu\), \(-18\pi^3 A^2\nu\), \(-24\pi^3 A^2\nu\),
\(-4\pi^3 A^2\nu\) respectively. No cubic sink appears in this balance.

### (d) A term \(-\kappa''\|\omega\|_{L^\infty}^3\) in \(\frac{d}{dt}\|\omega\|_{L^\infty}\)
for real Navier–Stokes?

No. The vorticity equation of real Navier–Stokes does not contain TF.
At a spatial maximum of \(|\omega|\),
\[
D^+\|\omega\|_{L^\infty}=\widehat{\omega}\cdot S\omega+\nu\,\widehat{\omega}\cdot\Delta\omega.
\]
On the four snapshots (amplitude \(A=1\)), a refined grid search gave
approximately \(D^+\|\omega\|_{L^\infty}\approx 5.80 A^2-6\nu A\) for
\(A\cdot U\), \(0-6\nu A\) for Taylor–Green, \(0-2.45\nu A\) for
\(\mathrm{ABC}(1,1,1)\), and \(0-\nu A\) for the shear. These are
quadratic stretching plus viscous terms, not a cubic sink produced by TF.

The May 3 inequality is \(\frac{d}{dt}\|\omega\|_{L^\infty}\le C-\kappa\|\omega\|_{L^\infty}^2\),
which is a different formula from \(C\|\omega\|_{L^\infty}^2-\kappa''\|\omega\|_{L^\infty}^3\).
Those two inequalities are not the same statement.

### (e) Published obstructions

Consistent with:

- [10.5281/zenodo.23971661](https://doi.org/10.5281/zenodo.23971661): under
  energy-null (C2) symmetry, the tether contributes nothing to the
  enstrophy balance, so no cubic enstrophy damping appears.
- [10.5281/zenodo.24120781](https://doi.org/10.5281/zenodo.24120781) and
  [10.5281/zenodo.23990195](https://doi.org/10.5281/zenodo.23990195):
  every symmetric kernel satisfying C2 has \(B(H,M)=0\) for every
  functional \(M\).
- [10.5281/zenodo.24122008](https://doi.org/10.5281/zenodo.24122008):
  the sign obstruction for using a negative-semidefinite tether as a
  metriplectic metric bracket.

The projected TF of vFinal is exactly this energy-null class, so those
obstructions apply to it. \(\mathcal{K}_{\mathrm{FT}}\) evades C2 on \(H\)
when \(u\not\parallel\omega\), by changing the equations.

**Verdict on the sink.** TF, in every writing found, does not produce a
\(-\kappa''\|\omega\|_{L^\infty}^3\) term in the real Navier–Stokes
vorticity balance. Where the kernel is degenerate on \(H\), it adds zero
to the dynamics. Where it is not, the system is not Navier–Stokes.

## 3. Vorticity-direction alignment

### What the papers and Lean already say

The alignment bound was found. It is written as an **open hypothesis**,
not as a theorem proved for every solution.

1. `NAMING.md` in `periodic-ns-classical-continuation` and
   `frohmanian-symplectic-tether-regularity` (sha256 of the latter
   `c33b92a54e3ad74bb55f7e003709725cc07dae418ce6d1ab6c73abd742d51fbe`):
   > Let \(\tau=\omega/|\omega|\) be the vorticity direction and \(S\) the strain.
   > For every smooth maximal solution on \(\mathbb{T}^3\) with finite lifespan \(T^*\):
   > (A) the bending strain \((I-\tau\otimes\tau)S\tau\) stays bounded where \(|\omega|\)
   > is large, on \([0,T^*)\);
   > (B) that bound gives a \(\tfrac12\)-Hölder vorticity direction.
   > **Both parts are open.**

   `FrohmanianTetherTheorem` is reserved and “not declared, because nothing
   is proved yet.” `FrohmanianTetherHypothesisB` is an abbreviation of
   `OrthogonalStrainToDirectionHolder`, a `Prop`, not a proved theorem.

2. Frohman, *What Is Actually Proved*, 9 September 2026, sha256
   `0c6b693c00f8e58baa778b642f7a8be41510127125be4e8d187815f1057062ad`,
   Definition (def:71):
   \[
   |\xi(x,t)-\xi(y,t)|\le C|x-y|^{1/2}
   \]
   whenever \(r(x,t),r(y,t)\ge\Omega\) and \(t\in[0,T_*)\).
   Theorem (thm:crit) is the implication: if a classical solution on
   \(T^3\) satisfies this, then \(T_*=\infty\). The paper then states:
   > The missing premise is that G holds for every smooth divergence-free
   > initial datum, with constants depending only on that datum and on \(\nu\).
   > That premise has not been proved.
   > Until an identity of shape (eq:shape) is derived from the unmodified
   > equations, Definition (def:71) remains an assumption.

3. `VortDirHolderHalf` in
   `periodic-ns-classical-continuation/PeriodicNSContinuation/TetherClaimAttack.lean`
   is the Lean form of
   \[
   \bigl\|\tau(x)-\tau(y)\bigr\|\le K\sqrt{\|x-y\|}
   \]
   when \(\|\omega(x)\|,\|\omega(y)\|\ge\Omega\). Theorems that use it take
   it as a hypothesis (for example `cfDepletion_le_of_holder`).
   `PeriodicDirectionCriterion` is also recorded as a hypothesis.

Nothing found in the searched Drive files, GitHub repos, or the listed
Zenodo-linked papers proves
\[
|\sin\theta(x,y,t)|\le C|x-y|^{1/2}
\]
(or the Lipschitz form, or Definition (def:71)) **unconditionally for every
smooth divergence-free initial datum**. The implication “alignment \(\Rightarrow\)
smoothness” is the classical criterion; the missing step is the alignment
itself.

\(|\sin\theta|\) and \(|\tau(x)-\tau(y)|\) (written \(\xi\) in the September
paper) are **not the same quantity**. If \(\theta=\pi\), then \(\sin\theta=0\)
while \(|\tau(x)-\tau(y)|=2\). Constantin–Fefferman (1993) and Beirão da Veiga–
Berselli (2002) write \(|\sin\theta|\). Definition (def:71) writes
\(|\xi(x,t)-\xi(y,t)|\). Lean records this distinction
(`antiparallel_direction_gap` in `Direction.lean`).

### Test from the papers’ TF, and a numerical scan

Because the projected TF of vFinal satisfies \(B(F,H)\equiv 0\), it does not
add a term to the Navier–Stokes vorticity equation. There is therefore no
tether increment from which a bound on \(|\sin\theta|\) can be derived for
real Navier–Stokes solutions. The direction field “with the tether term”
and “without the tether term” **coincide** on real Navier–Stokes solutions.

A grid scan at \(t=0\), \(A=1\), on the set \(|\omega|\ge\tfrac12\max|\omega|\),
with periodic distance on \((\mathbb{R}/2\pi\mathbb{Z})^3\), gave finite
ratios (expected for a \(C^\infty\) snapshot with \(|\omega|\) bounded away
from zero):

| field | \(\max|\omega|\) | \(\max\dfrac{|\sin\theta|}{|x-y|^{1/2}}\) | \(\max\dfrac{|\sin\theta|}{|x-y|}\) | \(\max\dfrac{|\tau(x)-\tau(y)|}{|x-y|^{1/2}}\) |
|---|---|---|---|---|
| \(A\cdot U\) | 6 | 0.761 | 0.615 | 1.482 |
| Taylor–Green | 2 | 0.735 | 0.800 | 1.651 |
| \(\mathrm{ABC}(1,1,1)\) | 2.446 | 0.901 | 0.984 | 1.353 |
| shear | 1 | 0 | 0 | 1.928 |

On the shear, \(\sin\theta=0\) at every high pair (directions are parallel or
anti-parallel), while \(|\tau(x)-\tau(y)|\) attains 2. A finite ratio on a
single smooth snapshot is not a uniform-in-time bound, with \(C\) depending
only on \(u_0\) and \(\nu\), for every solution. That last statement was
not proved, and the author’s September 2026 note already records it as
unproved.

**Status of the Beirão da Veiga–Berselli / Constantin–Fefferman hypothesis
as a consequence of TF:** not proved. It is not derived from the projected
TF, because that kernel vanishes on \(H\). It is not kernel-proved
unconditionally for all solutions in the existing Lean. It remains the
open Frohmanian Tether Hypothesis (B).

## 4. Lean

Directory: `/workspace/tf-frohmanian-tether-2026-11-16/`.
Toolchain and `lake-manifest.json` are byte-for-byte copies of
`frohmanian-symplectic-tether-regularity`
(toolchain sha256 `1098ca8368e0db12138f33b070187e1f6527984ae0451a587b20e3e661f96a76`,
manifest sha256 `b81d814b7d2d2d2821b03ed679324d5e7ec7da674e0a977352d01c88cbe8ccb8`).
Lean 4.30.0-rc1, Mathlib `0c154d67103f74be3a0f2c509f72ccbf5be9f2a7`.
Mathlib oleans were reused from
`/workspace/certify/frohmanian-tether-sdiff/.lake/packages`; Mathlib was not
downloaded. Header, copyright, and author line are on every Lean file.
No `sorry` in the sources (the only occurrence is the comment “No sorry”).

Kernel-produced oleans, 17 November 2026, America/Chicago:

- `TFFrohmanianTether/Basic.olean`, 00:11 CST
- `TFFrohmanianTether/Semantics.olean`, 00:13 CST

`Direction.lean` is sorry-free source; a subsequent full `lake build` of
`Direction.lean` and `AxiomAudit.lean` had not finished when this report
was written, because the box was already running several other `lake build`
processes. The theorems in `Basic.lean` and `Semantics.lean` were compiled
by the Lean 4.30.0-rc1 kernel.

`paper_claim` is the statement that the displayed 2-form density of vFinal (6)
is antisymmetric for every \(\kappa,\omega,\delta u,\delta v\). That claim is
refuted (`TF_not_antisymmetric`, `paper_claim_refuted`). Author approval of
the transcription remains PENDING. Nothing was published.

Rebuild, once the box is quiet: from this directory, `lake build`, with the
existing `.lake/packages` symlinks and without `--update`.
