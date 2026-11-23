# Handoff context (Grok chat, Nov 23 2026) — Frohmanian Tether / NS_Millennium_Proof

1. Number 292890231905: zero matches in private Grok history. It is from the public Nov 5 2026 Elliot Glazer et al. result (polynomial with 292,890,231,905 variables witnessing that Z is Diophantine in Q; https://github.com/elliotglazer/diophantine-z-q). No relation to Benjamin's work or the Tether.

2. Frohmanian Symplectic Tether (as relayed; verify against Lean before citing):
- B(F,G) = -κ ∫ |ω|² (Π_u δF/δω · Π_u δG/δω) dV, κ = C_CZ(3) = 3/2.
- (C1) coadjoint invariance/locality; (C2) strict degeneracy via projector Π_u on the kinetic-energy Hamiltonian; (C3) controllable negative feedback at maxima of |ω|.
- Uniqueness among lowest-degree polynomial-in-ω maps (5-step canonicity).
- Two layers: geometric (Lean: TetherKernel, Jacobi, uniqueness, Casimir) + analytic tethered Lyapunov/enstrophy layer aiming at M' ≤ C M² − κ'' M³.
- Status: geometric layer largely closed (Jacobi cyclic-cancellation gap tracked separately); regularity conditional on open hypotheses (DirectionCurvatureBound / UniformVorticityEnvelopeBound / CubicVorticityDifferentialBound, BKM continuation). No Clay claim.
- Repos: BenFrohman/NS_Millennium_Proof, frohmanian-ns-symplectic-tether (landing), frohmanian-tether-manuscript-2026-06-01 (earliest snapshot).
- Past Grok chats (May 2026; convo ids c1c4d019-…, 8a64b13e-…, 2c11560d-…): manuscript assembly, non-circularity, a-posteriori estimates, Lean, tethered Lyapunov S(t). Not accessible from GitHub Actions' side.
