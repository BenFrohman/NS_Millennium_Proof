# Real path

`lake build` checks `NS_Millennium_Proof/Modules` and `NS_Millennium_Proof/Definitions`. That is the real target.

Top-level `Modules/GlobalRegularity.lean`, `Modules/SymplecticTether.lean`, and `Modules/TetheredLyapunov.lean` re-export those modules. They do not redeclare the theorems. There is no `GlobalRegularityShadow` and no `_schematic` name.

| Declaration | Path | Binder |
| --- | --- | --- |
| `frohmanian_tether_theorem` | `NS_Millennium_Proof/Modules/GlobalRegularity.lean` | `hKato`, `hDI`, `τ`, `hτ`, `hTlb`, `hInt`, `huniq_shift`, `huniq` |
| `global_regularity_for_NS` | same file | `w : KatoLocalWitness`, `hRiccati` as the ceiling conclusion |
| `tethered_reproduces_classical_euler` | `NS_Millennium_Proof/Modules/SymplecticTether.lean` | `(F) (ω) (hδ) (hdiv) (hInt)` |
| `comparison_ode_stability` | `NS_Millennium_Proof/Modules/TetheredLyapunov.lean` | scalar ceiling `y' ≤ C y² − κ'' y³` |
| `riccati_ceiling_of_vorticity_di` | same file | consumes `hDI`; `Y = max(M(0), C/κ'')` |

`hDI` is the open package: `C`, `κ''`, differentiability, `M' ≤ C M² − κ'' M³`, continuity. The unpack does not produce `−κ M⁴`. The empty binder at `2d993e3` is not the theorem.

The Bohm elaboration is a complex Banach algebra, `[NormedAlgebra ℂ 𝔸]` and `[CompleteSpace 𝔸]`. The `ℚ` structure is `Algebra.restrictScalars ℚ ℂ`, because the series coefficients are `n!⁻¹`. `ℚ` is not complete. That file is not in this tree.

Author: Benjamin Stanley Frohman
