# Theorem-count history for `fefferman-clay-navier-stokes`

Read-only investigation of the three public counts **184**, **186**, and **247** (and the related **262** / **225** figures), compared with a source count of `theorem` / `lemma` declarations. No pushes. No `lake` builds. All times below are in America/Chicago (CDT, UTC-5, through 2026-11-01; CST, UTC-6, after that).

**Current source counted here** at `4cb21508606a17281fd1116cef6e17483e2f48ba` (main as of 2026-11-10 18:35:47 CST): **224** `theorem`/`lemma` declarations across 7 modules.

| Module | This count | Earlier briefing (225 / Defs 132) |
|---|---:|---:|
| `Defs.lean` | 131 | 132 |
| `FeffermanStatements.lean` | 10 | 10 |
| `FinalProductTheorem.lean` | 21 | 21 |
| `HighSetDepletionAndBKM.lean` | 26 (24 `theorem` + 2 `lemma`) | 26 |
| `MainTheorem.lean` | 1 | 1 |
| `Stage6Calculus.lean` | 16 | 16 |
| `TorusStrainExclusion.lean` | 19 | 19 |
| **Total** | **224** | **225** |

The 1-declaration gap is only in `Defs.lean` (131 vs 132). Method used here: strip Lean line and block comments, then count declaration headers of the form `(public|private|protected|noncomputable|@[…])* theorem|lemma <name>`, including dotted names such as `VorticityTransportRegularity.spaceC2`. Two in-comment uses of the word “theorem” in `Defs.lean` (around the `PointwiseStrainSupBound` discussion, lines 2823 and 2832 at this commit) are **not** counted. A naïve keyword scan that included both comment hits would be 133; 132 would be 131 plus exactly one of those comment hits, or 131 plus the `Prop` structure `VorticityTransportRegularity`. Which, if either, produced the earlier 132 is **unknown**. This file uses **224 / Defs 131** everywhere below.

---

## Side-by-side

| Claim | Where it was introduced and where it still sits | Introduced (SHA, author, America/Chicago date, subject) | Actual `theorem`/`lemma` count **at that commit** (or nearest fefferman commit on or before that date) | Actual count **now** (`4cb2150`) |
|---|---|---|---|---|
| **184** | GitHub repo **description** of `BenFrohman/fefferman-clay-navier-stokes` (until 2026-11-10); initial README, commit message, `.zenodo.json`, and titan-audit certificates in the same repo; published Zenodo **v1.0.0** [10.5281/zenodo.23652841](https://doi.org/10.5281/zenodo.23652841). Not in `CITATION.cff` (no count in any version). Not in `NS_Millennium_Proof`. | `9bd8a9675993cb973f66216de696b20f7c489b71`, Benjamin Stanley Frohman `<frohmanbenjamin@gmail.com>`, **2026-10-25 19:01:40 CDT**, “Formalize Fefferman periodic Navier-Stokes (B), global linear strain exclusion, and conditional BKM reductions (184 theorems, 0 sorry, DOI: 10.5281/zenodo.23652841)”. This is the repo’s first commit. The GitHub description is not stored in git; see notes below. | **164** at `9bd8a96` itself. Per module: Defs 126, FeffermanStatements 10, HighSetDepletionAndBKM 9, TorusStrainExclusion 19. The 184 figure is the titan-audit total from `audit/report.json` generated 2026-10-25 19:00:47 CDT (Defs 143, FeffermanStatements 13, HighSet 9, Torus 19). | **224** |
| **186** | fefferman README / certificates starting at `6ab1908`; `.zenodo.json` from `6954ea6` **through current main** (still says 186); `NS_Millennium_Proof` README starting at `8a5ec50` and **still on `main`** (PR #27 has not been merged); published Zenodo **v1.1.0** [10.5281/zenodo.23717083](https://doi.org/10.5281/zenodo.23717083) and latest **v1.2.0** [10.5281/zenodo.23749846](https://doi.org/10.5281/zenodo.23749846). | **In the fefferman repo:** `6ab1908fcb87cca6b82092562cb9c782bdcbf070`, Benjamin Stanley Frohman `<frohmanbenjamin@gmail.com>`, **2026-10-27 19:03:37 CDT**, “Add FinalProductTheorem.lean (Q1 ∧ Q2 ∧ Q3 ∧ Q4 ∧ Q5), Bochner-polar spatial-max reduction, single-sentence math+prose form, and updated 186-theorem certificates”. `.zenodo.json` was updated 49 minutes later in `6954ea6` (2026-10-27 19:52:14 CDT). **In `NS_Millennium_Proof`:** `8a5ec50aa602318c0c611269731e7d41cd30b75b`, same author, **2026-10-27 19:54:29 CDT**, “Release v2.2.0: sync 437-theorem audit certificates, standalone FinalProductTheorem DOIs, and Zenodo v2.2.0 metadata”. | **166** at `6ab1908` and at the nearest fefferman commit on or before the NS_Millennium_Proof line, `6954ea6` (2026-10-27 19:52:14 CDT). Per module: Defs 126, FeffermanStatements 10, FinalProductTheorem 2, HighSet 9, Torus 19. Titan-audit total 186 (same modules with Defs 143, FeffermanStatements 13, FinalProduct 2, HighSet 9, Torus 19). | **224** |
| **247** (“247 theorems across 7 modules”) | fefferman **README only**, from `a4e020a` through **current main** (header, section title, and pasted audit block). The module **table** was later edited in place, so its per-row numbers no longer sum to 247 (they sum to **262**; see below). Not in `.zenodo.json`, `CITATION.cff`, the GitHub description, `NS_Millennium_Proof`, or any published Zenodo record. | `a4e020a121b0c7d6b9d254c41f6b97299fa3ad2c`, Benjamin Stanley Frohman `<frohmanbenjamin@gmail.com>`, **2026-10-30 04:17:37 CDT**, “README: current module/theorem counts; mark conditional results inline”. README-only commit; Lean sources were not changed in this SHA. | **208** source declarations at `a4e020a`. Per module: Defs 126, FeffermanStatements 10, FinalProductTheorem 21, HighSet 9, MainTheorem 4, Stage6Calculus 19, Torus 19. The committed `audit/report.json` at this SHA is empty (theorems: 0; leftover from a failed regen on `c861ff6`). The README’s pasted block claims Defs 143, FeffermanStatements 13, FinalProduct 24, HighSet 9, Main 4, Stage6 **35**, Torus 19, **total 247**. | **224** |
| **262** (not one of the three headline claims; it is the sum of the current README table) | Current fefferman README module table only. Never written as a total in the header. | Not introduced as a claimed total. It appears once the HighSet table cell is changed from 9 to 24 (first in `1869c1ac0d1fd61b076f66ffa059757a342c2968`, 2026-10-30 14:19:06 CDT) while the other table cells and the pasted audit block stay at the `a4e020a` numbers. | n/a (sum of mixed stale/updated table cells: 24+13+19+24+4+35+143 = 262) | Source is still **224**. |
| **225** (related; not one of the three asked about) | fefferman README from `3abe9bc` (2026-10-28 18:11:57 CDT) until overwritten by 247 the next morning; titan-audit total at that commit. Reused on **2026-11-10** as the GitHub description (replacing 184) and in open [PR #27](https://github.com/BenFrohman/NS_Millennium_Proof/pull/27) (`d327524`, 2026-11-10 19:12:38 CST) as a source recount of current main. | First appearance: `3abe9bcb0be7ebe9a397af765efaea097af83238`, Benjamin Stanley Frohman `<frohmanbenjamin@gmail.com>`, **2026-10-28 18:11:57 CDT**, “Add Main Theorem reduction, Stage 6 calculus derivations, provenance, and AI disclosure”. | **202** source declarations at `3abe9bc` (Defs 126, FeffermanStatements 10, FinalProduct 21, HighSet 9, Main 1, Stage6 16, Torus 19). Titan-audit total **225** generated 2026-10-28 18:10:10 CDT (Defs 143, FeffermanStatements 13, FinalProduct 24, HighSet 9, Main 1, Stage6 16, Torus 19). | **224** source; description/PR text says 225 |

### GitHub description of `fefferman-clay-navier-stokes`

The description is not in git, and GitHub’s public events API does not record description-only edits. The `CreateEvent` for the repo (2026-10-25 19:01:41 CDT) now **displays** the current text with “225 theorems”; that field is the **current** description, not a historical snapshot.

A local API snapshot at `/workspace/tag-release-audit-20261106/fefferman-clay-navier-stokes.json` (file mtime **2026-11-09 05:11:45 CST**) still has:

> Lean 4 formalization of Fefferman's periodic Navier-Stokes statement (B), global linear strain exclusion on T3, Biot-Savart direction depletion identities, and conditional BKM reductions (**184 theorems**, 0 sorry)

The live description today (2026-11-10) is the same sentence with **225** in place of 184. The wording change happened on 2026-11-10 (this calendar day in America/Chicago), sometime after that 2026-11-09 05:11 CST snapshot. The exact clock time of the API edit is **unknown**.

---

## How 184, 186, 247, and 262 were produced

The 184 / 186 / 225 / 247 totals are **titan-audit** counts from `.olean` files, not raw `theorem`/`lemma` declaration counts in the Lean sources. Each `audit/report.md` says: “Build skipped (`--no-build`); audit used existing .olean files.” The tool is `titan-audit 1.0.0`. It reports a module count one higher than the number of keys in `per_module` (5 vs 4 at the 184 commit; 8 vs 7 at the 247 audit). The extra “module” is not named in the report. AxiomAudit.lean and the root `FeffermanClayNS.lean` have zero `theorem`/`lemma` declarations.

Across every committed audit that actually has numbers, titan-audit is higher than the source `theorem`/`lemma` count by a **stable per-module offset** in three files:

| Module | Source vs titan-audit, whenever the audit is in sync with that tree |
|---|---|
| `Defs` | source + **17** (126→143 at the early commits; 131→148 at `4a44bbc` / current certificates) |
| `FeffermanStatements` | source + **3** (10→13) |
| `FinalProductTheorem` | source + **3** once the file has grown past its first two theorems (21→24). When the file had only 2 theorems (`6ab1908`), audit also said 2. |
| `HighSetDepletionAndBKM`, `TorusStrainExclusion`, `MainTheorem`, `Stage6Calculus` (after name cleanup) | source and audit match |

So:

- **184 = 164 + 20** (the +17 and +3 on Defs and FeffermanStatements).
- **186 = 166 + 20** (same offset; the two new `FinalProductTheorem` theorems are counted 1-for-1).
- **225** (Oct 28 certificate) **= 202 + 23** (the same +20, plus +3 on FinalProduct once that file has 21 source theorems).
- **247** on the last committed successful audit (`4a44bbc`, 2026-10-30 14:47:13 CDT, generated 14:44:59 CDT, git HEAD recorded as `a818886`) **= 224 + 23**. That audit’s per-module split is Defs 148, FeffermanStatements 13, FinalProduct 24, HighSet 26, Main 1, Stage6 16, Torus 19.

The exact 23 extra `.olean` constants are **unknown**. This investigation did not run a lake build and the audit JSON stores only counts, not names. They are not reproduced by adding all `def` / `abbrev` / `structure` declarations, nor by adding only `Prop` structure fields (`VorticityTransportRegularity` has 3 fields, `AttainedSpatialMaximum` has 2; `KatoLocalWitness` is not a `Prop` structure). The natural hypothesis is that titan-audit counts additional Prop-valued kernel constants (generated projections or similar). That is not verified here.

**247 at the moment it was first typed into the README** (`a4e020a`, 2026-10-30 04:17:37 CDT) is a slightly different story. The Lean tree at that SHA has 208 source declarations, and the committed audit JSON is empty. The pasted per-module block already says Stage6 = **35** (source at that SHA is 19) and uses the titan-audit inflated numbers for Defs / FeffermanStatements / FinalProduct. Those seven cells sum to 247. A later committed audit on the same day (`8ac440d` certificates, 2026-10-30 14:04:18 CDT) also reports Stage6 = 35. After `a818886` (2026-10-30 14:44:49 CDT, “Original lemma names only: …”) restored the current Stage6/Main names, the `4a44bbc` audit dropped Stage6 from 35 to 16 (matching source) and the total stayed 247 because HighSet and Defs had grown. The 16 extra Stage6 names that once produced “35” are **unknown** (no name-level dump).

**262** is not an audit total. It is 24+13+19+24+4+35+143, i.e. the current README **table** after HighSet’s cell was updated to “24 theorems” (the 24 `theorem` declarations, excluding the two `lemma`s `Icc_mem_nhdsWithin_Ici_prod` and `hasDerivWithinAt_slice_Icc`) while Defs 143, FeffermanStatements 13, FinalProduct 24, Main 4, and Stage6 35 were left at the stale `a4e020a` paste. The header and the pasted `TOTAL theorems=247` block were never updated.

No evidence was found that 184/186/247 came from counting duplicated files. At every commit examined, each module exists once under `FeffermanClayNS/`.

---

## Literal text over time

### fefferman README toolchain / total lines

```
# 9bd8a96  2026-10-25 19:01:40 CDT  (introduces 184)
Toolchain: … (2631/2631 build jobs, **184 theorems**, 0 sorry, 0 non-standard axioms)
TOTAL theorems=184 nonstandard=0

# 6ab1908  2026-10-27 19:03:37 CDT  (introduces 186)
- **184 theorems**
+ **186 theorems across 6 modules**
- TOTAL theorems=184
+ TOTAL theorems=186
  (and “Exact Breakdown … (186 theorems, 0 sorry)”)

# 3abe9bc  2026-10-28 18:11:57 CDT  (introduces 225 in this README; later overwritten)
- **186 theorems across 6 modules**
+ **225 theorems across 6 modules**     # “6 modules” is already wrong: MainTheorem and Stage6Calculus make 7
- TOTAL theorems=208                    # intermediate ea51748 paste (audit 208, source 185)
+ header 225; the new audit paste is TOTAL theorems=225

# a4e020a  2026-10-30 04:17:37 CDT  (introduces 247; still on main)
- **225 theorems across 6 modules**
+ **247 theorems across 7 modules**
- ## Exact Breakdown … (225 theorems, 0 sorry)
+ ## Modules (247 theorems, 0 sorry)
- TOTAL theorems=225
+ TOTAL theorems=247
  (and Stage6 16→35, Main 1→4 in the pasted block; table HighSet still 9)

# 156ec72 / 8ac440d / 1869c1a  2026-10-30 13:28–14:19 CDT
  Header and TOTAL stay at 247.
  HighSet table cell only: 9 → 12 → … → 24 theorems
  (24+13+19+24+4+35+143 = 262; header still 247)
```

Current main (`4cb2150`, 2026-11-10 18:35:47 CST) still has the `a4e020a` header and pasted audit block, plus the later HighSet table cell of 24.

### fefferman `.zenodo.json`

```
# 9bd8a96  2026-10-25 19:01:40 CDT
"… 184 kernel-verified theorems across 5 modules with zero sorry …"

# 6954ea6  2026-10-27 19:52:14 CDT  (and still on current main)
"… 186 kernel-verified theorems across 6 modules with 0 sorry and 0 custom axioms …"
```

`CITATION.cff` never contains a theorem count.

### `NS_Millennium_Proof` README

```
# 8a5ec50  2026-10-27 19:54:29 CDT  (introduces the 186 line; still on main)
- `186` kernel-verified theorems across `6` modules (`0 sorry`, `0` custom axioms).

# d327524  2026-11-10 19:12:38 CST  (PR #27 only, not merged)
- `186` kernel-verified theorems across `6` modules (`0 sorry`, `0` custom axioms).
+ `225` `theorem`/`lemma` declarations across `7` modules (`0 sorry`, `0` custom axioms), counted in the source at commit `4cb2150`.
```

PR: https://github.com/BenFrohman/NS_Millennium_Proof/pull/27 (open, base `main`).

### GitHub description

```
# Snapshot still valid 2026-11-09 05:11:45 CST
… conditional BKM reductions (184 theorems, 0 sorry)

# Live on 2026-11-10
… conditional BKM reductions (225 theorems, 0 sorry)
```

### Published Zenodo records (unchanged in this investigation)

| Version | DOI / record | Publication date | Description still says |
|---|---|---|---|
| v1.0.0 | [10.5281/zenodo.23652841](https://doi.org/10.5281/zenodo.23652841) | 2026-10-25 | **184** kernel-verified theorems across 5 modules |
| v1.1.0 | [10.5281/zenodo.23717083](https://doi.org/10.5281/zenodo.23717083) | 2026-10-27 | **186** kernel-verified theorems across 6 modules |
| v1.2.0 (latest) | [10.5281/zenodo.23749846](https://doi.org/10.5281/zenodo.23749846) | 2026-10-28 (record created 2026-10-28 20:44:59 CDT) | **186** kernel-verified theorems across 6 modules (copied from the already-stale `.zenodo.json`; the fefferman README at that time already said 225) |

---

## Per-module source counts at each origin, vs now

| Module | 184 origin `9bd8a96` | 186 origin `6ab1908` | 247 origin `a4e020a` | Now `4cb2150` |
|---|---:|---:|---:|---:|
| Defs | 126 | 126 | 126 | 131 |
| FeffermanStatements | 10 | 10 | 10 | 10 |
| FinalProductTheorem | — (file absent) | 2 | 21 | 21 |
| HighSetDepletionAndBKM | 9 | 9 | 9 | 26 |
| MainTheorem | — | — | 4 | 1 |
| Stage6Calculus | — | — | 19 | 16 |
| TorusStrainExclusion | 19 | 19 | 19 | 19 |
| **Total** | **164** | **166** | **208** | **224** |

---

## Declaration diffs vs current main (`4cb2150`)

Names are `theorem`/`lemma` identifiers. A name present in both trees is not listed even if the proof changed. `git diff --stat` is for `*.lean` only.

### 184 origin `9bd8a96` → now: +60, −0

`git diff --stat 9bd8a96 4cb2150 -- '*.lean'`:

```
 AxiomAudit.lean                             | 283 +++++++++++++---
 FeffermanClayNS.lean                        |  35 +-
 FeffermanClayNS/Defs.lean                   | 148 +++++++--
 FeffermanClayNS/FeffermanStatements.lean    |  16 +-
 FeffermanClayNS/FinalProductTheorem.lean    | 499 ++++++++++++++++++++++++++++
 FeffermanClayNS/HighSetDepletionAndBKM.lean | 302 ++++++++++++++++-
 FeffermanClayNS/MainTheorem.lean            |  40 +++
 FeffermanClayNS/Stage6Calculus.lean         | 193 +++++++++++
 8 files changed, 1403 insertions(+), 113 deletions(-)
```

Nothing was removed. Added:

- `Defs.lean` (5): `Tstar_eq_top_of_bkm`, `beale_kato_majda_scaffold`, `beale_kato_majda_scaffold_integrability_unused`, `bkm_criterion_without_integrability_not_top`, `ereal_eq_top_of_bkm`
- `FinalProductTheorem.lean` (21, new file): `AttainedSpatialMaximum.vorticity_sup_norm_eq`, `bddAbove_range_norm_of_attained_max`, `beltrami_amplitude_pos_and_bounded`, `beltrami_lamb_vector_cross3_zero`, `bochner_laplacian_3d_identity`, `concrete_bochner_polar_viscous_damping_at_max`, `constVelocity_convective_zero`, `constVelocity_isPeriodicSmoothInitialData`, `constVelocity_isPeriodicSmoothSolution`, `constVelocity_isZ3Periodic`, `constVelocity_laplacian_zero`, `constVelocity_ne_zero`, `constantin_fefferman_near_far_cutoff_bridge`, `fefferman_periodic_ns_exact_reduction_product_theorem`, `first_remaining_gap_bochner_polar_damping_at_max`, `near_field_stretching_absorbed_by_viscous_direction_damping`, `nonzero_periodic_smooth_solution_exists`, `polar_pythagoras_3d_sum`, `polar_pythagoras_directional_deriv`, `unitCube_nonempty`, `vorticity_sup_norm_eq_of_isSpatialMax`
- `HighSetDepletionAndBKM.lean` (17): `Icc_mem_nhdsWithin_Ici_prod`, `clay_B_exact_of_periodic_bkm`, `clay_B_exact_of_periodic_finite_time_bound_scaffold`, `constE0_initialData`, `hasDerivWithinAt_slice_Icc`, `isPeriodicSmoothSolution_of_forall_horizon`, `not_isPhysicalNSSolution_of_constE0`, `not_periodicLocalExistenceOriginal`, `not_periodicMaximalSolutionOriginal`, `periodicBKMContinuation_of_finiteTime_scaffold`, `periodicExistenceTimesOriginal_constE0`, `periodicFiniteTimeBound_vacuous`, `periodicFiniteTimeVorticityBound_of_uniform`, `periodicGlobalOfTstarTop`, `periodicTstar_eq_top_of_bkm`, `zero_isPeriodicSmoothInitialData`, `zero_isPeriodicSmoothSolutionOn`
- `MainTheorem.lean` (1, new file): `clay_reduces_to_direction_curvature_bound`
- `Stage6Calculus.lean` (16, new file): `bochner_leibniz_of_hasDerivAt`, `hasDerivAt_half_norm_sq`, `hasDerivAt_inner_self`, `hasDerivAt_polar`, `inner_deriv_zero_at_max`, `polar_pythagoras_of_hasDerivAt`, `real_iSup_eq_zero_of_not_bddAbove`, `shearU_hasDerivAt_z`, `shearU_heat`, `shearV_hasDerivAt_z`, `shearV_heat`, `shear_beltrami`, `shear_convective_and_div_zero`, `shear_nonconstant`, `shear_periodic`, `unit_direction_deriv_orthogonal`

### 186 origin `6ab1908` → now: +58, −0

`git diff --stat 6ab1908 4cb2150 -- '*.lean'`:

```
 AxiomAudit.lean                             | 286 ++++++++++++++++----
 FeffermanClayNS.lean                        |   2 +
 FeffermanClayNS/Defs.lean                   | 148 ++++++++---
 FeffermanClayNS/FeffermanStatements.lean    |  16 +-
 FeffermanClayNS/FinalProductTheorem.lean    | 396 ++++++++++++++++++++++++++--
 FeffermanClayNS/HighSetDepletionAndBKM.lean | 302 ++++++++++++++++++++-
 FeffermanClayNS/MainTheorem.lean            |  40 +++
 FeffermanClayNS/Stage6Calculus.lean         | 193 ++++++++++++++
 8 files changed, 1273 insertions(+), 110 deletions(-)
```

Same added names as the 184 diff, except the two theorems already present in `FinalProductTheorem.lean` at `6ab1908` are not new: `fefferman_periodic_ns_exact_reduction_product_theorem`, `first_remaining_gap_bochner_polar_damping_at_max`. Nothing was removed.

### 247 origin `a4e020a` → now: +32, −16

This origin is a README-only commit. The Lean diff is against the same tree that the 247 number was first attached to.

`git diff --stat a4e020a 4cb2150 -- '*.lean'`:

```
 AxiomAudit.lean                             | 303 +++++++++++++++++++++-------
 FeffermanClayNS/Defs.lean                   | 148 +++++++++++---
 FeffermanClayNS/FeffermanStatements.lean    |  16 +-
 FeffermanClayNS/HighSetDepletionAndBKM.lean | 302 ++++++++++++++++++++++++++-
 FeffermanClayNS/MainTheorem.lean            |  49 ++---
 FeffermanClayNS/Stage6Calculus.lean         | 132 +++++-------
 6 files changed, 721 insertions(+), 229 deletions(-)
```

Removed (16), mostly Mathlib-style names later restored under the original identifiers in `a818886` (2026-10-30 14:44:49 CDT):

- `MainTheorem.lean` (3): `HasDirectionCurvatureCoercivity.clay_B_exact`, `HasDirectionCurvatureCoercivity.periodicTetherClosingBound`, `clay_B_exact_of_hasDirectionCurvatureCoercivity`
- `Stage6Calculus.lean` (13): `IsUnitDirectionCurve.inner_eq_zero`, `IsUnitDirectionCurve.norm_polar_deriv_sq_eq`, `hasDerivAt_inner_self_deriv_of_hasDerivAt`, `hasDerivAt_shearU_z`, `hasDerivAt_shearV_z`, `hasDerivAt_smul_polar`, `iSup_eq_zero_of_not_bddAbove`, `inner_eq_zero_of_hasDerivAt_of_norm_eq_one`, `inner_eq_zero_of_isLocalMax_half_norm_sq`, `isShearBeltramiMode`, `norm_polar_deriv_sq_eq_of_hasDerivAt`, `shearU_zero_ne_quarter`, `shear_convective_and_div_eq_zero`

Added (32):

- `Defs.lean` (5): same five BKM-scaffold names as in the 184/186 diffs
- `HighSetDepletionAndBKM.lean` (17): same 17 names as in the 184/186 diffs
- `Stage6Calculus.lean` (10, the restored original names): `bochner_leibniz_of_hasDerivAt`, `hasDerivAt_polar`, `inner_deriv_zero_at_max`, `polar_pythagoras_of_hasDerivAt`, `real_iSup_eq_zero_of_not_bddAbove`, `shearU_hasDerivAt_z`, `shearV_hasDerivAt_z`, `shear_convective_and_div_zero`, `shear_nonconstant`, `unit_direction_deriv_orthogonal`

From `a818886` onward the `theorem`/`lemma` name set is identical to `4cb2150`. Later commits on main are metadata, naming notes, CI, and the CITATION alias.

---

## Notes and leftovers (still public, still wrong or stale)

- fefferman **README** on current main still says **247** in the header and still pastes an audit block whose own cells sum to 247 but no longer match either the current source or the last committed audit JSON.
- fefferman **`.zenodo.json`** on current main still says **186 across 6 modules**.
- **`NS_Millennium_Proof` `main`** still says **186 across 6 modules**. The correction to 225 is only on branch `metadata/title-and-theorem-count` / PR #27.
- Published Zenodo **v1.0.0 still says 184**; **v1.1.0 and v1.2.0 still say 186**. Those records were not changed in this investigation.
- The GitHub **description** now says **225**, which is 1 higher than the source count obtained here (224).
- `CITATION.cff` has no theorem count in any version of either repo.

Method and limits: shallow-then-full clones under `/tmp` (deleted after); `git log -S` / `git log -G` on README, `.zenodo.json`, `CITATION.cff`, and the NS_Millennium_Proof README; declaration parse described above; titan-audit JSON/Markdown already in the trees; GitHub API for the current description, PR #27, and events; a 2026-11-09 local API snapshot for the old description; Zenodo REST for published records. No lake build, so the 23 extra titan-audit constants were not named.
