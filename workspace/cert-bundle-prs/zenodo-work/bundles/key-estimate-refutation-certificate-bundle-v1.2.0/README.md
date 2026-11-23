# Key-estimate refutation v1.2.0 certificate bundle

Lean kernel materials and outside checks from the GitHub Actions
verify-logs artifacts of runs 42916652258 (pull_request) and
42916649801 (push). Both runs are at commit
715626e2de363edd674b458dbb492cfa004c5b03, both concluded success,
and the two artifacts are byte-identical.

https://github.com/BenFrohman/ns-tether-key-estimate-refutation/actions/runs/42916652258
https://github.com/BenFrohman/ns-tether-key-estimate-refutation/actions/runs/42916649801

The files under lean-kernel/ are the Lean lake build log and the
#print axioms output from that artifact, together with this
repository's own lean/lake-manifest.json and lean/lean-toolchain
at 715626e, with sha256 (those two files were not inside the
verify-logs artifact).

The files under outside-checks/ are not Lean kernel certificates:
- v2_maxcert.log: Arb interval-arithmetic numeric check
- v1_trig_example.log: Python / sympy computation
- v2_symbolic.log and v2_sym.pkl: Python / sympy computation

Toolchain: Lean 4.22.0 (see lean-toolchain).
Mathlib revision: 79e94a093aff4a60fb1b1f92d9681e407124c2ca (v4.22.0).
