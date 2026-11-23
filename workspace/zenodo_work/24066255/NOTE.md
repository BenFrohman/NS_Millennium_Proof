# The two-point strain–direction pairing on unmodified Navier–Stokes expands to \( C_{\mathrm{CZ}} M(t)\,|\delta\xi|^2 \). The replacement by an \( M \)-independent \( -\gamma \) remains the regularity problem.

**Author:** Benjamin Stanley Frohman  
**Date:** 8 November 2026  

## Abstract

On unmodified 3D incompressible Navier–Stokes, after expansion of the geometric kernel via the Biot–Savart law and Calderón–Zygmund representation of the strain, the two-point pairing satisfies
\[
\delta\xi\cdot\bigl(S(x)\xi(x)-S(y)\xi(y)\bigr)=C_{\mathrm{CZ}}M(t)\,|\delta\xi|^2+R_{\mathrm{A}}+R_{\mathrm{B}}+R_{\mathrm{C}}.
\]
The leading factor is sharp on intermediate-axis alignment. Remainders (A)–(C) do not cancel it uniformly in \( M(t) \). The replacement of this factor by an \( M \)-independent \( -\gamma \) is equivalent to the regularity problem and is not performed here.

## 1. Standing objects

Let \( u \) be a classical solution of the 3D incompressible Navier–Stokes equations on \( \mathbb{R}^3 \) or \( \mathbb{T}^3 \),
\[
\partial_t u+(u\cdot\nabla)u=-\nabla p+\nu\Delta u,\qquad\nabla\cdot u=0,
\]
with vorticity \( \omega=\nabla\times u \). On \( \{\omega\neq 0\} \) write
\[
\xi=\frac{\omega}{|\omega|},\qquad M(t)=\|\omega(\cdot,t)\|_{L^\infty},\qquad S=\tfrac12\bigl(\nabla u+(\nabla u)^\top\bigr).
\]
The vorticity equation is unmodified:
\[
\partial_t\omega+(u\cdot\nabla)\omega=S\omega+\nu\Delta\omega.
\]
Fix two points \( x,y \) on a high set \( \{|\omega|\ge K\} \) and set \( \delta\xi=\xi(x)-\xi(y) \). The torus differs from \( \mathbb{R}^3 \) by a smooth periodic correction to the Biot–Savart kernel; that correction is absorbed into remainder (A) and does not change the singular structure.

## 2. Algebraic identity and kernel expansion

The two-point algebraic identity is
\[
S(x)\xi(x)-S(y)\xi(y)=S(x)\,\delta\xi+(S(x)-S(y))\xi(y),
\]
hence
\begin{equation}
\delta\xi\cdot\bigl(S(x)\xi(x)-S(y)\xi(y)\bigr)=S(x):\delta\xi\otimes\delta\xi+\delta\xi\cdot\bigl(S(x)-S(y)\bigr)\xi(y). \tag{\(\dagger\)}
\end{equation}
Because \( |\xi|=1 \), one has \( \delta\xi\perp(\xi(x)+\xi(y))/2 \), so \( \delta\xi \) is tangent to \( S^2 \) to first order.

Write \( K(r)\omega \) for the matrix kernel of the Calderón–Zygmund representation of \( S \), so \( S(x)=\mathrm{P.V.}(K*\omega)(x) \). Then both summands expand as principal-value integrals against the Biot–Savart kernel. The quadratic form \( S(x):\delta\xi\otimes\delta\xi \) is controlled by \( C_{\mathrm{CZ}}M(t)\,|\delta\xi|^2 \), and that size is attained for some orientations of \( \delta\xi \) relative to the eigenframe of \( S(x) \).

## 3. Named remainders (A)–(C) — closed

Fix a cutoff \( \rho>0 \) and split the integration in \( z \) into near (\( |z-x|\le\rho \) or \( |z-y|\le\rho \)) and far. Split \( \omega(z) \) into the high piece \( 1_{|\omega|\ge K}\omega \) and the low piece \( 1_{|\omega|<K}\omega \).

**(A) Far field.** On \( |z-x|\ge\rho \) and \( |z-y|\ge\rho \) the kernels \( K(x-z) \) and \( K(y-z) \) are smooth in \( (x,y) \). The difference \( K(x-z)-K(y-z) \) is \( O(|x-y|/|z-x|^4) \). After pairing with \( \delta\xi \) and using \( \|S\|_\infty\le C_{\mathrm{CZ}}M \),
\[
|R_{\mathrm{A}}|\le C_{\mathrm{CZ}}M(t)\,|\delta\xi|^2+C_\rho\,|\delta\xi|\,\|\omega\|_{L^1}.
\]
The \( L^1 \) term is controlled by the energy class and does not grow with \( M \). The first summand does.

**(B) Near-field kernel increment.** On the near set,
\[
\bigl|K(x-z)-K(y-z)\bigr|\le C\frac{|x-y|}{|z-x|^4}
\]
whenever \( |z-x|\gtrsim|x-y| \); the principal-value diagonal is handled as in the usual CZ theory. Pairing against \( \delta\xi\otimes\xi(y) \) and using \( |\omega(z)|\le M(t) \) produces
\[
|R_{\mathrm{B}}|\le C_{\mathrm{CZ}}M(t)\,|\delta\xi|^2+C|x-y|\bigl(|\nabla\xi(x)|+|\nabla\xi(y)|\bigr)M(t)\,|\delta\xi|.
\]
Young’s inequality moves the second piece onto \( \varepsilon(|\nabla\xi(x)|^2+|\nabla\xi(y)|^2) \) at the price of a further \( C_\varepsilon M(t)^2|x-y|^2|\delta\xi|^2 \) term, still dependent on \( M \).

**(C) Low-vorticity set.** Replacing \( |\omega(z)| \) by \( K \) on \( \{|\omega|<K\} \) gives an integral bounded by a constant built from \( K \), \( u_0 \), and \( \nu \) only. This remainder is independent of \( M(t) \).

Collecting (A)–(C) into \( (\dagger) \),
\begin{equation}
\delta\xi\cdot\bigl(S(x)\xi(x)-S(y)\xi(y)\bigr)=S(x):\delta\xi\otimes\delta\xi+R_{\mathrm{A}}+R_{\mathrm{B}}+R_{\mathrm{C}}, \tag{\(\ddagger\)}
\end{equation}
with
\[
|R_{\mathrm{A}}+R_{\mathrm{B}}|\le C_{\mathrm{CZ}}M(t)\,|\delta\xi|^2+\varepsilon\bigl(|\nabla\xi(x)|^2+|\nabla\xi(y)|^2\bigr)+C_\varepsilon M(t)^2|x-y|^2|\delta\xi|^2
\]
and \( R_{\mathrm{C}} \) independent of \( M \). The geometric factor \( D \) of Constantin has been used only inside the scalar stretching rate. It does not change the sign of \( S:\delta\xi\otimes\delta\xi \).

These bounds are closed: remainders (A)–(C) do not cancel the leading \( C_{\mathrm{CZ}}M(t)\,|\delta\xi|^2 \) term uniformly in \( M(t) \).

## 4. Intermediate-axis evaluation — sharpness

Let \( \lambda_1\ge\lambda_2\ge\lambda_3 \) be the eigenvalues of \( S(x) \), so \( \lambda_1+\lambda_2+\lambda_3=0 \) and \( \lambda_1\le C_{\mathrm{CZ}}M(t) \). Take \( \xi(x) \) along the intermediate axis \( e_2 \) and a small \( e_1 \)-tilt at \( y \),
\[
\xi(x)=(0,1,0),\qquad\xi(y)=\bigl(\beta,\sqrt{1-\beta^2},0\bigr),
\]
realized as the 1-jet of a smooth divergence-free field (linear strain plus rotation generating \( \omega=Me_2 \), plus a compactly supported divergence-free tilt of size \( O(\beta M) \) on length \( L \)). Then
\[
S(x):\delta\xi\otimes\delta\xi=\lambda_1\beta^2+O(\beta^4)=\lambda_1|\delta\xi|^2+O(|\delta\xi|^4).
\]
If \( \lambda_1>0 \), the leading term is positive. Combined with \( (\ddagger) \),
\[
\delta\xi\cdot\bigl(S(x)\xi(x)-S(y)\xi(y)\bigr)=\lambda_1|\delta\xi|^2+O(|\delta\xi|^4)+R_{\mathrm{A}}+R_{\mathrm{B}}+R_{\mathrm{C}}.
\]
For \( L \) large the gradient remainder is \( O(|\delta\xi|^2 L^{-2}) \). The constant in front of \( |\delta\xi|^2 \) that can be written without a Lipschitz hypothesis on \( \xi \) is therefore \( C_{\mathrm{CZ}}M(t) \), and it is sharp on this alignment.

(Alignment of \( \xi \) with the principal extensional axis produces a negative tangent form \( -\frac12\lambda_1|\delta\xi|^2+O(|\delta\xi|^4) \). That is a different configuration. The high set of three-dimensional flow is the intermediate-axis case.)

## 5. Explicit non-claim — closed

This note derives the expansion ending at \( C_{\mathrm{CZ}}M(t)\,|\delta\xi|^2 \), sharp on intermediate-axis alignment. Remainders (A)–(C) do not cancel it uniformly in \( M(t) \). Viscosity does not enter the left-hand side.

This note does **not** derive the inequality
\[
\delta\xi\cdot\bigl(S(x)\xi(x)-S(y)\xi(y)\bigr)\le-\gamma\,|\delta\xi|^2+\text{absorbable remainders}
\]
with \( \gamma>0 \) independent of \( M(t) \) and with no Lipschitz or Hölder assumption on \( \xi \). It does **not** discharge the Constantin–Fefferman hypothesis. It does **not** prove Definition 7.1. It does **not** prove global regularity of smooth solutions to the 3D incompressible Navier–Stokes equations.

The replacement
\[
C_{\mathrm{CZ}}M(t)\qquad\longrightarrow\qquad -\gamma
\]
remains the regularity problem.

## 6. What this note is

A signed expansion of the Biot–Savart strain increment, with remainders (A)–(C) named, and with the intermediate-axis versus max-axis signs computed. It is an honest kinematic obstruction note: the kernel is written out, the last constant is identified, and the remaining replacement is stated as the regularity problem itself.

Author takes responsibility for the claim as written.  
EOF
