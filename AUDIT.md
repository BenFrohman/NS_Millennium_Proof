# Axiom / sorry audit (2026-11-04)

- Full `lake build`: successful, 2705 jobs, 0 errors, 0 `declaration uses 'sorry'` warnings.
- 170 in-build `#print axioms` reports: all `[propext, Classical.choice, Quot.sound]`.
- Gateaux-pairing additions (`classicalBracket_antisymm`, `classicalBracket_self`, `tetherKernel_self_nonpos`): standard axioms only.
- No active `axiom` declarations in the build target. `Modules/Assumptions.lean:85` is commented out.
- Not certified (outside the build target): `docs/Clarified_Degeneracy_and_Majorant_Blocks.lean` (sorry), root `Projection.lean:96`, `Modules/Uniqueness.lean:98`, `Modules/ClosureBlueprint.lean:122,285` (root-level legacy copies, sorry), `Tether.lean:200` (`axiom czc_3d_pos`), `historical/`.
- Open item: `h : IsGateauxRepresentative KineticEnergyHamiltonian ω (velocity_from_vorticity ω)` is false as stated. The vorticity-pairing representative is ψ. Counterexample: u=(sin z,0,0), ω=(0,cos z,0), ε=ω. See `paper/NS_certificates.pdf`.
