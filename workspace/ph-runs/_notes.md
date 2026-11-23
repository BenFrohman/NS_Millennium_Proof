## eth-conflict-clause-lattice
- Hand-added claim eq:subexp_bound (paper/main.tex:161, displayed equation, not a theorem env).
- Open (true gap): Lean bounds the step counter of the cost model `simulateBlockHomologicalTraversal`, whose cost is *defined* by `tick ((n+m)^2); tick (2^(n / max k 1))` and which returns `true` without inspecting any formula. It does not bound the runtime of an algorithm that decides 3-SAT. The `hrun` flags stay open.
- Not flagged by the harness: paper writes o(1); Lean takes an arbitrary fixed real ε.
## fefferman-clay-navier-stokes
- Lean statement is a conjunction of named Props Q1..Q5; PipelineHalt compares surface text only and does not unfold them. Q5 is explicitly conditional (PeriodicDirectionDepletionBound ν ∧ PeriodicBKMContinuation ν → Clay_B_exact ν), and the paper says so. This is not a proof of Clay problem (B). Not a harness flag, but worth stating.
## StandardConjectures
- Manual finding (the harness cannot see it): `IsHodge` and `IsAlgebraic` are defined as `True` (StandardConjectures.lean:24,27), so `hodge_on_product_implies_lefschetz_B` is vacuous relative to the paper's meaning. Aligned on surface text only; the definitional gap stays open.
## p2q-jumps-lean
- No theorem environments in the repo paper (paper/verification_certificate.tex is an axiom table). Anchor hand-built verbatim from README.md:9 and :19.
- Open (true gap, as the README itself says): Theorem 28 is only a Prop `Theorem28`; `theorem28_from_paper` assumes it. Only `g_ge_six` is unconditional.
## OmegaZero34
- The paper has no \lean{} references. The map was hand-built by reading OmegaZero34/*.lean.
- Numbering: the Lean docstrings number by section ("Theorem 7.1", "Corollary 7.2"), while the tex prints Theorem 9 and Corollary 10. Closed with map aliases.
- Manual finding, not flagged: prop:kernel says "vanish **if and only if** a=b=e=f=0, c=d/6". `invariant_params` proves only the forward direction. The converse (c•Ω0 is invariant) follows from T1_preserves_Ω0/T2_preserves_Ω0 by linearity but is not stated as a theorem. This is a small narrower gap; an `_iff` lemma would close it (not done, see roll-up).
- Manual finding, not flagged: thm:C is conditional on H1–H3 (the paper says so). Lean takes the lattice-level content of H1–H3 as the structure `InvariantFormQ` (an argument, not a Prop hypothesis, so the harness doesn't see it). H1–H3 and the lattice identification are not formalized (TetherInterface.lean:23-27).
## HODGE
- Claims source: docs/CYCLE_CLASS_AND_CONSTRUCTOR.tex (the README's "Primary Manuscript"); 3 claims about the Klein quadric.
- Aligned on surface text, but there is a manual finding the harness cannot see: the Klein quadric is modelled with cycles := ℚ×ℚ, Hodge classes := ℚ×ℚ, `cl := LinearMap.id`, `construct γ := γ` (Hodge/Classical.lean:74-88). `construct_recovers` and `expansion` are `rfl`. So the geometric content (Hdg²(Q) = ℚ[Π] ⊕ ℚ[Π'], cl[Π], cl[Π'] being the basis, the intersection-number formulas a = γ·[Π], b = γ·[Π']) is built into the model, not proved. This is a modelling/definitional gap. It stays open as a reviewer finding.
## collatz-teaming-lemma
- No theorem environments. Anchor hand-built verbatim from the abstract (tex:24): 3 claims.
- `RemainingLemma` := ∀ n>0, ∃ k, iter k n = 1 (ReverseTree.lean:20). So `remaining_lemma_iff_collatz` is close to a restatement of the Collatz conjecture, and the conjecture itself stays open (the paper says so).
- model-mean-observation (3n-1 cycles at 1, 5, 17): no Lean declaration, and the paper says it lives in companion notes. It is mapped to `[]`, but PipelineHalt treats an empty list as "no mapping" and falls back to the heuristic, which picks unrelated decls (harness quirk). The open flag is kept; the honest status is SILENT/unformalized.
## frohmanian-symplectic-tether-regularity
- theorem-2.2 cites `tether_preserves_casimirs`, which exists nowhere in the repo's .lean files. Kept open (silent).
- eq:kappa-def: no Lean definition of κ(ν) = 27 C_CZ⁴/(4ν³) = 2187/(64ν³) was found. Kept open (silent).
- theorem-3.1: Lean hypotheses hC1 `InvariantUnderCoadjointAction`, hC2 `DegenerateWRTKineticEnergy`, hC3 `ProducesControllableNegativeFeedback`, `Polarizes` don't visibly match the paper's C1 (Casimir kernel annihilation), C2 (minimal degree & parabolic scaling), C3. Kept open: equivalence not clear.
- eq:young-4-eq-4: Lean `youngs_absorption_elimination` assumes the Young-type bound `h_young` as a hypothesis, i.e. the key inequality is assumed. Kept open (true conditional gap). There are also two declarations with this name (AnalyticPipeline.lean:69, TetheredLyapunov.lean:744) with different hypotheses (the latter has `h_kappa : kappa = CalderonZygmundConstant3D`).
- theorem-1.1: Lean statement is the conjunction P1 ∧ … ∧ P4 (FinalProductTheorem.lean:523). The paper itself states that global regularity for general data is conditional on FrohmanianTetherBound, KatoLocalWitness, PhysicalBKMContinuationCriterionFor, KatoUniquenessOnExistenceTimes. Consistent; not a proof of NS global regularity.
## NS_Millennium_Proof
- thm:main is conditional, and the paper says so (K, C, R, U). Two extra Lean hypotheses are kept open: `hTlb` (a uniform lower bound τ on the Kato existence time, which the paper doesn't state) and `hInt` (BKM integrability assumed separately; the paper says it is supplied by (R)).
- prop:degen cites `tetherKernel_C2`, which doesn't exist (only `_of_no_gateaux` / `_of_identifications` variants exist). Kept open.
- lem:transport: Lean assumes NS_PDE (the paper says a solution of the vorticity equation), VorticityTransportRegularity, and t ≥ 0. Kept open; equivalence not verified.
