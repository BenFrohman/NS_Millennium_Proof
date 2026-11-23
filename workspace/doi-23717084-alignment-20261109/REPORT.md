# DOI 10.5281/zenodo.23717084 alignment (2026-11-09, America/Chicago)

## Record 23717084
- **State:** published (`done` / `submitted: true`)
- **Title:** Global Regularity for the 3D Incompressible Navier–Stokes Equations via the Frohmanian Symplectic Tether: Lean 4 Formalization and Conditional Cubic Comparison Framework (v2.2)
- **Version DOI:** `10.5281/zenodo.23717084`
- **Concept DOI:** `10.5281/zenodo.23627609` (conceptrecid `23627609`)
- **Versions in family:**
  - `10.5281/zenodo.23627610` — v2.1.0 (2026-10-24)
  - `10.5281/zenodo.23717084` — v2.2.0 (2026-10-27) ← this DOI
  - `10.5281/zenodo.23749850` — v2.3.0 (2026-10-28)
- **Owning repo:** `BenFrohman/NS_Millennium_Proof`
- **Pinned GitHub:** tag `v2.2.0` / commit `8a5ec50aa602318c0c611269731e7d41cd30b75b`
- **Creator:** Frohman, Benjamin Stanley; ORCID `0009-0006-7068-3718`; affiliation Independent Researcher, Texas, United States
- **Files (md5):**
  - SEALGUARD_CLASSIFIED_MANIFEST.json — b52be91d7fb6238d7959c70f3721d487
  - Frohman_NS_Symplectic_Tether_v2.pdf — 95f5d8a9195fe08a9d5af5bd697b63e3
  - SCOPE.md — dbe08abb2d0abd6c49e6db9524590e8d
  - TITAN_AUDIT_CERTIFICATE.json — 5399a1c3afafa92026a7f9ee39bb8c5b
  - PROVENANCE_MERKLE_ROOT.json — c6bc900c959c47c19bfed6ac025f38e8
  - NS_Millennium_Proof-v2.2.0.zip — a4cf4e5466f12d4f2d7f46a8610506ba
- **HTML:** https://zenodo.org/records/23717084

## Mismatches found (before PRs)
1. `CITATION.cff` on NS lacked author `email` (NOTICE already had frohmanbenjamin@gmail.com).
2. README Zenodo section emphasized concept DOI; version DOI 23717084 risked looking orphaned next to sdiff’s different DOI story.
3. Zenodo v2.3.0 (`23749850`) still points at GitHub `v2.2.0`/`8a5ec50` and keeps zip name `…-v2.2.0.zip`; no GitHub tag `v2.3.0`.
4. Wrong citations of 23717084 on GitHub: **only NS_Millennium_Proof** (correct). `frohmanian-tether-sdiff` previously cited it; main now cites `24082000`; manuscript on main still said “No DOI assigned” until PR #2 update.
5. Local inventory clone `/workspace/inv/frohmanian-tether-sdiff` still has old NS DOI text — not on GitHub.

## GitHub PRs opened/updated (no merges)
- NS: https://github.com/BenFrohman/NS_Millennium_Proof/pull/24 — email + provenance table + .zenodo.json related pins + NOTICE
- sdiff: https://github.com/BenFrohman/frohmanian-tether-sdiff/pull/2 — cite 24082000; reject 23717084 as NS-only

## Zenodo edits
**Not applied.** Patch plans in this directory (`zenodo-patch-plan-*.json`) await user approval.

## Concurrent check: 10.5281/zenodo.24082000 (sdiff)
- Published; concept `10.5281/zenodo.24081999`; version 0.1.1
- Title/authorship/ORCID correct; email **not** on Zenodo creators
- Source zip **exact match** to GitHub tag `v0.1.1` / commit `0722b16` (key files SHA-256 match)
- Main tip `abd73d1` only adds DOI citations after the archive (expected)
- Pending metadata mismatches: missing email; `isSupplementedBy` relation direction; no commit SHA pin; empty keywords/notes on published record

## CI results (America/Chicago, 2026-11-09 ~06:18)
### NS_Millennium_Proof PR #24
- Build (lake): SUCCESS (~3m38s) https://github.com/BenFrohman/NS_Millennium_Proof/actions/runs/42615309917
- Repository structure check: SUCCESS
- CodeQL Advanced (python/actions): SUCCESS
- CodeQL: SUCCESS
- mergeable: MERGEABLE; mergeStateStatus BLOCKED (likely branch protection / review, not a failing check)

### frohmanian-tether-sdiff PR #2 (head e02c639)
- Lean 4 build: SUCCESS (~1m49s) https://github.com/BenFrohman/frohmanian-tether-sdiff/actions/runs/42615354756
- Lean certificate (PR + push): SUCCESS
- All checks green after manuscript DOI sync commit

## Pending user approval
1. Merge https://github.com/BenFrohman/NS_Millennium_Proof/pull/24
2. Merge https://github.com/BenFrohman/frohmanian-tether-sdiff/pull/2
3. Optional Zenodo metadata fixes (no publish/newversion done): see zenodo-patch-plan-23717084.json, zenodo-patch-plan-23749850.json, zenodo-patch-plan-24082000.json
