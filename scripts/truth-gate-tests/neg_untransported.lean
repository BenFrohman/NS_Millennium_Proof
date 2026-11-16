/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

import NS_Millennium_Proof.TruthGate

/-!
# neg_untransported

Truth Gate fixture `neg_untransported` (expected: UNTRANSPORTED). Run from the repository root:
`lake env lean scripts/truth-gate-tests/neg_untransported.lean`.
-/

-- Same-file theorem bodies must be available to the gate.
set_option Elab.async false

namespace TGFixture_neg_untransported

def paper_claim : Prop := ∀ n : Nat, n = 0 + n

def formal_claim : Prop := ∀ n : Nat, 0 + n = n

theorem intended_correspondence : formal_claim ↔ paper_claim :=
  ⟨fun h n => (h n).symm, fun h n => (h n).symm⟩

theorem formal_proof : formal_claim := fun n => Nat.zero_add n

theorem paper_holds : paper_claim := fun n => (Nat.zero_add n).symm

end TGFixture_neg_untransported

#eval TruthGate.runTruthGate "scripts/truth-gate-tests/neg_untransported.json" false
