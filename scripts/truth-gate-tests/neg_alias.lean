/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

import NS_Millennium_Proof.TruthGate

/-! Truth Gate fixture `neg_alias` (expected: ALIAS, TRIVIAL). Run from the repository root:
`lake env lean scripts/truth-gate-tests/neg_alias.lean`. -/

-- Same-file theorem bodies must be available to the gate.
set_option Elab.async false

namespace TGFixture_neg_alias

def formal_claim : Prop := ∀ n : Nat, 0 + n = n

def paper_claim : Prop := formal_claim

theorem intended_correspondence : formal_claim ↔ paper_claim := ⟨fun h => h, fun h => h⟩

theorem formal_proof : formal_claim := fun n => Nat.zero_add n

theorem paper_holds : paper_claim := intended_correspondence.mp formal_proof

end TGFixture_neg_alias

#eval TruthGate.runTruthGate "scripts/truth-gate-tests/neg_alias.json" false
