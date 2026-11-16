/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

module

public import NS_Millennium_Proof.Modules.HighSetDepletionAndBKM

/-!
# Semantics lock (Truth Gate)

**All `paper_claim` transcriptions below are PENDING AUTHOR APPROVAL.** Until the author
approves them in writing, a green gate certifies only that each public theorem inhabits the
transcription as written, not that the transcription is the reading the author intends.

Fixed once. Every exported public claim that says it matches a paper is obtained only as
`intended_correspondence.mp <formal proof>` across one of the locks below.

For each lock:

* `paper_claim` is an **independent** Lean transcription of a verbatim quote from a paper in
  this repository. Its docstring carries the quote, the paper path, the paper's SHA-256 and
  the section. It never mentions, unfolds to or aliases `formal_claim` (checked by the gate:
  its project-local dependency closure may share with the formal side only the declared
  `shared_vocabulary` of `truth-gate.lock.json`).
* `formal_claim` is the statement the Lean development proves.
* `intended_correspondence : formal_claim ↔ paper_claim` is proved from `propext`,
  `Classical.choice`, `Quot.sound` only, with no `sorry`, and never by `rfl`/`Iff.rfl`.

A lock whose paper wording does not match what Lean proves has status `drift` in
`truth-gate.lock.json`: it has a `paper_claim` but no `intended_correspondence`, and it keeps
the gate (hence `lake build`) red until the author decides. Nothing here claims that any
Clay problem is solved: every locked paper claim is an implication from named hypotheses that
remain open.

Observation first: before any tactic on a public obligation, run
`#check NS_Millennium_Proof.Semantics.<Lock>.intended_correspondence` and
`#print NS_Millennium_Proof.Semantics.<Lock>.paper_claim`.
-/

open NavierStokes3D MeasureTheory FrohmanianTether FrohmanianTether.ClayStatements

namespace NS_Millennium_Proof.Semantics

/-! ## Paper-side vocabulary (transcribed from the papers, not from the Lean hypotheses) -/

/-- Paper: `docs/VorticityEnvelopeCorrection.tex`, §1 "The corrected distinction"
(sha256 `e35cbb8274d914297828e67fd748968cb4ef56a22bd8bd4a482e7d7f0cb633a7`). Verbatim:
"for every smooth divergence-free periodic datum, there are positive constants $C,\kappa$
such that every represented local solution satisfies
$M(t)\leq\max\{M(0),C/\kappa\},\qquad 0\leq t<T.$ Here $M(t)=\|\operatorname{curl}u(t)\|_\infty$."
`M(0)` is read on the solution itself.

**Transcription status: PENDING AUTHOR APPROVAL** (Frohman, Benjamin Stanley). -/
@[expose] public def PaperUniformEnvelope (ν : ℝ) : Prop :=
  ∀ u₀ : VelocityField,
    ContDiff ℝ (⊤ : ℕ∞) u₀ → (∀ x, div u₀ x = 0) → IsZ3Periodic u₀ →
      ∃ C k : ℝ, 0 < C ∧ 0 < k ∧
        ∀ (T : ℝ) (u : TimeDependentVelocity) (p : TimeDependentPressure),
          IsPeriodicSmoothSolutionOn ν T u₀ u p →
            ∀ t : ℝ, 0 ≤ t → t < T →
              vorticity_sup_norm (vorticity (u t)) ≤
                max (vorticity_sup_norm (vorticity (u 0))) (C / k)

/-- Paper: `main.tex`, Abstract (sha256
`bca0d13a99d759f256dd0c31e421b6f18b2c12e0f1bb7d3afc094d90bb8539c0`). Verbatim:
"an \emph{assumed} uniform ceiling on $\|\omega(t)\|_\infty$ along periodic smooth solutions
(not a differential inequality)". Transcribed as one ceiling `Y` per smooth divergence-free
periodic datum, valid along every local periodic smooth solution on its whole lifespan.

**Transcription status: PENDING AUTHOR APPROVAL** (Frohman, Benjamin Stanley). -/
@[expose] public def PaperUniformCeiling (ν : ℝ) : Prop :=
  ∀ u₀ : VelocityField,
    ContDiff ℝ (⊤ : ℕ∞) u₀ → (∀ x, div u₀ x = 0) → IsZ3Periodic u₀ →
      ∃ Y : ℝ, ∀ (T : ℝ) (u : TimeDependentVelocity) (p : TimeDependentPressure),
        IsPeriodicSmoothSolutionOn ν T u₀ u p →
          ∀ t : ℝ, 0 ≤ t → t < T → vorticity_sup_norm (vorticity (u t)) ≤ Y

/-! ## Lock 1: `clay_reduces_to_uniform_vorticity_envelope` -/

namespace EnvelopeReduction

/-- Paper: `docs/VorticityEnvelopeCorrection.tex`, §2 "The checked conditional consequences"
(sha256 `e35cbb8274d914297828e67fd748968cb4ef56a22bd8bd4a482e7d7f0cb633a7`). Verbatim:
"the uniform envelope for every positive viscosity, \emph{and} the separately assumed periodic
BKM continuation principle, imply \lean{Clay_B_exact}." Conditional: both premises are open.

**Transcription status: PENDING AUTHOR APPROVAL** (Frohman, Benjamin Stanley). -/
@[expose] public def paper_claim : Prop :=
  ((∀ ν : ℝ, 0 < ν → PaperUniformEnvelope ν) ∧ (∀ ν : ℝ, 0 < ν → PeriodicBKMContinuation ν)) →
    Clay_B_exact

/-- What Lean proves (`clay_reduces_to_uniform_vorticity_envelope_formal`). -/
@[expose] public def formal_claim : Prop :=
  (∀ ν > (0 : ℝ), PeriodicBKMContinuation ν) →
    (∀ ν > (0 : ℝ), HighSetDepletionAndBKM.UniformVorticityEnvelopeBound ν) → Clay_B_exact

/-- The paper's envelope (with `M(0)` read on the solution) is the Lean envelope. -/
public theorem paperUniformEnvelope_iff (ν : ℝ) :
    PaperUniformEnvelope ν ↔ HighSetDepletionAndBKM.UniformVorticityEnvelopeBound ν := by
  constructor
  · intro h u₀ hdiv hsm hper
    obtain ⟨C, k, hC, hk, hb⟩ := h u₀ hsm hdiv hper
    refine ⟨C, k, hC, hk, fun T u p hsol t ht => ?_⟩
    have h0 : u 0 = u₀ := hsol.2.2.2.1
    have := hb T u p hsol t ht.1 ht.2
    rwa [h0] at this
  · intro h u₀ hsm hdiv hper
    obtain ⟨C, k, hC, hk, hb⟩ := h u₀ hdiv hsm hper
    refine ⟨C, k, hC, hk, fun T u p hsol t ht0 htT => ?_⟩
    have h0 : u 0 = u₀ := hsol.2.2.2.1
    rw [h0]
    exact hb T u p hsol t ⟨ht0, htT⟩

/-- **Fixed once.** -/
public theorem intended_correspondence : formal_claim ↔ paper_claim := by
  unfold formal_claim paper_claim
  simp only [paperUniformEnvelope_iff]
  constructor
  · intro h hp
    exact h hp.2 hp.1
  · intro h hB hE
    exact h ⟨hE, hB⟩

end EnvelopeReduction

/-! ## Lock 2: `clay_reduces_to_direction_curvature_bound` -/

namespace DirectionCurvatureReduction

/-- Paper: `main.tex`, Abstract (sha256
`bca0d13a99d759f256dd0c31e421b6f18b2c12e0f1bb7d3afc094d90bb8539c0`). Verbatim:
"assuming \lean{PeriodicBKMContinuation}~$\nu$ for every $\nu>0$, the hypothesis
\lean{DirectionCurvatureBound}~$\nu$ for every $\nu>0$ implies \lean{Clay_B_exact}. Here
\lean{DirectionCurvatureBound} is an abbreviation for \lean{UniformVorticityEnvelopeBound}, an
\emph{assumed} uniform ceiling on $\|\omega(t)\|_\infty$ along periodic smooth solutions (not a
differential inequality)". The hypothesis is transcribed from that description
(`PaperUniformCeiling`), not from the Lean abbreviation.

**Transcription status: PENDING AUTHOR APPROVAL** (Frohman, Benjamin Stanley). -/
@[expose] public def paper_claim : Prop :=
  (∀ ν : ℝ, 0 < ν → PeriodicBKMContinuation ν) →
    (∀ ν : ℝ, 0 < ν → PaperUniformCeiling ν) → Clay_B_exact

/-- What Lean proves (`clay_reduces_to_direction_curvature_bound_formal`). -/
@[expose] public def formal_claim : Prop :=
  (∀ ν > (0 : ℝ), PeriodicBKMContinuation ν) →
    (∀ ν > (0 : ℝ), HighSetDepletionAndBKM.DirectionCurvatureBound ν) → Clay_B_exact

/-- A single uniform ceiling is the same as the `max(M(0), C/κ)` envelope with `C, κ > 0`. -/
public theorem paperUniformCeiling_iff (ν : ℝ) :
    PaperUniformCeiling ν ↔ HighSetDepletionAndBKM.DirectionCurvatureBound ν := by
  constructor
  · intro h u₀ hdiv hsm hper
    obtain ⟨Y, hY⟩ := h u₀ hsm hdiv hper
    refine ⟨max Y 1, 1, lt_of_lt_of_le one_pos (le_max_right _ _), one_pos,
      fun T u p hsol t ht => ?_⟩
    have h1 := hY T u p hsol t ht.1 ht.2
    rw [div_one]
    exact le_trans h1 (le_trans (le_max_left Y 1) (le_max_right _ _))
  · intro h u₀ hsm hdiv hper
    obtain ⟨C, k, _hC, _hk, hb⟩ := h u₀ hdiv hsm hper
    exact ⟨max (vorticity_sup_norm (vorticity u₀)) (C / k),
      fun T u p hsol t ht0 htT => hb T u p hsol t ⟨ht0, htT⟩⟩

/-- **Fixed once.** -/
public theorem intended_correspondence : formal_claim ↔ paper_claim := by
  unfold formal_claim paper_claim
  constructor
  · intro h hB hC
    exact h hB (fun ν hν => (paperUniformCeiling_iff ν).1 (hC ν hν))
  · intro h hB hD
    exact h hB (fun ν hν => (paperUniformCeiling_iff ν).2 (hD ν hν))

end DirectionCurvatureReduction

/-! ## Lock 3: `clay_B_exact_of_periodic_tether_bound` -/

namespace PeriodicTetherReduction

/-- Paper: `main.tex`, §"The Periodic Clay (B) Statement and Scaling Analysis" (sec:clay)
(sha256 `bca0d13a99d759f256dd0c31e421b6f18b2c12e0f1bb7d3afc094d90bb8539c0`). Verbatim:
"The reduction from \lean{Clay_B_exact} to the periodic closing bound
\lean{PeriodicTetherClosingBound} and classical periodic BKM continuation
\lean{PeriodicBKMContinuation} is proved axiom-clean". Both premises are named in the paper and
are open; they are taken for every positive viscosity, as `Clay_B_exact` quantifies `ν > 0`.

**Transcription status: PENDING AUTHOR APPROVAL** (Frohman, Benjamin Stanley). -/
@[expose] public def paper_claim : Prop :=
  ((∀ ν : ℝ, 0 < ν → PeriodicTetherClosingBound ν) ∧
      (∀ ν : ℝ, 0 < ν → PeriodicBKMContinuation ν)) → Clay_B_exact

/-- What Lean proves (`clay_B_exact_of_periodic_tether_bound_formal`). -/
@[expose] public def formal_claim : Prop :=
  (∀ ν > (0 : ℝ), PeriodicTetherClosingBound ν) →
    (∀ ν > (0 : ℝ), PeriodicBKMContinuation ν) → Clay_B_exact

/-- **Fixed once.** -/
public theorem intended_correspondence : formal_claim ↔ paper_claim := by
  unfold formal_claim paper_claim
  constructor
  · intro h hp
    exact h hp.1 hp.2
  · intro h hT hB
    exact h ⟨hT, hB⟩

end PeriodicTetherReduction

/-! ## Lock 4 (DRIFT): Theorem 1.1 of `main.tex` versus `global_regularity_for_NS` -/

/-- Paper: `main.tex`, §1 Introduction, Theorem 1.1 (`thm:main`, "Conditional Global
Regularity; frohmanian_tether_theorem, global_regularity_for_NS") (sha256
`bca0d13a99d759f256dd0c31e421b6f18b2c12e0f1bb7d3afc094d90bb8539c0`). Verbatim opening: "Let
$\nu>0$ and let $u_0$ be smooth (\lean{ContDiff ℝ ⊤}), divergence-free, and of finite $L^2$
energy. Assume within the class of physical solutions (\lean{IsPhysicalNSSolution}):"
followed by (K) Kato local existence "from every such datum", (C) the BKM continuation
criterion, (R) the cubic tether rate `FrohmanianTetherRate`, (U) physical uniqueness, and
"Then $M(t)\le\max\bigl(M(0),\CZ/\kappa''\bigr)$ for all $t\ge0$, and \eqref{eq:NS} admits a
globally defined physical solution $u$ on $[0,\infty)$ that is spatially $C^\infty$ for every
$t\ge0$, divergence-free, and unique among all smooth physical solutions."

**Transcription status: PENDING AUTHOR APPROVAL** (Frohman, Benjamin Stanley). -/
@[expose] public def PaperTheorem11 : Prop :=
  ∀ (ν : ℝ) (u₀ : VelocityField), 0 < ν →
    ContDiff ℝ (⊤ : ℕ∞) u₀ → (∀ x, div u₀ x = 0) → Integrable (fun x : T3 => ‖u₀ x‖ ^ 2) →
    -- (K) Kato local existence from every such datum
    (∀ v₀ : VelocityField, ContDiff ℝ (⊤ : ℕ∞) v₀ → (∀ x, div v₀ x = 0) →
        Integrable (fun x : T3 => ‖v₀ x‖ ^ 2) → Nonempty (KatoLocalWitness v₀ ν)) →
    -- (C) Beale–Kato–Majda continuation criterion
    TetheredLyapunov.PhysicalBKMContinuationCriterionFor u₀ ν →
    -- (R) Frohmanian cubic tether rate along every physical solution from u₀
    FrohmanianTetherRate u₀ ν →
    -- (U) physical uniqueness against the Kato witness
    (∀ w : KatoLocalWitness u₀ ν, TetheredLyapunov.KatoUniquenessOnExistenceTimes u₀ ν w) →
    -- conclusion: the ceiling, and a global smooth divergence-free unique physical solution
    (∀ (u : TimeDependentVelocity) (p : TimeDependentPressure),
        NS_PDE u p ν → u 0 = u₀ → IsPhysicalNSSolution u →
          ∃ C k : ℝ, 0 < C ∧ 0 < k ∧ ∀ t : ℝ, 0 ≤ t →
            vorticity_sup_norm (vorticity (u t)) ≤
              max (vorticity_sup_norm (vorticity (u 0))) (C / k)) ∧
    ∃ (u : TimeDependentVelocity) (p : TimeDependentPressure),
      NS_PDE u p ν ∧ u 0 = u₀ ∧ IsPhysicalNSSolution u ∧
      (∀ t : ℝ, 0 ≤ t → ContDiff ℝ (⊤ : ℕ∞) (u t)) ∧
      (∀ t : ℝ, 0 ≤ t → ∀ x, div (u t) x = 0) ∧
      ∀ (v : TimeDependentVelocity) (q : TimeDependentPressure),
        NS_PDE v q ν → v 0 = u₀ → IsPhysicalNSSolution v →
          (∀ t : ℝ, 0 ≤ t → ContDiff ℝ (⊤ : ℕ∞) (v t)) → ∀ t : ℝ, 0 ≤ t → v t = u t

namespace ConditionalGlobalRegularity

/-- Theorem 1.1 of `main.tex` (see `PaperTheorem11`). DRIFT: not equivalent to what Lean
proves; no `intended_correspondence` exists for this lock.

**Transcription status: PENDING AUTHOR APPROVAL** (Frohman, Benjamin Stanley). -/
@[expose] public def paper_claim : Prop := PaperTheorem11

/-- The statement of `GlobalRegularity.global_regularity_for_NS` as Lean proves it. -/
@[expose] public def formal_claim : Prop :=
  ∀ (u0 : TimeDependentVelocity) (_h_div_free : ∀ t x, div (u0 t) x = 0)
    (_h_smooth : GlobalRegularity.IsSmooth (u0 0))
    (_h_finite_energy : Integrable (fun x : T3 => ‖u0 0 x‖ ^ 2))
    (ν : ℝ) (_h_ν_pos : ν > 0)
    (w : KatoLocalWitness (u0 0) ν)
    (_hRiccati : FrohmanianTetherBound (u0 0) ν)
    (_hcrit : TetheredLyapunov.PhysicalBKMContinuationCriterionFor (u0 0) ν)
    (_huniq : TetheredLyapunov.KatoUniquenessOnExistenceTimes (u0 0) ν w),
  ∃ (u : TimeDependentVelocity),
    (∀ t ≥ (0 : ℝ), GlobalRegularity.IsSmooth (u t)) ∧
    (u 0 = u0 0) ∧
    (∀ t ≥ (0 : ℝ), GlobalRegularity.satisfies_NavierStokes u ν) ∧
    (∀ t ≥ (0 : ℝ), GlobalRegularity.vorticity_sup_norm (vorticity (u t)) ≥ 0) ∧
    (∀ v : TimeDependentVelocity,
      (∀ t ≥ (0 : ℝ), GlobalRegularity.IsSmooth (v t)) →
      v 0 = u0 0 →
      (∀ t ≥ (0 : ℝ), GlobalRegularity.satisfies_NavierStokes v ν) →
      ∀ t ≥ (0 : ℝ), v t = u t)

end ConditionalGlobalRegularity

namespace TetherTheorem

/-- Theorem 1.1 of `main.tex`, which the paper also attributes to
`GlobalRegularity.frohmanian_tether_theorem`. DRIFT: that theorem's `hDI` hypothesis quantifies
over every datum and is unsatisfiable
(`TetherRateCounterexample.frohmanian_tether_theorem_hDI_unsatisfiable`), so it is vacuous and is
not Theorem 1.1. No `intended_correspondence` exists for this lock.

**Transcription status: PENDING AUTHOR APPROVAL** (Frohman, Benjamin Stanley). -/
@[expose] public def paper_claim : Prop := PaperTheorem11

end TetherTheorem

/-! ## Aggregate lock (`#check NS_Millennium_Proof.Semantics.intended_correspondence`) -/

/-- Conjunction of the locked paper claims (locks 1–3).

**Transcription status: PENDING AUTHOR APPROVAL** (Frohman, Benjamin Stanley). -/
@[expose] public def paper_claim : Prop :=
  EnvelopeReduction.paper_claim ∧ DirectionCurvatureReduction.paper_claim ∧
    PeriodicTetherReduction.paper_claim

/-- Conjunction of the corresponding formal claims. -/
@[expose] public def formal_claim : Prop :=
  EnvelopeReduction.formal_claim ∧ DirectionCurvatureReduction.formal_claim ∧
    PeriodicTetherReduction.formal_claim

/-- **Fixed once.** The aggregate correspondence, built from the per-claim locks. -/
public theorem intended_correspondence : formal_claim ↔ paper_claim :=
  and_congr EnvelopeReduction.intended_correspondence
    (and_congr DirectionCurvatureReduction.intended_correspondence
      PeriodicTetherReduction.intended_correspondence)

end NS_Millennium_Proof.Semantics
