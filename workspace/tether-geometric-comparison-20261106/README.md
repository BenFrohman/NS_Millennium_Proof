Scratch comparison (not part of any repo). Pins: frohmanian-tether-geometric /workspace/fr @9e40ae70716f15fb25bbabc425aaedc0c97df7ef;
frohmanian-tether-verified @26f16da (sources identical at d757e1f). Lean v4.30.0-rc1, mathlib 0c154d6 (cache from /workspace/NS_Millennium_Proof).
- Actual.lean / Actual.out: lemmas against ACTUAL geometric defs (TetherKernel, TetheredBracket, Pi_u, pairing, Enstrophy, FunctionalDerivative, velocity_from_vorticity). Std axioms only.
- cmp/Compare.lean: abstract real-Hilbert comparison against FTVerified tetheredBracketVec. Std axioms only.
- Ax.lean / build.log: #print axioms for FieldJacobi / JacobiWitness theorems.
Build: oleans in /tmp/jrev/{olean,fr}; LEAN_PATH in /tmp/jrev/lp{,fr}.
