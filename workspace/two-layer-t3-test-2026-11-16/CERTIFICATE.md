# Lean kernel certificate — TwoLayerT3 (local, unpublished)

Copyright (c) 2026 Benjamin Stanley Frohman. Author: Benjamin Stanley Frohman

Generated 2026-11-16 22:21 America/Chicago by `lean/make_certificate.py` from the build logs below.

## Toolchain provenance
- Manifest/toolchain source repo: BenFrohman/frohmanian-symplectic-tether-regularity @ `2a649d1d2671d9059af47c4cfaf9748b82d71a5b`
- lake-manifest.json identical to repo copy: yes; sha256 `b81d814b7d2d2d2821b03ed679324d5e7ec7da674e0a977352d01c88cbe8ccb8`
- lean-toolchain identical to repo copy: yes; contents `leanprover/lean4:v4.30.0-rc1`; sha256 `1098ca8368e0db12138f33b070187e1f6527984ae0451a587b20e3e661f96a76`
- Mathlib rev (manifest): `0c154d67103f74be3a0f2c509f72ccbf5be9f2a7`; checked-out package HEAD: `0c154d67103f74be3a0f2c509f72ccbf5be9f2a7`
- Mathlib oleans: the prebuilt cache already fetched (`lake exe cache get`) for this exact rev in `/workspace/certify/frohmanian-tether-sdiff/.lake/packages` (symlinked; all 9 package revs equal the manifest). A fresh `cache get` here failed: disk full. Mathlib worktree differs from its rev only by 6 deleted files under `scripts/bench/` (no `.lean` changes).
- elan 4.2.4 (227caca13 2026-08-25); Lake version 5.0.0-src+714601b (Lean version 4.30.0-rc1)
- Lake package and mathlib requirement identical to the repo's lakefile; only the `lean_lib` target is `TwoLayerT3`.

## Builds
- `certificates_lake_build_full.log` sha256 `f60d5ea8048dc80c396c5ad1da38f53c2b142513bc1a2d24e34334384a643e15`: `Build completed successfully`, LAKE_EXIT=0
  - Built TwoLayerT3.Tether (90s)
  - Built TwoLayerT3.LayerTwo (90s)
  - Built TwoLayerT3.ExplicitFields (90s)
  - Built TwoLayerT3.Semantics (162s)
  - Built TwoLayerT3.AxiomAudit (84s)
  - Built TwoLayerT3 (265s)
- `certificates_lake_build_final.log` sha256 `606d7f18cd55aa2405bd7021e07ab4328bef8303ec274f9fc0c3dc09d41787a6`: `Build completed successfully`, LAKE_EXIT=0
  - Replayed TwoLayerT3.Tether
  - Replayed TwoLayerT3.ExplicitFields
  - Replayed TwoLayerT3.LayerTwo
  - Replayed TwoLayerT3.Semantics
  - Built TwoLayerT3.KernelVersions (224s)
  - Built TwoLayerT3.AxiomAudit (52s)
  - Built TwoLayerT3 (62s)

## `#print axioms` (final build log, verbatim)
```
16:0: 'TwoLayerT3.intended_correspondence' depends on axioms: [propext, Classical.choice, Quot.sound]
17:0: 'TwoLayerT3.paper_claim_refuted' depends on axioms: [propext, Classical.choice, Quot.sound]
18:0: 'TwoLayerT3.projPerp_self' depends on axioms: [propext, Classical.choice, Quot.sound]
19:0: 'TwoLayerT3.inner_projPerp_u' depends on axioms: [propext, Classical.choice, Quot.sound]
20:0: 'TwoLayerT3.projPerp_idem' depends on axioms: [propext, Classical.choice, Quot.sound]
21:0: 'TwoLayerT3.tether_degenerate' depends on axioms: [propext, Classical.choice, Quot.sound]
22:0: 'TwoLayerT3.metriplectic_rate_tether_drops' depends on axioms: [propext, Classical.choice, Quot.sound]
23:0: 'TwoLayerT3.tether_no_feedback' depends on axioms: [propext, Classical.choice, Quot.sound]
24:0: 'TwoLayerT3.tether_degenerate_iff' depends on axioms: [propext, Classical.choice, Quot.sound]
25:0: 'TwoLayerT3.projPerp_eq_zero_imp' depends on axioms: [propext, Classical.choice, Quot.sound]
26:0: 'TwoLayerT3.tether_not_antisymm' depends on axioms: [propext, Classical.choice, Quot.sound]
27:0: 'TwoLayerT3.tether_degenerate_L2' depends on axioms: [propext, Classical.choice, Quot.sound]
28:0: 'TwoLayerT3.Explicit.div_free' depends on axioms: [propext, Classical.choice, Quot.sound]
29:0: 'TwoLayerT3.Explicit.lap_u1' depends on axioms: [propext, Classical.choice, Quot.sound]
30:0: 'TwoLayerT3.Explicit.lap_u2' depends on axioms: [propext, Classical.choice, Quot.sound]
31:0: 'TwoLayerT3.Explicit.lap_u3' depends on axioms: [propext, Classical.choice, Quot.sound]
32:0: 'TwoLayerT3.Explicit.viscous_difference_value' depends on axioms: [propext, Classical.choice, Quot.sound]
33:0: 'TwoLayerT3.Explicit.viscous_difference_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound]
34:0: 'TwoLayerT3.Explicit.curl_a' depends on axioms: [propext, Classical.choice, Quot.sound]
35:0: 'TwoLayerT3.Explicit.a_not_multiple_of_u' depends on axioms: [propext, Classical.choice, Quot.sound]
36:0: 'TwoLayerT3.LayerTwo.phi_term_deriv' depends on axioms: [propext, Classical.choice, Quot.sound]
37:0: 'TwoLayerT3.LayerTwo.phi_term_source' depends on axioms: [propext, Classical.choice, Quot.sound]
38:0: 'TwoLayerT3.LayerTwo.cubic_rate_amplitude' depends on axioms: [propext, Classical.choice, Quot.sound]
39:0: 'TwoLayerT3.LayerTwo.enstrophy_rate_amplitude' depends on axioms: [propext, Classical.choice, Quot.sound]
40:0: 'TwoLayerT3.kernelB_eq' depends on axioms: [propext, Classical.choice, Quot.sound]
41:0: 'TwoLayerT3.kernelB_degenerate' depends on axioms: [propext, Classical.choice, Quot.sound]
42:0: 'TwoLayerT3.kernelB_diag_nonpos' depends on axioms: [propext, Classical.choice, Quot.sound]
43:0: 'TwoLayerT3.kernelB_diag_neg' depends on axioms: [propext, Classical.choice, Quot.sound]
```

## Source files
- `TwoLayerT3.lean` sha256 `9861324e1faaa997dd1b7d5b4bb57a3feea5f9e82e5bb30b137ea5a6ec1f9fcd`
- `TwoLayerT3/AxiomAudit.lean` sha256 `57c7068cf0e4520f8ac2f77335e792da34107c41666a30da491b7ee62d694c82`
- `TwoLayerT3/ExplicitFields.lean` sha256 `018807430cb855005080bc6b8140cd26cad54d0e2e8ce4ef69367ae99206a357`
- `TwoLayerT3/KernelVersions.lean` sha256 `e87438f3aa90569e04c7b5faa7f9594e99b78143bf9e4346446fe22c762a03d1`
- `TwoLayerT3/LayerTwo.lean` sha256 `83417198f487b9012ae57f33a40e2869e935385953b7bce6c9534b510f171af8`
- `TwoLayerT3/Semantics.lean` sha256 `e89f7533cda8690627f46e3df4ab316ddce4b15261adcf9cbb3bb9e7c7da8ac6`
- `TwoLayerT3/Tether.lean` sha256 `16d05cc778aa9cc045d5621d255faa4789a85d744ee3bd77e8b10f76812ca860`

## Checks
- `sorry`/`admit`/`native_decide` occurrences: 0
- truth-gate script: TRUTH GATE (local checks): PASS — locked paper_claim is kernel-proved equivalent to False (claim refuted); author approval of transcription PENDING

Rebuild: `cd /workspace/two-layer-t3-test-2026-11-16/lean && lake build`
