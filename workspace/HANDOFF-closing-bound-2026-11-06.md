# Handoff to Grok Bot (31a01ff2-53c8-416d-a26d-6357c202aaf3): attempt the open analytic rate / closing bound
Requested by Benjamin Frohman (pt191u), Nov 6 2026. This brief is a research handoff. It does NOT authorize any push, publish, Zenodo action, PR, or contact with other bots. Benjamin must give an explicit yes before any of those.
Baseline: Zenodo v4 https://doi.org/10.5281/zenodo.23990195 (conditional/obstruction scope only). Repo https://github.com/BenFrohman/frohmanian-tether-geometric, published commit 9e40ae7.

## 0. Repos (read-only; work in a scratch copy)
- /workspace/frohmanian-tether-sdiff — branch gateaux-pairing, tip b740838 (= 9e40ae7 + 440 lines: DirectionCondition, VorticityL6Bound, NAMING). Origin is geometric.
- /workspace/tether-closing — branch closing-bound, tip 2764203 (CLOSING_BOUND.md). Has older sorry/True files.
- /workspace/NS_Millennium_Proof — main, 89faf8d (legacy; sorry-heavy).
- Toolchain leanprover/lean4:v4.30.0-rc1, Mathlib v4.30.0-rc1, single lib `FrohmanianTether`.
- Reproduce: `cp -r /workspace/frohmanian-tether-sdiff /tmp/fts && cd /tmp/fts && lake exe cache get && lake build` then `lake env lean scripts/AxiomAudit.lean`. Also run `python3 scripts/hweight_plausibility_check.py`.

## 1. Exact targets (all paths are under frohmanian-tether-sdiff/FrohmanianTether)
- `FrohmanianTetherRate u₀ ν` — SymplecticTether.lean:752-764. For all u, p with 0<ν, NS_PDE u p ν, u 0 = u₀, IsPhysicalNSSolution u, there exist C, κ''>0 **chosen after u, so per-solution**, such that for all s≥0: M is differentiable at s, M'(s) ≤ C M² − κ'' M³, M is continuous, and the sup is BddAbove. Here M(t) = vorticity_sup_norm (vorticity (u t)) = ⨆ₓ ‖ω(t,x)‖. This is the **sup-vorticity** quantity, not enstrophy.
- `FrohmanianTetherBound u₀ ν` — SymplecticTether.lean:740-746: for each solution there is a Y with sup_{τ≥0} M(τ) ≤ Y, plus continuity and BddAbove. This is also sup-vorticity.
- `FrohmanianTetherClosingBound ν` — ClayStatements.lean:47-51. It requires FrohmanianTetherBound for every smooth, div-free, L² datum on `T3`. Note that `T3 := EuclideanSpace ℝ (Fin 3)` (NS_Equations.lean:64), which is ℝ³, not a torus.
- `PeriodicTetherClosingBound ν` — ClayStatements.lean:568-573. For every smooth, div-free, ℤ³-periodic u₀, ∃Y (chosen before T and the solution) such that every IsPeriodicSmoothSolutionOn ν T u₀ u p has M(t) ≤ Y on [0,T). Sup-vorticity.
- `PeriodicBKMContinuation` :580, `ClassicalPeriodicBKM` :615, `ClayBClosingBound` :618 (= ∀ν>0, PeriodicTetherClosingBound ν). `clay_B_exact_of_closing_bound` :622 and `clay_B_exact_of_periodic_tether_bound` :592 prove one direction only. `Clay_B_exact` is defined at :250.
- `PeriodicDirectionDepletionBound` — HighSetDepletionAndBKM.lean:192 (cubic-ceiling form). It implies the closing bound at :206.
- Enstrophy: `ArnoldGeometric.Enstrophy` (ArnoldGeometric.lean:212) is defined on a `CoadjointOrbit` and is used as a weight in TetherKernel. Never substitute it for M.
- PDE predicate: `NS_PDE` = `navier_stokes_eq` (NS_Equations.lean:2235); vorticity transport is at :2238 (needs VorticityTransportRegularity); `IsPhysicalNSSolution` is at :2259 (pointwise time-differentiability, continuity, L², energy non-increase, constant for t≤0). These are the **unmodified** NS equations. The tether is a separate bracket/kernel (TetherKernel, SymplecticTether ~:700-725), and the kernel lemma there bounds stretching **+** TetherKernel, not stretching alone.
- Consumers: ConditionalRegularity.lean:83 (`hDI`, frohmanian_tether_theorem), :214 (`hRiccati`); Combined.lean:112; ClosureBlueprint.lean:269; TetheredLyapunov.lean:1821/1828.
- Obstruction: ObstructionAudit.lean:35-75 (flow_contribution_zero_of_C2, bilin_kernel_of_nonpos_of_self_zero, energy_conservation_not_C2); HWEIGHT_OBSTRUCTION.md (repo root); VorticityL6Bound.lean:19.
- Name clash to watch: `vorticity_sup_norm` is defined twice, at NS_Equations.lean:2802 and ConditionalRegularity.lean:184 (an alias). Confirm which one each statement resolves to.

## 2. Bottleneck already visible from the definitions (check this first)
(a) **Scaling.** Under u_λ = λu(λx, λ²t), M scales like λ², M' and M² like λ⁴, and M³ like λ⁶. This is a scaling diagnostic, not a contradiction or non-derivability proof: check the transformation and units of every constant and the domain before drawing conclusions. Because C and κ'' are existential per solution, the Rate is effectively: M is differentiable and M'/M² + κ''M is bounded above. With the required regularity and initial-value conditions, ODE comparison should give M ≤ max(M₀, C/κ''); verify those conditions. Do not infer a converse.
(b) **Differentiability.** ⨆ₓ‖ω‖ is in general only Lipschitz/Dini-differentiable for smooth solutions, for example when two local maxima cross. The `DifferentiableAt` conjunct is therefore likely false even for global smooth solutions. Concrete lemma to attempt first: build an explicit smooth periodic (or ℝ³ heat-like/Stokes) NS solution, such as a superposition of two shear/Kolmogorov modes with different decay rates, whose M(t) has a corner. If that works, the Rate as stated is **false**, independent of Clay. Report it as a counterexample and do not repair it silently. A Dini-derivative variant (D⁺M ≤ …) would be a changed target and needs Benjamin's OK.
(c) **Bound vs Clay.** ClosingBound + BKM ⇒ Clay B is proved in one direction. Clay B ⇒ ClosingBound is NOT proved, and must not be assumed: global smooth existence by itself does not state the needed uniform-in-time quantitative bound; analyze separately any decay or smoothing implications. Do not claim equivalence.
(d) **C2.** For symmetric C2, T(M,H) = 0. δH = ψ (stream function), not u. Π_u kills δE ∝ u. A negative T(F,F) is not a damping term for H or for unmodified NS. Any damping produced by the tether belongs to the modified flow.

## 3. Ordered steps
1. Build and audit: run `lake build` and `#print axioms` for frohmanian_tether_theorem, clay_B_exact_of_closing_bound, and the ObstructionAudit lemmas. List every sorryAx, axiom (for example tether-closing Assumptions.lean:85 UniqueContinuationForNavierStokes), and `: True` placeholder (tether-closing TetheredLyapunov.lean:912-946, 1548-1564) on any path you plan to use. Do not use them.
2. True NS vs modified flow: confirm that every hypothesis in the target quantifies over NS_PDE solutions of the unmodified equation, and that no tether term enters NS_PDE.
3. Derive identities with established norms only: ∂ₜω + u·∇ω = ω·∇u + νΔω; the enstrophy identity ½d/dt‖ω‖₂² = ∫ω·Sω − ν‖∇ω‖₂²; and the sup-point inequality D⁺M ≤ ⟨ξ,Sξ⟩M at the argmax (with the Δ term ≤ 0 there). Investigate established logarithmic strain estimates and finite-p Calderón–Zygmund estimates; derive their exact domain, exponent range, low-frequency/energy terms and regularity assumptions from a verified source rather than treating a schematic formula as proved. Track every constant and its ν, domain, and time dependence.
4. Test any candidate estimate on nonzero data: scaling, high-frequency/concentration (Burgers vortex, Lamb–Oseen, shear layers; see HWEIGHT_OBSTRUCTION.md numbers), regularity of the max point, and whether constants depend on t or on the solution.
5. Attempt the concrete lemma in §2(b) (counterexample to differentiability) and, separately, the strongest honest true statement, e.g. "Rate with Dini derivative ⇔ Bound + local differential bound" or the classical small-data/short-time ceiling with explicit lifespan T ≳ 1/(C M₀). State the domain (ℝ³ vs 𝕋³), data class (smooth, div-free, L², H^s with s>5/2), lifespan, and constants.
6. Only if a full analytic argument for unmodified NS exists for all smooth finite-energy data: formalize a dependency DAG in a new scratch file with no axiom, sorry, or True placeholder. Compile with `lake build`, check that `#print axioms` shows only propext/Classical.choice/Quot.sound, and check model alignment (T3 = ℝ³ vs periodic, which vorticity_sup_norm is used, IsPhysicalNSSolution).

## 4. Halt / report rules
- Halt and ask Benjamin before changing the PDE, adding the tether to NS, narrowing the data class, weakening the derivative notion, changing a target statement, or changing a title or claim.
- "Closed" only with (i) a complete written analytic proof for unmodified NS and arbitrary smooth finite-energy data, and (ii) a machine-checked DAG with a clean axiom audit and model alignment. Otherwise report the exact residual gap or counterexample. Make no promise of a solution and no Clay claim.
- First deliverable: the precise bottleneck (§2) plus a proved or refuted concrete lemma (the §2(b) differentiability counterexample, or a rigorously verified scaling constraint on proposed constants). Do not just rename assumptions.
- No push, publish, Zenodo action, or PR without explicit authorization. Repository code work follows the code-changes/cloud-plan/CLI rules.

## Additional cautions from review
- A possible corner in M(t), a shear-mode construction, and sample vortex profiles above are research leads, not established counterexamples. An example must solve the exact PDE and admissibility predicates on the exact domain (including finite energy where required).
- The global-in-time quantifier in FrohmanianTetherRate/Bound may be vacuous if no such solution is known; investigate maximal-lifespan targets and reject vacuous closure.
- Do not require closure of all analysis as a prerequisite for formalizing useful genuine intermediate lemmas. Formalize noncircular partial progress in scratch work, while keeping the main claim open.
