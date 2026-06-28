# 03 — Quartic Weight "Forced by the Uniqueness Theorem", κ = C_CZ(3), ε=κ/4 Absorption (Stronger Verbatim)

**Sources**: Roadmaps (coefficient matching), Grok Project-Tether Theorem Draft (direct analytic counterpart + operationally necessary), EDITfinals.tex (explicit ε=κ/4 + C_abs), Full_Living_Document, NEXT1/main.tex + Main8DRAFTAppends, NS-Polished.

**Stronger phrasing for h_B_definition sub-haves + TetheredLyapunov lemma_3_1 + comments**:

> "The quartic weight in S_ε(t) is not chosen arbitrarily or motivated heuristically. It is the direct analytic counterpart of the unique quadratic metric correction whose existence and uniqueness were established from the geometric requirements (C1)–(C3) on the coadjoint orbit. Any other weight would either fail to produce sufficient absorption or would violate the degeneracy condition that keeps the reversible dynamics exactly classical. Thus the Tether is operationally necessary: its uniqueness forces the precise form of the controlling functional used in the bound."
> (Grok Draft :151–171; echoed in EDITfinals, NEXT1/main :869, Full_Living 1650+)

> "Define the mollified tethered Lyapunov functional (quartic weight forced by the uniqueness theorem of the tether)"
> (repeated in EDITfinals, Full_Living, Main8DRAFTAppends, Roadmaps polished abstract)

> "Using ... Young’s inequality together with Gagliardo–Nirenberg interpolation, we obtain the differential inequality ... with absorption parameter ε = κ/4 absorbs the positive stretching contribution into the leading negative quartic term −κ/2 ∫ |ω_ε|^6 dλ, leaving a remainder controlled by a universal constant C_abs that depends only on dimension, C_CZ(3), C_Sob, and the Gagliardo–Nirenberg constant on T³."
> (EDITfinals :233+; Full_Living similar; matches the exact "ε=κ/4" + traceable C_abs in the target TetheredLyapunov.lean)

**For the Lean phase-plane (y' = C y² − κ'' y³) and independent majorant**:
The above directly forces the κ'' coefficient in the Riccati comparison ODE from the geometric uniqueness, keeping the two-layer non-circular (geometric first).

**Roadmap strengthening**:
"the quartic weight κ/4 |ω|^4 ... is canonically forced by the uniqueness theorem and leading-coefficient matching at spatial maxima."

These are stronger than generic "motivated" language and directly support the "forced by the uniqueness theorem" comments already in the target lean around h_feedback_fixes_coefficient and the S_ε definition.

