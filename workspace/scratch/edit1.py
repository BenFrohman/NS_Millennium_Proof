import re
p='manuscript/main.tex'; s=open(p).read()
def rep(old,new,count=1):
    global s
    assert s.count(old)>=1, old[:80]
    s=s.replace(old,new,count)
rep(r'\newcommand{\VERSIONDOI}{\href{https://doi.org/10.5281/zenodo.24120781}{10.5281/zenodo.24120781}}',
    r'\newcommand{\VERSIONDOI}{\href{https://doi.org/10.5281/zenodo.24122596}{10.5281/zenodo.24122596}}')
rep(r'\title{The Frohmanian Tether on $\mathrm{SDiff}(\mathbb{T}^3)$: A Metriplectic Correction, Its Canonicity, and an Obstruction to Damping\\[0.4em]\large Conditional statements verified in Lean~4}',
    r'\title{The Frohmanian Tether Bound Implies Global Smoothness and Beale--Kato--Majda Integrability on $\mathbb{T}^3$\\[0.4em]\large Kernel-checked conditional theorems in Lean~4, with the metriplectic tether on $\mathrm{SDiff}(\mathbb{T}^3)$, its canonicity, and an obstruction to damping}')
rep('Version 0.1.4; this version','Version 0.1.5; this version')
rep(r'\textbf{Preprint. Work in progress. All main results are conditional; see Section~\ref{sec:conditional}.}',
    r'\textbf{Preprint. All main results are conditional; the open hypotheses are collected in Section~\ref{sec:conditional}. Not a Clay Millennium Problem claim.}')
# abstract
a0=s.index(r'\begin{abstract}'); a1=s.index(r'\end{abstract}')
abstract=r'''\begin{abstract}
We prove, with every step checked by the Lean~4 kernel against Mathlib, that the \emph{Frohmanian tether
bound} implies global smoothness for the three-dimensional periodic Navier--Stokes equations, together with a
classical continuation input. The tether bound \lean{PeriodicTetherClosingBound ν} asserts that for every smooth,
divergence-free, $\mathbb{Z}^3$-periodic datum $u_0$ there is one ceiling $Y$ with
$\|\omega(t)\|_{L^\infty}\le Y$ along every classical periodic solution from $u_0$ on every interval $[0,T)$.
\textbf{Main Theorem} (\lean{clay_B_exact_of_periodic_tether_bound}): if, for every $\nu>0$,
\lean{PeriodicTetherClosingBound ν} and the Beale--Kato--Majda continuation hypothesis
\lean{PeriodicBKMContinuation ν} hold, then the formal version \lean{Clay_B_exact} of Fefferman's statement (B)
holds. \textbf{Second theorem} (\lean{periodicBKMIntegrability_of_periodicTetherBound}): the tether bound at a
datum implies Beale--Kato--Majda integrability there, $\int_{[0,T)}\|\omega(t)\|_{L^\infty}\,dt\le
\max(Y,0)\max(T_0,0)$ for every solution on $[0,T)$, $T\le T_0$. The converse, BKM integrability $\Rightarrow$
tether bound, is true classical mathematics conditional on three classical pillars (the Beale--Kato--Majda
theorem, uniqueness of classical periodic solutions, long-time decay); it is described in a separate section,
is not stated as a theorem, and is being formalized. Both hypotheses of the Main Theorem are open, and the
tether bound is as strong as statement (B) itself.

Version 0.1.5 also corrects the $\R^3$-class local hypotheses of version 0.1.4, with Lean proofs of both defects:
the real supremum \lean{vorticity_sup_norm} takes the junk value $0$ on unbounded vorticity, so the 0.1.4
ceiling imposed no constraint at such times (now guarded by \lean{BddAbove}); and the 0.1.4
\lean{LocalTetherRate} demanded two-sided differentiability of $\|\omega\|_{L^\infty}$ at the right endpoint,
which reads the path beyond the interval: an explicit local solution from $u_0=0$ with
$\|\omega(t)\|_{L^\infty}=t^{-1}$ refutes it, so the 0.1.4 \lean{frohmanian_tether_theorem} held vacuously. The
corrected rate uses right derivatives and holds at zero data. Every changed statement is listed.

The library further formalizes the tether $T(F,G)=-\kappa\|\omega\|_{L^2}^2\int\langle\Pi_u\,\delta F/\delta\omega,
\Pi_u\,\delta G/\delta\omega\rangle$, a symmetric correction to the Arnold Lie--Poisson bracket, and proves the
negative-feedback condition (C3), the transported form of (C1) under translations, canonicity inside a
restricted kernel class, the corrected weight condition via concentrated divergence-free test fields, an
\emph{obstruction to damping} (every symmetric kernel satisfying the energy degeneracy (C2) has $B(H,M)=0$ for
every $M$), and the decaying shear and ABC flows as exact global periodic solutions for their own data.
\textbf{This work does not prove global regularity of the three-dimensional Navier--Stokes equations and is not a
Clay Millennium Problem claim.} The build (Lean \texttt{v4.30.0-rc1}, Mathlib \texttt{v4.30.0-rc1}, 2797 jobs) contains 782 theorem
constants (690 stated in the sources and 92 auto-generated equation, congruence and injectivity lemmas) and
1101 declarations in 35 modules, with no \texttt{sorry}, no \texttt{native\_decide}, no axiom
declarations, and every declaration depending only on \texttt{propext}, \texttt{Classical.choice} and
\texttt{Quot.sound}; this is enforced in continuous integration and reproduced from a fresh clone by
the single command \texttt{bash scripts/verify.sh} (or \texttt{make verify}).
'''
s=s[:a0]+abstract+s[a1:]
# intro findings: add item 0
rep(r'''made explicit, and the exact Lean text is reproduced in Appendix~\ref{app:lean}. The main findings are:
\begin{enumerate}[label=(\roman*)]
''',r'''made explicit, and the exact Lean text is reproduced in Appendix~\ref{app:lean}. The main findings are:
\begin{enumerate}[label=(\roman*)]
\item \emph{Main results} (Section~\ref{sec:main}). The Frohmanian tether bound together with periodic BKM
continuation implies the formal statement (B) (Theorem~\ref{thm:mainA}); the tether bound implies BKM
integrability datum by datum (Theorem~\ref{thm:mainB}). The converse direction and its three classical pillars are
described in Section~\ref{sec:converse}. Section~\ref{sec:corr} corrects the local hypotheses of 0.1.4.
''')
# open hypotheses section
rep(r'''\subsection{The results are conditional}\label{sec:conditional}
Every theorem of this paper whose conclusion concerns Navier--Stokes solutions, and the canonicity theorems,
is an \emph{implication} whose hypotheses are not proved. The complete list of open hypotheses, by Lean name:''',
r'''\subsection{Open hypotheses}\label{sec:conditional}
Every theorem of this paper whose conclusion concerns Navier--Stokes solutions, and the canonicity theorems,
is an \emph{implication} whose hypotheses are not proved. This is the single list of unproved inputs, by Lean
name; no other section introduces one.''')
rep(r'''\item \emph{As strong as the open problem:} \lean{LocalTetherRate}, \lean{LocalTetherBound},
\lean{ClayStatements.LocalTetherClosingBound}, \lean{ClayStatements.PeriodicTetherClosingBound},''',
r'''\item \emph{As strong as the open problem:} the Frohmanian tether bound \lean{ClayStatements.PeriodicTetherClosingBound}
(hypothesis (i) of the Main Theorem) and its per-datum form \lean{TetherImpliesBKM.PeriodicTetherBound} (hypothesis of
Theorem~\ref{thm:mainB}); \lean{LocalTetherRate}, \lean{LocalTetherBound},
\lean{ClayStatements.LocalTetherClosingBound},''')
rep(r'''\lean{BKMGlobalContinuation}, \lean{SmoothPhysicalUniqueness}, \lean{PeriodicBKMContinuation},''',
r'''\lean{BKMGlobalContinuation}, \lean{SmoothPhysicalUniqueness}, \lean{PeriodicBKMContinuation} (hypothesis (ii)
of the Main Theorem),''')
rep(r'''None of these is an axiom; each is an explicit argument or a named \lean{Prop}.''',
r'''None of these is an axiom; each is an explicit argument or a named \lean{Prop}. The classical pillars (P1)--(P3)
of Section~\ref{sec:converse} are not hypotheses of any theorem; they describe the converse direction, which is
not claimed.''')
# version note: drop 23717084 sentence and update
rep(r''' This version, 0.1.4 (DOI \VERSIONDOI), adds the module \lean{ExplicitFlows} (Section~\ref{sec:explicit}): the decaying shear and ABC flows as exact solutions, their periodic smoothness, and the proof that no nonzero periodic field can be a \lean{KatoLocalWitness}. No existing Lean statement was changed.''',
r''' Version 0.1.4 (\href{https://doi.org/10.5281/zenodo.24120781}{10.5281/zenodo.24120781}) added the module \lean{ExplicitFlows} (Section~\ref{sec:explicit}): the decaying shear and ABC flows as exact solutions, their periodic smoothness, and the proof that no nonzero periodic field can be a \lean{KatoLocalWitness}; no existing Lean statement was changed. This version, 0.1.5 (DOI \VERSIONDOI), adds the modules \lean{TetherImpliesBKM} and \lean{TetherDefinitionAudit} (Section~\ref{sec:main}) and corrects the local hypotheses \lean{LocalTetherBound}, \lean{LocalFiniteTimeVorticityBound} and \lean{LocalTetherRate}; the exact statement changes are listed in Section~\ref{sec:diff}.''')
rep(r''' The older-project DOI \texttt{10.5281/zenodo.23717084} belongs to \texttt{NS\_Millennium\_Proof} and does \emph{not} identify this repository.''','')
rep(r'''Version 0.1.0 of this manuscript named a different repository
(\texttt{NS\_Millennium\_Proof}), quoted theorem and job counts of that repository, and cited a Zenodo DOI
belonging to it.''',r'''Version 0.1.0 of this manuscript named a different repository
and quoted theorem and job counts of that repository.''')
# insert main results before setting section
mr=open('/workspace/scratch/main_results.tex').read()
rep(r'''%=====================================================================
\section{The formal setting}\label{sec:setting}''', mr+r'''%=====================================================================
\section{The formal setting}\label{sec:setting}''')
# analytic layer
rep(r'''\begin{lemma}[Finite-interval comparison; \lean{TetheredLyapunov.comparison_ode_stability_Icc}]
The same conclusion holds on $[0,T]$: if $y$ is differentiable on $[0,T]$ with $y'\le Cy^2-\kappa''y^3$ there,
then $y(t)\le\max(y(0),C/\kappa'')$ for $t\in[0,T]$.
\end{lemma}''',r'''\begin{lemma}[Finite-interval comparison; \lean{TetheredLyapunov.comparison_ode_stability_Icc}]
The same conclusion holds on $[0,T]$: if $y$ is differentiable on $[0,T]$ with $y'\le Cy^2-\kappa''y^3$ there,
then $y(t)\le\max(y(0),C/\kappa'')$ for $t\in[0,T]$.
\end{lemma}

\begin{lemma}[One-sided comparison, new in 0.1.5; \lean{TetheredLyapunov.comparison_ode_stability_Icc_right}]\label{lem:cmpright}
Let $C,\kappa''>0$ and let $y$ be continuous on $[0,T]$ with, at every $s\in[0,T)$, a right derivative
$d$ (\lean{HasDerivWithinAt y d (Set.Ici s) s}) satisfying $d\le Cy(s)^2-\kappa''y(s)^3$. Then
$y(t)\le\max(y(0),C/\kappa'')$ for $t\in[0,T]$.
\end{lemma}''')
rep(r'''\item \lean{LocalTetherRate u₀ ν} (hDI): there are $C,\kappa''>0$, fixed before the interval, such that every
local physical solution from $u_0$ on every $[0,T]$ has $M$ differentiable on $[0,T]$ with
$M'\le CM^2-\kappa''M^3$ there. (Differentiability of a sup-norm in time is itself a strong requirement.) By the
finite-interval comparison lemma it implies \lean{LocalTetherBound u₀ ν}
(\lean{localTetherBound_of_localTetherRate}).
\item \lean{LocalTetherBound u₀ ν}: one ceiling $Y$ with $M(t)\le Y$ for every local physical solution from
$u_0$ on every $[0,T]$ and every $t\in[0,T]$. \lean{ClayStatements.LocalTetherClosingBound ν} asserts this for
\emph{all} smooth divergence-free finite-energy data. It implies \lean{LocalFiniteTimeVorticityBound u₀ ν}
(for each $T_0$ one ceiling on intervals $[0,T]$, $T\le T_0$).''',
r'''\item \lean{LocalTetherRate u₀ ν} (hDI; corrected in 0.1.5, Section~\ref{sec:corr}): there are $C,\kappa''>0$,
fixed before the interval, such that every local physical solution from $u_0$ on every $[0,T]$ has $M$
continuous on $[0,T]$, a right derivative $d\le CM(s)^2-\kappa''M(s)^3$ at every $s\in[0,T)$, and $\omega(t)$
bounded for $t\in[0,T]$. By Lemma~\ref{lem:cmpright} it implies \lean{LocalTetherBound u₀ ν}
(\lean{localTetherBound_of_localTetherRate}); it holds at $u_0=0$ (\lean{localTetherRate_zero}).
\item \lean{LocalTetherBound u₀ ν} (corrected in 0.1.5): one ceiling $Y$ such that, for every local physical
solution from $u_0$ on every $[0,T]$ and every $t\in[0,T]$, $\omega(t)$ is bounded and $M(t)\le Y$.
\lean{ClayStatements.LocalTetherClosingBound ν} asserts this for all smooth divergence-free finite-energy data
with bounded initial vorticity. It implies \lean{LocalFiniteTimeVorticityBound u₀ ν} (for each $T_0$ one
ceiling, with the same boundedness clause, on intervals $[0,T]$, $T\le T_0$).''')
rep(r'''Assume, for all $u_0$ and $\nu$: (hKato) a Kato local witness for smooth divergence-free finite-energy $u_0$
and $\nu>0$; (hcont) \lean{BKMGlobalContinuation u₀ ν}; and (hDI) \lean{LocalTetherRate u₀ ν}. Then there is a
kernel $\Tf_F$ such that: (1) every kernel with density equal to the canonical tether density equals $\Tf_F$;
and (2) for every $\nu>0$ and every smooth divergence-free finite-energy $u_0$ there are $u,p$ with
\lean{NS_PDE u p ν}, $u(0)=u_0$, and $u(t)$ smooth and divergence-free for all $t\ge0$.''',
r'''Assume: (hKato) a Kato local witness for every smooth divergence-free finite-energy $u_0$ and $\nu>0$;
(hcont) \lean{BKMGlobalContinuation u₀ ν} for all $u_0$ and all $\nu>0$; and (hDI) \lean{LocalTetherRate u₀ ν}
for all $\nu>0$ and all $u_0$ with bounded vorticity. Then there is a kernel $\Tf_F$ such that: (1) every kernel
with density equal to the canonical tether density equals $\Tf_F$; and (2) for every $\nu>0$ and every smooth
divergence-free finite-energy $u_0$ with bounded vorticity there are $u,p$ with \lean{NS_PDE u p ν}, $u(0)=u_0$,
and $u(t)$ smooth and divergence-free for all $t\ge0$.''')
rep(r'''solutions), then the continuation hypothesis.''',r'''solutions), then the continuation hypothesis. In version 0.1.4 the hypothesis (hDI) was unsatisfiable
(Theorem~\ref{thm:escape}), so the 0.1.4 statement was vacuous; the 0.1.5 statement is not.''')
rep(r'''\begin{theorem}[\lean{clay_B_exact_of_periodic_tether_bound}]
If \lean{PeriodicTetherClosingBound ν} and \lean{PeriodicBKMContinuation ν} hold for every $\nu>0$, then
\lean{Clay_B_exact}.
\end{theorem}

\lean{PeriodicTetherClosingBound} is a uniform vorticity bound for all periodic smooth data and
\lean{PeriodicBKMContinuation} says that such a bound yields a global periodic smooth solution. Together they
are at least as strong as the conclusion; the reduction is a formal bookkeeping step and makes no progress
on (B).''',r'''The Main Theorem (Theorem~\ref{thm:mainA}, \lean{clay_B_exact_of_periodic_tether_bound}) concludes
\lean{Clay_B_exact} from \lean{PeriodicTetherClosingBound ν} and \lean{PeriodicBKMContinuation ν} for every
$\nu>0$. Its two hypotheses are open, and together they are at least as strong as the conclusion; the theorem
isolates the tether bound as the single estimate that, with classical continuation, yields (B).''')
open(p,'w').write(s)
