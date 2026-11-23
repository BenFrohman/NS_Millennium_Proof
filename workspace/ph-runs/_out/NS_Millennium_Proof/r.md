# PipelineHalt report: Global Regularity for the 3D Incompressible Navier--Stokes Equations via the Frohmanian Symplectic Tether\\[4pt]
\large Complete Original Conjectured Framework and Kernel-Verified Non-Vacuous Conditional Formalization in Lean~4

Status: **HALT** · overall drift **0.912** · 8 claims · 262 Lean declarations scanned · 20 open question(s)

Mapping file: none (heuristic pairing only).

> PipelineHalt surfaces syntactic differences between paper claims and Lean statements and asks about them. Matching is heuristic. It does not decide what the author meant; recorded answers are the author's.

| Claim | Matched Lean | Drift | Open | Answered |
|---|---|---|---|---|
| Theorem 1.1 | — | 1.000 | 2 | 0 |
| Definition 3.1 | — | 1.000 | 1 | 0 |
| Proposition 3.2 | `degeneracy_for_mollified_sup_norm_proxy` (0.339), `degeneracy_for_mollified_sup_norm_proxy` (0.339), `degeneracy_for_mollified_sup_norm_proxy` (0.299), `step3_projection` (0.244) | 0.998 | 9 | 0 |
| Lemma 4.1 | — | 1.000 | 2 | 0 |
| Lemma 4.2 | — | 1.000 | 1 | 0 |
| Lemma 4.3 | — | 1.000 | 2 | 0 |
| Lemma 4.4 | `comparison_majorant_global_bound` (0.443), `comparison_majorant_global_bound` (0.443), `comparison_majorant_global_bound` (0.39), `phase_plane_analysis_of_majorant_ODE` (0.325) | 0.300 | 1 | 0 |
| Proposition 4.5 | — | 1.000 | 2 | 0 |

## Theorem 1.1 — Conditional Global Regularity; \lean{frohmanian_tether_theorem}, \lean{global_regularity_for_NS}

- `cdf871b6ca1c` SILENT: No Lean declaration matches this claim. Closest candidate: `lemma_3_1_uniform_bound_and_continuation` (score 0.17, below threshold 0.2). — **OPEN**
- `9415a2e4de2c` AMBIGUOUS: Title “Conditional Global Regularity; \lean{frohmanian_tether_theorem}, \lean{global_regularity_for_NS}” shares almost no terms with the statement. — **OPEN**

## Definition 3.1 — Frohmanian tether kernel; Lean \lean{TetherKernel}, \lean{Pi_u}

- `e75338c6a714` SILENT: No Lean declaration matches this claim. Closest candidate: `projectionOrthogonalToU.` (score 0.13, below threshold 0.2). — **OPEN**

## Proposition 3.2 — Strict Degeneracy on Kinetic Energy; proved, \lean{tetherKernel_degenerates_on_kinetic_energy}, \lean{tetherKernel_C2}

- `5eee1cf6e942` CONDITIONAL: `degeneracy_for_mollified_sup_norm_proxy` assumes `hδ : FunctionalDerivative KineticEnergyHamiltonian ω = velocity_from_vorticity ω`, not stated in the claim. — **OPEN**
- `1a1be1fad790` CONDITIONAL: `degeneracy_for_mollified_sup_norm_proxy` assumes `hdiv : ∀ x, div (velocity_from_vorticity ω) x = 0`, not stated in the claim. — **OPEN**
- `d676a5d8143e` CONDITIONAL: `degeneracy_for_mollified_sup_norm_proxy` assumes `hInt : Integrable (fun y => ‖velocity_from_vorticity ω y‖ ^ 2)`, not stated in the claim. — **OPEN**
- `5eee1cf6e942` CONDITIONAL: `degeneracy_for_mollified_sup_norm_proxy` assumes `hδ : FunctionalDerivative KineticEnergyHamiltonian ω = velocity_from_vorticity ω`, not stated in the claim. — **OPEN**
- `1a1be1fad790` CONDITIONAL: `degeneracy_for_mollified_sup_norm_proxy` assumes `hdiv : ∀ x, div (velocity_from_vorticity ω) x = 0`, not stated in the claim. — **OPEN**
- `d676a5d8143e` CONDITIONAL: `degeneracy_for_mollified_sup_norm_proxy` assumes `hInt : Integrable (fun y => ‖velocity_from_vorticity ω y‖ ^ 2)`, not stated in the claim. — **OPEN**
- `5eee1cf6e942` CONDITIONAL: `degeneracy_for_mollified_sup_norm_proxy` assumes `hδ : FunctionalDerivative KineticEnergyHamiltonian ω = velocity_from_vorticity ω`, not stated in the claim. — **OPEN**
- `1a1be1fad790` CONDITIONAL: `degeneracy_for_mollified_sup_norm_proxy` assumes `hdiv : ∀ x, div (velocity_from_vorticity ω) x = 0`, not stated in the claim. — **OPEN**
- `d676a5d8143e` CONDITIONAL: `degeneracy_for_mollified_sup_norm_proxy` assumes `hInt : Integrable (fun y => ‖velocity_from_vorticity ω y‖ ^ 2)`, not stated in the claim. — **OPEN**

## Lemma 4.1 — Stretching at a spatial maximum; proved, \lean{stretching_inner_le_at_max}

- `3b4f1c8ac605` SILENT: No Lean declaration matches this claim. Closest candidate: `step4_coefficient` (score 0.11, below threshold 0.2). — **OPEN**
- `5e5d552b0287` AMBIGUOUS: Title “Stretching at a spatial maximum; proved, \lean{stretching_inner_le_at_max}” shares almost no terms with the statement. — **OPEN**

## Lemma 4.2 — Transport and viscosity at a spatial maximum; proved, \lean{time_pairing_le_stretching_at_max}

- `b8ffde411914` SILENT: No Lean declaration matches this claim. Closest candidate: `euler_energy_conservation` (score 0.17, below threshold 0.2). — **OPEN**

## Lemma 4.3 — Cubic comparison stability; proved, \lean{comparison_ode_stability}

- `efc10fabcc0e` SILENT: No Lean declaration matches this claim. Closest candidate: `majorant_comparison_principle` (score 0.24, but it matches claim lem:majorant better). — **OPEN**
- `5604cd92a6b0` AMBIGUOUS: Title “Cubic comparison stability; proved, \lean{comparison_ode_stability}” shares almost no terms with the statement. — **OPEN**

## Lemma 4.4 — Explicit majorant global bound; proved, \lean{comparison_majorant_global_bound}

- `66e0c28378de` AMBIGUOUS: Title “Explicit majorant global bound; proved, \lean{comparison_majorant_global_bound}” shares almost no terms with the statement. — **OPEN**

## Proposition 4.5 — Cubic rate $\Rightarrow$ uniform vorticity ceiling; proved, \lean{riccati_ceiling_of_vorticity_di}

- `06bf1c024fe6` SILENT: No Lean declaration matches this claim. Closest candidate: `majorant_comparison_principle` (score 0.25, but it matches claim lem:majorant better). — **OPEN**
- `e96b01a5c691` AMBIGUOUS: Title “Cubic rate $\Rightarrow$ uniform vorticity ceiling; proved, \lean{riccati_ceiling_of_vorticity_di}” shares almost no terms with the statement. — **OPEN**

## Realignment notes

- Theorem 1.1: answer `cdf871b6ca1c` — Paper claim Theorem 1.1 (thm:main) states: “Let $\nu>0$ and let $u_0$ be smooth (\lean{ContDiff ℝ ⊤}), divergence-free, and of finite $L^2$ energy. Assume within the class of physical solutions (\lean{IsPhysicalNSSolution}): •[(K)] \emph{Kato …”. No Lean declaration matching it was found among 135 candidates. Closest candidate: `lemma_3_1_uniform_bound_and_continuation` (score 0.17, below threshold 0.2). Is this claim intentionally not formalized, or which declaration should it map to?
- Theorem 1.1: answer `9415a2e4de2c` — Paper claim Theorem 1.1 (thm:main) states: “Let $\nu>0$ and let $u_0$ be smooth (\lean{ContDiff ℝ ⊤}), divergence-free, and of finite $L^2$ energy. Assume within the class of physical solutions (\lean{IsPhysicalNSSolution}): •[(K)] \emph{Kato …”. Its title is “Conditional Global Regularity; \lean{frohmanian_tether_theorem}, \lean{global_regularity_for_NS}”, which does not appear to describe that statement. Is the title or the statement misworded?
- Definition 3.1: answer `e75338c6a714` — Paper claim Definition 3.1 (def:tether) states: “For a velocity field $u=\mathrm{BS}(\omega)$ with $\|u\|_{L^2}\neq0$, let $\Pi_u=P^\perp_u$ be the $L^2$-orthogonal Gram--Schmidt projection onto the complement of $\operatorname{span}\{u\}$: \[ \Pi_…”. No Lean declaration matching it was found among 127 candidates. Closest candidate: `projectionOrthogonalToU.` (score 0.13, below threshold 0.2). Is this claim intentionally not formalized, or which declaration should it map to?
- Proposition 3.2: answer `5eee1cf6e942` — Paper claim Proposition 3.2 (prop:degen) states: “Whenever $\delta H/\delta\omega=u$, $\nabla\cdot u=0$, and $u\in L^2$, one has $\Pi_u u=0$ (\lean{projection_orthogonal_to_u}) and hence \[ B(F,H)(\omega)=0\qquad\text{for every functional }F. \]”. Lean theorem `degeneracy_for_mollified_sup_norm_proxy` assumes `hδ : FunctionalDerivative KineticEnergyHamiltonian ω = velocity_from_vorticity ω`, which the claim does not state. Is this extra hypothesis intentional?
- Proposition 3.2: answer `1a1be1fad790` — Paper claim Proposition 3.2 (prop:degen) states: “Whenever $\delta H/\delta\omega=u$, $\nabla\cdot u=0$, and $u\in L^2$, one has $\Pi_u u=0$ (\lean{projection_orthogonal_to_u}) and hence \[ B(F,H)(\omega)=0\qquad\text{for every functional }F. \]”. Lean theorem `degeneracy_for_mollified_sup_norm_proxy` assumes `hdiv : ∀ x, div (velocity_from_vorticity ω) x = 0`, which the claim does not state. Is this extra hypothesis intentional?
- Proposition 3.2: answer `d676a5d8143e` — Paper claim Proposition 3.2 (prop:degen) states: “Whenever $\delta H/\delta\omega=u$, $\nabla\cdot u=0$, and $u\in L^2$, one has $\Pi_u u=0$ (\lean{projection_orthogonal_to_u}) and hence \[ B(F,H)(\omega)=0\qquad\text{for every functional }F. \]”. Lean theorem `degeneracy_for_mollified_sup_norm_proxy` assumes `hInt : Integrable (fun y => ‖velocity_from_vorticity ω y‖ ^ 2)`, which the claim does not state. Is this extra hypothesis intentional?
- Proposition 3.2: answer `5eee1cf6e942` — Paper claim Proposition 3.2 (prop:degen) states: “Whenever $\delta H/\delta\omega=u$, $\nabla\cdot u=0$, and $u\in L^2$, one has $\Pi_u u=0$ (\lean{projection_orthogonal_to_u}) and hence \[ B(F,H)(\omega)=0\qquad\text{for every functional }F. \]”. Lean theorem `degeneracy_for_mollified_sup_norm_proxy` assumes `hδ : FunctionalDerivative KineticEnergyHamiltonian ω = velocity_from_vorticity ω`, which the claim does not state. Is this extra hypothesis intentional?
- Proposition 3.2: answer `1a1be1fad790` — Paper claim Proposition 3.2 (prop:degen) states: “Whenever $\delta H/\delta\omega=u$, $\nabla\cdot u=0$, and $u\in L^2$, one has $\Pi_u u=0$ (\lean{projection_orthogonal_to_u}) and hence \[ B(F,H)(\omega)=0\qquad\text{for every functional }F. \]”. Lean theorem `degeneracy_for_mollified_sup_norm_proxy` assumes `hdiv : ∀ x, div (velocity_from_vorticity ω) x = 0`, which the claim does not state. Is this extra hypothesis intentional?
- Proposition 3.2: answer `d676a5d8143e` — Paper claim Proposition 3.2 (prop:degen) states: “Whenever $\delta H/\delta\omega=u$, $\nabla\cdot u=0$, and $u\in L^2$, one has $\Pi_u u=0$ (\lean{projection_orthogonal_to_u}) and hence \[ B(F,H)(\omega)=0\qquad\text{for every functional }F. \]”. Lean theorem `degeneracy_for_mollified_sup_norm_proxy` assumes `hInt : Integrable (fun y => ‖velocity_from_vorticity ω y‖ ^ 2)`, which the claim does not state. Is this extra hypothesis intentional?
- Proposition 3.2: answer `5eee1cf6e942` — Paper claim Proposition 3.2 (prop:degen) states: “Whenever $\delta H/\delta\omega=u$, $\nabla\cdot u=0$, and $u\in L^2$, one has $\Pi_u u=0$ (\lean{projection_orthogonal_to_u}) and hence \[ B(F,H)(\omega)=0\qquad\text{for every functional }F. \]”. Lean theorem `degeneracy_for_mollified_sup_norm_proxy` assumes `hδ : FunctionalDerivative KineticEnergyHamiltonian ω = velocity_from_vorticity ω`, which the claim does not state. Is this extra hypothesis intentional?
- Proposition 3.2: answer `1a1be1fad790` — Paper claim Proposition 3.2 (prop:degen) states: “Whenever $\delta H/\delta\omega=u$, $\nabla\cdot u=0$, and $u\in L^2$, one has $\Pi_u u=0$ (\lean{projection_orthogonal_to_u}) and hence \[ B(F,H)(\omega)=0\qquad\text{for every functional }F. \]”. Lean theorem `degeneracy_for_mollified_sup_norm_proxy` assumes `hdiv : ∀ x, div (velocity_from_vorticity ω) x = 0`, which the claim does not state. Is this extra hypothesis intentional?
- Proposition 3.2: answer `d676a5d8143e` — Paper claim Proposition 3.2 (prop:degen) states: “Whenever $\delta H/\delta\omega=u$, $\nabla\cdot u=0$, and $u\in L^2$, one has $\Pi_u u=0$ (\lean{projection_orthogonal_to_u}) and hence \[ B(F,H)(\omega)=0\qquad\text{for every functional }F. \]”. Lean theorem `degeneracy_for_mollified_sup_norm_proxy` assumes `hInt : Integrable (fun y => ‖velocity_from_vorticity ω y‖ ^ 2)`, which the claim does not state. Is this extra hypothesis intentional?
- Lemma 4.1: answer `3b4f1c8ac605` — Paper claim Lemma 4.1 (lem:localmax) states: “Let $x$ satisfy $\|\omega(x)\|=\|\omega\|_{L^\infty}$ and suppose $\|\nabla u(x)\|\le\CZ\|\omega\|_{L^\infty}$ (\lean{hCZ}). Then \[ \langle\omega(x),(\omega\cdot\nabla)u(x)\rangle\le\CZ\,\|\omega\|_…”. No Lean declaration matching it was found among 135 candidates. Closest candidate: `step4_coefficient` (score 0.11, below threshold 0.2). Is this claim intentionally not formalized, or which declaration should it map to?
- Lemma 4.1: answer `5e5d552b0287` — Paper claim Lemma 4.1 (lem:localmax) states: “Let $x$ satisfy $\|\omega(x)\|=\|\omega\|_{L^\infty}$ and suppose $\|\nabla u(x)\|\le\CZ\|\omega\|_{L^\infty}$ (\lean{hCZ}). Then \[ \langle\omega(x),(\omega\cdot\nabla)u(x)\rangle\le\CZ\,\|\omega\|_…”. Its title is “Stretching at a spatial maximum; proved, \lean{stretching_inner_le_at_max}”, which does not appear to describe that statement. Is the title or the statement misworded?
- Lemma 4.2: answer `b8ffde411914` — Paper claim Lemma 4.2 (lem:transport) states: “At a spatial maximum where the convective transport pairing $\langle\omega,(u\cdot\nabla)\omega\rangle(x)$ vanishes and $\langle\omega,\Delta\omega\rangle(x)\le0$, along any solution of \eqref{eq:vor…”. No Lean declaration matching it was found among 135 candidates. Closest candidate: `euler_energy_conservation` (score 0.17, below threshold 0.2). Is this claim intentionally not formalized, or which declaration should it map to?
- Lemma 4.3: answer `efc10fabcc0e` — Paper claim Lemma 4.3 (lem:cubic) states: “Let $C>0$, $\kappa''>0$, and let $y:[0,\infty)\to\R$ be differentiable on $[0,\infty)$ with \[ y'(s)\le C\,y(s)^2-\kappa''\,y(s)^3\qquad(s\ge0). \] Then for every $t\ge0$, \[ y(t)\le\max\Bigl(y(0),\ …”. No Lean declaration matching it was found among 135 candidates. Closest candidate: `majorant_comparison_principle` (score 0.24, but it matches claim lem:majorant better). Is this claim intentionally not formalized, or which declaration should it map to?
- Lemma 4.3: answer `5604cd92a6b0` — Paper claim Lemma 4.3 (lem:cubic) states: “Let $C>0$, $\kappa''>0$, and let $y:[0,\infty)\to\R$ be differentiable on $[0,\infty)$ with \[ y'(s)\le C\,y(s)^2-\kappa''\,y(s)^3\qquad(s\ge0). \] Then for every $t\ge0$, \[ y(t)\le\max\Bigl(y(0),\ …”. Its title is “Cubic comparison stability; proved, \lean{comparison_ode_stability}”, which does not appear to describe that statement. Is the title or the statement misworded?
- Lemma 4.4: answer `66e0c28378de` — Paper claim Lemma 4.4 (lem:majorant) states: “For $C,\kappa''>0$ and $y_0\ge0$, any solution $Y_{C,\kappa''}(t;y_0)$ of the comparison ODE $y'=Cy^2-\kappa''y^3$, $y(0)=y_0$ (\lean{ComparisonODE}) satisfies $0\le Y_{C,\kappa''}(t;y_0)\le\max(y_0,…”. Its title is “Explicit majorant global bound; proved, \lean{comparison_majorant_global_bound}”, which does not appear to describe that statement. Is the title or the statement misworded?
- Proposition 4.5: answer `06bf1c024fe6` — Paper claim Proposition 4.5 (prop:ceiling) states: “If $M(t)=\|\omega(t)\|_{L^\infty}$ is differentiable on $[0,\infty)$ and satisfies $M'(t)\le \CZ M(t)^2-\kappa''M(t)^3$, then \[ \sup_{t\ge0}M(t)\le\max\Bigl(M(0),\frac{\CZ}{\kappa''}\Bigr). \]”. No Lean declaration matching it was found among 135 candidates. Closest candidate: `majorant_comparison_principle` (score 0.25, but it matches claim lem:majorant better). Is this claim intentionally not formalized, or which declaration should it map to?
- Proposition 4.5: answer `e96b01a5c691` — Paper claim Proposition 4.5 (prop:ceiling) states: “If $M(t)=\|\omega(t)\|_{L^\infty}$ is differentiable on $[0,\infty)$ and satisfies $M'(t)\le \CZ M(t)^2-\kappa''M(t)^3$, then \[ \sup_{t\ge0}M(t)\le\max\Bigl(M(0),\frac{\CZ}{\kappa''}\Bigr). \]”. Its title is “Cubic rate $\Rightarrow$ uniform vorticity ceiling; proved, \lean{riccati_ceiling_of_vorticity_di}”, which does not appear to describe that statement. Is the title or the statement misworded?
- Lean `theorem_2_3_uniqueness_of_the_minimal_correction.` cites “Theorem 2.3” in its docstring but is not matched to any anchor claim (informational).
- Lean `lemma_3_1_uniform_bound_and_continuation` cites “Lemma 3.1” in its docstring but is not matched to any anchor claim (informational).
