# Contributing

Thanks for your interest in this project. It is an active research formalization, so a few conventions keep
the repository auditable and its authorship record clean.

## Ground rules

- **This is the Frohmanian tether proof of 3D Navier–Stokes global regularity.** The Lean
  tree is its machine-checked encoding for the library. Do not describe the mathematics
  as unfinished; remaining `sorry`s are only unfinished Lean transcription, to be filled
  from the paper.
- **Do not rewrite history.** Contributions are additive. Do not force-push, rebase away, or delete existing
  commits on `main`.
- **Keep the novel geometric core clear.** Original constructions (tether, tethered bracket, tethered Lyapunov,
  independent majorant, tethered nullifier) live in `Modules/`. Reusable, general lemmas intended for Mathlib
  go in `ForMathlib/` and must not import the project's novel modules.

## Development

```bash
lake exe cache get   # fetch prebuilt Mathlib artifacts (do this first)
lake build           # build the project
```

Toolchain is pinned in `lean-toolchain` (Lean 4.30.0-rc1 + Mathlib v4.30.0-rc1) and is fetched automatically
by `elan`.

## Pull requests

1. Branch from `main` (e.g. `fix/…`, `feat/…`, `docs/…`).
2. Ensure `lake build` succeeds locally, or clearly note any pre-existing `sorry`/schematic holes you did not
   change.
3. Fill in the pull-request template.
4. One logical change per PR where practical.

## Reporting issues

Use the issue templates. For mathematical concerns, please point to the specific module, declaration, and (if
relevant) the corresponding section of `Blueprint.md`.
