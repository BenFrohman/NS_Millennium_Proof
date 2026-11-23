# Audit Report: FrohmanianTripleArchitecture.lean

**Author context:** Benjamin Stanley Frohman  
**Date:** 2026-11-09 (America/Chicago)  
**Lean:** 4.22.0 · **Mathlib:** v4.22.0 / `79e94a093aff`  
**Workdir:** `/workspace/triple-architecture-build-2026-11-09`  
**Constraints honored:** no deletes of originals; no git; no publish/push; pristine copies untouched.

---

## 1. Sources extracted from paste t993u

| Artifact | Path | Role |
|---|---|---|
| Second (complete) copy | `pristine/FrohmanianTripleArchitecture.lean` | Main formalization (verbatim, backticks stripped) |
| First-copy Section 3 fragment | `pristine/AlignmentKernel_fragment.lean` | alignment kernel lemmas absent from second copy |
| Truncation note | `pristine/CONSTANTIN_FEFFERMAN_TRUNCATED.txt` | mid-statement cut of `constantin_fefferman_desingularization` |
| Fixed main | `fixed/FrohmanianTripleArchitecture.lean` | API + one logic-bug proof repair; statements unchanged |
| Fixed fragment | `fixed/AlignmentKernel_fragment.lean` | API repair for `triple_product_cycle`; statements unchanged |

The first paste is truncated mid-`constantin_fefferman_desingularization` and is garbled into prose; that theorem **cannot be built as pasted**. The second complete copy (after `` ```lean ``) has **no** alignment-kernel section and **no** `constantin_fefferman_desingularization`.

Note: the first paste also contained `tether_nonpos`, which is **not** in the second complete copy (so it is not in the main pristine/fixed files).

---

## 2. Build status

| Target | Pristine | Fixed |
|---|---|---|
| `FrohmanianTripleArchitecture.lean` | **FAIL** (Grönwall/API + unsound `nlinarith`) | **PASS** |
| Sections 1–2 alone (projPerp / Metriplectic / totalMetriplectic*) | **PASS** (zero edits) | n/a |
| `AlignmentKernel_fragment.lean` | **FAIL** (`triple_product_cycle` + stray doc-comment) | **PASS** |
| `constantin_fefferman_desingularization` | **absent / truncated** — not buildable | — |

`State` / `V` as implicit autobound variables on `totalMetriplecticBracket` / `totalMetriplectic_symm` / `totalMetriplectic_flow_equals_unmodified_NS`: **elaborates successfully** (namespace-level `variable {V ...}` plus Lean autobinding of `State`).

---

## 3. Forbidden-token scan

On pristine and fixed main + fragment: **zero** hits for `sorry`, `admit`, `axiom` declarations, `native_decide`, `opaque`, `implemented_by`, `unsafe`.

---

## 4. `#print axioms` (fixed builds)

Every theorem depends only on the standard Lean axioms:

`propext`, `Classical.choice`, `Quot.sound`

No custom axioms.

**Main:** `projPerp_self`, `inner_projPerp_self`, `tether_degenerate_H`, `tether_symmetric`, `totalMetriplectic_symm`, `totalMetriplectic_flow_equals_unmodified_NS`, `gronwall_differential_bound`, `hypothesisB_implies_clayStatementB`, `three_way_equivalence`.

**Fragment:** `abs_dot3_le`, `triple_product_cycle`, `abs_alignmentKernel_le`.

---

## 5. Theorem statements (verbatim) and honest classification

### 5.1 Genuinely proved from definitions (algebraic / elementary)

```
lemma projPerp_self (u : V) : projPerp u u = 0
lemma inner_projPerp_self (u Φ : V) : inner ℝ (projPerp u Φ) u = 0
theorem tether_degenerate_H (κ W_ω : ℝ) (u dF : V) :
    tetherMetricCorrection κ W_ω u dF u = 0
theorem tether_symmetric (κ W_ω : ℝ) (u dF dG : V) :
    tetherMetricCorrection κ W_ω u dF dG = tetherMetricCorrection κ W_ω u dG dF
```

```
theorem totalMetriplectic_symm (sys : MetriplecticSystem State V) (F G : State → ℝ) (ω : State) :
    totalMetriplecticBracket sys F G ω = totalMetriplecticBracket sys G F ω
```
(Uses structure field `diss_symm` + proved `tether_symmetric`.)

```
theorem totalMetriplectic_flow_equals_unmodified_NS (sys : MetriplecticSystem State V)
    (H : State → ℝ) (F : State → ℝ) (ω : State) :
    sys.liePoisson F H ω + totalMetriplecticBracket sys F H ω =
    sys.liePoisson F H ω + sys.morrisonDiss F H ω
```
(Uses structure field `curlGradVar_H` — see §5.2 — plus proved `tether_degenerate_H`.)

```
lemma gronwall_differential_bound {Y α : ℝ → ℝ} {T : ℝ} (hT : 0 ≤ T)
    (hY_diff : ∀ t ∈ Icc 0 T, DifferentiableAt ℝ Y t)
    (hα_cont : ContinuousOn α (Icc 0 T))
    (h_ineq : ∀ t ∈ Icc 0 T, deriv Y t ≤ α t * Y t) :
    ∀ t ∈ Icc 0 T, Y t ≤ Y 0 * Real.exp (∫ τ in (0 : ℝ)..t, α τ)
```
Genuine scalar Grönwall (fixed proof body; statement unchanged).

**Fragment:**
```
lemma abs_dot3_le (a b : Fin 3 → ℝ) : |dot3 a b| ≤ norm3 a * norm3 b
lemma triple_product_cycle (r_hat ξ_x ξ_y : Fin 3 → ℝ) :
    dot3 (cross3 r_hat ξ_y) ξ_x = dot3 r_hat (cross3 ξ_y ξ_x)
theorem abs_alignmentKernel_le {dist : ℝ} (hdist : 0 < dist) {r_hat ξ_x : Fin 3 → ℝ}
    (hr : norm3 r_hat = 1) (hξx : norm3 ξ_x = 1) (ξ_y : Fin 3 → ℝ) :
    |alignmentTetherKernel dist r_hat ξ_x ξ_y| ≤ (3 / (4 * Real.pi * dist ^ 3)) * norm3 (cross3 ξ_y ξ_x)
```
Elementary ℝ³ Cauchy–Schwarz / scalar-triple-product / kernel bound. **Not** a PDE desingularization theorem.

### 5.2 Conclusions that rest on structure fields that *assume* the content

`MetriplecticSystem` fields (assumed, not derived):
- `curlGradVar_H : ∀ H, ∀ ω, curlGradVar H ω = velField ω` — assumes δH/δω curl equals velocity.
- `lp_skew` — assumes skew-symmetry of `liePoisson`; **Jacobi identity is never stated and never proved**.
- `diss_symm` — assumes symmetry of `morrisonDiss`.
- `liePoisson`, `morrisonDiss`, `velField`, `enstrophy`, `curlGradVar` are abstract; there is no actual vorticity PDE, no T³, no Biot–Savart.

`NavierStokesUnifiedData` fields (assumed, not derived):
- `clayStatementB : Prop` — an **abstract proposition**, not Clay Statement (B) for 3D NS on T³.
- `bkm_vorticity_criterion : clayStatementB ↔ (BKM-style integral bound on vorticitySup)` — **assumes BKM as an iff**, does not prove BKM.
- `smooth_implies_bounded_strain` — assumes clayStatementB ⇒ strain supremum bound.
- `differential_bounds` — assumes `deriv vorticitySup t ≤ strainSup t * vorticitySup t` (the Riccati/growth inequality M' ≤ S·M), does not derive it from NS.

```
theorem hypothesisB_implies_clayStatementB (sol : NavierStokesUnifiedData)
    (hHypB : HypothesisB sol) : sol.clayStatementB
```
Rearranges Hypothesis B + assumed Riccati + assumed BKM-iff into `clayStatementB`.

```
theorem three_way_equivalence (sol : NavierStokesUnifiedData) :
    (HypothesisB sol ↔ BKMVorticityIntegrable sol) ∧
    (BKMVorticityIntegrable sol ↔ sol.clayStatementB)
```
Logical rearrangement among abstract props / assumed fields.

### 5.3 Unsound pristine step in `three_way_equivalence` (verified)

Pristine proof:
```
have hCS_nonneg : 0 ≤ C_S := by
  have h0 := hCS 0 ⟨…⟩           -- only strainSup 0 ≤ C_S
  have h0_nonneg := sol.vorticity_nonneg 0 …
  nlinarith
```
**Fails to build.** `strainSup` may be negative; `vorticity_nonneg` is irrelevant. Unlike `ConditionalNavierStokesTetherFull` (which had `strain_nonneg`), this structure has no strain nonnegativity field.

**Fixed without changing the theorem statement:** witness `(max C_S 0) * T` instead of `C_S * T`. Documented in `FIXES.md`. This is a correction of a wrong proof step, not a weakening of the claim.

### 5.4 Plain answers to the required questions

| Question | Answer |
|---|---|
| Does anything prove Clay Statement (B) for actual 3D Navier–Stokes on T³? | **No.** `clayStatementB` is an abstract `Prop`; BKM and M'≤S·M are assumed as structure fields; there is no NS PDE in the file. |
| Is the Jacobi identity for `liePoisson` proved? | **No.** It is not even stated. Only `lp_skew` is assumed as a structure field. Manuscript prose claiming Jacobi via Marsden–Weinstein–Ratiu is **not** formalized. |
| Does `abs_alignmentKernel_le` build? | **Yes** (fixed fragment). |
| Does `constantin_fefferman_desingularization` build? | **No** — truncated mid-statement in the first paste; absent from the second complete copy. |

---

## 6. Comparison with ConditionalNavierStokesTetherFull.lean (prior audit)

| Feature | ConditionalNavierStokesTetherFull | FrohmanianTripleArchitecture |
|---|---|---|
| `projPerp` + tether degeneracy/symmetry | yes (`quadraticBilinearTether`) | yes (`tetherMetricCorrection`) — same idea |
| Diagonal nonpositivity `tether_nonpos` | yes | **only in truncated first paste**, not in second complete copy |
| Metriplectic packaging (`liePoisson` + `morrisonDiss` + total bracket) | **no** | **yes (new)** — but brackets are abstract fields |
| `totalMetriplectic_flow_equals_unmodified_NS` | no | **yes (new)** — degeneracy + assumed `curlGradVar_H` |
| Scalar Grönwall | yes | yes (same pattern) |
| Hyp B / BKM / clayStatementB three-way | yes | yes (adds named `BKMVorticityIntegrable`) |
| `strain_nonneg` field | **yes** | **no** (caused pristine `nlinarith` failure) |
| Alignment kernel / CF desingularization | no | fragment has kernel bound; CF theorem truncated |
| Proves real 3D NS regularity / Clay | **no** | **no** |

**What is genuinely new and proved:** metriplectic bracket packaging + symmetry of the total symmetric sector + recovery of “unmodified” energy-slot flow from tether degeneracy, all at the level of an abstract structure; plus the ℝ³ alignment-kernel absolute-value bound in the fragment.

**What is not new in substance for Clay/NS:** the Grönwall + abstract BKM-iff rearrangement is the same conditional skeleton as before.

---

## 7. Fixes applied (summary)

See `FIXES.md` for the full list. Headline items:

1. Import `Deriv.MeanValue` + `Deriv.Mul`; `open intervalIntegral` + `Filter` / `Topology`.
2. `intervalIntegrable_of_Icc`; Grönwall proof body adapted to Mathlib v4.22 (`antitoneOn_of_hasDerivWithinAt_nonpos`, etc.).
3. Replace unsound `nlinarith` for `0 ≤ C_S` with witness `(max C_S 0) * T`.
4. Fragment: prove `triple_product_cycle` via Mathlib `triple_product_permutation`; fix orphan doc-comment.

No theorem/def/structure **statements** were changed; no hypotheses were added to structures.

---

## 8. Claimed manuscript items vs Lean reality

| Manuscript claim | Lean status |
|---|---|
| Skew `liePoisson` | Assumed (`lp_skew`), not constructed from NS |
| Jacobi on coadjoint orbits / MWR | **Not formalized** |
| Symmetric total metriplectic bracket | Proved relative to assumed `diss_symm` + proved tether symmetry |
| Strict degeneracy B(F,H)≡0 | Proved for the abstract quadratic form (`tether_degenerate_H`) |
| Unmodified NS vorticity transport | Only: abstract energy-slot identity using assumed `curlGradVar_H` |
| Constantin–Fefferman desingularization | **Truncated; not present** |
| Theorems A/B/C (BKM / Kato / Fujita–Kato) | **Not proved**; BKM is an assumed iff field |
| Clay Statement (B) for 3D NS on T³ | **Not proved** |

---

## 9. Artifacts

- `pristine/` — untouched sources from the paste  
- `fixed/` — building copies  
- `FIXES.md` — edit log  
- `logs/` — pristine/fixed/fragment/axioms build logs  
- Lake project reuses Mathlib cache from the prior tether-unified build (`79e94a09`)
