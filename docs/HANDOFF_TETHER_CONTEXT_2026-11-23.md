# Handoff context (23 November 2026) — Frohmanian Tether / NS_Millennium_Proof

**Provenance.** This file archives the tether/NS portion of the 23 November 2026
handoff that was placed on the shared computer as
`/workspace/ns-context/HANDOFF_2026-11-23_tether_context.md` (3:31 PM, America/Chicago)
and was prepared from session t638u. An unrelated public-result item from that
same session is omitted here, at Benjamin's instruction, and is not part of the
tether or Navier–Stokes formalization.

The claims below were checked against the Lean in this repository before being
used in [OFFICIAL_CONDITIONAL_THEOREM.md](OFFICIAL_CONDITIONAL_THEOREM.md) and
[LYAPUNOV_CUBIC_SINK_STATUS.md](LYAPUNOV_CUBIC_SINK_STATUS.md). Discrepancies
are recorded there, not smoothed over.

## Frohmanian Symplectic Tether (as relayed, then checked)

- The tether formula is \(B(F,G) = -\kappa \int |\omega|^2 (\Pi_u \delta F/\delta\omega \cdot \Pi_u \delta G/\delta\omega)\,dV\), with \(\kappa = C_{CZ}(3) = 3/2\). The constant identity is kernel-checked as `CalderonZygmundConstant3D_eq_three_halves` / `kappa_eq_three_halves`.
- (C1) coadjoint invariance / locality; (C2) strict degeneracy via the projector \(\Pi_u\) on the kinetic-energy Hamiltonian; (C3) controllable negative feedback at maxima of \(|\omega|\). Degeneracy on the kinetic-energy Hamiltonian is `tetherKernel_degenerates_on_kinetic_energy`.
- Uniqueness among lowest-degree polynomial-in-\(\omega\) maps (5-step canonicity): live theorem `uniqueness_of_minimal_tether` (minimal uniqueness, not the false claim that every antisymmetric map is the kernel).
- Two layers: a geometric layer, and an analytic tethered Lyapunov / enstrophy layer that *aims at* the cubic majorant \(M' \le C M^2 - \kappa'' M^3\). That majorant is a target and is **open**. See [LYAPUNOV_CUBIC_SINK_STATUS.md](LYAPUNOV_CUBIC_SINK_STATUS.md).
- Named open hypotheses that **do** exist in Lean: `DirectionCurvatureBound` (alias of `UniformVorticityEnvelopeBound`), `UniformVorticityEnvelopeBound`, `CubicVorticityDifferentialBound`, together with BKM continuation propositions such as `PeriodicBKMContinuation` and `BKMClosingCriterion`.
- Status: the geometric layer is largely in place, with the Jacobi cyclic-cancellation step still a hypothesized identification (`tethered_jacobi_identity` takes `hident` and `hvanish`; `h_cyclic_integrand_zero` is not a declaration). Regularity is conditional on the named open analytic hypotheses. No Clay claim.
- Repos named in the handoff: `BenFrohman/NS_Millennium_Proof`, `BenFrohman/frohmanian-ns-symplectic-tether` (landing page; GitHub shows only `main`), and `BenFrohman/frohmanian-tether-manuscript-2026-06-01` (earliest public snapshot; GitHub also has truth-gate and copyright-header branches). No local unpushed work for those two companion repos was found on this computer.
- Past May 2026 Grok chat identifiers from the handoff were not accessible from this side and are not reproduced as if they had been re-read.

Author: Benjamin Stanley Frohman.
