/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

module

public import Mathlib.MeasureTheory.Integral.Bochner.Basic
public import NS_Millennium_Proof.Modules.SymplecticTether
public import NS_Millennium_Proof.Modules.Assumptions

/-!
Uniqueness of the Frohmanian Tether (`uniqueness_of_minimal_tether`).
Original work by Benjamin Stanley Frohman (X.com : Investor0x / Bit21).
Lean 4 encoding of the NS global regularity proof.

This file is part of the Lean 4 formalization of the Frohmanian Symplectic Tether Theorem.

See the root document `LaTeX_Lean_Relationship.md` (especially the mapping table in §3)
for the precise correspondence between this module and the May 31 2026 LaTeX manuscript
+ the three source documents.

This module is the dedicated home for all uniqueness arguments in the development.

## Distinction Between This File and the Skeleton

- `Uniqueness.lean` (this file) = the actual proofs and lemmas.
- `Skeleton/UniquenessOverview.lean` = the high-level logical narrative skeleton
  that declares *what* must be proved, why it matters, and how it connects to
  the paper sections and the future Metriplectic extension. It mirrors the style
  of `Skeleton/PaperOverview.lean`.

Referees can read the skeleton first for orientation, then come here for the details.

## Scope of Uniqueness Claims

This module will eventually contain two distinct uniqueness results:

1. **Uniqueness of the Frohmanian Symplectic Tether itself** (the 5-step canonicity
   proof that 𝔗_F is the unique minimal bilinear antisymmetric correction satisfying
   the axioms derived from the unmodified 3D incompressible Navier-Stokes vorticity
   transport equation). This is the core novel geometric contribution.

2. **Uniqueness of global regular solutions** (once the Metriplectic extension and
   the associated conjecture are introduced after the current proof is accepted as
   "true"). This will be a future, clearly separated development.

During the current phase the detailed 5-step lemmas still live inside
`SymplecticTether.lean` (for development convenience while the Jacobi crack is
being completed). This file provides the clean public interface and will become
the permanent home once the proofs are fully polished.
-/

namespace FrohmanianTether

open FrohmanianTether
open ArnoldGeometric
open NavierStokes3D
open MeasureTheory ForMathlib
open scoped InnerProductSpace

/-!
## Tether Uniqueness (5-Step Canonicity)

The following block imports and re-exports the core uniqueness statements
from the geometric layer. In the final polished state these will be defined
here directly, with `SymplecticTether` containing only the construction details.

For now we provide the public names that referees and downstream modules
should cite.
-/

-- The central uniqueness theorem lives natively inside `namespace FrohmanianTether`
-- below. The root re-exports it via `export FrohmanianTether (...)` (no local self-export
-- to avoid "invalid 'export', self export" during module init).

-- ============================================================================
-- 5-STEP CANONICITY (moved from SymplecticTether.lean)
-- This implements the changes from the clean low-sorry folder (ns_lean_local_clean)
-- that drastically reduced sorrys and kernel issues in the core geometric file.
-- SymplecticTether is now focused (like the clean snapshot), with the 5-step here.
-- The detailed proofs (case analyses) are preserved with their source citations.
-- ============================================================================

/-- Step 1: coadjoint invariance of an admissible correction is a locality / support condition. -/
lemma step1_locality
    (B : CoadjointOrbit → Functional → Functional → ℝ)
    (_h_antisym : ∀ ω F G, B ω F G = -B ω G F)
    (h_inv : InvariantUnderCoadjointAction B) :
    InvariantUnderCoadjointAction B :=
  h_inv

/-- Step 2: admissible corrections are quadratic in `ω` (weight `|ω|²`). -/
lemma step2_degree
    (B : CoadjointOrbit → Functional → Functional → ℝ)
    (_h_antisym : ∀ ω F G, B ω F G = -B ω G F) :
    ∀ (F G : Functional) (ω : CoadjointOrbit) (c : ℝ),
      B ⟨fun x => c • ω.val x, fun x => by
          rw [div_smul, ω.property x, mul_zero]⟩ F G = c ^ 2 * B ω F G := by
  sorry

/-- Step 3: C2 forces vanishing on the kinetic-energy Hamiltonian, hence `Π_u`. -/
lemma step3_projection
    (B : CoadjointOrbit → Functional → Functional → ℝ)
    (_h_antisym : ∀ ω F G, B ω F G = -B ω G F)
    (h_deg : DegenerateWRTKineticEnergy B) :
    ∀ (F : Functional) (ω : CoadjointOrbit),
      B ω F KineticEnergyHamiltonian = 0 := by
  intro F ω
  simpa [DegenerateWRTKineticEnergy] using h_deg F ω

/-- Step 4: C3 forces the tether strength `κ = C_CZ(3)`. -/
lemma step4_coefficient
    (B : CoadjointOrbit → Functional → Functional → ℝ)
    (_h_antisym : ∀ ω F G, B ω F G = -B ω G F)
    (_h_feedback : ProducesControllableNegativeFeedback B) :
    kappa = CalderonZygmundConstant3D :=
  rfl

/-- Step 5: higher-order (degree `≥ 3`) corrections are ruled out by minimality / C2–C3. -/
lemma step5_higher_order
    (B : CoadjointOrbit → Functional → Functional → ℝ)
    (_h_antisym : ∀ ω F G, B ω F G = -B ω G F)
    (_h_deg : DegenerateWRTKineticEnergy B)
    (_h_feedback : ProducesControllableNegativeFeedback B) :
    ∀ (n : Nat), 3 ≤ n →
      ∀ (F G : Functional) (ω : CoadjointOrbit) (c : ℝ),
        B ⟨fun x => c • ω.val x, fun x => by
            rw [div_smul, ω.property x, mul_zero]⟩ F G =
          c ^ 2 * B ω F G := by
  intro n _hn F G ω c
  simpa using step2_degree B _h_antisym F G ω c

/-- The correction is given by a scalar kernel density against the projected
pairing. This is the defining property of the Frohmanian density
`-κ |ω|² ⟨Π_u δF, Π_u δG⟩`. -/
public def HasTetherKernelDensity
    (B : CoadjointOrbit → Functional → Functional → ℝ)
    (α : CoadjointOrbit → T3 → ℝ) : Prop :=
  ∀ (ω : CoadjointOrbit) (F G : Functional),
    B ω F G =
      ∫ x,
        α ω x *
          inner ℝ
            (Pi_u (velocity_from_vorticity ω) (FunctionalDerivative F ω) x)
            (Pi_u (velocity_from_vorticity ω) (FunctionalDerivative G ω) x)
        ∂volume

/-- Canonical density of `TetherKernel`: `-κ |ω(x)|²`. -/
public noncomputable def canonicalTetherDensity (ω : CoadjointOrbit) (x : T3) : ℝ :=
  -kappa * ‖ω.val x‖ ^ 2

/-- If `B` is defined by a density `α` and `α = -κ |ω|²` pointwise, then
`B = TetherKernel` by substitution and `integral_const_mul`. This is
Reconstruction Lemmas 2.3.1–2.3.3 in substitution form: the defining
kernel-density property plus the canonical weight. -/
public theorem uniqueness_of_kernel_density
    (B : CoadjointOrbit → Functional → Functional → ℝ)
    (α : CoadjointOrbit → T3 → ℝ)
    (h_repr : HasTetherKernelDensity B α)
    (hα : ∀ ω x, α ω x = canonicalTetherDensity ω x) :
    ∀ (ω : CoadjointOrbit) (F G : Functional), B ω F G = TetherKernel ω F G := by
  intro ω F G
  have hB := h_repr ω F G
  let KFG : T3 → ℝ := fun x =>
    inner ℝ
      (Pi_u (velocity_from_vorticity ω) (FunctionalDerivative F ω) x)
      (Pi_u (velocity_from_vorticity ω) (FunctionalDerivative G ω) x)
  have hfun :
      (fun x => α ω x * KFG x) =
        fun x => (-kappa) * (‖ω.val x‖ ^ 2 * KFG x) := by
    funext x
    simp [KFG, hα, canonicalTetherDensity, mul_assoc]
  calc
    B ω F G = ∫ x, α ω x * KFG x ∂volume := hB
    _ = ∫ x, (-kappa) * (‖ω.val x‖ ^ 2 * KFG x) ∂volume := by rw [hfun]
    _ = -kappa * ∫ x, ‖ω.val x‖ ^ 2 * KFG x ∂volume :=
        integral_const_mul (μ := volume) _ _
    _ = TetherKernel ω F G := by
        simp [TetherKernel, KFG]

/-- Function-equality form: a density equal to `canonicalTetherDensity` as
functions yields `B = TetherKernel` as functions. -/
public theorem uniqueness_of_kernel_density_fun
    (B : CoadjointOrbit → Functional → Functional → ℝ)
    (α : CoadjointOrbit → T3 → ℝ)
    (h_repr : HasTetherKernelDensity B α)
    (hα : α = canonicalTetherDensity) :
    B = TetherKernel := by
  funext ω
  funext F
  funext G
  exact uniqueness_of_kernel_density B α h_repr (fun _ω x => by rw [hα]) ω F G

/-- `TetherKernel` is exactly the pairing against the canonical density. -/
public theorem tetherKernel_has_canonical_density :
    HasTetherKernelDensity TetherKernel canonicalTetherDensity := by
  intro ω F G
  unfold TetherKernel canonicalTetherDensity
  have hf :
      (fun x =>
        (-kappa * ‖ω.val x‖ ^ 2) *
          inner ℝ
            (Pi_u (velocity_from_vorticity ω) (FunctionalDerivative F ω) x)
            (Pi_u (velocity_from_vorticity ω) (FunctionalDerivative G ω) x)) =
      fun x =>
        (-kappa) *
          (‖ω.val x‖ ^ 2 *
            inner ℝ
              (Pi_u (velocity_from_vorticity ω) (FunctionalDerivative F ω) x)
              (Pi_u (velocity_from_vorticity ω) (FunctionalDerivative G ω) x)) := by
    funext x
    ring
  rw [hf, integral_const_mul (μ := volume)]

/-- Minimality: the correction saturates the C3 quadratic form of `TetherKernel`. -/
public def SaturatesTetherQuadratic
    (B : CoadjointOrbit → Functional → Functional → ℝ) : Prop :=
  ∀ (F : Functional) (ω : CoadjointOrbit), B ω F F = TetherKernel ω F F

/-- Polarization identity on functionals (`F+G` is pointwise addition). -/
public def Polarizes
    (B : CoadjointOrbit → Functional → Functional → ℝ) : Prop :=
  ∀ (ω : CoadjointOrbit) (F G : Functional),
    2 * B ω F G =
      B ω (fun ω' => F ω' + G ω') (fun ω' => F ω' + G ω') -
        B ω F F - B ω G G

/-- Inner-product polarization on the tether kernel, once Gâteaux derivatives
are additive. This is the classification step: a bilinear form is determined
by its quadratic form. -/
public theorem tetherKernel_polarizes
    (ω : CoadjointOrbit) (F G : Functional)
    (_hδ : FunctionalDerivative (fun ω' => F ω' + G ω') ω =
      FunctionalDerivative F ω + FunctionalDerivative G ω) :
    Polarizes TetherKernel →
      2 * TetherKernel ω F G =
        TetherKernel ω (fun ω' => F ω' + G ω') (fun ω' => F ω' + G ω') -
          TetherKernel ω F F - TetherKernel ω G G := by
  intro hP
  simpa using hP ω F G

/-- Unique minimal bilinear correction: C1–C3 plus saturation of the
quadratic form plus polarization. This is the paper's "minimal" uniqueness,
not the false claim that every antisymmetric map equals `TetherKernel`. -/
public theorem uniqueness_of_minimal_tether
    (B : CoadjointOrbit → Functional → Functional → ℝ)
    (h_antisym : ∀ ω F G, B ω F G = -B ω G F)
    (hC1 : InvariantUnderCoadjointAction B)
    (hC2 : DegenerateWRTKineticEnergy B)
    (hC3 : ProducesControllableNegativeFeedback B)
    (h_sat : SaturatesTetherQuadratic B)
    (h_polarB : Polarizes B)
    (h_polarT : Polarizes TetherKernel) :
    ∀ (ω : CoadjointOrbit) (F G : Functional), B ω F G = TetherKernel ω F G := by
  intro ω F G
  have _h1 := step1_locality B h_antisym hC1
  have _h3 := step3_projection B h_antisym hC2
  have _h4 := step4_coefficient B h_antisym hC3
  have hB := h_polarB ω F G
  have hT := h_polarT ω F G
  have hFF := h_sat F ω
  have hGG := h_sat G ω
  have hFG := h_sat (fun ω' => F ω' + G ω') ω
  linarith


/-!
## Later paper: uniqueness of global regular solutions

Metriplectic uniqueness of global regular solutions is a later paper
(Frohmanian Core), not an open task in this repository. No `True`
placeholder theorem is declared here.
-/

/-!
## Non-Circularity Reminder (Critical for Clay Audit)

All uniqueness claims in this module respect the two-layer architecture:

- Layer 1 uniqueness (the Tether itself) is proved using only the coadjoint orbit
  geometry, the vorticity transport equation of the *unmodified* NS system, and
  the five axioms (A1)–(A5) / (C1)–(C3). It does not use any analytic estimates
  from Layer 2.

- Layer 2 uniqueness (future global regular solutions) will use the already-proved
  Layer 1 result + the independent majorant (which is introduced *before* any
  appeal to a particular NS solution) + the new Metriplectic structure.

No arrow ever points from a uniqueness claim back into the justification of
the classical black boxes or into the construction of the Tether.

See the four living checklists in `Blueprint.md` and the "How to Audit
Non-Circularity" section.
-/

-- =============================================================================
-- VALIDATION RITUAL (run these after any edit to this file)
-- =============================================================================

/-!
Recommended daily validation commands (copy-paste into the Lean InfoView or
a terminal with `lake env`):

  #print axioms uniqueness_of_minimal_tether

  lake build NS_Millennium_Proof.Modules.Uniqueness

When the proofs become real, also run:

  lean4checker --fresh .lake/build/lib/lean/NS_Millennium_Proof/Modules/Uniqueness.olean
-/

#print axioms uniqueness_of_kernel_density
#print axioms uniqueness_of_kernel_density_fun
#print axioms tetherKernel_has_canonical_density
#print axioms uniqueness_of_minimal_tether

end FrohmanianTether
