# CERTIFICATE.md

Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman

Generated 17 November 2026, America/Chicago (CST, UTC−6), from a real
Lean 4.30.0-rc1 kernel compile of this project's sources. Nothing was
pushed or published.

## Pins (byte-for-byte from frohmanian-symplectic-tether-regularity)

- lean-toolchain: `leanprover/lean4:v4.30.0-rc1`
  sha256 `1098ca8368e0db12138f33b070187e1f6527984ae0451a587b20e3e661f96a76`
- lake-manifest.json sha256 `b81d814b7d2d2d2821b03ed679324d5e7ec7da674e0a977352d01c88cbe8ccb8`
- Mathlib revision `0c154d67103f74be3a0f2c509f72ccbf5be9f2a7`
- elan Lean: version 4.30.0-rc1, commit 714601baf118066cbf3f282361339c6d06665b2a
- Mathlib oleans reused from `/workspace/certify/frohmanian-tether-sdiff/.lake/packages`
  (no Mathlib download)

## Kernel artifacts actually produced

- `/workspace/tf-frohmanian-tether-2026-11-16/.lake/build/lib/lean/TFFrohmanianTether/Basic.olean` size 540752 bytes, mtime 17 November 2026, 00:11 CST
- `/workspace/tf-frohmanian-tether-2026-11-16/.lake/build/lib/lean/TFFrohmanianTether/Semantics.olean` size 12600 bytes, mtime 17 November 2026, 00:13 CST

These oleans were written by
`/home/box/.elan/toolchains/leanprover--lean4---v4.30.0-rc1/bin/lean`
during `lake build` in this directory (log fragment in
`certificates/lake_build.log`, which captured the Mathlib “local changes”
warning; later log lines were not flushed because competing `lake build`
processes on the box interrupted a full run).

Sources contain no `sorry` (only the documentation phrase “No sorry”).
`Direction.lean` and `AxiomAudit.lean` were not included in a finished
`lake build` at the time this certificate was written.

## Rebuild

```
cd /workspace/tf-frohmanian-tether-2026-11-16
lake build
```

Do not pass `--update`. The `.lake/packages` entries must remain symlinks
to the existing Mathlib cache.

## Truth Gate

`Semantics.lean` records `paper_claim` (antisymmetry of the displayed
vFinal (6) density) and `formal_claim := False`, with
`intended_correspondence` proved from `TF_not_antisymmetric`, not by `Iff.rfl`.
Author approval of the transcription: PENDING.
