## Main Theorem (proved reduction)

`clay_reduces_to_direction_curvature_bound` (Lean 4 + Mathlib, `0 sorry`, axioms `[propext, Classical.choice, Quot.sound]`):

> For every ν > 0, assuming the classical periodic Beale–Kato–Majda continuation principle `PeriodicBKMContinuation ν` (a published theorem, Kato 1972 / Beale–Kato–Majda 1984, **not** formalized here and therefore an explicit hypothesis), the named estimate `DirectionCurvatureBound ν` implies Fefferman's exact periodic Clay statement `Clay_B_exact ν`.

- `DirectionCurvatureBound ν` (high-set direction-curvature / cubic depletion bound `M' ≤ C M² − κ M³`) is the single named **open** estimate (conjecture). It is **not** proved.
- The Clay problem is **not** claimed solved. The converse (`Clay_B_exact → DirectionCurvatureBound`) is **not** proved.

**Main Theorem A (unconditional supporting facts):** attained-maximum ⇒ `BddAbove` and sup-norm equality; Bochner and polar Pythagoras identities, now *derived* from `HasDerivAt` along coordinate lines (`Stage6Calculus.lean`); the near/far cutoff absorption algebra; Burgers-strain exclusion on 𝕋³; the comparison-ODE ceiling; and a genuinely non-constant exact periodic shear Beltrami mode `e^{-4π²νt}(sin 2πz, cos 2πz, 0)` checked component-wise.

