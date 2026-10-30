# titan-audit report: `NS_Millennium_Proof`

**Verdict: PASS_WITH_WARNINGS**

- Generated (UTC): 2026-10-30T18:34:46+00:00
- Tool: titan-audit 1.0.0 (Benjamin Stanley Frohman (ORCID: 0009-0006-7068-3718))
- Toolchain: `leanprover/lean4:v4.30.0-rc1`  Git HEAD: `49efc24531977445275884ae4713a8589ffbae24`
- Tree SHA-256: `7fb431288c4e54ae87eca27cb02e19576d3b919d497fd9f496939a934256d7d3` over 112 files

## Build

- Build skipped (`--no-build`); audit used existing .olean files.

## Axiom audit

- Modules: 21  Theorems: 502  Clean (only propext/Classical.choice/Quot.sound): 502
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
| `NS_Millennium_Proof.Modules.NS_Equations` | 143 | 0 |
| `NS_Millennium_Proof.Modules.Stage6Calculus` | 35 | 0 |
| `NS_Millennium_Proof.Modules.SymplecticConstraint` | 61 | 0 |
| `NS_Millennium_Proof.Modules.SymplecticTether` | 38 | 0 |
| `NS_Millennium_Proof.Modules.TetheredLyapunov` | 53 | 0 |
| `NS_Millennium_Proof.Modules.TorusStrainExclusion` | 19 | 0 |
| `NS_Millennium_Proof.Modules.Uniqueness` | 16 | 0 |

## Source scan

Counts: axiom_outside_build=1, real_iSup_without_BddAbove=5, real_iSup_without_BddAbove_outside_build=6, sorry_outside_build=141, trivial_prop_def_outside_build=3, true_hypothesis_outside_build=1


### Vacuity heuristics (in build)

- real_iSup_without_BddAbove `NS_Millennium_Proof/Modules/NS_Equations.lean:2290` `Tstar`: Real iSup/sSup is 0 on unbounded ranges; downstream bounds on it may be vacuous unless BddAbove is required.
- real_iSup_without_BddAbove `NS_Millennium_Proof/Modules/NS_Equations.lean:2801` `vorticity_sup_norm`: Real iSup/sSup is 0 on unbounded ranges; downstream bounds on it may be vacuous unless BddAbove is required.
- real_iSup_without_BddAbove `NS_Millennium_Proof/Modules/NS_Equations.lean:2815` `strain_sup_norm`: Real iSup/sSup is 0 on unbounded ranges; downstream bounds on it may be vacuous unless BddAbove is required.
- real_iSup_without_BddAbove `NS_Millennium_Proof/Modules/SymplecticTether.lean:777` `MollifiedSupNormFunctional`: Real iSup/sSup is 0 on unbounded ranges; downstream bounds on it may be vacuous unless BddAbove is required.
- real_iSup_without_BddAbove `NS_Millennium_Proof/Modules/TetheredLyapunov.lean:502` `MollifiedSupNorm`: Real iSup/sSup is 0 on unbounded ranges; downstream bounds on it may be vacuous unless BddAbove is required.

Heuristics are advisory: a flag means *look here*, not *wrong*.

## Signature

- ed25519 public key (base64): `YoEHEghXFxrXvYKQoWQb+oDunzwdxBgpk03gxrdC7WI=`
- Verify: `titan-audit verify report.json`
