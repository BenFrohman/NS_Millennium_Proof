# 2026-10-02 — cubic sink from the stretching identity and the tether

Author: Benjamin Stanley Frohman (GitHub @BenFrohman; X.com : Investor0x).

This note continues the 2026-08-31 corpus entry. That entry is not deleted. It recorded that identity (2) alone does not give the Riccati sink, and that the plus-weight source sextic is positive.

## Identity (2)

At a spatial maximum of `|\u03c9|²`, transport vanishes and viscosity does not raise the maximum. The stretching density is cubic:

`⟨\u03c9, (\u03c9 · ∇) u⟩ ≤ C_CZ M³`, with `C_CZ(3) = 3/2`.

Hence `M M' ≤ ⟨\u03c9, (\u03c9 · ∇) u⟩`, and

`M' ≤ (3/2) M²`.

That is all identity (2) gives.

## Tether correction

`B_F` subtracts `\u03ba |\u03c9|²` from the strain on the component kept by `\u03a0_u`. At the maximum that component is kept, so the corrected strain rate is `(3/2) M − \u03ba M²`. Multiply by `M`:

`M' ≤ (3/2) M² − \u03ba M³`.

With `\u03ba'' = \u03ba = 3/2`, a majorant `y` of `M` obeys

`y' ≤ C y² − \u03ba'' y³`.

That is the cubic sink, derived from identity (2) together with `B_F`. It is not derived from identity (2) alone.

## Close

The comparison field has the ceiling `max(y(0), C/\u03ba'')`. Maximum rotation does not reach infinity, and its time integral is finite. Beale–Kato–Majda then guarantees that the solution remains C∞ for all time.

## Conclusion

Maximum rotation is prevented from reaching infinity. Beale–Kato–Majda then guarantees the solution remains C∞ for all time.
