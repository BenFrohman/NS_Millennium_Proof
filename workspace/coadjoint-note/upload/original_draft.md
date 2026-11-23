<!-- Verbatim copy of Benjamin Stanley Frohman's Nov 4, 2026 draft, as sent in the Physics Visualizer chat. Not edited. -->

**Revised draft (synchronized with the Lean categories)**
---
### The Frohmanian Tether on the Coadjoint Orbit
#### 1. Categories and basic objects
- `T3` = `EuclideanSpace ℝ (Fin 3)` (model space).
- `CoadjointOrbit` : structure with fields  
  `val : T3 → EuclideanSpace ℝ (Fin 3)`  
  `property : ∀ x, NavierStokes3D.div val x = 0`.
- `SDiff` : an abstract group equipped with a `MulAction SDiff CoadjointOrbit`.
- `SDiffActionHyp SDiff` : hypothesis structure whose fields are  
  `enstrophy_invariant`, `casimir_invariant`, `transitive_on_casimir_levels`.  
  (No global axioms; every theorem that needs them takes the structure as an argument.)
- `CoadjointAction g ω := g • ω` (the `MulAction`).
- `FunctionalDerivative` : Gâteaux representative on the orbit (or 0 if none exists).
- `velocity_from_vorticity` : Biot–Savart recovery of the velocity (Fourier-side inversion proved mode-by-mode; real-space kernel still open).
#### 2. The tether kernel
```lean
TetherKernel (ω : CoadjointOrbit) (F G : Functional) : ℝ :=
  -κ * (∫ x, ‖ω.val x‖ ^ 2) *
    ∫ x, ⟪Π_u (FunctionalDerivative F ω) x,
            Π_u (FunctionalDerivative G ω) x⟫
```
- Sign: \(-\kappa\) with \(\kappa>0\).
- Weight: the global scalar \(\|\omega\|_{L^2}^2\) (overall enstrophy), not a pointwise density.
- \(\Pi_u\) = pointwise projection orthogonal to `velocity_from_vorticity ω`.
#### 3. The tethered bracket
```lean
TetheredBracket ω F G :=
  ClassicalLiePoissonBracket ω F G + TetherKernel ω F G
```
This is a **metriplectic** bracket:
- the classical summand is antisymmetric and satisfies Jacobi;
- `TetherKernel` is symmetric and negative-semidefinite;
- the sum is neither antisymmetric nor Jacobi.  
In particular `TetheredBracket ω F F ≠ 0` in general.
#### 4. Properties that hold (under the named hypotheses)
- Energy conservation: `TetherKernel ω KineticEnergyHamiltonian _ = 0` (C2) implies the tethered flow still conserves \(H\).
- Route-2 canonicity: any bilinear form that saturates the quadratic bound and polarizes to a symmetric \(Q\) depending on the derivatives only through \(\Pi_u\) coincides with `TetherKernel`. Locality is the one-line corollary of that representation. The proof uses only saturation + polarization.
- Coadjoint invariance of the kernel is conditional on `SDiffActionHyp` (enstrophy invariance + density equivariance).
#### 5. The C2/C3 obstruction (open, recorded)
Symmetry of `TetherKernel` together with C2 forces
```lean
TetherKernel ω M KineticEnergyHamiltonian = 0
```
for every functional `M`. Hence
```lean
deriv (fun t => M (ω t)) = ClassicalLiePoissonBracket ω M KineticEnergyHamiltonian
```
The tether contributes nothing. The formal cubic damping term is absent.  
(The projection gap remains as a secondary obstruction: only an upper bound on \(\int|\Pi_u\omega|^2\) is available.)
#### 6. Analytic status
The differential inequality that would feed the Riccati comparison, the tether rate, and the tether closing bound are **named open assumptions**. Any conditional regularity statement is explicitly conditional on a resolution of the C2/C3 incompatibility. No Navier–Stokes existence, uniqueness or regularity theorem is claimed.
#### 7. Open assumptions (all named, none axiomatic)
- `SDiffActionHyp.transitive_on_casimir_levels`
- `FunctionalDerivative KineticEnergyHamiltonian ω = velocity_from_vorticity ω`
- Euler equations realized as coadjoint motion (`IsCoadjointMotion`)
- the tether rate and the tether closing bound
- resolution of the C2/C3 obstruction (if a damping reading is wanted)
---
All terminology, variable names and categories above match the current Lean development (`CoadjointOrbit`, `SDiffActionHyp`, `MulAction`, `TetherKernel`, `TetheredBracket`, `FunctionalDerivative`, etc.). The geometric layer builds; the dissipative bridge does not.
