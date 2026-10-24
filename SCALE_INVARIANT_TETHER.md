# Scale-invariant variants of the Frohmanian tether bound (trial, 2026-10-22)

Evidence only, not proof. Script: `scripts/scale_invariant_tether_check.py`
(output saved in `scripts/scale_invariant_tether_check.out.txt`).

## 1. Why the original bound cannot be right
NS scaling: u_λ(x,t) = λ u(λx, λ²t), ω_λ = λ² ω(λx, λ²t), ν fixed. Units: [ω] = T⁻¹, [ν] = L²T⁻¹.
At a vorticity maximum the stretching s = ⟨ω, Sω⟩ has units T⁻³, as does C M³ (C dimensionless).
The original target (V0) s ≤ C M³ − κ M⁴ adds a T⁻⁴ term: it is dimensionally inconsistent, so it
must fail at large amplitude. The numerics confirm it on every field at A ≥ 1 (and at every A for
Burgers), consistent with `HWEIGHT_OBSTRUCTION.md`.

The script also measures the exponents under λ = 2 numerically: M → λ², s → λ⁶, E = ∫|u|² → λ⁻¹,
Ω = ∫|ω|² → λ¹, P = ∫|∇ω|² → λ³, ∫ω·Sω → λ³, matching the dimensional count.

**Amplitude argument (the general obstruction).** Any damping D built from ν, M, E with
[D] = T⁻³ has the form ν^a M^b E^c with b = 3 + c/2, a = −5c/2. At t = 0, for planar fields
(s = 0 at the maximum) and for u → A u, the inequality s ≤ C M³ − D must hold for all A, and both
sides must have the same degree in A, otherwise one side wins at A → 0 or A → ∞. The only consistent
degree is 3, so D = g(dimensionless) · M³ with g bounded on the whole family. That collapses to
s ≤ (C − κ g) M³, which gives only M' ≲ M², a bound that does **not** prevent blow-up
(M' ≤ c M² allows blow-up in finite time). Closing requires control of a critical, scale-invariant
quantity, which is exactly what BKM / Prodi–Serrin / ESS / Constantin–Fefferman require.

## 2. Variants and results
Fields: Lamb–Oseen tube, Burgers vortex (localized strain proxy and the exact analytic vortex),
shear layer, Taylor–Green, ABC, and 3 random spectral divergence-free fields. Amplitudes
A ∈ {10⁻², …, 10²}, ν ∈ {10⁻², 1}; 10 cases per field.

| Variant | Dimensionally consistent | Result | Counterexample | Implies regularity if true? |
|---|---|---|---|---|
| V0 s ≤ CM³ − κM⁴ (original) | no | **fails** 6/10 on every field, 8/10 Burgers | any field at A ≥ 1, ν = 10⁻² | would (that is why it is false) |
| V1 s ≤ CM³ − κνM⁴/‖u‖∞² | yes (degree 2 in A) | **fails** 4/10 every field | small amplitude (A = 0.01, 0.1) | no (‖u‖∞ is not controlled) |
| V2+ s ≤ CM³ − κM³·Re_E, Re_E = M^{1/2}E/ν^{5/2} | yes (degree 11/2) | **fails** 8–9/10 | large Re_E (small ν or large A) | n/a |
| V2− s ≤ CM³ − κM³/Re_E | yes (degree 1/2) | **fails** 2/10 every field | small A at ν = 1 | n/a |
| V3 s ≤ CM³(1 − k g(Re_E)), g = Re_E/(1+Re_E) | yes (degree 3) | survives on test fields with k ≤ 0.47; **fails for every k > 0** on the exact Burgers vortex with strain a ≥ M (σ = s/(CM³) = 1) | exact Burgers, a/M ≥ 1 | no: gives only M' ≲ M² |
| V4 s ≤ K M³ ℓ_ω sup_B|∇ξ|, ξ = ω/|ω|, ℓ_ω = (Ω/M²)^{1/3} (local Constantin–Fefferman type) | yes | survives on test fields (K ≥ 0.099 needed); **fails** on exact Burgers (ξ ≡ e_z, s = aM² > 0, K = ∞) | exact Burgers | only with an extra a-priori bound on ℓ|∇ξ| (CF hypothesis, open) and a far-field strain term |
| V5 ∫ω·Sω ≤ K Ω^{3/4} P^{3/4} | yes | survives (K ≥ 0.003 needed); it is a classical theorem (Hölder + Sobolev) | none | no: gives enstrophy control only for small data / short time |

## 3. Verdict
No scale-invariant variant tested both survives and would imply regularity. The survivors are
either classical true bounds (V5) that only give small-data or short-time results, or bounds of
degree 3 (V3, V4) that reduce to M' ≲ M², which is compatible with finite-time blow-up unless an
extra critical quantity is controlled. The exact Burgers vortex, an explicit NS solution with
externally driven stretching, kills the pointwise variants V0, V3 (for every k > 0) and V4.

This matches Task 2 (see `ClayStatements.lean` docstring and the final report): the missing fact
is a critical a-priori bound (BKM ∫₀ᵀ‖ω‖∞ < ∞, Prodi–Serrin, ESS L∞_t L³_x or a CF direction
bound), which is equivalent in difficulty to the open problem.

## Caveats
Kinematic t = 0 tests at the maximum point only; spectral grids 48³ and 32³; localized fields are
periodized; random fields fixed seed 20261022. The localized Burgers proxy bends vortex lines, so
it gives a finite K for V4; the exact analytic Burgers vortex is the counterexample.
