# Changelog

## 2026-11-16: `main.tex` Theorem 1.1 rewritten to match the Lean (scope change; PENDING AUTHOR REVIEW)

Branch `feat/semantics-lock` (PR #34). Author: Benjamin Stanley Frohman. **This is a scope change
that the author must review and approve.** Nothing is published.

### Why

The Truth Gate reported two DRIFT failures on Theorem 1.1 (`thm:main`):

1. `ConditionalGlobalRegularity`: the paper attributed Theorem 1.1 to `global_regularity_for_NS`,
   but Lean proves a different statement. Lean assumes the time-uniform bound
   `FrohmanianTetherBound` (not the cubic rate (R) `FrohmanianTetherRate`), one given Kato witness
   (not Kato local existence (K) from every datum), and its conclusion has no ceiling
   `M(t) <= max(M(0), C/kappa'')`. The old statement was unsettled in Lean (not proved, not
   disproved).
2. `TetherTheorem`: the paper also attributed Theorem 1.1 to `frohmanian_tether_theorem`, whose
   hypothesis `hDI : ∀ u₀ ν, FrohmanianTetherRate u₀ ν` is proved unsatisfiable
   (`TetherRateCounterexample.frohmanian_tether_theorem_hDI_unsatisfiable`), so that theorem is
   vacuous.

Following the workflow "correct the paper to what Lean kernel-checks", Theorem 1.1 now states
exactly `global_regularity_for_NS` (hypotheses and conclusion transcribed faithfully), and a new
Proposition (`prop:hDI`) states that the all-data rate hypothesis is unsatisfiable. Neither is a
regularity result for Navier–Stokes: hypothesis (B) of the new Theorem 1.1 is open, and by
Beale–Kato–Majda it is essentially as hard as regularity itself. No Clay or Millennium problem is
claimed solved.

### Old Theorem 1.1 (verbatim)

```latex
\begin{theorem}[Conditional Global Regularity; \lean{frohmanian_tether_theorem}, \lean{global_regularity_for_NS}]\label{thm:main}
Let $\nu>0$ and let $u_0$ be smooth (\lean{ContDiff ℝ ⊤}), divergence-free, and of finite $L^2$ energy. Assume within the class of physical solutions (\lean{IsPhysicalNSSolution}):
\begin{enumerate}
\item[(K)] \emph{Kato local existence}: a local smooth physical solution (\lean{KatoLocalWitness}) exists from every such datum, so $T^*(u_0,\nu)>0$;
\item[(C)] \emph{Beale--Kato--Majda continuation criterion} (\lean{PhysicalBKMContinuationCriterionFor}): if $T^*(u_0,\nu)$ is finite then $\int_0^{T^*}\|\omega\|_\infty\,dt=\infty$; $T^*=\infty$ is then derived from (K), (C) and the integrability supplied by (R);
\item[(R)] \emph{Frohmanian cubic tether rate (\lean{FrohmanianTetherRate})}: along every physical solution from $u_0$, the vorticity sup-norm $t\mapsto M(t)$ is continuous, differentiable on $[0,\infty)$, and satisfies
\[
M'(t)\le \CZ\,M(t)^2-\kappa''\,M(t)^3\qquad(t\ge 0)
\]
for constants $\CZ>0$, $\kappa''>0$ (yielding \lean{FrohmanianTetherBound});
\item[(U)] \emph{Physical uniqueness (\lean{KatoUniquenessOnExistenceTimes})}: smooth physical solutions (\lean{IsPhysicalNSSolution}) starting from $u_0$ agree with the Kato witness on each existence interval $[0,T]$.
\end{enumerate}
Then $M(t)\le\max\bigl(M(0),\CZ/\kappa''\bigr)$ for all $t\ge0$, and \eqref{eq:NS} admits a globally defined physical solution $u$ on $[0,\infty)$ that is spatially $C^\infty$ for every $t\ge0$, divergence-free, and unique among all smooth physical solutions.
\end{theorem}
```

### New Theorem 1.1 (verbatim)

```latex
\begin{theorem}[Conditional global regularity on $\mathbb{R}^3$ from an assumed uniform vorticity bound; \lean{global_regularity_for_NS}]\label{thm:main}
Let $\nu>0$ and let $u_0$ be a time-dependent velocity field on $\mathbb{R}^3$ that is divergence-free at every time and whose initial slice $u_0(0)$ is smooth (\lean{ContDiff ℝ ⊤}) and of finite $L^2$ energy. Let $w$ be a Kato local witness (\lean{KatoLocalWitness}) for $u_0(0)$ and $\nu$, and assume:
\begin{enumerate}
\item[(B)] \emph{Assumed uniform vorticity bound} (\lean{FrohmanianTetherBound}): for every physical solution $(u,p)$ (\lean{IsPhysicalNSSolution}) of \lean{NS_PDE} with viscosity $\nu$ and $u(0)=u_0(0)$, the map $t\mapsto M(t)$ is continuous on $\mathbb{R}$, $x\mapsto|\omega(u(t))(x)|$ is bounded above for every $t\ge0$, and there is a constant $Y$ with $M(t)\le Y$ for all $t\ge0$;
\item[(C)] \emph{Beale--Kato--Majda continuation criterion} (\lean{PhysicalBKMContinuationCriterionFor}) for $u_0(0)$ and $\nu$;
\item[(U)] \emph{Physical uniqueness against $w$} (\lean{KatoUniquenessOnExistenceTimes}).
\end{enumerate}
Then there is a velocity field $u$ with $u(0)=u_0(0)$ that is spatially $C^\infty$ for every $t\ge0$, is a physical solution of \lean{navier_stokes_eq} with viscosity $\nu$ for some pressure, satisfies $M(t)\ge0$ for every $t\ge0$, and agrees at every $t\ge0$ with every velocity field $v$ that has $v(0)=u_0(0)$, is spatially $C^\infty$ for every $t\ge0$, and is a physical solution of \lean{navier_stokes_eq} with viscosity $\nu$ for some pressure.
\end{theorem}
```

### New Proposition (verbatim)

```latex
\begin{proposition}[The all-data rate hypothesis of \lean{frohmanian_tether_theorem} is unsatisfiable; \lean{frohmanian_tether_theorem_hDI_unsatisfiable}]\label{prop:hDI}
It is not the case that for every velocity field $u_0$ and every $\nu\in\mathbb{R}$ the following holds: for every $(u,p)$ with $\nu>0$, \lean{NS_PDE}~$u$~$p$~$\nu$, $u(0)=u_0$ and \lean{IsPhysicalNSSolution}~$u$, the map $t\mapsto M(t)$ is continuous on $\mathbb{R}$, $x\mapsto|\omega(u(t))(x)|$ is bounded above for every $t\ge0$, and there are constants $C>0$ and $\kappa''>0$ such that for every $s\ge0$ the map $t\mapsto M(t)$ is differentiable at $s$ with $M'(s)\le C\,M(s)^2-\kappa''\,M(s)^3$.
\end{proposition}
```

### Other paper text corrected in the same change

- Abstract: no longer says Lean proves (K)+(C)+(R)+(U) ⇒ ceiling + global smoothness via
  `frohmanian_tether_theorem`; states Theorem 1.1 as the conditional implication from the open
  bound (B), the rate ⇒ ceiling lemma separately, and that `frohmanian_tether_theorem` is vacuous.
- Scope and verification-status paragraphs of Theorem 1.1; §original (BKM upgrade "assumed",
  not "established"); §open; the Appendix-A item 10 row; the status table rows for
  `global_regularity_for_NS` (no longer "verified non-vacuous" without qualification) and
  `frohmanian_tether_theorem` (now "Vacuous"); the appendix heading for the assembled theorem.
- Theorem, job and module counts recomputed from the build of this commit.

### Truth Gate

Locks `ConditionalGlobalRegularity` and `TetherTheorem` now have status `locked`, with
independent `paper_claim` transcriptions of the new verbatim text (no aliasing, no `rfl`),
`intended_correspondence` proved, formal proofs `GlobalRegularity.global_regularity_for_NS` and
`TetherRateCounterexample.frohmanian_tether_theorem_hDI_unsatisfiable`, and transported public
theorems `GlobalRegularity.conditional_global_regularity` and
`TetherRateCounterexample.all_data_rate_hypothesis_unsatisfiable`. All paper hashes were updated
to the new `main.tex`. Approver status stays **PENDING AUTHOR APPROVAL**; the author-approval CI
job stays red until the author signs off.

The pre-change PDF is kept at `historical/main_2026-11-16_pre-thm1.1-rewrite.pdf`.
