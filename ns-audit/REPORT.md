# REPORT: Navier–Stokes / Frohmanian Tether: preservation and paper↔Lean alignment (handoff to PipelineHalt)

Prepared 2026-11-23 (America/Chicago, CT) by the Grok Bot executor, on Benjamin Frohman's instruction pt384u ("Ensure nothing is left local and lost. Halt on any mismatches.") and the cubic-sink handoff t385u. Zenodo was read-only: nothing was edited, merged or pushed to main.
**Status: HALTED.** The mismatches below need the author's intent before any deposit or main-branch change.

## 0. Preservation

- See `MANIFEST.md`. Of 40,001 NS-relevant files on the box, 35,855 are already on GitHub (matched by git blob id across 101 BenFrohman repos) and 36 are byte-identical Zenodo files. 4,110 are local-only.
- 2,429 local-only files (1,837 unique blobs, about 200 MB) are archived to the orphan branch `archive/ns-materials-20261123` in `BenFrohman/NS_Millennium_Proof`. The branch has no `.github/`, so it triggers no CI, and it uses one signed commit, never main, with no force push. Commit and verification details are in §7.
- 1,681 local-only files were **not** archived:
  - 966 personal, Drive-sourced, third-party or Drive-listing files. The repo is public, so these need Benjamin's decision (halt Q8).
  - 706 machine-generated JSON/JSONL dumps.
  - 6 bundles larger than 5 MB, whose sources are on GitHub/Zenodo.
  - 3 filename false positives from the secret filter.
- No credential was found in any archived file or archive member.

## 1. Lean status (official GitHub CI only)

| Repo @ commit | Workflow runs (all on that commit) | Result |
|---|---|---|
| `frohmanian-tether-conditional-regularity` @ `86336a9` (Merge PR #11, 1:29 PM CT) | Lean build and kernel check https://github.com/BenFrohman/frohmanian-tether-conditional-regularity/actions/runs/45249571059 · truth-gate …/runs/45249570289 · Kernel certificate …/runs/45249569955 · Lean header …/runs/45249570819 | all green; 12/12 modules replayed, 0 failures; AUDIT PASS 233 theorems, axioms ⊆ {propext, Classical.choice, Quot.sound}; 0 sorry / sorryAx |
| `frohmanian-tether-sdiff` @ `50928f3` | truth-gate https://github.com/BenFrohman/frohmanian-tether-sdiff/actions/runs/45248920836 · Lean 4 …/runs/45248920764 · Kernel certificate …/runs/45248920793 | all green; kernel replay 153/153 modules; AUDIT PASS 1,904 theorems / 91 modules; SCRATCH FULL AUDIT PASS; standard axioms |
| `periodic-ns-classical-continuation` @ `b5154f3` | truth-gate https://github.com/BenFrohman/periodic-ns-classical-continuation/actions/runs/44062315706 | Lean, kernel and header green. **truth-gate FAIL (LOCK-FORM)**: `paper_claim` reuses `PeriodicBKMIntegrability`, which aliases `formal_claim` |
| `frohmanian-symplectic-tether-regularity` @ `d6fa547` | Kernel cert https://github.com/BenFrohman/frohmanian-symplectic-tether-regularity/actions/runs/44061122453 · truth-gate …/runs/44061122441 | kernel green. **truth-gate FAIL (LOCK-FORM)**: partial lock, only conjunct (P4) of the Master Product Theorem is locked. "Kernel checks passed: no math was found false." |
| `NS_Millennium_Proof` | last green main `6b78ba7`: Lean CI https://github.com/BenFrohman/NS_Millennium_Proof/actions/runs/45241230406, Kernel cert …/runs/45241230794, truth-gate …/runs/45241230366 | `e4a9871` (3:31 PM CT, pushed by another agent) CI was in progress at audit time |
| `frohmanian-tether-geometric` | no main runs listed. Branch `ci-backfill/ac27181`: kernel green, header red | not a certificate of record |

No local Lean or Mathlib build was run, and no cache was touched.

### 1a. Exact statements (conditional-regularity @ 86336a9)

- `ClassicalNS.IsClassicalNS` / `NSSolution` are genuine classical solutions on the unit-period torus. `gradLinf` is the sup of ‖Du‖ over the cube, and `gradIntegral sol T` is a lintegral.
- `BKMCriterion`: for every maximal solution, `Tstar ≠ ⊤ → gradIntegral = ⊤`. This is the ∇u form, one-directional, and a **named hypothesis**.
- `HypothesisB C_star := ∀ ν u0 sol T, 0 < T → gradIntegral sol T ≤ ofReal (C_star T)`. It is **one bound depending only on T**, uniform over all ν and u₀.
- `analyticBridge_of_formB_forall` (locked main theorem, thm:A of both repo papers): `HypothesisB C_star → BKMCriterion → (all global with finite gradient integral)`.
- `clayB_iff_gradIntegral_finite`: per solution, given BKM, `Tstar = ⊤ ↔ ∀ T>0, gradIntegral sol T < ⊤`.
- `KatoPonceEnergy` is a named hypothesis; `kp_trivial` shows it is trivially satisfiable, so it has no content.
- `ClassicalNSOpenTarget.analytic_bridge_unconditional_Statement` is a `def … : Prop` (statement only, no sorry). README.md is stale: it still says "exactly one intentional sorry … excluded from the forbidden-token scan".
- `FrohmanianTripleArchitecture.lean` is byte-identical to the Zenodo 24079623 file (MD5 285eb869…).
  - It proves `tether_symmetric`, `tether_nonpos`, `tether_degenerate_H` and `totalMetriplectic_flow_equals_unmodified_NS`, using the structure field `curlGradVar_H` (∇×δH/δω = u) as an assumption.
  - It also proves the alignment-kernel bound and Grönwall.
  - `NavierStokesUnifiedData.bkm_vorticity_criterion` is an **iff** field over an abstract `clayStatementB : Prop`. As a result, `hypothesisB_implies_clayStatementB` and `three_way_equivalence` have no content, and the vacuity audit proves `hypothesisB_holds` and `clayStatementB_holds`.
  - The corrected file `FrohmanianTripleArchitectureLifespan.lean` sets `clayStatementB := Tstar = ⊤` and proves non-vacuity (`blowupModel_not_clay`, `old_trivialization_fails`).
- `Semantics.lean` locks `paper/Frohmanian_Tether_Unified.tex` (sha256 e8723c81…) with a genuine transcription (`paper_claim` does not alias `formal_claim`). Its docstring says the faithfulness review "is in progress". `paper/provenance-stamp.tex` still contains `PENDING-CERTIFYING-COMMIT`, `PENDING-CERTIFYING-CI-RUN` and `PENDING-OFFICIAL-PRINT-AXIOMS`.

### 1b. ⚠ MAJOR mismatch: `HypothesisB` is false for every `C_star`, so the main lock is vacuous

This is a hand argument. It is **not yet kernel-checked**.

On the unit-period torus, take u(x,t) = A e^{−4π²νt} sin(2πx₂) e₁ with p = 0.
- The advection term vanishes, ∂ₜu = νΔu and ∇·u = 0, so this is a global classical solution and maximality holds vacuously (T* = ∞).
- ‖∇u(t)‖_∞ = 2πA e^{−4π²νt}, so ∫₀ᵀ‖∇u‖_∞ dt = A(1 − e^{−4π²νT})/(2πν).
- This is unbounded in A, so no `C_star T` bounds it.

Consequences:
- `analyticBridge_of_formB_forall` is true only vacuously.
- The paper's Form B, with C_*(‖u₀‖_{H^s}, ν, T) and ‖S‖_∞, is a different statement: data-dependent, and S instead of ∇u.
- The per-solution statement that does carry content is `clayB_iff_gradIntegral_finite`.

Recommended (needs the author's intent, halt Q1/Q2): formalize `∀ C_star, ¬ HypothesisB C_star`, then re-encode Form B either per solution or with a data-dependent constant.

### 1c. Classical inputs proved in Lean elsewhere (different encodings; no bridge to `ClassicalNS.BKMCriterion`)

- `periodic-ns-classical-continuation`:
  - `periodicBKMCriterion` (vorticity, one-directional, ℤ³-periodic smooth class);
  - `periodicLocalExistence_of_nonneg` (T* > 0, Galerkin, s = 3);
  - `periodicBKMIntegrability_iff_globalLifespan`.
- `frohmanian-tether-sdiff`:
  - `periodicBKMContinuation_of_classical` (ν > 0, from the vendored pillar);
  - `clay_B_exact_of_periodic_tether_bound`, conditional only on the open `PeriodicTetherClosingBound`;
  - `KatoMaximal.katoMaximalSolution_of_feffermanDecay` (ℝ³, Fefferman decay, H³; in Scratch, built by CI);
  - `LogBoundLocal.bkmLogInequality` (BKM log-Sobolev bound on ℝ³).
- Stale sdiff docstrings:
  - `Scratch/KatoMaximal.lean:308` says "KatoMaximalSolution remains open".
  - `ClayStatements.lean:582` says BKM continuation is "known, not formalized here".

## 2. Cubic sink (t385u). Item (a): Lean statements

| Name | Where (CI-green repo first) | Kind | Discharged? |
|---|---|---|---|
| `CorrectedMaxRate (rate M C_CZ κ) := rate ≤ M * (C_CZ * M - κ * M ^ 2)` | sdiff `FrohmanianTether/CubicSourceCertificate.lean:42` (built in run 45248920764). Also in NS_Millennium_Proof, -geometric, and an Int version in `Clay-/lean/Clay/Gaps/ConditionalRiccati.lean` | `def … : Prop`, used only as a theorem argument | **No.** Only the algebra `cubic_sink_of_corrected_rate` (→ rate ≤ C_CZ M² − κM³) is proved |
| `hIdent : deriv (LyapunovS (MollifiedVorticity ω ε ·) φ) t ≤ 4·C_CZ·M·∫|ω_ε|⁴|φ| − κ·∫|ω_ε|⁶` | sdiff `TetheredLyapunov.lean:351, 424`; symplectic-tether-regularity `TetheredLyapunov.lean:788, 862, 1707` | explicit theorem argument | **No** |
| `hRiccati` (package ∃ C κ'' y, y′ ≤ Cy² − κ''y³, M ≤ y); also `hDI : FrohmanianTetherRate` / `PhysicalVorticityCubicRate` / `LocalTetherRate`, `RiccatiMajorantExists`, `FiniteTimeVorticityBound` | `ConditionalRegularity.frohmanian_tether_theorem` (sdiff, axioms [propext, Classical.choice, Quot.sound]); `GlobalRegularity.frohmanian_tether_theorem` (NS_Millennium_Proof); ClosureBlueprint | explicit theorem arguments | **No.** `AssemblyGap.lean` states this explicitly |

- None of these is an `axiom`. All `#print axioms` lines checked are standard. `riccati_ceiling_of_vorticity_di` prints `[propext, choice, Quot.sound]`, which is `Classical.choice` under `open Classical`.
- Classical source:
  - `stretching_inner_le_at_max` (⟨ω,(ω·∇)u⟩ ≤ C_CZ M³ at a spatial max) takes `hCZ : PointwiseStrainSupBound u ω C_CZ x` as a hypothesis.
  - That bound is **refuted** as a universal statement: `StrainBoundRefutation.not_forall_strain_le_sup_vorticity` (sdiff, standard axioms).
  - So M′ ≤ C_CZ M² is itself conditional. The unconditional classical bound carries a logarithm (BKM 1984; Kozono–Taniuchi 2000).
  - `classical_source_not_reduced_strain`: the cubic source does not imply `ReducedStrain`.
  - `weighted_source_polynomial`: the plus-weight amplifies.
  - `lyapunovSminus_density_neg_of_large_weight`: the minus-weight loses coercivity.
  - HISTORY.md 2026-08-31 confirms that no sextic sink exists.
  - The sink C M² − κM³ is a **hypothesis** and is not derived from identity (2). This agrees with the user context.
- **Flags (paper, LaTeX or docs that present the sink as derived, hIdent/hRiccati as proved, or global regularity as established):**
  1. The docstring "…produces the uniform ceiling used by BKM. **This discharges `hRiccati`.**" appears at:
     - sdiff `TetheredLyapunov.lean:1715` (CI-green main);
     - symplectic-tether-regularity `:2232`;
     - NS_Millennium_Proof `Modules/TetheredLyapunov.lean:2228` and `NS_Millennium_Proof/Modules/TetheredLyapunov.lean:2222`;
     - -geometric `:2228`;
     - metriplectic-world-model `:2019`.

     False as worded: `riccati_ceiling_of_vorticity_di` takes the cubic-rate `hDI` as an argument. `AnalyticPipeline.lean:215` says "discharged" in the same sense.
  2. The theorem name `global_regularity_of_constructions` (symplectic-tether-regularity `:2251`, NS_Millennium_Proof `Modules/…:2247`, metriplectic-world-model `:2038`) is conditional on `hDI : PhysicalVorticityCubicRate`, hKato and the uniqueness hypotheses. In those copies it also uses the weak class `NS_PDE + IsPhysicalNSSolution`, which admits the Takagi field (HISTORY 2026-11-21). The name overclaims.
  3. `NS_Millennium_Proof/HISTORY.md` (after the 2026-11-21 entry) says: "This formalization establishes priority for the Frohmanian Symplectic Tether Regularity Theorem as the original solution approach to the 3D Navier–Stokes Millennium Problem." This is overclaim wording.
  4. Papers whose sink wording is already honest:
     - sdiff `manuscript/main.tex`: "the cubic rate … is not a consequence of the tether"; the pointwise strain bound is refuted; there is an obstruction to damping;
     - `papers/fefferman-clay-a-conditional`;
     - local `Conditional_Continuation_SmallData_Tether.tex`: "FrohmanianTetherRate" is labeled open;
     - `two_part` and `metriplectic-world-model` are labeled as modified systems, not NS.

     **No paper or LaTeX file found presents hIdent/hRiccati as proved or claims global regularity for unmodified NS.** The overclaims are in Lean docstrings, a theorem name and HISTORY.md.

### Item (b): corrected LaTeX (drafts; not on main; committed only to the archive branch under `ns-audit/corrected-latex/`)

- `Frohmanian_Tether_Unified_corrected.tex` / `.pdf` (corrected 24079623 Unified).
  - Classical A/B/C are cited, with one-directional BKM (s > 5/2), min(T, T*) and mean-zero data. The Ponce strain remark adds the log bound (not pointwise comparable).
  - Velocity-slot tether: B(·,H) ≡ 0 holds under the curl identity, which is a Lean hypothesis. No Jacobi claim is made for the total bracket.
  - Hypothesis **`CorrectedMaxRate`** is stated exactly as in Lean, with only `cubic_sink_of_corrected_rate` proved. The classical source is stated as conditional on `PointwiseStrainSupBound`, which is refuted universally.
  - The **construction-order paragraph** says: the geometric stage (uniqueness/canonicity, degeneracy, symmetry, sign) comes first, then the analytic majorant comparison. It states that this explains which parts are proved and "does not close any gap". It lists as open: `CorrectedMaxRate`/`ReducedStrain` along NS, `hIdent`, `hRiccati` and Clay (B).
  - It includes the exact Lean statements, a remark on the HypothesisB encoding (marked "author decision pending; not yet kernel-checked"), the Lean counterparts elsewhere, the certificate line, CC BY 4.0, the Texas date and full citations (BKM 1984, Kato 1972, Kato–Ponce 1988, Fujita–Kato 1964, Kozono–Taniuchi 2000, Ponce 1985, Arnold 1966, Marsden–Weinstein 1983, Arnold–Khesin 1998, Morrison 1986, Fefferman 2000).
- `Three_Pillars_NS_corrected.tex` / `.pdf` (corrected 24080310):
  - the pillars are labeled classical/cited;
  - Pillar II data are H^s and mean-zero, and the gap in its proof (Ḣ^{3/2} ↛ L¹ ‖∇u‖_∞) is replaced by propagation of regularity;
  - "equivalently S" is replaced by a Ponce 1985 citation;
  - "converse" is corrected to "contrapositive";
  - Kato–Ponce and Ponce are added to the bibliography;
  - a Lean scope paragraph is added.
- `Littlewood_Paley_corrected.tex` / `.pdf`:
  - restricted to 1 ≤ p < ∞;
  - cites Wang 2015 and Bourgain–Pavlović 2008 for p = ∞ ill-posedness;
  - cites KOT 2002 for the B⁰_{∞,∞} bound;
  - adds Chemin 1992, Bahouri–Chemin–Danchin 2011 and a bibliography (previously none).
- All three compile cleanly with pdflatex. None has been deposited.

### Item (c): Lean/paper disagreements needing intent (halt points; see §5)

## 3. Four-way sort per draft

Key: P = PROVED (correct as stated, cited or Lean); W = WRONGLY-RETRACTED; O = OVERCLAIM; D = WORDING-DRIFT.

| # | Draft | P | W | O | D | Key items |
|---|---|---|---|---|---|---|
| 1 | Zenodo 24079623 `Frohmanian_Tether_Unified.tex` | 3 | 0 | 2 | 5 | P: one-directional BKM at s > 5/2 (cited); Kato; tether symmetric/≤0/B(F,H)=0. O: Thm A "conversely any globally smooth solution satisfies (FormB)" with a data-controlled constant (needs Tao 2007-type input or a per-solution restatement); Thm C sketch "interpolating Ḣ^{3/2} into H^s gives L¹‖S‖_∞" (gap). D: BKM integral without min(T,T*); T_loc ≥ 1/(C_s‖u₀‖) vs proof 1/(2C_s‖u₀‖); mean-zero missing; Form B (S, data-dependent) ≠ Lean HypothesisB (∇u, uniform); tether degeneracy stated unconditionally while Lean assumes the curl identity |
| 2 | Zenodo `Frohmanian_Tether_Full_Expanded.tex` | shares #1 | 0 | 1 (+#1) | shares #1 | O: Cor. (ii), the same converse. Only the differences from #1 were checked |
| 3 | Zenodo `Conditional_BKM_Continuation.tex` | 1 | 0 | 0 | 1 | P: one-directional form, s > 5/2. D: no bibliography; needs BKM 1984, Kato 1972, Kato–Ponce 1988, Kozono–Taniuchi 2000 |
| 4 | Zenodo `Littlewood_Paley_Conditional_and_SmallData.tex` (both records) | 1 | 0 | 1 | 1 | P: KT/BKM continuation (one-directional). O: Chemin/Fujita–Kato for p = ∞ (Ḃ⁻¹_{∞,1}), which is ill-posed (Wang 2015; Bourgain–Pavlović 2008). D: no bibliography (KOT 2002, Chemin 1992) |
| 5 | Zenodo 24079623 Lean files + description | 3 | 0 | 1 | 3 | P: tether lemmas, alignment-kernel bound, Grönwall (standard axioms; byte-identical to repo). O: "BKM interface one-directional", while the file has an iff field and contentless theorems (the correction note → 10.5281/zenodo.24102969 exists). D: license `apache2.0` on a paper record (must be CC BY 4.0); "Review draft (unpublished)… Keep unpublished" on a published record; companion repo called "private" (it is public) |
| 6 | Zenodo 24080310 `Three_Pillars_NS.tex` + metadata | 2 | 0 | 1 | 5 | P: Pillar I (Kato), Pillar III statement. O: Pillar II, with Ḣ^{1/2}-only data feeding into the H^s Kato solution and the Ḣ^{3/2} → L¹‖∇u‖_∞ gap. D: "(or, equivalently, ∫‖S‖_∞)" without Ponce 1985; contrapositive mislabeled "converse"; Kato–Ponce cited with no bibliography entry; description "License: Apache-2.0" vs metadata cc-by-4.0; "Keep unpublished" |
| 7 | Repo `frohmanian-tether-conditional-regularity` paper + Three Pillars note (main 86336a9) | 3 | 4 | 1 | 3 | P: tether lemmas; `clayB_iff_gradIntegral_finite`; Lifespan non-vacuity. W: Kato, Fujita–Kato and BKM labeled "Open, not formalized" (classical: should read "classical, cited, not formalized here"; periodic BKM and local existence are proved in Lean elsewhere); "logarithmic Sobolev bounds … not formalized" (`bkmLogInequality` is proved on ℝ³). O: thm:A = `analyticBridge_of_formB_forall` is vacuous (§1b). D: Form B paper vs Lean; README's stale sorry text; PENDING placeholders in provenance-stamp |
| 8 | `frohmanian-tether-sdiff/manuscript/main.tex` (+docstrings) | 4 | 2 | 1 | 1 | P: `clay_B_exact_of_periodic_tether_bound` (conditional), continuation proved, strain-bound refutation, damping obstruction. W: docstrings `KatoMaximal.lean:308` ("remains open") and `ClayStatements.lean:582` ("not formalized here"). O: docstring "This discharges `hRiccati`" (TetheredLyapunov:1715). D: says `stretching_inner_le_at_max` was "deleted", but it survives in other repos and copies (under `hCZ`) |
| 9 | Local `Conditional_Continuation_SmallData_Tether.tex` (now archived) | 6 | 0 | 0 | 1 | P: KT/BKM one-directional B⁰_{∞,∞}, s > 5/2, mean-zero, Fujita–Kato ‖u₀‖_{Ḣ^{1/2}} ≤ ε₀ν, velocity-slot tether without a Jacobi claim, stream-function slot failure (`shear_C2_fails`), open hypothesis, conditional ceiling. D: the hypothesis name "FrohmanianTetherRate" ≠ Lean `CorrectedMaxRate` (halt Q9) |
| 10 | Cubic-sink Lean docs / HISTORY (NS_Millennium_Proof, symplectic-tether-regularity, -geometric, metriplectic-world-model) | 6 | 0 | 3 | 2 | P: CorrectedMaxRate/hIdent/hRiccati are hypotheses only; `cubic_sink_of_corrected_rate`; `classical_source_not_reduced_strain`; `not_forall_strain_le_sup_vorticity`; ceiling from rate; minus-weight non-coercivity. O: "discharges hRiccati" docstrings; the name `global_regularity_of_constructions`; HISTORY "original solution approach to the … Millennium Problem". D: weak class admits the Takagi field (in old copies); "classical source M′ ≤ C_CZM²" holds only under `PointwiseStrainSupBound` |

Newer Zenodo records of the conditional-regularity repo source (24303097, 24480427, 24480435; tarballs at 86336a9/0dc35f3) were found in local audit folders. Their paper is the repo paper (#7). They were not re-sorted separately.

## 4. What a corrected Zenodo version must say

These items are for Zenodo Depositor, after Benjamin approves. I made no Zenodo edits.

1. The Clay Statement (B) remains open. There is no global-regularity claim for unmodified NS.
2. Classical results are cited, not claimed:
   - BKM one-directional (T* < ∞ ⇒ ∫₀^{T*}‖ω‖_∞ = ∞), for s > 5/2, with min(T, T*), mean-zero H^s data;
   - Kato (Kato 1972, Kato–Ponce 1988);
   - Fujita–Kato (Ḣ^{1/2} smallness, H^s data);
   - Ponce 1985 for the strain version;
   - KT 2000 / KOT 2002 for the log/Besov bounds.

   None is labeled "Open".
3. Form B has either a per-solution statement or a data-dependent constant. The converse "global smooth ⇒ Form B with a data-controlled constant" is removed, or cited to Tao 2007 in its exact form. The Lean `HypothesisB` is reported as unsatisfiable, so the corresponding lock is vacuous until it is re-encoded.
4. Tether: symmetric, B(F,F) ≤ 0, B(F,H) ≡ 0 (velocity slot). The flow is the unmodified NS. The tether gives no a priori estimate. No Jacobi identity is claimed for the total bracket. In Lean, the curl identity is an assumption.
5. The sink M′ ≤ C_CZ M² − κM³ is the named hypothesis **CorrectedMaxRate**, which is open and not derived. hIdent and hRiccati are open theorem arguments. The classical cubic source is conditional on the pointwise strain bound, and that bound fails in general. There is no sextic sink. The construction-order paragraph appears as in the draft, explicitly not as a justification.
6. Littlewood–Paley: 1 ≤ p < ∞ only.
7. Lean files: replace the iff-field `FrohmanianTripleArchitecture.lean` with the Lifespan version, or present it explicitly as superseded. The certificate line must name the exact commit plus the official CI run ids, and the provenance stamp must have no PENDING placeholders.
8. Metadata: license CC BY 4.0 for the papers, Apache-2.0 for code. Remove "unpublished / keep unpublished / private". Author "Frohman, Benjamin Stanley", ORCID 0009-0006-7068-3718. Add the bibliography entries above.

## 5. HALT questions for Benjamin

1. **HypothesisB.** The current Lean `HypothesisB` (C_star(T) only) fails for every C_star (shear flow, §1b), so `analyticBridge_of_formB_forall` is vacuous. Should I formalize `∀ C_star, ¬ HypothesisB C_star` and re-encode it?
2. **Intended Form B.** (a) A per-solution bound: classical, equivalent to Clay (B) given BKM, already `clayB_iff_gradIntegral_finite`. Or (b) C_*(‖u₀‖_{H^s}, ν, T) on ∫‖S‖_∞, whose converse needs a Tao 2007-type theorem. Also: S or ∇u?
3. Replace "Open, not formalized" for Kato, Fujita–Kato and BKM with "classical, cited". Should the papers also cite the Lean periodic-BKM / local-existence / ℝ³-Kato results, or should a bridge lemma to `ClassicalNS.BKMCriterion` be formalized?
4. Littlewood–Paley: confirm the restriction to p < ∞.
5. Zenodo metadata: license (apache2.0 → CC BY 4.0) and the "unpublished/private" text on 24079623 and 24080310. Hand to Zenodo Depositor?
6. Fix the "This discharges `hRiccati`" docstrings (6 locations) and rename `global_regularity_of_constructions` (e.g. `global_regularity_of_cubic_rate`)? These are main-branch edits, so CI pushes are needed. Sdiff's stale KatoMaximal/ClayStatements docstrings also need fixing.
7. The HISTORY.md wording "original solution approach to the 3D Navier–Stokes Millennium Problem": change it to "approach to" or "programme toward"?
8. 966 personal, Drive-sourced and third-party local files were not archived because the repo is public. Archive them to a private repo or Drive?
9. Hypothesis name in papers: `CorrectedMaxRate` (Lean audit def), `FrohmanianTetherRate`, `PhysicalVorticityCubicRate` or `LocalTetherRate`. Which one is canonical? The draft uses CorrectedMaxRate, as instructed.
10. The truth-gate LOCK-FORM failures in `periodic-ns-classical-continuation` (aliasing `paper_claim`) and `frohmanian-symplectic-tether-regularity` (partial lock): re-lock?
11. The user context ("classical unforced NS gives the cubic stretching source M′ ≤ C_CZ M²") holds in Lean only under `PointwiseStrainSupBound`, which Lean refutes universally. Should the papers state this source as conditional, or with the BKM logarithm?

## 6. Not done

- No Zenodo edits.
- No main-branch commits.
- No PRs.
- No Lean builds.
- `¬ HypothesisB` is not formalized (that waits for halt Q1).
- Zenodo version listing via the API returned no hits. The records were read individually.

## 7. Archive commit
Branch `archive/ns-materials-20261123` in `BenFrohman/NS_Millennium_Proof`: one SSH-signed commit by Benjamin Stanley Frohman <frohmanbenjamin@gmail.com>, orphan branch, no `.github/`.
