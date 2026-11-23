/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import TwoLayerT3.Tether

/-!
# Semantics lock: the "combination" claim (does B_F supply a sink along real NS dynamics?)

## paper_claim source (verbatim)
File: `sources/drive/ns-proof-written.tex` (Google Drive id 1tkVgQm1cscSki3g8fHzGqMJGDhBpJRlW),
sha256 72b18b9787ed69458d86cf4e558092e5127d898b9f1a0b43dde7868d255fbfcf,
eq. (bf) and §"The cubic comparison field":

> "The tether is the symmetric metric kernel
>  B_F(F,G)=-\kappa\int|\omega|^2\,(\Pi_u\delta F\cdot\Pi_u\delta G)\,dV.
>  Here \(\Pi_u\) is the \(L^2\) projection orthogonal to the kinetic-energy direction \(u\)."
> "\kappa=C_{CZ}(3)=\frac32."
> "Apply \(B_F\) at the value \eqref{eq:kappa} to the stretching rate ... What remains is a
>  cubic sink ... \(\kappa''>0\) is the coefficient of the sink retained by \(B_F\)."

Dynamics in which B_F enters the rate of a functional F (Full_Living_May24.md §5,
sha256 384270d1e4411d4546b569f963068b7d30f0dd60f51138e2e26f09629749c824):
> "dF/dt = \{F, H\}_{\mathfrak{T}_F} + [F, H]_{\rm diss}"
so the tether's contribution to dF/dt is B_F(F,H), with δH = u (kinetic-energy direction).

## Transcription (written directly from the quotes; does not mention formal_claim)
There are a state u ∈ L²(𝕋³;ℝ³), a nonnegative weight operator W (multiplication by |ω|²),
κ = 3/2 and a functional derivative δF such that the B_F-contribution to dF/dt is a strict
sink: −κ ⟪Π_u δF, W(Π_u u)⟫ < 0, where Π_u g = g − (⟪g,u⟫/⟪u,u⟫) u.

## formal_claim
What the Lean development proves about this proposition: it is equivalent to `False`.
Approval of the transcription by the author: PENDING (lock not author-approved yet).
-/

open scoped InnerProductSpace

namespace TwoLayerT3

/-- Literal transcription of the paper's claim (see module doc). -/
def paper_claim : Prop :=
  ∃ (κ : ℝ) (W : L2Field →L[ℝ] L2Field) (u δF : L2Field),
    κ = 3 / 2 ∧ (∀ x : L2Field, 0 ≤ ⟪x, W x⟫_ℝ) ∧
    -κ * ⟪δF - (⟪δF, u⟫_ℝ / ⟪u, u⟫_ℝ) • u, W (u - (⟪u, u⟫_ℝ / ⟪u, u⟫_ℝ) • u)⟫_ℝ < 0

/-- What is proved: the claim is false. -/
def formal_claim : Prop := False

/-- Proved by the degeneracy computation Π_u u = 0 (not by `Iff.rfl`). -/
theorem intended_correspondence : formal_claim ↔ paper_claim := by
  constructor
  · intro h; exact h.elim
  · rintro ⟨κ, W, u, δF, -, -, hneg⟩
    have h0 : tetherForm κ W u δF u = 0 := tether_degenerate κ W u δF
    have h1 : tetherForm κ W u δF u =
        -κ * ⟪δF - (⟪δF, u⟫_ℝ / ⟪u, u⟫_ℝ) • u, W (u - (⟪u, u⟫_ℝ / ⟪u, u⟫_ℝ) • u)⟫_ℝ := rfl
    rw [h1] at h0
    exact absurd hneg (by rw [h0]; exact lt_irrefl 0)

/-- **Verdict theorem**: the paper's combination claim is refuted. -/
theorem paper_claim_refuted : ¬ paper_claim := fun h => intended_correspondence.mpr h

end TwoLayerT3
