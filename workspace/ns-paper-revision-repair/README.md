# Local provenance repair proposal

No published content changed.

{
  "status": "LOCAL PROPOSAL ONLY; no publication or fresh build",
  "published_record": "10.5281/zenodo.23749850",
  "existing_archived_commit": "8a5ec50",
  "first_history_commit_with_named_sources": "b04619c120852a33523363eb3fc3225d3fc5ae0e",
  "ci_verified_candidate": "c98fe859867affeba4508b3e51583cfa6b20087c",
  "ci_run": "https://github.com/BenFrohman/NS_Millennium_Proof/actions/runs/42311131768",
  "ci_audit": {
    "theorems": 488,
    "nonstandard": 0,
    "module_entries": 19,
    "scope": "imported theorem constants under NS_Millennium_Proof module prefix, excluding internal names"
  },
  "toolchain": "leanprover/lean4:v4.30.0-rc1",
  "mathlib_commit": "0c154d67103f74be3a0f2c509f72ccbf5be9f2a7",
  "blocking_semantic_mismatch": "Paper defines DirectionCurvatureBound as differentiability plus cubic differential inequality. Lean abbrev aliases PeriodicDirectionDepletionBound: uniform sup norm envelope, without derivative/coercivity premises. No exact complete PDF-matching revision established.",
  "proposal": "Keep old archive/records. Add reviewed exact-source manifest and theorem-to-hypothesis table; align paper definition with actual Lean or prove derivative-to-envelope bridge for actual PDE norms before publication. Do not substitute new SHA alone as full repair."
}
