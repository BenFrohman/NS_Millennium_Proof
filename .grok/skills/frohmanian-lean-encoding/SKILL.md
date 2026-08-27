---
name: frohmanian-lean-encoding
description: Lean 4 encoding rules for the Frohmanian Symplectic Tether NS proof in NS_Millennium_Proof. Use when filling sorrys, closing lemmas, committing, or claiming a Lean certificate. Triggers: frohmanian, tether, sorryAx, lake build, #print axioms, NS_Millennium_Proof.
---

# Frohmanian Lean encoding

Work in `/Users/inv0x/lean-projects/NS_Millennium_Proof/.worktrees/kernel-cohesive-tether-kappa-bkm` on `kernel/cohesive-tether-kappa-bkm`. Do not spawn a dozen isolated-worktree agents onto this branch.

## Non-negotiable

- Lean 4 only. No `begin`/`end`, no `have …, from`, no `show …, from`, no `structure :=`.
- Never `True.intro` / `True` gates. Never fake-close `frohmanian_tether_theorem`.
- Never rewrite published git history. Never `Co-authored-by: Grok`.
- Authorship: `Authors: Benjamin Stanley Frohman`. Git: `Benjamin Stanley Frohman <frohmanbenjamin@gmail.com>`, SSH sign. GitHub @BenFrohman. X.com : Investor0x.
- Certificate = `#print axioms frohmanian_tether_theorem` lists `propext`, `Classical.choice`, `Quot.sound` and **not** `sorryAx`.

## Honest fills

- Antisymmetry of an arbitrary `B` does not imply degree two. Use `step2_degree` on `TetherKernel` / canonical density.
- `δH = u` is the velocity pairing `∫⟨u, Kε⟩`. Do not identify that with vorticity pairing `∫⟨δ, ε.val⟩` unless proved.
- Euler energy needs **both** convective IBP and pressure IBP **and** the Euler momentum equation. Div-free alone is not conservation.
- Haar on `ℝ³` is not finite-measure `𝕋³`. Finite-measure Hölder needs an extra hyp; do not pretend Lebesgue volume is finite.
- Kato / BKM stay named remainders until transcribed. Do not `sorry` them into `True`.

## After a closed lemma

`lake build` the module. `#print axioms` the lemma. Commit signed as Frohman. Append `HISTORY.md`. Push to PR #8 only after the build is green.
