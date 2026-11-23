import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.CrossProduct
import Mathlib.Tactic

/-!
Fragment from the truncated first paste of FrohmanianTripleArchitecture.lean:
Section 3 alignment kernel lemmas that are NOT in the second complete copy.
Includes a minimal prelude so the fragment can be attempted standalone.
-/

noncomputable section
open Real

namespace AlignmentKernelFragment

def cross3 (a b : Fin 3 → ℝ) : Fin 3 → ℝ := crossProduct a b
def dot3 (a b : Fin 3 → ℝ) : ℝ := ∑ i : Fin 3, a i * b i
def normSq3 (a : Fin 3 → ℝ) : ℝ := dot3 a a
def norm3 (a : Fin 3 → ℝ) : ℝ := Real.sqrt (normSq3 a)

lemma abs_dot3_le (a b : Fin 3 → ℝ) : |dot3 a b| ≤ norm3 a * norm3 b := by
  unfold norm3 normSq3 dot3
  rw [← Real.sqrt_mul (Finset.sum_nonneg fun i _ => mul_self_nonneg (a i))]
  apply Real.abs_le_sqrt
  have hcs := Finset.sum_mul_sq_le_sq_mul_sq (Finset.univ : Finset (Fin 3)) a b
  simpa only [sq] using hcs

def alignmentTetherKernel (dist : ℝ) (r_hat ξ_x ξ_y : Fin 3 → ℝ) : ℝ :=
  (3 / (4 * Real.pi * dist ^ 3)) * (dot3 r_hat ξ_x) * (dot3 (cross3 r_hat ξ_y) ξ_x)

lemma triple_product_cycle (r_hat ξ_x ξ_y : Fin 3 → ℝ) :
    dot3 (cross3 r_hat ξ_y) ξ_x = dot3 r_hat (cross3 ξ_y ξ_x) := by
  unfold dot3 cross3 crossProduct
  simp only [Fin.sum_univ_three, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two, Matrix.head_cons]
  ring

theorem abs_alignmentKernel_le {dist : ℝ} (hdist : 0 < dist) {r_hat ξ_x : Fin 3 → ℝ}
    (hr : norm3 r_hat = 1) (hξx : norm3 ξ_x = 1) (ξ_y : Fin 3 → ℝ) :
    |alignmentTetherKernel dist r_hat ξ_x ξ_y| ≤ (3 / (4 * Real.pi * dist ^ 3)) * norm3 (cross3 ξ_y ξ_x) := by
  unfold alignmentTetherKernel
  have hcoeff_pos : 0 < 3 / (4 * Real.pi * dist ^ 3) := by positivity
  rw [abs_mul, abs_mul, abs_of_pos hcoeff_pos]
  have h1 : |dot3 r_hat ξ_x| ≤ 1 := by
    calc |dot3 r_hat ξ_x| ≤ norm3 r_hat * norm3 ξ_x := abs_dot3_le r_hat ξ_x
    _ = 1 * 1 := by rw [hr, hξx]
    _ = 1 := mul_one 1
  have h2 : |dot3 (cross3 r_hat ξ_y) ξ_x| ≤ norm3 (cross3 ξ_y ξ_x) := by
    rw [triple_product_cycle]
    calc |dot3 r_hat (cross3 ξ_y ξ_x)| ≤ norm3 r_hat * norm3 (cross3 ξ_y ξ_x) := abs_dot3_le r_hat (cross3 ξ_y ξ_x)
    _ = 1 * norm3 (cross3 ξ_y ξ_x) := by rw [hr]
    _ = norm3 (cross3 ξ_y ξ_x) := one_mul _
  have h1_nonneg : 0 ≤ |dot3 r_hat ξ_x| := abs_nonneg _
  have h2_nonneg : 0 ≤ |dot3 (cross3 r_hat ξ_y) ξ_x| := abs_nonneg _
  calc (3 / (4 * Real.pi * dist ^ 3)) * |dot3 r_hat ξ_x| * |dot3 (cross3 r_hat ξ_y) ξ_x|
    ≤ (3 / (4 * Real.pi * dist ^ 3)) * 1 * norm3 (cross3 ξ_y ξ_x) := by gcongr
  _ = (3 / (4 * Real.pi * dist ^ 3)) * norm3 (cross3 ξ_y ξ_x) := by ring

/-- Truncated mid-statement in the first paste; kept for provenance only.
    The incomplete theorem constantin_fefferman_desingularization is NOT restated here
    because its proof body was cut off in the source paste. -/

end AlignmentKernelFragment
