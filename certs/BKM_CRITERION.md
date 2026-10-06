# Beale–Kato–Majda criterion

Date: 2026-10-06. This note corrects the statement. It does not close the proof.

## The criterion

Beale, Kato, and Majda, Comm. Math. Phys. 94 (1984), proved a continuation criterion for 3D incompressible Euler. Let ω = curl u, and let T_* be the first time a smooth solution stops being smooth. The solution continues past any T < T_* if

    ∫_0^T ||ω(t)||_L∞ dt < ∞.

A singularity at T_* forces that integral to diverge. The same criterion is used for Navier–Stokes. Viscosity does not remove it.

## What is not proved

The criterion does not say the integral is finite. That is the missing step.

`frohmanian_tether_theorem` and `global_regularity_for_NS` include the conjunct `vorticity_sup_norm (vorticity (u t)) ≥ 0`. A norm is nonnegative. That conjunct is not the Beale–Kato–Majda integral.

The integral, the stretching identification, local existence on the interval used, the Jacobi identity as used, and uniqueness of the Cauchy problem remain `sorry` in this repository. A green `lake build` does not discharge them. Replacing a `sorry` with an axiom or with `True` is not a correction.

## What a correction would be

A proof that, for every smooth divergence-free finite-energy initial datum, the Navier–Stokes solution satisfies the integral bound above. The proposed comparison y' ≤ C y^2 − κ y^3 is not that proof until it is derived from the equation.
