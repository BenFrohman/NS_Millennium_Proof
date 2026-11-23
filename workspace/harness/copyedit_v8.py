import re,io
def sub(path,pairs):
    s=open(path,encoding='utf8').read()
    for a,b in pairs:
        if a not in s: raise SystemExit(f"MISSING in {path}: {a[:70]}")
        s=s.replace(a,b)
    open(path,'w',encoding='utf8').write(s)
P='periodic-ns-classical-continuation/'; M='metriplectic-world-model/'
COUNT_P=(r"\paragraph{Counting convention.} Two counts are reported, each with its method. "
 r"(i)~\emph{Source count:} 726 declarations introduced by the keywords \texttt{theorem} or \texttt{lemma} "
 r"(optionally preceded by attributes or modifiers) in the tracked \texttt{.lean} files of this repository, excluding \file{AxiomAudit.lean}. "
 r"(ii)~\emph{Kernel count:} 833 non-internal theorem constants in the \texttt{PeriodicNSContinuation} module tree, as reported by \file{AxiomAudit.lean}; "
 r"this includes theorems generated automatically by Lean. "
 r"An earlier figure of 727 was not obtained by either method and is withdrawn; the figure 726 used in versions~$\le$7 is the source count.")
# ---- periodic main
sub(P+'paper/periodic-ns-classical-continuation.tex',[
 (r"(Lean development at commit \file{a35d13a})", r"(Lean development at commit \file{f9a26c7})"),
 (r"\section{Conventions and naming}", r"""\section{Introduction}
The incompressible Navier--Stokes equations on the three-dimensional torus $\TT$ are the setting of Statement~(B) of the Clay Millennium Problem~\cite{Fefferman2000}. Their classical continuation theory---local existence, uniqueness, the $H^s$ energy identities and the Beale--Kato--Majda (BKM) criterion~\cite{BKM1984}---is well established on paper. The purpose of this work is to formalize that theory in Lean~4 with Mathlib~\cite{Lean4,Mathlib2020}, and to record precisely which steps are machine-checked without hypotheses, which are machine-checked relative to explicitly named hypotheses, and which remain open.

Section~\ref{sec:proved} collects the results proved with no hypothesis Props. Section~\ref{sec:conditional} records the conditional results, culminating in the reduction of Statement~(B) to the single open hypothesis \lean{PeriodicBKMIntegrability}. Section~\ref{sec:wip} documents the further reductions of that hypothesis obtained so far, and Section~\ref{sec:status} summarizes the status of every named Prop. No result in this paper resolves the Clay problem.

\section{Conventions and naming}"""),
 (r"\section{Proved results (no hypothesis Props)}", r"\section{Proved results (no hypothesis Props)}\label{sec:proved}"),
 (r"\section{Conditional results}", r"\section{Conditional results}\label{sec:conditional}"),
 (r"\section{Attacking the open hypothesis (work in progress)}", r"\section{Further reductions of the open hypothesis (work in progress)}\label{sec:wip}"),
 (r"(commits \file{f981e71}, \file{052cef1}, \file{ea5133d}, \file{0cd3551}, \file{a35d13a}). All names are coined.", r"(commits \file{f981e71}, \file{052cef1}, \file{ea5133d}, \file{0cd3551}, \file{a35d13a}); the file names are historical. All identifiers in this section are coined."),
 (r"both \textbf{not formalized} at the time. \emph{Update:} the trilinear", r"neither of which was formalized at that stage. Subsequently, the trilinear"),
 (r"This does not resolve the Clay problem. \emph{Bug fix:} the earlier hypothesis", r"This does not resolve the Clay problem. \emph{Correction.} The earlier hypothesis"),
 (r"\lean{PeriodicDirectionRegularity}. New: \lean{periodicDirectionCriterion_of_growth} proves", r"\lean{PeriodicDirectionRegularity}. In addition, \lean{periodicDirectionCriterion_of_growth} proves"),
 (r"\emph{Mismatch found.} \lean{PeriodicH2SmoothingRate} asks for", r"\emph{Discrepancy with the standard estimate.} The hypothesis \lean{PeriodicH2SmoothingRate} requires"),
 (r"The pointwise form is not known to hold. It is kept (and marked) but is replaced by", r"The pointwise form is not known to hold. It is retained in the development, marked accordingly, and superseded by"),
 (r"\section{Status}", r"\section{Status}\label{sec:status}"),
 (r"\section*{Reproducibility}"+"\n"+r"\texttt{lake build}; \texttt{lake env lean AxiomAudit.lean} (726 theorems and lemmas in this repository; 0 \texttt{sorry}; only \lean{propext}, \lean{Classical.choice}, \lean{Quot.sound}).",
  r"\section*{Reproducibility}"+"\n"+r"Run \texttt{lake build} and then \texttt{lake env lean AxiomAudit.lean}. The build contains no \texttt{sorry}, and the audit reports only \lean{propext}, \lean{Classical.choice} and \lean{Quot.sound}."+"\n\n"+COUNT_P),
])
# ---- periodic reduction
sub(P+'paper/reduction/reduction.tex',[
 (r"(Lean development at commit \file{a35d13a})", r"(Lean development at commit \file{f9a26c7})"),
 (r"(commit \file{a35d13a}), we prove two results", r"(commit \file{f9a26c7}), we prove two results"),
 (r"\section{\texorpdfstring{The periodic chain on $\mathbb{T}^3$}", r"""\section{Introduction}
The Beale--Kato--Majda criterion~\cite{BKM1984} asserts that a smooth solution of the three-dimensional Navier--Stokes equations can cease to be smooth at a finite time $T$ only if $\int_0^T\norm{\omega(t)}_{L^\infty}\dd t=\infty$. Consequently, Statement~(B) of the Clay Millennium Problem~\cite{Fefferman2000} on the torus is equivalent to the time-integrability of the vorticity sup-norm for every smooth periodic initial field. In this paper we report a machine-checked version of this reduction in Lean~4: the criterion and the required $H^3$ control are proved with no hypothesis Props, and Statement~(B) is derived from the single named hypothesis \lean{PeriodicBKMIntegrability}, which remains open. Section~\ref{sec:stated} tabulates precisely what is stated and what is proved.

\section{\texorpdfstring{The periodic chain on $\mathbb{T}^3$}"""),
 (r"it is not a weaker or ``technical'' leftover. This converse, from (B) itself, is argued informally here.", r"it is not a weaker, merely technical residue. This converse, from Statement~(B) itself, is argued informally here."),
 (r"(current commit; 726 theorems and lemmas, 0 \texttt{sorry}).", r"(current commit; 0 \texttt{sorry})."+"\n\n"+COUNT_P),
])
COUNT_M=(r"\paragraph{Counting convention.} The figure 765 is the \emph{kernel count}: the number of non-internal theorem constants in the module trees \texttt{MetriplecticWorldModel}, \texttt{FrohmanianSymplecticTether} and \texttt{TetherMayForm}, as printed by \file{AxiomAudit.lean} (\texttt{TOTAL theorems=765 nonstandard=0}). "
 r"For comparison, the \emph{source count} of declarations introduced by \texttt{theorem} or \texttt{lemma} in the tracked \texttt{.lean} files, excluding \file{AxiomAudit.lean}, is 342; the difference consists of theorems generated by Lean and by declaration commands other than \texttt{theorem}/\texttt{lemma}.")
sub(M+'paper/metriplectic-world-model.tex',[
 (r"\section{Naming}", r"""\section{Introduction}
Metriplectic dynamics~\cite{Morrison1986} combine a Hamiltonian (antisymmetric) bracket with a dissipative (symmetric) bracket. This paper documents a Lean~4 formalization of the author's tethered metriplectic model of three-dimensional vorticity dynamics, in which a symmetric tether bracket adds cubic damping of the peak vorticity. We establish the algebraic structure of the brackets (Section~\ref{sec:brackets}), the comparison-ODE ceilings and their dependence on the stretching hypothesis (Section~\ref{sec:ceiling}), several obstructions arising from the encoding (Section~\ref{sec:enc}), and the analytic facts about the Newton potential and the Biot--Savart law on $\R^3$ needed for the helicity results. The model is not the Navier--Stokes system, and no statement about unmodified Navier--Stokes is made.

\section{Naming}"""),
 (r"\section{Brackets and canonicity (\texttt{Bracket.lean}, \texttt{Canonical.lean})}", r"\section{Brackets and canonicity (\texttt{Bracket.lean}, \texttt{Canonical.lean})}\label{sec:brackets}"),
 (r"\section{Ceiling and stretching (\texttt{Ceiling.lean}, \texttt{AuditFixes.lean})}", r"\section{Ceiling and stretching (\texttt{Ceiling.lean}, \texttt{AuditFixes.lean})}\label{sec:ceiling}"),
 (r"\section{Encoding obstructions (\texttt{ChoiceFree}, \texttt{HelmholtzObstruction}, \texttt{TestClass})}", r"\section{Encoding obstructions (\texttt{ChoiceFree}, \texttt{HelmholtzObstruction}, \texttt{TestClass})}\label{sec:enc}"),
 (r"Its honest replacement is", r"Its replacement, consistent with the known estimates in form, is"),
 (r"\noindent\emph{Definition fix.}", r"\noindent\emph{Correction to a definition.}"),
])
sub(M+'paper/reduction/tethered-ceiling-reduction.tex',[
 (r"\section{The cubic-tethered vorticity model}", r"""\section{Introduction}
Adding a cubic damping term to the vorticity equation produces a model in which the peak vorticity $Y(t)=\sup_x\abs{\omega(t,x)}$ satisfies a comparison inequality of the form $Y'\le CY^2-\kappa Y^3$, which yields a uniform-in-time ceiling. The difficulty lies in the vortex-stretching term, whose known bounds involve norms stronger than $Y$. In this paper we isolate exactly what is needed: we prove, in Lean~4, a uniform ceiling for the cubic-tethered model conditional on a $Y$-only logarithmic stretching hypothesis and six explicit regularity and support hypotheses, and we explain why the classical Calder\'on--Zygmund estimate does not supply the stretching hypothesis.

\section{The cubic-tethered vorticity model}"""),
 (r"(765 theorems) throws an error", r"(765 theorems; see the counting convention below) throws an error"),
 (r"Every theorem above is in the audit.", r"Every theorem above is in the audit."+"\n\n"+COUNT_M),
])
# READMEs
s=open(P+'README.md',encoding='utf8').read()
s=s.replace("`∫_{T³} |K_{vpWeight R}(x − y)| dy ≤ C`",r"$\int_{\mathbb{T}^3} |K_{\mathrm{vpWeight}\,R}(x-y)|\,dy \le C$")
s=s.replace("T³",r"$\mathbb{T}^3$")
s=s.replace("(mismatch noted). 726 theorems and lemmas in this repository;","(discrepancy documented). 726 `theorem`/`lemma` declarations in the source (kernel audit: 833 theorem constants, including Lean-generated ones; the earlier figure 727 is withdrawn);")
i=s.index("**Final status:**"); j=s.index("What is proved vs. conditional:")
fin=s[i:j].rstrip()+"\n"; whatp=s[j:].rstrip()+"\n"
s=s[:i]+whatp+"\n"+fin
open(P+'README.md','w',encoding='utf8').write(s)
s=open(M+'README.md',encoding='utf8').read()
s=s.replace("**R³ vs T³:**",r"**$\mathbb{R}^3$ vs. $\mathbb{T}^3$:**")
s=s.replace("# 765 theorems,","# 765 theorem constants (kernel count; 342 theorem/lemma declarations in source),")
open(M+'README.md','w',encoding='utf8').write(s)
