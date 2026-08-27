# Contributing

This repository is Benjamin Stanley Frohman's Frohmanian tether proof and its Lean 4
encoding. Remaining Lean transcription is author-only (with the Grok encoding
collaboration recorded in the disclaimer). Do not open issues or PRs to fill
`sorry`s, invent TODOs, or take credit for classical boxes. Conventions below
keep the authorship record clean.

## Ground rules

- **This is the Frohmanian tether proof of 3D Navier–Stokes global regularity.** The Lean
  tree is its machine-checked encoding for the library. Do not describe the mathematics
  as unfinished; remaining `sorry`s are only unfinished Lean transcription, to be filled
  from the paper.
- **AI collaboration.** The Lean encoding was compiled with an AI assistant (Grok, xAI) from
  Benjamin Stanley Frohman's paper proofs. That does not change authorship of the mathematics.
- **Do not rewrite history.** Contributions are additive. Do not force-push, rebase away, or delete existing
  commits on `main`. Git author aliases are canonicalized in `.mailmap` instead of amending old commits.
- **Keep the novel geometric core clear.** Original constructions (tether, tethered bracket, tethered Lyapunov,
  independent majorant, tethered nullifier) live in `Modules/`. Reusable, general lemmas intended for Mathlib
  go in `ForMathlib/` and must not import the project's novel modules.

## Authorship (Lean 4 / mathlib4 / Zulip)

This repository follows [mathlib4's copyright and `Authors:` conventions](https://leanprover-community.github.io/contribute/style.html)
so modules stay attributable if they are discussed on the Lean Zulip, opened as Mathlib PRs, or reused
downstream.

1. **Five-line header** on original Lean files (precisely these five lines; no extra prose in the copyright block):

   ```lean
   /-
   Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
   Released under Apache 2.0 license as described in the file LICENSE.
   Authors: Benjamin Stanley Frohman
   -/
   ```

   - Keep `Authors:` even for a single author.
   - No trailing period on the `Authors:` line.
   - No `and` before the last name.
   - Names are the people you would ping on the Lean Zulip.
   - Add a name to a file's `Authors:` line **only** if that person authored or substantially edited that module.

2. **Git identity.** Use `Benjamin Stanley Frohman <frohmanbenjamin@gmail.com>` for new commits.
   Do not rewrite existing commits. `.mailmap` maps historical handles (`Frohmanian`, `BenFrohman`) to that name.

3. **Pull requests.** GitHub [inbound=outbound](https://docs.github.com/en/site-policy/github-terms/github-terms-of-service#6-contributions-under-repository-license)
   applies. If the git author on a PR is a handle rather than the `Authors:` name, comment on the PR:

   ```
   Author: Benjamin Stanley Frohman
   GitHub: @BenFrohman / @Investor0x
   Zulip: Benjamin Stanley Frohman
   ```

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
3. Fill in the pull-request template, including the authorship checklist.
4. One logical change per PR where practical.

## Reporting issues

Use the issue templates. For mathematical concerns, please point to the specific module, declaration, and (if
relevant) the corresponding section of `Blueprint.md`.
