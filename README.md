# Frohmanian Symplectic Tether — 3D Navier–Stokes Global Regularity (Lean 4)

[![Lean CI](https://github.com/BenFrohman/NS_Millennium_Proof/actions/workflows/lean.yml/badge.svg)](https://github.com/BenFrohman/NS_Millennium_Proof/actions/workflows/lean.yml)
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Lean](https://img.shields.io/badge/Lean-4.30.0--rc1-brightgreen.svg)](lean-toolchain)
[![Sponsor](https://img.shields.io/github/sponsors/BenFrohman?label=Sponsor&logo=github)](https://github.com/sponsors/BenFrohman)

A geometric approach to the **3D incompressible Navier–Stokes global-regularity problem** on the periodic
torus, together with its **Lean 4** formalization. The central object is the *Frohmanian Symplectic Tether* —
a construction on coadjoint orbits that produces controllable negative feedback at maxima of the vorticity,
tied to a Lyapunov/enstrophy argument.

> ### Honest scope
> This repository is a **priority-preserving, structured formalization artifact**. It contains novel geometric
> definitions and architecture, schematic proof skeletons, and remaining analytic work marked with explicit
> `sorry` / schematic holes. **It does not claim a completed, kernel-closed solution of the Clay Navier–Stokes
> Millennium Problem.** Readers should distinguish (a) the novel geometric definitions and architecture,
> (b) the schematic proof skeletons, and (c) the analytic steps that remain open. This framing is deliberate
> and is carried through the source and documentation.

## Approach at a glance

The proof is organized as a **two-layer, non-circular** architecture:

1. **Geometric layer** — a symplectic tether on coadjoint orbits, with three necessary conditions (C1)–(C3)
   and a degeneracy result with respect to the kinetic-energy Hamiltonian (`Modules/SymplecticTether.lean`,
   `Modules/ArnoldGeometric.lean`).
2. **Analytic layer** — a tethered Lyapunov / enstrophy differential inequality in which higher-order
   dissipation absorbs the nonlinear vorticity-stretching term (`Modules/TetheredLyapunov.lean`,
   `Modules/IndependentMajorant.lean`), closing to global regularity (`Modules/GlobalRegularity.lean`).

Reusable, potentially upstreamable lemmas live under [`ForMathlib/`](ForMathlib/README.md) following the
hygiene pattern used in Tao's PFR project.

## Repository structure

```
Modules/                 Core Lean modules (geometric + analytic layers)
ForMathlib/              Reusable lemmas intended for eventual Mathlib upstreaming
NS_Millennium_Proof/     Library root (Definitions, Modules, Skeleton, Widgets)
Blueprint.md             Human-readable dependency graph and atomic statements
LaTeX_Lean_Relationship.md   Mapping between LaTeX intuition and the Lean code
AUTHORS.md / COPYRIGHT.md / HISTORY.md   Attribution and provenance
lakefile.lean / lean-toolchain / lake-manifest.json   Build configuration
```

## Building

Requires [`elan`](https://github.com/leanprover/elan) (the toolchain pin in `lean-toolchain` is fetched
automatically). Mathlib is a dependency; fetch its prebuilt cache before building to avoid a multi-hour
compile:

```bash
lake exe cache get   # download prebuilt Mathlib artifacts
lake build           # build the project
```

The pinned toolchain is **Lean 4.30.0-rc1** with **Mathlib @ v4.30.0-rc1**.

## Authorship, priority, and citation

Original author and originator: **Benjamin Stanley Frohman** (see [`AUTHORS.md`](AUTHORS.md)). The named
constructions in this repository (Frohmanian tether, tethered bracket, tethered Lyapunov, tethered nullifier,
independent majorant) are original to this work. If you reference it, please cite via
[`CITATION.cff`](CITATION.cff).

## Support

Independent research. If this corpus is useful: **[Sponsor on GitHub](https://github.com/sponsors/BenFrohman)**.

## License

[Apache License 2.0](LICENSE) © 2026 Benjamin Stanley Frohman.
