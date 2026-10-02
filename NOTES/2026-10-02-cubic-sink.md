# 2026-10-02 — cubic sink from the stretching identity and the tether

Author: Benjamin Stanley Frohman (GitHub @BenFrohman; X.com : Investor0x).

This note continues the 2026-08-31 corpus entry. That entry is not deleted. It recorded that identity (2) alone does not give the Riccati sink, and that the plus-weight source sextic is positive.

## Identity (2)

At a spatial maximum of `|ω|²`, transport vanishes and viscosity does not raise the maximum. The stretching density is cubic:

`⟨ω, (ω · ∇) u⟩ ≤ C_CZ M³`, with `C_CZ(3) = 3/2`.

Hence `M M' ≤ ⟨ω, (ω · ∇) u⟩`, and

`M' ≤ (3/2) M²`.

That is all identity (2) gives.

## Tether correction

`B_F` subtracts `κ |ω|²` from the strain on the component kept by `Π_u`. At the maximum that component is kept, so the corrected strain rate is `(3/2) M − κ M²`. Multiply by `M`:

`M' ≤ (3/2) M² − κ M³`.

With `κ'' = κ = 3/2`, a majorant `y` of `M` obeys

`y' ≤ C y² − κ'' y³`.

That is the cubic sink, derived from identity (2) together with `B_F`. It is not derived from identity (2) alone.

## Status

This is the paper identification. It is not a new kernel theorem. `HISTORY.md` was not rewritten: a full-file update of that 30KB note truncates. The 2026-08-31 sentence remains the record that (2) alone is not the sink.
