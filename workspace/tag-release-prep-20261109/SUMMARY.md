# Tag/release recommendation prep — 2026-11-09 (America/Chicago)

Preparation only for recommendations 1–3 (+ UnitCorrection investigation). No Zenodo deposits by this run. may-form v1.0.0 and attestation/archive tags left alone.

## 1) frohmanian-tether-sdiff
Concurrent main work (`ffedc1d`, `36e150e`, `0722b16`) already added Lean CI, corrected manuscript identity/counts, and certificate. Verified locally earlier: lake build 2712 jobs; AxiomAudit **519** theorems, **0** nonstandard axioms.

Open follow-up PR (this run): https://github.com/BenFrohman/frohmanian-tether-sdiff/pull/2
- head: 34e1350f59a1eeeceb78b7c9f36c528cdab06e40
- Adds explicit not-peer-reviewed / not-unconditional-NS language and rejects older DOI 10.5281/zenodo.23717084
- CI green: Lean 4 https://github.com/BenFrohman/frohmanian-tether-sdiff/actions/runs/42611841312 ; Lean certificate https://github.com/BenFrohman/frohmanian-tether-sdiff/actions/runs/42611841349

NOTE: A GitHub Release `v0.1.1` and tag appeared on the repo at ~11:47 AM CST from concurrent work (not created by this preparation run). Still needs user awareness; Zenodo archive for this repo remains unassigned per manuscript.

Closed superseded conflicting PR #1 from stale base.

## 2) titan-audit
PR: https://github.com/BenFrohman/titan-audit/pull/1
- head: 141567a72510280354d21a6954447aa57d04a65b
- Adds `.github/workflows/ci.yml` (pytest + attestation verify + LeanKernelGate)
- Local: 15 pytest passed; reference attestation verify OK
- CI green: https://github.com/BenFrohman/titan-audit/actions/runs/42610261123
  - Python: job 129136549009 SUCCESS
  - LeanKernelGate: job 129136548755 SUCCESS
- Draft release notes (local only): /workspace/tag-release-prep-20261109/titan-audit-v1.0.0-RELEASE-NOTES.md
- Prefer one Release for v1.0.0 at 7709720, or v1.0.1 after merging CI PR; do not also release alias `v1`.

## 3) Frohman-S-UnitCorrection
No PR. Failed run 40248384503 was a false-positive seeds.csv grep; fixed on main by e201a7b (CSV parse). Latest docs.yml green: https://github.com/BenFrohman/Frohman-S-UnitCorrection/actions/runs/41801723667
Investigation: /workspace/tag-release-prep-20261109/Frohman-S-UnitCorrection-investigation.md

## Pending user approval
- Merge titan-audit PR #1
- Merge frohmanian-tether-sdiff PR #2
- Optional later: titan-audit GitHub Release (v1.0.0 or v1.0.1) — draft notes only so far
- Optional later: Zenodo archive DOI for sdiff (manuscript says none assigned)
- Review concurrent sdiff GitHub Release v0.1.1 (created outside this prep run)
