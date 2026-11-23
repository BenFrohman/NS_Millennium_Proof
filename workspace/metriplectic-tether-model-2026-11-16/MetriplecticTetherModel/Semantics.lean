/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
import MetriplecticTetherModel.Example

/-!
# MetriplecticTetherModel.Semantics

Truth Gate semantics lock for the paper *The Metriplectic Tether Model on 𝕋³*.

* `formal_claim` is the conjunction of the statements of the library theorems, phrased through the
  named definitions `tether`, `tetheredRHS`, `energy`, `tetherFactorized`.
* `paper_claim` is an independent Lean transcription of the paper's Main Theorem (quoted verbatim
  below), written directly from the English text with all formulas inlined; it never mentions
  `formal_claim`, `tether`, `tetheredRHS`, `energy` or `tetherFactorized`.
* `intended_correspondence : formal_claim ↔ paper_claim` is proved by unfolding each conjunct and
  translating between the named-definition form and the inlined form (set equality vs. pointwise
  `iff`, inlined integrals vs. named kernels), not by `Iff.rfl`.
-/

open MeasureTheory Real

namespace MetriplecticTetherModel

/-- What the Lean development proves, phrased with the library's named definitions. -/
def formal_claim : Prop :=
  ∀ κ ν : ℝ,
    (∀ (w a u : R3 → R3), Continuous u → tether κ w u a u = 0) ∧
    (∀ (u v : R3 → R3), Continuous u → Continuous v →
      HasDerivAt (fun ε : ℝ => energy (fun x => u x + ε • v x)) (l2 u v) 0) ∧
    (∀ (u : FlowField) (a : TestField), tetheredRHS κ ν u a = nsRHS ν u a) ∧
    (∀ U : ℝ → FlowField, IsSolution (tetheredRHS κ ν) U ↔ IsSolution (nsRHS ν) U) ∧
    (GlobalRegularity (tetheredRHS κ ν) ↔ GlobalRegularity (nsRHS ν)) ∧
    (∀ P : (ℝ → FlowField) → Prop,
      (∀ U, IsSolution (tetheredRHS κ ν) U → P U) ↔ (∀ U, IsSolution (nsRHS ν) U → P U)) ∧
    (0 ≤ κ → ∀ (w u a : R3 → R3), tether κ w u a a ≤ 0) ∧
    (tether κ (curl beltrami.u) beltrami.u e0.v e0.v = -(4 * π ^ 2 * κ)) ∧
    (0 < κ → ¬ ∀ (u : FlowField) (a : TestField), 0 ≤ tether κ (curl u.u) u.u a.v a.v) ∧
    (∀ (w u a : R3 → R3), Continuous u → Continuous a → tetherFactorized κ w u a u = 0) ∧
    (0 ≤ κ → ∀ (w u a : R3 → R3), tetherFactorized κ w u a a ≤ 0)

/-- **Paper claim** (independent transcription of the Main Theorem).

Source file: `paper/main_theorem.tex` (included verbatim as Theorem 1 of
`paper/metriplectic_tether_model.tex`, Section 3 "Main theorem"), sha256
`c2f5033c5e1831aba17cc8695ceacb5ebd0f5d6d35543a7bda357ae84f9b7805`.

Verbatim quote:

```
\begin{theorem}[Main Theorem]\label{thm:main}
Let $\kappa,\nu\in\mathbb{R}$ be arbitrary.
\begin{enumerate}[label=(\alph*)]
\item\label{it:deg} \emph{(Energy degeneracy.)} For every continuous field $u$, every field $w$ and every field $a$ on $\mathbb{T}^3$,
  $B^{\kappa}_{w,u}(a,u)=-\kappa\int_{\mathbb{T}^3}|w|^2\,(\Pi_u a\cdot\Pi_u u)\,dx=0$.
\item\label{it:grad} \emph{(Energy gradient.)} For all continuous fields $u,v$ on $\mathbb{T}^3$,
  $\frac{d}{d\varepsilon}\big|_{\varepsilon=0}\tfrac12\int_{\mathbb{T}^3}|u+\varepsilon v|^2\,dx=\int_{\mathbb{T}^3}u\cdot v\,dx$.
\item\label{it:rhs} \emph{(Same equation.)} For every smooth periodic divergence-free velocity field $u$ and every smooth periodic divergence-free test field $a$,
  $-\langle(u\cdot\nabla)u,a\rangle+\nu\langle\Delta u,a\rangle+B^{\kappa}_{\operatorname{curl}u,u}(a,u)=-\langle(u\cdot\nabla)u,a\rangle+\nu\langle\Delta u,a\rangle$.
\item\label{it:sol} \emph{(Same solutions.)} The set of smooth solutions on $[0,\infty)$ of the metriplectic tether model equals the set of smooth solutions on $[0,\infty)$ of the Navier--Stokes equations on $\mathbb{T}^3$.
\item\label{it:reg} \emph{(Equivalent regularity.)} Global regularity holds for the metriplectic tether model if and only if global regularity holds for the Navier--Stokes equations on $\mathbb{T}^3$.
\item\label{it:prop} \emph{(Transfer.)} For every property $P$ of time-dependent velocity fields, $P$ holds for every smooth solution of the metriplectic tether model if and only if $P$ holds for every smooth solution of the Navier--Stokes equations on $\mathbb{T}^3$.
\item\label{it:sign} \emph{(Sign.)} If $\kappa\ge 0$, then $B^{\kappa}_{w,u}(a,a)\le 0$ for all fields $w,u,a$.
\item\label{it:beltrami} \emph{(Non-vacuity.)} For the Beltrami field $u_B(x)=(0,\sin 2\pi x_0,\cos 2\pi x_0)$ and the constant test field $e_0=(1,0,0)$,
  $B^{\kappa}_{\operatorname{curl}u_B,u_B}(e_0,e_0)=-4\pi^2\kappa$.
\item\label{it:psd} \emph{(Not a metric bracket.)} If $\kappa>0$, it is not the case that $B^{\kappa}_{\operatorname{curl}u,u}(a,a)\ge 0$ for every smooth periodic divergence-free $u$ and every smooth periodic divergence-free test field $a$.
\item\label{it:fac} \emph{(Factorized weight.)} For all continuous fields $u,a$ and every field $w$, $-\kappa\,\|w\|_{L^2}^2\,\langle\Pi_u a,\Pi_u u\rangle=0$; and if $\kappa\ge0$, then $-\kappa\,\|w\|_{L^2}^2\,\langle\Pi_u a,\Pi_u a\rangle\le 0$ for all fields $w,u,a$.
\end{enumerate}
\end{theorem}
```

Transcription conventions (stated in Section 2 of the paper): `𝕋³` is the cell `[0,1]³` with
Lebesgue measure `μ`; a *field* is any map `ℝ³ → ℝ³`; `Π_u a = a − (⟨a,u⟩/⟨u,u⟩)u`; a *smooth periodic
divergence-free velocity field* is a `FlowField`, a test field is a `TestField`; *smooth solution on
`[0,∞)`* and *global regularity* are `IsSolution` and `GlobalRegularity` (Definitions 2.4–2.5); the
metriplectic tether model is the weak system whose right-hand side is
`−⟨(u·∇)u,a⟩ + ν⟨Δu,a⟩ + B_{curl u,u}(a,u)`; the Navier–Stokes equations are the weak system with
right-hand side `nsRHS ν`. -/
def paper_claim : Prop :=
  ∀ κ ν : ℝ,
    -- (a)
    (∀ (u w a : R3 → R3), Continuous u →
      -κ * ∫ x, dot (w x) (w x) * dot (proj u a x) (proj u u x) ∂μ = 0) ∧
    -- (b)
    (∀ (u v : R3 → R3), Continuous u → Continuous v →
      HasDerivAt (fun ε : ℝ => (1 / 2) * ∫ x, dot (u x + ε • v x) (u x + ε • v x) ∂μ)
        (∫ x, dot (u x) (v x) ∂μ) 0) ∧
    -- (c)
    (∀ (u : FlowField) (a : TestField),
      -l2 (convective u.u) a.v + ν * l2 (laplacian u.u) a.v +
          -κ * ∫ x, dot (curl u.u x) (curl u.u x) * dot (proj u.u a.v x) (proj u.u u.u x) ∂μ =
        -l2 (convective u.u) a.v + ν * l2 (laplacian u.u) a.v) ∧
    -- (d)
    ({U : ℝ → FlowField | IsSolution (fun u a => -l2 (convective u.u) a.v +
        ν * l2 (laplacian u.u) a.v +
        -κ * ∫ x, dot (curl u.u x) (curl u.u x) * dot (proj u.u a.v x) (proj u.u u.u x) ∂μ) U} =
      {U : ℝ → FlowField | IsSolution (nsRHS ν) U}) ∧
    -- (e)
    ((∀ u₀ : FlowField, ∃ U : ℝ → FlowField, (U 0).u = u₀.u ∧
        IsSolution (fun u a => -l2 (convective u.u) a.v + ν * l2 (laplacian u.u) a.v +
          -κ * ∫ x, dot (curl u.u x) (curl u.u x) * dot (proj u.u a.v x) (proj u.u u.u x) ∂μ) U) ↔
      (∀ u₀ : FlowField, ∃ U : ℝ → FlowField, (U 0).u = u₀.u ∧ IsSolution (nsRHS ν) U)) ∧
    -- (f)
    (∀ P : (ℝ → FlowField) → Prop,
      (∀ U, IsSolution (fun u a => -l2 (convective u.u) a.v + ν * l2 (laplacian u.u) a.v +
          -κ * ∫ x, dot (curl u.u x) (curl u.u x) * dot (proj u.u a.v x) (proj u.u u.u x) ∂μ) U →
        P U) ↔
      (∀ U, IsSolution (nsRHS ν) U → P U)) ∧
    -- (g)
    (0 ≤ κ → ∀ (w u a : R3 → R3),
      -κ * ∫ x, dot (w x) (w x) * dot (proj u a x) (proj u a x) ∂μ ≤ 0) ∧
    -- (h)
    (-κ * ∫ x, dot (curl (fun y => ![0, sin (2 * π * y 0), cos (2 * π * y 0)]) x)
          (curl (fun y => ![0, sin (2 * π * y 0), cos (2 * π * y 0)]) x) *
        dot (proj (fun y => ![0, sin (2 * π * y 0), cos (2 * π * y 0)]) (fun _ => ![1, 0, 0]) x)
          (proj (fun y => ![0, sin (2 * π * y 0), cos (2 * π * y 0)]) (fun _ => ![1, 0, 0]) x) ∂μ =
      -(4 * π ^ 2 * κ)) ∧
    -- (i)
    (0 < κ → ¬ ∀ (u : FlowField) (a : TestField),
      0 ≤ -κ * ∫ x, dot (curl u.u x) (curl u.u x) * dot (proj u.u a.v x) (proj u.u a.v x) ∂μ) ∧
    -- (j)
    (∀ (w u a : R3 → R3), Continuous u → Continuous a →
      -κ * (∫ x, dot (w x) (w x) ∂μ) * (∫ x, dot (proj u a x) (proj u u x) ∂μ) = 0) ∧
    (0 ≤ κ → ∀ (w u a : R3 → R3),
      -κ * (∫ x, dot (w x) (w x) ∂μ) * (∫ x, dot (proj u a x) (proj u a x) ∂μ) ≤ 0)

/-- The inlined right-hand side of the paper is the library's `tetheredRHS`. -/
theorem paper_rhs_eq (κ ν : ℝ) :
    (fun (u : FlowField) (a : TestField) => -l2 (convective u.u) a.v + ν * l2 (laplacian u.u) a.v +
      -κ * ∫ x, dot (curl u.u x) (curl u.u x) * dot (proj u.u a.v x) (proj u.u u.u x) ∂μ) =
      tetheredRHS κ ν := by
  funext u a
  simp only [tetheredRHS, nsRHS, tether]

theorem beltrami_u_eq : beltrami.u = fun y => ![0, sin (2 * π * y 0), cos (2 * π * y 0)] := by
  funext y
  rfl

theorem e0_v_eq : e0.v = fun _ => ![1, 0, 0] := rfl

/-- **Intended correspondence**: the Lean development proves exactly the paper's Main Theorem. -/
theorem intended_correspondence : formal_claim ↔ paper_claim := by
  constructor
  · intro hF κ ν
    obtain ⟨ha, hb, hc, hd, he, hf, hg, hh, hi, hj1, hj2⟩ := hF κ ν
    refine ⟨fun u w a hu => ?_, fun u v hu hv => ?_, fun u a => ?_, ?_, ?_, fun P => ?_,
      fun hκ w u a => ?_, ?_, fun hκ => ?_, fun w u a hu hA => ?_, fun hκ w u a => ?_⟩
    · have := ha w a u hu
      simpa only [tether] using this
    · simpa only [energy, l2] using hb u v hu hv
    · have := hc u a
      simpa only [tetheredRHS, nsRHS, tether] using this
    · rw [paper_rhs_eq]
      ext U
      exact hd U
    · rw [paper_rhs_eq]
      exact he
    · rw [paper_rhs_eq]
      exact hf P
    · simpa only [tether] using hg hκ w u a
    · rw [← beltrami_u_eq, ← e0_v_eq]
      simpa only [tether] using hh
    · simpa only [tether] using hi hκ
    · simpa only [tetherFactorized, l2] using hj1 w u a hu hA
    · simpa only [tetherFactorized, l2] using hj2 hκ w u a
  · intro hP κ ν
    obtain ⟨ha, hb, hc, hd, he, hf, hg, hh, hi, hj1, hj2⟩ := hP κ ν
    rw [paper_rhs_eq] at hd he hf
    refine ⟨fun w a u hu => ?_, fun u v hu hv => ?_, fun u a => ?_, fun U => ?_, he, hf,
      fun hκ w u a => ?_, ?_, fun hκ => ?_, fun w u a hu hA => ?_, fun hκ w u a => ?_⟩
    · simpa only [tether] using ha u w a hu
    · simpa only [energy, l2] using hb u v hu hv
    · simpa only [tetheredRHS, nsRHS, tether] using hc u a
    · exact Set.ext_iff.1 hd U
    · simpa only [tether] using hg hκ w u a
    · rw [← beltrami_u_eq, ← e0_v_eq] at hh
      simpa only [tether] using hh
    · simpa only [tether] using hi hκ
    · simpa only [tetherFactorized, l2] using hj1 w u a hu hA
    · simpa only [tetherFactorized, l2] using hj2 hκ w u a

/-- The library proves `formal_claim`. -/
theorem formal_claim_holds : formal_claim := fun κ ν =>
  ⟨fun w a _ hu => tether_energy_slot_right κ w a hu,
   fun _ _ hu hv => energy_hasDerivAt hu hv,
   tetheredRHS_eq_nsRHS κ ν,
   isSolution_tethered_iff κ ν,
   globalRegularity_tethered_iff κ ν,
   solution_property_transfer κ ν,
   fun hκ w u a => tether_diag_nonpos hκ w u a,
   tether_beltrami κ,
   fun hκ => tether_not_psd hκ,
   fun w _ _ hu ha => tetherFactorized_energy_slot_right κ w hu ha,
   fun hκ w u a => tetherFactorized_diag_nonpos hκ w u a⟩

/-- **Main Theorem of the paper**, obtained through the semantics lock. -/
theorem main_theorem : paper_claim := intended_correspondence.mp formal_claim_holds

end MetriplecticTetherModel
