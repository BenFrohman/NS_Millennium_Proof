---
name: lean-standard-stack
description: Strict harness for a functional Lean 4 environment and for migrating paper proofs into shared open-source Lean communities. Use for any Lean repo setup, Mathlib contribution, lake build, toolchain pin, authorship header, PR, web lookup, or Zulip draft. Triggers: standard stack, elan, lake, InfoView, mathlib PR, lean-toolchain, sorry, Grok Heavy, Zulip.
---

# The standard stack

Follow this skill on every Lean 4 task. Do not improvise a looser workflow.

Author of the mathematics and of every commit this skill produces: Benjamin Stanley Frohman (`Benjamin Stanley Frohman <frohmanbenjamin@gmail.com>`, GitHub @BenFrohman, X.com : Investor0x, Zulip: Benjamin Stanley Frohman). Grok Heavy may scaffold. Grok is not an author, not a `Co-authored-by`, and not an `Authors:` name.

## Environment contract

A working Lean environment is exactly these three pieces. A lone `.lean` file is not an environment.

1. **elan.** The project root has `lean-toolchain`. The editor and `lake` use that pin. Do not float to `stable` inside a pinned project.
2. **Lake.** The folder opened in the editor contains `lakefile.lean` or `lakefile.toml` plus `lean-toolchain`. Create with `lake new Name` or `lake new Name math`. Never edit outside that folder.
3. **Editor.** VS Code with `leanprover.lean4`. Acceptance surface is the InfoView (`Cmd+Shift+Enter` / `Ctrl+Shift+Enter`), not a green syntax highlight.

Before any Mathlib build: `lake exe cache get`, then `lake build`. Skipping the cache is a failure of this skill.

Open the project folder, not a subfolder and not a single file. After a toolchain or dependency change, run `Lean 4: Restart Server`.

## Web, clicks, and real changes

The agent may look things up. It may not pretend a click or a post happened.

- **Web.** Before a community PR, read the live guide: `https://leanprover-community.github.io/contribute/`, the style guide, and the target repo `CONTRIBUTING`. Use search and page fetch. Quote the rule that applies. Do not rely on memory if the page can be opened.
- **Clicks.** There is no logged-in browser driver and no Zulip connector. Do not claim a button was clicked, a form submitted, or a message sent unless a connected tool returned success. A rendered confirm form is not a completed action.
- **Real changes.** Writes go through a connected tool with a recorded result: GitHub branch, file update, or PR only after the user submits the confirm form. Google Drive is file storage, not a Lean host. Do not install VS Code or elan on the author's Mac from chat.

## Zulip comment

Mathlib requires a Zulip discussion before a non-trivial contribution, and forbids LLM-written Zulip or GitHub comments. The author posts in his own words.

Stream: https://leanprover.zulipchat.com/ — channel `#mathlib4` for fit, or the topic channel the guide names. Display name on Zulip: Benjamin Stanley Frohman. GitHub on the profile: BenFrohman.

The agent drafts only. It does not send. Hand the author this skeleton to edit and post:

```
Name: Benjamin Stanley Frohman
GitHub: @BenFrohman

I have a small Lean 4 change for <target>. It <one sentence: what the declaration is>.
The statement is in <file or paper section>. It builds against <lean-toolchain pin>.
I used Grok Heavy to scaffold the transcription from my paper proof; I can defend the design without it.
Is this in scope for mathlib before I open a PR?
```

After he posts, record the message URL in the PR body. If there is no URL, do not open the community PR. A draft in chat is not a Zulip comment.

## Harness

The machine-checked contract is `.grok/skills/lean-standard-stack/StandardStack.lean`. It is the environment theorem, not a claim about Navier–Stokes, Hodge, or any paper theorem. Paper theorems are encoded only in the project modules, and only after they compile.

`the_standard_stack` closes by `decide`. If it does not, the agent stops.

## Paper proof to Lean

- Transcribe from the author's paper. Do not invent a proof the paper does not contain.
- A declaration is done only when `lake build` succeeds on its module and `#print axioms` does not show `sorryAx` for that declaration.
- `sorry` is an explicit hole. Do not wrap a hole in `True`, `True.intro`, or an unproved `axiom` and call it closed.
- Do not claim a Millennium problem, Hodge, Tate, Collatz, or any other open problem is solved unless the corresponding theorem compiles with no `sorryAx`.

## Authorship and copyright

On original Lean files in this repository, the copyright block is exactly:

```lean
/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
```

No trailing period on `Authors:`. No `and`. No AI name on that line.

Every commit message includes:

```
Author: Benjamin Stanley Frohman
GitHub: @BenFrohman
```

If Grok Heavy scaffolded the change, the commit message also says so, in the body, not as `Co-authored-by`. Git author and committer stay `Benjamin Stanley Frohman <frohmanbenjamin@gmail.com>`. Do not rewrite history. Do not force-push `main`.

Own-repo license is Apache-2.0 as in `LICENSE`, with the copyright notice in `COPYRIGHT.md`. That is not a second, incompatible copyright lock.

## Migration into a shared community

Before opening a PR against `leanprover-community/mathlib4` or any other community repo:

1. Read that repo's `CONTRIBUTING`, style guide, naming guide, and AI policy on the web. Those rules win over this skill where they conflict.
2. Draft the Zulip comment above. The author posts it. LLM-written Zulip or GitHub comments are forbidden by Mathlib.
3. Copy the copyright header of a neighboring file in the target repo. Do not invent a private banner. Authorship is the `Authors:` line plus git history. A Mathlib contribution is released under Apache 2.0 as described in Mathlib's `LICENSE`.
4. The author must be able to defend every design choice without an AI. If that is not true, do not open the PR.
5. PR body discloses the tool and how it was used, and links the Zulip thread. If a substantial amount of the diff is LLM-produced, comment `LLM-generated` so the label is applied.
6. Open the PR against the community default branch from a fork, not against the fork's own default branch. Small, self-contained diffs. One logical change.
7. Do not open the PR until `lake build` is clean for the touched modules, style matches the target guide, and imports are the narrowest that compile.

## Stop conditions

Stop and report, do not push, if:

- `lake` or `lean` is not on `PATH` (elan env not sourced).
- The editor is not opened on the project folder.
- `lean-toolchain` does not match the Mathlib revision the lakefile requires.
- A paper claim has no compiling Lean counterpart and the task was to certify it.
- The target repo's AI or authorship rules would be violated by the planned PR.
- A Zulip or GitHub comment would be posted by the agent rather than by Benjamin Stanley Frohman.
- A click, install, or send is claimed without a tool result that says it happened.
