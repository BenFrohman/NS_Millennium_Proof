import FrohmanianTether.SymplecticTether
/-! Scratch comparison against ACTUAL definitions of frohmanian-tether-geometric @9e40ae7. -/
namespace TetherCompare
open FrohmanianTether ArnoldGeometric ForMathlib NavierStokes3D MeasureTheory InnerProductSpace

/-- Actual tether integrand pairing `q(F,G,ω) = ∫⟪Π_u δF, Π_u δG⟫`, `u = BS ω`. -/
noncomputable def q (F G : Functional) (ω : CoadjointOrbit) : ℝ :=
  ∫ x, inner ℝ (Pi_u (velocity_from_vorticity ω) (FunctionalDerivative F ω) x)
      (Pi_u (velocity_from_vorticity ω) (FunctionalDerivative G ω) x) ∂volume

/-- Helicity-type pairing `⟨ω, u⟩ = ∫ pairing (ω x) (u x)`, `u = BS ω`. -/
noncomputable def hel (ω : CoadjointOrbit) : ℝ :=
  ∫ x, pairing (ω.val x) (velocity_from_vorticity ω x) ∂volume

theorem tetherKernel_eq (ω : CoadjointOrbit) (F G : Functional) :
    TetherKernel ω F G = -kappa * Enstrophy ω * q F G ω := rfl

theorem tetheredBracket_eq (F G : Functional) (ω : CoadjointOrbit) :
    TetheredBracket F G ω = ClassicalBracket F G ω + -kappa * Enstrophy ω * q F G ω := rfl

/-- Frozen-vector tether pairing: pairing the FTVerified-shaped vector `(-(κ w) q) • u`
with the state `ω` (actual `pairing`, actual `u = BS ω`). Requires no integrability: uses
`integral_const_mul` only. -/
theorem frozen_pairing (ω : CoadjointOrbit) (F G : Functional) (w : ℝ) :
    (∫ x, pairing (ω.val x) ((-(kappa * w) * q F G ω) • velocity_from_vorticity ω x) ∂volume)
      = -(kappa * w) * q F G ω * hel ω := by
  unfold hel; rw [← integral_const_mul]; congr 1; funext x
  simp [pairing, inner_smul_right]

/-- Exact matching condition against the ACTUAL `TetherKernel`. -/
theorem match_iff (ω : CoadjointOrbit) (F G : Functional) (w : ℝ) :
    (∫ x, pairing (ω.val x) ((-(kappa * w) * q F G ω) • velocity_from_vorticity ω x) ∂volume)
      = TetherKernel ω F G ↔ q F G ω * (w * hel ω - Enstrophy ω) = 0 := by
  rw [frozen_pairing, tetherKernel_eq]
  have hk : kappa ≠ 0 := kappa_ne_zero'
  constructor
  · intro h
    have : kappa * (q F G ω * (w * hel ω - Enstrophy ω)) = 0 := by linarith
    exact (mul_eq_zero.mp this).resolve_left hk
  · intro h; linear_combination (-kappa) * h
where kappa_ne_zero' : kappa ≠ 0 := ne_of_gt kappa_pos

theorem match_of_hel_ne (ω : CoadjointOrbit) (F G : Functional) (h : hel ω ≠ 0) :
    (∫ x, pairing (ω.val x)
        ((-(kappa * (Enstrophy ω / hel ω)) * q F G ω) • velocity_from_vorticity ω x) ∂volume)
      = TetherKernel ω F G := by
  rw [match_iff]; field_simp; ring

/-- Obstruction against actual defs: zero helicity pairing, nonzero enstrophy and nonzero
projected pairing ⇒ no frozen parameter `w` reproduces the actual tether kernel. -/
theorem no_match (ω : CoadjointOrbit) (F G : Functional) (hH : hel ω = 0)
    (hE : Enstrophy ω ≠ 0) (hq : q F G ω ≠ 0) (w : ℝ) :
    (∫ x, pairing (ω.val x) ((-(kappa * w) * q F G ω) • velocity_from_vorticity ω x) ∂volume)
      ≠ TetherKernel ω F G := by
  intro h; rw [match_iff, hH] at h; simp [hE, hq] at h

/-- Degeneracy of the actual encoding: if `F` has no Gâteaux representative at `ω`,
the actual tether kernel `T(F,G)(ω)` is `0` for every `G` (classical part not covered:
its integrand is private in the source module). -/
theorem tetherKernel_of_no_rep (F G : Functional) (ω : CoadjointOrbit)
    (h : ¬ ∃ d, IsGateauxRepresentative F ω d) : TetherKernel ω F G = 0 := by
  rw [tetherKernel_eq, q, FunctionalDerivative_eq_zero_of_not h, Pi_u_zero]; simp

/-- The actual bracket is not antisymmetric off the classical part:
`{F,G} + {G,F} = 2·TetherKernel` (uses actual `classicalBracket_antisymm`). -/
theorem symm_part (F G : Functional) (ω : CoadjointOrbit) :
    TetheredBracket F G ω + TetheredBracket G F ω = 2 * TetherKernel ω F G := by
  have := classicalBracket_antisymm F G ω
  unfold TetheredBracket; rw [tetherKernel_comm ω G F]; linarith

/-- Enstrophy state dependence (actual def): `Enstrophy ω = ∫ ‖ω x‖²`. -/
theorem enstrophy_eq (ω : CoadjointOrbit) : Enstrophy ω = ∫ x, ‖ω.val x‖ ^ 2 ∂volume := rfl

/-- The zero state is an actual orbit point, with zero enstrophy, so the actual tether
kernel vanishes there for all `F G`. -/
def zeroOrbit : CoadjointOrbit := ⟨fun _ => 0, by intro x; simp [NavierStokes3D.div]⟩
theorem tetherKernel_zero (F G : Functional) : TetherKernel zeroOrbit F G = 0 := by
  rw [tetherKernel_eq, enstrophy_eq]; simp [zeroOrbit]
end TetherCompare
#print axioms TetherCompare.tetherKernel_eq
#print axioms TetherCompare.frozen_pairing
#print axioms TetherCompare.match_iff
#print axioms TetherCompare.match_of_hel_ne
#print axioms TetherCompare.no_match
#print axioms TetherCompare.tetherKernel_of_no_rep
#print axioms TetherCompare.symm_part
#print axioms TetherCompare.tetherKernel_zero
