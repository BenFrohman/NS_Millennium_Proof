# TRUTH GATE: read this first

Author: Benjamin Stanley Frohman. This file is the root instruction for every person and every
automated agent (every bot and every chat) that touches this repository. Load it before any other
file. The Truth Gate is the highest and final gate: only true, honestly proved theorems pass it.
**Nothing from this repository is published, released, deposited on Zenodo, cited or claimed
unless the `truth-gate` check is green on the exact commit being cited.**

## The vacuity trap

A paper states its claim in English. Lean can check `formal_claim ↔ paper_claim` only once
`paper_claim` is itself written in Lean. If `paper_claim` were defined to be `formal_claim`, or
unfolded to it, or aliased it, `intended_correspondence` would be `Iff.rfl`: it would prove
nothing, and the gate would pass anything. That is forbidden.

## The lock

* `NS_Millennium_Proof/Semantics.lean` holds, per lock, `formal_claim` (what Lean proves),
  `paper_claim` (an independent transcription of a verbatim quote, whose doc comment carries the
  quote, the paper path, its sha256 and the section) and
  `intended_correspondence : formal_claim ↔ paper_claim`, proved by real reasoning.
* Every public theorem that a paper cites is proved only as
  `intended_correspondence.mp <formal proof>` and has type exactly `paper_claim`.
* Conditional results keep every hypothesis explicit on both sides. Every locked claim here is
  an implication from named hypotheses that remain **open** (the uniform vorticity envelope or
  periodic closing bound, and periodic BKM continuation). No Clay or Millennium problem is
  claimed solved. The kernel certifies only that a proof inhabits the locked proposition.
* `truth-gate.lock.json` records, per lock, the paper path/sha256/section/quote, the sha256 of
  both canonical statements, the formal proof, the public theorems and the shared vocabulary.
  Changing a locked statement needs the author's explicit approval and a new lock.
* **Every `paper_claim` transcription is PENDING AUTHOR APPROVAL** until the author signs off.

## What fails the gate (and therefore `lake build`)

`NS_Millennium_Proof.lean` runs `#eval TruthGate.runTruthGate "truth-gate.lock.json"` during
`lake build`, next to the kernel axiom audit. The build fails on any of:

| code | meaning |
|---|---|
| `NO_SEMANTICS_IMPORT` | the Semantics module is not imported by the root, or not directly by a module declaring a public theorem |
| `MISSING` / `SHAPE` | a lock declaration is missing, or the correspondence is not `formal_claim ↔ paper_claim` |
| `ALIAS` | `paper_claim` reaches a formal-side constant, or shares a project constant with it outside the declared vocabulary |
| `RFL` / `TRIVIAL` | the correspondence is `rfl`/`Iff.rfl`, or the two claims are definitionally equal |
| `SORRY` / `NATIVE_DECIDE` / `AXIOM` | `sorry`/`admit`, `native_decide`, or any axiom beyond `propext`, `Classical.choice`, `Quot.sound` |
| `HASH` / `PAPER_SHA` / `QUOTE` | a locked statement changed, the paper changed, or the quote is not in the paper |
| `UNTRANSPORTED` | a public theorem is not `intended_correspondence.mp <formal proof>` with type `paper_claim` |
| `UNREGISTERED` | some other theorem concludes a headline Clay proposition or a locked claim |
| `DRIFT` | the paper's English claim is not what Lean proves; red until the author decides |

A mismatch keeps the gate red and is reported. It is never patched: never weaken `paper_claim`,
drop a hypothesis, or redefine it to match the formal side.

## Running it

```
lake exe cache get                       # never rebuild Mathlib
lake env lean scripts/SemanticsLock.lean # observation pass + gate + axioms (uncached)
bash scripts/truth-gate-tests/run.sh     # negative fixtures: each broken lock must be red
bash scripts/verify-lock.sh              # everything, including lake build
```

Lake does not hash `truth-gate.lock.json` or the papers, so a locally cached root module can
keep a stale pass; `scripts/SemanticsLock.lean` always re-runs the gate, and CI builds from a
clean checkout.

## Observation first

Before any tactic on a public obligation, or any public text about one, run
`#check NS_Millennium_Proof.Semantics.<Lock>.intended_correspondence` and
`#print NS_Millennium_Proof.Semantics.<Lock>.paper_claim` (step 1 of
`scripts/SemanticsLock.lean`). Public text (titles, abstracts, READMEs, Zenodo records) states
exactly the locked `paper_claim`, the locked commit, the toolchain, the `#print axioms` output and
one rebuild command.
