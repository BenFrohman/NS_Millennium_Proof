/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import TFFrohmanianTether.Basic

/-!
# Semantics lock: the displayed TF 2-form is not antisymmetric

## paper_claim source (verbatim)

File: Drive `vFinal.txt` (May 21, 2026),
sha256 `d5b6508eca165379bebd46185557cef5fc7864a94a8bc39d73aec142361e6c05`,
abstract and §5, displayed equations (5)–(6):

> "We derive the Frohmanian Symplectic Tether TF as the canonical minimal
> bilinear antisymmetric correction to Arnold’s Lie–Poisson bracket on the
> coadjoint orbit of volume-preserving diffeomorphisms."

> "The full tethered bracket is
>  {F, G}TF = {F, G}classical + B(F, G)."

> "The associated 2-form is
>  TF (δ u, δ v) = ∫_{T³} ω · (δ u × δ v) dλ − κ ∫_{T³} |ω|² (δ u · δ v) dλ."

The same associated 2-form (without the projection `Π_u` in the second
integral) appears in the May 14 papers
`Frohmanian_Symplectic_Tether_Theorem_Proof_Clean_v1.tex`
(sha256 `98717d941535df4d96d9fa18b6367c3de6350212a112ab09458c0a47bea026ff`)
and in `Full_Living_May24.md` §2.3
(sha256 `384270d1e4411d4546b569f963068b7d30f0dd60f51138e₃e₃6f09629749c824`).

The English claim transcribed here is that this displayed associated
2-form (equivalently, its pointwise density) is bilinear and antisymmetric.
A form that fails to be antisymmetric at even one point cannot be an
antisymmetric 2-form after integration either.

## Transcription (written directly from the quotes; does not mention formal_claim)

For every real `κ` and every vectors `ω, δu, δv` in `Fin 3 → ℝ`, the displayed
density `ω · (δu × δv) − κ |ω|² (δu · δv)` equals the negative of the
same density with `δu` and `δv` swapped.

## formal_claim

What the Lean development proves about this proposition: it is equivalent
to `False`. Author approval of the transcription: PENDING.
-/

namespace TFFrohmanianTether

/-- Literal transcription of the displayed-2-form antisymmetry claim. -/
def paper_claim : Prop :=
  ∀ (κ : ℝ) (ω δu δv : Fin 3 → ℝ),
    TF κ ω δu δv = - TF κ ω δv δu

/-- What is proved: the claim is false. -/
def formal_claim : Prop := False

/-- Proved by the explicit witness in `TF_not_antisymmetric`
(not by `Iff.rfl`). -/
theorem intended_correspondence : formal_claim ↔ paper_claim := by
  constructor
  · intro h; exact h.elim
  · intro h
    exact (TF_not_antisymmetric h).elim

theorem paper_claim_refuted : ¬ paper_claim :=
  TF_not_antisymmetric

end TFFrohmanianTether
