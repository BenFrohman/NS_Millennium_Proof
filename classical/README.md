# Direction of vorticity on the high set (canonical ledger)

**Author.** Benjamin Stanley Frohman.  
**File.** `DirectionHolder_BdVB.tex` / `DirectionHolder_BdVB.pdf`  
**License.** CC-BY-4.0. No tether. This note does **not** claim Clay.

Closed: \(7.1\Rightarrow T^*=\infty\); the \(\xi\)-equation with \(P_\xi\) and \(|\nabla\xi|^2\xi\); \(S\in L^2_t L^2_x\) by CZ \(2\to 2\).

False: drift \(=O(1/\Omega)\); DGNM \(\Rightarrow\) uniform \(C^{0,1/2}\) on \(E(t)\).

Not proved: Definition 7.1. Remaining Lemma B is Campanato on \(4\sin^2(\phi/2)\).

## What is proved

On the maximal classical interval \([0,T^*)\) of the unmodified 3D Navier–Stokes system (1)–(2), \(\nu>0\):

if the vorticity direction \(\xi=\omega/|\omega|\) is uniformly \(1/2\)-Hölder on the set where \(|\omega|\ge\Omega\), then \(T^*=\infty\) and \(u\) remains smooth.

The two constants of the criterion, displayed in the note, are
\[
\Omega=\Omega(u_0,\nu)>0,\qquad C=C(u_0,\nu)<\infty.
\]
The derived majorant coefficient is \(K(C,\Omega,\nu)=C_\ast(C+\Omega)^2/\nu\).

Section 10 constructs them from the unmodified PDE: \(\Omega=1\), and \(C\) is the actual running \(\tfrac12\)-Hölder modulus of \(\xi\) on \(\{r\ge 1\}\) along the classical solution. Theorem B records the test: energy does not force \(C<\infty\). Neither global smoothness nor blow-up is obtained for arbitrary data.

Degeneracy is respected: \(\xi\) is undefined on \(\{\omega=0\}\) and is never used there.

## What is not proved

This does **not** solve the Clay problem. The a priori bound on \(C\) does not close.

## Geometric implication (Section on Definition 7.1)

If Definition 7.1 holds for every smooth divergence-free \(u_0\), then \(T^*=\infty\) and \(u\) is globally smooth. That is Clay, on this route. The implication is written out with the identities that close (\(r^2\) in stretching, HLS to \(\|\omega\|_2^2\|\omega\|_6\), Gronwall from energy, Kato \(H^1\) continuation). Definition 7.1 itself is Theorem C and is not proved.

## What is left (Theorem C)

One inequality, on the unmodified NSE:

\[
\sup_{t<T^*}\;[\xi(t)]_{C^{0,1/2}(\{|\omega|\ge 1\})}<\infty,
\]
with the finite number allowed to depend only on \((u_0,\nu)\). If that holds, Theorem A gives \(T^*=\infty\). That is the whole remainder on this route. De Giorgi--Nash--Moser does not prove it: \(\xi\) is an \(S^2\)-system, \(P_\xi(S\xi)\in L^2\) is below \(p>5/2\), and interior cylinders miss \(\partial E(t)\). Either an integrability upgrade plus Chen--Struwe \(\varepsilon\)-regularity, or a direct Campanato bound on \(4\sin^2(\phi/2)\), would close it. Energy proves neither.

The implication itself is the Constantin–Fefferman / Beirão da Veiga–Berselli geometric criterion (Lipschitz in 1993; \(1/2\)-Hölder in 2002).

## Build

```
tectonic -X compile DirectionHolder_BdVB.tex
```
