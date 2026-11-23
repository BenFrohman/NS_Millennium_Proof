# Actual spatial bridge: kernel-checked milestone

Base: merged Clay- main ae6f0211cac75de6e6f5f9370c699b46b7159212, verified unchanged. Local integration snapshot/patch only; no new branch, commit or remote mutation.

The exact original SpatialBridgeObligation has an inhabitant: spatialBridgeObligation_proved. No comparison, extra regularity, temporal-integrability or BKM premise is inserted into it. All prior theorem statements and the original target Prop are unchanged.

Proof: existing NSOn joint smoothness -> spatial C2 time slice -> mixed-partial symmetry -> actual div(curl)=0 and differentiable curl -> norm/normalized-curl product rule -> actual log-vorticity derivative along actual tangent -> FTC -> exponential endpoint comparison. Zero peak vorticity is handled separately. Intermediate LogDerivativeAlong is proved, not assumed in the final theorem.

Ten new explicit named theorems in Clay.Depletion.SolutionLinkedVortexLines: pd_pd_comm, div_curl_eq_zero, curl_differentiable_of_C2, spatialC2_of_NSOn, norm_direction_derivative, logDerivativeAlong_of_spatialC2, spatialComparison_of_logDerivativeAlong, spatialComparison_of_NSOn, spatialBridgeObligation_proved, bkmIntegralFinite_of_NSOn_and_endpoint.

Fresh checks: solution-linked dependency, ActualSpatialBridge, rebuilt Clay root, SolutionLinkedRegression and full AxiomReport pass with pinned Lean 4.16.0 cached dependencies. Full audit: 125 theorem declarations including generated (12 in new module, ten explicit named), 236 audited declarations, zero nonstandard axioms. Unchanged modules reuse previously checked objects. No dependency rebuild, installation or download.

README, scope documentation, monograph TeX/PDF, regressions and AXIOMS.md synchronized. Forward/reverse binary patch checks pass. LICENSE unchanged; no existing theorem weakened. Evidence is incremental, not a standalone trusted proof certificate or peer review.

The new BKM criterion assumes only actual NSOn, a linked Packet and separately finite actual endpoint time integral; no assumed SpatialComparison remains. Constructing uniformly bounded measurable packets for arbitrary solutions and proving those endpoint integrals finite remain open. This does not prove Statement B or unconditional regularity. This formalizes the classical spatial DHY Lemma 1/Theorem 1 argument, not Euler-only Theorem 2 and not a novelty claim.

Parent should independently review and apply the patch on a new branch before any separately authorized push. Commit identity: Frohman, Benjamin Stanley <frohmanbenjamin@gmail.com>, without coauthor trailers.
