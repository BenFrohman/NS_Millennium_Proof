# Provenance pack — 2026-08-27

**Author:** Benjamin Stanley Frohman  
**GitHub:** @BenFrohman  
**X.com : Investor0x** (not a GitHub handle)  
**Email:** frohmanbenjamin@gmail.com  

This file is a custody record, not a Clay certificate. `#print axioms frohmanian_tether_theorem` still includes `sorryAx`.

## Lean kernel vs editor green ticks

A green underline / InfoView “goals accomplished” only means *that declaration* elaborated. It does **not** walk `sorry` in dependencies. The receipt is `#print axioms`. `rfl` is `Eq.refl` after definitional unfolding (compile-time, kernel). It does not prove an untranscribed PDE identity.

## Dated lake build log (original)

- Path: `certs/lake-build-2026-08-27T063948Z.log`
- UTC: `2026-08-27T06:39:48Z`
- Host: Ben’s MacBook Pro
- SHA at build: `2d993e3c271db46b2f74ab2c34ac54c83369688f`
- Branch: `kernel/cohesive-tether-kappa-bkm`
- Signature: `G frohmanbenjamin@gmail.com` (SSH)
- Toolchain: `leanprover/lean4:v4.30.0-rc1` (Lake 5.0.0, commit `714601baf118066cbf3f282361339c6d06665b2a`)

Closed theorems in that log (no `sorryAx`): `div_curl`, `div_smul_field`, `uniqueness_of_kernel_density`, `step2_degree_of_canonical_density`, `tetherKernel_degenerates_on_kinetic_energy`, `kineticEnergy_hasDerivAt_velocity_pairing`, `div_cross_right`, others listed in the log.

Main theorem in that log: `frohmanian_tether_theorem` **depends on `sorryAx`**.

## Git / GitHub (kernel path, PR #8)

Repo created on GitHub: `2026-06-19T21:15:05Z`.  
Oldest author-dated commit in the object graph: `c4fc018` 2026-06-19T16:29:21-05:00 (unsigned). Graph root `78ebf97` is later (2026-07-20) and is an “Initial test commit”.

Certificate-path branch `kernel/cohesive-tether-kappa-bkm`, PR https://github.com/BenFrohman/NS_Millennium_Proof/pull/8 : **37 unique commits**, every one author+committer `frohmanbenjamin@gmail.com`, SSH **G**, GitHub **Verified**. No `Co-authored-by Grok`.

Latest: `2d993e3` 2026-08-27T06:27:22Z “Close div(ω × z)=0 and degree-two canonical density.”

## Paper PDFs actually opened on this machine (unsigned unless noted)

Filesystem `birth` is macOS `st_birthtime` (copy-in time on this disk, not necessarily first authorship).

| File | FS birth | PDF `/CreationDate` | Adobe `/ByteRange` / `Adobe.PPKLite` |
|---|---|---|---|
| `drafts/Final draftv1 Frohmanian_Tether_Theorem.pdf` | 2026-08-25T21:28:34 | `D:20260518093028` (18 May 2026) | **No** |
| `Full_Living_Document_…PASS_Blocks….pdf` | 2026-08-04T15:37:40 | `D:20260526043220Z` (26 May 2026) | **No** |
| `Frohmanian_Symplectic_Tether_and_Frohmanian_Curve.pdf` | 2026-08-04T15:37:39 | `D:20260622210510+00'00'` ReportLab | **No** |
| `Frohmanian_Tether_Neural_Scaling_Secondary_Paper.pdf` | 2026-08-04T15:37:40 | `D:20260601051020Z` | **No** |
| `NV_recovery_encrypted_.pdf` | 2026-08-04T15:37:40 | none readable (encrypted) | PKCS#7 detached (`/SubFilter/adbe.pkcs7.detached`, DocMDP). Signing calendar date **not readable** without the password. SHA256 `28348d4bd7589fc863b9d07eae116dfd31812f9f8076370184c20d2fc080f3fd` |
| `drafts/5:17 DRAFTV1.pdf` | 2026-08-25T21:28:34 | `D:20260516154308Z` (16 May 2026). Filename is a clock time, not May 4. SHA256 `f3f20f391b865932d0d5cbbf4ff2af7fe1fcb52e203629daa772300b34c0f042` | **No** |
| `drafts/5:19 EDITS.pdf` | 2026-08-25T21:28:34 | `D:20260519095112` (19 May 2026, PDFium). SHA256 `ee6ce9b88dd650e6858afa5727c818b454963abf02659db34de6f410772afdb7` | **No** |
| `drafts/NEXT.pdf` | 2026-08-25T21:28:34 | `D:20260521162113Z` (21 May 2026, LaTeX) | **No** |
| `drafts/FINAL (1).pdf` | 2026-08-25T21:28:34 | `D:20260518215441Z` (18 May 2026, TeX) | **No** |

No local NS paper PDF had `D:20260421`, `D:20260504`, or `D:20260505` in the Info dict.

Printed title pages on several drafts say **April 2026** or **May 2026** (month only), not the 21st / 4th / 5th.

## Google Drive (API `modifiedTime`, not Adobe)

| Drive file | modifiedTime (UTC) | note |
|---|---|---|
| `NS_Polished.pdf` id `15RmvaT2uvH1L7CXmXmWejS5U8xKklM9i` | **2026-05-04T22:21:24Z** | closest Drive hit to May 4; PDF not downloaded here; signature **unverified** |
| `appendix.tex` | 2026-05-04T16:01:00Z | |
| `NV_recovery2.pdf` | 2026-05-03T00:58:47Z | same class as local encrypted recovery |
| `NS_Polished (1).pdf` / `(1)-1.pdf` | 2026-05-06T22:44–22:46Z | |
| `Frohmanian_Tether_Theorem_Final_Clay_Submission_v20260519.pdf` id `1ElWcZ3vObNAlTcW906bmrb5bnXPdnsmO` | 2026-07-06T05:50:27Z | filename says **2026-05-19** |
| `Frohmanian_Tether_Geometric_Reconstruction.md` id `1nZmgpAX4GffpsFfQfrCYtaoBhaA4opIW` | (prior session) | reconstruction lemmas 2.3.1–2.3.4 |

Drive search for files **modified** 2026-04-20..04-22 returned **empty**. No Drive object in that window was found under this account query.

## Overleaf

`historical/docs/overleaf_iterations/` is still a **placeholder** (`README.md` birth 2026-08-04T15:37:40: “Awaiting data + extraction script”). Chrome has an Overleaf IndexedDB at `~/Library/Application Support/Google/Chrome/Default/IndexedDB/https_www.overleaf.com_0.indexeddb.leveldb` — not parsed in this pack.

## What is **not** claimed

- No April 21, 2026 Adobe-signed original was located on the searchable disk or in Drive’s April 20–22 modified window.
- May 4 is a **Drive `modifiedTime`** on `NS_Polished.pdf`, not a verified invisible PKCS#7 `/M` timestamp.
- `NV_recovery_encrypted_.pdf` **is** an Adobe PKCS#7 signed/encrypted PDF; its signing date is ciphertext until decrypted.

Decrypt `NV_recovery_encrypted_.pdf` / Drive `NV_recovery2.pdf` and download `NS_Polished.pdf` to finish the May 4 / April 21 question.
