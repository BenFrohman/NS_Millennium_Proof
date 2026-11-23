# Two-layer T³ test and the combination question: results (Nov 16, 2026, America/Chicago)

Local only. Nothing was pushed, merged, staged or published, and no originals were modified.
Files: `two-layer-reconstruction.md`, `sympy/checks.{py,log}`, `sim/ns_sim.{py,log}`, `lean/` (TwoLayerT3),
`CERTIFICATE.md`, `truth-gate.lock.json`, the build logs, and `sources/` (copies plus SHA256SUMS).

## 1. Reconstruction (details and quotes are in two-layer-reconstruction.md)
- Layer 1 (KKS, Lie–Poisson, tether B_F): the sink appears only as axiom (A5), "negative quadratic feedback … with
  coefficient fixed by exact matching", and the coefficient is fixed by assertion (κ = C_CZ(3) = 3/2). A5 is
  inconsistent with the paper's own (A3), B(F,H) ≡ 0. The author's own text says Layer 1 "does not directly prove
  regularity" and "the tether supplies only the motivational form of the quartic weighting" (Full_Living_May24).
- Layer 2 (unmodified NS): the sink enters in one sentence (Full_Living_May24 §3), "Young's inequality … absorbs the
  positive stretching contribution into the leading negative quartic term −(κ/2)∫|ω_ε|⁶". No file derives that term.
  With the stated functional S_ε = ∫(½|ω_ε|² + (κ/4)|ω_ε|⁴φ_ε) and Dφ/Dt = +|ω|², the φ-term actually contributes
  +(κ/4)∫|ω|⁶ at t = 0. That is a source, not a sink (Lean `phi_term_source`). The May 28 Lean skeleton has the step
  only as a comment plus `sorry`. The later ns-proof-written.tex asserts it ("What remains is a cubic sink"). The
  Oct 28 paper correctly calls it an open conjecture.
- No April 2026 material exists. The earliest dated tether files are on Drive, May 14, 2026.

## 2. IBP check (sympy, exact, generic u)
ω·∂ₜω − [ω·Sω − u·∇(½|ω|²) + ν(Δ(½|ω|²) − |∇ω|²)] = 0, an identity. On T³ with div u = 0 this gives
d/dt ½‖ω‖² = ∫ω·Sω − ν‖∇ω‖². No other term appears: no B_F term and no −κ|ω|⁴ or −κ''‖ω‖³_{L∞} term.
Explicit fields (half the enstrophy, ½‖ω‖²_{L²} = ½∫|ω|²; ∫ω·Sω = 0 at t = 0 for all four fields):
| field | ½‖ω(0)‖²_{L²} | ‖∇ω(0)‖²_{L²} | d/dt ½‖ω‖²_{L²} at t=0 (NS) | (κ/4)∫|ω|⁶ (φ-term, t=0) |
|---|---|---|---|---|
| A·U (Nov 9) | 40π³A² | 88π³A² | −88π³νA² | 19627π³κA⁶/2 |
| Taylor–Green | 3π³A² | 18π³A² | −18π³νA² | 1113π³κA⁶/256 |
| ABC(1,1,1) | 12π³A² | 24π³A² | −24π³νA² | 108π³κA⁶ |
| shear (sin y,0,0) | 2π³A² | 4π³A² | −4π³νA² | 5π³κA⁶/8 |

## 3. Constants verdict (reuses /workspace/tetherrate-verify-2026-11-16/REPORT.md, re-derived here)
- Constants depending only on ν: **refuted.**
  - L∞ norm: ‖ω(0)‖_{L∞} = 6A and the touching slope is 6A(A−ν). For every ν, C, κ'' > 0, the amplitude
    A = ν + 1 + |C|/κ'' violates d/dt ‖ω‖_{L∞} ≤ C‖ω‖²_{L∞} − κ''‖ω‖³_{L∞} (Lean `cubic_rate_amplitude`; touching argument from KeyEstimateRefutation, Nov 9).
  - Enstrophy d/dt(½‖ω‖²_{L²})|₀ − (C(½‖ω(0)‖²_{L²})² − κ''(½‖ω(0)‖²_{L²})³) = 64000π⁹κ''A⁶ − 1600π⁶CA⁴ − 88π³νA², which is > 0 for large A
    (algebra in Lean `enstrophy_rate_amplitude`; the integral values come from sympy and are not kernel-checked).
- Constants depending on ν and the energy: refuted by the localized family (Nov 9 report, Arb certificate).
- Constants depending on the datum: **open.** For all data this is periodic Clay (B).

## 4. Simulations (pseudo-spectral, 64³, 2/3 dealiasing, RK4, dt = 2e-3, ν = 0.05, T = 2; all runs completed)
- A·U, A=1: ‖ω‖_{L∞} 6.00 → max 9.04 (t=1.68). The paper's constants C = κ'' = 3/2 are violated: max of d/dt ‖ω‖_{L∞} − (C‖ω‖²_{L∞} − κ''‖ω‖³_{L∞}) is 986.
- A·U, A=3: ‖ω‖_{L∞} 18 → 178 (t=1.76). Resolution is marginal at the peak (k_max·η ≈ 1), so treat the numbers as qualitative.
- Taylor–Green, A=3: ‖ω‖_{L∞} 6.00 → 8.09. C = κ'' = 3/2 is violated (max gap 697).
- Data-dependent constants can always be fitted after the fact. For example, with κ'' = 0.01 the needed C is
  0.22 (A·U, A=1), 1.78 (A·U, A=3) and 0.32 (TG). So the runs cannot decide the open case.
- Check: the computed ½‖ω(0)‖²_{L²} = 1240.25 matches 40π³ exactly.

## 5. Combination verdict under the Truth Gate (kernel-decided where stated)
Question: does the metriplectic tether correction vanish on real NS solutions, so that real NS satisfies the tethered dynamics?
- **Reading used by the papers** (δH/δμ = u; Full_Living_May24 §7.1, "X_H^{T_F} = X_H^classical exactly"), both
  kernel formulas: **PASS, the correction vanishes, and kernel-proved.** B_F(·,H) ≡ 0 on every state, so also on every
  NS solution (`tether_degenerate`, `tether_degenerate_L2`, `kernelB_degenerate`). Real NS solutions therefore satisfy
  dF/dt = {F,H} + B_F(F,H) + [F,H]_diss exactly (`metriplectic_rate_tether_drops`).
  **But the correction vanishes because it is identically zero along the H-flow.** It adds exactly 0 to dM/dt and
  dE/dt. The locked paper claim, that B_F leaves a strict sink in the rate (ns-proof-written.tex, sha256 72b18b97…),
  is **kernel-proved equivalent to False** (`intended_correspondence : formal_claim ↔ paper_claim` with
  formal_claim := False, `paper_claim_refuted`). The tethered model's regularity question is therefore literally the
  unmodified NS question. The combination step adds no regularity.
- If NS is read as the Hamiltonian flow of H for T_F alone (Thm 2.1(1) literally, with no separate dissipative
  bracket): **FAIL, kernel-proved.** The two vector fields differ by νΔu, and νΔ(A·U)(π/2,0,0) = (2νA, −3νA, 0) ≠ 0
  (`viscous_difference_value`, `viscous_difference_ne_zero`).
- Vorticity-derivative reading (δH/δω = vector potential a, with curl a = u): **the correction does not vanish
  (FAIL).** Exact values: B_F(E,H) = −1548π³κA⁴ for A·U, −45π³κA⁴/16 for TG, −3π³κA⁴ for shear, and 0 for ABC
  (Beltrami, where a ∥ u). Kernel-proved: B_F(·,a) ≡ 0 ⇔ Π_u a = 0 (`tether_degenerate_iff`), and for A·U the field a
  is not a pointwise multiple of u, since a(0) = (0,0,6A) and u(0) = 0 (`a_not_multiple_of_u`, `curl_a`). Not yet in
  the kernel: the T³ integrals, and the step from "continuous a ∉ span{u} pointwise" to "Π_u a ≠ 0 in L²". In this
  reading the tether changes the Euler part, so real NS solutions do not satisfy the tethered dynamics.
- Truth Gate status: the lock passes its local checks (0 sorry, standard axioms, no alias, no rfl correspondence,
  quote and sha256 present). The transcription of paper_claim still **needs your approval** (`truth-gate.lock.json`,
  approver PENDING).

## 6. What this says about the real world
Real NS solutions satisfy the tethered metriplectic dynamics only in the reading where the tether is zero, and so
it can supply no damping. In every reading where the tether is nonzero, real NS solutions do not follow the tethered
dynamics. In neither case does the tether give a −κ''‖ω‖³_{L∞} sink for real fluids.

## 7. The single open step
For unmodified NS on T³ with ν > 0: for every smooth, divergence-free, mean-zero u₀, find C, κ'' > 0 (they may depend
on u₀) with D⁺‖ω‖_∞ ≤ C‖ω‖_∞² − κ''‖ω‖_∞³ on the maximal interval. For all u₀ this is periodic Clay (B). It is open,
and nothing here proves it.
