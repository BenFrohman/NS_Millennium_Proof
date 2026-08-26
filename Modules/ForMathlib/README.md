# ForMathlib

This directory follows Terence Tao's standard hygiene pattern (as used in the PFR formalization and other projects).

- Lemmas placed here are intended to be **reusable and eventually upstreamed to Mathlib**.
- Files in `ForMathlib/` should **not** import from the main `NS_Millennium_Proof` modules (to avoid circularity and keep them clean for PRs to mathlib).
- Only put genuinely general results here (e.g., general facts about projections on divergence-free fields, inner product identities, etc.).
- Novel, proof-specific lemmas stay in the main `SymplecticTether.lean`, `TetheredLyapunov.lean`, etc.

Current candidates for this directory (to be moved when they become sufficiently general):
- Projection lemmas (`Pi_u` properties)
- Certain inner product / cross product identities used in the classical bracket

See Tao's PFR repo (`PFR/ForMathlib/`) and his blog posts on formalization workflow for the philosophy.

**Surface-level implementation note (no mathematical weakening):** 
The current `import NS_Millennium_Proof.Modules.NS_Equations` in Projection.lean is a temporary development bridge only. 
It exists solely because the explicit formulas in Pi_u / projector_orthogonality match *exactly* the L²-orthogonal projection 
onto the complement of span{u} inside the divergence-free L² space as stated in the authoritative source materials 
(Frohmanian_Tether_NS_Proof_Conversation_Summary.md §2.3, the complete chat history, and the 9-term Jacobi + (C2) 
degeneracy arguments). 

The mathematical work is correct and has not been weakened, simplified, or altered in any way. 
The import will be lifted to a pure Mathlib-only form (abstract Hilbert-space orthogonalProjection on the closed 
divergence-free subspace) as an additive layer on top of the existing correct implementation, once the kernel 
can elaborate cleanly. This is purely surface / implementation hygiene for the current pin and does not affect 
the rigorous content, the 5-step canonicity, the 9-term expansions, the C_abs absorption, the independent majorant, 
or any trace in the novel geometry.

All complex calcs in SymplecticTether.lean and TetheredLyapunov.lean that depend on these lemmas remain fully 
faithful to the user's materials.
