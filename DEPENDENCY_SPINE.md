# Dependency spine

The conditional Frohmanian Tether spine is recorded in
[`docs/TETHER_CONDITIONAL_SPINE.md`](docs/TETHER_CONDITIONAL_SPINE.md).

It documents two separate well-founded paths:

- Path A (terminal Clay reduction): the open hypotheses `UniformVorticityEnvelopeBound ν` **and** `PeriodicBKMContinuation ν`, with terminal node `clay_reduces_to_uniform_vorticity_envelope`. Both hypotheses are required.
- Path B (rate / comparison ceiling): the open hypotheses `FrohmanianTetherRate u₀ ν` and `CubicVorticityDifferentialBound u τ C κ`, which yield a bound on \(\|\omega(t)\|_\infty\) but do not by themselves give `Clay_B_exact` and are not identified with the envelope.

No unconditional Clay (B) claim is made. The rate, the envelope, and periodic BKM continuation stay named, visible, and open.
