# Name separation

Lake target is `NS_Millennium_Proof/Modules`. Top-level `Modules/` is not in the `lakefile.lean` globs. CI only checks that those files exist. The old comment that the two trees match was false.

The lake names are unchanged. Their binders are unchanged.

| Lake declaration | Binder that stays |
| --- | --- |
| `GlobalRegularity.frohmanian_tether_theorem` | `hKato`, `hDI`, `τ`, `hτ`, `hTlb`, `hInt`, `huniq_shift`, `huniq` |
| `GlobalRegularity.global_regularity_for_NS` | `w : KatoLocalWitness`, `hRiccati` (the ceiling, not the differential inequality) |
| `FrohmanianTether.tethered_reproduces_classical_euler` | `(F) (ω) (hδ) (hdiv) (hInt)` |
| `TetheredLyapunov.comparison_ode_stability` | scalar ceiling `y' ≤ C y² − κ'' y³` |
| `TetheredLyapunov.riccati_ceiling_of_vorticity_di` | consumes `hDI`; `Y = max(M(0), C/κ'')` |

`hDI` is the open package: `C`, `κ''`, differentiability, `M' ≤ C M² − κ'' M³`, continuity. The three-line unpack does not produce `−κ M⁴`. Deleting `hDI` does not close the fourth conjunct.

Shadow names, top-level `Modules/` only:

| Old name in the shadow tree | New name |
| --- | --- |
| `GlobalRegularity.frohmanian_tether_theorem` | `GlobalRegularityShadow.frohmanian_tether_theorem_shadow` |
| `GlobalRegularity.global_regularity_for_NS` | `GlobalRegularityShadow.global_regularity_for_NS_shadow` |
| `tethered_reproduces_classical_euler` (two arguments) | `tethered_reproduces_classical_euler_schematic` |
| local `have hRiccati := by sorry` | `hRiccati_untranscribed` |

The shadow theorem still has an empty binder. That is the weaker statement. Its first and third branches are `sorry`, because the lake theorems they used to call now take `hδ hdiv hInt` and `w hRiccati hTstar hbelow`. A `sorry` is not `True`. The uniqueness branch of `global_regularity_for_NS_shadow` remains `sorry`.

`#print axioms` on the lake theorem is not `#print axioms` on the shadow theorem.

## Not in this tree

`CustodyCheck/Algebra.lean` is a second package and does not import Mathlib. The parameter `(deriv : Int → Int)` must be `intStep`. `Mathlib.deriv` stays `(ℝ → ℝ) → ℝ → ℝ`.

`Bohm/Trotter.lean` is a third run. The algebra is `[NormedAlgebra ℂ 𝔸]` and `[CompleteSpace 𝔸]`. The `ℚ` instance is `Algebra.restrictScalars ℚ ℂ`, because the series coefficients are `n!⁻¹`. `ℚ` is not complete. This is not a Banach algebra over `ℚ`. `lieStep_eq_exp_of_commute`, `strangStep_eq_exp_of_commute`, and `strangProduct_eq_exp_of_commute` require that the factors commute and that `n ≠ 0`. They do not apply to `−½Δ` and `½ ω² r²`. The Trotter limit in that algebra is uninhabited here. It is not a strong limit on `L²`.

Author: Benjamin Stanley Frohman
