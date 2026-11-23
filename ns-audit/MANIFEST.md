# MANIFEST: Navier–Stokes / Frohmanian Tether materials (handoff to PipelineHalt)

Generated 2026-11-23 (America/Chicago, CT) by Grok Bot executor on the shared box. Read-only on Zenodo; nothing merged; no main-branch pushes.

## 1. Where everything lives

- NS-relevant files found on the box (scan of /workspace, /home/box, bot store): **40001**.
  - Already on GitHub (git blob SHA-1 found in one of the 101 BenFrohman repos, any ref/history; 25,297 objects indexed): **35855**.
  - Byte-identical to a Zenodo file (24079623 / 24080310): **36**.
  - Local-only: **4110** → archived: **2429** (1837 unique blobs, 200.8 MB); not archived: **1681** (reasons below).
- Archive location (off-machine): GitHub `BenFrohman/NS_Millennium_Proof`, branch `archive/ns-materials-20261123` (orphan branch, no `.github/`, so it triggers no CI). Files keep their box path under `workspace/…` (and `home/…`). Full per-file list with size, mtime and git blob id: `manifest-archived.tsv` (same directory).
- This MANIFEST, `REPORT.md`, `corrected-latex/` and both TSVs are committed at the branch root under `ns-audit/`.

## 2. Off-machine sources of record

| Source | Content | Status |
|---|---|---|
| GitHub `BenFrohman/frohmanian-tether-conditional-regularity` main `86336a9` | ClassicalNS, FrohmanianTripleArchitecture(+Lifespan), Semantics locks, repo papers | CI green (see REPORT §2) |
| GitHub `BenFrohman/frohmanian-tether-sdiff` main `50928f3` | SDiff tether, CubicSourceCertificate, AssemblyGap, TetheredLyapunov, Scratch/KatoMaximal, vendored periodic BKM pillar, manuscript | CI green |
| GitHub `BenFrohman/periodic-ns-classical-continuation` main `b5154f3` | periodic BKM criterion, periodic local existence | Lean green; truth-gate FAIL (LOCK-FORM) |
| GitHub `BenFrohman/NS_Millennium_Proof` main (last green `6b78ba7`; `e4a9871` CI in progress at 3:31 PM CT) | HISTORY.md, CubicSourceCertificate, CeilingFromRate, TetheredLyapunov | see REPORT |
| GitHub `BenFrohman/frohmanian-symplectic-tether-regularity` main `d6fa547` | velocity-slot tether `tetherKernelVel_C2`, hIdent/hRiccati binders | Lean/kernel green; truth-gate FAIL (LOCK-FORM, partial lock) |
| GitHub `BenFrohman/frohmanian-tether-geometric` main | CubicSourceCertificate, AssemblyGap | no main CI runs listed; branch `ci-backfill/ac27181` kernel green, header red |
| GitHub, 101 BenFrohman repos total (31 NS-related cloned depth-1 in `repos/`) | full list `allrepos.tsv` | blob index only |
| Zenodo 10.5281/zenodo.24079623 (concept 24079622), published 2026-11-09 | Unified, Full_Expanded, Conditional_BKM_Continuation, Littlewood–Paley (tex+pdf), 3 Lean files, verify_tether_tg.py(+output), references.bib | downloaded to `zenodo/24079623/`, read-only |
| Zenodo 10.5281/zenodo.24080310 (concept 24080309) | Three_Pillars_NS, Littlewood–Paley (tex+pdf) | downloaded to `zenodo/24080310/`, read-only |
| Bot store `store-c7c74681…` | 2 .lean + 1 .txt (all byte-identical to GitHub blobs); remaining items are MK-1 PDFs/images (not NS) | nothing to archive |

## 3. Local-only material NOT archived (needs Benjamin's decision; halt Q8)

| Reason | Count |
|---|---|
| personal/Drive-sourced/third-party/API dump - not archived (see manifest) | 783 |
| machine-generated JSON/JSONL dump - not archived | 706 |
| Google Drive listing (file IDs) - not archived | 183 |
| large release/deposit bundle >5MB - not archived | 6 |
| secret-pattern (filename/content) - not archived | 3 |

The archive branch lives in a **public** repository, so personal, forensic, career and Google-Drive-sourced material (including Drive listings that carry file IDs and page tokens), third-party code (vendored batteries, Mathlib copies) and machine-generated JSON/JSONL API dumps were held back. The directory names and file lists stay on the box only (`/workspace/ns-audit/manifest-skipped.tsv`, not committed, because the repository is public). They remain only on this box. Recommended: a private repository or the user's own Drive, on his instruction.


Large bundles (>5 MB) not archived; their sources are on GitHub/Zenodo:

- `/workspace/zenodo_packages/1_NS_Millennium_Proof_v2.1/NS_Millennium_Proof-v2.1.0.zip` (17.5 MB, blob `632695a114ac`)
- `/workspace/ns-envelope-fix-20261106/ns-envelope-correction-certificate.tar.gz` (5.2 MB, blob `ceb62100f5d1`)
- `/workspace/zenodo-provenance-batch3/NS_Millennium_Proof-v2.2.0.zip` (17.6 MB, blob `260967e4ae1a`)
- `/workspace/corr20261111/upC/NS_Millennium_Proof-6c79135d30fdd03d6b7520d47eec4fefa5ec7f03.zip` (17.7 MB, blob `a75bb015e933`)
- `/workspace/cert-bundle-prs/rebuild/upload/24302372/NS_Millennium_Proof-6c79135d30fdd03d6b7520d47eec4fefa5ec7f03.zip` (17.7 MB, blob `2fa10cd9876c`)
- `/workspace/rel/23627610/NS_Millennium_Proof-v2.1.0.zip` (17.5 MB, blob `632695a114ac`)

Secret-pattern exclusions (filename false positives; the originals are on GitHub):

- `/workspace/tetherrate-verify-2026-11-16/partial-packages-copy-unused/batteries/Batteries/Tactic/OpenPrivate.lean`
- `/workspace/tetherrate-verify-2026-11-16/partial-packages-copy-unused/batteries/BatteriesTest/openPrivate.lean`
- `/workspace/tetherrate-verify-2026-11-16/partial-packages-copy-unused/batteries/BatteriesTest/OpenPrivateDefs.lean`

Content scan of every archived file and every member of archived zip/tar.gz bundles for key/token patterns: no credential found. Three Zenodo helper scripts read `ZENODO_ACCESS_TOKEN` from the environment and contain no token. The bundle member `scripts/check_forbidden_tokens.py` matched by name only. Full list with reasons: `manifest-skipped.tsv` (box only). The committed `manifest-skipped-public.tsv` lists only the JSON-dump, large-bundle and secret-pattern entries, plus per-reason counts.

## 4. Key local-only manuscripts (archived; not on GitHub or Zenodo before this branch)

- `/workspace/conditional-continuation-ms/Conditional_Continuation_SmallData_Tether.tex` (30606 B, blob `82c43482a1d7`, archived)
- `/workspace/tether-alignment-zenodo/Frohmanian_Tether_Alignment_NS.tex` (12166 B, blob `2163b05bba7e`, archived)
- `/workspace/coadjoint-note/main.tex` (37581 B, blob `6155413a6a64`, archived)
- `/workspace/tether_paper/*.tex`, `/workspace/three-pillars/` (the latter is a copy of the Zenodo file)

## 5. Audit working set (on box, `/workspace/ns-audit/`)

`allrepos.tsv`, `repos/` (depth-1 clones), `bare/` (blobless bare clones; not archived, rebuildable), `allblobs.txt`, `ci/` (CI logs), `zenodo/` (record JSON + files), `scan/` (scan.py, select.py, files.json, selected.json, skipped.json), `corrected-latex/` (3 drafts + PDFs), `REPORT.md`, `MANIFEST.md`.

One selected file disappeared during the run (`/workspace/NS_Millennium_Proof/NS_Millennium_Proof/Modules/TrajectoryDistinction.lean`). Another agent is working in that checkout (HEAD `e4a9871`, 3:31 PM CT), so it was not archived.
