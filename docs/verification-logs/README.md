# Verification logs collected for the 23 November 2026 figures / Jacobi draft

America/Chicago timestamps.

## Grok-Millennium-Prime autonomous verification process

A case-insensitive search for `Millennium-Prime`, `Millennium Prime`, and
`Grok-Millennium-Prime` was run over:

- `BenFrohman/NS_Millennium_Proof` on `origin/main` (including the
  23 November 2026 handoff files `HANDOVER-2026-11-23.md`,
  `STATUS-FORM-B-2026-11-23.md`, `docs/TETHER_CONDITIONAL_SPINE.md`,
  and `docs/GROK_HANDOFF_2026-11-23_CONTEXT.md`)
- `/workspace/NS_Millennium_Proof`, `/workspace/names`, `/workspace/ns-context`
- this bot's store `/cursor/stores/store-97f91c13-adaf-4d2b-8291-6ef30c018a44`
- `/home/box` Downloads, reference, and the 4 November 2026 scratch backup

No drafts, logs, or transcripts of a process named Grok-Millennium-Prime
were found. The script `scripts/verify_millennium_complex_calcs.sh` prints
the banner "Grok-Millennium Complex Calcs Verifier"; that is a different
name and was not treated as a hit.

If those materials exist on another machine or in a chat export that was
not copied onto this computer, they still need to be provided for
archival under this directory.

The 23 November 2026 tether-context handoff used only to check figure
captions and the Jacobi status is **not** committed here. It is already
on `main` as `docs/GROK_HANDOFF_2026-11-23_CONTEXT.md` (`e4a9871`) and
was reserved for the separate conditional-theorem documentation path.

## Official CI at `6b78ba7` (last green Lean stack on `main` before the later documentation commits)

Lean source was not changed by those later documentation commits
(`a028242`, `a232661`, `209c18e`, `e4a9871`). Fresh Kernel certificate
and Lean CI runs on `e4a9871` were still queued or pending when this
note was written. The last completed official full stack on `main` is
the merge of PR #43:

| Workflow | Run ID | Result | Time (America/Chicago) |
|---|---|---|---|
| Kernel certificate | [45241230794](https://github.com/BenFrohman/NS_Millennium_Proof/actions/runs/45241230794) | success | 23 Nov 2026, 12:42 PM CST |
| Lean CI | [45241230406](https://github.com/BenFrohman/NS_Millennium_Proof/actions/runs/45241230406) | success | 23 Nov 2026, 12:42 PM CST |
| truth-gate | [45241230366](https://github.com/BenFrohman/NS_Millennium_Proof/actions/runs/45241230366) | success | 23 Nov 2026, 12:42 PM CST |
| Lean header | [45241230323](https://github.com/BenFrohman/NS_Millennium_Proof/actions/runs/45241230323) | success | 23 Nov 2026, 12:42 PM CST |
| CodeQL Advanced | [45241230457](https://github.com/BenFrohman/NS_Millennium_Proof/actions/runs/45241230457) | success | 23 Nov 2026, 12:42 PM CST |

Head SHA: `6b78ba7f59f1def862744e7325619c5f34e1f4d0`.
Toolchain: `leanprover/lean4:v4.30.0-rc1`.

Copies of the kernel-certificate artifact excerpts are in
`official-ci-6b78ba7/`. SHA-256 of those copies:

| File | SHA-256 |
|---|---|
| `sorry-scan.txt` | `3baa9702f0996e328d96bb43a10dfe6787a9f66d97e46b7ad3d36b3d5d45560d` |
| `environment.txt` | `5ffb1b54b3ee1a85ba550ce215730702c1c6e553fecc292f5949e91ad210cf06` |
| `axioms.txt` | `397d217ccdc7141971df2bc688873ba69d3d9adf94e178c1fe0156090585ce9e` |
| `leanchecker.txt` | `7bd45d0c296164b6edf75854d61732cc72e350d324bdd044d9d8c7a725922e62` |

Kernel certificate results at that commit:

- `sorry_scan.py`: 131 tracked `.lean` files scanned; **0 hits in the certified library**.
- Certificate scope excludes `historical/`, `docs/`, and `scripts/truth-gate-tests/`
  (109 excluded hits, tabulated below). This skip list is exactly what
  open [PR #44](https://github.com/BenFrohman/NS_Millennium_Proof/pull/44)
  proposes to remove; that PR is currently red and is left untouched here.
- Axiom audit: `AUDIT PASS: 691 theorems in 30 modules depend only on propext, Classical.choice, Quot.sound (or on no axioms)`.
- leanchecker: `32 of 32 modules replayed through the kernel, 0 failures`.

Lean CI at run 45241230406 also passed its lake build and strict axiom
audit. Its `lean-certificate` artifact is not duplicated here; the
kernel-certificate sorry scan is the official full-log scan used for
the table below.

## Sorry table (official scan at `6b78ba7`, run 45241230794)

### Certified library (live modules)

**Zero remaining `sorry` / `admit` / `native_decide` / `axiom` declarations.**

The Jacobi identity gap is therefore **not** a `sorry` on current `main`.
See the Jacobi status section below. Comments in
`Modules/SymplecticTether.lean` that still speak of a remaining `sorry`
inside `h_cyclic_integrand_zero` and of `#print axioms` showing
`sorryAx` are stale relative to the live theorem.

### Excluded hits (not certified; 109 total)

Classification: these are archived snapshots, prose sketches, or
deliberate truth-gate fixtures. They are not part of the live library
certificate. The May 2026 `complete_implementation_2026-05-28` tree
includes early Jacobi / tether stubs; those are historical, not the
live gap.

| File | Hits | Classification |
|---|---|---|
| `historical/previous_implementations/complete_implementation_2026-05-28/ForMathlib/NS/Tether.lean` | 42 | historical snapshot (classical black-box / early tether stubs) |
| `docs/Clarified_Degeneracy_and_Majorant_Blocks.lean` | 18 | docs sketch, not a Lake target |
| `historical/previous_implementations/complete_implementation_2026-05-28/Modules/IndependentMajorant.lean` | 10 | historical snapshot (analytic / majorant black-boxes) |
| `historical/previous_implementations/complete_implementation_2026-05-28/Full_Proof_Skeleton.lean` | 9 | historical snapshot |
| `historical/.../Modules/AnalyticEstimates.lean` | 5 | historical snapshot (classical black-box) |
| `historical/.../Modules/ArnoldGeometric.lean` | 5 | historical snapshot |
| `historical/.../Modules/TetheredLyapunov.lean` | 5 | historical snapshot (analytic black-box) |
| `historical/.../Modules/SymplecticTether.lean` | 4 | historical snapshot (includes early Jacobi / kernel stubs) |
| `historical/previous_implementations/PaperFormalization.lean` | 3 | historical snapshot |
| `historical/.../Modules/NS_Equations.lean` | 3 | historical snapshot (classical black-box) |
| `historical/.../Modules/DataStructures.lean` | 1 | historical snapshot |
| `historical/.../Modules/GlobalRegularity.lean` | 1 | historical snapshot |
| `scripts/truth-gate-tests/neg_axiom.lean` | 1 | fixture (must contain a forbidden token) |
| `scripts/truth-gate-tests/neg_native_decide.lean` | 1 | fixture |
| `scripts/truth-gate-tests/neg_sorry.lean` | 1 | fixture |

Full line-level listing: `official-ci-6b78ba7/sorry-scan.txt`.

## Jacobi status (`tethered_jacobi_identity` / `h_cyclic_integrand_zero`)

### On current `main` (`e4a9871`, and already in this form at `6b78ba7`)

`h_cyclic_integrand_zero` is **not present**. The live theorem is

```lean
public theorem tethered_jacobi_identity (F G H : Functional) (ω : CoadjointOrbit)
    (X Y Z : VelocityField)
    (_hF : FunctionalDerivative F ω = X)
    (_hG : FunctionalDerivative G ω = Y)
    (_hH : FunctionalDerivative H ω = Z)
    (hident : jacobiator F G H ω =
      ∫ x, cyclicLiePairing X Y Z x ∂volume)
    (hvanish : (∫ x, cyclicLiePairing X Y Z x ∂volume) = 0) :
    jacobiator F G H ω = 0 := by
  rw [hident, hvanish]
```

This is a rewrite from two explicit hypotheses. It does not prove that
the jacobiator equals the cyclic integral, and it does not prove that
the cyclic integrand vanishes. The algebraic 9-term IBP + cyclic
cancellation therefore remains **open**, packaged as hypotheses rather
than as a `sorry`. The two-layer architecture is unchanged: geometric
Layer 1 is not used to close analytic Layer 2 / Form B.

The comment block immediately above the theorem still describes "the
remaining `sorry` inside `h_cyclic_integrand_zero`". That comment was
left in place; this draft does not rewrite the Lean file.

This form was introduced on `main` in `ed45dcc` ("Complete
IsPhysicalNSSolution non-vacuity repair..."). No later branch was
found that closes `hident` / `hvanish` by a kernel-checked 9-term
cancellation. Closing it honestly would require the term-by-term
algebra the older comments already say is missing from the sources; it
was not invented here.

### Older expanded form (still on stale branches, not on `main`)

Branches such as `preserve/gateaux-pairing-local-2026-11-04` (and many
older topic branches, all far behind `main`) still have the earlier
statement

```lean
public theorem tethered_jacobi_identity (F G H : Functional) (ω : CoadjointOrbit) :
    jacobiator F G H ω = 0 := by
  have h_classical_jacobi : jacobiator F G H ω = 0 := by
    sorry   -- classical (black-box; MWR from sources)
  have h_correction_jacobi : jacobiator F G H ω = 0 := by
    have h_corr_expansion : jacobiator F G H ω = 0 := by
      sorry   -- classical (black-box)
    have h_cyclic_integrand_zero : jacobiator F G H ω = 0 := by
      -- named haves h_t1_after_IBP …, each `sorry`
      ...
```

Those `sorry` leaves are the documented Jacobi-gap / MWR black-boxes.
They were not merged forward as a proof; they were replaced on `main`
by the hypothesized form above. Those branches were not replayed onto
this draft.

### What was not done

Lean was not changed on this branch. In particular this draft does not
add a `sorry`, does not restore the old have-block, and does not invent
a cyclic-cancellation proof.
