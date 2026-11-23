# May/June 2026 rename map (read-only audit, 2026-10-31)

Sources scanned (May/June only): may-form `history/2026-05-*`, `2026-06-*` (May 31 Tether.lean, May 20 routeA, May 21 PASS2/vFinal, Jun build_context, Jun 26 living); `ns_snapshot_0528`, `ns_snapshot_0629`; `drive_may/own`; `may30_upload`; `drive/` (main3_May03, Full_Living_May24, Tether_May31, vFinal, referee_0521); Zenodo record 23629499 PDFs (pdftotext). Excluded: may-form `TetherMayForm/*.lean` (git dates Oct 29, rebuilt) and `2026-08-26_saturation`.

Caveats: snapshot/folder dates are labels from folder names, not server timestamps (except where provenance_dates.md confirms). May/June Lean is mostly `sorry`/stub, so a "match" means the same NAME/ROLE, not the same theorem. Renaming to a May name whose May statement differs would misstate the result — flagged MEDIUM/LOW.

| repo | coined name | May/June name | confidence | source (file:line — date) | quote | note |
|---|---|---|---|---|---|---|
| metriplectic-world-model | `projOff` | `Pi_u` | HIGH | frohmanian-symplectic-tether-may-form/history/2026-05-31_Tether_lean/Tether_May31.lean.txt:43 — May 31 2026 (history folder label) | `def Pi_u (u v : VelocityField) : VelocityField :=` | same object: L²-orthogonal projection off span{u}, x − (⟨v,u⟩/‖u‖²)u |
| metriplectic-world-model | `split_exists_unique` | NO MAY/JUNE NAME | — | | | no May/June Lean name; closest prose: May 20 PDF/May31 Tether.lean "TF as antisymmetric correction" to ClassicalBracket; metric part "quadratic metric correction" |
| metriplectic-world-model | `canonical_metric_bracket` | `theorem_2_3_uniqueness_of_the_minimal_correction` | MEDIUM | frohmanian-symplectic-tether-may-form/history/2026-05-31_Tether_lean/Tether_May31.lean.txt:220 — May 31 2026 (history folder label) | `theorem theorem_2_3_uniqueness_of_the_minimal_correction` | same role (uniqueness of the correction from C1–C3), but May statement is for the ANTISYMMETRIC kernel with κ=C_CZ(3) and is sorry; new theorem is the symmetric metric part up to constant c. Using the May name would change its meaning; alternative step3_degeneracy_forces_the_projection (MEDIUM-LOW, matches the C2→projection step) |
| metriplectic-world-model | `canonical_metric_bracket_sign` | `step4_feedback_coefficient_fixed_by_C3` | LOW | frohmanian-symplectic-tether-may-form/history/2026-05-31_Tether_lean/Tether_May31.lean.txt:191 — May 31 2026 (history folder label) | `lemma step4_feedback_coefficient_fixed_by_C3` | May step4 fixes the coefficient by C3 negative feedback; new lemma only gives sign c ≤ 0 |
| metriplectic-world-model | `projOff_form_symm_degen` | `c2_degeneracy` | MEDIUM-LOW | ns_snapshot_0528/Full_Proof_Skeleton.lean:66 — May 28 2026 (snapshot label) | `theorem c2_degeneracy : DegenerateWRTKineticEnergy TetherKernel := by` | May c2_degeneracy: "DegenerateWRTKineticEnergy TetherKernel" (May 28). New lemma = symmetric + degenerate for c⟨Π_u·,Π_u·⟩; also nearest: SatisfiesTheThreeConditions |
| metriplectic-world-model | `realization_of_rate` | NO MAY/JUNE NAME | — | | | no match; closest prose "Integral-Kernel Realization" (vFinal / May 21) is a different concept |
| metriplectic-world-model | `gateaux_rep_of_not_differentiable` | NO MAY/JUNE NAME | — | | | closest: FunctionalDerivative (May 31 Tether.lean:123, sorry def) |
| metriplectic-world-model | `not_streamFunctionRepresentative` | NO MAY/JUNE NAME | — | | | closest: velocity_from_vorticity / velocityFromVorticity (May 28 ArnoldGeometric.lean:30); no stream-function name found May/June |
| periodic-ns-classical-continuation | `AllHsBound` | NO MAY/JUNE NAME | — | | | closest term `comparison_majorant_global_bound` (ns_snapshot_0528/Modules/TetheredLyapunov.lean:32; shares ['bound']) — LOW, not a match |
| periodic-ns-classical-continuation | `CoefL1` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `CurveHyp` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `FourierData` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `FourierHigherRegularity` | NO MAY/JUNE NAME | — | | | closest term `full_lemma_3_1_and_unconditional_regularity_from_latex` (ns_snapshot_0528/Full_Proof_Skeleton.lean:173; shares ['regularity']) — LOW, not a match |
| periodic-ns-classical-continuation | `FourierSeriesVelocity` | NO MAY/JUNE NAME | — | | | closest term `Velocity` (ns_snapshot_0629/docs/Clarified_Degeneracy_and_Majorant_Blocks.lean:14; shares ['velocity']) — LOW, not a match |
| periodic-ns-classical-continuation | `FourierSeriesVelocitySmooth` | NO MAY/JUNE NAME | — | | | closest term `IsSmooth` (ns_snapshot_0629/NS_Millennium_Proof/Modules/GlobalRegularity.lean:107; shares ['smooth']) — LOW, not a match |
| periodic-ns-classical-continuation | `FourierSolutionReconstruction` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `GalerkinContinuation` | NO MAY/JUNE NAME | — | | | closest term `UniqueContinuationForNavierStokes` (ns_snapshot_0629/NS_Millennium_Proof/Modules/Assumptions.lean:81; shares ['continuation']) — LOW, not a match |
| periodic-ns-classical-continuation | `GalerkinLimitEquation` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `GalerkinModeConvergence` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `GalerkinModeEquiLipschitz` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `GalerkinStructurePreserved` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `GalerkinUniformBoundNS` | NO MAY/JUNE NAME | — | | | closest term `lemma_3_1_uniform_bound_and_continuation` (ns_snapshot_0528/Modules/TetheredLyapunov.lean:37; shares ['bound', 'uniform']) — LOW, not a match |
| periodic-ns-classical-continuation | `HS` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `IsFourierSolutionOn` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `IsGalerkinSolutionOn` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `IsSmoothFourierSolutionOn` | NO MAY/JUNE NAME | — | | | closest term `IsSmooth` (ns_snapshot_0629/NS_Millennium_Proof/Modules/GlobalRegularity.lean:107; shares ['smooth']) — LOW, not a match |
| periodic-ns-classical-continuation | `JReg` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `JReg.continuousOn_coeff` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `JReg.dJ` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `JReg.helm` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `JReg.iterate` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `JReg.slice` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `ModeContinuous` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `PerR` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `PerR.continuous_liftR` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `PerR.helmR` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `PerR.pdR` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `PeriodicBKMHsControl` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `PeriodicDataDivFree` | NO MAY/JUNE NAME | — | | | closest term `div` (ns_snapshot_0528/Modules/NS_Equations.lean:34; shares ['div']) — LOW, not a match |
| periodic-ns-classical-continuation | `PeriodicDataHs` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `PeriodicFourierCoeffDecay` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `PeriodicFourierCoeffODE` | NO MAY/JUNE NAME | — | | | closest term `ComparisonODE` (ns_snapshot_0528/Modules/TetheredLyapunov.lean:30; shares ['ode']) — LOW, not a match |
| periodic-ns-classical-continuation | `PeriodicFourierCommutatorBound` | NO MAY/JUNE NAME | — | | | closest term `comparison_majorant_global_bound` (ns_snapshot_0528/Modules/TetheredLyapunov.lean:32; shares ['bound']) — LOW, not a match |
| periodic-ns-classical-continuation | `PeriodicFourierHsEnergyIdentity` | NO MAY/JUNE NAME | — | | | closest term `DegenerateWRTKineticEnergy` (frohmanian-symplectic-tether-may-form/history/2026-05-31_Tether_lean/Tether_May31.lean.txt:82; shares ['energy']) — LOW, not a match |
| periodic-ns-classical-continuation | `PeriodicGalerkinLimit` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `PeriodicGalerkinUniformTime` | NO MAY/JUNE NAME | — | | | closest term `lemma_3_1_uniform_bound_and_continuation` (ns_snapshot_0528/Modules/TetheredLyapunov.lean:37; shares ['uniform']) — LOW, not a match |
| periodic-ns-classical-continuation | `PeriodicGradHsControl` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `PeriodicHsBlowupAlternative` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `PeriodicLogSobolevBKM` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `PeriodicLogSobolevBKMBound` | NO MAY/JUNE NAME | — | | | closest term `comparison_majorant_global_bound` (ns_snapshot_0528/Modules/TetheredLyapunov.lean:32; shares ['bound']) — LOW, not a match |
| periodic-ns-classical-continuation | `PeriodicLowFreqVorticityBound` | NO MAY/JUNE NAME | — | | | closest term `global_vorticity_bound` (ns_snapshot_0528/docs/frohmanian_ns_proof_chat_history.md:43; shares ['bound', 'vorticity']) — LOW, not a match |
| periodic-ns-classical-continuation | `PeriodicPressureRecovery` | NO MAY/JUNE NAME | — | | | closest term `PressureField` (ns_snapshot_0528/Modules/NS_Equations.lean:31; shares ['pressure']) — LOW, not a match |
| periodic-ns-classical-continuation | `PeriodicSupNormContinuity` | NO MAY/JUNE NAME | — | | | closest term `MollifiedSupNorm` (ns_snapshot_0629/NS_Millennium_Proof/Modules/TetheredLyapunov.lean:473; shares ['norm', 'sup']) — LOW, not a match |
| periodic-ns-classical-continuation | `PeriodicTameHsBound` | NO MAY/JUNE NAME | — | | | closest term `comparison_majorant_global_bound` (ns_snapshot_0528/Modules/TetheredLyapunov.lean:32; shares ['bound']) — LOW, not a match |
| periodic-ns-classical-continuation | `PeriodicTameHsInequality` | NO MAY/JUNE NAME | — | | | closest term `differential_inequality_after_tether_and_absorption` (ns_snapshot_0629/NS_Millennium_Proof/Modules/TetheredLyapunov.lean:493; shares ['inequality']) — LOW, not a match |
| periodic-ns-classical-continuation | `PtBound` | NO MAY/JUNE NAME | — | | | closest term `comparison_majorant_global_bound` (ns_snapshot_0528/Modules/TetheredLyapunov.lean:32; shares ['bound']) — LOW, not a match |
| periodic-ns-classical-continuation | `SmoothPer` | NO MAY/JUNE NAME | — | | | closest term `IsSmooth` (ns_snapshot_0629/NS_Millennium_Proof/Modules/GlobalRegularity.lean:107; shares ['smooth']) — LOW, not a match |
| periodic-ns-classical-continuation | `SmoothPer.continuous` | NO MAY/JUNE NAME | — | | | closest term `IsSmooth` (ns_snapshot_0629/NS_Millennium_Proof/Modules/GlobalRegularity.lean:107; shares ['smooth']) — LOW, not a match |
| periodic-ns-classical-continuation | `SmoothPer.helmOp` | NO MAY/JUNE NAME | — | | | closest term `IsSmooth` (ns_snapshot_0629/NS_Millennium_Proof/Modules/GlobalRegularity.lean:107; shares ['smooth']) — LOW, not a match |
| periodic-ns-classical-continuation | `SmoothPer.pdC` | NO MAY/JUNE NAME | — | | | closest term `IsSmooth` (ns_snapshot_0629/NS_Millennium_Proof/Modules/GlobalRegularity.lean:107; shares ['smooth']) — LOW, not a match |
| periodic-ns-classical-continuation | `abs_le_of_modeSq_le` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `barrierTime_anti` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `barrierTime_pos` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `bilOp` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `bilRaw` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `bkm_log_arith` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `bse` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `bseSum` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `charK` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `charK_add_single` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `charK_contDiff` | NO MAY/JUNE NAME | — | | | closest term `diffBy` (may30_upload/Extensions.lean:34; shares ['diff']) — LOW, not a match |
| periodic-ns-classical-continuation | `charK_eq` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `charK_hasFDerivAt` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `clay_B_exact_of_bkm` | NO MAY/JUNE NAME | — | | | closest: global_regularity_for_NS (Jun 29 GlobalRegularity.lean:134) — different hypotheses |
| periodic-ns-classical-continuation | `clay_B_exact_of_bounds` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `clay_B_exact_of_hsControl` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `clay_B_exact_of_tame_log` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `coefCurve` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `coefField` | NO MAY/JUNE NAME | — | | | closest term `EnstrophyAccumulationField` (ns_snapshot_0528/Modules/AnalyticEstimates.lean:22; shares ['field']) — LOW, not a match |
| periodic-ns-classical-continuation | `compC` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `compC_add_single` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `compC_contDiff` | NO MAY/JUNE NAME | — | | | closest term `diffBy` (may30_upload/Extensions.lean:34; shares ['diff']) — LOW, not a match |
| periodic-ns-classical-continuation | `compC_eq_liftR` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `compR` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `continuous_curlOf` | NO MAY/JUNE NAME | — | | | closest term `curl` (ns_snapshot_0528/Modules/NS_Equations.lean:35; shares ['curl']) — LOW, not a match |
| periodic-ns-classical-continuation | `continuous_single'` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `convConst` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `convTerm` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `conv_term_split` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `convective_coeff` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `convective_coord` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `coordB` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `cs_tsum` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `cterm` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `cubeCoeff` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `cubeCoeff_const_mul'` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `cubeCoeff_dt_eq` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `cubeCoeff_eq` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `cubeCoeff_helmOp` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `cubeCoeff_helmR` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `cubeCoeff_iterate_helmJ` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `cubeCoeff_iterate_helmOp` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `cubeCoeff_mul_series` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `cubeCoeff_pdC` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `cubeCoeff_pdR` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `cubeCoeff_sub'` | NO MAY/JUNE NAME | — | | | closest term `helpSubCommand` (may30_upload/Extensions.lean:58; shares ['sub']) — LOW, not a match |
| periodic-ns-classical-continuation | `cubeCoeff_sum'` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `curlOf` | `curl` | MEDIUM | ns_snapshot_0528/Modules/NS_Equations.lean:35 — May 28 2026 (snapshot label) | `def curl (u : VelocityField) : T3 → ℝ³ := sorry` | May 28 NS_Equations.lean:35 `def curl (u : VelocityField) : T3 → ℝ³ := sorry` |
| periodic-ns-classical-continuation | `curl_eq_curlOf` | NO MAY/JUNE NAME | — | | | closest term `curl` (ns_snapshot_0528/Modules/NS_Equations.lean:35; shares ['curl']) — LOW, not a match |
| periodic-ns-classical-continuation | `dJ` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `data_of_sol` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `directionalCoord_eq` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `dtCoeff` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `dtCoeff_div` | NO MAY/JUNE NAME | — | | | closest term `div` (ns_snapshot_0528/Modules/NS_Equations.lean:34; shares ['div']) — LOW, not a match |
| periodic-ns-classical-continuation | `dtCoeff_div_Ioo` | NO MAY/JUNE NAME | — | | | closest term `div` (ns_snapshot_0528/Modules/NS_Equations.lean:34; shares ['div']) — LOW, not a match |
| periodic-ns-classical-continuation | `emb` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `entry_le` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `equiv_symm_single` | NO MAY/JUNE NAME | — | | | closest term `array_as_list_equiv` (ns_snapshot_0528/Modules/DataStructures.lean:33; shares ['equiv']) — LOW, not a match |
| periodic-ns-classical-continuation | `ev` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `evOp` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `evTerm` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `evk` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `exists_bound_cubeCoeff` | NO MAY/JUNE NAME | — | | | closest term `comparison_majorant_global_bound` (ns_snapshot_0528/Modules/TetheredLyapunov.lean:32; shares ['bound']) — LOW, not a match |
| periodic-ns-classical-continuation | `fderiv_coord` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `fourierCoeffVF` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `fourierCoeffVF_continuousOn` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `fourierCoeffVF_eq_cubeCoeff` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `fourierCoeffVF_hermitian` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `fourierNSField` | NO MAY/JUNE NAME | — | | | closest term `EnstrophyAccumulationField` (ns_snapshot_0528/Modules/AnalyticEstimates.lean:22; shares ['field']) — LOW, not a match |
| periodic-ns-classical-continuation | `fourierNSField_eq` | NO MAY/JUNE NAME | — | | | closest term `EnstrophyAccumulationField` (ns_snapshot_0528/Modules/AnalyticEstimates.lean:22; shares ['field']) — LOW, not a match |
| periodic-ns-classical-continuation | `fourierNSField_eq_dtCoeff` | NO MAY/JUNE NAME | — | | | closest term `EnstrophyAccumulationField` (ns_snapshot_0528/Modules/AnalyticEstimates.lean:22; shares ['field']) — LOW, not a match |
| periodic-ns-classical-continuation | `fourier_split_bound` | NO MAY/JUNE NAME | — | | | closest term `comparison_majorant_global_bound` (ns_snapshot_0528/Modules/TetheredLyapunov.lean:32; shares ['bound']) — LOW, not a match |
| periodic-ns-classical-continuation | `fourier_split_eps` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `fourier_split_log` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `galerkinContinuation` | NO MAY/JUNE NAME | — | | | closest term `UniqueContinuationForNavierStokes` (ns_snapshot_0629/NS_Millennium_Proof/Modules/Assumptions.lean:81; shares ['continuation']) — LOW, not a match |
| periodic-ns-classical-continuation | `galerkinStructurePreserved_of` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `glueR` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `glue_contDiffOn` | NO MAY/JUNE NAME | — | | | closest term `diffBy` (may30_upload/Extensions.lean:34; shares ['diff']) — LOW, not a match |
| periodic-ns-classical-continuation | `glue_deriv` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `glue_sol` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `gradCoeff` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `gradSupNorm` | NO MAY/JUNE NAME | — | | | closest term `MollifiedSupNorm` (ns_snapshot_0629/NS_Millennium_Proof/Modules/TetheredLyapunov.lean:473; shares ['norm', 'sup']) — LOW, not a match |
| periodic-ns-classical-continuation | `gradSupNorm_nonneg` | NO MAY/JUNE NAME | — | | | closest term `MollifiedSupNorm` (ns_snapshot_0629/NS_Millennium_Proof/Modules/TetheredLyapunov.lean:473; shares ['norm', 'sup']) — LOW, not a match |
| periodic-ns-classical-continuation | `grad_tail_le` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `gronwall_of_hasDerivAt` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `hasDerivAt_coeff_time` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `hasDerivAt_normSq_complex` | NO MAY/JUNE NAME | — | | | closest term `MollifiedSupNorm` (ns_snapshot_0629/NS_Millennium_Proof/Modules/TetheredLyapunov.lean:473; shares ['norm']) — LOW, not a match |
| periodic-ns-classical-continuation | `hasSum_grad` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `helmJ` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `helmOp` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `helmR` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `helmR_slice` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `hsNormField_extendG_mono` | NO MAY/JUNE NAME | — | | | closest term `EnstrophyAccumulationField` (ns_snapshot_0528/Modules/AnalyticEstimates.lean:22; shares ['field']) — LOW, not a match |
| periodic-ns-classical-continuation | `hsNorm_le_of_hsSq_le` | NO MAY/JUNE NAME | — | | | closest term `MollifiedSupNorm` (ns_snapshot_0629/NS_Millennium_Proof/Modules/TetheredLyapunov.lean:473; shares ['norm']) — LOW, not a match |
| periodic-ns-classical-continuation | `hsSq` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `hsSq_eq_tsum` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `hsSq_nonneg` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `hs_bound_of_galerkin` | NO MAY/JUNE NAME | — | | | closest term `comparison_majorant_global_bound` (ns_snapshot_0528/Modules/TetheredLyapunov.lean:32; shares ['bound']) — LOW, not a match |
| periodic-ns-classical-continuation | `insertNth_one_eq` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `integrableOn_coeff` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `integrableOn_cube_of_continuous` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `integral_le_of_nonneg` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `integral_pdC_eq_zero` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `jreg_decay` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `jreg_dt` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `jreg_u` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `laplacian_coord` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `lerayLin` | NO MAY/JUNE NAME | — | | | closest term `leray_projector_commutation` (ns_snapshot_0528/Full_Proof_Skeleton.lean:121; shares ['leray']) — LOW, not a match |
| periodic-ns-classical-continuation | `lerayOp` | NO MAY/JUNE NAME | — | | | closest term `leray_projector_commutation` (ns_snapshot_0528/Full_Proof_Skeleton.lean:121; shares ['leray']) — LOW, not a match |
| periodic-ns-classical-continuation | `leray_solve` | NO MAY/JUNE NAME | — | | | closest term `leray_projector_commutation` (ns_snapshot_0528/Full_Proof_Skeleton.lean:121; shares ['leray']) — LOW, not a match |
| periodic-ns-classical-continuation | `liftR` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `liftR_add_single` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `liftR_contDiff` | NO MAY/JUNE NAME | — | | | closest term `diffBy` (may30_upload/Extensions.lean:34; shares ['diff']) — LOW, not a match |
| periodic-ns-classical-continuation | `lin` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `linS` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `lipC` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `lowGrad` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `lowGradSup` | NO MAY/JUNE NAME | — | | | closest term `MollifiedSupNorm` (ns_snapshot_0629/NS_Millennium_Proof/Modules/TetheredLyapunov.lean:473; shares ['sup']) — LOW, not a match |
| periodic-ns-classical-continuation | `lowGrad_eq` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `lowGrad_norm_le` | NO MAY/JUNE NAME | — | | | closest term `MollifiedSupNorm` (ns_snapshot_0629/NS_Millennium_Proof/Modules/TetheredLyapunov.lean:473; shares ['norm']) — LOW, not a match |
| periodic-ns-classical-continuation | `mFourier_torusMk` | NO MAY/JUNE NAME | — | | | closest term `integration_by_parts_on_torus` (ns_snapshot_0629/docs/Clarified_Degeneracy_and_Majorant_Blocks.lean:29; shares ['torus']) — LOW, not a match |
| periodic-ns-classical-continuation | `mkL1` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `modeSq` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `modeSq_add_le` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `modeSq_nonneg` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `mulOp` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `nlField` | NO MAY/JUNE NAME | — | | | closest term `EnstrophyAccumulationField` (ns_snapshot_0528/Modules/AnalyticEstimates.lean:22; shares ['field']) — LOW, not a match |
| periodic-ns-classical-continuation | `nonlinCoeff` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `norm_charK` | NO MAY/JUNE NAME | — | | | closest term `MollifiedSupNorm` (ns_snapshot_0629/NS_Millennium_Proof/Modules/TetheredLyapunov.lean:473; shares ['norm']) — LOW, not a match |
| periodic-ns-classical-continuation | `norm_cubeCoeff_le` | NO MAY/JUNE NAME | — | | | closest term `MollifiedSupNorm` (ns_snapshot_0629/NS_Millennium_Proof/Modules/TetheredLyapunov.lean:473; shares ['norm']) — LOW, not a match |
| periodic-ns-classical-continuation | `norm_gradCoeff` | NO MAY/JUNE NAME | — | | | closest term `MollifiedSupNorm` (ns_snapshot_0629/NS_Millennium_Proof/Modules/TetheredLyapunov.lean:473; shares ['norm']) — LOW, not a match |
| periodic-ns-classical-continuation | `norm_le_aux` | NO MAY/JUNE NAME | — | | | closest term `MollifiedSupNorm` (ns_snapshot_0629/NS_Millennium_Proof/Modules/TetheredLyapunov.lean:473; shares ['norm']) — LOW, not a match |
| periodic-ns-classical-continuation | `nsOp` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `opNorm_le_entries` | NO MAY/JUNE NAME | — | | | closest term `MollifiedSupNorm` (ns_snapshot_0629/NS_Millennium_Proof/Modules/TetheredLyapunov.lean:473; shares ['norm']) — LOW, not a match |
| periodic-ns-classical-continuation | `pdC` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `pdC_compC` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `pdC_liftR` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `pdR` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `pdR_slice` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `perR_coord` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `perR_of` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `periodicBKMCriterion_of_hsControl` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `periodicBKMHsControl_of_bounds` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `periodicBKMHsControl_of_coeff_lowFreq` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `periodicBKMHsControl_of_commutator_lowFreq` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `periodicBKMHsControl_of_fourier_lowFreq` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `periodicBKMHsControl_of_tame_log` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `periodicBKMHsControl_of_tame_lowFreq` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `periodicDataDivFree` | NO MAY/JUNE NAME | — | | | closest term `div` (ns_snapshot_0528/Modules/NS_Equations.lean:34; shares ['div']) — LOW, not a match |
| periodic-ns-classical-continuation | `periodicDataHs` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `periodicFourierCoeffDecay` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `periodicFourierCoeffODE` | NO MAY/JUNE NAME | — | | | closest term `ComparisonODE` (ns_snapshot_0528/Modules/TetheredLyapunov.lean:30; shares ['ode']) — LOW, not a match |
| periodic-ns-classical-continuation | `periodicFourierHsEnergyIdentity` | NO MAY/JUNE NAME | — | | | closest term `DegenerateWRTKineticEnergy` (frohmanian-symplectic-tether-may-form/history/2026-05-31_Tether_lean/Tether_May31.lean.txt:82; shares ['energy']) — LOW, not a match |
| periodic-ns-classical-continuation | `periodicFourierHsEnergyIdentity_of_coeff` | NO MAY/JUNE NAME | — | | | closest term `DegenerateWRTKineticEnergy` (frohmanian-symplectic-tether-may-form/history/2026-05-31_Tether_lean/Tether_May31.lean.txt:82; shares ['energy']) — LOW, not a match |
| periodic-ns-classical-continuation | `periodicGalerkinLimit_of_velocity_pressure` | NO MAY/JUNE NAME | — | | | closest term `PressureField` (ns_snapshot_0528/Modules/NS_Equations.lean:31; shares ['pressure']) — LOW, not a match |
| periodic-ns-classical-continuation | `periodicGalerkinUniformTime_of_gt` | NO MAY/JUNE NAME | — | | | closest term `lemma_3_1_uniform_bound_and_continuation` (ns_snapshot_0528/Modules/TetheredLyapunov.lean:37; shares ['uniform']) — LOW, not a match |
| periodic-ns-classical-continuation | `periodicGalerkinUniformTime_of_gt'` | NO MAY/JUNE NAME | — | | | closest term `lemma_3_1_uniform_bound_and_continuation` (ns_snapshot_0528/Modules/TetheredLyapunov.lean:37; shares ['uniform']) — LOW, not a match |
| periodic-ns-classical-continuation | `periodicGradHsControl` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `periodicGradHsControl_of_bound` | NO MAY/JUNE NAME | — | | | closest term `comparison_majorant_global_bound` (ns_snapshot_0528/Modules/TetheredLyapunov.lean:32; shares ['bound']) — LOW, not a match |
| periodic-ns-classical-continuation | `periodicHsBlowupAlternative` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `periodicLocalExistence_of_nonneg` | `local_existence` | MEDIUM | ns_snapshot_0528/Modules/NS_Equations.lean:45 — May 28 2026 (snapshot label) | `theorem local_existence` | May 28 NS_Equations.lean:45 is Kato local existence (stub); new is periodic Galerkin proof |
| periodic-ns-classical-continuation | `periodicLocalSolution_quant` | NO MAY/JUNE NAME | — | | | closest term `local_existence` (ns_snapshot_0528/Modules/NS_Equations.lean:45; shares ['local']) — LOW, not a match |
| periodic-ns-classical-continuation | `periodicLogSobolevBKMBound_of_lowFreq` | NO MAY/JUNE NAME | — | | | closest term `comparison_majorant_global_bound` (ns_snapshot_0528/Modules/TetheredLyapunov.lean:32; shares ['bound']) — LOW, not a match |
| periodic-ns-classical-continuation | `periodicSupNormContinuity` | NO MAY/JUNE NAME | — | | | closest term `MollifiedSupNorm` (ns_snapshot_0629/NS_Millennium_Proof/Modules/TetheredLyapunov.lean:473; shares ['norm', 'sup']) — LOW, not a match |
| periodic-ns-classical-continuation | `periodicTameHsInequality_of_fourier` | NO MAY/JUNE NAME | — | | | closest term `differential_inequality_after_tether_and_absorption` (ns_snapshot_0629/NS_Millennium_Proof/Modules/TetheredLyapunov.lean:493; shares ['inequality']) — LOW, not a match |
| periodic-ns-classical-continuation | `phase` | NO MAY/JUNE NAME | — | | | closest term `phase_plane_analysis_of_majorant_ODE` (ns_snapshot_0629/NS_Millennium_Proof/Modules/TetheredLyapunov.lean:750; shares ['phase']) — LOW, not a match |
| periodic-ns-classical-continuation | `phaseCLM` | NO MAY/JUNE NAME | — | | | closest term `phase_plane_analysis_of_majorant_ODE` (ns_snapshot_0629/NS_Millennium_Proof/Modules/TetheredLyapunov.lean:750; shares ['phase']) — LOW, not a match |
| periodic-ns-classical-continuation | `phaseCLM_apply` | NO MAY/JUNE NAME | — | | | closest term `phase_plane_analysis_of_majorant_ODE` (ns_snapshot_0629/NS_Millennium_Proof/Modules/TetheredLyapunov.lean:750; shares ['phase']) — LOW, not a match |
| periodic-ns-classical-continuation | `phaseCLM_single` | NO MAY/JUNE NAME | — | | | closest term `phase_plane_analysis_of_majorant_ODE` (ns_snapshot_0629/NS_Millennium_Proof/Modules/TetheredLyapunov.lean:750; shares ['phase']) — LOW, not a match |
| periodic-ns-classical-continuation | `phase_mul_charK` | NO MAY/JUNE NAME | — | | | closest term `phase_plane_analysis_of_majorant_ODE` (ns_snapshot_0629/NS_Millennium_Proof/Modules/TetheredLyapunov.lean:750; shares ['phase']) — LOW, not a match |
| periodic-ns-classical-continuation | `phase_shift` | NO MAY/JUNE NAME | — | | | closest term `phase_plane_analysis_of_majorant_ODE` (ns_snapshot_0629/NS_Millennium_Proof/Modules/TetheredLyapunov.lean:750; shares ['phase']) — LOW, not a match |
| periodic-ns-classical-continuation | `pressLin` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `pressOp` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `pressureCoeff` | NO MAY/JUNE NAME | — | | | closest term `PressureField` (ns_snapshot_0528/Modules/NS_Equations.lean:31; shares ['pressure']) — LOW, not a match |
| periodic-ns-classical-continuation | `pressureGradient_coord` | NO MAY/JUNE NAME | — | | | closest term `PressureField` (ns_snapshot_0528/Modules/NS_Equations.lean:31; shares ['pressure']) — LOW, not a match |
| periodic-ns-classical-continuation | `rateOf` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `rate_term_le` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `reVec` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `seriesC` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `seriesPressure` | NO MAY/JUNE NAME | — | | | closest term `PressureField` (ns_snapshot_0528/Modules/NS_Equations.lean:31; shares ['pressure']) — LOW, not a match |
| periodic-ns-classical-continuation | `seriesVelocity` | NO MAY/JUNE NAME | — | | | closest term `Velocity` (ns_snapshot_0629/docs/Clarified_Degeneracy_and_Majorant_Blocks.lean:14; shares ['velocity']) — LOW, not a match |
| periodic-ns-classical-continuation | `shift_sol` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `smoothPer_iterate_helmOp` | NO MAY/JUNE NAME | — | | | closest term `IsSmooth` (ns_snapshot_0629/NS_Millennium_Proof/Modules/GlobalRegularity.lean:107; shares ['smooth']) — LOW, not a match |
| periodic-ns-classical-continuation | `sobW_add_le` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `sobW_mul_sobW` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `sol_around` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `sq_term_le` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `summable_mode_mul_coeff` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `summable_prod_fin3` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `summable_sobW_cubeCoeff` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `supNorm_continuousOn` | NO MAY/JUNE NAME | — | | | closest term `MollifiedSupNorm` (ns_snapshot_0629/NS_Millennium_Proof/Modules/TetheredLyapunov.lean:473; shares ['norm', 'sup']) — LOW, not a match |
| periodic-ns-classical-continuation | `tailWeight` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `tailWeight_le_rpow` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `tailWeight_tendsto_zero` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `torusComp` | NO MAY/JUNE NAME | — | | | closest term `integration_by_parts_on_torus` (ns_snapshot_0629/docs/Clarified_Degeneracy_and_Majorant_Blocks.lean:29; shares ['torus']) — LOW, not a match |
| periodic-ns-classical-continuation | `torusCompC` | NO MAY/JUNE NAME | — | | | closest term `integration_by_parts_on_torus` (ns_snapshot_0629/docs/Clarified_Degeneracy_and_Majorant_Blocks.lean:29; shares ['torus']) — LOW, not a match |
| periodic-ns-classical-continuation | `torusMk` | NO MAY/JUNE NAME | — | | | closest term `integration_by_parts_on_torus` (ns_snapshot_0629/docs/Clarified_Degeneracy_and_Majorant_Blocks.lean:29; shares ['torus']) — LOW, not a match |
| periodic-ns-classical-continuation | `u_zero` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `unw` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `vecS` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `viscMul` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `viscOp` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `visc_term_nonpos` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `vpWeight` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
| periodic-ns-classical-continuation | `wt` | NO MAY/JUNE NAME | — | | | no related May/June term — LOW, not a match |
