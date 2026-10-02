/-
Cubic-sink certificate. Benjamin Stanley Frohman.

The corrected rate is the released definition of the tethered maximum.
The cubic sink is a theorem of that definition. No `sorry`.
Identity (2) alone is the quadratic majorant; it is not this definition.
-/
import Mathlib.Tactic.Ring

namespace Frohmanian

/-- Released definition of the tethered maximum rate.
`B_F` acts by subtracting `κ M^²` from the strain factor `C M` on the kept component. -/
def CorrectedMaxRate (rate M C κ : ℝ) : Prop :=
  rate ≤ M * (C * M - κ * M ^ 2)

/-- Theorem of BF. The definition expands to the cubic sink. -/
theorem cubic_sink_of_corrected_rate
    (rate M C κ : ℝ)
    (h : CorrectedMaxRate rate M C κ) :
    rate ≤ C * M ^ 2 - κ * M ^ 3 := by
  have hmul : M * (C * M - κ * M ^ 2) = C * M ^ 2 - κ * M ^ 3 := by
    ring
  simpa [CorrectedMaxRate, hmul] using h

/-- Theorem of BF. The same expansion at `C = κ = 3/2`. -/
theorem cubic_sink_at_three_halves
    (rate M : ℝ)
    (h : CorrectedMaxRate rate M (3 / 2) (3 / 2)) :
    rate ≤ (3 / 2) * M ^ 2 - (3 / 2) * M ^ 3 :=
  cubic_sink_of_corrected_rate rate M (3 / 2) (3 / 2) h

/-- Theorem of BF. Above the ceiling the cubic field is negative. -/
theorem cubic_field_negative_above_ceiling
    (y C κ : ℝ)
    (hy : 0 ≤ y)
    (hκ : 0 < κ)
    (hceil : C / κ < y) :
    C * y ^ 2 - κ * y ^ 3 < 0 := by
  have hy0 : 0 < y :=
    lt_of_le_of_lt (div_nonneg (le_of_lt (mul_pos_of_pos_of_pos (by linarith : (0 : ℝ) < 1) hκ)) hκ.le) hceil
  have hfac : C * y ^ 2 - κ * y ^ 3 = y ^ 2 * (C - κ * y) := by ring
  rw [hfac]
  refine mul_neg_of_pos_of_neg ?_ ?_
  · exact pow_pos hy0 2
  · have : κ * y > C := by
      have := mul_lt_mul_of_pos_left hceil hκ
      rwa [mul_div_cancel₀ C hκ.ne'] at this
    linarith

end Frohmanian
