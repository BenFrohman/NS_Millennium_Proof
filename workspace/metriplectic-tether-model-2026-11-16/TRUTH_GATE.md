# TRUTH GATE — read this first

Every agent and contributor loads this file before touching a Lean statement or any public text.

## The vacuity trap
A paper's claim is written in English. Lean can check `formal_claim ↔ paper_claim` only once
`paper_claim` is itself written in Lean. If `paper_claim` were defined as `formal_claim` (or aliased
or unfolded to it), `intended_correspondence` would be `Iff.rfl` and would certify anything.

## The lock in this repository
- `MetriplecticTetherModel/Semantics.lean` holds `formal_claim` (named-definition form of what the
  library proves) and `paper_claim` (an independent transcription of the paper's Main Theorem, with
  every kernel and right-hand side written out inline). Its doc comment carries the verbatim quote,
  the claim-source path `paper/main_theorem.tex` (which the paper `\input`s as Theorem 3.1), its
  sha256 and the section.
- `intended_correspondence : formal_claim ↔ paper_claim` is proved by translating each of the
  ten items (a)–(j), not by `rfl`. `main_theorem : paper_claim` is
  `intended_correspondence.mp formal_claim_holds`.
- The lock is **full**: all items (a)–(j) of the Main Theorem are locked. There is no partial lock.
- `truth-gate.lock.json` stores the hashes of `formal_claim`, `paper_claim`,
  `intended_correspondence`, the claim source, the manifest and the toolchain. The commit is
  recorded in `CERTIFICATE.md` (a file cannot contain the hash of the commit that contains it).
- **Approval status:** the `paper_claim` transcription is awaiting the author's explicit approval
  (`"approver": "PENDING …"`). Changing a locked statement needs the author's approval and a new lock.

## Checks (`./verify.sh`, `scripts/verify-lock.sh`, `.github/workflows/truth-gate.yml`)
The gate fails on: a failed `lake build`; `sorry`, `admit`, `native_decide`, `axiom`, `opaque`;
any theorem depending on an axiom other than `propext`, `Classical.choice`, `Quot.sound`;
a missing `Semantics.lean` or `intended_correspondence`; `paper_claim` mentioning `formal_claim` or
the named kernels; a correspondence proved by `rfl`; a missing or changed quote or sha256;
a lock-hash mismatch; a `leanchecker` failure; a missing copyright header.

## What may be said publicly
Exactly the locked Main Theorem, the commit and toolchain from `CERTIFICATE.md`, the axiom output,
and the rebuild command `./verify.sh`. In particular: this work does **not** prove global regularity
of the Navier–Stokes equations or of the tether model; it proves the two are equivalent.
