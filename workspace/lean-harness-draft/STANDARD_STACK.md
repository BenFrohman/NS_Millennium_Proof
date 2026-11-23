# The Standard Stack

Author: Benjamin Stanley Frohman · DRAFT for review

Sources: extracted from `.grok/skills/lean-standard-stack/SKILL.md`,
`.grok/skills/lean-standard-stack/StandardStack.lean`,
`.grok/skills/frohmanian-lean-encoding/SKILL.md`, `CONTRIBUTING.md`,
`.github/PULL_REQUEST_TEMPLATE.md`, `.github/workflows/lean.yml`, and `lakefile.lean`
in `BenFrohman/NS_Millennium_Proof` (origin/main `a52c4d8`).
Tags: **[found]** = stated in those files. **[inferred]** = my wording of a rule implied but not written there.

## 1. Environment contract
1. **elan** — project root has `lean-toolchain`; editor and `lake` both use that pin. Do not float to `stable` in a pinned project. [found]
2. **Lake** — the folder opened in the editor contains `lakefile.lean`/`lakefile.toml` and `lean-toolchain`. Create with `lake new Name` or `lake new Name math`. A lone `.lean` file is not an environment. [found]
3. **Editor** — VS Code + `leanprover.lean4`. Acceptance surface is the InfoView, not syntax highlighting. Open the project folder, not a subfolder or a file. Run `Lean 4: Restart Server` after toolchain/dependency changes. [found]
4. Before any Mathlib build: `lake exe cache get`, then `lake build`. [found]

## 2. Toolchain pinning
- `lean-toolchain` and the Mathlib `rev` in the lakefile must match (current: Lean `v4.30.0-rc1`, Mathlib tag `v4.30.0-rc1`). Mismatch is a stop condition. [found]
- Pin Mathlib by tag or commit, never a moving branch. [inferred from the pinned `@ "v4.30.0-rc1"` require]
- Commit `lake-manifest.json`. [inferred; CI checks it exists]

## 3. Authorship
- Original Lean files start with exactly:
  ```
  /-
  Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
  Released under Apache 2.0 license as described in the file LICENSE.
  Authors: Benjamin Stanley Frohman
  -/
  ```
  No trailing period on `Authors:`, no `and`, no AI name. [found]
- Git author and committer: `Benjamin Stanley Frohman <frohmanbenjamin@gmail.com>`. [found]
- **No `Co-authored-by:` trailers for any AI model or tool.** AI assistance, if any, is disclosed in the commit/PR body, not as co-authorship. [found]
- Do not rewrite published history or force-push `main`. [found]
- Add a name to `Authors:` only if that person authored or substantially edited the module. [found]

## 4. Green-build gate
- A declaration is done only when `lake build` succeeds on its module **and** `#print axioms <decl>` does not show `sorryAx`. [found]
- Acceptable axioms: `propext`, `Classical.choice`, `Quot.sound`. [found] Anything else (custom `axiom`, `Lean.trustCompiler` via `native_decide`) fails the gate. [found for trustCompiler in lakefile comment; general rule inferred]
- No `sorry` on any completed claim. `sorry` is an explicit hole; never disguise it as `True`, `True.intro`, or an unproved `axiom`. [found]
- Do not claim an open problem is solved unless its theorem compiles without `sorryAx`. [found]

## 5. Pin-and-cite (classical results)
- Classical results not yet in Mathlib (e.g. Kato, BKM) stay as **named, explicit hypotheses** until transcribed — never `sorry`ed into `True`, never assumed as their own conclusions. [found]
- Never add a classical result as a global `axiom`. [found in spirit ("unproved `axiom`" forbidden); explicit wording inferred]
- Each such hypothesis or use of a Mathlib lemma is documented with: source (author, title, year, theorem number) and the Mathlib lemma name when one exists. [inferred — the phrase "pin-and-cite" does not appear in the repo]

## 6. Community migration (Mathlib PRs)
Read the target repo's CONTRIBUTING, style, naming, and AI policy (they win on conflict); discuss on Zulip in your own words; disclose AI use in the PR body and apply `LLM-generated` where required; small single-change PRs from a fork; build clean first. [found]

## 7. Stop conditions
Stop and report (do not push) if `lake`/`lean` is not on PATH; editor not on the project folder; toolchain ≠ Mathlib rev; a claim to certify has no compiling counterpart; target repo's AI/authorship rules would be violated. [found]
