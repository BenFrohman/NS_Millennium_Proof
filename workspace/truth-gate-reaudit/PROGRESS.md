# Truth Gate re-audit progress — 2026-11-23 (CT)
Working clones/logs: /workspace/reaudit-1123/ (tools/scanlog.py, tools/common/{check_no_skips,check_lean_coverage,fix_ci}.py)

## Done
- Kato T1-T11 (sdiff dd8e086): PASS. truth-gate 45089388200 + kernel cert 45089388205, full log read (20,552 lines), 0 sorry, std axioms, paper sha matches lock. Paper-edit notes: thm:T10 title vs uniform ||w||inf ceiling hypothesis; T11 rate only in quoted Lean.
- TFFrohmanianTether: PR #1 merged (e6b9eee) — proved Basic/Semantics restored, headers, no-skip; PR #2 merged (b3e4e8d). main green.
- NS_Tether_Alternatives: PR #2 merged (b05491b) — axiom T_on_H replaced by theorems Pi_u_self/T_on_H (std axioms), built in lib NonSymmetricC2, exclusions removed; PR #3 merged (58c82b9).
- Guard fixes: catches grep -vE; fails on 0 files read. Kernel-cert diff now inside `if` (bash -e bug).
## Open
- p2q PR #10 (488cdc5): CI running since 12:49 CT. Then merge, fresh run on main, Zenodo draft = reuse empty newversion draft 24407887 (concept 22713135). Do not touch 24377388.
- sdiff PR #18 (guard update): CI running.
- NS_Millennium_Proof PR #44: no-skip, EXPECTED RED (110 forbidden tokens, ~55 unbuilt .lean). NS v2.6.x draft blocked on archive decision.
- uniruled-fourfolds PR #2: strict verify, EXPECTED RED (8 axioms + sorry in Blueprint.lean). Blocker.
- RCW-Version15-Certificates: no Lean sources at all; README claims formalization. Blocker.
- Test-Practice-Repo: startup_failure cause = repo Actions setting allowed_actions=local_only (checkout/upload-artifact blocked). Needs user approval to change setting; also 244 sorry.

## Update 13:58 CT
- sdiff PR #18 (guard) merged 50928f3 after all green, logs read.
- NS PR #44 red as expected: coverage 131 tracked, 32 BUILT, 14 CI-RUN, 85 uncovered; truth-gate static 110 forbidden tokens.
- p2q PR #10 @488cdc5: truth-gate 45242409256 PASS, Lean cert 45242397722 + 45242409250 PASS (artifact 14852149838), header pass; Kernel certificate 45242397649 still running (per-module kernel re-check, ~57 min). NEXT: when green, read log, merge, create draft in 24407887.
- p2q draft description template: p2q-draft/description.html
- p2q PR #10 merged (see above); all PR checks green incl. kernel cert 45242397649 (155/155 modules, coverage 156 files 0 uncovered, elan 4.4.0, Lean 4.26.0, Lake 5.0.0-src+d8204c9, manifest sha 4d3ae22e…). NEXT: zenodo draft 24407887.
- 14:05 CT p2q DRAFT DONE: Zenodo 24407887 (concept 22713135, reserved DOI 10.5281/zenodo.24407887), unsubmitted, v1.4.1, date 2026-11-23, isNewVersionOf 24180777. 8 files (PDF+tex built at 488cdc5, source zip, CI artifact zips exact digests cae0fd75…/7c8fc8e4…, ci-logs zip, NOTICE, SHA256SUMS). Old "pending author approval" notes replaced. NOT published. 24377388 untouched.
  Caveats: lock covers Thm L + L2 only (partial); paper still names old version "0.11-review2" in historical snapshot/bib; source zip contains stale paper/verification_certificate.*.
- NS v2.6.x draft: BLOCKED (NS PR #44 red: 85 uncovered files, 110 forbidden tokens) pending author decision on archival files.
- Kato re-verified 14:07: truth-gate 45089388200 log 6393 lines, scanlog 0 findings; main now 50928f3 all 5 workflows green.

## New brief 14:10 CT (order): (1) p2q full lock + review2 wording + drop stale verification_certificate from source zip, merge, refresh draft 24407887; (2) sdiff T10 retitle + T11 rate prose, merge; (3) guard+coverage rollout to remaining repos. HOLD: NS #44, uniruled #2, Test-Practice-Repo, 24024593.
- 14:35 (2) sdiff PR #19 opened (branch paper/kato-T10-title-T11-rate-20261123): T10 retitled, def:rate added, T11 refers to it, v1.2 date 23 Nov; lock region unchanged; paper sha 176853c2…; static gate PASS locally. NEXT: wait CI, read logs, merge. Note: tectonic PDF build fails on box (font issue with Noto Sans Mono variable font) for main too — not a regression.
- (1) p2q scope: paper has 95 theorem-like envs (52 Part A, 41 Part B + conj, 1 Part C ledger) — list in p2q-envs.tsv. Only L, L2 locked. Full lock = ~93 more independent transcriptions + correspondence proofs. Local build available: copied .lake/build from /workspace/p2q-4sort (0b82cdd, same Lean).
