#!/usr/bin/env python3
# Author: Benjamin Stanley Frohman
# Generates the Truth Gate fixture modules and lock files (one per case).
import hashlib, json, os
HERE = os.path.dirname(os.path.abspath(__file__))
HDR = """/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

import NS_Millennium_Proof.TruthGate

/-!
# {case}

Truth Gate fixture `{case}` (expected: {expect}). Run from the repository root:
`lake env lean scripts/truth-gate-tests/{case}.lean`.
-/

-- Same-file theorem bodies must be available to the gate.
set_option Elab.async false
"""
GOOD_PAPER = "def paper_claim : Prop := ∀ n : Nat, n = 0 + n"
FORMAL = "def formal_claim : Prop := ∀ n : Nat, 0 + n = n"
CORR = "theorem intended_correspondence : formal_claim ↔ paper_claim :=\n  ⟨fun h n => (h n).symm, fun h n => (h n).symm⟩"
FPROOF = "theorem formal_proof : formal_claim := fun n => Nat.zero_add n"
PUB = "theorem paper_holds : paper_claim := intended_correspondence.mp formal_proof"
CASES = {
  "good": ("PASS", [GOOD_PAPER, FORMAL, CORR, FPROOF, PUB], {}),
  "neg_rfl": ("RFL, TRIVIAL",
    ["def paper_claim : Prop := ∀ n : Nat, 0 + n = n", FORMAL,
     "theorem intended_correspondence : formal_claim ↔ paper_claim := Iff.rfl", FPROOF, PUB], {}),
  "neg_alias": ("ALIAS, TRIVIAL",
    [FORMAL, "def paper_claim : Prop := formal_claim",
     "theorem intended_correspondence : formal_claim ↔ paper_claim := ⟨fun h => h, fun h => h⟩",
     FPROOF, PUB], {}),
  "neg_sorry": ("SORRY",
    [GOOD_PAPER, FORMAL, "theorem intended_correspondence : formal_claim ↔ paper_claim := by sorry",
     FPROOF, PUB], {}),
  "neg_axiom": ("AXIOM",
    [GOOD_PAPER, FORMAL, "axiom cheat : ∀ p : Prop, p",
     "theorem intended_correspondence : formal_claim ↔ paper_claim := cheat _", FPROOF, PUB], {}),
  "neg_native_decide": ("NATIVE_DECIDE",
    [GOOD_PAPER, FORMAL, CORR,
     "theorem formal_proof : formal_claim := fun n => by\n  have : (2 : Nat) + 2 = 4 := by native_decide\n  exact Nat.zero_add n",
     PUB], {}),
  "neg_untransported": ("UNTRANSPORTED",
    [GOOD_PAPER, FORMAL, CORR, FPROOF,
     "theorem paper_holds : paper_claim := fun n => (Nat.zero_add n).symm"], {}),
  "neg_paper_sha": ("PAPER_SHA", [GOOD_PAPER, FORMAL, CORR, FPROOF, PUB], {"sha256": "0" * 64}),
  "neg_quote": ("QUOTE", [GOOD_PAPER, FORMAL, CORR, FPROOF, PUB],
    {"quote": "for every natural number n, n equals n + 0."}),
  "neg_drift": ("DRIFT", [GOOD_PAPER, FORMAL, CORR, FPROOF, PUB], {"status": "drift"}),
}
paper = os.path.join(HERE, "paper.txt")
sha = hashlib.sha256(open(paper, "rb").read()).hexdigest()
hashes = json.load(open(os.path.join(HERE, "claim-hashes.json"))) if os.path.exists(
    os.path.join(HERE, "claim-hashes.json")) else {}
for case, (expect, decls, over) in CASES.items():
    ns = "TGFixture_" + case
    src = HDR.format(case=case, expect=expect) + f"\nnamespace {ns}\n\n" + "\n\n".join(decls) + \
        f"\n\nend {ns}\n\n#eval TruthGate.runTruthGate \"scripts/truth-gate-tests/{case}.json\" false\n"
    open(os.path.join(HERE, case + ".lean"), "w").write(src)
    h = hashes.get(case, {})
    lock = {"id": case, "namespace": ns, "status": over.get("status", "locked"),
            "paper": {"path": "scripts/truth-gate-tests/paper.txt", "sha256": over.get("sha256", sha),
                      "section": "Section 1",
                      "quote": over.get("quote", "for every natural number n, n equals 0 + n.")},
            "formal_proof": f"{ns}.formal_proof", "shared_vocabulary": [],
            "public": [f"{ns}.paper_holds"],
            "drift": "fixture: paper and Lean disagree" if over.get("status") == "drift" else "",
            "paper_claim_sha256": h.get("paper", ""), "formal_claim_sha256": h.get("formal", "")}
    json.dump({"schema": 1, "locks": [lock], "expect": expect}, open(os.path.join(HERE, case + ".json"), "w"),
              indent=2, ensure_ascii=False)
print("generated", len(CASES), "fixtures")
