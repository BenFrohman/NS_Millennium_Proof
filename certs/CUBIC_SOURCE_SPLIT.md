# Cubic source versus cubic sink

Date: 2026-10-06. This note records the split. It does not close the proof.

The classical pairing at a spatial maximum is a cubic source:

    M' ≤ C_CZ M^2

for M > 0, once the pairing is at most C_CZ M^3. Transport is zero there and
viscosity is non-positive. The product rule multiplies by 1 + κ M^2 ≥ 0 and
preserves the source, giving a cubic term and a quintic term, both nonnegative.

The sink M' ≤ C M^2 − κ M^3 is `ring` applied to `CorrectedMaxRate`, which
already assumes the strain factor C M − κ M^2. That replacement is not an
identity for ω · ∂tω. B(F,H) ≡ 0 does not insert it.

`CubicSourceCertificate.lean` is the audit module. It is not imported by
`GlobalRegularity`, `TetheredLyapunov`, `IndependentMajorant`, or
`ClosureBlueprint`. Young absorption does not force the Riccati field.
`hRiccati` stays a hypothesis.

Copyright (c) 2026 Benjamin Stanley Frohman. Apache-2.0. See LICENSE and NOTICE.
