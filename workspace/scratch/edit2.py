p='manuscript/main.tex'; s=open(p).read()
def rep(old,new):
    global s
    assert old in s, old[:90]
    s=s.replace(old,new,1)
rep(r'''smoothness, and the non-existence of Kato witnesses for nonzero periodic data (Section~\ref{sec:explicit}).
''',r'''smoothness, and the non-existence of Kato witnesses for nonzero periodic data (Section~\ref{sec:explicit});
the one-sided comparison Lemma~\ref{lem:cmpright}; the audit results of Section~\ref{sec:corr} (junk value of the
supremum, the degenerate local solution, the refutation of the 0.1.4 \lean{LocalTetherRate}, and
\lean{localTetherRate_zero}).
''')
rep(r'''Canonicity (from saturation and polarization); Casimir conservation''',r'''The Main Theorem~\ref{thm:mainA} (from the tether bound and periodic BKM continuation) and
Theorem~\ref{thm:mainB} (BKM integrability from the tether bound); canonicity (from saturation and polarization); Casimir conservation''')
rep(r'''hypotheses on local solutions, Kato existence, Kato--BKM continuation and uniqueness); the Clay (B) reduction. The hypotheses are
listed by category in Section~\ref{sec:assumptions}.''',r'''hypotheses on local solutions, Kato existence, Kato--BKM continuation and uniqueness). The hypotheses are
those of Section~\ref{sec:conditional}, annotated in Section~\ref{sec:assumptions}.''')
rep(r'''\item The cubic rate \lean{LocalTetherRate} (or \lean{FrohmanianTetherRate}), any closing bound, or any damping mechanism from the tether''',
r'''\item The Frohmanian tether bound \lean{PeriodicTetherClosingBound} or \lean{PeriodicTetherBound} at any nonzero datum;
the converse BKM integrability $\Rightarrow$ tether bound and its pillars (P1)--(P3) (Section~\ref{sec:converse}).
\item The cubic rate \lean{LocalTetherRate} (or \lean{FrohmanianTetherRate}), any closing bound, or any damping mechanism from the tether''')
rep(r'''\subsection{Remaining assumptions, by category}\label{sec:assumptions}
Every remaining assumption is an explicit Lean argument or a named \lean{Prop}. None is an axiom.''',
r'''\subsection{Annotations to the open hypotheses}\label{sec:assumptions}
The hypotheses are those listed in Section~\ref{sec:conditional}; this subsection records, for each, where it is
used and how it relates to the classical literature. Every one is an explicit Lean argument or a named
\lean{Prop}. None is an axiom.''')
rep(r'''uniqueness clauses only); \lean{PeriodicBKMContinuation} (Clay reduction);''',r'''uniqueness clauses only); \lean{PeriodicBKMContinuation} (hypothesis (ii) of the Main Theorem: local existence,
uniqueness and Beale--Kato--Majda continuation for classical periodic solutions);''')
rep(r'''\item[(d) Equivalent in strength to the open problem.] \lean{LocalTetherRate} (the cubic rate on every local
physical solution; it also asks for time-differentiability of $\|\omega(t)\|_{L^\infty}$, which can fail for
genuine flows); \lean{LocalTetherBound} and \lean{ClayStatements.LocalTetherClosingBound} (uniform vorticity
bounds on local solutions); \lean{ClayStatements.PeriodicTetherClosingBound} and''',
r'''\item[(d) Equivalent in strength to the open problem.] The Frohmanian tether bound
\lean{ClayStatements.PeriodicTetherClosingBound} (hypothesis (i) of the Main Theorem) and its per-datum form
\lean{PeriodicTetherBound}; \lean{LocalTetherRate} (the cubic rate on every local physical solution, as a
right-derivative inequality since 0.1.5); \lean{LocalTetherBound} and \lean{ClayStatements.LocalTetherClosingBound}
(uniform vorticity bounds on local solutions, with bounded vorticity since 0.1.5);''')
rep(r'''(Section~\ref{sec:explicit}). They are not discharged by the explicit flows; the list above is unchanged by
version 0.1.4.''',r'''(Section~\ref{sec:explicit}). They are not discharged by the explicit flows.''')
rep(r'''\measure_iUnion}, \lean{ENNReal.tsum_const_eq_top_of_ne_zero}.''' if False else r'''\lean{measure_iUnion}, \lean{ENNReal.tsum_const_eq_top_of_ne_zero}.''',
r'''\lean{measure_iUnion}, \lean{ENNReal.tsum_const_eq_top_of_ne_zero}. Modules \lean{TetherImpliesBKM} and
\lean{TetherDefinitionAudit} (0.1.5): \lean{lintegral}, \lean{setLIntegral_mono'}, \lean{setLIntegral_const},
\lean{Real.volume_Ico}, \lean{Real.iSup_of_not_bddAbove}, \lean{image_le_of_liminf_slope_right_lt_deriv_boundary},
\lean{HasDerivWithinAt.liminf_right_slope_le}, \lean{hasDerivAt_iff_isLittleO}, \lean{Asymptotics.isLittleO_pow_id},
\lean{tendsto_inv_nhdsGT_zero}.''')
open(p,'w').write(s)
