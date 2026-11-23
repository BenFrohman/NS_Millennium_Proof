# Type-drift audit: Metriplectic Tether Model on T³

- **Date:** 16 November 2026, America/Chicago
- **Scope:** `/workspace/metriplectic-tether-model-2026-11-16/` (paper `paper/metriplectic_tether_model.tex` and `paper/main_theorem.tex`; Lean modules `Basic`, `Tether`, `Energy`, `Dynamics`, `Example`, `Semantics`)
- **Method:** Independent adversarial reading of the sources against the lean-semantics-lock / Truth Gate rules. Small `#check` / `#print axioms` scratch compiled against the existing `.lake` oleans (Lean 4.30.0-rc1). No Mathlib download, no repo Lean/paper edits, no push, stage, or publish.
- **Claim source hash:** `sha256(paper/main_theorem.tex) = c2f5033c5e1831aba17cc8695ceacb5ebd0f5d6d35543a7bda357ae84f9b7805`, matching `truth-gate.lock.json` and the `paper_claim` docstring.

## Verdict

**The Lean types are correct for the Main Theorem as this paper states it. This is not an uncaught type-drift that silently changes or vacates the theorem.**

The equivalence “global regularity of the model ⇔ global regularity of Navier–Stokes on T³” holds because the energy-generated tether correction is proved to be the zero function, so the two weak right-hand sides are equal. That is exactly what the title, abstract, and items (c)–(f) say. It is not a junk-`deriv` loophole, a dummy type, or a vacuous `∃`/`∀` encoding.

Two caveats, both already written in the paper, should not be mistaken for a hidden formalization bug:

1. **Disclosed slot difference versus `TetherKernelVel`** (item 6). This paper evaluates \(B\) on \(L^2\) velocity gradients \(\delta F/\delta u\). `TetherKernelVel` evaluates on \(\Pi_u\operatorname{curl}(\delta F/\delta\omega)\). The Remark after Definition 2.3 records this. It is a modeling choice, not an uncaught drift. For the *energy-generated* correction the two readings are intended to agree once \(\operatorname{curl}(\delta H/\delta\omega)=u\).
2. **Disclosed gap versus Fefferman’s official (B)** (item 4). Pressure is not reconstructed and the energy bound is not formalized. Definition 2.5 says so. The Lean `GlobalRegularity` matches *this paper’s* definition, not the full Clay statement.

The Truth Gate lock exists and is formally well-shaped (`paper_claim` does not alias `formal_claim`; `intended_correspondence` is not `Iff.rfl`; only `propext`, `Classical.choice`, `Quot.sound`). The lock’s `"approver"` field is still `PENDING`. This audit is an independent review of faithfulness; it is not a substitute for Benjamin’s explicit approval of the transcription.

---

## Truth Gate checks

| Check | Result |
| --- | --- |
| `paper_claim` references or aliases `formal_claim` | **Pass.** No mention of `formal_claim`, `tether`, `tetheredRHS`, `energy`, or `tetherFactorized`. Kernels and the tethered RHS are inlined. |
| `intended_correspondence` is `Iff.rfl` / `rfl` | **Pass.** Proved by unfolding named definitions against inlined integrals, `paper_rhs_eq`, and set-extensionality (`Semantics.lean` 144–182). |
| Quote / sha256 present and matching | **Pass.** Verbatim quote of `paper/main_theorem.tex`; hash matches the file and the lock. |
| Dummy / stand-in types | **Pass.** `R3 := Fin 3 → ℝ`, `cell`, `μ = volume.restrict cell`, `curl`/`div`/`laplacian` from `fderiv`, and Bochner/Lebesgue integrals are real objects. |
| Junk-value `deriv` loophole | **Pass.** Time derivatives and the energy variation use `HasDerivAt`, not `deriv f t = …`. |
| Vacuous hypotheses | **Pass.** Continuity hypotheses in (a), (b), (j) are used. `FlowField` / `TestField` are inhabited (`beltrami`, `e0`). |
| Conditional results stated as bare conclusions | **Pass.** Global regularity of the model is *not* asserted; only the equivalence is. |
| Author approval of `paper_claim` | **Pending.** `truth-gate.lock.json`: `"approver": "PENDING - Benjamin Stanley Frohman must approve the paper_claim transcription"`. |
| `#print axioms` (scratch against existing oleans) | `intended_correspondence` and `main_theorem` depend only on `propext`, `Classical.choice`, `Quot.sound`. |

---

## (1) Domain: is this really \(\mathbb{T}^3\)?

**Rating: OK** (periodic-function representation, not the quotient-manifold type; integrals are genuine).

**Paper (Definition 2.1, lines 115–120):**

> \(\mathbb{T}^3=\mathbb{R}^3/\mathbb{Z}^3\) is represented by the fundamental cell \([0,1]^3\) with Lebesgue measure \(\mu\); \(\mu([0,1]^3)=1\). A *field* is any map \(\mathbb{R}^3\to\mathbb{R}^3\); it is *periodic* if \(f(x+e_i)=f(x)\) for \(i=0,1,2\). For fields \(f,g\), \(\langle f,g\rangle=\int_{\mathbb{T}^3}f\cdot g\,dx\) (a Bochner integral, with the usual convention that a non-integrable integrand has integral \(0\)).

**Lean (`Basic.lean` 36–49, 86):**

```lean
abbrev R3 : Type := Fin 3 → ℝ
def cell : Set R3 := Set.univ.pi fun _ => Set.Icc (0 : ℝ) 1
noncomputable def μ : Measure R3 := volume.restrict cell
def IsPeriodic (f : R3 → R3) : Prop :=
  ∀ (i : Fin 3) (x : R3), f (x + Pi.single i 1) = f x
noncomputable def l2 (f g : R3 → R3) : ℝ := ∫ x, dot (f x) (g x) ∂μ
```

- This is the standard cover representation of the *unit* torus \(\mathbb{R}^3/\mathbb{Z}^3\), not \((\mathbb{R}/2\pi\mathbb{Z})^3\). The Beltrami frequencies \(2\pi x_0\) and the constant \(-4\pi^2\kappa\) are consistent with Haar measure \(1\) on \([0,1]^3\).
- Integrals are Mathlib Lebesgue/Bochner integrals against `volume.restrict cell`, not finite sums or placeholder pairings. `Example.lean` proves `μ Set.univ = 1` from `volume_pi_pi` and `Real.volume_Icc`.
- Periodicity of states and test fields is a real predicate (`IsPeriodic`), and for any function (no continuity needed) invariance under the three unit translations implies invariance under \(\mathbb{Z}^3\).
- The ambient type is `Fin 3 → ℝ`, not Mathlib’s `AddCircle` or a quotient manifold. That is a representation, disclosed in Definition 2.1, not a dummy torus.

**Looseness (not a false theorem):** in items (a), (b), (g), (j), “fields on \(\mathbb{T}^3\)” are formalized as *arbitrary* maps `R3 → R3`. Periodicity is imposed only on `FlowField` and `TestField`. Because (a) is a vanishing statement, the Lean claim is stronger than “for periodic fields.” The paper itself defines a field as any map \(\mathbb{R}^3\to\mathbb{R}^3\).

**Fix, only if a tighter type is wanted:** require `IsPeriodic` (and, if desired, a Mathlib torus type) in the quantification of “fields on \(\mathbb{T}^3\).” Not needed to correct the Main Theorem.

---

## (2) Velocity field, constraints, and curl

**Rating: OK.**

**Paper (Definition 2.2, lines 128–131):** a smooth periodic divergence-free velocity field is \(C^\infty\), periodic, and \(\operatorname{div}u=0\). A test field has the same three properties.

**Lean (`Basic.lean` 51–83):**

```lean
noncomputable def pd (f : R3 → R3) (j : Fin 3) (x : R3) : R3 :=
  fderiv ℝ f x (Pi.single j 1)
noncomputable def curl (f : R3 → R3) (x : R3) : R3 :=
  ![pd f 1 x 2 - pd f 2 x 1, pd f 2 x 0 - pd f 0 x 2, pd f 0 x 1 - pd f 1 x 0]
noncomputable def div (f : R3 → R3) (x : R3) : ℝ := ∑ i, pd f i x i
structure FlowField where
  u : R3 → R3
  smooth : ContDiff ℝ ∞ u
  periodic : IsPeriodic u
  divFree : ∀ x, div u x = 0
```

- Smoothness, periodicity, and pointwise divergence-free are *imposed* as structure fields, not merely named.
- `curl` is the standard Euclidean curl in coordinates \((0,1,2)\). On `FlowField` / `TestField`, `ContDiff ℝ ∞` implies the Fréchet derivatives exist, so this is not the junk value `fderiv = 0`.
- `laplacian` (`∑ i, pd (pd f i) i`) and `convective` (`fderiv ℝ u x (u x)`) are the real vector Laplacian and \((u\cdot\nabla)u\).
- Mean-zero is **not** imposed, and the paper does not require it. Some expositions of periodic Clay (B) add \(\int u=0\); Fefferman’s official (B) is usually stated for general smooth periodic divergence-free data (the mean is conserved). This is a formulation gap only if one silently identifies `GlobalRegularity` with a mean-zero-only statement of (B). The paper does not do that.

**Fix, only if closer alignment with a mean-zero statement of (B) is wanted:** add `meanZero : l2 u (fun _ => 1) = 0` (componentwise) to `FlowField`. Not required for this paper’s theorem.

---

## (3) \(\Pi_u\) and the \(L^2\) gradient of \(H\)

**Rating: OK.**

**Paper (Definition 2.3, lines 135–136, and item (b)):** \(\Pi_u v=v-\frac{\langle v,u\rangle}{\langle u,u\rangle}u\); if \(\langle u,u\rangle=0\) the quotient is \(0\), so \(\Pi_u v=v\). Item (b): \(\frac{d}{d\varepsilon}\big|_{\varepsilon=0}\tfrac12\int|u+\varepsilon v|^2=\int u\cdot v\).

**Lean (`Basic.lean` 88–91; `Energy.lean` 43–45):**

```lean
noncomputable def proj (u v : R3 → R3) : R3 → R3 :=
  fun x => v x - (l2 v u / l2 u u) • u x
theorem energy_hasDerivAt {u v : R3 → R3} (hu : Continuous u) (hv : Continuous v) :
    HasDerivAt (fun ε : ℝ => energy (fun x => u x + ε • v x)) (l2 u v) 0
```

- `proj` is the genuine global \(L^2\) Gram–Schmidt projector (scalar coefficient \(\langle v,u\rangle_{L^2}/\langle u,u\rangle_{L^2}\)), the same formula as `Pi_u` in `frohmanian-symplectic-tether-regularity` (`ForMathlib/Projection.lean`).
- The \(u=0\) / zero-energy convention is Lean’s `x/0=0`, which yields \(\Pi_0 v=v\). That is the mathematically correct projection onto the complement of \(\{0\}\). It is disclosed in both the paper and the Lean docstring. The degeneracy proofs treat the zero-energy case by an almost-everywhere vanishing argument for *continuous* \(u\), not by silent junk arithmetic.
- `energy_hasDerivAt` is a real one-parameter `HasDerivAt` (Gâteaux / variational derivative along the line \(u+\varepsilon v\)), not a definitional renaming of \(\delta H/\delta u\). The representer of that derivative is \(u\). It is not a Fréchet derivative of \(H\) as a map on a Banach space of fields; the paper’s displayed formula is the Gâteaux statement, so this is a match, not a drift.

**Fix:** none for the stated theorem. If a full Fréchet derivative on \(L^2(\mathbb{T}^3)\) is ever claimed in prose, that stronger statement would still need to be proved.

---

## (4) `IsSolution`, `GlobalRegularity`, pressure, junk derivatives, vacuity of the iff

**Rating: OK** for the paper’s own Definitions 2.4–2.5. **Disclosed gap** versus Fefferman (B). **Not a vacuous iff.**

**Paper (Definitions 2.4–2.5, lines 154–174):**

- NS RHS: \(-\langle(u\cdot\nabla)u,a\rangle+\nu\langle\Delta u,a\rangle\) (zero forcing; tested only against divergence-free periodic fields, so no pressure term appears).
- Tether model RHS: the same plus \(B^\kappa_{\operatorname{curl}u,u}(a,u)\).
- Smooth solution on \([0,\infty)\): \((t,x)\mapsto U(t)(x)\) is \(C^\infty\) on \([0,\infty)\times\mathbb{R}^3\), and for every test field \(a\) and every \(t>0\), \(\frac{d}{dt}\langle U(t),a\rangle=R(U(t),a)\).
- Global regularity: every state \(u_0\) is the time-\(0\) value of such a solution.
- Explicit disclaimer: “its relation to Fefferman’s statement (B) (pressure, energy bound) is not formalized here.”

**Lean (`Basic.lean` 100–122; `Dynamics.lean` 29–45):**

```lean
noncomputable def nsRHS (ν : ℝ) (u : FlowField) (a : TestField) : ℝ :=
  -l2 (convective u.u) a.v + ν * l2 (laplacian u.u) a.v
noncomputable def tetheredRHS (κ ν : ℝ) (u : FlowField) (a : TestField) : ℝ :=
  nsRHS ν u a + tether κ (curl u.u) u.u a.v u.u
def IsSolution (rhs : FlowField → TestField → ℝ) (U : ℝ → FlowField) : Prop :=
  ContDiffOn ℝ ∞ (fun p : ℝ × R3 => (U p.1).u p.2) (Set.Ici 0 ×ˢ Set.univ) ∧
  ∀ (a : TestField) (t : ℝ), 0 < t →
    HasDerivAt (fun s => l2 (U s).u a.v) (rhs (U t) a) t
def GlobalRegularity (rhs : FlowField → TestField → ℝ) : Prop :=
  ∀ u₀ : FlowField, ∃ U : ℝ → FlowField, (U 0).u = u₀.u ∧ IsSolution rhs U
theorem tetheredRHS_eq_nsRHS (κ ν : ℝ) (u : FlowField) (a : TestField) :
    tetheredRHS κ ν u a = nsRHS ν u a := by
  rw [tetheredRHS, tether_term_vanishes, add_zero]
theorem globalRegularity_tethered_iff (κ ν : ℝ) :
    GlobalRegularity (tetheredRHS κ ν) ↔ GlobalRegularity (nsRHS ν) := by
  rw [tetheredRHS_fun_eq]
```

- **Pressure:** handled by restricting tests to divergence-free fields (standard elimination). Pressure is not reconstructed, and the de Rham/Hodge step from this weak form to a strong form plus a pressure function is not proved. The paper discloses this.
- **Time derivative:** `HasDerivAt` of the real function \(t\mapsto\langle U(t),a\rangle\). This is a genuine two-sided derivative at every \(t>0\) (a neighbourhood of such \(t\) can be taken inside \((0,\infty)\)). It does *not* use the junk rule `deriv f t = 0` when \(f\) is not differentiable.
- **Joint smoothness:** `ContDiffOn` on the closed half-space \([0,\infty)\times\mathbb{R}^3\) is `ContDiffWithinAt`, i.e. Taylor expansions in neighbourhoods *within that set*, so at \(t=0\) the time derivatives are one-sided. That is the right notion of \(C^\infty\) up to the initial time.
- **Laplacian and convection:** real, as in (2), and only applied to `FlowField` data (`ContDiff ∞`).
- **The iff is not vacuous.** `tetheredRHS = nsRHS` is a proved theorem (`tether_term_vanishes`, from \(\Pi_u u=0\) / energy degeneracy). After that rewrite, the two `IsSolution` / `GlobalRegularity` predicates coincide. The paper states this mechanism in the proof of (c)–(f) (“the two right-hand sides are equal as functions”). The brief asked whether the iff holds only because both sides are the same expression: **yes, after a real vanishing proof, and that is honestly what the paper says.**
- `GlobalRegularity` is a genuine existence statement (`∀ u₀, ∃ U, …`). It is not discharged by an empty type or a junk witness.

**Minor paper-wording inaccuracy (not a Lean bug):** Definition 2.5 calls this a “weak-in-time, divergence-free-tested form.” Lean (and the displayed formula “for every \(t>0\), \(d/dt\langle U(t),a\rangle=R\)”) is *classical in time* and weak only in space. A correct wording would be “classical in time, weak in space (tested against divergence-free fields).”

**Fix for the Fefferman gap, only if the title is ever read as Clay (B):** keep the current Lean as the paper’s formulation; do not claim equivalence to Fefferman (B) until pressure recovery and the energy bound are formalized. No Lean change is required for the Main Theorem as written.

---

## (5) Items (a)–(j): English versus Lean

**Rating: OK.** Quantifiers, kernel formula, signs, and the Beltrami constant match.

| Item | Paper (`main_theorem.tex`) | Lean | Match |
| --- | --- | --- | --- |
| (a) | For continuous \(u\) and all fields \(w,a\), \(B^\kappa_{w,u}(a,u)=-\kappa\int\|w\|^2(\Pi_u a\cdot\Pi_u u)=0\) | `Continuous u → tether κ w u a u = 0`, and the inlined integral in `paper_claim` | Yes. Pointwise \(\lvert w\rvert^2\) weight. Continuity only on \(u\), as in the prose. |
| (b) | Gâteaux formula at \(\varepsilon=0\) for continuous \(u,v\) | `HasDerivAt` of \(\tfrac12\int\lvert u+\varepsilon v\rvert^2\) equals `l2 u v` at `0` | Yes. |
| (c) | For every `FlowField` \(u\) and `TestField` \(a\), NS RHS \(+ B^\kappa_{\operatorname{curl}u,u}(a,u)\) equals the NS RHS | Inlined in `paper_claim`; `tetheredRHS_eq_nsRHS` in `formal_claim` | Yes. |
| (d) | The two sets of smooth solutions on \([0,\infty)\) are equal | `paper_claim`: set equality of `IsSolution` predicates; `formal_claim`: pointwise `↔` | Yes (equivalent). The predicates use the paper’s Definitions 2.4–2.5, not a stronger classical NS. |
| (e) | Global regularity of the model iff of NS on \(\mathbb{T}^3\) | `GlobalRegularity (tetheredRHS κ ν) ↔ GlobalRegularity (nsRHS ν)`, or the inlined expansion | Yes, relative to Definition 2.5. |
| (f) | Every property \(P\) of time-dependent velocity fields transfers | `∀ P : (ℝ → FlowField) → Prop, (∀ U, IsSolution tethered U → P U) ↔ …` | Yes. Mild looseness: \(U\) is defined on all of \(\mathbb{R}\), so a pathological \(P\) could depend on unconstrained \(t<0\) values; the iff remains true, and any \(P\) that depends only on \(t\ge 0\) (e.g. a cubic sink) is correctly transferred. |
| (g) | If \(\kappa\ge 0\), then \(B(a,a)\le 0\) for all fields \(w,u,a\) | Same, no extra hypotheses | Yes. |
| (h) | For \(u_B(x)=(0,\sin 2\pi x_0,\cos 2\pi x_0)\) and \(e_0=(1,0,0)\), \(B=-4\pi^2\kappa\) | `tether … = -(4 * π ^ 2 * κ)`; `paper_claim` inlines the same two fields | Yes. The identity \(\operatorname{curl}u_B=2\pi u_B\), \(\lvert\operatorname{curl}u_B\rvert^2=4\pi^2\), \(\Pi_{u_B}e_0=e_0\), and \(\mu(\mathbb{T}^3)=1\) produce exactly \(-4\pi^2\kappa\). |
| (i) | If \(\kappa>0\), it is not the case that \(B(\operatorname{curl}u,u)(a,a)\ge 0\) for every smooth periodic divergence-free \(u,a\) | `0 < κ → ¬ ∀ (u : FlowField) (a : TestField), 0 ≤ tether … a.v a.v` | Yes. |
| (j) | Factorized weight: degeneracy for continuous \(u,a\); sign for \(\kappa\ge 0\) and all fields | Inlined \(-\kappa\|w\|_{L^2}^2\langle\Pi_u a,\Pi_u u\rangle=0\) and the corresponding inequality | Yes. Continuity of \(a\) is required only for degeneracy, as in the prose. |

The two kernels are not confused: the body of the paper uses the pointwise weight throughout; the factorized weight \(\|w\|_{L^2}^2\langle\Pi_u a,\Pi_u b\rangle\) appears only in (j), matching `tetherFactorized`.

**Fix:** none for (a)–(j) as stated. Optionally tighten (f) to properties of `Set.Ici 0`-restrictions, and optionally inline `nsRHS` in `paper_claim` (d)–(f) for perfect typographic independence; neither changes the meaning.

---

## (6) Slot: velocity variations versus `TetherKernelVel`

**Rating: OK for this paper’s stated theorem. Disclosed slot difference versus `TetherKernelVel`, not uncaught drift.**

**Paper (abstract, lines 38–42; “Which kernel,” lines 97–103; Remark, lines 147–151):**

> … the velocity-slot Frohmanian tether … \(B^\kappa_{\omega,u}(a,b)=-\kappa\int_{\mathbb{T}^3}\lvert\omega\rvert^2\,(\Pi_u a\cdot\Pi_u b)\,dx\) …
>
> In [Fr21856430] the slots are \(\Pi_u(\delta F/\delta\omega)\); in `TetherKernelVel` they are \(\Pi_u\operatorname{curl}(\delta F/\delta\omega)\). Here the slots are taken to be \(L^2\) velocity gradients by definition. For the energy this slot is computed in item (b): \(\delta H/\delta u=u\).

**Lean (`Basic.lean` 93–109):**

```lean
noncomputable def tether (κ : ℝ) (w u a b : R3 → R3) : ℝ :=
  -κ * ∫ x, dot (w x) (w x) * dot (proj u a x) (proj u b x) ∂μ
noncomputable def tetheredRHS (κ ν : ℝ) (u : FlowField) (a : TestField) : ℝ :=
  nsRHS ν u a + tether κ (curl u.u) u.u a.v u.u
```

The right-hand slot of the correction in the PDE is \(u=\delta H/\delta u\), and the left-hand slot is the test field \(a=\delta F_a/\delta u\). That is exactly the velocity-variation slot the paper defines.

**Comparison with `TetherKernelVel`** (from `frohmanian-symplectic-tether-regularity`, `C2Analysis.lean` 57–64):

```lean
noncomputable def TetherKernelVel (kappa : ℝ) (ω : CoadjointOrbit) (F G : Functional) : ℝ :=
  -kappa * ∫ x,
    ‖ω.val x‖ ^ 2 *
      inner ℝ
        (Pi_u (velocity_from_vorticity ω) (curl (FunctionalDerivative F ω)) x)
        (Pi_u (velocity_from_vorticity ω) (curl (FunctionalDerivative G ω)) x)
    ∂NavierStokes3D.volume
```

So:

| | This paper / `tether` | `TetherKernelVel` |
| --- | --- | --- |
| Weight | pointwise \(\lvert\omega(x)\rvert^2\) | pointwise \(\lvert\omega(x)\rvert^2\) (same) |
| Projector | \(L^2\) \(\Pi_u\) | \(L^2\) \(\Pi_u\) (same formula) |
| Slot | \(\Pi_u(\delta F/\delta u)\), here a test field \(a\) | \(\Pi_u\operatorname{curl}(\delta F/\delta\omega)\) |
| Energy identification | *proved* \(\delta H/\delta u=u\) | *assumed* \(\operatorname{curl}(\delta H/\delta\omega)=u\) in `tetherKernelVel_C2` |

The earlier file itself says the velocity-slot fix “is the same as treating \(H\) as a functional of \(u\) (\(\delta H/\delta u=u\)).” For the energy-generated term \(B(F,H)\) that drives \(\dot F=\{F,H\}+B(F,H)\), both readings give a right-hand slot of \(u\), hence \(\Pi_u u=0\), hence a vanishing correction. That is why the types in *this* paper are correct for the theorem it actually states.

What is *not* formalized here is the dictionary \(\operatorname{curl}(\delta F/\delta\omega)=\delta F/\delta u\) for a general functional \(F\), nor the coadjoint-orbit / `FunctionalDerivative` packaging of `TetherKernelVel`. If the intended theorem had been “the literal `TetherKernelVel` dynamics are identical to Navier–Stokes,” that identification would still need a proof (or the kernel would have to be written with `curl (FunctionalDerivative · )`). The present paper does not claim that literal packaging; it claims the velocity-gradient model it defines.

**Fix, only if the literal `TetherKernelVel` model is the object of the theorem:** redefine the correction as \(B(F,G)=-\kappa\int\lvert\omega\rvert^2\bigl(\Pi_u\operatorname{curl}(\delta F/\delta\omega)\cdot\Pi_u\operatorname{curl}(\delta G/\delta\omega)\bigr)\) and prove or assume the stream-function identity for \(H\). That is a different paper, not a correction of this one. For the energy slot the vanishing conclusion would be expected to survive.

---

## Additional notes (not rated as drift)

- **Title versus body.** The title says the model’s global regularity “is equivalent to periodic Navier–Stokes global regularity.” The abstract adds “in the formulation used here” and “This is not a Clay Millennium Problem claim.” The Lean matches the body, not an unqualified Clay claim.
- **`B(H,M)=0` and the published obstructions.** Item (a) (and symmetry) is exactly the energy degeneracy that earlier records used to show a symmetric C2 kernel cannot damp a general functional \(M\) through \(B(H,M)\). This development proves that degeneracy instead of assuming it, and then faces the consequence: the modified PDE is Navier–Stokes. That is the honest engagement those records require, not a type error.
- **No `sorry` / `admit` in the six modules.** Inspected in full.
- Scratch `#check` was run with `lake env lean` against the existing oleans; toolchain `leanprover/lean4:v4.30.0-rc1`.

## Bottom line

Benjamin’s question — “is this type even correct for the stated theorem, or was this already an uncaught drift?” — is answered as follows:

The types are correct for the Main Theorem written in `paper/main_theorem.tex`. There is no uncaught dummy-type, junk-`deriv`, or vacuous-iff problem in `IsSolution` / `GlobalRegularity`. The slot is not the literal `TetherKernelVel` slot, but that difference is written into the paper’s own Remark and is the intended velocity-gradient reading of the energy-generated term. What remains open is the author’s approval of `paper_claim`, not a hidden error in the types.
