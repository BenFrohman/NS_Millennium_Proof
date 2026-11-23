# CHANGELOG: manuscript v2 (2026-10-23)

- **Source:** Drive `Frohmanian_Tether_Final_Submission_v8.tex` (modified Aug 18), copied to `src/v8.tex`.
- **Cross-checked against:** `Frohmanian_Symplectic_Tether_ArXiv (9).pdf`, `ns_push` (main-equivalent) and `ns_trial` (uncommitted).
- **Not done:** nothing was pushed, committed or uploaded.

## Changed
- **Title and author:** the title is now the requested one, with a "conditional reduction" subtitle. The author is "Benjamin Stanley Frohman".
- **Abstract, intro, Thm 1.1, Thm 6.1:** all now conditional. Kato + rate $$M'\le C_{CZ}M^2-\kappa''M^3$$ ⇒ global regularity, via ceiling + BKM + restart. The rate is stated as OPEN (`sorry` in `reduced_pairing_of_unmodified_and_tether`).
- **Riccati inequality:** the quadratic $$M'\le C-\kappa'M^2$$ and its tanh solution are removed. Replaced by the cubic Lemma 5.1 (`comparison_ode_stability`), Lemma 5.2 (`comparison_majorant_global_bound`) and Prop 5.1 (`riccati_ceiling_of_vorticity_di`), with ceiling $$\max(M(0),C/\kappa'')$$.
- **Kept:** $S(t)$ and $\varphi$ with $$\partial_t\varphi+u\cdot\nabla\varphi=|\omega|^2$$, now described as a vehicle that produces no rate.
- **"Symplectic completion" retracted:** the tether is now called a "projected metric correction with degeneracy and feedback properties". New Remark 3.1: `TetherKernel` is symmetric.
- **A1–A5:** an axiom table records the status of each.
- **Appendix A:** the lemmas are now explicitly sketches.
- **Viscosity:** the claim that the bracket reproduces full NS is removed. The Laplacian is handled via BKM and parabolic regularity.
- **CZ bound:** Remark 4.1 states that the CZ $$L^\infty$$ bound is a hypothesis (`hCZ`) and false in general.

## Added
- **§6.1 audit:**
  - `library_huniq_unsatisfiable_at_zero` and `closing_bound_uniqueness_family_unsatisfiable` mean the main theorems are vacuous.
  - The ⌊t⌋ rotation counterexample shows `FrohmanianTetherBound 0 ν` is false.
  - The repair (a time-smooth class) is in progress.
- **§7:**
  - Verbatim `Clay_B_exact`, `IsPeriodicSmoothSolution` and `clay_B_exact_of_periodic_tether_bound`.
  - The scaling obstruction (HWEIGHT, SCALE_INVARIANT): the closing bound is BKM-equivalent, and $$\mathbb T^3$$ gives no advantage.
- **§8 Open Problems:**
  - (rate) the rate at maxima;
  - (symp) $$d\mathfrak T_F=0$$, Jacobi (MWR does not license it; the Lean proof is a pass-through), non-degeneracy, coadjoint invariance (Lean action is the identity);
  - (visc) viscosity;
  - formal repairs.
- **§9:** the scope section, with the geometric/analytic layers and a status table.
- **Appendix B:** Lean statements quoted verbatim (extracted by `extract.py` into `lean/`).
- **New observations:** `uniqueness_of_minimal_tether` has jointly restrictive hypotheses (antisym + saturation), and `CoadjointAction` is the identity.

## Removed
- The Onsager, metriplectic/holographic and "Applications" sections (they depended on the withdrawn regularity claim).
- The duplicated "Exact Mandatory Order" skeleton (v8 lines 168ff).
- The "NS is the exact Hamiltonian flow of the tether" claim.
