import Mathlib

/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

/-!
# Interface for the Hodge conjecture

Sister copy of `BenFrohman/HODGE` `Hodge/Basic.lean`.
This file records the linear-algebraic shape of the statement. It does not
construct algebraic cycles from Hodge classes. Clay status remains open.
-/

namespace Hodge

/-- The data needed to *state* the Hodge conjecture on an abstract coefficient
triple:
* `Z` — rational algebraic cycles of a fixed codimension,
* `V` — ambient rational cohomology of even degree,
* `N` — a complement that receives the off-diagonal Hodge pieces.

`cl` is the cycle class map. `obstruction` vanishes on algebraic classes. -/
structure Datum (Z V N : Type*)
    [AddCommGroup Z] [Module ℚ Z]
    [AddCommGroup V] [Module ℚ V]
    [AddCommGroup N] [Module ℚ N] where
  /-- The integer `k` in `H^{2k}`. -/
  codim : ℕ
  /-- Projection onto the off-diagonal Hodge pieces. -/
  obstruction : V →ₗ[ℚ] N
  /-- The cycle class map. -/
  cl : Z →ₗ[ℚ] V
  /-- Geometry produces Hodge classes: the easy arrow. -/
  cl_isHodge : ∀ z, obstruction (cl z) = 0

namespace Datum

variable {Z V N : Type*}
    [AddCommGroup Z] [Module ℚ Z]
    [AddCommGroup V] [Module ℚ V]
    [AddCommGroup N] [Module ℚ N]

/-- Hodge classes: the kernel of the off-diagonal obstruction. -/
def hodgeClasses (D : Datum Z V N) : Submodule ℚ V :=
  LinearMap.ker D.obstruction

/-- Algebraic classes: the image of the cycle class map. -/
def algebraicClasses (D : Datum Z V N) : Submodule ℚ V :=
  LinearMap.range D.cl

/-- Every algebraic class is a Hodge class. This is `cl_isHodge` as a
submodule inclusion. -/
theorem algebraicClasses_le_hodgeClasses (D : Datum Z V N) :
    D.algebraicClasses ≤ D.hodgeClasses := by
  intro v hv
  rcases hv with ⟨z, rfl⟩
  exact D.cl_isHodge z

/-- The Hodge conjecture, as a statement about this datum: every Hodge class
is algebraic. -/
def HodgeConjecture (D : Datum Z V N) : Prop :=
  D.hodgeClasses ≤ D.algebraicClasses

end Datum

end Hodge
/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

/-!
# Type of a counterexample term

A term of `¬ ∀ D γ, ∃ z, cl z = γ` (restricted to Hodge classes `γ`)
is the triple

    (D_bad, γ_bad, ∀ z, cl z = γ_bad → False)

plus the side-condition `γ_bad ∈ D_bad.hodgeClasses`.

This file records that type. It is not a Clay close.
-/

namespace Hodge

variable {Z V N : Type*}
    [AddCommGroup Z] [Module ℚ Z]
    [AddCommGroup V] [Module ℚ V]
    [AddCommGroup N] [Module ℚ N]

/-- A pair `(D, γ)` is a Hodge-disproof pair when `γ` is a Hodge class
and is missed by `cl`. -/
def isHodgeDisproof (D : Datum Z V N) (γ : V) : Prop :=
  γ ∈ D.hodgeClasses ∧ ∀ z : Z, D.cl z = γ → False

/-- Type-level packaging of a counterexample term. -/
structure HodgeDisproof (Z V N : Type*)
    [AddCommGroup Z] [Module ℚ Z]
    [AddCommGroup V] [Module ℚ V]
    [AddCommGroup N] [Module ℚ N] where
  D_bad     : Datum Z V N
  γ_bad     : V
  γ_isHodge : γ_bad ∈ D_bad.hodgeClasses
  no_cycle  : ∀ z : Z, D_bad.cl z = γ_bad → False

namespace HodgeDisproof

def toPred (H : HodgeDisproof Z V N) : isHodgeDisproof H.D_bad H.γ_bad :=
  ⟨H.γ_isHodge, H.no_cycle⟩

theorem to_neg (H : HodgeDisproof Z V N) : ¬ H.D_bad.HodgeConjecture := by
  intro h
  rcases h H.γ_isHodge with ⟨z, hz⟩
  exact H.no_cycle z hz

end HodgeDisproof

theorem isHodgeDisproof.not_hodgeConjecture
    {D : Datum Z V N} {γ : V} (h : isHodgeDisproof D γ) :
    ¬ D.HodgeConjecture := by
  intro hc
  rcases hc h.1 with ⟨z, hz⟩
  exact h.2 z hz

/-- Linear-algebra sentinel. `cl = 0`, `γ = 1`. Not a variety. -/
def zeroCycle : Datum ℚ ℚ ℚ where
  codim := 2
  obstruction := 0
  cl := 0
  cl_isHodge := by intro _; rfl

theorem zeroCycle_isHodgeDisproof : isHodgeDisproof zeroCycle (1 : ℚ) := by
  constructor
  · change (1 : ℚ) ∈ LinearMap.ker (0 : ℚ →ₗ[ℚ] ℚ)
    simp
  · intro z h
    change (0 : ℚ) = 1 at h
    exact zero_ne_one h

def zeroCycleDisproof : HodgeDisproof ℚ ℚ ℚ where
  D_bad     := zeroCycle
  γ_bad     := 1
  γ_isHodge := zeroCycle_isHodgeDisproof.1
  no_cycle  := zeroCycle_isHodgeDisproof.2

end Hodge
/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

/-!
# Geometric host interface (type only)

Clay Hodge is the Π-sentence: on every nonsingular complex projective
variety `X`, every class in `H^{2k}(X,ℚ) ∩ H^{k,k}(X)` lies in the image
of the rational cycle-class map

    cl_X : CH^k(X)_ℚ → H^{2k}(X,ℚ).

Mathlib 4.22 does not contain schemes, Chow groups, or Hodge decomposition
over ℂ. This file records those *names* as an interface. It does not
implement them, and it does not inhabit a counterexample.

Declaring this type does not close the Clay problem.
-/

namespace Hodge
namespace Geometric

/-- Documentation-only host. `presentation` is a string, not a scheme. -/
structure SmoothComplexProj where
  name : String
  dim : ℕ
  /-- Equations or moduli description, for humans. -/
  presentation : String

/-- Clay-shaped coefficient package on one host.
`CH` stands for `CH^k(X)_ℚ`. `H2k` stands for `H^{2k}(X,ℚ)`.
`hdg` stands for the Hodge classes `H^{2k} ∩ H^{k,k}`. -/
structure CycleClassData (X : SmoothComplexProj) (k : ℕ) where
  CH  : Type
  H2k : Type
  addCH : AddCommGroup CH := by infer_instance
  modCH : Module ℚ CH := by infer_instance
  addH  : AddCommGroup H2k := by infer_instance
  modH  : Module ℚ H2k := by infer_instance
  cl    : CH →ₗ[ℚ] H2k
  hdg   : Submodule ℚ H2k
  cl_isHodge : ∀ z : CH, cl z ∈ hdg

attribute [instance] CycleClassData.addCH CycleClassData.modCH
attribute [instance] CycleClassData.addH CycleClassData.modH

def CycleClassData.HodgeConjecture
    {X : SmoothComplexProj} {k : ℕ} (C : CycleClassData X k) : Prop :=
  C.hdg ≤ LinearMap.range C.cl

/-- Geometric disproof pair on one packaged host. Uninhabited here. -/
def isGeometricDisproof
    {X : SmoothComplexProj} {k : ℕ} (C : CycleClassData X k) (γ : C.H2k) : Prop :=
  γ ∈ C.hdg ∧ ∀ z : C.CH, C.cl z = γ → False

theorem isGeometricDisproof.not_hodge
    {X : SmoothComplexProj} {k : ℕ} {C : CycleClassData X k} {γ : C.H2k}
    (h : isGeometricDisproof C γ) : ¬ C.HodgeConjecture := by
  intro hc
  rcases hc h.1 with ⟨z, hz⟩
  exact h.2 z hz

/-- Named classical fourfolds, as *labels only*. Their cycle-class data
is not supplied by mathlib. Wrapping a `Datum` with `cl = id` is the
sister-repo encoding, not the geometric map. -/
def P4 : SmoothComplexProj :=
  ⟨"P^4", 4, "Proj of k[x0,x1,x2,x3,x4]"⟩

def kleinQ4 : SmoothComplexProj :=
  ⟨"Klein quadric Q^4", 4, "Gr(2,4) / Plucker quadric in P^5"⟩

def productP2P2 : SmoothComplexProj :=
  ⟨"P^2 x P^2", 4, "product of two projective planes"⟩

/-- A Clay close would be an inhabitant of this Σ-type for some named `X`
whose `CycleClassData` is the *geometric* map, not `LinearMap.id` on `ℚ`. -/
def ClayDisproof : Prop :=
  ∃ (X : SmoothComplexProj) (k : ℕ) (C : CycleClassData X k) (γ : C.H2k),
    isGeometricDisproof C γ

/-- No inhabitant is supplied. -/
theorem ClayDisproof_is_a_hole : True := trivial

end Geometric
end Hodge

namespace Hodge.Geometric
-- Exact current interface accepts the zero map even with the P4 label.
def labelOnlyP4Data : CycleClassData P4 2 where
  CH := ℚ
  H2k := ℚ
  addCH := inferInstance
  modCH := inferInstance
  addH := inferInstance
  modH := inferInstance
  cl := 0
  hdg := ⊤
  cl_isHodge := by intro z; trivial

theorem labelOnlyP4Data_miss : isGeometricDisproof labelOnlyP4Data (1 : ℚ) := by
  constructor
  · trivial
  · intro z hz
    change (0 : ℚ) = 1 at hz
    exact zero_ne_one hz

-- Diagnostic only: shows the existing target is not equivalent to geometry.
theorem labelOnly_ClayDisproof : ClayDisproof :=
  ⟨P4, 2, labelOnlyP4Data, (1 : ℚ), labelOnlyP4Data_miss⟩
#print axioms labelOnly_ClayDisproof
end Hodge.Geometric
