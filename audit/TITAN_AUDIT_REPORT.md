# titan-audit report: `ns_push`

**Verdict: PASS_WITH_WARNINGS**

- Generated (UTC): 2026-10-30T19:00:16+00:00
- Tool: titan-audit 1.0.0 (Benjamin Stanley Frohman (ORCID: 0009-0006-7068-3718))
- Toolchain: `leanprover/lean4:v4.30.0-rc1`  Git HEAD: `ca6709fc8b002cbe7e72fd8fecbebab0f2c8484f`
- Tree SHA-256: `96ee72b51b6b6839ca90f371aa2b997bcd3c19be641b6368f2a10081402cf7f1` over 112 files

## Build

- Build skipped (`--no-build`); audit used existing .olean files.

## Axiom audit

- Modules: 21  Theorems: 512  Clean (only propext/Classical.choice/Quot.sound): 512
- Nonstandard: 0

| Module | Theorems | Nonstandard |
|---|---:|---:|
| `NS_Millennium_Proof.Definitions.FrohmanianTether` | 1 | 0 |
| `NS_Millennium_Proof.Modules.AnalyticPipeline` | 14 | 0 |
| `NS_Millennium_Proof.Modules.ArnoldGeometric` | 43 | 0 |
| `NS_Millennium_Proof.Modules.AssemblyGap` | 6 | 0 |
| `NS_Millennium_Proof.Modules.ClayStatements` | 20 | 0 |
| `NS_Millennium_Proof.Modules.ClosureBlueprint` | 22 | 0 |
| `NS_Millennium_Proof.Modules.CubicSourceCertificate` | 6 | 0 |
| `NS_Millennium_Proof.Modules.ForMathlib.Projection` | 7 | 0 |
| `NS_Millennium_Proof.Modules.GlobalRegularity` | 2 | 0 |
| `NS_Millennium_Proof.Modules.HighSetDepletionAndBKM` | 8 | 0 |
| `NS_Millennium_Proof.Modules.IndependentMajorant` | 2 | 0 |
| `NS_Millennium_Proof.Modules.MainTheorem` | 6 | 0 |
| `NS_Millennium_Proof.Modules.NS_Equations` | 148 | 0 |
| `NS_Millennium_Proof.Modules.Stage6Calculus` | 35 | 0 |
| `NS_Millennium_Proof.Modules.SymplecticConstraint` | 61 | 0 |
| `NS_Millennium_Proof.Modules.SymplecticTether` | 38 | 0 |
| `NS_Millennium_Proof.Modules.TetheredLyapunov` | 58 | 0 |
| `NS_Millennium_Proof.Modules.TorusStrainExclusion` | 19 | 0 |
| `NS_Millennium_Proof.Modules.Uniqueness` | 16 | 0 |

## Source scan

Counts: axiom_outside_build=1, real_iSup_without_BddAbove=5, real_iSup_without_BddAbove_outside_build=6, sorry_outside_build=141, trivial_prop_def_outside_build=3, true_hypothesis_outside_build=1


### Vacuity heuristics (in build)

- real_iSup_without_BddAbove `NS_Millennium_Proof/Modules/NS_Equations.lean:2291` `Tstar`: Real iSup/sSup is 0 on unbounded ranges; downstream bounds on it may be vacuous unless BddAbove is required.
- real_iSup_without_BddAbove `NS_Millennium_Proof/Modules/NS_Equations.lean:2802` `vorticity_sup_norm`: Real iSup/sSup is 0 on unbounded ranges; downstream bounds on it may be vacuous unless BddAbove is required.
- real_iSup_without_BddAbove `NS_Millennium_Proof/Modules/NS_Equations.lean:2816` `strain_sup_norm`: Real iSup/sSup is 0 on unbounded ranges; downstream bounds on it may be vacuous unless BddAbove is required.
- real_iSup_without_BddAbove `NS_Millennium_Proof/Modules/SymplecticTether.lean:777` `MollifiedSupNormFunctional`: Real iSup/sSup is 0 on unbounded ranges; downstream bounds on it may be vacuous unless BddAbove is required.
- real_iSup_without_BddAbove `NS_Millennium_Proof/Modules/TetheredLyapunov.lean:502` `MollifiedSupNorm`: Real iSup/sSup is 0 on unbounded ranges; downstream bounds on it may be vacuous unless BddAbove is required.

Heuristics are advisory: a flag means *look here*, not *wrong*.

## Signature

- ed25519 public key (base64): `YoEHEghXFxrXvYKQoWQb+oDunzwdxBgpk03gxrdC7WI=`
- Verify: `titan-audit verify report.json`
