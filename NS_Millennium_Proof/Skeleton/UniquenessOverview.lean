/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman

This file is part of the Lean 4 formalization of the Frohmanian Symplectic Tether Theorem.

See the root document `LaTeX_Lean_Relationship.md` §3 (mapping table) and §5 (Future Extension)
for the precise correspondence with the May 31 2026 LaTeX manuscript.

This is the **high-level logical skeleton** for all uniqueness arguments.

It is deliberately distinct from `Modules/Uniqueness.lean` (the implementation file
that contains the actual proofs and lemmas). This file plays the same role for
uniqueness that `Skeleton/PaperOverview.lean` plays for the overall proof.

Referees and collaborators should read this file first for orientation.
-/

module

namespace FrohmanianTether.Skeleton

/-!
# Uniqueness Overview — Frohmanian Symplectic Tether Formalization

## 1. Two Distinct Uniqueness Claims

The development contains (or will contain) two clearly separated uniqueness results:

### Claim A — Uniqueness of the Tether Construction (Current, Layer 1)
There exists a **unique** (up to gauge) minimal bilinear antisymmetric quadratic
metric correction 𝔗_F to Arnold’s classical Lie–Poisson bracket on the coadjoint
orbit of volume-preserving diffeomorphisms such that:

- It is forced by the vorticity transport equation of the **unmodified**
  3D incompressible Navier-Stokes equations.
- It satisfies the five axioms (A1)–(A5) derived from the structure of the PDE
  and the coadjoint orbit geometry.
- It reproduces the exact classical reversible Euler dynamics (degeneracy).
- It produces controllable negative quadratic feedback on vortex stretching.
- It preserves the Jacobi identity on the reduced orbit (explicit 9-term
  index-notation verification + Chevalley–Eilenberg 2-cocycle closure).

This claim is proved by the 5-step canonicity argument (Theorem 2.3 in the paper).
Its proof lives in `Modules/SymplecticTether.lean` (detailed) and will be
surfaced cleanly through `Modules/Uniqueness.lean`.

### Claim B — Uniqueness of Global Regular Solutions (Future, after Metriplectic extension)
Once the current Tether proof is accepted as true and the author introduces
the Metriplectic conjecture and function, a second uniqueness result will appear:

Any two global regular solutions of the 3D incompressible Navier-Stokes system
that satisfy the tethered dynamics and have the same initial data must coincide.

This claim will live in `Modules/Uniqueness.lean` under a clearly labeled section
and will be accompanied by an updated row in `LaTeX_Lean_Relationship.md`.

## 2. Logical Dependencies (One-Way Flow Only)

```
Classical NS PDE + Coadjoint Orbit Geometry
          ↓
   Construction of 𝔗_F (SymplecticTether)
          ↓
   5-Step Canonicity / Uniqueness of 𝔗_F (Claim A)
          ↓
   Independent Majorant + Differential Inequality (TetheredLyapunov, Layer 2)
          ↓
   Global Regularity Corollary (GlobalRegularity)
          ↓
   [Future] Metriplectic Structure + Conjecture
          ↓
   Uniqueness of Global Regular Solutions (Claim B)
```

No arrow ever points backwards. In particular:
- The proof of Claim A never uses any analytic estimate from Layer 2.
- The proof of Claim B (future) will use the already-established Claim A + the
  independent majorant (which is introduced before any appeal to a particular
  solution).

## 3. Why a Dedicated Uniqueness Skeleton?

- Uniqueness arguments are often the most delicate part of regularity proofs.
- Clay referees can review this module independently of the full analytic
  estimates.
- It makes the separation between "the Tether is unique" and "solutions are
  unique" explicit and auditable — exactly the distinction the author
  requested.
- It provides a stable home for the future Metriplectic uniqueness claim
  without polluting the current proof.

## 4. Connection to the Paper

- Paper §2.7 (Canonicity and Uniqueness of the Minimal Tether) → Claim A
- Paper §3 (Global Regularity as a Corollary) + future metriplectic section → Claim B
- See also the expanded 5-step argument and the explicit mollified proxy
  degeneracy verification in the May 31 2026 merged paper.

## 5. Validation Targets

When the proofs are complete, the following should hold with zero `sorry` in
the novel geometry:

- `#print axioms uniqueness_of_minimal_tether`  → only classical black boxes
- `#print axioms uniqueness_of_global_regular_solutions` (future) → only the
  already-proved Tether uniqueness + the independent majorant + the new
  Metriplectic axioms (if any)

## 6. Future Evolution

After the current proof is kernel-verified and accepted, this skeleton will be
extended with a new subsection describing the precise logical role of the
Metriplectic function in allowing the global regularity statement to "break
down" into a uniqueness claim.

All updates will be synchronized via `scripts/generate_laTeX_lean_relationship.py`
and recorded in `Blueprint.md` under the Clay Panel Audit Mode records.

-/

end FrohmanianTether.Skeleton
