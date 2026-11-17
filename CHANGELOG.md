# Changelog

## 2026-11-16: `main.tex` Theorem 1.1 rewritten to match the Lean (scope change; PENDING AUTHOR REVIEW)

Branch `feat/semantics-lock` (PR #34). Author: Benjamin Stanley Frohman. **This is a scope change
that the author must review and approve.** Nothing is published.

### Why

The Truth Gate reported two DRIFT failures on Theorem 1.1 (`thm:main`):

1. `ConditionalGlobalRegularity`: Theorem 1.1 was attributed to `global_regularity_for_NS` (now
   `ConditionalRegularity.conditional_regularity_of_open_hyps`), but that theorem assumes the
   time-uniform bound `FrohmanianTetherBound` instead of the cubic rate (R), one given Kato
   witness instead of (K) for every datum, and has no ceiling in its conclusion.
2. `TetherTheorem`: Theorem 1.1 was also attributed to `frohmanian_tether_theorem`, whose
   hypothesis `hDI : ∀ u₀ ν, FrohmanianTetherRate u₀ ν` (the rate for ALL data) is proved
   unsatisfiable, so that theorem is vacuous.

Following "build out the formalization and see what Lean can prove" (t432u), a new theorem
`CeilingFromRate.conditional_global_regularity_with_ceiling` was proved (no `sorry`, standard
axioms only). It is the original Theorem 1.1 with two differences: (R) is assumed for the one
given datum (as in the original wording "along every physical solution from u₀"), and (K) is
replaced by a single Kato witness for that datum (a weaker hypothesis, so a stronger theorem).
Its conclusion contains the ceiling `M(t) ≤ max(M(0), C/κ'')`. All its hypotheses are proved
jointly satisfiable at `u₀ = 0` (`CeilingFromRate.hypotheses_jointly_satisfiable_at_zero`);
satisfiability for any nonzero datum is not known. Theorem 1.1 now states exactly this theorem,
and a new Proposition (`prop:hDI`) states that the all-data rate hypothesis is unsatisfiable.

Neither is a regularity result for Navier–Stokes: (R) for a given nonzero datum is open.

Attempt not added: (K) for ALL data as a hypothesis. It would make the theorem weaker (the single
witness version already implies it by instantiating at `u₀(0)`), and its satisfiability cannot be
checked in Lean without formalizing Kato's 1972 local existence theorem, so it fails the
non-vacuity requirement. Not added as an axiom or hypothesis.

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
\begin{theorem}[Conditional global regularity with a vorticity ceiling from the single-datum cubic rate; \lean{conditional_global_regularity_with_ceiling}]\label{thm:main}
Let $\nu>0$ and let $u_0$ be a time-dependent velocity field on $\mathbb{R}^3$ that is divergence-free at every time and whose initial slice $u_0(0)$ is smooth (\lean{ContDiff ℝ ⊤}) and of finite $L^2$ energy. Let $w$ be a Kato local witness (\lean{KatoLocalWitness}) for $u_0(0)$ and $\nu$, and assume:
\begin{enumerate}
\item[(R)] \emph{Cubic tether rate for this datum} (\lean{FrohmanianTetherRate}~$u_0(0)$~$\nu$): for every physical solution $(u,p)$ (\lean{IsPhysicalNSSolution}) of \lean{NS_PDE} with viscosity $\nu$ and $u(0)=u_0(0)$, the map $t\mapsto M(t)$ is continuous on $\mathbb{R}$, $x\mapsto|\omega(u(t))(x)|$ is bounded above for every $t\ge0$, and there are constants $C>0$ and $\kappa''>0$ such that for every $s\ge0$ the map $t\mapsto M(t)$ is differentiable at $s$ with $M'(s)\le C\,M(s)^2-\kappa''\,M(s)^3$;
\item[(C)] \emph{Beale--Kato--Majda continuation criterion} (\lean{PhysicalBKMContinuationCriterionFor}) for $u_0(0)$ and $\nu$;
\item[(U)] \emph{Physical uniqueness against $w$} (\lean{KatoUniquenessOnExistenceTimes}).
\end{enumerate}
Then there is a velocity field $u$ with $u(0)=u_0(0)$ that is spatially $C^\infty$ for every $t\ge0$, is a physical solution of \lean{navier_stokes_eq} with viscosity $\nu$ for some pressure, satisfies $M(t)\le\max\bigl(M(0),C/\kappa''\bigr)$ for every $t\ge0$ for some constants $C>0$ and $\kappa''>0$, and agrees at every $t\ge0$ with every velocity field $v$ that has $v(0)=u_0(0)$, is spatially $C^\infty$ for every $t\ge0$, and is a physical solution of \lean{navier_stokes_eq} with viscosity $\nu$ for some pressure.
\end{theorem}
```

### New Proposition (verbatim)

```latex
\begin{proposition}[The all-data rate hypothesis of \lean{frohmanian_tether_theorem} is unsatisfiable; \lean{frohmanian_tether_theorem_hDI_unsatisfiable}]\label{prop:hDI}
It is not the case that for every velocity field $u_0$ and every $\nu\in\mathbb{R}$ the following holds: for every $(u,p)$ with $\nu>0$, \lean{NS_PDE}~$u$~$p$~$\nu$, $u(0)=u_0$ and \lean{IsPhysicalNSSolution}~$u$, the map $t\mapsto M(t)$ is continuous on $\mathbb{R}$, $x\mapsto|\omega(u(t))(x)|$ is bounded above for every $t\ge0$, and there are constants $C>0$ and $\kappa''>0$ such that for every $s\ge0$ the map $t\mapsto M(t)$ is differentiable at $s$ with $M'(s)\le C\,M(s)^2-\kappa''\,M(s)^3$.
\end{proposition}
```

### Other corrections in the same change

- Abstract, scope and verification-status paragraphs, §original, §open, Appendix-A item 10 and
  the status table rows: the old wording "proved, non-vacuous" for `frohmanian_tether_theorem` is
  replaced by "vacuous"; the uniform-bound variant `conditional_regularity_of_open_hyps` is
  described with its actual hypothesis (B).
- N1 Lyapunov row: `lyapunov_differential_inequality` never existed. The intended inequality
  `dS_ε/dt ≤ C_abs(1 + M_ε³‖φ_ε‖_∞^(3/2)) − κ'∫|ω_ε|⁶` is concluded by the module-private lemmas
  `differential_inequality_after_tether_and_absorption` / `key_differential_inequality` only
  from an open identification hypothesis `hIdent` and a hypothesis `h1` (the constant 1 is in
  L³) that is false on the model space ℝ³; `LyapunovDIStatus.key_di_h1_hypothesis_unsatisfiable`
  proves that. The inequality is now stated as open. The exact torus identity
  `dS_identity_smooth` (repository `weighted-enstrophy-identities`, commit 9e4cfd22) is cited,
  with a fresh axiom certificate in `docs/certs/`. The Hölder pipeline lemmas with the same `h1`
  hypothesis are marked vacuous on ℝ³.
- The stub `Modules/AnalyticEstimates.lean` (theorems proving only `True`) moved to
  `drafts/AnalyticEstimates_stub.lean`, unbuilt and marked; not deleted.
- Coadjoint invariance: described as conditional on `SDiffActionHyp` and
  `TetherIntegralPreserved` for an abstract action, not invariance under the actual SDiff(T³)
  action.
- Theorem, job and file counts recomputed from the build of this commit.

### Truth Gate

Locks `ConditionalGlobalRegularity` and `TetherTheorem` are now `locked`, with independent
`paper_claim` transcriptions of the new verbatim text (no aliasing, no `rfl`), proved
`intended_correspondence`, and transported public theorems `CeilingFromRate.theorem_1_1` and
`TetherRateCounterexample.all_data_rate_hypothesis_unsatisfiable`. All `main.tex` hashes were
updated. Approver status stays **PENDING AUTHOR APPROVAL**; the author-approval CI job stays red
until the author signs off.

The pre-change PDF is kept at `historical/main_2026-11-16_pre-thm1.1-rewrite.pdf`.

### Truth Gate: unformalized paper claims are work to do, not failures (author rule, 2026-11-16)

- Old: a paper claim with no Lean formalization could only be recorded as `drift`, which turns the gate red.
- New: lock status `unformalized` (with a `todo` note). The gate still checks the paper sha256, the verbatim quote, the paper_claim hash and the no-alias rule for it, reports `TRUTH GATE TODO <id>` (never PASS; certifies nothing), and does not count it as a failure. Such a lock may not export a public theorem or name a formal proof (`SHAPE` failure; new fixture `scripts/truth-gate-tests/neg_unformalized_public`). `DRIFT` remains a failure and is reserved for a claim the kernel shows Lean does not prove as stated. The summary line is now `locks=N todo=T failures=F`. No other check changed. All five current locks are `locked` (todo=0).
- Why: the author's rule is to formalize the missing piece and rerun `lake build`, rewording the paper only when the kernel actually fails.
- `scripts/verify-lock.sh`: Lean wraps long `#print axioms` lists over several lines, so the old line-based check rejected standard-axiom results whose names were long (and would have let a non-standard axiom on a continuation line go unread). Continuation lines are now joined before the same allow-list regex is applied.
