# Pre-CI backfill (precI) — progress
Updated Mon Nov 23 2026, 03:40 PM CT

Approved by Benjamin, Nov 23 2026 2:27-2:28 PM CT: "why not just backfill the CI to the commits?" (t593u), "Well built them all then!!!" (t594u).

What it does: the 1,400 commits the main backfill recorded as not-run (1,269 with no .github/workflows, 131 with only PR/tag workflows).
For each one with Lean source: branch `ci-backfill/<sha7>` = that exact commit + ONE SSH-signed commit (Benjamin Stanley Frohman
<frohmanbenjamin@gmail.com>, no trailers) that adds the repo's current Lean CI from the default-branch HEAD (Lean / kernel-certificate /
truth-gate / certify / header / axiom / verify workflows that run on a branch push or dispatch, plus the script folders they reference).
The commit's own lean-toolchain, lake-manifest.json and lakefile are kept; only when missing is the current one used, and the
result records it (`substituted`). No original branch or history is touched; no force-push; no branch is deleted.
Pass/fail uses the main runner's rules: every run's full log is downloaded (precI/logs/) and scanned for sorry/sorryAx, non-standard
axioms and errors, plus the skip/exclusion scan; any workflow that never runs is a FAIL. Nothing is called passed unless every run passed.
Throttle: at most 5 concurrent runs / 2 commits (12 / 5 once the main backfill has finished), and no new commit starts while the main backfill has 3+ runs queued (so it is not
starved) or the GitHub API budget is low.

No stall cancel/retry: per Benjamin (t610u, 3:09 PM CT) backfill runs flow through one after another and run to completion however long they take.

Files: precI/plan.py (queue), precI/runner_precI.py, precI/state.json, precI/results.jsonl, precI/runner.log, precI/logs/.
Resume: ./resume_precI.sh (also called by resume.sh). Watchdogs: watchdog.sh, watchdog_precI.sh. Pause: touch precI/PAUSE.

## Counts
- Queued total: 1400 commits. Plan: 936 to build, 464 with no Lean source (recorded 'no Lean source', nothing to build).
- Results so far: {'not-run': 464, 'fail': 10}; of which no-Lean-source 464; built 10 (pass 0, fail 10), 2 of the built used a substituted toolchain/manifest/lakefile.
- Remaining to build: 926 (in flight 0).
- Failure reasons: {'build/check error': 8, 'nonstandard axioms': 1, 'sorry': 1}
- ETA: 9.3 commits/hour so far -> about Fri Nov 27, 07:27 PM CT
- First push: 14:43:11 CT

## Latest built results
- frohmanian-tether-geometric ac27181 FAIL — step ending `python3 scripts/lean_header.py --check .` failed; last output: : 45 drifted, 11 ok — branch ci-backfill/ac27181
- periodic-navier-stokes-smooth-uniqueness aaabf41 FAIL — step ending `if grep -q '"name": *"mathlib"' lake-manifest.json 2>/dev/null; then lake exe cache get; else echo "no mathlib dependenc` failed; last output: /home/runner/work/_temp/da18ca86-53c8-44f2-a849-a861348daa80.sh: — branch ci-backfill/aaabf41
- local-hodge-lean-variants-2026 f3ae677 FAIL — step ending `python3 scripts/lean_header.py --check .` failed; last output: : 6 drifted, 0 ok — branch ci-backfill/f3ae677
- quadratic-residues-lean 83d81ad FAIL — step ending `python3 scripts/lean_header.py --check .` failed; last output: : 3 drifted, 1 ok; step ending `lake build 2>&1 | tee cert-out/build.log` failed; last output: error: build failed; step ending `${GITHUB_ACTION (substituted lake-manifest.json) — branch ci-backfill/83d81ad
- RCW-Version15-Certificates 6d0bd7a FAIL — step ending `python3 scripts/lean_header.py --check .` failed; last output: : 1 drifted, 0 ok; step failed; last output: error: build failed — branch ci-backfill/6d0bd7a
- RCW-Residuals-Lean 4221808 FAIL — step ending `python3 scripts/lean_header.py --check .` failed; last output: : 3 drifted, 0 ok — branch ci-backfill/4221808-r2
- NS_Tether_Alternatives aff5016 FAIL — error: build failed; error: build failed; : 3 drifted, 2 ok (substituted lean-toolchain, lake-manifest.json, lakefile.lean) — branch ci-backfill/aff5016
- frohmanian-tether-early-may-2026-snapshot ebcd333 FAIL — run 45265746002 Lean header failure: ##[error]Process completed with exit code 1. — branch ci-backfill/ebcd333
- CollatzConjecture 0e92141 FAIL — Scanned 4 tracked .lean files for sorry / admit / native_decide / axiom declarations (comments and strings ignored). — branch ci-backfill/0e92141-r2
- TFFrohmanianTether 9ecf156 FAIL — run 45262291178 Kernel certificate failure: error: dependency 'plausible' of 'mathlib' not in manifest; this suggests that the manifest is corrupt; use `lake update` to generate a new, complete file ( — branch ci-backfill/9ecf156
