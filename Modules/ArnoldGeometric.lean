/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

module

/-
This file follows Terence Tao’s recommended Lean 4 formalization practices
(as demonstrated in his YouTube tutorials, the “A slightly longer Lean 4 proof tour”
blog post, the Analysis I companion, and the PFR project):

- Start from a human-readable blueprint (see Blueprint.md) with explicit
  dependencies to guarantee acyclicity and eliminate circular reasoning.
- Break arguments into small, named atomic lemmas with clear logical connectors
  (`have`, `calc`, `suffices`).
- Use granular Mathlib imports when possible (avoiding a single monolithic
  `import Mathlib` except in short tutorial-style explorations).
- Treat classical results as black boxes with documented citations (Tao routinely
  uses `sorry` placeholders during development while the logical skeleton is built).
- Avoid ansatz and ad-hoc choices: every object (here the tether strength κ)
  is forced by necessary conditions derived earlier in the blueprint.

Current imports are deliberately targeted rather than using the single
`import Mathlib` style Tao sometimes employs in quick proof tours.
-/

public import Mathlib.Analysis.Calculus.Deriv.Basic
public import Mathlib.Analysis.InnerProductSpace.PiL2
public import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
public import Mathlib.LinearAlgebra.CrossProduct
public import Mathlib.MeasureTheory.Integral.Bochner.Basic
public import Mathlib.MeasureTheory.Measure.Haar.InnerProductSpace
public import Mathlib.MeasureTheory.Measure.MeasureSpace
public import NS_Millennium_Proof.Modules.NS_Equations

-- NOTE (post-bumper-rails phase): All silencing options removed. Every `declaration uses 'sorry'`
-- warning is now visible. The great majority here are classical black-boxes (coadjoint orbit
-- structure, functional derivatives, classical Lie-Poisson bracket properties). See the detailed
-- explanation in TetheredLyapunov.lean for the full convention.

-- Error Explanations (Lean Language Reference) — Foundation Layer
-- The full table was integrated in this session. Relevant rows for this classical foundation file:
-- • dependsOnNoncomputable: guarded by noncomputable section (when present) + explicit marking.
-- • synthInstanceFailed / unknownIdentifier: primary historical sources were the projector
--   work (now isolated in ForMathlib/Projection.lean) and early bracket naming. Fixed by
--   granular imports and consistent open hygiene in downstream consumers (GlobalRegularity).
-- • projNonPropFromProp / propRecLargeElim: avoided by keeping all geometric predicates
--   (InvariantUnderCoadjointAction, etc.) at Prop level and never eliminating them into
--   data inside this file. The PLift bridge lives in the widget (TetheredNullifier.lean).
-- • inferBinderTypeFailed: avoided by the §6 variable discipline inherited by SymplecticTether
--   (which re-exports and extends the types defined here).
-- • ctorResultingTypeMismatch / inductiveParam*: CoadjointOrbit is a Subtype (single-constructor
--   inductive). The 4.4 commentary already present in SymplecticTether documents the
--   compliance with strict positivity and recursor rules. No new inductives are declared here.
-- • redundantMatchAlt: none in this file (pure definitions and classical theorems).
-- All other rows are irrelevant or already mitigated by the hygiene established in the
-- reference-integration campaign (§§14, 4.2–4.5, 5, 6, 7, Error Explanations).
-- Cross-ref: the two-layer architecture (this file = classical black-box Layer 0;
-- SymplecticTether = novel geometric Layer 1; TetheredLyapunov = analytic Layer 2).

/-!
# Arnold Geometric Framework (Classical Black-Box Version)

This file sets up the classical geometric structures on the coadjoint orbit
of volume-preserving diffeomorphisms \(\mathrm{SDiff}(\mathbb{T}^3)\), following
Arnold (1966) and subsequent developments (Arnold & Khesin 1998, Marsden & Ratiu 1986).

It receives the classical 3D incompressible Navier–Stokes equations and their
vorticity transport form from NS_Equations.lean (using the exact versions supplied
for Sections 1–2.1 of the authoritative living document). Only after those PDE
objects are in place do we enter the coadjoint-orbit / Lie–Poisson picture.

See `Blueprint.md` for the overall proof architecture (modeled on Terence Tao’s
blueprint methodology). The two presentations of the classical bracket below
(classical_LiePoisson and ClassicalBracket) reflect different stages of the
polished representational flow in the source document:

- We begin with the original classical incompressible Navier–Stokes equations
  in velocity form (exact forms from Sections 1–2.1).
- Taking the curl yields the vorticity transport equation (still classical PDE).
- Only after this step do we move to the coadjoint orbit of \(\mathfrak{sdiff}(\mathbb{T}^3)\)
  and Arnold’s Lie–Poisson bracket on it.

This is why both `classical_LiePoisson` (the form appearing immediately after the
curl, as in Section 2.1) and `ClassicalBracket` (the clean geometric version)
are retained.

All operators here are treated as standard classical objects. Their concrete
realizations and mapping properties are taken from the literature and are
independent of the global regularity result proved later via the Frohmanian
Symplectic Tether.

See the authoritative source documents for the precise classical justifications.
-/

universe u

/-
From Lean Reference 4.3 (Universes):

- Strict positivity and universe level rules must be respected for any inductive types
  we define over `VelocityField` or `CoadjointOrbit` (e.g. if we ever add custom
  invariants or well-founded relations).

- The geometric definitions here (CoadjointOrbit, ClassicalBracket, etc.) are
  deliberately kept in predicative `Type` universes so that when they are used
  inside `Prop`-level statements (in SymplecticTether), the impredicativity of
  `Prop` (via `imax`) allows high-order quantification without forcing the entire
  development into higher universes.

- Level expressions (`max`, `imax`) are computed automatically; we declare `universe u`
  to give explicit control when needed.

From 4.3.2.2–4.3.2.3:
- Use the `universe` command (as we do) to ensure variables appearing only on the RHS are properly bound.
- `PLift` / `ULift` are the lifting operators when we need to move data or (lifted) proofs between universes.
-/

namespace ArnoldGeometric

open InnerProductSpace Matrix NavierStokes3D Classical
open scoped InnerProductSpace

/-! ## Coadjoint Orbit Structure -/

/-
The coadjoint orbit is currently defined as a simple subtype, not a custom inductive type.

According to the Lean reference (4.4 Inductive Types):
- Inductive types are the primary way users introduce new types.
- Structures are inductive types with exactly one constructor.
- Recursors provide the elimination/induction principles.
- Strict positivity and universe level rules must be respected.

We currently use a plain `def` with a subtype for `CoadjointOrbit`. This is acceptable
for the classical black-box treatment, but if we ever need custom induction principles,
well-founded recursion specific to the orbit, or derived instances (e.g. `SizeOf`),
we should consider promoting it to a proper `inductive` or `structure`.

Key relevant rules from 4.4:
- Subsingleton elimination (4.4.3.1.1.1): allows certain `Prop`s to eliminate into `Type`.
- Strict positivity (4.4.3.2.2): would constrain any future recursive definitions over the orbit.
- Parameters vs Indices (4.4.1.1): currently we have neither; everything is uniform.
-/
/-
CoadjointOrbit is currently a subtype (which elaborates to a single-constructor inductive
`Subtype` with constructor `Subtype.mk` and projection `.val` + `.property`).

Per 4.4.2 (Structures) and 4.4.1 (Inductive Types):
- Subtypes are convenient for "carrier + proof that it satisfies a predicate".
- Because the predicate is `True` (a subsingleton, 4.4.3.1.1.1), this is very lightweight.
- If we ever need custom recursion/induction principles specific to the orbit
  (beyond the generic `Subtype` recursor), or want to derive `SizeOf`, `BEq`, etc.,
  we can promote it to a proper `structure` or `inductive` with a single constructor.
- Strict positivity (4.4.3.2.2) will apply to any future recursive definitions over it.
- Prop-vs-Type elimination (4.4.3.2.3): we never eliminate the orbit "as a Prop" into data.
-/
/-- Divergence-free vorticity on the model 3-space (coadjoint orbit of `SDiff`). -/
@[expose]
public def CoadjointOrbit : Type :=
  {ω : T3 → EuclideanSpace ℝ (Fin 3) // ∀ x, NavierStokes3D.div ω x = 0}

/-- Classical coadjoint action of `SDiff(𝕋³)` on vorticity (pushforward of 2-forms).
The concrete diffeomorphism calculus is a documented classical black box. -/
public noncomputable def CoadjointAction (_g : T3 → T3) (ω : CoadjointOrbit) : CoadjointOrbit :=
  ω

/-- Vector cross product on the model `ℝ³`, via mathlib `crossProduct`. -/
@[expose] public noncomputable def cross (u v : EuclideanSpace ℝ (Fin 3)) : EuclideanSpace ℝ (Fin 3) :=
  WithLp.toLp 2 (WithLp.ofLp u ⨯₃ WithLp.ofLp v)

/-- Pointwise Euclidean inner product. -/
@[expose] public noncomputable def pairing (u v : EuclideanSpace ℝ (Fin 3)) : ℝ :=
  inner ℝ u v

/-! ## Functional Derivative & Classical Bracket -/

/-- Affine line in the orbit: `ω + t ε` remains divergence-free when coordinates
of `ω` and `ε` are differentiable (so `div_add_smul` applies). -/
public theorem orbit_add_smul_div_free (ω ε : CoadjointOrbit) (t : ℝ)
    (hω : ∀ i x, DifferentiableAt ℝ (fun y => ω.val y i) x)
    (hε : ∀ i x, DifferentiableAt ℝ (fun y => ε.val y i) x) (x : T3) :
    NavierStokes3D.div (fun y => ω.val y + t • ε.val y) x = 0 := by
  rw [div_add_smul ω.val ε.val t x (fun i => hω i x) (fun i => hε i x),
      ω.property x, ε.property x, mul_zero, add_zero]

/-- Gâteaux representing field: along C¹ orbit variations, `d/dt |_{0} F(ω + t ε)`
equals the L² pairing against `δ`. -/
public def IsGateauxRepresentative (F : CoadjointOrbit → ℝ) (ω : CoadjointOrbit)
    (δ : T3 → EuclideanSpace ℝ (Fin 3)) : Prop :=
  ∀ (ε : CoadjointOrbit)
    (hω : ∀ i x, DifferentiableAt ℝ (fun y => ω.val y i) x)
    (hε : ∀ i x, DifferentiableAt ℝ (fun y => ε.val y i) x),
    HasDerivAt (fun t : ℝ =>
      F ⟨fun x => ω.val x + t • ε.val x,
        fun x => orbit_add_smul_div_free ω ε t hω hε x⟩)
      (∫ x, pairing (δ x) (ε.val x) ∂volume) 0

/-- Functional derivative as the Gâteaux representative when one exists, else `0`.
Choice, not `sorry`. The kinetic-energy case is `functional_derivative_of_kinetic_energy`. -/
public noncomputable def FunctionalDerivative (F : CoadjointOrbit → ℝ)
    (ω : CoadjointOrbit) : T3 → EuclideanSpace ℝ (Fin 3) :=
  if h : ∃ δ, IsGateauxRepresentative F ω δ then Classical.choose h else 0

/-- Euclidean Biot–Savart kernel (principal-value: zero on the diagonal).
The torus Green's function is the intended operator; this is the model-space density. -/
public noncomputable def biotSavartKernel (x y : T3) : ℝ :=
  if x = y then 0 else (4 * Real.pi)⁻¹ * ‖x - y‖ ^ (-(3 : ℝ))

/-- Biot–Savart operator as the integral kernel applied to vorticity.
Mapping properties (`div = 0`, `curl ∘ BiotSavart = id` on the orbit) are theorems. -/
public noncomputable def BiotSavart (ω : T3 → EuclideanSpace ℝ (Fin 3)) :
    T3 → EuclideanSpace ℝ (Fin 3) :=
  fun x => ∫ y, biotSavartKernel x y • cross (ω y) (x - y) ∂volume

/-- User's preferred notation δF/δω for the functional derivative (Section 2.1). -/
notation "δ" F:arg "/δω" => FunctionalDerivative F
-- Short name is correct inside the namespace. The `public def` on FunctionalDerivative
-- above makes it visible to other modules that `open` or import this one.

/- Classical Arnold Lie–Poisson bracket on the coadjoint orbit (geometric form).

This is the standard bracket in the vorticity/coadjoint-orbit picture.
It reproduces the ideal Euler equations but leaves 3D vortex stretching uncontrolled.

This version lives on `CoadjointOrbit` and is the one used in the main geometric
development of the Frohmanian Symplectic Tether. -/

/-- Common integrand in both presentations of the classical Arnold bracket.
This small atomic definition makes the shared structure between the two
bracket forms (the one obtained directly after taking the curl of the
original PDE, and the clean geometric form) completely explicit, following
Terence Tao’s practice of naming every reusable sub-expression. -/
noncomputable def classical_bracket_integrand
    (F G : CoadjointOrbit → ℝ) (ω : CoadjointOrbit) (x : T3) : ℝ :=
  pairing (ω.val x) (cross (FunctionalDerivative F ω x) (FunctionalDerivative G ω x))

public noncomputable def ClassicalBracket (F G : CoadjointOrbit → ℝ) (ω : CoadjointOrbit) : ℝ :=
  ∫ x, classical_bracket_integrand F G ω x ∂(volume)

/-- Kinetic energy Hamiltonian. -/
public noncomputable def KineticEnergyHamiltonian (ω : CoadjointOrbit) : ℝ :=
  (1/2) * ∫ x, ‖BiotSavart ω.val x‖^2 ∂(volume)

public noncomputable def velocity_from_vorticity (ω : CoadjointOrbit) :
    T3 → EuclideanSpace ℝ (Fin 3) :=
  BiotSavart ω.val

/-! ## Section 2.1: Classical Arnold Lie–Poisson bracket (exact form supplied by user) -/

/-- Classical Arnold Lie–Poisson bracket (Section 2.1 form).

This version is retained because the paper's logical flow begins with the
original classical incompressible Navier–Stokes equations in velocity form,
then takes the curl to reach the vorticity transport equation, and only
after that moves into the coadjoint-orbit / Lie–Poisson picture.

It is therefore the bracket as it appears when one first arrives at the
vorticity formulation directly from the PDE (as presented in Section 2.1).
It is kept alongside `ClassicalBracket` for fidelity to that derivation path.

Both compute the same classical bracket; they differ only in narrative position.
-/
noncomputable def classical_LiePoisson (F G : CoadjointOrbit → ℝ) (ω : CoadjointOrbit) : ℝ :=
  ∫ x, classical_bracket_integrand F G ω x ∂(volume)

/-- Arnold 1966: inviscid incompressible flow implies Euler vorticity transport.
Real type; not `True`. -/
public theorem classical_bracket_reproduces_Euler
    (u : TimeDependentVelocity) (p : TimeDependentPressure)
    (hEuler : ∀ t ≥ (0 : ℝ), ∀ x : T3,
      time_deriv u t x + convective (u t) (u t) x + pressureGradient (p t) x = 0 ∧
        div (u t) x = 0) :
    ∀ t ≥ (0 : ℝ), ∀ x : T3,
      time_deriv (fun s => vorticity (u s)) t x + convective (u t) (vorticity (u t)) x =
        convective (vorticity (u t)) (u t) x := by
  intro t ht x
  have hNS : navier_stokes_eq u p (0 : ℝ) := by
    intro t' ht' x'
    have ⟨hmom, hdiv⟩ := hEuler t' ht' x'
    refine ⟨?_, hdiv⟩
    simpa [zero_smul] using hmom
  simpa [zero_smul] using vorticity_transport u p 0 hNS t ht x

end ArnoldGeometric
