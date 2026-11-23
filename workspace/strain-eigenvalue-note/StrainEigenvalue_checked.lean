import Mathlib

/-!
# Strain-Tensor Eigenvalue Decomposition (checked version)

Algebraic identities for a real symmetric, trace-free 3×3 strain matrix `S`, using the
actual eigenvalues and an orthonormal eigenbasis supplied by Mathlib's spectral theorem
(`LinearMap.IsSymmetric.eigenvalues`, `LinearMap.IsSymmetric.eigenvectorBasis`) for the
self-adjoint operator `Matrix.toEuclideanLin S` on `EuclideanSpace ℝ (Fin 3)`.

Mathlib sorts the eigenvalues in *decreasing* order:
`eigenvalues S 0 ≥ eigenvalues S 1 ≥ eigenvalues S 2`.
In the paper's notation `λ₁ ≤ λ₂ ≤ λ₃`, this means
`λ₃ = eigenvalues S 0`, `λ₂ = eigenvalues S 1` (the intermediate eigenvalue), and
`λ₁ = eigenvalues S 2`.

Everything here is pointwise linear algebra. Nothing here gives integrability of
`‖S‖_∞` in time or proves Hypothesis B.
-/

noncomputable section

open Matrix
open scoped InnerProductSpace

namespace StrainEigenvalue

/-- A real symmetric 3×3 matrix with vanishing trace. -/
structure StrainTensor where
  mat : Matrix (Fin 3) (Fin 3) ℝ
  symm : mat.IsSymm
  trace_zero : mat.trace = 0

/-- Ambient space: Euclidean ℝ³ (so the norm is the ℓ² norm). -/
abbrev E3 := EuclideanSpace ℝ (Fin 3)

/-- The linear operator `ξ ↦ S ξ` on Euclidean ℝ³. -/
def op (S : StrainTensor) : E3 →ₗ[ℝ] E3 := Matrix.toEuclideanLin S.mat

theorem isHermitian (S : StrainTensor) : S.mat.IsHermitian := by
  unfold Matrix.IsHermitian
  rw [Matrix.conjTranspose_eq_transpose_of_trivial]
  exact S.symm

theorem op_isSymmetric (S : StrainTensor) : (op S).IsSymmetric :=
  Matrix.isSymmetric_toEuclideanLin_iff.mpr (isHermitian S)

theorem finrank_E3 : Module.finrank ℝ E3 = 3 := finrank_euclideanSpace_fin

/-- The three real eigenvalues of `S` (spectral theorem), sorted decreasingly. -/
def eigenvalues (S : StrainTensor) : Fin 3 → ℝ :=
  (op_isSymmetric S).eigenvalues finrank_E3

/-- An orthonormal eigenbasis of `S`. -/
def eigenbasis (S : StrainTensor) : OrthonormalBasis (Fin 3) ℝ E3 :=
  (op_isSymmetric S).eigenvectorBasis finrank_E3

theorem eigenbasis_spec (S : StrainTensor) (i : Fin 3) :
    op S (eigenbasis S i) = eigenvalues S i • eigenbasis S i := by
  simp [eigenbasis, eigenvalues]

/-- `eigenvalues S 2 ≤ eigenvalues S 1 ≤ eigenvalues S 0`: index `1` is the intermediate one. -/
theorem eigenvalues_sorted (S : StrainTensor) :
    eigenvalues S 2 ≤ eigenvalues S 1 ∧ eigenvalues S 1 ≤ eigenvalues S 0 := by
  have h := (op_isSymmetric S).eigenvalues_antitone finrank_E3
  exact ⟨h (by decide), h (by decide)⟩

/-- Trace-free: `λ₁ + λ₂ + λ₃ = 0`. -/
theorem eigenvalues_sum_zero (S : StrainTensor) :
    ∑ i, eigenvalues S i = 0 := by
  have htr : LinearMap.trace ℝ E3 (op S) = S.mat.trace := by
    unfold op
    rw [Matrix.toEuclideanLin_eq_toLin_orthonormal, Matrix.trace_toLin_eq]
  rw [LinearMap.trace_eq_sum_inner (op S) (eigenbasis S), S.trace_zero] at htr
  rw [← htr]
  refine Finset.sum_congr rfl fun i _ => ?_
  rw [eigenbasis_spec, real_inner_smul_right, real_inner_self_eq_norm_sq,
    (eigenbasis S).orthonormal.1 i]
  ring

/-- The smallest eigenvalue is `≤ 0` and the largest is `≥ 0`. -/
theorem extreme_eigenvalues_sign (S : StrainTensor) :
    eigenvalues S 2 ≤ 0 ∧ 0 ≤ eigenvalues S 0 := by
  have hs := eigenvalues_sum_zero S
  rw [Fin.sum_univ_three] at hs
  obtain ⟨h1, h2⟩ := eigenvalues_sorted S
  constructor <;> linarith

/-- Coordinates of `ξ` in the eigenbasis: `c i = ⟪e i, ξ⟫`. -/
def coord (S : StrainTensor) (ξ : E3) (i : Fin 3) : ℝ := ⟪eigenbasis S i, ξ⟫_ℝ

/-- The stretching quadratic form `ξ · S ξ`. -/
def stretching (S : StrainTensor) (ξ : E3) : ℝ := ⟪ξ, op S ξ⟫_ℝ

/-- `ξ · S ξ` is the usual matrix quadratic form `ξᵀ S ξ`. -/
theorem stretching_eq_dotProduct (S : StrainTensor) (ξ : E3) :
    stretching S ξ = (WithLp.ofLp ξ) ⬝ᵥ (S.mat *ᵥ WithLp.ofLp ξ) := by
  show (S.mat *ᵥ WithLp.ofLp ξ) ⬝ᵥ star (WithLp.ofLp ξ) = _
  rw [star_trivial, dotProduct_comm]

/-- Spectral form: `ξ · S ξ = Σ λᵢ cᵢ²`. -/
theorem stretching_eq_sum (S : StrainTensor) (ξ : E3) :
    stretching S ξ = ∑ i, eigenvalues S i * coord S ξ i ^ 2 := by
  unfold stretching
  rw [← (eigenbasis S).sum_inner_mul_inner ξ (op S ξ)]
  refine Finset.sum_congr rfl fun i _ => ?_
  have hrepr := (op_isSymmetric S).eigenvectorBasis_apply_self_apply finrank_E3 ξ i
  rw [OrthonormalBasis.repr_apply_apply, OrthonormalBasis.repr_apply_apply] at hrepr
  change ⟪eigenbasis S i, op S ξ⟫_ℝ = eigenvalues S i * ⟪eigenbasis S i, ξ⟫_ℝ at hrepr
  rw [hrepr, real_inner_comm, coord]
  ring

/-- For a unit vector, the eigenbasis coordinates satisfy `Σ cᵢ² = 1`. -/
theorem coord_sum_sq (S : StrainTensor) (ξ : E3) (hξ : ‖ξ‖ = 1) :
    ∑ i, coord S ξ i ^ 2 = 1 := by
  have h := (eigenbasis S).sum_sq_norm_inner_right ξ
  rw [hξ, one_pow] at h
  rw [← h]
  refine Finset.sum_congr rfl fun i _ => ?_
  rw [coord, Real.norm_eq_abs, sq_abs]

/-- Intermediate-eigenvalue representation, for a unit vector `ξ` (Euclidean norm):
`ξ · S ξ = λ₂ + (λ₃ - λ₂) c₀² + (λ₁ - λ₂) c₂²`, where `λ₂ = eigenvalues S 1` is the
intermediate eigenvalue. With the paper's labels this is
`λ₂ + (λ₁ - λ₂) ξ₁² + (λ₃ - λ₂) ξ₃²`. -/
theorem intermediate_representation (S : StrainTensor) (ξ : E3) (hξ : ‖ξ‖ = 1) :
    stretching S ξ =
      eigenvalues S 1 +
      (eigenvalues S 0 - eigenvalues S 1) * (coord S ξ 0) ^ 2 +
      (eigenvalues S 2 - eigenvalues S 1) * (coord S ξ 2) ^ 2 := by
  have hs := stretching_eq_sum S ξ
  have hc := coord_sum_sq S ξ hξ
  rw [Fin.sum_univ_three] at hs hc
  rw [hs]
  linear_combination (eigenvalues S 1) * hc

end StrainEigenvalue
