#!/usr/bin/env python3
# usage: reopen.py GATE_DIR REPO_KEY  (edits checker, lock and TRUTH_GATE.md in GATE_DIR; copies md to extra paths)
import json, os, sys, re
R = {
"frohmanian-tether-verified": dict(
 claim="flow_contribution_zero_of_C2 (Section 5 \"Refuted claims\", item \"The tether damps the energy budget\")",
 reason=[
  "Tautology, not a step. `DegenerateWRTKineticEnergy B` (C2) is defined as `∀ F ω, B ω F KineticEnergyHamiltonian = 0`, and the locked main theorem `flow_contribution_zero_of_C2` is the term `hC2 M ω`. It restates its own hypothesis, so the lock certifies nothing beyond the definition.",
  "Not the paper's main result and not a step on a path to it. The quote is one item of the paper's \"Refuted claims\" audit list. A refutation prunes a path; it is not a step that the next step can build from.",
  "Stand-in naming. `CoadjointOrbit` is the type of all divergence-free fields (`val`, `property : div val = 0`). No orbit structure is built, and the `SDiff` action is abstract (`[MulAction SDiff CoadjointOrbit]`).",
 ],
 fix="Record the refutation as a pruned path, not as a lock. A lock here needs a stated theorem of the paper on the path to its main result, with its hypotheses not true by definition."),
"frohmanian-tether-sdiff": dict(
 claim="clay_B_exact_of_periodic_tether_bound (Theorem thm:mainA)",
 reason=[
  "The hypotheses are not independently transcribed. `paper_claim` keeps the repository Props `PeriodicTetherClosingBound` and `PeriodicBKMContinuation` as named Props, although the paper gives a precise English definition (def:ptb). The hypotheses carry the whole difficulty, so the lock leans on repository definitions exactly where it matters.",
  "Stand-in naming. By its definition, the \"Frohmanian tether bound\" is the plain uniform bound `‖ω(t)‖_∞ ≤ Y` over all classical periodic solutions on all `[0,T)`. Nothing tether-specific enters, and the repository's own docstring says \"the Frohmanian assembly contributes no step that BKM does not\". The name presents an open vorticity bound as a tether result.",
  "Non-vacuity is not certified. The bound is open and as strong as Statement (B), and there is no witness. Neither the bound nor its satisfiability is shown.",
 ],
 fix="Either re-lock with an independent transcription of both hypotheses from the paper's English, naming the bound honestly as a uniform vorticity bound (as in BenFrohman/Clay-), or retire this lock in favour of the Clay- reduction."),
"frohmanian-strain-eigenvalue": dict(
 claim="quadratic_form_intermediate (Proposition 1.1, intermediate-eigenvalue representation)",
 reason=[
  "Not an independent transcription. `paper_claim` uses the repository's own `eigenvalues` and `eigenCoords` for the ordered eigenvalues λ₁ ≤ λ₂ ≤ λ₃ and the coordinates ξ₁, ξ₃, so the terms that carry the content are read through repository definitions.",
  "Otherwise the claim is the complete Proposition 1.1, it is about the real objects (symmetric trace-free 3×3 matrices), and it is kernel-checked.",
 ],
 fix="Re-lock with `paper_claim` transcribed from the paper's words. For a symmetric trace-free `A`, every orthonormal eigenbasis `e₁, e₂, e₃` with eigenvalues `λ₁ ≤ λ₂ ≤ λ₃`, and every unit `ξ`: `ξ·Aξ = λ₂ + (λ₁−λ₂)(ξ·e₁)² + (λ₃−λ₂)(ξ·e₃)²`."),
"frohmanian-symplectic-tether": dict(
 claim="routeA_determines_kappa_of_matching (Theorem thm:routeA, first two sentences only)",
 reason=[
  "Partial lock. Only the first two sentences of Theorem thm:routeA are locked. Its third sentence (\"Consequently, in dim ≥ 3 with S ≥ 0, w > 0, a correction is admissible for Route A iff B = T[κ,w,u] with κ = S.\") is not.",
  "Not a certified step toward the paper's goal. The locked part is the one-line computation Π_u ω = ω ⇒ (S − κ)w = 0. The paper's proof itself says \"κ is a free parameter … and S is supplied, not derived\". The companion two-part paper (BenFrohman/frohmanian-tether-manuscript-2026-06-01, `two_part/tether_two_part.tex`) shows the tether does not modify the Navier–Stokes vector field. No step toward Navier–Stokes regularity is certified.",
 ],
 fix="A lock needs the complete Theorem thm:routeA, including the admissibility characterization. It also needs a stated reason why the matching premise is realized on the path to the paper's main result, if one exists."),
"frohmanian-symplectic-tether-may-form": None,
"frohmanian-symplectic-tether-regularity": dict(
 claim="comparison_ode_stability (conjunct (P4) of the Master Product Theorem)",
 reason=[
  "Partial lock. Only conjunct (P4) of the paper's Master Product Theorem (P1–P5) is locked. The paper's headline statement, the product theorem itself, is not, so the lock leaves the rest of the stated theorem unchecked (partial drift).",
  "Not a certified step on the paper's path. P4 is a scalar ODE comparison fact. The paper itself says \"that the vorticity of a Navier–Stokes flow obeys this inequality is not proved\".",
 ],
 fix="A lock needs the complete Master Product Theorem as stated, with every conjunct independently transcribed and matching, or a paper statement reduced to what is proved on the path."),
"metriplectic-world-model": dict(
 claim="uniform_ceiling (theorem uniform_ceiling, first sentence only)",
 reason=[
  "Partial lock. Only the first sentence of theorem `uniform_ceiling` is locked. The same theorem also states `absorbing`, `ceiling_antitone_kappa` and `kappa_zero_no_ceiling`, and those are not locked.",
  "The comparison inequality M′ ≤ CM² − κM³ is a hypothesis. The paper relabels the results that use `StretchingCZ` as model-only (\"false as a sup-norm bound for Navier–Stokes\"), so this lock does not certify a step on a Navier–Stokes path by itself.",
 ],
 fix="A lock needs the complete theorem as stated, independently transcribed. Its role on the paper's path (tethered model versus Navier–Stokes) also has to be stated."),
"weighted-enstrophy-identities": dict(
 claim="Smooth.enstrophy_identity_smooth (Identity (1) in the smooth model)",
 reason=[
  "Partial lock. The paper's smooth-model theorem (`Smooth.int_d`, `Smooth.int_dt`, `Smooth.enstrophy_identity_smooth`, `Smooth.weighted_identity_smooth`) states \"identities (1) and (2) hold for all u, ω, φ ∈ A\". Only identity (1) is locked; identity (2), the weighted identity, is not.",
  "The locked identity itself is real, true and kernel-checked. It is about real objects (smooth ℤ³-periodic fields), and its `paper_claim` is an independent transcription.",
 ],
 fix="Re-lock both identities (1) and (2) in the smooth model, independently transcribed."),
"periodic-ns-classical-continuation": dict(
 claim="clay_B_exact_of_integrability (Statement (B) conditional on PeriodicBKMIntegrability)",
 reason=[
  "The hypothesis is not independently transcribed. `paper_claim` keeps the repository Prop `PeriodicBKMIntegrability` as a named Prop. The paper describes it only loosely (\"∫‖ω‖_∞ < ∞ on every finite interval of existence\"), so the hypothesis that carries the whole difficulty is read through a repository definition.",
  "Non-vacuity is not certified. The hypothesis is open, there is no witness, and the paper says it is equivalent to global existence.",
 ],
 fix="Re-lock with the hypothesis transcribed from a precise statement in the paper. BenFrohman/Clay- locks the same reduction with both hypotheses transcribed from the paper's English."),
"frohmanian-tether-manuscript-2026-06-01": dict(
 claim="riccati_bound (appendix table row only)",
 reason=[
  "Partial lock. Only the `riccati_bound` row of the Lean appendix table is locked. Theorem thm:cond, which the row serves, is not.",
  "Not a step on a realized path. The paper says the hypothesis M′ ≤ C − κ′M² \"has no derivation and is equivalent to an a priori bound that would settle the Clay problem\". It also says the tether, \"shown in Part I not to modify the NS vector field … cannot produce\" the −κ′M² term.",
 ],
 fix="A lock needs a complete stated theorem of the paper on a path the paper does not itself declare unrealized."),
"HODGE": dict(
 claim="jacobianDeg12_finrank_eq (dimension clause of Theorem thm:r12)",
 reason=[
  "Partial lock. Only the dimension clause of Theorem thm:r12 (dim_ℚ R₁₂ = 1751) is locked. Its second clause (\"the classes of the 1751 standard monomials of degree 12 form a basis of R₁₂\") is not.",
  "The objects are real: the actual chain sextic F, its Jacobian ideal and the degree-12 piece of ℚ[x]/J. The step is genuine. The kernel audit's definitional-equality check hit its heartbeat cap (inconclusive); the alias, syntactic and transport checks passed.",
  "Scope: this is not the Hodge conjecture, for this fourfold or in general.",
 ],
 fix="Re-lock the complete Theorem thm:r12, dimension and basis. Lean already has `stdMonomial_linearIndependent` and `jacobianDeg12_eq_span`."),
}
R["frohmanian-symplectic-tether-may-form"] = R["frohmanian-symplectic-tether"]
gate, key = sys.argv[1], sys.argv[2]
d = R[key]
# 1. checker: a non-certifying lock fails the static check
p = os.path.join(gate, "scripts/truth_gate_check.py"); s = open(p, encoding="utf-8").read()
anchor = """          "main_theorems", "lock_region_sha256", "draft_dirs", "lean_roots"]:
    if k not in lock: fail(f"TRUTH_GATE.lock lacks key {k}")
if FAIL: sys.exit(1)
"""
assert anchor in s
s = s.replace(anchor, anchor + """
# 0. Re-audit status: a lock marked non-certifying keeps the gate red (see TRUTH_GATE.md).
if lock.get("certifying", True) is not True:
    fail("this lock is NOT certifying (reopened by the re-audit of 2026-11-16): "
         + str(lock.get("reopened_reason", "see TRUTH_GATE.md")))
""", 1)
s = s.replace("#  1. TRUTH_GATE.lock parses and names existing files.",
  "#  0. A lock marked `\"certifying\": false` (re-audit) fails.\n#  1. TRUTH_GATE.lock parses and names existing files.", 1)
open(p, "w", encoding="utf-8").write(s)
# 2. lock file
lp = os.path.join(gate, "TRUTH_GATE.lock"); lock = json.load(open(lp))
lock["certifying"] = False
lock["reopened_reason"] = d["reason"][0]
lock["reopened_on"] = "2026-11-16"
open(lp, "w").write(json.dumps(lock, indent=2, ensure_ascii=False) + "\n")
# 3. TRUTH_GATE.md
mp = os.path.join(gate, "TRUTH_GATE.md"); m = open(mp, encoding="utf-8").read()
sec = f"""

## Re-audit (2026-11-16): this lock is NOT certifying

Status: **REOPENED. The gate is red on purpose.** `TRUTH_GATE.lock` carries `"certifying": false`, and
`scripts/truth_gate_check.py` fails while it does. Nothing was deleted: `Semantics.lean`, the quotes,
the hashes and the history are unchanged.

Rule applied (Benjamin Stanley Frohman, 2026-11-16):
* There are no partial locks. A lock certifies only a step on the correct path to the full theorem
  that is kernel-proved as the actual true answer, so that the next step can build on it.
* Drifted, dummy, placeholder or stand-in types, names or categories are rejected.
* Cross-ontology connections are not rejected for looking unrelated. The kernel check, and whether
  the piece genuinely helps reach the full structured proof, decide.
* `paper_claim` is an independent transcription of the verbatim paper quote, never an alias of
  `formal_claim`, and the correspondence is never `rfl`/`Iff.rfl`.

Locked claim under review: {d['claim']}

Why it is reopened:
""" + "".join(f"* {r}\n" for r in d["reason"]) + f"""
What would re-certify it: {d['fix']}
"""
m = m.rstrip("\n") + sec
open(mp, "w", encoding="utf-8").write(m)
for extra in sys.argv[3:]:
    open(extra, "w", encoding="utf-8").write(m)
print("ok", key)
