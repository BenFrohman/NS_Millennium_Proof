# Local review: NS uniform/differential correction

Baseline/live main checked: c98fe859867affeba4508b3e51583cfa6b20087c.
No remote write, commit, push, PR, merge, tag, release, history rewrite, deletion
or publication was performed. This is a local reviewable patch only.

## Principal source implementation

1. Accurate `UniformVorticityEnvelopeBound` public name for the exact existing
   `PeriodicDirectionDepletionBound` body; legacy `DirectionCurvatureBound` and
   the original theorem remain definitionally compatible.
2. Actual-u `CubicVorticityDifferentialBound u τ C κ_cubic`, with bounded spatial
   vorticity ranges, ordinary norm differentiability on [0,τ], positive constants
   and the actual cubic derivative inequality. It is an explicit additional
   hypothesis, NOT a newly derived PDE estimate or a disguised envelope field.
3. New named theorems in `FrohmanianTether.HighSetDepletionAndBKM`:
   - vorticity_envelope_of_cubic_differential_bound
   - pointwise_vorticity_envelope_of_cubic_differential_bound
   - periodic_solution_envelope_of_compact_cubic_bounds
   - cubicVorticityDifferentialBound_zero
   - clay_reduces_to_uniform_vorticity_envelope
4. New named theorems in `NS_Millennium_Proof.Stage6`:
   - exponential_profile_hasDerivAt
   - exponential_profile_satisfies_cubic_bound
   - fixed_cubic_constants_fail_for_some_amplitude

The compact theorem applies existing `comparison_ode_ceiling` with every premise.
The half-open theorem uses compatible compact bounds with SAME constants and the
actual solution's initial identity. The pointwise conclusion uses the supremum's
boundedness guard. A true globally zero trajectory passes the new regression.
The original envelope definition body and all original Stage6 proof bodies were
compared unchanged; both existing mirrored modules are synchronized. No axiom,
`sorry`, `native_decide`, weaker established theorem or new geometric/PDE axiom.

## Bounded actual PDE check: stronger direction coercivity is false

Let ν>0, k=2π, a=νk², A>0. The actual periodic shear

    v(t,x) = A exp(-at) (sin(k x₃), 0, 0), p=0

has zero convection/divergence and ∂tv=νΔv. Its actual vorticity is
(0, k A exp(-at) cos(k x₃), 0). At x₃=0 its norm is the positive spatial maximum
M=k A exp(-at), while ξ=(0,1,0) in a neighborhood, so |∇ξ|²=0. Therefore the bare
premise κ M²≤ν|∇ξ|² from `viscous_direction_dissipation_bridge` is FALSE there for
every κ>0, even if data-dependent. This is not a disproof of the conditional
lemma, the data-dependent envelope, or a differently thresholded estimate.
It rules out promoting this direction-only premise to a universal PDE law.
Amplitude curvature supplies the actual damping: ω·Δω=-k²M² and M'=-aM.

For the two-component Beltrami mode, M=M₀ exp(-at) as well. Fixed C,κ across all
amplitudes fail, but C=κ M₀ gives a genuine data-dependent cubic estimate. The
scalar derivative, sufficient inequality and quantified fixed-constant
obstruction are Lean-checked; the full vector/PDE/supremum assembly is an explicit
analytical calculation in the addendum, NOT newly assembled into Lean here.
Scaling sends κ to κ/λ² rather than a fixed positive coefficient; on the unit
torus use positive integer λ. Neither amplitude nor scaling disproves constants
that are allowed to depend on the initial datum.

## Precisely unproved work

Derive for general actual solutions the net-source estimate

    ω·Sω + ν ω·Δω ≤ C M³ - κ M⁴

at the relevant maxima, with the right time/lifespan/data quantifiers, and justify
an appropriate maximum-in-time one-sided/Dini derivative comparison. The checked
source reduction assumes this source estimate; it does not prove it. Bare
endpoint L∞ Calderón–Zygmund cannot silently supply it.

Ordinary differentiability at 0 cannot follow for ALL represented local solutions:
negative times are unconstrained; the zero forward solution can be extended by a
nonzero Beltrami field for negative times, making M jump at 0. Also spatial
suprema can switch maximizing branches. Accordingly the closed-interval
predicate is explicitly conditional on a given actual trajectory, not asserted
universally from local PDE smoothness. Periodic BKM continuation remains a
separate explicit premise in the global reduction.

## Tests actually completed

- Pinned Lean4.30.0-rc1, Mathlib0c154d67103f74be3a0f2c509f72ccbf5be9f2a7.
- `lake build`: full project build passed (2712 jobs including dependency targets).
- `lake env lean scripts/AxiomAudit.lean`: 497 noninternal project theorem
  declarations, nonstandard transitive axioms 0.
- `lake env lean scripts/EnvelopeCorrectionAudit.lean`: old API regression and
  per-new-theorem axiom prints passed (only standard axioms).
- `lake env lean scripts/CertificateAxiomInventory.lean`: all 497 declarations
  exported with their transitive axiom sets; sorted TSV supplied.
- All 9 dependency HEADs match pins. Eight tracked trees clean; Mathlib has six
  pre-existing benchmark-script deletions, no changed Lean proof sources.
  These were not repaired/deleted. Pinned cached artifacts were reused, not a
  clean dependency rebuild.
- New audit scripts are invoked by the proposed CI workflow. No new remote CI
  run exists because nothing was pushed. Prior run42311131768 is NOT validation
  of this patch.
- Deterministic documentation generator checked. Its former incorrect parent
  root and unconditional proof-status prose are replaced by the maintained
  precise mapping; regex inventory is no longer passed off as semantic audit.
- New correction TeX/PDF synchronized: four pages, cached-only Tectonic, no
  resource download; PDF metadata author is Frohman, Benjamin Stanley. First-page
  rendering inspected. Original manuscript PDFs and Zenodo records unchanged.
- Forward binary/source patch application, reverse-application CHECK, and
  byte-for-byte equality with the final tested source snapshot passed.
  Git notes one intentional Markdown hard-line-break (two trailing spaces);
  there was no patch-application error in the final validation.

## Delivery files

- after/ : final tested source snapshot
- ns-envelope-correction.patch : 15-file source/binary patch
- ns-envelope-correction-certificate.tar.gz : 5.2 MB review/proof bundle
- docs/VORTICITY_ENVELOPE_CORRECTION.md and correction TeX/PDF inside after/
- review-*.log, per-theorem-axioms.tsv, dependency-state.json,
  patch-validation.log, structural-validation.log, delivery-validation.json

Patch SHA256: 0884e251291ad5074fc09586ee17e50e23f652b2de09ba0e1633a67015ff87ae
Bundle SHA256: 2e7d36831fc263a3e9c9df631c68c05abb486c902bbd5dbf4d713238074eb0ee

Bundle: 231 manifested payload files; 143 compiled-project/artifact
files including .olean/.private/.server/.ilean and hash companions. Every payload
was checked both on disk and inside serialized tar entries. Includes proof
sources, exact pins, logs, per-theorem audit, preserved project LICENSE and
third-party notice/license copies, hashes and reproduction instructions. Not an
independently trusted standalone proof certificate, semantic correctness proof,
mathematical novelty claim or unconditional Navier–Stokes solution.

Author for any future reviewed commit: Frohman, Benjamin Stanley
<frohmanbenjamin@gmail.com>; no coauthor/trailer. No relicensing.
