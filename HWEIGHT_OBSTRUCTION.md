# Obstruction: `reduced_pairing_of_unmodified_and_tether` is false as stated (2026-10-13)

## Statement
At x with ‖ω(x)‖ = M = ‖ω‖_∞, the target says ⟨ω, (ω·∇)u⟩(x) ≤ C M³ − κ M⁴, where κ = C_CZ(3) = 3/2 and C is any constant with ‖∇u(x)‖ ≤ C M.
The conclusion never mentions the tether. It is a pointwise claim about the unmodified field.
`hweight` in `tethered_stretching_of_weight` is M⁴ ≤ ∫ |ω_orb|² |Π_u δF|² dx, with
Π_u v = v − (⟨v,u⟩_{L²}/‖u‖²_{L²}) u (rank-one L² Gram–Schmidt), u = BiotSavart(ω_orb), and δF = the Gâteaux representative (or 0).
`orbit` and `testF` are free and are never tied to ωField.
That lemma bounds stretching + TetherKernel, not stretching alone, so it cannot yield the target.

## Scaling (u_λ = λu(λx, λ²t), ω_λ = λ²ω)
- stretching ⟨ω,Sω⟩: λ⁶; C M³: λ⁶ (C is scale-invariant); κ M⁴: λ⁸.
- κ is dimensionless, so C M³ − κ M⁴ is dimensionally inconsistent ([T⁻³] versus [T⁻⁴]).
- hweight with the sup-proxy δF = (ω/|ω|)η (dimensionless, fixed η): the RHS scales like λ⁴·λ⁻³ = λ¹ against λ⁸ on the left. With δE (kinetic energy), δE ∝ u, and Π_u u = 0, so the RHS is 0.
- Amplitude scaling ω → Aω (C invariant): stretching ~A², target RHS ~ −κA⁴M⁴. So the claim fails for every field once A > C/(κM).

## Counterexample
For any planar-type field (stretching ≡ 0 at the max, e.g. a vortex tube or shear layer), the claim requires 0 ≤ (C − κM)M³, which fails whenever M > C/κ. Lamb–Oseen-type tube: C ≈ 0.49, so it fails for M > 0.33. Burgers: the stretching αM² > 0 makes it fail even more strongly. Numbers are in scripts/hweight_plausibility_check.py.

## Consistency
A −κM³ term with κ fixed would give M' ≤ CM² − κ''M³, which bounds M for all smooth data, i.e. it would resolve NS regularity. It is also supercritical-inconsistent with scaling, so no estimate of this form can come from the unmodified equation.

## What would need to change
1. Use a scale-consistent damping such as −κ ν M² · (something dimensionless) or −κ‖∇ω‖²-type dissipation. A dimensionless κ times M⁴ is not admissible.
2. Tie `orbit = ω(t)` and choose a specific F. The tether only modifies a *modified* bracket's dynamics, so any damping it produces belongs to the modified equation, not the unmodified one. To claim it for NS, you must prove the tether contribution is identically present in NS, which it is not (C2 degeneracy makes it vanish on the energy).
3. Restate the open step honestly: either drop `reduced_pairing_of_unmodified_and_tether`, or mark it as known-false in STATUS.

## Resolution in this tree (trial, uncommitted)
- `reduced_pairing_of_unmodified_and_tether` and `tethered_stretching_of_weight` (with `hweight`) are removed from the build in `NS_Millennium_Proof/Modules/SymplecticTether.lean`; a doc block there records why.
- The open step is now the explicit hypothesis `FrohmanianTetherRate u₀ ν` (taken by `frohmanian_tether_theorem` as `hDI`), and the ceiling is `FrohmanianTetherBound u₀ ν` (taken by `global_regularity_for_NS` as `hRiccati`).
- Scale-invariant replacements are tested in `SCALE_INVARIANT_TETHER.md`: none that survives the tests also implies regularity.
