/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

import NS_Millennium_Proof.TruthGate

/-!
# neg_unformalized_public

Truth Gate fixture `neg_unformalized_public` (expected: SHAPE: an unformalized lock may not export a public theorem). Run from the repository root:
`lake env lean scripts/truth-gate-tests/neg_unformalized_public.lean`.
-/

-- Same-file theorem bodies must be available to the gate.
set_option Elab.async false

namespace TGFixture_neg_unformalized_public

def paper_claim : Prop := ∀ n : Nat, n = 0 + n

theorem paper_holds : paper_claim := fun n => (Nat.zero_add n).symm

end TGFixture_neg_unformalized_public

#eval TruthGate.runTruthGate "scripts/truth-gate-tests/neg_unformalized_public.json" false
