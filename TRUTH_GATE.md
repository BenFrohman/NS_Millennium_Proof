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

## The locked claims (PENDING AUTHOR APPROVAL)

Primary paper: PAPER_PATH `main.tex`, PAPER_SHA256 `bca0d13a99d759f256dd0c31e421b6f18b2c12e0f1bb7d3afc094d90bb8539c0`.

### `EnvelopeReduction` (LOCKED)

* paper: `docs/VorticityEnvelopeCorrection.tex`, sha256 `e35cbb8274d914297828e67fd748968cb4ef56a22bd8bd4a482e7d7f0cb633a7`
* section: §2 The checked conditional consequences
* public theorem(s): `FrohmanianTether.HighSetDepletionAndBKM.clay_reduces_to_uniform_vorticity_envelope`

Verbatim quote:

```
conditional reduction: the uniform envelope for every positive viscosity,
\emph{and} the separately assumed periodic BKM continuation principle, imply
\lean{Clay_B_exact}.
```

### `DirectionCurvatureReduction` (LOCKED)

* paper: `main.tex`, sha256 `bca0d13a99d759f256dd0c31e421b6f18b2c12e0f1bb7d3afc094d90bb8539c0`
* section: Abstract
* public theorem(s): `FrohmanianTether.HighSetDepletionAndBKM.clay_reduces_to_direction_curvature_bound`

Verbatim quote:

```
assuming \lean{PeriodicBKMContinuation}~$\nu$ for every $\nu>0$, the hypothesis \lean{DirectionCurvatureBound}~$\nu$ for every $\nu>0$ implies \lean{Clay_B_exact}. Here \lean{DirectionCurvatureBound} is an abbreviation for \lean{UniformVorticityEnvelopeBound}, an \emph{assumed} uniform ceiling on $\|\omega(t)\|_\infty$ along periodic smooth solutions (not a differential inequality)
```

### `PeriodicTetherReduction` (LOCKED)

* paper: `main.tex`, sha256 `bca0d13a99d759f256dd0c31e421b6f18b2c12e0f1bb7d3afc094d90bb8539c0`
* section: §The Periodic Clay (B) Statement and Scaling Analysis (sec:clay)
* public theorem(s): `FrohmanianTether.ClayStatements.clay_B_exact_of_periodic_tether_bound`

Verbatim quote:

```
The reduction from \lean{Clay_B_exact} to the periodic closing bound \lean{PeriodicTetherClosingBound} and classical periodic BKM continuation \lean{PeriodicBKMContinuation} is proved axiom-clean
```

### `ConditionalGlobalRegularity` (LOCKED)

* paper: `main.tex`, sha256 `PAPERSHA`
* section: §1 Introduction, Theorem 1.1 (thm:main)
* formal proof: `CeilingFromRate.conditional_global_regularity_with_ceiling`
* public theorem(s): `CeilingFromRate.theorem_1_1`
* scope: conditional on a Kato witness, the cubic rate (R) for the ONE given datum (open for every
  nonzero datum), BKM continuation (C) and uniqueness (U); hypotheses jointly satisfiable at
  `u₀ = 0` (`CeilingFromRate.hypotheses_jointly_satisfiable_at_zero`). Replaces the former DRIFT
  wording of Theorem 1.1 (see `CHANGELOG.md`).

Verbatim quote:

```
Then there is a velocity field $u$ with $u(0)=u_0(0)$ that is spatially $C^\infty$ for every $t\ge0$, is a physical solution of \lean{navier_stokes_eq} with viscosity $\nu$ for some pressure, satisfies $M(t)\le\max\bigl(M(0),C/\kappa''\bigr)$ for every $t\ge0$ for some constants $C>0$ and $\kappa''>0$, and agrees at every $t\ge0$ with every velocity field $v$ that has $v(0)=u_0(0)$, is spatially $C^\infty$ for every $t\ge0$, and is a physical solution of \lean{navier_stokes_eq} with viscosity $\nu$ for some pressure.
```

### `TetherTheorem` (LOCKED)

* paper: `main.tex`, sha256 `PAPERSHA`
* section: §1 Introduction, Proposition prop:hDI
* formal proof: `TetherRateCounterexample.frohmanian_tether_theorem_hDI_unsatisfiable`
* public theorem(s): `TetherRateCounterexample.all_data_rate_hypothesis_unsatisfiable`
* scope: a negative result about the all-data rate hypothesis `hDI` of
  `frohmanian_tether_theorem` (which is therefore vacuous); the witness is not a classical
  Navier–Stokes solution. Replaces the former DRIFT attribution (see `CHANGELOG.md`).

Verbatim quote:

```
It is not the case that for every velocity field $u_0$ and every $\nu\in\mathbb{R}$ the following holds: for every $(u,p)$ with $\nu>0$, \lean{NS_PDE}~$u$~$p$~$\nu$, $u(0)=u_0$ and \lean{IsPhysicalNSSolution}~$u$, the map $t\mapsto M(t)$ is continuous on $\mathbb{R}$, $x\mapsto|\omega(u(t))(x)|$ is bounded above for every $t\ge0$, and there are constants $C>0$ and $\kappa''>0$ such that for every $s\ge0$ the map $t\mapsto M(t)$ is differentiable at $s$ with $M'(s)\le C\,M(s)^2-\kappa''\,M(s)^3$.
```

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
