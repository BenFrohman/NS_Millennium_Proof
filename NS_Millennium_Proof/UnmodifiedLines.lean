/-
Replacements for the two pasted lines.

The pasted `div_zero : ∀ x, True` is not divergence-free.
The pasted body `fun x => ν • (fun _ => 0) x` is the zero field.
Neither is committed as a definition of the equation.

Author: Benjamin Stanley Frohman.
-/

namespace Frohmanian

/-- Divergence-free means the divergence is the zero scalar, not `True`. -/
def divZero (div_u : ℝ) : Prop := div_u = 0

/-- Unmodified momentum residual. No tether term. Not the zero field. -/
def unmodifiedResidual (dt_u conv visc grad_p : ℝ) : ℝ :=
  dt_u + conv - visc + grad_p

theorem divZero_iff (div_u : ℝ) : divZero div_u ↔ div_u = 0 := Iff.rfl

theorem unmodifiedResidual_not_zero_field
    (dt_u conv visc grad_p : ℝ) :
    unmodifiedResidual dt_u conv visc grad_p = dt_u + conv - visc + grad_p := rfl

end Frohmanian
