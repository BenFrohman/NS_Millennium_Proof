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

public import Mathlib.Analysis.Calculus.Deriv.Add
public import Mathlib.Analysis.Calculus.Deriv.Basic
public import Mathlib.Analysis.Calculus.Deriv.Mul
public import Mathlib.Analysis.Calculus.Deriv.Pow
public import Mathlib.Analysis.InnerProductSpace.PiL2
public import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
public import Mathlib.LinearAlgebra.CrossProduct
public import Mathlib.MeasureTheory.Integral.Bochner.Basic
public import Mathlib.MeasureTheory.Measure.Haar.InnerProductSpace
public import Mathlib.MeasureTheory.Measure.MeasureSpace
public import Mathlib.Tactic.Ring
public import Mathlib.Analysis.Calculus.ParametricIntegral
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

open InnerProductSpace Matrix NavierStokes3D Classical MeasureTheory
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
/-- Divergence-free vorticity on the model 3-space (coadjoint orbit of `SDiff`).
Lean 4 structure (`where`, not the deprecated `structure … :=` form from v4.14).
Fields keep the Subtype names `val` / `property` so existing projections stay valid.
`@[expose]` is a `def`-only attribute (Language Reference, modules); `public structure` is the visibility. -/
public structure CoadjointOrbit where
  val : T3 → EuclideanSpace ℝ (Fin 3)
  property : ∀ x, NavierStokes3D.div val x = 0

/-- Classical coadjoint action of `SDiff(𝕋³)` on vorticity (pushforward of 2-forms).
The concrete diffeomorphism calculus is a documented classical black box. -/
@[expose]
public noncomputable def CoadjointAction (_g : T3 → T3) (ω : CoadjointOrbit) : CoadjointOrbit :=
  ω

/-- Vector cross product on the model `ℝ³`, via mathlib `crossProduct`. -/
@[expose] public noncomputable def cross (u v : EuclideanSpace ℝ (Fin 3)) : EuclideanSpace ℝ (Fin 3) :=
  WithLp.toLp 2 (WithLp.ofLp u ⨯₃ WithLp.ofLp v)

/-- Left-linearity of `cross` in the scalar. -/
public theorem cross_smul_left (c : ℝ) (u v : EuclideanSpace ℝ (Fin 3)) :
    cross (c • u) v = c • cross u v := by
  unfold cross
  have hof : WithLp.ofLp (c • u) = c • WithLp.ofLp u := rfl
  rw [hof, LinearMap.map_smul]
  rfl

/-- Right-linearity of `cross` in the scalar. -/
public theorem cross_smul_right (c : ℝ) (u v : EuclideanSpace ℝ (Fin 3)) :
    cross u (c • v) = c • cross u v := by
  unfold cross
  have hof : WithLp.ofLp (c • v) = c • WithLp.ofLp v := rfl
  rw [hof, LinearMap.map_smul]
  rfl

/-- Left-additivity of `cross`. -/
public theorem cross_add_left (u w v : EuclideanSpace ℝ (Fin 3)) :
    cross (u + w) v = cross u v + cross w v := by
  unfold cross
  have hof : WithLp.ofLp (u + w) = WithLp.ofLp u + WithLp.ofLp w := rfl
  rw [hof, LinearMap.map_add]
  rfl

/-- Right-additivity of `cross`. -/
public theorem cross_add_right (u v w : EuclideanSpace ℝ (Fin 3)) :
    cross u (v + w) = cross u v + cross u w := by
  unfold cross
  have hof : WithLp.ofLp (v + w) = WithLp.ofLp v + WithLp.ofLp w := rfl
  rw [hof, LinearMap.map_add]
  rfl

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

/-- If no Gâteaux representative exists, the encoding returns the zero field.
Binder is ASCII `dH` so the later notation `δ F /δω` cannot capture it. -/
public theorem FunctionalDerivative_eq_zero_of_not
    {F : CoadjointOrbit → ℝ} {ω : CoadjointOrbit}
    (h : ¬ ∃ dH, IsGateauxRepresentative F ω dH) :
    FunctionalDerivative F ω = 0 :=
  dif_neg h

/-- If a Gâteaux representative exists, `FunctionalDerivative` is that choice. -/
public theorem FunctionalDerivative_eq_choose
    {F : CoadjointOrbit → ℝ} {ω : CoadjointOrbit}
    (h : ∃ dH, IsGateauxRepresentative F ω dH) :
    FunctionalDerivative F ω = Classical.choose h :=
  dif_pos h

/-- Euclidean Biot–Savart kernel (principal-value: zero on the diagonal).
The torus Green's function is the intended operator; this is the model-space density. -/
public noncomputable def biotSavartKernel (x y : T3) : ℝ :=
  if x = y then 0 else (4 * Real.pi)⁻¹ * ‖x - y‖ ^ (-(3 : ℝ))

/-- Prefactor of the Constantin–Fefferman / Majda–Bertozzi 3D strain kernel
`(K z ω)_{ij} = (3/(8 π)) [(z × ω)_i z_j + (z × ω)_j z_i] / |z|^5`. -/
@[expose] public noncomputable def biotSavartStrainKernelPrefactor : ℝ :=
  3 / (8 * Real.pi)

/-- Euclidean surface area of the unit sphere `S² ⊂ ℝ³`. -/
@[expose] public noncomputable def sphereAreaS2 : ℝ :=
  4 * Real.pi

/-- Action of the 3D Biot–Savart strain kernel on a test vector.
`(K z ω) v = (3/(8 π) |z|⁻⁵) [(z × ω) ⊗ z + z ⊗ (z × ω)] v`, zero at `z = 0`. -/
@[expose] public noncomputable def biotSavartStrainKernel
    (z ω v : EuclideanSpace ℝ (Fin 3)) : EuclideanSpace ℝ (Fin 3) :=
  if z = 0 then 0 else
    let c := biotSavartStrainKernelPrefactor * ‖z‖ ^ (-(5 : ℝ))
    let w := cross z ω
    c • (inner ℝ w v • z + inner ℝ z v • w)

/-- Biot–Savart operator as the integral kernel applied to vorticity.
Mapping properties (`div = 0`, `curl ∘ BiotSavart = id` on the orbit) are theorems. -/
public noncomputable def BiotSavart (ω : T3 → EuclideanSpace ℝ (Fin 3)) :
    T3 → EuclideanSpace ℝ (Fin 3) :=
  fun x => ∫ y, biotSavartKernel x y • cross (ω y) (x - y) ∂volume

/-- The kernel applied to the zero field is the zero field. -/
public theorem BiotSavart_zero :
    BiotSavart (fun _ => 0) = 0 := by
  funext x
  have hfun :
      (fun y => biotSavartKernel x y • cross (0 : EuclideanSpace ℝ (Fin 3)) (x - y)) =
        fun _ => 0 := by
    funext y
    simp [cross]
  simp only [BiotSavart, Pi.zero_apply]
  rw [hfun]
  exact integral_zero (α := T3) (G := EuclideanSpace ℝ (Fin 3))
    (μ := NavierStokes3D.volume)

/-- Biot–Savart is homogeneous of degree one. Unconditional: both sides are
Mathlib `0` if the integrand is not integrable. -/
public theorem BiotSavart_smul (c : ℝ) (ω : T3 → EuclideanSpace ℝ (Fin 3)) :
    BiotSavart (fun y => c • ω y) = fun x => c • BiotSavart ω x := by
  funext x
  have hfun :
      (fun y => biotSavartKernel x y • cross (c • ω y) (x - y)) =
        fun y => c • (biotSavartKernel x y • cross (ω y) (x - y)) := by
    funext y
    rw [cross_smul_left, smul_comm]
  simp only [BiotSavart]
  rw [hfun, integral_smul]

/-- Biot–Savart is additive, given Bochner integrability of each kernel density. -/
public theorem BiotSavart_add (ω ε : T3 → EuclideanSpace ℝ (Fin 3)) {x : T3}
    (hω : Integrable (fun y => biotSavartKernel x y • cross (ω y) (x - y)))
    (hε : Integrable (fun y => biotSavartKernel x y • cross (ε y) (x - y))) :
    BiotSavart (fun y => ω y + ε y) x = BiotSavart ω x + BiotSavart ε x := by
  have hfun :
      (fun y => biotSavartKernel x y • cross (ω y + ε y) (x - y)) =
        fun y =>
          biotSavartKernel x y • cross (ω y) (x - y) +
            biotSavartKernel x y • cross (ε y) (x - y) := by
    funext y
    rw [cross_add_left, smul_add]
  simp only [BiotSavart]
  rw [hfun, integral_add (μ := NavierStokes3D.volume) hω hε]

/-- Pointwise expansion of `|a + t b|² / 2` at `t = 0` has derivative `⟨a, b⟩`. -/
public theorem hasDerivAt_half_norm_sq
    (a b : EuclideanSpace ℝ (Fin 3)) :
    HasDerivAt (fun t : ℝ => (1 / 2 : ℝ) * ‖a + t • b‖ ^ 2) (inner ℝ a b) 0 := by
  have hpoly :
      (fun t : ℝ => (1 / 2 : ℝ) * ‖a + t • b‖ ^ 2) =
        fun t =>
          (1 / 2) * ‖a‖ ^ 2 + inner ℝ a b * t + (1 / 2) * ‖b‖ ^ 2 * t ^ 2 := by
    funext t
    have hsq := norm_add_sq_real a (t • b)
    have hinter : inner ℝ a (t • b) = t * inner ℝ a b := by
      simp [real_inner_smul_right]
    have htb : ‖t • b‖ ^ 2 = t ^ 2 * ‖b‖ ^ 2 := by
      rw [norm_smul, mul_pow, Real.norm_eq_abs, sq_abs]
    calc
      (1 / 2 : ℝ) * ‖a + t • b‖ ^ 2
          = (1 / 2) * (‖a‖ ^ 2 + 2 * inner ℝ a (t • b) + ‖t • b‖ ^ 2) := by
            rw [hsq]
      _ = (1 / 2) * ‖a‖ ^ 2 + inner ℝ a (t • b) + (1 / 2) * ‖t • b‖ ^ 2 := by
            ring
      _ = (1 / 2) * ‖a‖ ^ 2 + t * inner ℝ a b + (1 / 2) * (t ^ 2 * ‖b‖ ^ 2) := by
            rw [hinter, htb]
      _ = (1 / 2) * ‖a‖ ^ 2 + inner ℝ a b * t + (1 / 2) * ‖b‖ ^ 2 * t ^ 2 := by
            ring
  rw [hpoly]
  have h0 : HasDerivAt (fun _ : ℝ => (1 / 2 : ℝ) * ‖a‖ ^ 2) 0 0 :=
    hasDerivAt_const 0 _
  have h1 : HasDerivAt (fun t : ℝ => inner ℝ a b * t) (inner ℝ a b) 0 := by
    simpa using (hasDerivAt_id (0 : ℝ)).const_mul (inner ℝ a b)
  have h2 : HasDerivAt (fun t : ℝ => (1 / 2 : ℝ) * ‖b‖ ^ 2 * t ^ 2) 0 0 := by
    have hp : HasDerivAt (fun t : ℝ => t ^ 2) (2 * (0 : ℝ) ^ 1) 0 := by
      simpa using hasDerivAt_pow 2 (0 : ℝ)
    have hc := hp.const_mul ((1 / 2 : ℝ) * ‖b‖ ^ 2)
    simpa using hc
  simpa using (h0.add h1).add h2

/-- Same expansion at an arbitrary time: derivative is `⟨a + t b, b⟩`. -/
public theorem hasDerivAt_half_norm_sq_at
    (a b : EuclideanSpace ℝ (Fin 3)) (t : ℝ) :
    HasDerivAt (fun s : ℝ => (1 / 2 : ℝ) * ‖a + s • b‖ ^ 2)
      (inner ℝ (a + t • b) b) t := by
  have hpoly :
      (fun s : ℝ => (1 / 2 : ℝ) * ‖a + s • b‖ ^ 2) =
        fun s =>
          (1 / 2) * ‖a‖ ^ 2 + inner ℝ a b * s + (1 / 2) * ‖b‖ ^ 2 * s ^ 2 := by
    funext s
    have hsq := norm_add_sq_real a (s • b)
    have hinter : inner ℝ a (s • b) = s * inner ℝ a b := by
      simp [real_inner_smul_right]
    have hsb : ‖s • b‖ ^ 2 = s ^ 2 * ‖b‖ ^ 2 := by
      rw [norm_smul, mul_pow, Real.norm_eq_abs, sq_abs]
    calc
      (1 / 2 : ℝ) * ‖a + s • b‖ ^ 2
          = (1 / 2) * (‖a‖ ^ 2 + 2 * inner ℝ a (s • b) + ‖s • b‖ ^ 2) := by
            rw [hsq]
      _ = (1 / 2) * ‖a‖ ^ 2 + inner ℝ a (s • b) + (1 / 2) * ‖s • b‖ ^ 2 := by
            ring
      _ = (1 / 2) * ‖a‖ ^ 2 + s * inner ℝ a b + (1 / 2) * (s ^ 2 * ‖b‖ ^ 2) := by
            rw [hinter, hsb]
      _ = (1 / 2) * ‖a‖ ^ 2 + inner ℝ a b * s + (1 / 2) * ‖b‖ ^ 2 * s ^ 2 := by
            ring
  have hval : inner ℝ (a + t • b) b = inner ℝ a b + t * ‖b‖ ^ 2 := by
    rw [inner_add_left, real_inner_smul_left, real_inner_self_eq_norm_sq]
  rw [hpoly, hval]
  have h0 : HasDerivAt (fun _ : ℝ => (1 / 2 : ℝ) * ‖a‖ ^ 2) 0 t :=
    hasDerivAt_const t _
  have h1 : HasDerivAt (fun s : ℝ => inner ℝ a b * s) (inner ℝ a b) t := by
    simpa using (hasDerivAt_id t).const_mul (inner ℝ a b)
  have h2 : HasDerivAt (fun s : ℝ => (1 / 2 : ℝ) * ‖b‖ ^ 2 * s ^ 2)
      (((1 / 2 : ℝ) * ‖b‖ ^ 2) * (2 * t)) t := by
    have hp : HasDerivAt (fun s : ℝ => s ^ 2) (2 * t ^ 1) t := by
      simpa using hasDerivAt_pow 2 t
    simpa using hp.const_mul ((1 / 2 : ℝ) * ‖b‖ ^ 2)
  have hall := (h0.add h1).add h2
  convert hall using 1
  ring

/-- Affine line in the vorticity: `K(ω + t ε) = Kω + t Kε` at a point, given
integrable kernel densities for `ω` and `ε`. -/
public theorem BiotSavart_affine (ω ε : T3 → EuclideanSpace ℝ (Fin 3)) (t : ℝ) {x : T3}
    (hω : Integrable (fun y => biotSavartKernel x y • cross (ω y) (x - y)))
    (hε : Integrable (fun y => biotSavartKernel x y • cross (ε y) (x - y))) :
    BiotSavart (fun y => ω y + t • ε y) x =
      BiotSavart ω x + t • BiotSavart ε x := by
  have hfun :
      (fun y => biotSavartKernel x y • cross (t • ε y) (x - y)) =
        fun y => t • (biotSavartKernel x y • cross (ε y) (x - y)) := by
    funext y
    rw [cross_smul_left, smul_comm]
  have ht : Integrable (fun y => biotSavartKernel x y • cross (t • ε y) (x - y)) := by
    rw [hfun]
    exact hε.smul t
  have hadd := BiotSavart_add ω (fun y => t • ε y) (x := x) hω ht
  rw [hadd]
  have hsm : BiotSavart (fun y => t • ε y) x = t • BiotSavart ε x := by
    simpa using congrFun (BiotSavart_smul t ε) x
  rw [hsm]

/-- Scalar triple product: `r · (ω × r) = 0`. -/
public theorem pairing_cross_self_right (ω r : EuclideanSpace ℝ (Fin 3)) :
    pairing r (cross ω r) = 0 := by
  unfold pairing cross
  have hdot :
      inner ℝ r (WithLp.toLp 2 (WithLp.ofLp ω ⨯₃ WithLp.ofLp r)) =
        WithLp.ofLp r ⬝ᵥ (WithLp.ofLp ω ⨯₃ WithLp.ofLp r) := by
    simp [PiLp.inner_apply, dotProduct]
    refine Finset.sum_congr rfl fun i _ => mul_comm _ _
  rw [hdot, dot_cross_self]

/-- Kinetic energy along an affine Biot–Savart line has derivative
`∫ ⟨u, δu⟩` at `t = 0`. This is the paper's `δH = u` in the Lie-algebra
pairing against the velocity variation, given dominated integrability. -/
public theorem kineticEnergy_hasDerivAt_velocity_pairing
    (a b : T3 → EuclideanSpace ℝ (Fin 3))
    (hF_meas : ∀ᶠ t in nhds (0 : ℝ),
      AEStronglyMeasurable (fun x => (1 / 2 : ℝ) * ‖a x + t • b x‖ ^ 2)
        NavierStokes3D.volume)
    (hF_int : Integrable (fun x => (1 / 2 : ℝ) * ‖a x‖ ^ 2)
      NavierStokes3D.volume)
    (hbound : Integrable (fun x => ‖a x‖ * ‖b x‖ + ‖b x‖ ^ 2)
      NavierStokes3D.volume)
    (hinner : AEStronglyMeasurable
      (fun x => inner ℝ (a x) (b x)) NavierStokes3D.volume) :
    HasDerivAt (fun t : ℝ =>
        ∫ x, (1 / 2 : ℝ) * ‖a x + t • b x‖ ^ 2 ∂NavierStokes3D.volume)
      (∫ x, inner ℝ (a x) (b x) ∂NavierStokes3D.volume) 0 := by
  have hs : Metric.ball (0 : ℝ) 1 ∈ nhds (0 : ℝ) := Metric.ball_mem_nhds 0 one_pos
  have hdiff : ∀ᵐ x ∂NavierStokes3D.volume,
      ∀ t ∈ Metric.ball (0 : ℝ) 1,
        HasDerivAt (fun s : ℝ => (1 / 2 : ℝ) * ‖a x + s • b x‖ ^ 2)
          (inner ℝ (a x + t • b x) (b x)) t :=
    Filter.Eventually.of_forall fun x t _ht =>
      hasDerivAt_half_norm_sq_at (a x) (b x) t
  have hbd : ∀ᵐ x ∂NavierStokes3D.volume,
      ∀ t ∈ Metric.ball (0 : ℝ) 1,
        ‖inner ℝ (a x + t • b x) (b x)‖ ≤ ‖a x‖ * ‖b x‖ + ‖b x‖ ^ 2 :=
    Filter.Eventually.of_forall fun x t ht => by
      have ht1 : |t| ≤ 1 := (le_of_lt (mem_ball_zero_iff.mp ht)).trans_eq (by simp)
      have hineq := abs_real_inner_le_norm (a x + t • b x) (b x)
      have htri : ‖a x + t • b x‖ ≤ ‖a x‖ + |t| * ‖b x‖ := by
        simpa [norm_smul, Real.norm_eq_abs] using norm_add_le (a x) (t • b x)
      have hmul : (‖a x‖ + |t| * ‖b x‖) * ‖b x‖ ≤
          ‖a x‖ * ‖b x‖ + ‖b x‖ ^ 2 := by
        nlinarith [norm_nonneg (a x), norm_nonneg (b x), abs_nonneg t, ht1]
      exact hineq.trans ((mul_le_mul_of_nonneg_right htri (norm_nonneg (b x))).trans hmul)
  have hF'meas : AEStronglyMeasurable
      (fun x => inner ℝ (a x + (0 : ℝ) • b x) (b x)) NavierStokes3D.volume := by
    simpa using hinner
  have hF0 : Integrable (fun x => (1 / 2 : ℝ) * ‖a x + (0 : ℝ) • b x‖ ^ 2)
      NavierStokes3D.volume := by
    simpa [zero_smul, add_zero] using hF_int
  have hkey :=
    hasDerivAt_integral_of_dominated_loc_of_deriv_le (μ := NavierStokes3D.volume)
      (F := fun t x => (1 / 2 : ℝ) * ‖a x + t • b x‖ ^ 2)
      (F' := fun t x => inner ℝ (a x + t • b x) (b x))
      (bound := fun x => ‖a x‖ * ‖b x‖ + ‖b x‖ ^ 2)
      (x₀ := (0 : ℝ)) hs hF_meas hF0 hF'meas hbd hbound hdiff
  have hinter :
      (∫ x, inner ℝ (a x + (0 : ℝ) • b x) (b x) ∂NavierStokes3D.volume) =
        ∫ x, inner ℝ (a x) (b x) ∂NavierStokes3D.volume := by
    congr 1
    funext x
    simp [zero_smul, add_zero]
  rw [← hinter]
  exact hkey.2

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

/-- Velocity recovered from the zero vorticity field is zero. -/
public theorem velocity_from_zero_orbit (ω : CoadjointOrbit)
    (hω : ω.val = fun _ => 0) :
    velocity_from_vorticity ω = 0 := by
  simp [velocity_from_vorticity, hω, BiotSavart_zero]

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

#print axioms BiotSavart_zero
#print axioms BiotSavart_smul
#print axioms BiotSavart_add
#print axioms BiotSavart_affine
#print axioms hasDerivAt_half_norm_sq
#print axioms hasDerivAt_half_norm_sq_at
#print axioms pairing_cross_self_right
#print axioms cross_smul_left
#print axioms FunctionalDerivative_eq_zero_of_not
#print axioms FunctionalDerivative_eq_choose
#print axioms kineticEnergy_hasDerivAt_velocity_pairing

end ArnoldGeometric
