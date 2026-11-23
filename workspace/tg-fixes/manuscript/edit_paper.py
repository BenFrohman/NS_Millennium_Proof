import sys
p = sys.argv[1]
s = open(p, encoding="utf-8").read()
def rep(old, new):
    global s
    assert s.count(old) == 1, ("NOT FOUND/UNIQUE", old[:80])
    s = s.replace(old, new)

rep(r"\newtheorem{lemma}[theorem]{Lemma}",
    r"\newtheorem{lemma}[theorem]{Lemma}" "\n" r"\newtheorem{conjecture}[theorem]{Conjecture}")
rep(r"\date{November 4, 2026}", r"\date{November 23, 2026}")
rep(r"""$\dot M\le C-\kappa' M^2$ for $M=\|\omega\|_{L^\infty}$ and shows it is not derived from the
Navier--Stokes equations. We prove instead (i) a conditional regularity theorem: any Leray--Hopf
solution satisfying a one-sided Riccati hypothesis is globally smooth (via Beale--Kato--Majda);
and (ii) unconditional global regularity for an explicitly \emph{modified} tether-damped system.""",
r"""$\dot M\le C-\kappa' M^2$ for $M=\|\omega\|_{L^\infty}$ and shows it is not derived from the
Navier--Stokes equations. We prove instead a conditional regularity theorem: if $M$ satisfies a one-sided
Riccati inequality, and the Beale--Kato--Majda continuation criterion and parabolic smoothing are taken as
named hypotheses, then $M$ stays bounded, the solution is global, and it is smooth. For an explicitly
\emph{modified} tether-damped system we state global regularity only as a conjecture, with a heuristic sketch.
Every result this paper claims is a Lean~4 theorem whose statement is locked to the text (Appendix~\ref{app:lean});
results from the literature are cited, not claimed.""")
rep(r"""Claim in the source manuscript & Status & Reason\\\midrule
Vorticity equation from NS & Proved & Classical (curl of NS).\\
Arnold Lie--Poisson bracket reproduces Euler & Proved & Arnold 1966; Marsden--Weinstein 1983.\\
$B(F,G)$ / $\mathfrak T_F$ correction is a ``2-form'' & False & $-\kappa\int|\omega|^2\delta u\cdot\delta v$ is symmetric (Lemma~\ref{lem:sym}).\\
$\{\cdot,\cdot\}_{\mathfrak T_F}$ satisfies Jacobi via MWR & Gap/false & A bracket with nonzero symmetric part is not Poisson; MWR reduction concerns symmetry groups, not perturbations.\\
Degeneracy $B(F,H)=0$ & Proved & By the projection $\Pi_u$; hence $B$ does not change $\dot F=\{F,H\}$.\\
Invariance under $\mathrm{SDiff}$ & Proved (for the local form) & $|\omega|^2$ and the $L^2$ pairing are transported (Prop.~\ref{prop:inv}). Not for the $K_{\rm BS}$ form without extra argument.\\""",
r"""Claim in the source manuscript & Status & Reason\\\midrule
Vorticity equation from NS & Classical (cited) & Curl of NS.\\
Arnold Lie--Poisson bracket reproduces Euler & Classical (cited) & Arnold 1966; Marsden--Weinstein 1983.\\
$B(F,G)$ / $\mathfrak T_F$ correction is a ``2-form'' & False & $\kappa\int|\omega|^2\delta u\cdot\delta v$ is symmetric (Lemma~\ref{lem:sym}, Lean).\\
$\{\cdot,\cdot\}_{\mathfrak T_F}$ satisfies Jacobi via MWR & Gap/false & A bracket with nonzero symmetric part is not antisymmetric, hence not Poisson (Lemma~\ref{lem:sym}(c), Lean); MWR reduction concerns symmetry groups, not perturbations.\\
Degeneracy $B(F,H)=0$ & Proved (Lean) & By the projection $\Pi_u$ (Proposition~\ref{prop:status}).\\
Invariance under $\mathrm{SDiff}$ & Not claimed here & Remark~\ref{rem:inv}: expected only for isometries; not formalized.\\""")
rep(r"""Tether-damped model regularity (Thm.~\ref{thm:model}) & Proved & Maximum principle; modified equation.\\
\bottomrule
\end{tabular}
\end{center}""",
r"""Tether-damped model regularity (Conj.~\ref{thm:model}) & Open & Heuristic sketch only; modified equation.\\
\bottomrule
\end{tabular}
\end{center}
\noindent\textbf{Scope of claims.} The results this paper claims are exactly Lemma~\ref{lem:sym}, Propositions~\ref{prop:status},
\ref{prop:degen} and~\ref{prop:mirror}, and Theorem~\ref{thm:cond}. Each is a Lean~4 theorem (Appendix~\ref{app:lean}) whose
statement is locked to the text by the repository's Truth Gate. Rows marked ``Classical (cited)'' and statements
attributed to the literature are background and are not claimed or formalized here; rows marked ``Gap'', ``False as stated''
or ``Error'' are assessments of the source manuscript; remarks are commentary.""")
rep(r"""Conditional theorem (Thm.~\ref{thm:cond}) & Proved (conditional) & New formulation; hypothesis unverified for NS.\\""",
    r"""Conditional theorem (Thm.~\ref{thm:cond}) & Proved (conditional, Lean) & Hypotheses named; Riccati hypothesis unverified for NS.\\""")
rep(r"""BKM $\Rightarrow$ global smoothness given bounded $M$ & Proved & Beale--Kato--Majda 1984.\\
Log-Sobolev continuation (notes) & Proved & Brezis--Gallou\'et/Kozono--Taniuchi; Strategy B correct.\\""",
    r"""BKM $\Rightarrow$ global smoothness given bounded $M$ & Classical (cited) & Beale--Kato--Majda 1984.\\
Log-Sobolev continuation (notes) & Classical (cited) & Brezis--Gallou\'et/Kozono--Taniuchi; Strategy B correct.\\""")

rep(r"""\begin{definition}
For $\kappa>0$ define on divergence-free $\delta u,\delta v$ the bilinear form
$\mathfrak g_\omega(\delta u,\delta v)=\kappa\int_{\T}|\omega|^2\,\delta u\cdot\delta v\,dV$
and the projected version $\mathfrak g^\Pi_\omega(\delta u,\delta v)=\mathfrak g_\omega(\Pi_u\delta u,\Pi_u\delta v)$.
\end{definition}
\begin{lemma}\label{lem:sym}
$\mathfrak g_\omega$ is symmetric and positive semidefinite. Hence $\Omega_{\rm KKS}-\mathfrak g_\omega$ is not
antisymmetric and the ``tethered bracket'' is not a Poisson bracket unless $\mathfrak g_\omega=0$.
\end{lemma}
\begin{proof}Symmetry is clear; antisymmetry of a Poisson bracket forces the symmetric part to vanish.\end{proof}
\begin{proposition}\label{prop:inv}
$\mathfrak g_\omega$ is $\mathrm{SDiff}$-equivariant: $\mathfrak g_{g_*\omega}(g_*\delta u,g_*\delta v)=\mathfrak g_\omega(\delta u,\delta v)$
when $g$ is an isometry; for general $g\in\mathrm{SDiff}$ the pointwise norms are not preserved and equivariance fails.
\end{proposition}
\begin{proof}Volume preservation handles $dV$; $|g_*\omega|\circ g=|Dg\,\omega|$, which equals $|\omega|$ iff $Dg$ is orthogonal along $\omega$.\end{proof}
\begin{remark}This corrects the source's Invariance Lemma: invariance holds only under isometries, not the full coadjoint action.\end{remark}
\begin{proposition}[Correct status of the tether: a metriplectic metric]
$\mathfrak g^\Pi$ satisfies $\mathfrak g^\Pi(\cdot,\delta H)=0$, so the metriplectic flow $\dot F=\{F,H\}-\mathfrak g^\Pi(\delta F,\delta S)$
conserves $H$ for any entropy $S$. In particular $\mathfrak g^\Pi$ contributes nothing to $\dot F=\{F,H\}$; it can only act through an additional functional $S$, which must be \emph{added} to the equations.
\end{proposition}""",
r"""\begin{definition}
Let $(X,\mu)$ be a measure space; the case of interest is $X=\T$ with $\mu=dV$. Let $\kappa>0$, let
$\omega\colon X\to\mathbb R^3$, and let $\Pi\colon\delta u\mapsto\Pi\delta u$ be any map of vector fields $X\to\mathbb R^3$
(for us, $\Pi=\Pi_u$, the projection onto $\delta H^\perp$). For vector fields $\delta u,\delta v\colon X\to\mathbb R^3$ (in the
application, divergence-free) define
$\mathfrak g_\omega(\delta u,\delta v)=\kappa\int_X|\omega|^2\,\delta u\cdot\delta v\,d\mu$, where $|\omega|^2=\sum_{i=1}^3\omega_i^2$ and
$\delta u\cdot\delta v=\sum_{i=1}^3\delta u_i\,\delta v_i$, and the projected version
$\mathfrak g^\Pi_\omega(\delta u,\delta v)=\mathfrak g_\omega(\Pi\delta u,\Pi\delta v)$. The integral is the Lebesgue integral, with the
convention that it equals $0$ when the integrand is not integrable.
\end{definition}
\begin{lemma}\label{lem:sym}
(a) For all $\delta u,\delta v$: $\mathfrak g_\omega(\delta u,\delta v)=\mathfrak g_\omega(\delta v,\delta u)$ and $\mathfrak g_\omega(\delta u,\delta u)\ge0$.
(b) For all $\delta u,\delta v$: $\mathfrak g^\Pi_\omega(\delta u,\delta v)=\mathfrak g^\Pi_\omega(\delta v,\delta u)$ and $\mathfrak g^\Pi_\omega(\delta u,\delta u)\ge0$.
(c) Let $V$ be any set, $\Omega\colon V\times V\to\mathbb R$ antisymmetric ($\Omega(a,b)+\Omega(b,a)=0$) and $\mathfrak g\colon V\times V\to\mathbb R$
symmetric. Then $\Omega-\mathfrak g$ is antisymmetric if and only if $\mathfrak g=0$. In particular the ``tethered bracket''
$\Omega_{\rm KKS}-\mathfrak g_\omega$ is not antisymmetric, hence not a Poisson bracket, unless $\mathfrak g_\omega$ vanishes identically.
\end{lemma}
\begin{proof}(a) $\delta u\cdot\delta v=\delta v\cdot\delta u$ pointwise, and the integrand $|\omega|^2|\delta u|^2$ is nonnegative.
(b) is (a) applied to $\Pi\delta u,\Pi\delta v$. (c) Adding $(\Omega-\mathfrak g)(a,b)+(\Omega-\mathfrak g)(b,a)=0$ to the
antisymmetry of $\Omega$ gives $\mathfrak g(a,b)+\mathfrak g(b,a)=0$, i.e.\ $2\mathfrak g(a,b)=0$; the converse is immediate.\end{proof}
\begin{remark}[Equivariance; not claimed]\label{rem:inv}
One expects $\mathfrak g_{g_*\omega}(g_*\delta u,g_*\delta v)=\mathfrak g_\omega(\delta u,\delta v)$ when $g\in\mathrm{SDiff}$ is an isometry:
volume preservation handles $dV$, and $|g_*\omega|\circ g=|Dg\,\omega|$, which equals $|\omega|$ when $Dg$ is orthogonal along $\omega$.
For general $g\in\mathrm{SDiff}$ the pointwise norms are not preserved. This computation is not formalized and is not
claimed as a result of this paper; it indicates that the source's Invariance Lemma can hold at most for isometries.
\end{remark}
\begin{proposition}[Correct status of the tether: a metriplectic metric]\label{prop:status}
Let $V$ be a real vector space, $\{\cdot,\cdot\}\colon V\times V\to\mathbb R$ antisymmetric ($\{a,b\}+\{b,a\}=0$),
$\mathfrak g$ a real bilinear form on $V$, $\Pi\colon V\to V$ linear, and $\delta H,\delta S\in V$ with $\Pi\,\delta H=0$
(as for $\Pi=\Pi_u$). Write $\mathfrak g^\Pi(a,b)=\mathfrak g(\Pi a,\Pi b)$. Then $\mathfrak g^\Pi(\delta F,\delta H)=0$ for every $\delta F\in V$,
and the metriplectic rate $\dot F=\{\delta F,\delta H\}-\mathfrak g^\Pi(\delta F,\delta S)$ gives $\dot H=0$ for every $\delta S$.
\end{proposition}
\begin{proof}$\Pi\,\delta H=0$ and bilinearity give $\mathfrak g^\Pi(\cdot,\delta H)=0$; antisymmetry gives $\{\delta H,\delta H\}=0$.\end{proof}
\begin{remark}Thus $\mathfrak g^\Pi$ contributes nothing to $\dot H$; it can only act through an additional functional $S$, which must be \emph{added} to the equations.\end{remark}""")

rep(r"""(D1) $\{F,S\}=0$ for all $F$ ($S$ a Casimir), (D2) $(F,H)=0$ for all $F$.
\begin{proposition}\label{prop:degen}
Under (D1)--(D2): (a) $\dot H=0$; (b) $\dot S=(S,S)\ge0$; (c) the Hamiltonian part $X_H$ is the unmodified Lie--Poisson (Euler) field, and its flow, forward or time-reversed, maps each coadjoint orbit to itself and preserves $\Omega_{\rm KKS}$; (d) the full flow is in general transverse to the orbits.
\end{proposition}
\begin{proof}(a) $\dot H=\{H,H\}+(H,S)=0$ by antisymmetry and (D2). (b) $\{S,H\}=0$ by (D1). (c) $(F,S)$ does not enter $X_H$; Hamiltonian flows of Lie--Poisson brackets preserve symplectic leaves and their forms, and $t\mapsto -t$ is again Hamiltonian (for $-H$). (d) $(F,S)$ changes Casimirs whenever $(C,S)\neq0$.\end{proof}""",
r"""(D1) $\{F,S\}=0$ for all $F$ ($S$ a Casimir), (D2) $(F,H)=0$ for all $F$.
\begin{proposition}\label{prop:degen}
Let $V$ be a real vector space of gradients, $\{\cdot,\cdot\}$ and $(\cdot,\cdot)$ real bilinear forms on $V$ with $\{\cdot,\cdot\}$
antisymmetric and $(\cdot,\cdot)$ symmetric and positive semidefinite, $\delta H,\delta S\in V$, and
$\dot F=\{\delta F,\delta H\}+(\delta F,\delta S)$. Under (D1) $\{\delta F,\delta S\}=0$ for all $\delta F$ and (D2) $(\delta F,\delta H)=0$ for all $\delta F$:
(a) $\dot H=0$; (b) $\dot S=(\delta S,\delta S)\ge0$.
\end{proposition}
\begin{proof}(a) $\dot H=\{\delta H,\delta H\}+(\delta H,\delta S)=0$ by antisymmetry, symmetry and (D2). (b) $\{\delta S,\delta H\}=-\{\delta H,\delta S\}=0$ by (D1).\end{proof}
\begin{remark}[Geometry of the split; cited, not claimed]
Classically~\cite{Morrison1986,MarsdenRatiu}: (c) the Hamiltonian part $X_H$ is the unmodified Lie--Poisson (Euler) field, and its flow,
forward or time-reversed, maps each coadjoint orbit to itself and preserves $\Omega_{\rm KKS}$, since $(F,S)$ does not enter $X_H$;
(d) the full flow is in general transverse to the orbits, since $(F,S)$ changes Casimirs whenever $(C,S)\neq0$. These statements
about the infinite-dimensional orbit geometry are not formalized and are not claimed as results of this paper.
\end{remark}""")
rep(r"""Hence for the velocity field alone, (c) gives""", r"""Hence for the velocity field alone, the classical statement (c) above gives""")
rep(r"""Proposition~\ref{prop:degen} applied to it is sound; its novelty""", r"""Proposition~\ref{prop:degen} applies to it; its novelty""")

rep(r"""\begin{proposition}[Frohman's mirror principle, sound form]\label{prop:mirror}
Write the tethered generator as the metriplectic split
\[ \dot F=\underbrace{\{F,H\}_{\rm LP}}_{\text{antisymmetric (2-form)}}\;-\;\underbrace{\mathfrak g^\Pi(\delta F,\delta S)}_{\text{symmetric (tether)}}, \]
where $\{\cdot,\cdot\}_{\rm LP}$ is the Lie--Poisson bracket (its leaves carry the genuine 2-form $\Omega_{\rm KKS}$) and $\mathfrak g^\Pi$ is the tether metric. Then:
(i) the two parts act side by side: the antisymmetric part conserves $H$ and every Casimir, while the symmetric part supplies the negative, dissipative ``mirror'' term, $\frac{d}{dt}S=\mathfrak g^\Pi(\delta S,\delta S)\ge0$, i.e.\ $-\frac{d}{dt}(-S)\le0$;
(ii) under the degeneracy conditions $\{F,S\}_{\rm LP}=0$ and $\mathfrak g^\Pi(\cdot,\delta H)=0$, the mirror term does not alter the reversible (Euler) field, nor $H$;
(iii) the balance is between \emph{types}: antisymmetric (reversible) versus symmetric (irreversible). It is not a cancellation inside the tether.
\end{proposition}
\begin{proof}(i) follows from antisymmetry of $\{\cdot,\cdot\}_{\rm LP}$ and positive semidefiniteness of $\mathfrak g^\Pi$ (Lemma~\ref{lem:sym}); (ii) is Proposition~\ref{prop:degen}; (iii) restates the decomposition of a bilinear form into antisymmetric and symmetric parts, which is unique.\end{proof}
\begin{remark}[Symmetric plus mirror stays symmetric]
Adding a negative copy $-\mathfrak g$ to a symmetric $\mathfrak g$ (or any symmetric correction) yields a symmetric form; it can never produce a 2-form. The only antisymmetric content of the tethered bracket is the Lie--Poisson part.
\end{remark}""",
r"""\begin{proposition}[Frohman's mirror principle, sound form]\label{prop:mirror}
Let $V$ be a real vector space, $\{\cdot,\cdot\}_{\rm LP}\colon V\times V\to\mathbb R$ antisymmetric ($\{a,b\}_{\rm LP}+\{b,a\}_{\rm LP}=0$),
$\mathfrak g$ a positive semidefinite real bilinear form on $V$, $\Pi\colon V\to V$ linear, $\mathfrak g^\Pi(a,b)=\mathfrak g(\Pi a,\Pi b)$,
$\delta H,\delta S\in V$, and write the tethered generator as the metriplectic split
\[ \dot F=\underbrace{\{\delta F,\delta H\}_{\rm LP}}_{\text{antisymmetric (2-form)}}\;-\;\underbrace{\mathfrak g^\Pi(\delta F,\delta S)}_{\text{symmetric (tether)}}. \]
Then:
(i) $\{\delta H,\delta H\}_{\rm LP}=0$, and $\{\delta C,\delta H\}_{\rm LP}=0$ for every Casimir $\delta C$ (that is, $\{\delta C,\cdot\}_{\rm LP}=0$), so the
antisymmetric part conserves $H$ and every Casimir; and if $\{\delta F,\delta S\}_{\rm LP}=0$ for all $\delta F$, then
$\frac{d}{dt}S=-\mathfrak g^\Pi(\delta S,\delta S)\le0$: the symmetric part is the dissipative ``mirror'' term;
(ii) if $\{\delta F,\delta S\}_{\rm LP}=0$ for all $\delta F$ and $\Pi\,\delta H=0$, then $\dot H=0$ and $\mathfrak g^\Pi(\delta F,\delta H)=0$ for every $\delta F$:
the mirror term does not change $H$;
(iii) every $B\colon V\times V\to\mathbb R$ is $B=A+S$ with $A$ antisymmetric and $S$ symmetric, and this decomposition is unique.
The balance is therefore between \emph{types}, antisymmetric (reversible) versus symmetric (irreversible); it is not a cancellation inside the tether.
\end{proposition}
\begin{proof}(i) $\{\delta H,\delta H\}_{\rm LP}=0$ by antisymmetry; $\{\delta S,\delta H\}_{\rm LP}=-\{\delta H,\delta S\}_{\rm LP}=0$, and $\mathfrak g$ is
positive semidefinite. (ii) As in Proposition~\ref{prop:status}. (iii) $A(a,b)=\tfrac12(B(a,b)-B(b,a))$, $S(a,b)=\tfrac12(B(a,b)+B(b,a))$;
if $A_1+S_1=A_2+S_2$, evaluating at $(a,b)$ and $(b,a)$ gives $A_1=A_2$ and $S_1=S_2$.\end{proof}
\begin{remark}[Sign convention]
An earlier version stated $\frac{d}{dt}S=\mathfrak g^\Pi(\delta S,\delta S)\ge0$ for this generator; with the minus sign in front of
$\mathfrak g^\Pi$ the correct value is $-\mathfrak g^\Pi(\delta S,\delta S)\le0$, as in (i). With the opposite sign convention
$\dot F=\{F,H\}+(F,S)$ of Proposition~\ref{prop:degen} one has $\dot S\ge0$ instead.
\end{remark}
\begin{remark}[Symmetric corrections stay symmetric]
By Lemma~\ref{lem:sym}(c), adding any symmetric correction to an antisymmetric bracket gives an antisymmetric bracket only if the
correction vanishes. The only antisymmetric content of the tethered bracket is the Lie--Poisson part.
\end{remark}""")
rep(r"""by (ii) it leaves the stretching (reversible) part untouched.""", r"""it leaves the stretching (reversible) part untouched.""")
rep(r"""At a maximum point $x_*$ of $|\omega|^2$ one rigorously obtains (in the Dini sense)""",
    r"""At a maximum point $x_*$ of $|\omega|^2$ one obtains (in the Dini sense; classical, cited, not formalized here)""")

rep(r"""\begin{theorem}\label{thm:cond}
Let $u_0\in H^s(\T)$, $s>5/2$, $\nabla\cdot u_0=0$, $\nu>0$, and $u$ the local smooth solution on $[0,T^*)$.
Suppose there are $C\ge0,\kappa'>0$ with $D^+M(t)\le C-\kappa'M(t)^2$ on $[0,T^*)$. Then
$M(t)\le\max\{M(0),\sqrt{C/\kappa'}\}$, $T^*=\infty$, and $u\in C^\infty((0,\infty)\times\T)$.
\end{theorem}
\begin{proof}If $M(t_0)>K:=\max\{M(0),\sqrt{C/\kappa'}\}$, take the last $t_1<t_0$ with $M(t_1)=K$; on $(t_1,t_0]$, $D^+M<0$, so $M$ is nonincreasing (Dini monotonicity lemma), contradiction. Then $\int_0^{T}M<\infty$ for all $T$, and BKM~\cite{BKM1984} (or Strategy B of the log-Sobolev notes: local existence time depends only on $\|u\|_{H^s}$, which is bounded by Gronwall with the Kozono--Taniuchi inequality) gives $T^*=\infty$; parabolic smoothing gives $C^\infty$.\end{proof}
\begin{remark}The hypothesis is weaker-looking than BKM but not known to hold for any nontrivial class beyond those already known regular (small data, 2D-like symmetry).\end{remark}""",
r"""\begin{theorem}\label{thm:cond}
Let $T^*\in(0,\infty]$ (the lifespan of a solution $u$), $M\colon\mathbb R\to\mathbb R$ (only its values on $[0,T^*)$ enter; for
Navier--Stokes $M(t)=\|\omega(t)\|_{L^\infty}$), and $C\ge0$, $\kappa'>0$. For each $T>0$ let $\mathcal S(T)$ be the statement
``$u\in C^\infty((0,T]\times\T)$''. Assume:
\begin{itemize}
\item[(R)] \emph{Riccati hypothesis.} $M$ is continuous on $[0,t]$ for every $t\in[0,T^*)$, and for every $t\in(0,T^*)$, $M$ is differentiable at $t$ with $M'(t)\le C-\kappa'M(t)^2$;
\item[(BKM)] \emph{Beale--Kato--Majda continuation criterion.} If $T^*<\infty$, then $\sup_{0\le t<T^*}M(t)=\infty$;
\item[(PS)] \emph{Parabolic smoothing.} $\mathcal S(T)$ holds for every $T\in(0,T^*)$.
\end{itemize}
Then $M(t)\le\max\{M(0),\sqrt{C/\kappa'}\}$ for all $t\in[0,T^*)$, $T^*=\infty$, and $\mathcal S(T)$ holds for every $T>0$, i.e.\ $u\in C^\infty((0,\infty)\times\T)$.
\end{theorem}
\begin{proof}Let $K:=\max\{M(0),\sqrt{C/\kappa'}\}$ and suppose $M(t)>K$ for some $t\in[0,T^*)$. Let $s_0$ be the largest
$s\in[0,t]$ with $M(s)\le K$ (it exists by continuity, and $s_0<t$). On $(s_0,t)$ we have $M>K\ge\sqrt{C/\kappa'}$, hence
$M'\le C-\kappa'M^2<0$; by the mean value theorem $M(t)-M(s_0)<0$, contradicting $M(s_0)\le K<M(t)$. So $M\le K$ on $[0,T^*)$;
this bounded supremum contradicts (BKM) unless $T^*=\infty$, and then (PS) gives $\mathcal S(T)$ for every $T>0$.\end{proof}
\begin{remark}[Application to Navier--Stokes; cited, not formalized]
For $u_0\in H^s(\T)$, $s>5/2$, $\nabla\cdot u_0=0$, $\nu>0$, $u$ the local smooth solution with maximal time $T^*$ and
$M=\|\omega\|_{L^\infty}$, hypothesis (BKM) is a consequence of the Beale--Kato--Majda theorem~\cite{BKM1984} (or of Strategy B of the
log-Sobolev notes, via Kozono--Taniuchi~\cite{KozonoTaniuchi}), and (PS) is classical parabolic smoothing. Neither is formalized here;
Theorem~\ref{thm:cond} takes them as named hypotheses. Hypothesis (R) is \emph{not} known for Navier--Stokes. Theorem~\ref{thm:cond} uses
a classical derivative; the version with the Dini derivative $D^+M$, which is the natural object for $\|\omega\|_{L^\infty}$, is not formalized.
\end{remark}
\begin{remark}The Riccati hypothesis is weaker-looking than BKM but not known to hold for any nontrivial class beyond those already known regular (small data, 2D-like symmetry).\end{remark}""")

rep(r"""\section{An unconditional theorem for a tether-damped model}""", r"""\section{A conjecture for a tether-damped model}""")
rep(r"""\begin{theorem}\label{thm:model}
For $\kappa>0$, $\omega_0\in H^{s-1}$, $s>5/2$ (smooth, divergence-free), \eqref{eq:model} has a unique global smooth solution with
$\|\omega(t)\|_\infty\le \max\{\|\omega_0\|_\infty, C_*\}$ for a constant depending on $\kappa,\nu,\|\omega_0\|_{L^2}$.
\end{theorem}
\begin{proof}[Proof sketch with the one nontrivial step]""",
r"""\begin{conjecture}\label{thm:model}
For $\kappa>0$, $\omega_0\in H^{s-1}$, $s>5/2$ (smooth, divergence-free), \eqref{eq:model} has a unique global smooth solution with
$\|\omega(t)\|_\infty\le \max\{\|\omega_0\|_\infty, C_*\}$ for a constant depending on $\kappa,\nu,\|\omega_0\|_{L^2}$.
\end{conjecture}
\noindent This is not proved here and not claimed; the following sketch is heuristic.
\begin{proof}[Heuristic sketch, not a proof]""")
rep(r"""this theorem is a model result and not new in kind.""", r"""Conjecture~\ref{thm:model} is a model statement and would not be new in kind.""")
rep(r"""Part~I is sound once the tether is reclassified as a metriplectic metric; Part~II proves conditional regularity and
a model result.""", r"""Part~I is sound once the tether is reclassified as a metriplectic metric; Part~II proves conditional regularity
(Theorem~\ref{thm:cond}) and states the tether-damped model result only as a conjecture.""")

i0 = s.index(r"\section{Lean 4 certificate}")
i1 = s.index(r"\begin{thebibliography}")
s = s[:i0] + r"""\section{Lean 4 certificate}\label{app:lean}
\href{https://github.com/BenFrohman/frohmanian-tether-manuscript-2026-06-01/actions/workflows/lean.yml}{\texttt{lean} CI} builds
\texttt{lean/MirrorMetriplectic} (Lean v4.30.0-rc1, Mathlib v4.30.0-rc1) with no \texttt{sorry}, no \texttt{native\_decide}, and an
axiom audit showing only \texttt{propext}, \texttt{Classical.choice}, \texttt{Quot.sound}. The \texttt{truth-gate} CI locks the statement
of every claimed result to an independent Lean transcription of the text above (\texttt{lean/MirrorMetriplectic/Semantics.lean}).
\begin{center}\small
\begin{tabular}{ll}\toprule
Result in this paper & Lean theorem (\texttt{MirrorMetriplectic.*})\\\midrule
Lemma~\ref{lem:sym}(a),(b) & \texttt{tetherTensor\_symm\_psd}\\
Lemma~\ref{lem:sym}(c) & \texttt{sub\_symm\_antisymm\_iff}\\
Proposition~\ref{prop:status} & \texttt{tetherMetric\_degenerate}\\
Proposition~\ref{prop:degen} & \texttt{metriplectic\_rates}\\
Proposition~\ref{prop:mirror} & \texttt{mirror\_principle}\\
Theorem~\ref{thm:cond} & \texttt{conditional\_regularity} (with \texttt{riccati\_bound\_Icc})\\\bottomrule
\end{tabular}\end{center}
\emph{Cited, not formalized:} the infinite-dimensional Lie--Poisson and coadjoint-orbit geometry, the log-Sobolev/Kozono--Taniuchi
inequality, the Beale--Kato--Majda theorem and parabolic smoothing (hypotheses (BKM) and (PS) of Theorem~\ref{thm:cond}), and
Conjecture~\ref{thm:model}. The Riccati hypothesis (R) is \emph{not} proved for Navier--Stokes; Lean certifies only the implication.

""" + s[i1:]
open(p, "w", encoding="utf-8").write(s)
print("ok")
