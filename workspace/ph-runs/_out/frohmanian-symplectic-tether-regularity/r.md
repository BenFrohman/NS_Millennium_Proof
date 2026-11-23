# PipelineHalt report: \textbf{The Frohmanian Symplectic Tether: Canonical Uniqueness on Coadjoint Orbits of $\mathrm{SDiff

Status: **HALT** · overall drift **0.760** · 5 claims · 217 Lean declarations scanned · 7 open question(s)

Mapping file: none (heuristic pairing only).

> PipelineHalt surfaces syntactic differences between paper claims and Lean statements and asks about them. Matching is heuristic. It does not decide what the author meant; recorded answers are the author's.

| Claim | Matched Lean | Drift | Open | Answered |
|---|---|---|---|---|
| Theorem 1.1 | — | 1.000 | 2 | 0 |
| Definition 2.1 | — | 1.000 | 2 | 0 |
| Theorem 2.2 | — | 1.000 | 1 | 0 |
| Theorem 3.1 | `c1_c3_not_unique_vel` (0.213) | 0.500 | 1 | 0 |
| Theorem 4.1 | `velocity_tether_product_theorem` (0.259), `shear_C2_fails` (0.233) | 0.300 | 1 | 0 |

## Theorem 1.1 — Master Product Theorem: \texttt{frohmanian\_metriplectic\_system\_canonical\_uniqueness\_and\_global\_regularity\_product\_theorem}

- `43fe16ee1903` SILENT: No Lean declaration matches this claim. Closest candidate: `velocity_tether_product_theorem` (score 0.15, below threshold 0.2). — **OPEN**
- `e7f5ad81c345` AMBIGUOUS: Title “Master Product Theorem: \texttt{frohmanian\_metriplectic\_system\_canonical\_uniqueness\_and\_global\_regularity\_product\_theorem}” shares almost no terms with the statement. — **OPEN**

## Definition 2.1 — Frohmanian Symplectic Tether Bracket and Kernel

- `4328d2dc605b` SILENT: No Lean declaration matches this claim. Closest candidate: `TetheredBracketVel` (score 0.09, below threshold 0.2). — **OPEN**
- `8f22c96a8cb9` AMBIGUOUS: Title “Frohmanian Symplectic Tether Bracket and Kernel” shares almost no terms with the statement. — **OPEN**

## Theorem 2.2 — Unconditional Casimir Non-Degeneracy of $\mathcal{K}_{\mathrm{FT}}$

- `43bfc54b8b6c` SILENT: No Lean declaration matches this claim. Closest candidate: `degeneracy_for_mollified_sup_norm_proxy` (score 0.19, below threshold 0.2). — **OPEN**

## Theorem 3.1 — Canonical Uniqueness: \texttt{uniqueness\_of\_minimal\_tether} and \texttt{uniqueness\_of\_kernel\_density}

- `37c098a5063a` CONDITIONAL: `c1_c3_not_unique_vel` assumes `hC2 : DegenerateWRTKineticEnergy (TetherKernelVel kappa)`, not stated in the claim. — **OPEN**

## Theorem 4.1 — Quartic $4 = 4$ Young Absorption, \texttt{youngs\_absorption\_elimination}

- `51164beb1353` AMBIGUOUS: Title “Quartic $4 = 4$ Young Absorption, \texttt{youngs\_absorption\_elimination}” shares almost no terms with the statement. — **OPEN**

## Realignment notes

- Theorem 1.1: answer `43fe16ee1903` — Paper claim Theorem 1.1 (theorem-1.1) states: “For every viscosity $\nu > 0$ on the dual Lie algebra $\mathfrak{g}^* = \mathrm{SDiff}(\mathbb{T}^3)^*$ with Calder\'on--Zygmund constant $C_{\mathrm{CZ}} = 3/2$ and canonical tether coupling $\kappa…”. No Lean declaration matching it was found among 161 candidates. Closest candidate: `velocity_tether_product_theorem` (score 0.15, below threshold 0.2). Is this claim intentionally not formalized, or which declaration should it map to?
- Theorem 1.1: answer `e7f5ad81c345` — Paper claim Theorem 1.1 (theorem-1.1) states: “For every viscosity $\nu > 0$ on the dual Lie algebra $\mathfrak{g}^* = \mathrm{SDiff}(\mathbb{T}^3)^*$ with Calder\'on--Zygmund constant $C_{\mathrm{CZ}} = 3/2$ and canonical tether coupling $\kappa…”. Its title is “Master Product Theorem: \texttt{frohmanian\_metriplectic\_system\_canonical\_uniqueness\_and\_global\_regularity\_product\_theorem}”, which does not appear to describe that statement. Is the title or the statement misworded?
- Definition 2.1: answer `4328d2dc605b` — Paper claim Definition 2.1 (eq:kappa-def) states: “For $\nu > 0$ and $C_{\mathrm{CZ}} = 3/2$, define the canonical coupling constant and symmetric bilinear kernel: \begin{align} \kappa(\nu) &= \frac{27 C_{\mathrm{CZ}}^4}{4 \nu^3} = \frac{2187}{64 \nu…”. No Lean declaration matching it was found among 56 candidates. Closest candidate: `TetheredBracketVel` (score 0.09, below threshold 0.2). Is this claim intentionally not formalized, or which declaration should it map to?
- Definition 2.1: answer `8f22c96a8cb9` — Paper claim Definition 2.1 (eq:kappa-def) states: “For $\nu > 0$ and $C_{\mathrm{CZ}} = 3/2$, define the canonical coupling constant and symmetric bilinear kernel: \begin{align} \kappa(\nu) &= \frac{27 C_{\mathrm{CZ}}^4}{4 \nu^3} = \frac{2187}{64 \nu…”. Its title is “Frohmanian Symplectic Tether Bracket and Kernel”, which does not appear to describe that statement. Is the title or the statement misworded?
- Theorem 2.2: answer `43bfc54b8b6c` — Paper claim Theorem 2.2 (theorem-2.2) states: “Let $\kappa > 0$, $\omega \in \mathfrak{g}^*$, and $v : \mathbb{T}^3 \to \mathbb{R}^3$. Define the pointwise tether density $d_{\mathrm{FT}}(\kappa, \omega, v, x) = -\kappa \|\omega(x)\|^2 \|P_{\delt…”. No Lean declaration matching it was found among 161 candidates. Closest candidate: `degeneracy_for_mollified_sup_norm_proxy` (score 0.19, below threshold 0.2). Is this claim intentionally not formalized, or which declaration should it map to?
- Theorem 3.1: answer `37c098a5063a` — Paper claim Theorem 3.1 (theorem-3.1) states: “Let $\mathcal{K}(v, w; \omega) = \int_{\mathbb{T}^3} k(\omega(x), v(x), w(x))\,dx$ be any local bilinear symmetric form on $\mathfrak{g}^*$ whose pointwise density $k(\omega, v, w)$ satisfies C1 (Cas…”. Lean theorem `c1_c3_not_unique_vel` assumes `hC2 : DegenerateWRTKineticEnergy (TetherKernelVel kappa)`, which the claim does not state. Is this extra hypothesis intentional?
- Theorem 4.1: answer `51164beb1353` — Paper claim Theorem 4.1 (eq:young-4-eq-4) states: “For every $\nu > 0$, $C_{\mathrm{CZ}} > 0$, and $x = |\omega| \ge 0$, with $\kappa = \frac{27 C_{\mathrm{CZ}}^4}{4\nu^3}$, \begin{equation} C_{\mathrm{CZ}} x^3 - \frac{\nu}{3} x^2 - \frac{\kappa}{4} …”. Its title is “Quartic $4 = 4$ Young Absorption, \texttt{youngs\_absorption\_elimination}”, which does not appear to describe that statement. Is the title or the statement misworded?
