FIX: IntervalIntegral -> intervalIntegral
- ConditionalNavierStokesTetherFull.lean: open IntervalIntegral -> intervalIntegral (Mathlib namespace case)
- ConditionalNavierStokesTetherFull.lean: import Mathlib.Analysis.Calculus.MeanValue -> Deriv.MeanValue (lemma moved)
- ConditionalNavierStokesTetherFull.lean: ContinuousOn.intervalIntegrable -> intervalIntegrable_of_Icc (API expects uIcc; of_Icc takes a≤b)
- ConditionalNavierStokesTetherFull.lean: rewrote gronwall_vorticity_bound proof body for Mathlib v4.22 (uIcc/Icc, antitoneOn_of_hasDerivWithinAt_nonpos, continuousOn_primitive_interval', ContinuousOn.stronglyMeasurableAtFilter). Statement unchanged.
- Added import Mathlib.Analysis.Calculus.Deriv.Mul
- open Filter + scoped Topology for 𝓝 notation
- FrohmanianTetherComplete.lean: added FundThmCalculus/Deriv.MeanValue/Mul imports + Filter/Topology (still needs proof rewrite)
