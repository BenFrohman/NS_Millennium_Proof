# Direction of vorticity, ½-Hölder, and continuation

**Author.** Benjamin Stanley Frohman.  
**File.** `DirectionHolder_BdVB.tex` / `DirectionHolder_BdVB.pdf`  
**License.** CC-BY-4.0 on the note. No tether is used.

## What is proved

On the maximal classical interval \([0,T^*)\) of the unmodified 3D Navier–Stokes system (1)–(2), \(\nu>0\):

if the vorticity direction \(\xi=\omega/|\omega|\) is uniformly \(1/2\)-Hölder on the set where \(|\omega|\ge\Omega\), then \(T^*=\infty\) and \(u\) remains smooth.

The two constants of the criterion, displayed in the note, are
\[
\Omega=\Omega(u_0,\nu)>0,\qquad C=C(u_0,\nu)<\infty.
\]
The derived majorant coefficient is \(K(C,\Omega,\nu)=C_\ast(C+\Omega)^2/\nu\).

Degeneracy is respected: \(\xi\) is undefined on \(\{\omega=0\}\) and is never used there.

## What is not proved

This does **not** solve the Clay problem. The two constants \(\Omega\) and \(C\) are **hypotheses**. Constructing them from the PDE for arbitrary smooth divergence-free \(u_0\) would finish Clay via this implication. That construction is not done here.

The implication itself is the Constantin–Fefferman / Beirão da Veiga–Berselli geometric criterion (Lipschitz in 1993; \(1/2\)-Hölder in 2002).

## Build

```
tectonic -X compile DirectionHolder_BdVB.tex
```
