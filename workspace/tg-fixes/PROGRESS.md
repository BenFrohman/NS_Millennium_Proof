# Truth-gate fixes progress (updated 2026-11-23 CT)
Work clones: /workspace/tg1123/<repo>. Commit helper: /workspace/tg1123/commit.sh "msg". Logs: /workspace/tg1123/logs.
Rule: certifying stays false until the whole paper is locked (t546u/t565u), so truth-gate stays red (LOCK-FORM). Never merge red, never --admin.

## frohmanian-tether-verified
- branch truth-gate/devacuify-energy-20261123, draft PR #11, head c6b69b5 (reason reclassified as partial lock)
- local: full lake build OK (8296 jobs, 0 errors, std axioms), audit PASS, lint PASS, static fails only on certifying
- CI at 32c531f: all pass except truth-gate 45251844696 FAIL (LOCK-FORM, labeled "vacuous" due to word in reason -> fixed in c6b69b5); rerun at c6b69b5: truth-gate 45253930442 FAIL (LOCK-FORM, partial lock), audit PASS, kernel PASS; others pass
- next: confirm CI; remaining unlocked: Sec3 (3 items), Sec4 (7 items), Refuted items 2,3

## periodic-ns-classical-continuation
- branch truth-gate/bkm-integrability-transcribed-20261123 (local, UNCOMMITTED), no PR yet
- done: paper hyp sentence rewritten to exact Lean meaning; Semantics lock (paperBKMInt etc.); docstring; lock JSON mains+reason; TruthGateAudit mains
- building: /tmp/pn_sem.log (lake build PeriodicNSContinuation.Semantics)
- PDF rebuilt OK. next: fix Semantics errors; resync_sha.py; TRUTH_GATE.md; lint/static/audit; commit/push/draft PR

## frohmanian-symplectic-tether
- branch truth-gate/routeA-full-20261123, draft PR #8, head 9f55c5f
- CI at 9f55c5f: all pass except truth-gate 45253937011 FAIL (LOCK-FORM partial lock; audit PASS). Earlier run 45239509402 = FAIL (LOCK-FORM, only certifying; audit PASS)
- next: lock the 15 remaining statements

## frohmanian-symplectic-tether-may-form (base fresh-public)
- branch truth-gate/routeA-full-20261123, draft PR #6, head 1c6fe45
- CI at 1c6fe45: all pass except truth-gate 45253941470 FAIL (LOCK-FORM partial lock; audit PASS). Earlier run 45242480007 = FAIL (LOCK-FORM, only certifying)

## frohmanian-symplectic-tether-regularity — BLOCKER, not started
- P1 vacuous (assumes SaturatesTetherQuadratic = conclusion on diagonal; first two conjuncts identical); P2/P3 need independent transcriptions; P5 withdrawn

## frohmanian-tether-manuscript-2026-06-01 — BLOCKER, not started
- thm:cond needs BKM + parabolic smoothing (not formalized); lean/ has only riccati_bound

## NS_Millennium_Proof
- author-approval job removed (1566128); #38 merged 556c433; #43 merged 6b78ba7; main green at 6b78ba7 (truth-gate 45241230366, Lean CI 45241230406, kernel cert 45241230794)
## p2q-jumps-lean
- author-approval removed (e2903cb); main green 0b82cdd (truth-gate 44893346401)

## [executor 14:46 CT] frohmanian-tether-manuscript-2026-06-01 — STARTED
- branch truth-gate/whole-paper-thmcond-20261123 (local). lean/.lake/packages -> /tmp/wei/.lake/packages (same manifest revs)
- plan: new Lean thms (riccati on [0,T*), thm:cond with named BKM + parabolic-smoothing hyps, continuum g_ω sym/PSD, tethered bracket antisymm iff g=0, sym/antisym split uniqueness); demote thm:model, Prop inv, prop:degen (c)(d) to unclaimed remarks; fix sign error in prop:mirror (i); whole-paper lock.
- 15:08 CT local lake build stalled (box thrashing: load>100, ~0 free RAM, lake stuck in page IO) -> killed per 10-min rule; compiling via GitHub CI instead
- 15:45 CT manuscript: commit 7ae6785 pushed, draft PR #8. New lean/MirrorMetriplectic/PaperResults.lean (6 mains + riccati_bound_Icc); Semantics whole-paper lock, certifying:true; paper edited (thm:model->Conjecture, prop:inv & prop:degen(c,d) -> remarks, sign fix prop:mirror(i), thm:cond with (R),(BKM),(PS)). Local: static PASS, lint PASS, fixtures OK, tokens PASS, header OK, PDF builds w/o overfull. Lean compile only via CI (box thrashing). pyc accidentally committed; restoring next commit.
- 15:58 CT manuscript: CI run 45270208106 failed only on integrand_coords rewrite (PaperResults compiled OK); fixed in 582d2b9; cancelled stale 7ae6785 runs
- 16:12 CT manuscript: head 4085efa (paper ref fix + resync). All CI runs queued (account runner queue saturated, ci-backfill). Local PDF: 9 pages, 0 overfull, 0 undefined refs.
