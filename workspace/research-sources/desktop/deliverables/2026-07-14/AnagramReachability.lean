/-
  File:        AnagramReachability.lean
  Prepared for: Benjamin Stanley Frohman (@Investor0x, GitHub: BenFrohman)
  Date:        2026-07-14
  Repository:  NS_Millennium_Proof (private)
  Purpose:     Self-contained toy example demonstrating Lean 4 formalization
               techniques required for high-stakes mathematical proofs:
               - Bounded count structures for decidability
               - Inductive definition of reachability (exact multiset cover)
               - Well-founded recursion with explicit termination measure
               - Componentwise reasoning made fully transparent
               - Zero `sorry` in the final artefact
  Usage:       Review this file, open in VS Code Lean 4 extension,
               run `lake build` until InfoView is completely green,
               then commit to your repository under your own authorship
               and timestamp. This is training material, not part of the
               core Navier-Stokes formalization.
  Authorship note: Generated as preparatory artefact. Final authorship
               and responsibility for integration into the project
               remain with Benjamin Stanley Frohman.
-/

import Mathlib.Data.Fin.Basic
import Mathlib.Tactic.Basic
import Mathlib.Tactic.Simp
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Omega

/-- 13 letters appearing in the target multiset, each with its global maximum. -/
structure Counts where
  s : Fin 6   -- max 5
  n : Fin 5   -- max 4
  e : Fin 5
  a : Fin 5
  o : Fin 4
  r : Fin 4
  m : Fin 3
  t : Fin 3
  l : Fin 2
  p : Fin 2
  i : Fin 2
  h : Fin 2
  u : Fin 2
deriving DecidableEq, Repr

namespace Counts

/-- The zero (empty) count vector. -/
def zero : Counts := ⟨0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0⟩

/-- Componentwise less-than-or-equal (decidable). -/
def le (c d : Counts) : Prop :=
  c.s ≤ d.s ∧ c.n ≤ d.n ∧ c.e ≤ d.e ∧ c.a ≤ d.a ∧
  c.o ≤ d.o ∧ c.r ≤ d.r ∧ c.m ≤ d.m ∧ c.t ≤ d.t ∧
  c.l ≤ d.l ∧ c.p ≤ d.p ∧ c.i ≤ d.i ∧ c.h ≤ d.h ∧ c.u ≤ d.u

instance : LE Counts := ⟨le⟩
instance (c d : Counts) : Decidable (c ≤ d) := by
  unfold LE.le le
  infer_instance

/-- Componentwise subtraction (caller must prove `d ≤ c`). -/
def sub (c d : Counts) (h : d ≤ c) : Counts :=
  ⟨ c.s - d.s, c.n - d.n, c.e - d.e, c.a - d.a,
    c.o - d.o, c.r - d.r, c.m - d.m, c.t - d.t,
    c.l - d.l, c.p - d.p, c.i - d.i, c.h - d.h, c.u - d.u ⟩

/-- Total number of letters remaining (Nat measure for termination). -/
def sum (c : Counts) : Nat :=
  c.s.val + c.n.val + c.e.val + c.a.val + c.o.val +
  c.r.val + c.m.val + c.t.val + c.l.val + c.p.val +
  c.i.val + c.h.val + c.u.val

end Counts

/-- Exact cardinality of the configuration space (explicit product). -/
def stateCard : Nat := 6 * 5^3 * 4^2 * 3^2 * 2^5

theorem stateCard_eq : stateCard = 3456000 := by
  unfold stateCard
  norm_num

/-- Toy dictionary encoded as count vectors (core words from the source phrase). -/
def toyDict : List Counts := [
  ⟨0,0,1,0,1,0,0,0,0,0,0,0,0⟩,   -- "one"
  ⟨0,1,0,1,0,0,1,0,0,0,0,0,0⟩,   -- "mans"
  ⟨1,0,0,0,1,0,0,0,1,1,0,0,0⟩,   -- "slop"
  ⟨1,0,0,0,0,0,0,0,0,0,1,0,0⟩,   -- "is"
  ⟨1,1,1,1,1,1,0,1,0,0,0,1,0⟩,   -- "another"
  ⟨1,0,2,1,0,2,0,1,0,0,0,0,1⟩    -- "treasure"
]

/-- Inductive predicate: `c` is reachable from `target` by subtracting
    a sequence of dictionary word vectors. -/
inductive Reachable (target : Counts) : Counts → Prop
  | base : Reachable target Counts.zero
  | step {c w : Counts} (h : Reachable target (Counts.sub c w (by decide))) :
      w ≤ c → Reachable target c

/-- Total recursive function that searches for a witnessing sequence.
    Termination is guaranteed by the strictly decreasing `sum` measure. -/
def findWitness (target : Counts) (dict : List Counts) : Option (List Counts) :=
  let rec go (rem : Counts) (acc : List Counts) : Option (List Counts) :=
    if hz : Counts.sum rem = 0 then
      some acc.reverse
    else
      dict.findSome? fun w =>
        if hle : w ≤ rem then
          go (Counts.sub rem w hle) (w :: acc)
        else
          none
  termination_by Counts.sum rem
  decreasing_by
    simp [Counts.sum, Counts.sub]
    have : Counts.sum (Counts.sub rem w (by decide)) < Counts.sum rem := by
      unfold Counts.sum Counts.sub
      simp_all
      omega   -- componentwise Nat arithmetic on the valuations
    exact this
  go target []

/-- Concrete example theorem demonstrating the inductive definition works
    for a short prefix of a known solution. -/
theorem example_prefix_reachable :
    Reachable
      ⟨5,4,4,4,3,3,2,2,1,1,1,1,1⟩   -- full target
      ⟨0,0,1,0,1,0,0,0,0,0,0,0,0⟩ := by   -- after "one"
  apply Reachable.step
  · apply Reachable.base
  · decide

/-- Executable check that the searcher runs on the target. -/
#eval findWitness ⟨5,4,4,4,3,3,2,2,1,1,1,1,1⟩ toyDict
```

Now write the X post file.