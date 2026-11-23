## Failure classes (what a red Truth Gate means)

A red Truth Gate is not automatically a math failure. Since 2026-11-17, `scripts/verify-lock.sh`
runs every phase even after one fails. `scripts/truth_gate_classify.py` then sorts each failure
into exactly one class and prints a `TRUTH GATE VERDICT` block at the end of the log. The block
also goes to the job summary and to `truth-gate-report/classification.json`.

This exists because of frohmanian-tether-sdiff PR #13 (run 44039231121). That PR changed only CI,
but its merge ref was built on a main whose lock still had the old `paper_claim` form. The gate
printed `TRUTH GATE FAIL: this lock is NOT certifying` and `TRUTH GATE STATIC FAIL`, which read like
a proof failure, though every kernel check was green.

| Class | Raised by | What the verdict prints | What fixes it |
|---|---|---|---|
| **KERNEL/PROOF** | `lake build` fails; `sorry`/`admit`/`native_decide`/`axiom` outside the draft dirs; nonstandard axioms; a missing or ill-typed locked declaration; `intended_correspondence` fails to check | `KERNEL/PROOF FAILURE (a proof does not check)` and `This is a proof failure`, with the failing lines | Fix the proof. **This is the only class ever described as a proof failure.** |
| **LOCK-FORM** | `paper_claim` reuses a repository Prop or definition; a vacuous alias of `formal_claim`; an `rfl` correspondence; a partial lock; a lock marked `"certifying": false`; an edited lock region; missing `PAPER_*` fields | `LOCK-FORM: lock wording/form problem, not a math failure`, each offending identifier with `file:line` in the Semantics file and the `file:line` of its repository declaration, then the independent transcription that is required | Rewrite the paper side from the paper's own definition, in the paper's symbols, and prove `intended_correspondence` with real reasoning. A new lock needs the author's sign-off. |
| **PAPER-HASH** | the paper's sha256 differs from the lock | `PAPER-HASH: the paper changed after the lock (not a math failure)`, the commit whose bytes match the lock, every changed line, whether only copyright/license/attribution lines changed, and whether the locked quote is still verbatim | If the edit is intended, update `paper_sha256` in `TRUTH_GATE.lock`, the `PAPER_SHA256:` line in the Semantics file and the hash in this file, all in one commit. If the quote changed, that is a statement change and needs sign-off. |
| **STALE-BASE** | a PR's merge ref was built on an older main, and main has since changed the lock, a Semantics file, a paper or a gate script | `STALE-BASE: branch is behind main's lock; update branch (not a math failure)` | The workflow re-merges the PR head onto the current main and judges that merge, which is what would actually land. It goes red only if that merge conflicts, and then it says to update the branch. |

Two more labels can appear in the verdict:

* **`[INHERITED]`** appears when the PR touches no lock, vocabulary, Semantics or paper file but a
  LOCK-FORM or PAPER-HASH failure remains. The failure comes from main, so it has to be fixed on
  main.
* **`UNCLASSIFIED`** appears when a checker crashed or printed a message no rule recognises. It is
  shown verbatim and is never presumed to be a math failure.

The last line always states the classes, for example
`VERDICT: FAIL (LOCK-FORM). Kernel checks passed: no math was found false.`

### Lock-form lint (runs on every PR, no Lean needed)

The `lock-form-lint` job in `.github/workflows/truth-gate.yml` runs
`python3 scripts/truth_gate_classify.py lint --fetch-deps`. It collects every declaration in
`lean_roots` and in the author's own Lake dependencies (every non-Mathlib package in
`lake-manifest.json`), then reads `paper_claim` and any paper-side helper defined in the Semantics
file. It rejects:

1. any Prop that is a whole hypothesis or the conclusion of `formal_claim` (for example the old
   sdiff form `(∀ ν > 0, PeriodicTetherClosingBound ν) → …`). This is never allowed, with or without
   a vocabulary entry;
2. any other repository name that is not listed, with a reason, in `TRUTH_GATE.vocabulary.json`
   (basic notions such as the velocity-field type);
3. any name in `paper_forbidden_names`, and any mention of `formal_claim`.

`TRUTH_GATE.vocabulary.json` is lint configuration. It cannot change the locked claim, because the
lock region hash still pins `paper_claim`. For an existing author-approved lock, it records only the
basic names that the approved claim already uses. Any new name on the paper side goes into the
new-lock PR together with the author's sign-off.

### Tests

`scripts/tests/test_truth_gate_classify.py` has one throw-away fixture repository per class:

* KERNEL/PROOF: build error, sorry, nonstandard axioms;
* LOCK-FORM: named hypothesis Prop, unlisted repository name, alias, non-certifying,
  partial lock, vacuous lock;
* PAPER-HASH: copyright-only change, and a change to the quote;
* STALE-BASE: re-merge onto the current main, and a merge conflict;
* `[INHERITED]` label.

The `lock-form-lint` job runs them on every PR:

```
python3 -m unittest discover -s scripts/tests -p 'test_truth_gate_classify.py' -v
```
