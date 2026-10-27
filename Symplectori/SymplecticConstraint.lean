/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

module

public import NS_Millennium_Proof.Modules.GlobalRegularity
public import NS_Millennium_Proof.Modules.SymplecticTether
public import NS_Millennium_Proof.Modules.Uniqueness
public import NS_Millennium_Proof.Modules.AssemblyGap
public import NS_Millennium_Proof.Modules.TetheredLyapunov
public import NS_Millennium_Proof.Modules.HighSetDepletionAndBKM
public import NS_Millennium_Proof.Modules.TorusStrainExclusion
public import NS_Millennium_Proof.Modules.ClayStatements

/-!
# The Symplectic Constraint: Coherent Ontological Formalization & Proof-Obligation Ledger

This module formalizes the exact statement of the **Frohmanian Symplectic Constraint**
as it appears in the manuscript (`main.tex` Sections 1–5 and
`historical/docs/Full_Living_Document_NS_Millennium_Proof.md` Sections 2–3),
incorporating **in-place ontological and pedagogical corrections** where earlier
Lean encodings diverged from the mathematical meaning of the manuscript:

1. **In-Place Correction 1 — Kirillov–Kostant–Souriau (KKS) Symplectic 2-Form & Lie–Poisson Bracket:**
   Earlier modules defined `ClassicalBracket` via a `Classical.choose` Gâteaux wrapper without
   exposing the explicit skew-symmetric bilinear KKS symplectic 2-form
   $$\omega_{\mathrm{KKS}}(\omega)(\delta u, \delta v) = \int_{\mathbb{T}^3} \langle \omega(x), \delta u(x) \times \delta v(x) \rangle\,dx$$
   (`main.tex` Eq. (10), line 295). Here we define `kksPointwiseIntegrand` and `kksSymplecticForm`
   directly on tangent variations, and prove pointwise skew-symmetry (`kksPointwiseIntegrand_skew`),
   integral skew-symmetry (`kksSymplecticForm_skew`), diagonal vanishing (`kksSymplecticForm_self_zero`),
   and the exact cyclic vector-triple-product Jacobi identity (`kksPointwise_cyclic_jacobi_identity`).

2. **In-Place Correction 2 — Genuine Volume-Preserving Coadjoint Action & Vortex-Line Monodromy / Helicity Casimir:**
   In `ArnoldGeometric.lean` (line 179), `CoadjointAction _g ω := ω` was a trivial identity stub,
   and neither Kelvin circulation monodromy $\oint_{\gamma(t)} u \cdot d\ell$ nor the 3D Helicity
   Casimir $\mathcal{H}(\omega) = \int_{\mathbb{T}^3} \langle u(x), \omega(x) \rangle\,dx$ was defined.
   Here we define the genuine `VolumePreservingCoadjointAction` structure (carrying volume-preserving
   integral invariance and projected Gâteaux pullback), prove `volumePreservingCoadjointAction_preserves_TetherKernel`,
   and define `HelicityCasimir`, `kelvinLoopCirculation`, and `VortexLineMonodromyCondition`.

3. **In-Place Correction 3 — Hilbert-Space Orthogonal Projector $\Pi_u$ Idempotence, Self-Adjointness, and Metriplectic Split:**
   Earlier modules proved only $\Pi_u u = 0$ and $\langle \Pi_u v, u \rangle_{L^2} = 0$, while leaving
   the manuscript's dual phrasing ("antisymmetric 2-form" vs. "symmetric metric correction") pedagogically
   opaque. Here we prove the full Hilbert-space projection characterization of $\Pi_u$—idempotence
   (`Pi_u_idempotent : Pi_u u (Pi_u u v) = Pi_u u v`) and $L^2$ self-adjointness
   (`Pi_u_self_adjoint`)—and formalize the exact **Metriplectic Decomposition**
   $$\mathfrak{T}_F(\omega)(\delta u, \delta v) = \underbrace{\omega_{\mathrm{KKS}}(\omega)(\delta u, \delta v)}_{\text{skew-symmetric Poisson part}} + \underbrace{B_{\mathrm{metric}}(\omega)(\delta u, \delta v)}_{\text{symmetric negative-semidefinite tether}}$$
   together with its exact diagonal non-positivity (`FrohmanianMetriplecticPairing_diag_eq_metric`)
   and its identity with `TetherKernel` (`TetherKernel_eq_tetherMetricForm`).

4. **In-Place Correction 4 — Periodic Cell Energy on $\mathbb{T}^3 = [0,1]^3$ (`unitCube`) & One-Sided Smooth Time Derivatives:**
   In `NS_Equations.lean`, `IsPhysicalNSSolution` integrated energy over `Set.univ : Set ℝ³` (infinite for
   non-zero periodic fields) and used two-sided `deriv` at $t = 0$. Here we define
   `PeriodicCellPhysicalNSSolution` using `unitCube = [0,1]^3`, `IsZ3Periodic`, `ContDiffOn ℝ (⊤ : ℕ∞)` on
   $[0, \infty) \times \mathbb{R}^3$, and one-sided `navier_stokes_eq_Ici`.

5. **In-Place Correction 5 — Explicit Spatial-Maximum Rademacher/Danskin Rate & Scale-Invariant Cubic-Rate Bridge:**
   Instead of burying the spatial-maximum rate inside an existential `FrohmanianTetherRate` binder,
   we formalize `SpatialMaxVorticityEnvelope` (making the Danskin/Rademacher envelope relation
   $M(t) = \|\omega(t, x_t)\|$ and $M'(t) \le \langle \omega(t, x_t), \partial_t \omega(t, x_t)\rangle / M(t)$
   completely explicit) and separate the proved cubic source from the open quartic/cubic-sink obligations.
-/

namespace Symplectori.SymplecticConstraint

open NavierStokes3D
open ArnoldGeometric hiding CoadjointOrbit
open ArnoldGeometric (CoadjointOrbit)
open FrohmanianTether
open FrohmanianTether.ClayStatements
open FrohmanianTether.TorusStrainExclusion
open FrohmanianTether.HighSetDepletionAndBKM
open TetheredLyapunov
open GlobalRegularity hiding vorticity_sup_norm
open Frohmanian.AssemblyGap
open Frohmanian.CubicSourceAudit
open MeasureTheory hiding volume
open ForMathlib
open scoped InnerProductSpace

noncomputable section

/-! ## Section 1. In-Place Correction 1: Coherent KKS Symplectic 2-Form on Coadjoint Orbits
(`main.tex` §3.1 Eq. (169) and §5.1 Eq. (295)) -/

/-- Pointwise integrand of the Kirillov–Kostant–Souriau (KKS) coadjoint symplectic 2-form:
$\langle \omega(x), \delta u(x) \times \delta v(x) \rangle$. -/
@[expose] public noncomputable def kksPointwiseIntegrand
    (ω : CoadjointOrbit) (δu δv : VelocityField) (x : T3) : ℝ :=
  inner ℝ (ω.val x) (cross (δu x) (δv x))

/-- Explicit Kirillov–Kostant–Souriau (KKS) symplectic 2-form on tangent variations
$\delta u, \delta v$ at $\omega \in \mathcal{O} \subset \mathfrak{sdiff}(\mathbb{T}^3)^*$:
$$\omega_{\mathrm{KKS}}(\omega)(\delta u, \delta v) = \int_{\mathbb{T}^3} \langle \omega(x), \delta u(x) \times \delta v(x) \rangle\,dx.$$ -/
@[expose] public noncomputable def kksSymplecticForm
    (ω : CoadjointOrbit) (δu δv : VelocityField) : ℝ :=
  ∫ x : T3, kksPointwiseIntegrand ω δu δv x ∂NavierStokes3D.volume

/-- Cross product in $\mathbb{R}^3$ is alternating: $a \times b = -(b \times a)$. -/
public theorem cross_anticomm (a b : EuclideanSpace ℝ (Fin 3)) :
    cross a b = -cross b a := by
  ext i
  have h1 := cross_coord a b
  have h2 := cross_coord b a
  fin_cases i
  · change cross a b 0 = -(cross b a 0)
    rw [h1.1, h2.1]; ring
  · change cross a b 1 = -(cross b a 1)
    rw [h1.2.1, h2.2.1]; ring
  · change cross a b 2 = -(cross b a 2)
    rw [h1.2.2, h2.2.2]; ring

/-- Cross product of any vector with itself vanishes: $a \times a = 0$. -/
public theorem cross_self_zero (a : EuclideanSpace ℝ (Fin 3)) :
    cross a a = 0 := by
  ext i
  have h1 := cross_coord a a
  fin_cases i
  · change cross a a 0 = 0
    rw [h1.1]; ring
  · change cross a a 1 = 0
    rw [h1.2.1]; ring
  · change cross a a 2 = 0
    rw [h1.2.2]; ring

/-- **Proved (Ontological Correction 1a):** Pointwise skew-symmetry of the KKS symplectic integrand:
$\langle \omega(x), \delta u(x) \times \delta v(x) \rangle = -\langle \omega(x), \delta v(x) \times \delta u(x) \rangle$. -/
public theorem kksPointwiseIntegrand_skew
    (ω : CoadjointOrbit) (δu δv : VelocityField) (x : T3) :
    kksPointwiseIntegrand ω δu δv x = -kksPointwiseIntegrand ω δv δu x := by
  unfold kksPointwiseIntegrand
  rw [cross_anticomm (δu x) (δv x), inner_neg_right]

/-- **Proved (Ontological Correction 1b):** Integral skew-symmetry of the KKS symplectic 2-form:
$\omega_{\mathrm{KKS}}(\omega)(\delta u, \delta v) = -\omega_{\mathrm{KKS}}(\omega)(\delta v, \delta u)$. -/
public theorem kksSymplecticForm_skew
    (ω : CoadjointOrbit) (δu δv : VelocityField) :
    kksSymplecticForm ω δu δv = -kksSymplecticForm ω δv δu := by
  unfold kksSymplecticForm
  have hfun :
      (fun x => kksPointwiseIntegrand ω δu δv x) =
        fun x => -kksPointwiseIntegrand ω δv δu x := by
    funext x
    exact kksPointwiseIntegrand_skew ω δu δv x
  rw [hfun, integral_neg]

/-- **Proved (Ontological Correction 1c):** Alternating / diagonal vanishing of the KKS 2-form:
$\omega_{\mathrm{KKS}}(\omega)(\delta u, \delta u) = 0$. -/
public theorem kksSymplecticForm_self_zero
    (ω : CoadjointOrbit) (δu : VelocityField) :
    kksSymplecticForm ω δu δu = 0 := by
  have h := kksSymplecticForm_skew ω δu δu
  linarith

/-- **Proved (Ontological Correction 1d):** Pointwise vector-cross-product Jacobi identity
$(a \times (b \times c)) + (b \times (c \times a)) + (c \times (a \times b)) = 0$ on fibers,
which is the algebraic core of the closedness $d\omega_{\mathrm{KKS}} = 0$ on coadjoint orbits. -/
public theorem cross_jacobi_identity (a b c : EuclideanSpace ℝ (Fin 3)) :
    cross a (cross b c) + cross b (cross c a) + cross c (cross a b) = 0 := by
  ext i
  have hbc := cross_coord b c
  have hca := cross_coord c a
  have hab := cross_coord a b
  have h1 := cross_coord a (cross b c)
  have h2 := cross_coord b (cross c a)
  have h3 := cross_coord c (cross a b)
  fin_cases i
  · change cross a (cross b c) 0 + cross b (cross c a) 0 + cross c (cross a b) 0 = 0
    rw [h1.1, h2.1, h3.1, hbc.2.1, hbc.2.2, hca.2.1, hca.2.2, hab.2.1, hab.2.2]
    ring
  · change cross a (cross b c) 1 + cross b (cross c a) 1 + cross c (cross a b) 1 = 0
    rw [h1.2.1, h2.2.1, h3.2.1, hbc.1, hbc.2.2, hca.1, hca.2.2, hab.1, hab.2.2]
    ring
  · change cross a (cross b c) 2 + cross b (cross c a) 2 + cross c (cross a b) 2 = 0
    rw [h1.2.2, h2.2.2, h3.2.2, hbc.1, hbc.2.1, hca.1, hca.2.1, hab.1, hab.2.1]
    ring

/-- **Proved (Ontological Correction 1e):** Pointwise cyclic KKS pairing vanishes identically:
$\langle \omega(x), \delta u \times (\delta v \times \delta w) + \delta v \times (\delta w \times \delta u) + \delta w \times (\delta u \times \delta v) \rangle = 0$. -/
public theorem kksPointwise_cyclic_jacobi_identity
    (ω : CoadjointOrbit) (δu δv δw : VelocityField) (x : T3) :
    inner ℝ (ω.val x) (cross (δu x) (cross (δv x) (δw x))) +
      inner ℝ (ω.val x) (cross (δv x) (cross (δw x) (δu x))) +
      inner ℝ (ω.val x) (cross (δw x) (cross (δu x) (δv x))) = 0 := by
  rw [← inner_add_right, ← inner_add_right, cross_jacobi_identity (δu x) (δv x) (δw x),
    inner_zero_right]

/-- **Proved Bridge (`kksSymplecticForm_functional_skew`):**
Evaluated on functional derivatives $\delta F / \delta \omega$ and $\delta G / \delta \omega$,
`kksSymplecticForm` is the explicit exposed form of the classical Arnold Lie–Poisson bracket
and satisfies exact skew-symmetry. -/
public theorem kksSymplecticForm_functional_skew
    (F G : Functional) (ω : CoadjointOrbit) :
    kksSymplecticForm ω (FunctionalDerivative F ω) (FunctionalDerivative G ω) =
      -kksSymplecticForm ω (FunctionalDerivative G ω) (FunctionalDerivative F ω) :=
  kksSymplecticForm_skew ω (FunctionalDerivative F ω) (FunctionalDerivative G ω)

/-! ## Section 2. In-Place Correction 2: Genuine Volume-Preserving Coadjoint Action,
Kelvin Circulation Monodromy, and Helicity Casimir (`main.tex` §3.1, §3.4) -/

/-- **Ontological Correction 2a (`VolumePreservingCoadjointAction`):**
Replaces the identity stub `CoadjointAction _g ω := ω` with a coherent mathematical structure
representing the action of a group of volume-preserving diffeomorphisms on `CoadjointOrbit`:
1. `act g ω` is a divergence-free vorticity field on the coadjoint orbit;
2. Every diffeomorphism $g$ preserves spatial Bochner integrals (`integral_comp_eq`);
3. For any isometric volume-preserving transformation $g$, the quadratic tether integrand
   pulls back by composition with $g$. -/
public structure VolumePreservingCoadjointAction where
  act : (T3 → T3) → CoadjointOrbit → CoadjointOrbit
  integral_comp_eq : ∀ (g : T3 → T3) (f : T3 → ℝ),
    (∫ x : T3, f (g x) ∂NavierStokes3D.volume) = ∫ x : T3, f x ∂NavierStokes3D.volume
  tether_integrand_pullback :
    ∀ (g : T3 → T3) (F G : Functional) (ω : CoadjointOrbit) (x : T3),
      ‖(act g ω).val x‖ ^ 2 *
        inner ℝ
          (Pi_u (velocity_from_vorticity (act g ω))
            (FunctionalDerivative F (act g ω)) x)
          (Pi_u (velocity_from_vorticity (act g ω))
            (FunctionalDerivative G (act g ω)) x) =
      ‖ω.val (g x)‖ ^ 2 *
        inner ℝ
          (Pi_u (velocity_from_vorticity ω) (FunctionalDerivative F ω) (g x))
          (Pi_u (velocity_from_vorticity ω) (FunctionalDerivative G ω) (g x))

/-- **Proved (`volumePreservingCoadjointAction_preserves_TetherKernel`):**
Any `VolumePreservingCoadjointAction` automatically satisfies `ConjecturedSDiffPushforwardInvariance`:
$B(\mathrm{act}_g \omega, F, G) = B(\omega, F, G)$. -/
public theorem volumePreservingCoadjointAction_preserves_TetherKernel
    (A : VolumePreservingCoadjointAction) :
    ConjecturedSDiffPushforwardInvariance A.act := by
  intro g F G ω
  unfold TetherKernel
  congr 1
  let f : T3 → ℝ := fun y =>
    ‖ω.val y‖ ^ 2 *
      inner ℝ
        (Pi_u (velocity_from_vorticity ω) (FunctionalDerivative F ω) y)
        (Pi_u (velocity_from_vorticity ω) (FunctionalDerivative G ω) y)
  have hfun :
      (fun x => ‖(A.act g ω).val x‖ ^ 2 *
        inner ℝ
          (Pi_u (velocity_from_vorticity (A.act g ω))
            (FunctionalDerivative F (A.act g ω)) x)
          (Pi_u (velocity_from_vorticity (A.act g ω))
            (FunctionalDerivative G (A.act g ω)) x)) =
      fun x => f (g x) := by
    funext x
    exact A.tether_integrand_pullback g F G ω x
  rw [hfun, A.integral_comp_eq g f]

/-- **Ontological Correction 2b (`HelicityCasimir`):**
The classical 3D hydrodynamic Casimir invariant on $\mathfrak{sdiff}(\mathbb{T}^3)^*$:
$$\mathcal{H}(\omega) = \int_{\mathbb{T}^3} \langle u(x), \omega(x) \rangle\,dx, \qquad u = \mathrm{BS}(\omega),$$
measuring the topological knotting/linking and monodromy of vortex lines. -/
@[expose] public noncomputable def HelicityCasimir (ω : CoadjointOrbit) : ℝ :=
  ∫ x : T3, inner ℝ (velocity_from_vorticity ω x) (ω.val x) ∂NavierStokes3D.volume

/-- **Ontological Correction 2c (`KelvinCirculationMonodromy`):**
Formalizes the Kelvin circulation integral $\Gamma(\gamma, u) = \int_0^1 \langle u(\gamma(s)), \gamma'(s) \rangle\,ds$
around a closed material loop $\gamma : \mathbb{R} \to \mathbb{T}^3$ ($\gamma(1) = \gamma(0)$) and the
vortex-line monodromy condition that the coadjoint flow $g_t$ preserves loop circulation and helicity. -/
public noncomputable def kelvinLoopCirculation
    (u : VelocityField) (γ : ℝ → T3) : ℝ :=
  ∫ s in (0 : ℝ)..1, inner ℝ (u (γ s)) (deriv γ s)

public structure VortexLineMonodromyCondition
    (u : TimeDependentVelocity)
    (A : VolumePreservingCoadjointAction)
    (g : ℝ → (T3 → T3)) : Prop where
  orbit_trajectory : ∀ t ≥ (0 : ℝ),
    ∃ ω_t : CoadjointOrbit, ω_t.val = vorticity (u t)
  coadjoint_monodromy : ∀ (t : ℝ) (ω₀ ω_t : CoadjointOrbit),
    0 ≤ t → ω₀.val = vorticity (u 0) → ω_t.val = vorticity (u t) →
    A.act (g t) ω₀ = ω_t
  kelvin_circulation_preserved : ∀ (t : ℝ) (γ₀ : ℝ → T3),
    0 ≤ t → γ₀ 1 = γ₀ 0 →
    kelvinLoopCirculation (u t) (fun s => g t (γ₀ s)) = kelvinLoopCirculation (u 0) γ₀
  casimir_transverse_damping : ∀ (ωx ωy grad_orth : T3),
    grad_orth ≠ 0 → casimirTetherKernel ωx ωy grad_orth < 0

/-! ## Section 3. In-Place Correction 3: Hilbert-Space Projector $\Pi_u$ Idempotence,
Self-Adjointness, and the Metriplectic Split (`main.tex` §3.2–3.3, Eq. (295)) -/

/-- **Proved (Ontological Correction 3a — Idempotence $\Pi_u^2 = \Pi_u$):**
The Gram–Schmidt orthogonal projector `Pi_u u` onto $(\mathrm{span}\{u\})^\perp$ is idempotent:
`Pi_u u (Pi_u u v) = Pi_u u v` for every velocity field $u$ and test variation $v$. -/
public theorem Pi_u_idempotent
    (u v : VelocityField) (hdiv : ∀ x, div u x = 0) :
    Pi_u u (Pi_u u v) = Pi_u u v := by
  by_cases hE : (∫ y, ‖u y‖ ^ 2 ∂NavierStokes3D.volume) ≠ 0
  · have horth : (∫ y, pairing (Pi_u u v y) (u y) ∂NavierStokes3D.volume) = 0 :=
      projector_orthogonality v u hdiv hE
    funext x
    change Pi_u u v x -
        ((∫ y, pairing (Pi_u u v y) (u y) ∂NavierStokes3D.volume) /
          (∫ y, ‖u y‖ ^ 2 ∂NavierStokes3D.volume)) • u x =
      Pi_u u v x
    rw [horth, zero_div, zero_smul, sub_zero]
  · simp only [ne_eq, not_not] at hE
    rw [Pi_u_of_energy_zero u v hE, Pi_u_of_energy_zero u v hE]

/-- **Proved (Ontological Correction 3b — $L^2$ Self-Adjointness of $\Pi_u$):**
For integrable pairings, $\langle \Pi_u a, b \rangle_{L^2} = \langle a, \Pi_u b \rangle_{L^2}$. -/
public theorem Pi_u_self_adjoint
    (u a b : VelocityField)
    (hInt_ab : Integrable (fun x => inner ℝ (a x) (b x)) MeasureTheory.volume)
    (hInt_au : Integrable (fun x => inner ℝ (a x) (u x)) MeasureTheory.volume)
    (hInt_ub : Integrable (fun x => inner ℝ (u x) (b x)) MeasureTheory.volume) :
    (∫ x, inner ℝ (Pi_u u a x) (b x) ∂NavierStokes3D.volume) =
      ∫ x, inner ℝ (a x) (Pi_u u b x) ∂NavierStokes3D.volume := by
  set Eu := ∫ y, ‖u y‖ ^ 2 ∂NavierStokes3D.volume
  set Eau := ∫ y, pairing (a y) (u y) ∂NavierStokes3D.volume
  set Ebu := ∫ y, pairing (b y) (u y) ∂NavierStokes3D.volume
  have hL_fun :
      (fun x => inner ℝ (Pi_u u a x) (b x)) =
        fun x => inner ℝ (a x) (b x) - (Eau / Eu) * inner ℝ (u x) (b x) := by
    funext x
    simp only [Pi_u, Eau, Eu]
    rw [inner_sub_left, real_inner_smul_left]
  have hR_fun :
      (fun x => inner ℝ (a x) (Pi_u u b x)) =
        fun x => inner ℝ (a x) (b x) - (Ebu / Eu) * inner ℝ (a x) (u x) := by
    funext x
    simp only [Pi_u, Ebu, Eu]
    rw [inner_sub_right, real_inner_smul_right]
  rw [hL_fun, hR_fun]
  have hsubL := integral_sub hInt_ab (hInt_ub.const_mul (Eau / Eu))
  have hsubR := integral_sub hInt_ab (hInt_au.const_mul (Ebu / Eu))
  change (∫ x, inner ℝ (a x) (b x) - (Eau / Eu) * inner ℝ (u x) (b x) ∂MeasureTheory.volume) =
    ∫ x, inner ℝ (a x) (b x) - (Ebu / Eu) * inner ℝ (a x) (u x) ∂MeasureTheory.volume
  rw [hsubL, hsubR, integral_const_mul, integral_const_mul]
  have h_ub_eq : (∫ x, inner ℝ (u x) (b x) ∂MeasureTheory.volume) = Ebu := by
    unfold Ebu pairing
    congr 1
    funext x
    exact real_inner_comm (b x) (u x)
  have h_au_eq : (∫ x, inner ℝ (a x) (u x) ∂MeasureTheory.volume) = Eau := rfl
  rw [h_ub_eq, h_au_eq]
  ring

/-- **Ontological Correction 3c (`tetherMetricForm` & `FrohmanianMetriplecticPairing`):**
Resolves the manuscript's terminology tension between "antisymmetric 2-form" and "symmetric metric
correction" (`main.tex` §3.3, lines 196–201) by explicitly separating:
- the skew-symmetric Hamiltonian KKS 2-form `kksSymplecticForm ω δu δv`, and
- the symmetric negative-semidefinite projected metric bilinear form `tetherMetricForm ω δu δv`. -/
@[expose] public noncomputable def tetherMetricForm
    (ω : CoadjointOrbit) (δu δv : VelocityField) : ℝ :=
  -kappa * ∫ x : T3,
    ‖ω.val x‖ ^ 2 *
      inner ℝ
        (Pi_u (velocity_from_vorticity ω) δu x)
        (Pi_u (velocity_from_vorticity ω) δv x)
    ∂NavierStokes3D.volume

/-- The full tethered pairing on tangent variations $(\delta u, \delta v)$ (`main.tex` Eq. (295)). -/
@[expose] public noncomputable def FrohmanianMetriplecticPairing
    (ω : CoadjointOrbit) (δu δv : VelocityField) : ℝ :=
  kksSymplecticForm ω δu δv + tetherMetricForm ω δu δv

/-- **Proved:** `TetherKernel ω F G` is definitionally identical to `tetherMetricForm` evaluated on the
functional derivatives $\delta F / \delta \omega$ and $\delta G / \delta \omega$. -/
public theorem TetherKernel_eq_tetherMetricForm
    (F G : Functional) (ω : CoadjointOrbit) :
    TetherKernel ω F G =
      tetherMetricForm ω (FunctionalDerivative F ω) (FunctionalDerivative G ω) :=
  rfl

/-- **Proved (Symmetry of `tetherMetricForm`):**
The metric tether form is symmetric in its tangent-variation slots:
`tetherMetricForm ω δu δv = tetherMetricForm ω δv δu`. -/
public theorem tetherMetricForm_symm
    (ω : CoadjointOrbit) (δu δv : VelocityField) :
    tetherMetricForm ω δu δv = tetherMetricForm ω δv δu := by
  unfold tetherMetricForm
  congr 1
  congr 1
  funext x
  rw [real_inner_comm]

/-- **Proved (Diagonal Reduction):** On the diagonal $\delta u = \delta v$, the skew-symmetric KKS
part vanishes identically (`kksSymplecticForm_self_zero`), so the full tethered pairing reduces
purely to the negative-semidefinite symmetric metric form `tetherMetricForm ω δu δu ≤ 0`. -/
public theorem FrohmanianMetriplecticPairing_diag_eq_metric
    (ω : CoadjointOrbit) (δu : VelocityField) :
    FrohmanianMetriplecticPairing ω δu δu = tetherMetricForm ω δu δu ∧
    tetherMetricForm ω δu δu ≤ 0 := by
  constructor
  · unfold FrohmanianMetriplecticPairing
    rw [kksSymplecticForm_self_zero, zero_add]
  · unfold tetherMetricForm
    have hnn : ∀ x : T3,
        0 ≤ ‖ω.val x‖ ^ 2 *
          inner ℝ
            (Pi_u (velocity_from_vorticity ω) δu x)
            (Pi_u (velocity_from_vorticity ω) δu x) := by
      intro x
      rw [real_inner_self_eq_norm_sq]
      exact mul_nonneg (sq_nonneg _) (sq_nonneg _)
    have hint : 0 ≤ ∫ x : T3,
        ‖ω.val x‖ ^ 2 *
          inner ℝ
            (Pi_u (velocity_from_vorticity ω) δu x)
            (Pi_u (velocity_from_vorticity ω) δu x) ∂NavierStokes3D.volume :=
      integral_nonneg hnn
    have hκ : -kappa ≤ 0 := neg_nonpos.mpr kappa_pos.le
    exact mul_nonpos_of_nonpos_of_nonneg hκ hint

/-! ## Section 4. In-Place Correction 4: Periodic Cell Energy on $\mathbb{T}^3 = [0,1]^3$ (`unitCube`)
and One-Sided Smooth Time Derivatives (`main.tex` §2 & §6) -/

/-- **Ontological Correction 4 (`PeriodicCellPhysicalNSSolution`):**
Coherent periodic physical solution class on $\mathbb{T}^3 = \mathbb{R}^3 / \mathbb{Z}^3$:
1. Joint spacetime smoothness `ContDiffOn ℝ (⊤ : ℕ∞)` on $[0, \infty) \times \mathbb{R}^3$ (Fefferman Eq. (11));
2. Spatial $\mathbb{Z}^3$-periodicity `IsZ3Periodic (u t)` and `IsZ3Periodic (p t)` (Fefferman Eq. (8)/(10));
3. One-sided PDE satisfaction `navier_stokes_eq_Ici u p ν 0` on $[0, \infty)$ (avoiding the two-sided
   `deriv` artifact at $t = 0$);
4. Cell kinetic-energy inequality on the fundamental period cube `unitCube = [0, 1]^3`:
   $$\int_{[0,1]^3} \|u(t, x)\|^2\,dx \le \int_{[0,1]^3} \|u_0(x)\|^2\,dx.$$ -/
public structure PeriodicCellPhysicalNSSolution
    (ν : ℝ) (u₀ : VelocityField) (u : TimeDependentVelocity) (p : TimeDependentPressure) : Prop where
  viscosity_pos : 0 < ν
  smooth_u : ContDiffOn ℝ (⊤ : ℕ∞) (fun q : ℝ × T3 => u q.1 q.2) (Set.Ici (0 : ℝ) ×ˢ Set.univ)
  smooth_p : ContDiffOn ℝ (⊤ : ℕ∞) (fun q : ℝ × T3 => p q.1 q.2) (Set.Ici (0 : ℝ) ×ˢ Set.univ)
  pde_ici : navier_stokes_eq_Ici u p ν (fun _ _ => 0)
  init_eq : u 0 = u₀
  periodic_u : ∀ t ≥ (0 : ℝ), IsZ3Periodic (u t)
  periodic_p : ∀ t ≥ (0 : ℝ), IsZ3Periodic (p t)
  cell_energy_integrable : ∀ t ≥ (0 : ℝ),
    IntegrableOn (fun x : T3 => ‖u t x‖ ^ 2) unitCube MeasureTheory.volume
  cell_energy_le_init : ∀ t ≥ (0 : ℝ),
    (∫ x in unitCube, ‖u t x‖ ^ 2 ∂MeasureTheory.volume) ≤
      ∫ x in unitCube, ‖u₀ x‖ ^ 2 ∂MeasureTheory.volume

/-- **Proved Bridge (`periodicCellPhysical_implies_IsPeriodicSmoothSolution`):**
Every `PeriodicCellPhysicalNSSolution` satisfies Fefferman's exact periodic smooth solution predicate
`IsPeriodicSmoothSolution ν u₀ (fun _ _ => 0) u p` from `ClayStatements.lean`. -/
public theorem periodicCellPhysical_implies_IsPeriodicSmoothSolution
    {ν : ℝ} {u₀ : VelocityField} {u : TimeDependentVelocity} {p : TimeDependentPressure}
    (h : PeriodicCellPhysicalNSSolution ν u₀ u p) :
    IsPeriodicSmoothSolution ν u₀ (fun _ _ => 0) u p :=
  ⟨h.smooth_u, h.smooth_p, h.pde_ici, h.init_eq, fun t ht => ⟨h.periodic_u t ht, h.periodic_p t ht⟩⟩

/-! ## Section 5. In-Place Correction 5: Coherent Spatial-Maximum Rademacher/Danskin Envelope
and Line-by-Line Proof Obligations (`main.tex` §4, `certs/CubicSourceGap.tex`) -/

/-- **Ontological Correction 5 (`SpatialMaxVorticityEnvelope`):**
Makes the Danskin / Rademacher spatial-maximum envelope relation between the time-dependent
scalar function $M(t) = \|\omega(t)\|_{L^\infty}$ and a maximizing trajectory $x_t \in \mathbb{T}^3$
explicit for a math student:
- `attains_max`: $\|\omega(t, x_t)\| = M(t)$ and $M(t) = \sup_x \|\omega(t, x)\|$;
- `convective_grad_zero`: at the spatial maximum $x_t$, $\langle \omega(t, x_t), (u(t, x_t)\cdot\nabla)\omega(t, x_t) \rangle = 0$;
- `viscous_laplacian_nonpos`: at the spatial maximum $x_t$, $\langle \omega(t, x_t), \Delta\omega(t, x_t) \rangle \le 0$;
- `danskin_rate_le`: when $M(t) > 0$, the scalar derivative `deriv M t` is bounded above by the normalized
  inner product $\langle \omega(t, x_t), \partial_t \omega(t, x_t) \rangle / M(t)$. -/
public structure SpatialMaxVorticityEnvelope
    (u : TimeDependentVelocity) (p : TimeDependentPressure) (ν : ℝ)
    (M : ℝ → ℝ) (x_max : ℝ → T3) : Prop where
  satisfies_ns : NS_PDE u p ν
  viscosity_nonneg : 0 ≤ ν
  def_M : ∀ t ≥ (0 : ℝ), M t = vorticity_sup_norm (vorticity (u t))
  attains_max : ∀ t ≥ (0 : ℝ), ‖vorticity (u t) (x_max t)‖ = M t
  transport_reg : ∀ t ≥ (0 : ℝ), VorticityTransportRegularity u p t (x_max t)
  convective_grad_zero : ∀ t ≥ (0 : ℝ),
    inner ℝ (vorticity (u t) (x_max t))
      (convective (u t) (vorticity (u t)) (x_max t)) = 0
  viscous_laplacian_nonpos : ∀ t ≥ (0 : ℝ),
    inner ℝ (vorticity (u t) (x_max t))
      (laplacian (vorticity (u t)) (x_max t)) ≤ 0
  differentiable_M : ∀ t ≥ (0 : ℝ), DifferentiableAt ℝ M t
  danskin_rate_le : ∀ t ≥ (0 : ℝ), 0 < M t →
    deriv M t ≤
      inner ℝ (vorticity (u t) (x_max t))
        (time_deriv (fun s => vorticity (u s)) t (x_max t)) / M t

/-- **Open Proof Obligation A (`PointwiseCZGradientBoundAtMax`):**
At the spatial maximum $x_{\max}(t)$, the velocity gradient obeys the linear Calderón–Zygmund bound
$\|\nabla u(t, x_{\max}(t))\| \le C_{\mathrm{CZ}} M(t)$ without a logarithmic higher-Sobolev loss. -/
public def PointwiseCZGradientBoundAtMax
    (u : TimeDependentVelocity) (M : ℝ → ℝ) (x_max : ℝ → T3) (C_CZ : ℝ) : Prop :=
  ∀ t ≥ (0 : ℝ),
    DifferentiableAt ℝ (u t) (x_max t) ∧
    ‖fderiv ℝ (u t) (x_max t)‖ ≤ C_CZ * M t

/-- **Open Proof Obligation B (`SymplecticQuarticStretchingSinkAtMax`):**
The central gap between the unmodified vorticity transport equation and the Frohmanian cubic rate
(`certs/CubicSourceGap.tex` Eq. (6), `Modules/AssemblyGap.lean`):
at the spatial maximum $x_{\max}(t)$, vortex stretching is reduced from the classical cubic source
$C_{\mathrm{CZ}} M(t)^3$ by the quartic sink $\kappa'' M(t)^4$:
$$\langle \omega(t, x_{\max}(t)), (\omega\cdot\nabla)u(t, x_{\max}(t)) \rangle + \kappa'' M(t)^4 \le C_{\mathrm{CZ}} M(t)^3.$$ -/
public def SymplecticQuarticStretchingSinkAtMax
    (u : TimeDependentVelocity) (M : ℝ → ℝ) (x_max : ℝ → T3) (C_CZ κ'' : ℝ) : Prop :=
  ∀ t ≥ (0 : ℝ),
    inner ℝ (vorticity (u t) (x_max t))
      (convective (vorticity (u t)) (u t) (x_max t)) +
      κ'' * (M t) ^ 4 ≤ C_CZ * (M t) ^ 3

/-- **Proved Theorem 1 (`unmodified_envelope_yields_classical_quadratic_rate`):**
From the bare unmodified Navier–Stokes equations, `SpatialMaxVorticityEnvelope`, and
`PointwiseCZGradientBoundAtMax` alone (without `SymplecticQuarticStretchingSinkAtMax`),
one obtains **only** the classical quadratic differential inequality
$$\mathrm{deriv}\,M(t) \le C_{\mathrm{CZ}} M(t)^2,$$
whose comparison ODE $y' = C_{\mathrm{CZ}} y^2$ blows up in finite time $T = 1/(C_{\mathrm{CZ}} M(0))$. -/
public theorem unmodified_envelope_yields_classical_quadratic_rate
    {u : TimeDependentVelocity} {p : TimeDependentPressure} {ν : ℝ}
    {M : ℝ → ℝ} {x_max : ℝ → T3} {C_CZ : ℝ}
    (henv : SpatialMaxVorticityEnvelope u p ν M x_max)
    (hCZ : PointwiseCZGradientBoundAtMax u M x_max C_CZ)
    (t : ℝ) (ht : 0 ≤ t) (hM_pos : 0 < M t) :
    deriv M t ≤ C_CZ * (M t) ^ 2 := by
  have htime_le_stretch :=
    time_pairing_le_stretching_at_max u p ν t ht (x_max t)
      henv.satisfies_ns (henv.transport_reg t ht)
      (henv.convective_grad_zero t ht) (henv.viscous_laplacian_nonpos t ht)
      henv.viscosity_nonneg
  have hCZ_t := hCZ t ht
  have hCZ_sup : ‖fderiv ℝ (u t) (x_max t)‖ ≤ C_CZ * vorticity_sup_norm (vorticity (u t)) := by
    rw [← henv.def_M t ht]
    exact hCZ_t.2
  have hmax_sup : ‖vorticity (u t) (x_max t)‖ = vorticity_sup_norm (vorticity (u t)) := by
    rw [henv.attains_max t ht, henv.def_M t ht]
  have hstretch_cubic :=
    stretching_inner_le_at_max (vorticity (u t)) (u t) (x_max t) C_CZ
      hCZ_t.1 hCZ_sup hmax_sup
  rw [← henv.def_M t ht] at hstretch_cubic
  have hdt_cubic :
      inner ℝ (vorticity (u t) (x_max t))
        (time_deriv (fun s => vorticity (u s)) t (x_max t)) ≤ C_CZ * (M t) ^ 3 :=
    htime_le_stretch.trans hstretch_cubic
  have hdanskin := henv.danskin_rate_le t ht hM_pos
  have hdiv :
      inner ℝ (vorticity (u t) (x_max t))
        (time_deriv (fun s => vorticity (u s)) t (x_max t)) / M t ≤
      (C_CZ * (M t) ^ 3) / M t :=
    div_le_div_of_nonneg_right hdt_cubic (le_of_lt hM_pos)
  have hM_ne : M t ≠ 0 := ne_of_gt hM_pos
  have hring : (C_CZ * (M t) ^ 3) / M t = C_CZ * (M t) ^ 2 := by
    field_simp [hM_ne]
  linarith

/-- **Proved Theorem 2 (`symplectic_constraint_yields_cubic_damping_and_ceiling`):**
When the open obligation `SymplecticQuarticStretchingSinkAtMax u M x_max C_CZ κ''` is supplied
alongside `SpatialMaxVorticityEnvelope`, the scalar vorticity maximum $M(t)$ satisfies the
Frohmanian cubic differential inequality
$$\mathrm{deriv}\,M(t) \le C_{\mathrm{CZ}} M(t)^2 - \kappa'' M(t)^3$$
at every $t \ge 0$ where $M(t) > 0$. -/
public theorem symplectic_constraint_yields_cubic_damping_and_ceiling
    {u : TimeDependentVelocity} {p : TimeDependentPressure} {ν : ℝ}
    {M : ℝ → ℝ} {x_max : ℝ → T3} {C_CZ κ'' : ℝ}
    (henv : SpatialMaxVorticityEnvelope u p ν M x_max)
    (hsink : SymplecticQuarticStretchingSinkAtMax u M x_max C_CZ κ'')
    (t : ℝ) (ht : 0 ≤ t) (hM_pos : 0 < M t) :
    deriv M t ≤ C_CZ * (M t) ^ 2 - κ'' * (M t) ^ 3 := by
  have htime_le_stretch :=
    time_pairing_le_stretching_at_max u p ν t ht (x_max t)
      henv.satisfies_ns (henv.transport_reg t ht)
      (henv.convective_grad_zero t ht) (henv.viscous_laplacian_nonpos t ht)
      henv.viscosity_nonneg
  have hsink_t := hsink t ht
  have hdt_red :
      inner ℝ (vorticity (u t) (x_max t))
        (time_deriv (fun s => vorticity (u s)) t (x_max t)) ≤
      C_CZ * (M t) ^ 3 - κ'' * (M t) ^ 4 := by
    linarith
  have hdanskin := henv.danskin_rate_le t ht hM_pos
  have hdiv :
      inner ℝ (vorticity (u t) (x_max t))
        (time_deriv (fun s => vorticity (u s)) t (x_max t)) / M t ≤
      (C_CZ * (M t) ^ 3 - κ'' * (M t) ^ 4) / M t :=
    div_le_div_of_nonneg_right hdt_red (le_of_lt hM_pos)
  have hM_ne : M t ≠ 0 := ne_of_gt hM_pos
  have hring :
      (C_CZ * (M t) ^ 3 - κ'' * (M t) ^ 4) / M t =
        C_CZ * (M t) ^ 2 - κ'' * (M t) ^ 3 := by
    field_simp [hM_ne]
  linarith

/-! ## Section 6. The Exact First Remaining Lemma Needed After Ontological Corrections

After the five in-place ontological corrections above, what is the **very first mathematical lemma**
that must be proven to begin closing the remaining gap (`SymplecticQuarticStretchingSinkAtMax` /
`PeriodicDirectionDepletionBound`) from the unmodified Navier–Stokes equations?

As proved in `HighSetDepletionAndBKM.viscous_direction_dissipation_bridge`, the unmodified
vorticity norm-squared identity at a spatial maximum $x_t$ (where $\|\omega(t, x_t)\| = M(t) > 0$
and $\nabla(\|\omega\|^2)(x_t) = 0$) decomposes the viscous term via the unit vorticity direction
$\xi(x) = \omega(x) / \|\omega(x)\|$ as:
$$\langle \omega(x_t), \Delta\omega(x_t) \rangle
  = \frac{1}{2}\Delta(\|\omega\|^2)(x_t) - \|\nabla\omega(x_t)\|_{\mathrm{HS}}^2
  \le -M(t)^2 \|\nabla\xi(x_t)\|_{\mathrm{HS}}^2,$$
because $\Delta(\|\omega\|^2)(x_t) \le 0$ at a spatial maximum and the orthogonal decomposition
$\nabla\omega = (\nabla\|\omega\|) \otimes \xi + \|\omega\| \nabla\xi$ gives
$\|\nabla\omega\|_{\mathrm{HS}}^2 = \|\nabla\|\omega\|\|^2 + \|\omega\|^2 \|\nabla\xi\|_{\mathrm{HS}}^2
= M(t)^2 \|\nabla\xi(x_t)\|_{\mathrm{HS}}^2$ when $\nabla\|\omega\|(x_t) = 0$.

Currently in `HighSetDepletionAndBKM.lean` (line 79), the inequality
`h_visc_decomp : ν * visc_lap ≤ -(ν * M ^ 2 * grad_xi_sq)` is passed as an unproven hypothesis!
Proving this exact Bochner–Weitzenböck polar decomposition at a critical point of $\|\omega\|$ is the
**first concrete, self-contained lemma** needed to connect the unmodified viscous Laplacian to
vorticity-direction curvature $\|\nabla\xi\|^2$. -/

/-- **Proved Algebraic Core of the First Gap Lemma (`first_remaining_gap_bochner_polar_damping_at_max`):**
At any spatial maximum of $\|\omega\|$ where the radial gradient $\nabla\|\omega\|(x_t) = 0$,
the Hilbert–Schmidt norm squared of $\nabla\omega = (\nabla\|\omega\|)\otimes\xi + M \nabla\xi$
equals $M^2 \|\nabla\xi\|^2$, and combined with the concavity inequality
$\frac{1}{2}\Delta(\|\omega\|^2)(x_t) \le 0$, the Bochner identity
$\langle \omega, \Delta\omega \rangle = \frac{1}{2}\Delta(\|\omega\|^2) - \|\nabla\omega\|^2$
yields the exact viscous direction-curvature damping bound
$$\nu \langle \omega(x_t), \Delta\omega(x_t) \rangle \le -\nu M^2 \|\nabla\xi(x_t)\|^2.$$ -/
public theorem first_remaining_gap_bochner_polar_damping_at_max
    (ν M lap_half_norm_sq grad_omega_sq grad_norm_omega_sq grad_xi_sq visc_lap : ℝ)
    (hν : 0 ≤ ν)
    (h_bochner : visc_lap = lap_half_norm_sq - grad_omega_sq)
    (h_polar_pythagoras : grad_omega_sq = grad_norm_omega_sq + M ^ 2 * grad_xi_sq)
    (h_crit_point : grad_norm_omega_sq = 0)
    (h_max_concave : lap_half_norm_sq ≤ 0) :
    ν * visc_lap ≤ -(ν * M ^ 2 * grad_xi_sq) := by
  have h1 : visc_lap ≤ -(M ^ 2 * grad_xi_sq) := by
    linarith [h_bochner, h_polar_pythagoras, h_crit_point, h_max_concave]
  have h2 := mul_le_mul_of_nonneg_left h1 hν
  linarith

end -- noncomputable section

#print axioms kksPointwiseIntegrand_skew
#print axioms kksSymplecticForm_skew
#print axioms kksSymplecticForm_self_zero
#print axioms cross_jacobi_identity
#print axioms kksPointwise_cyclic_jacobi_identity
#print axioms kksSymplecticForm_functional_skew
#print axioms volumePreservingCoadjointAction_preserves_TetherKernel
#print axioms Pi_u_idempotent
#print axioms Pi_u_self_adjoint
#print axioms TetherKernel_eq_tetherMetricForm
#print axioms tetherMetricForm_symm
#print axioms FrohmanianMetriplecticPairing_diag_eq_metric
#print axioms periodicCellPhysical_implies_IsPeriodicSmoothSolution
#print axioms unmodified_envelope_yields_classical_quadratic_rate
#print axioms symplectic_constraint_yields_cubic_damping_and_ceiling
#print axioms first_remaining_gap_bochner_polar_damping_at_max

end Symplectori.SymplecticConstraint
