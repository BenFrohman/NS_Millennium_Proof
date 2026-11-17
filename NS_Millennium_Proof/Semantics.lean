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
PAPER_SHA256: 6d09b347ecf02190dbe0317da4f52c72616e1090eb7a9a0604ac012b3d946764
PAPER_SECTION: Abstract (main theorem `clay_reduces_to_direction_curvature_bound`); also §"The Periodic Clay (B) Statement and Scaling Analysis" (sec:clay) §1 Theorem 1.1 (thm:main) and §1 Proposition prop:hDI

Locked paper claims in `main.tex`, quoted verbatim (locks `DirectionCurvatureReduction`,
`PeriodicTetherReduction`, `ConditionalGlobalRegularity`, `TetherTheorem`, in that order):

PAPER_QUOTE_BEGIN
assuming \lean{PeriodicBKMContinuation}~$\nu$ for every $\nu>0$, the hypothesis \lean{DirectionCurvatureBound}~$\nu$ for every $\nu>0$ implies \lean{Clay_B_exact}. Here \lean{DirectionCurvatureBound} is an abbreviation for \lean{UniformVorticityEnvelopeBound}, an \emph{assumed} uniform ceiling on $\|\omega(t)\|_\infty$ along periodic smooth solutions (not a differential inequality)
PAPER_QUOTE_END

PAPER_QUOTE_BEGIN
The reduction from \lean{Clay_B_exact} to the periodic closing bound \lean{PeriodicTetherClosingBound} and classical periodic BKM continuation \lean{PeriodicBKMContinuation} is proved axiom-clean
PAPER_QUOTE_END

PAPER_QUOTE_BEGIN
Then there is a velocity field $u$ with $u(0)=u_0(0)$ that is spatially $C^\infty$ for every $t\ge0$, is a physical solution of \lean{navier_stokes_eq} with viscosity $\nu$ for some pressure, satisfies $M(t)\le\max\bigl(M(0),C/\kappa''\bigr)$ for every $t\ge0$ for some constants $C>0$ and $\kappa''>0$, and agrees at every $t\ge0$ with every velocity field $v$ that has $v(0)=u_0(0)$, is spatially $C^\infty$ for every $t\ge0$, and is a physical solution of \lean{navier_stokes_eq} with viscosity $\nu$ for some pressure.
PAPER_QUOTE_END

PAPER_QUOTE_BEGIN
It is not the case that for every velocity field $u_0$ and every $\nu\in\mathbb{R}$ the following holds: for every $(u,p)$ with $\nu>0$, \lean{NS_PDE}~$u$~$p$~$\nu$, $u(0)=u_0$ and \lean{IsPhysicalNSSolution}~$u$, the map $t\mapsto M(t)$ is continuous on $\mathbb{R}$, $x\mapsto|\omega(u(t))(x)|$ is bounded above for every $t\ge0$, and there are constants $C>0$ and $\kappa''>0$ such that for every $s\ge0$ the map $t\mapsto M(t)$ is differentiable at $s$ with $M'(s)\le C\,M(s)^2-\kappa''\,M(s)^3$.
PAPER_QUOTE_END

Second paper (lock `EnvelopeReduction`; checked by the in-build gate against
`truth-gate.lock.json`): `docs/VorticityEnvelopeCorrection.tex`, sha256
`e35cbb8274d914297828e67fd748968cb4ef56a22bd8bd4a482e7d7f0cb633a7`, §2 "The checked conditional
consequences".

Scope: CONDITIONAL. Every locked positive claim is an implication whose hypotheses (the uniform
vorticity envelope / ceiling or the periodic tether closing bound, and periodic BKM continuation,
for every `ν > 0`; or, for Theorem 1.1, the single-datum cubic rate, BKM continuation and
uniqueness) are OPEN and stay explicit on both sides; lock `TetherTheorem` is a negative result. The analytic link of the tether is not
established. Nothing here is a proof of the Navier–Stokes Millennium problem.

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

/-! ## Lock 4: Theorem 1.1 of `main.tex` (`CeilingFromRate.conditional_global_regularity_with_ceiling`) -/

/-- Paper: `main.tex`, §1 Introduction, Theorem 1.1 (`thm:main`), hypothesis (R). Verbatim:
"for every physical solution $(u,p)$ (\lean{IsPhysicalNSSolution}) of \lean{NS_PDE} with
viscosity $\nu$ and $u(0)=u_0(0)$, the map $t\mapsto M(t)$ is continuous on $\mathbb{R}$,
$x\mapsto|\omega(u(t))(x)|$ is bounded above for every $t\ge0$, and there are constants $C>0$
and $\kappa''>0$ such that for every $s\ge0$ the map $t\mapsto M(t)$ is differentiable at $s$
with $M'(s)\le C\,M(s)^2-\kappa''\,M(s)^3$". Transcribed from that sentence, not from
`FrohmanianTetherRate`. This is the rate for the ONE datum `a`, not for all data.

**Transcription status: PENDING AUTHOR APPROVAL** (Frohman, Benjamin Stanley). -/
def PaperSingleDatumRate (a : VelocityField) (ν : ℝ) : Prop :=
  ∀ (u : TimeDependentVelocity) (p : TimeDependentPressure),
    IsPhysicalNSSolution u → NS_PDE u p ν → u 0 = a →
      Continuous (fun t : ℝ => vorticity_sup_norm (vorticity (u t))) ∧
      (∀ t : ℝ, 0 ≤ t → BddAbove (Set.range fun x => ‖vorticity (u t) x‖)) ∧
      ∃ C k : ℝ, 0 < C ∧ 0 < k ∧ ∀ s : ℝ, 0 ≤ s →
        DifferentiableAt ℝ (fun t : ℝ => vorticity_sup_norm (vorticity (u t))) s ∧
        deriv (fun t : ℝ => vorticity_sup_norm (vorticity (u t))) s ≤
          C * vorticity_sup_norm (vorticity (u s)) ^ 2 -
            k * vorticity_sup_norm (vorticity (u s)) ^ 3

/-- Paper: `main.tex`, Theorem 1.1: "is a physical solution of \lean{navier_stokes_eq} with
viscosity $\nu$ for some pressure".

**Transcription status: PENDING AUTHOR APPROVAL** (Frohman, Benjamin Stanley). -/
def PaperPhysicalNSSolution (u : TimeDependentVelocity) (ν : ℝ) : Prop :=
  IsPhysicalNSSolution u ∧ ∃ p : TimeDependentPressure, navier_stokes_eq u p ν

namespace ConditionalGlobalRegularity

/-- Paper: `main.tex`, §1 Introduction, Theorem 1.1 (`thm:main`, "Conditional global regularity
with a vorticity ceiling from the single-datum cubic rate"). Verbatim: "Let $\nu>0$ and let
$u_0$ be a time-dependent velocity field on $\mathbb{R}^3$ that is divergence-free at every time
and whose initial slice $u_0(0)$ is smooth (\lean{ContDiff ℝ ⊤}) and of finite $L^2$ energy.
Let $w$ be a Kato local witness (\lean{KatoLocalWitness}) for $u_0(0)$ and $\nu$, and assume:"
(R) [see `PaperSingleDatumRate`], "(C) \emph{Beale--Kato--Majda continuation criterion}
(\lean{PhysicalBKMContinuationCriterionFor}) for $u_0(0)$ and $\nu$; (U) \emph{Physical
uniqueness against $w$} (\lean{KatoUniquenessOnExistenceTimes})." and "Then there is a velocity
field $u$ with $u(0)=u_0(0)$ that is spatially $C^\infty$ for every $t\ge0$, is a physical
solution of \lean{navier_stokes_eq} with viscosity $\nu$ for some pressure, satisfies
$M(t)\le\max\bigl(M(0),C/\kappa''\bigr)$ for every $t\ge0$ for some constants $C>0$ and
$\kappa''>0$, and agrees at every $t\ge0$ with every velocity field $v$ that has
$v(0)=u_0(0)$, is spatially $C^\infty$ for every $t\ge0$, and is a physical solution of
\lean{navier_stokes_eq} with viscosity $\nu$ for some pressure." Conditional: (R) for a given
nonzero datum is open.

**Transcription status: PENDING AUTHOR APPROVAL** (Frohman, Benjamin Stanley). -/
def paper_claim : Prop :=
  ∀ (ν : ℝ) (u₀ : TimeDependentVelocity), 0 < ν →
    (∀ t x, div (u₀ t) x = 0) → ContDiff ℝ (⊤ : ℕ∞) (u₀ 0) →
    Integrable (fun x : T3 => ‖u₀ 0 x‖ ^ 2) →
    ∀ w : KatoLocalWitness (u₀ 0) ν,
    -- (R) cubic rate for this one datum
    PaperSingleDatumRate (u₀ 0) ν →
    -- (C) Beale–Kato–Majda continuation criterion
    TetheredLyapunov.PhysicalBKMContinuationCriterionFor (u₀ 0) ν →
    -- (U) physical uniqueness against w
    TetheredLyapunov.KatoUniquenessOnExistenceTimes (u₀ 0) ν w →
    ∃ u : TimeDependentVelocity, u 0 = u₀ 0 ∧
      (∀ t : ℝ, 0 ≤ t → ContDiff ℝ (⊤ : ℕ∞) (u t)) ∧
      PaperPhysicalNSSolution u ν ∧
      (∃ C k : ℝ, 0 < C ∧ 0 < k ∧ ∀ t : ℝ, 0 ≤ t →
        vorticity_sup_norm (vorticity (u t)) ≤
          max (vorticity_sup_norm (vorticity (u 0))) (C / k)) ∧
      ∀ v : TimeDependentVelocity, v 0 = u₀ 0 →
        (∀ t : ℝ, 0 ≤ t → ContDiff ℝ (⊤ : ℕ∞) (v t)) →
        PaperPhysicalNSSolution v ν → ∀ t : ℝ, 0 ≤ t → v t = u t

/-- The statement of `CeilingFromRate.conditional_global_regularity_with_ceiling` as Lean
proves it. -/
def formal_claim : Prop :=
  ∀ (u0 : TimeDependentVelocity) (_h_div_free : ∀ t x, div (u0 t) x = 0)
    (_h_smooth : ConditionalRegularity.IsSmooth (u0 0))
    (_h_finite_energy : Integrable (fun x : T3 => ‖u0 0 x‖ ^ 2))
    (ν : ℝ) (_h_ν_pos : ν > 0)
    (w : KatoLocalWitness (u0 0) ν)
    (_hR : FrohmanianTetherRate (u0 0) ν)
    (_hcrit : TetheredLyapunov.PhysicalBKMContinuationCriterionFor (u0 0) ν)
    (_huniq : TetheredLyapunov.KatoUniquenessOnExistenceTimes (u0 0) ν w),
  ∃ u : TimeDependentVelocity,
    (∀ t ≥ (0 : ℝ), ConditionalRegularity.IsSmooth (u t)) ∧
    u 0 = u0 0 ∧
    (∀ t ≥ (0 : ℝ), ConditionalRegularity.satisfies_NavierStokes u ν) ∧
    (∃ C κ'' : ℝ, 0 < C ∧ 0 < κ'' ∧ ∀ t ≥ (0 : ℝ),
      vorticity_sup_norm (vorticity (u t)) ≤
        max (vorticity_sup_norm (vorticity (u 0))) (C / κ'')) ∧
    (∀ v : TimeDependentVelocity,
      (∀ t ≥ (0 : ℝ), ConditionalRegularity.IsSmooth (v t)) →
      v 0 = u0 0 →
      (∀ t ≥ (0 : ℝ), ConditionalRegularity.satisfies_NavierStokes v ν) →
      ∀ t ≥ (0 : ℝ), v t = u t)

/-- Under `0 < ν`, the paper's (R) for one datum is `FrohmanianTetherRate` for that datum. -/
theorem paperSingleDatumRate_iff (a : VelocityField) (ν : ℝ) (hν : 0 < ν) :
    PaperSingleDatumRate a ν ↔ FrohmanianTetherRate a ν := by
  constructor
  · intro h u p _ hNS h0 hphys
    obtain ⟨hc, hb, C, k, hC, hk, hs⟩ := h u p hphys hNS h0
    exact ⟨C, k, hC, hk, fun s hs' => (hs s hs').1, fun s hs' => (hs s hs').2, hc,
      fun t ht => hb t ht⟩
  · intro h u p hphys hNS h0
    obtain ⟨C, k, hC, hk, hd, hD, hc, hb⟩ := h u p hν hNS h0 hphys
    exact ⟨hc, fun t ht => hb t ht, C, k, hC, hk, fun s hs => ⟨hd s hs, hD s hs⟩⟩

/-- `satisfies_NavierStokes` does not depend on `t`, so its `∀ t ≥ 0` form is the paper's
"physical solution of `navier_stokes_eq` for some pressure". -/
theorem forall_satisfies_iff (u : TimeDependentVelocity) (ν : ℝ) :
    (∀ t ≥ (0 : ℝ), ConditionalRegularity.satisfies_NavierStokes u ν) ↔
      PaperPhysicalNSSolution u ν := by
  rw [show PaperPhysicalNSSolution u ν ↔ ConditionalRegularity.satisfies_NavierStokes u ν from
    (ConditionalRegularity.satisfies_NavierStokes_iff u ν).symm]
  exact ⟨fun h => h 0 le_rfl, fun h _ _ => h⟩

/-- **Fixed once.** -/
theorem intended_correspondence : formal_claim ↔ paper_claim := by
  unfold formal_claim paper_claim
  constructor
  · intro h ν u₀ hν hdiv hsm hE w hR hC hU
    obtain ⟨u, hsmu, hu0, hns, ⟨C, k, hC0, hk0, hceil⟩, huniq⟩ :=
      h u₀ hdiv hsm hE ν hν w ((paperSingleDatumRate_iff _ _ hν).1 hR) hC hU
    refine ⟨u, hu0, fun t ht => hsmu t ht, (forall_satisfies_iff u ν).1 hns,
      ⟨C, k, hC0, hk0, fun t ht => hceil t ht⟩, ?_⟩
    intro v hv0 hsmv hnsv t ht
    exact huniq v (fun s hs => hsmv s hs) hv0 ((forall_satisfies_iff v ν).2 hnsv) t ht
  · intro h u₀ hdiv hsm hE ν hν w hR hC hU
    obtain ⟨u, hu0, hsmu, hns, ⟨C, k, hC0, hk0, hceil⟩, huniq⟩ :=
      h ν u₀ hν hdiv hsm hE w ((paperSingleDatumRate_iff _ _ hν).2 hR) hC hU
    refine ⟨u, fun t ht => hsmu t ht, hu0, (forall_satisfies_iff u ν).2 hns,
      ⟨C, k, hC0, hk0, fun t ht => hceil t ht⟩, ?_⟩
    intro v hsmv hv0 hnsv t ht
    exact huniq v hv0 (fun s hs => hsmv s hs) ((forall_satisfies_iff v ν).1 hnsv) t ht

end ConditionalGlobalRegularity

/-! ## Lock 5: Proposition 1.1 of `main.tex` (the all-data rate hypothesis is unsatisfiable) -/

namespace TetherTheorem

/-- Paper: `main.tex`, §1 Introduction, Proposition `prop:hDI` ("The all-data rate hypothesis of
frohmanian_tether_theorem is unsatisfiable"). Verbatim: "It is not the case that for every
velocity field $u_0$ and every $\nu\in\mathbb{R}$ the following holds: for every $(u,p)$ with
$\nu>0$, \lean{NS_PDE}~$u$~$p$~$\nu$, $u(0)=u_0$ and \lean{IsPhysicalNSSolution}~$u$, the map
$t\mapsto M(t)$ is continuous on $\mathbb{R}$, $x\mapsto|\omega(u(t))(x)|$ is bounded above for
every $t\ge0$, and there are constants $C>0$ and $\kappa''>0$ such that for every $s\ge0$ the map
$t\mapsto M(t)$ is differentiable at $s$ with $M'(s)\le C\,M(s)^2-\kappa''\,M(s)^3$."
Transcribed from that sentence, not from `FrohmanianTetherRate`.

**Transcription status: PENDING AUTHOR APPROVAL** (Frohman, Benjamin Stanley). -/
def paper_claim : Prop :=
  ¬ ∀ (u₀ : VelocityField) (ν : ℝ),
    ∀ (u : TimeDependentVelocity) (p : TimeDependentPressure),
      0 < ν → NS_PDE u p ν → u 0 = u₀ → IsPhysicalNSSolution u →
        Continuous (fun t : ℝ => vorticity_sup_norm (vorticity (u t))) ∧
        (∀ t : ℝ, 0 ≤ t → BddAbove (Set.range fun x => ‖vorticity (u t) x‖)) ∧
        ∃ C k : ℝ, 0 < C ∧ 0 < k ∧ ∀ s : ℝ, 0 ≤ s →
          DifferentiableAt ℝ (fun t => vorticity_sup_norm (vorticity (u t))) s ∧
          deriv (fun t => vorticity_sup_norm (vorticity (u t))) s ≤
            C * vorticity_sup_norm (vorticity (u s)) ^ 2 -
              k * vorticity_sup_norm (vorticity (u s)) ^ 3

/-- What Lean proves (`TetherRateCounterexample.frohmanian_tether_theorem_hDI_unsatisfiable`):
the `hDI` binder of `frohmanian_tether_theorem` is unsatisfiable. -/
def formal_claim : Prop :=
  ¬ ∀ (u₀ : VelocityField) (ν : ℝ), FrohmanianTetherRate u₀ ν

/-- **Fixed once.** -/
theorem intended_correspondence : formal_claim ↔ paper_claim := by
  unfold formal_claim paper_claim
  refine not_congr ⟨fun h u₀ ν u p hν hNS h0 hphys => ?_, fun h u₀ ν u p hν hNS h0 hphys => ?_⟩
  · obtain ⟨C, k, hC, hk, hd, hdi, hc, hb⟩ := h u₀ ν u p hν hNS h0 hphys
    exact ⟨hc, fun t ht => hb t ht, C, k, hC, hk, fun s hs => ⟨hd s hs, hdi s hs⟩⟩
  · obtain ⟨hc, hb, C, k, hC, hk, hds⟩ := h u₀ ν u p hν hNS h0 hphys
    exact ⟨C, k, hC, hk, fun s hs => (hds s hs).1, fun s hs => (hds s hs).2, hc,
      fun t ht => hb t ht⟩

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
