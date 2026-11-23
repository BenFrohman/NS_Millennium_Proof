# PipelineHalt report: \textbf{Formalizing Fefferman's Official Periodic Navier--Stokes Problem (B) in Lean 4:\\
Global Linear Strain Exclusion on $\mathbb{T

Status: **HALT** · overall drift **1.000** · 1 claims · 25 Lean declarations scanned · 2 open question(s)

Mapping file: none (heuristic pairing only).

> PipelineHalt surfaces syntactic differences between paper claims and Lean statements and asks about them. Matching is heuristic. It does not decide what the author meant; recorded answers are the author's.

| Claim | Matched Lean | Drift | Open | Answered |
|---|---|---|---|---|
| Theorem 1.1 | — | 1.000 | 2 | 0 |

## Theorem 1.1 — Master Product Theorem: \texttt{fefferman\_periodic\_ns\_exact\_reduction\_product\_theorem}

- `43fe16ee1903` SILENT: No Lean declaration matches this claim. Closest candidate: `clay_reduces_to_direction_curvature_bound` (score 0.10, below threshold 0.2). — **OPEN**
- `e7f5ad81c345` AMBIGUOUS: Title “Master Product Theorem: \texttt{fefferman\_periodic\_ns\_exact\_reduction\_product\_theorem}” shares almost no terms with the statement. — **OPEN**

## Realignment notes

- Theorem 1.1: answer `43fe16ee1903` — Paper claim Theorem 1.1 (theorem-1.1) states: “For every viscosity $\nu \in \mathbb{R}$ on the 3-torus $\mathbb{T}^3 = \mathbb{R}^3/\mathbb{Z}^3$, \textbf{(Q$_1$)} spatial $\mathbb{Z}^3$-periodicity is equivalent to invariance under the three uni…”. No Lean declaration matching it was found among 21 candidates. Closest candidate: `clay_reduces_to_direction_curvature_bound` (score 0.10, below threshold 0.2). Is this claim intentionally not formalized, or which declaration should it map to?
- Theorem 1.1: answer `e7f5ad81c345` — Paper claim Theorem 1.1 (theorem-1.1) states: “For every viscosity $\nu \in \mathbb{R}$ on the 3-torus $\mathbb{T}^3 = \mathbb{R}^3/\mathbb{Z}^3$, \textbf{(Q$_1$)} spatial $\mathbb{Z}^3$-periodicity is equivalent to invariance under the three uni…”. Its title is “Master Product Theorem: \texttt{fefferman\_periodic\_ns\_exact\_reduction\_product\_theorem}”, which does not appear to describe that statement. Is the title or the statement misworded?
