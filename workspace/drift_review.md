# Drift / correctness review — Drive NS-tether editions vs. /workspace/tether-may-form rebuild
Reference (verified rebuild): tetF SYMMETRIC, degenerate on energy; dissF ≤ 0; Jacobi only for antisymmetric (Poisson) part; `symPart_not_cochain`; Riccati y' ≤ Cy² − κ''y³, ceiling max(y0, C/κ''); κ = S (Route A), no numeric value; 4/3 only as Young exponent after N ≤ A·G^{1/4}L^{3/2}; plain NS untouched (IsTrueNS = IsTetheredNS only at κ=0).
Status: consistent / drift / false / unverifiable. Dates are Drive dates (CDT).

| Edition (date) | Claim (quote) | Status |
|---|---|---|
| a07 ArXiv9 (2026-08-05) | "Antisymmetry of B follows at once from the symmetry" | false (self-contradictory; rebuild B symmetric) |
| a11 main_0707 (07-07) | "bilinear antisymmetric correction"; "forces κ = 1"; "dt Mε ≤ C − Mε²" | false / drift / drift |
| a11, b02, b04 Leg1, b05, b08 Global_Regularity, c06, c10 "42", c13 NS_Polished (May–Jul) | "forces κ = 1"; Riccati C − M²; "Lie-algebra cocycle identity δξ⟨ω,ω⟩ = 0" | drift (κ), drift (Riccati), false (invariance ≠ CE cocycle) |
| a12 Preprint_v1, b09, b11, b13, v5, v6 (May–Aug) | B "bilinear antisymmetric"; κ = C_CZ(3) | false / drift (no derivation) |
| b15 / c01 GotItNavier (identical) | "B(F,G) = −κ∫|ω|²(δF·δG)" (unprojected); called antisymmetric | false (form is symmetric) |
| b06 Clay_Submission_v20260519 (05-19) | "C_CZ(3) ≤ (3/2)√3 ≈ 2.598 (sharp bound from Stein…)", "κ'' ≥ 0.312" | arithmetic ok; sharpness unverifiable/false |
| b14 Explicit_Absorption | "unconditional, non-circular, and satisfies all Clay Institute requirements"; κ' = κ/2 − C_univ | false |
| z1/z2 files-1c7155d2 (05-16 01:12 / 13:48) | gaps table: "No explicit closed-form … antisymmetric bilinear form" | consistent (honest gap) |
| z2 (05-16) | Hölder ‖ω‖³_{L³} ≤ b^{3/4}(2π)^{3/4}; Young → δb + C M⁸ (implicit (4/3,4) pairing) | consistent as estimate; closest 4/3 analogue |
| z2 (05-16) | "M' ≤ CM² − κ'''M⁴" ... "contradicts BKM" | drift (quartic vs cubic); false logic for plain NS |
| a05 Tether_v2 (10-24) | "B(F,G) = −κ∫|ω|²⟨Π_u δF, Π_u δG⟩", "κ = C_CZ(3) = 3/2 (Lean: kappa_eq_three_halves)" | B consistent (symmetric); κ=3/2 drift (rebuild κ=S) |
| a05 | lists both "tetherKernel_symmetric" and "A1 Antisymmetric uniqueness … Proved axiom-clean" | false (inconsistent) |
| a05 | "Reduced 9-term Jacobi … conditional on cyclic cocycle" | consistent as conditional; Jacobi only needed for Poisson part |
| a05 | "A5/C3 ProducesControllableNegativeFeedback Proved axiom-clean" | unverifiable/circular (assumes conclusion) |
| a05 | hyp hCZ ‖∇u‖∞ ≤ C_CZ‖ω‖∞ | false as universal bound (Riesz not L∞-bounded) |
| readable1/2.tex, readable copy (Oct) | "stand-in κ=1 is not the matched coefficient", B_F symmetric, not KKS, y' ≤ Cy² − κ''y³ | consistent (κ=3/2 still drift) |
| Lean `tethered_jacobi_identity` (prior) | Jacobi "proved" | false/vacuous hypothesis |
| Screenshots 05-10…05-17 (Grok/Overleaf "Master Issues List") | "If B(F,H)=0, the vector field X_H is unmodified"; "rendering the improvement in the Riccati bound impossible"; "CRITICAL gaps (non-antisymmetric correction term…)"; "matching argument fixing k = 1" | consistent — same degeneracy/symmetry problems the rebuild resolves via metriplectic split |
| Screenshots | "Master Issues Tracker contains zero open issues … proof is declared complete" | false for plain NS |
| 06_negfb, 08_shear diagrams; a06 grok_report; a10 Key_Diagrams (OCR) | "2-Cocycle Closure d'B = 0", "Antisymmetric" | false (symmetric B not a CE cochain) |

## Repetition / memory / mastery; 4/3
- "memory": only TeX log ("594246 words of memory out of 5000000") in screenshots, and ETH Conflict-Clause paper (a02–a04, "memory saturation") — unrelated.
- "master": only "Master Issues List / MASTER SYSTEM PROMPT" (prompt workflow), not mastery theory. "repetition": 0 hits.
- 4/3: no explicit occurrence in any file; only implicit Young pairing in z2.
- No Félix Robles material included.
