/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

module

public import NS_Millennium_Proof.Modules.HighSetDepletionAndBKM

/-!
# Semantics lock (Truth Gate)

PAPER_PATH: main.tex
PAPER_SHA256: 0a5a98a673dd6c3ec033d4f8a5d464c6cf6450ccb506ff6baaef0f26a9ec4308
PAPER_SECTION: Abstract (main theorem `clay_reduces_to_direction_curvature_bound`); also §"The Periodic Clay (B) Statement and Scaling Analysis" (sec:clay) §1 Theorem 1.1 (thm:main) and §1 Proposition prop:classical-zero

Locked paper claims in `main.tex`, quoted verbatim (locks `DirectionCurvatureReduction`,
`PeriodicTetherReduction`, `ConditionalGlobalRegularity`, `TetherTheorem`, in that order):

PAPER_QUOTE_BEGIN
assuming \lean{PeriodicBKMContinuation}~$\nu$ for every $\nu>0$, the hypothesis \lean{DirectionCurvatureBound}~$\nu$ for every $\nu>0$ implies \lean{Clay_B_exact}. Here \lean{DirectionCurvatureBound} is an abbreviation for \lean{UniformVorticityEnvelopeBound}, an \emph{assumed} uniform ceiling on $\|\omega(t)\|_\infty$ along periodic smooth solutions (not a differential inequality)
PAPER_QUOTE_END

PAPER_QUOTE_BEGIN
The reduction from \lean{Clay_B_exact} to the periodic closing bound \lean{PeriodicTetherClosingBound} and classical periodic BKM continuation \lean{PeriodicBKMContinuation} is proved axiom-clean
PAPER_QUOTE_END

PAPER_QUOTE_BEGIN
Along every classical periodic smooth solution of the unforced equations, if $M(s)$ is differentiable for every $s\ge0$ and $M'(s)\le C\,M(s)^2-\kappa''\,M(s)^3$ for constants $C>0$ and $\kappa''>0$, then $M(t)\le\max\bigl(M(0),C/\kappa''\bigr)$ for every $t\ge0$.
PAPER_QUOTE_END

PAPER_QUOTE_BEGIN
For every real viscosity $\nu$, the zero velocity and the zero pressure form a classical periodic smooth solution of the unforced equations with zero initial velocity.
PAPER_QUOTE_END

Second paper (lock `EnvelopeReduction`; checked by the in-build gate against
`truth-gate.lock.json`): `docs/VorticityEnvelopeCorrection.tex`, sha256
`e35cbb8274d914297828e67fd748968cb4ef56a22bd8bd4a482e7d7f0cb633a7`, §2 "The checked conditional
consequences".

Scope: CONDITIONAL. The envelope and periodic-tether reductions stay implications from open
hypotheses. Theorem 1.1 is the comparison ceiling along one classical periodic smooth
solution that is assumed to obey the cubic differential inequality. Lock `TetherTheorem`
records that the zero field is one such solution. Clay (B) and Clay (D) stay open. The
analytic link of the tether is not established. Nothing here is a proof of the
Navier–Stokes Millennium problem.

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

@[expose] public section

open NavierStokes3D MeasureTheory FrohmanianTether FrohmanianTether.ClayStatements

namespace NS_Millennium_Proof.Semantics

-- TRUTH-GATE LOCK BEGIN
/-! ## Paper-side vocabulary (transcribed from the papers, not from the Lean hypotheses) -/

/-- Paper: `docs/VorticityEnvelopeCorrection.tex`, §1 "The corrected distinction"
(sha256 `e35cbb8274d914297828e67fd748968cb4ef56a22bd8bd4a482e7d7f0cb633a7`). Verbatim:
"for every smooth divergence-free periodic datum, there are positive constants $C,\kappa$
such that every represented local solution satisfies
$M(t)\leq\max\{M(0),C/\kappa\},\qquad 0\leq t<T.$ Here $M(t)=\|\operatorname{curl}u(t)\|_\infty$."
`M(0)` is read on the solution itself.

**Transcription status: PENDING AUTHOR APPROVAL** (Frohman, Benjamin Stanley). -/
def PaperUniformEnvelope (ν : ℝ) : Prop :=
  ∀ u₀ : VelocityField,
    ContDiff ℝ (⊤ : ℕ∞) u₀ → (∀ x, div u₀ x = 0) → IsZ3Periodic u₀ →
      ∃ C k : ℝ, 0 < C ∧ 0 < k ∧
        ∀ (T : ℝ) (u : TimeDependentVelocity) (p : TimeDependentPressure),
          IsPeriodicSmoothSolutionOn ν T u₀ u p →
            ∀ t : ℝ, 0 ≤ t → t < T →
              vorticity_sup_norm (vorticity (u t)) ≤
                max (vorticity_sup_norm (vorticity (u 0))) (C / k)

/-- Paper: `main.tex`, Abstract (sha256
`6d09b347ecf02190dbe0317da4f52c72616e1090eb7a9a0604ac012b3d946764`). Verbatim:
"an \emph{assumed} uniform ceiling on $\|\omega(t)\|_\infty$ along periodic smooth solutions
(not a differential inequality)". Transcribed as one ceiling `Y` per smooth divergence-free
periodic datum, valid along every local periodic smooth solution on its whole lifespan.

**Transcription status: PENDING AUTHOR APPROVAL** (Frohman, Benjamin Stanley). -/
def PaperUniformCeiling (ν : ℝ) : Prop :=
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
def paper_claim : Prop :=
  ((∀ ν : ℝ, 0 < ν → PaperUniformEnvelope ν) ∧ (∀ ν : ℝ, 0 < ν → PeriodicBKMContinuation ν)) →
    Clay_B_exact

/-- What Lean proves (`clay_reduces_to_uniform_vorticity_envelope_formal`). -/
def formal_claim : Prop :=
  (∀ ν > (0 : ℝ), PeriodicBKMContinuation ν) →
    (∀ ν > (0 : ℝ), HighSetDepletionAndBKM.UniformVorticityEnvelopeBound ν) → Clay_B_exact

/-- The paper's envelope (with `M(0)` read on the solution) is the Lean envelope. -/
theorem paperUniformEnvelope_iff (ν : ℝ) :
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
theorem intended_correspondence : formal_claim ↔ paper_claim := by
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
`6d09b347ecf02190dbe0317da4f52c72616e1090eb7a9a0604ac012b3d946764`). Verbatim:
"assuming \lean{PeriodicBKMContinuation}~$\nu$ for every $\nu>0$, the hypothesis
\lean{DirectionCurvatureBound}~$\nu$ for every $\nu>0$ implies \lean{Clay_B_exact}. Here
\lean{DirectionCurvatureBound} is an abbreviation for \lean{UniformVorticityEnvelopeBound}, an
\emph{assumed} uniform ceiling on $\|\omega(t)\|_\infty$ along periodic smooth solutions (not a
differential inequality)". The hypothesis is transcribed from that description
(`PaperUniformCeiling`), not from the Lean abbreviation.

**Transcription status: PENDING AUTHOR APPROVAL** (Frohman, Benjamin Stanley). -/
def paper_claim : Prop :=
  (∀ ν : ℝ, 0 < ν → PeriodicBKMContinuation ν) →
    (∀ ν : ℝ, 0 < ν → PaperUniformCeiling ν) → Clay_B_exact

/-- What Lean proves (`clay_reduces_to_direction_curvature_bound_formal`). -/
def formal_claim : Prop :=
  (∀ ν > (0 : ℝ), PeriodicBKMContinuation ν) →
    (∀ ν > (0 : ℝ), HighSetDepletionAndBKM.DirectionCurvatureBound ν) → Clay_B_exact

/-- A single uniform ceiling is the same as the `max(M(0), C/κ)` envelope with `C, κ > 0`. -/
theorem paperUniformCeiling_iff (ν : ℝ) :
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
theorem intended_correspondence : formal_claim ↔ paper_claim := by
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
(sha256 `6d09b347ecf02190dbe0317da4f52c72616e1090eb7a9a0604ac012b3d946764`). Verbatim:
"The reduction from \lean{Clay_B_exact} to the periodic closing bound
\lean{PeriodicTetherClosingBound} and classical periodic BKM continuation
\lean{PeriodicBKMContinuation} is proved axiom-clean". Both premises are named in the paper and
are open; they are taken for every positive viscosity, as `Clay_B_exact` quantifies `ν > 0`.

**Transcription status: PENDING AUTHOR APPROVAL** (Frohman, Benjamin Stanley). -/
def paper_claim : Prop :=
  ((∀ ν : ℝ, 0 < ν → PeriodicTetherClosingBound ν) ∧
      (∀ ν : ℝ, 0 < ν → PeriodicBKMContinuation ν)) → Clay_B_exact

/-- What Lean proves (`clay_B_exact_of_periodic_tether_bound_formal`). -/
def formal_claim : Prop :=
  (∀ ν > (0 : ℝ), PeriodicTetherClosingBound ν) →
    (∀ ν > (0 : ℝ), PeriodicBKMContinuation ν) → Clay_B_exact

/-- **Fixed once.** -/
theorem intended_correspondence : formal_claim ↔ paper_claim := by
  unfold formal_claim paper_claim
  constructor
  · intro h hp
    exact h hp.1 hp.2
  · intro h hT hB
    exact h ⟨hT, hB⟩

end PeriodicTetherReduction

/-! ## Lock 4: Theorem 1.1 of `main.tex` (`CeilingFromRate.classical_vorticity_ceiling`) -/

namespace ConditionalGlobalRegularity

/-- Paper: `main.tex`, §1 Introduction, Theorem 1.1 (`thm:main`). Verbatim: "Along every
classical periodic smooth solution of the unforced equations, if $M(s)$ is differentiable for
every $s\ge0$ and $M'(s)\le C\,M(s)^2-\kappa''\,M(s)^3$ for constants $C>0$ and $\kappa''>0$,
then $M(t)\le\max\bigl(M(0),C/\kappa''\bigr)$ for every $t\ge0$."

The classical solution is transcribed as the five conjuncts of `IsPeriodicSmoothSolution`
(joint smoothness of velocity and pressure, the unforced one-sided equation, the initial
condition, and `ℤ³` periodicity), each as its own hypothesis. The differential inequality is
an assumption. This is not existence, and it is not Clay (B) or (D).

**Transcription status: PENDING AUTHOR APPROVAL** (Frohman, Benjamin Stanley). -/
def paper_claim : Prop :=
  ∀ (ν : ℝ) (u₀ : VelocityField) (u : TimeDependentVelocity) (p : TimeDependentPressure)
    (C κ'' : ℝ),
    0 < ν →
    ContDiffOn ℝ (⊤ : ℕ∞) (fun q : ℝ × T3 => u q.1 q.2) (Set.Ici (0 : ℝ) ×ˢ Set.univ) →
    ContDiffOn ℝ (⊤ : ℕ∞) (fun q : ℝ × T3 => p q.1 q.2) (Set.Ici (0 : ℝ) ×ˢ Set.univ) →
    navier_stokes_eq_Ici u p ν (fun _ _ => (0 : EuclideanSpace ℝ (Fin 3))) →
    u 0 = u₀ →
    (∀ t ≥ (0 : ℝ), IsZ3Periodic (u t) ∧ IsZ3Periodic (p t)) →
    0 < C →
    0 < κ'' →
    (∀ s ≥ (0 : ℝ),
      DifferentiableAt ℝ (fun τ => vorticity_sup_norm (vorticity (u τ))) s) →
    (∀ s ≥ (0 : ℝ),
      deriv (fun τ => vorticity_sup_norm (vorticity (u τ))) s ≤
        C * vorticity_sup_norm (vorticity (u s)) ^ 2 -
          κ'' * vorticity_sup_norm (vorticity (u s)) ^ 3) →
    ∀ t ≥ (0 : ℝ),
      vorticity_sup_norm (vorticity (u t)) ≤
        max (vorticity_sup_norm (vorticity (u 0))) (C / κ'')

/-- The statement of `CeilingFromRate.classical_vorticity_ceiling`. The solution hypothesis is
the bundled predicate `IsPeriodicSmoothSolution`, so this is not the curried paper transcription. -/
def formal_claim : Prop :=
  ∀ (ν : ℝ) (_hν : 0 < ν) (u₀ : VelocityField)
    (u : TimeDependentVelocity) (p : TimeDependentPressure),
    IsPeriodicSmoothSolution ν u₀ (fun _ _ => (0 : EuclideanSpace ℝ (Fin 3))) u p →
    ∀ (C κ'' : ℝ) (_hC : 0 < C) (_hκ : 0 < κ''),
      (∀ s ≥ (0 : ℝ),
        DifferentiableAt ℝ (fun τ => vorticity_sup_norm (vorticity (u τ))) s) →
      (∀ s ≥ (0 : ℝ),
        deriv (fun τ => vorticity_sup_norm (vorticity (u τ))) s ≤
          C * vorticity_sup_norm (vorticity (u s)) ^ 2 -
            κ'' * vorticity_sup_norm (vorticity (u s)) ^ 3) →
      ∀ t ≥ (0 : ℝ),
        vorticity_sup_norm (vorticity (u t)) ≤
          max (vorticity_sup_norm (vorticity (u 0))) (C / κ'')

/-- **Fixed once.** Packing the five classical conjuncts is the correspondence. -/
theorem intended_correspondence : formal_claim ↔ paper_claim := by
  unfold formal_claim paper_claim
  constructor
  · intro h ν u₀ u p C κ'' hν hCu hCp hNS h0 hper hC hκ hdiff hDI
    exact h ν hν u₀ u p ⟨hCu, hCp, hNS, h0, hper⟩ C κ'' hC hκ hdiff hDI
  · intro h ν hν u₀ u p hsol C κ'' hC hκ hdiff hDI
    exact h ν u₀ u p C κ'' hν hsol.1 hsol.2.1 hsol.2.2.1 hsol.2.2.2.1 hsol.2.2.2.2
      hC hκ hdiff hDI

end ConditionalGlobalRegularity

/-! ## Lock 5: the zero field is one classical periodic smooth solution (`prop:classical-zero`) -/

namespace TetherTheorem

/-- Paper: `main.tex`, §1 Introduction, Proposition `prop:classical-zero`. Verbatim: "For every
real viscosity $\nu$, the zero velocity and the zero pressure form a classical periodic smooth
solution of the unforced equations with zero initial velocity."

The initial-velocity clause is written again as `(fun _ => 0) 0 = 0`, outside
`IsPeriodicSmoothSolution`. The predicate already contains `u 0 = u₀`. The two claims are
therefore not the same definition. This is the zero datum only. It is not `Clay_B_exact`, and
it is not a witness for `Clay_D_periodic`.

**Transcription status: PENDING AUTHOR APPROVAL** (Frohman, Benjamin Stanley). -/
def paper_claim : Prop :=
  ∀ ν : ℝ,
    ((fun _ : ℝ => (0 : VelocityField)) 0 = (0 : VelocityField)) ∧
      IsPeriodicSmoothSolution ν (0 : VelocityField)
        (fun _ _ => (0 : EuclideanSpace ℝ (Fin 3)))
        (fun _ => (0 : VelocityField))
        (fun _ => (0 : PressureField))

/-- What Lean proves (`NavierStokes3D.zero_isPeriodicSmoothSolution`): the zero velocity and the
zero pressure are one `IsPeriodicSmoothSolution` of the unforced equations. -/
def formal_claim : Prop :=
  ∀ ν : ℝ,
    IsPeriodicSmoothSolution ν (0 : VelocityField)
      (fun _ _ => (0 : EuclideanSpace ℝ (Fin 3)))
      (fun _ => (0 : VelocityField))
      (fun _ => (0 : PressureField))

/-- **Fixed once.** The extra initial-slice identity is `rfl` on the zero function; the solution
conjunct is the formal statement. -/
theorem intended_correspondence : formal_claim ↔ paper_claim := by
  unfold formal_claim paper_claim
  constructor
  · intro h ν
    exact And.intro rfl (h ν)
  · intro h ν
    exact (h ν).2

end TetherTheorem

/-! ## Aggregate lock (`#check NS_Millennium_Proof.Semantics.intended_correspondence`) -/

/-- Conjunction of the locked paper claims (locks 1–5).

**Transcription status: PENDING AUTHOR APPROVAL** (Frohman, Benjamin Stanley). -/
def paper_claim : Prop :=
  EnvelopeReduction.paper_claim ∧ DirectionCurvatureReduction.paper_claim ∧
    PeriodicTetherReduction.paper_claim ∧ ConditionalGlobalRegularity.paper_claim ∧
      TetherTheorem.paper_claim

/-- Conjunction of the corresponding formal claims. -/
def formal_claim : Prop :=
  EnvelopeReduction.formal_claim ∧ DirectionCurvatureReduction.formal_claim ∧
    PeriodicTetherReduction.formal_claim ∧ ConditionalGlobalRegularity.formal_claim ∧
      TetherTheorem.formal_claim

/-- **Fixed once.** The aggregate correspondence, built from the per-claim locks. -/
theorem intended_correspondence : formal_claim ↔ paper_claim :=
  and_congr EnvelopeReduction.intended_correspondence
    (and_congr DirectionCurvatureReduction.intended_correspondence
      (and_congr PeriodicTetherReduction.intended_correspondence
        (and_congr ConditionalGlobalRegularity.intended_correspondence
          TetherTheorem.intended_correspondence)))

-- TRUTH-GATE LOCK END
end NS_Millennium_Proof.Semantics

end
