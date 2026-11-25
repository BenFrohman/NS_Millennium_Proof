/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

module

public import Mathlib.Analysis.Fourier.AddCircleMulti

/-!
# Sobolev spaces `Hˢ` on the torus `𝕋ᵈ`

For `s : ℝ` the Sobolev space `Hˢ(𝕋ᵈ)` consists of the `L²` functions `f` on
`𝕋ᵈ = UnitAddTorus d` whose Fourier coefficients satisfy
`∑ n, (1 + |n|²)ˢ |f̂ n|² < ∞`, where `f̂ n = mFourierCoeff f n`.
We define it as a `ℂ`-submodule of `L²(𝕋ᵈ)`, using the Hilbert basis `mFourierBasis`
and the space `ℓ²` (`Memℓp _ 2`) from Mathlib.

For `s ≤ 0` every `L²` function satisfies this condition, so `sobolev s = ⊤`; the
space `Hˢ(𝕋ᵈ)` for `s < 0` is larger than `L²` and would need distributions, which are
not treated here.

## Main definitions

* `UnitAddTorus.sobolevWeight s n`: the weight `⟨n⟩ˢ = (1 + |n|²) ^ (s / 2)`.
* `UnitAddTorus.sobolev s`: the submodule `Hˢ(𝕋ᵈ)` of `L²(𝕋ᵈ)`.

## Main statements

* `UnitAddTorus.mem_sobolev_iff`: `f ∈ Hˢ` iff `(⟨n⟩ˢ f̂ n)ₙ ∈ ℓ²`, with
  `f̂ = mFourierCoeff f`.
* `UnitAddTorus.sobolev_antitone`: `Hˢ ⊆ Hᵗ` for `t ≤ s`.
* `UnitAddTorus.sobolev_zero`: `H⁰ = L²`.
* `UnitAddTorus.mFourierLp_mem_sobolev`: every monomial `mFourier n` lies in every `Hˢ`.

## References

* [L. Grafakos, *Classical Fourier Analysis*][grafakos2014], §3.1.
* [M. E. Taylor, *Partial Differential Equations I*][taylor2011], Chapter 3, §1 and Chapter 4.
* [J. C. Robinson, J. L. Rodrigo and W. Sadowski, *The Three-Dimensional Navier–Stokes
  Equations*][robinson_rodrigo_sadowski_2016], Chapter 1.
-/

@[expose] public section

noncomputable section

open MeasureTheory
open scoped ENNReal

namespace UnitAddTorus

variable {d : Type*} [Fintype d]

/-- The measure on `ℝ / ℤ` is normalised to have total volume `1`, as in
`Mathlib.Analysis.Fourier.AddCircleMulti`. -/
local instance : MeasureSpace UnitAddCircle := ⟨AddCircle.haarAddCircle⟩

local notation "L²(" α ")" => Lp ℂ 2 (volume : Measure α)

/-- The Sobolev weight `⟨n⟩ˢ = (1 + |n|²) ^ (s / 2)` at the frequency `n : d → ℤ`,
where `|n|² = ∑ i, nᵢ²`. -/
def sobolevWeight (s : ℝ) (n : d → ℤ) : ℝ := (1 + ∑ i, (n i : ℝ) ^ 2) ^ (s / 2)

lemma one_le_one_add_sum_sq (n : d → ℤ) : 1 ≤ 1 + ∑ i, (n i : ℝ) ^ 2 :=
  le_add_of_nonneg_right (Finset.sum_nonneg fun _ _ ↦ sq_nonneg _)

lemma sobolevWeight_pos (s : ℝ) (n : d → ℤ) : 0 < sobolevWeight s n :=
  Real.rpow_pos_of_pos (zero_lt_one.trans_le (one_le_one_add_sum_sq n)) _

@[simp]
lemma sobolevWeight_zero (n : d → ℤ) : sobolevWeight 0 n = 1 := by
  simp [sobolevWeight]

lemma sobolevWeight_le_sobolevWeight {s t : ℝ} (h : t ≤ s) (n : d → ℤ) :
    sobolevWeight t n ≤ sobolevWeight s n :=
  Real.rpow_le_rpow_of_exponent_le (one_le_one_add_sum_sq n) (by linarith)

/-- The Sobolev space `Hˢ(𝕋ᵈ)`, as the submodule of `L²(𝕋ᵈ)` of functions `f` with
`(⟨n⟩ˢ f̂ n)ₙ ∈ ℓ²`, where `f̂ n = mFourierBasis.repr f n = mFourierCoeff f n`. -/
def sobolev (s : ℝ) : Submodule ℂ L²(UnitAddTorus d) where
  carrier := {f | Memℓp (fun n ↦ (sobolevWeight s n : ℂ) * mFourierBasis.repr f n) 2}
  add_mem' {f g} hf hg := by
    change Memℓp _ 2
    convert Memℓp.add hf hg using 1
    funext n
    simp only [map_add, lp.coeFn_add, Pi.add_apply, mul_add]
  zero_mem' := by
    change Memℓp _ 2
    convert (zero_memℓp : Memℓp (0 : (d → ℤ) → ℂ) 2) using 1
    funext n
    simp only [map_zero, lp.coeFn_zero, Pi.zero_apply, mul_zero]
  smul_mem' c f hf := by
    change Memℓp _ 2
    convert Memℓp.const_smul hf c using 1
    funext n
    simp only [map_smul, lp.coeFn_smul, Pi.smul_apply, smul_eq_mul]
    ring

lemma mem_sobolev_iff {s : ℝ} {f : L²(UnitAddTorus d)} :
    f ∈ sobolev s ↔ Memℓp (fun n ↦ (sobolevWeight s n : ℂ) * mFourierCoeff f n) 2 := by
  change Memℓp _ 2 ↔ _
  simp only [mFourierBasis_repr]

/-- `Hˢ(𝕋ᵈ) ⊆ Hᵗ(𝕋ᵈ)` for `t ≤ s`. -/
theorem sobolev_antitone : Antitone (sobolev (d := d)) := by
  intro t s h f hf
  have hp : (0 : ℝ) < (2 : ℝ≥0∞).toReal := by norm_num
  change Memℓp _ 2 at hf ⊢
  rw [memℓp_gen_iff hp] at hf ⊢
  refine Summable.of_nonneg_of_le (fun _ ↦ by positivity) (fun n ↦ ?_) hf
  simp only [norm_mul, Complex.norm_real, Real.norm_eq_abs,
    abs_of_pos (sobolevWeight_pos _ _)]
  exact Real.rpow_le_rpow (mul_nonneg (sobolevWeight_pos _ _).le (norm_nonneg _))
    (mul_le_mul_of_nonneg_right (sobolevWeight_le_sobolevWeight h n) (norm_nonneg _)) hp.le

/-- `H⁰(𝕋ᵈ) = L²(𝕋ᵈ)`. -/
@[simp]
theorem sobolev_zero : sobolev (d := d) 0 = ⊤ := by
  refine eq_top_iff.2 fun f _ ↦ ?_
  change Memℓp _ 2
  have h : Memℓp (⇑(mFourierBasis.repr f)) 2 := (mFourierBasis.repr f).2
  convert h using 1
  funext n
  simp

/-- For `s ≤ 0`, every `L²` function lies in `sobolev s`. -/
theorem sobolev_eq_top_of_nonpos {s : ℝ} (hs : s ≤ 0) : sobolev (d := d) s = ⊤ :=
  eq_top_iff.2 (sobolev_zero (d := d) ▸ sobolev_antitone hs)

/-- Every monomial `mFourier n` lies in every Sobolev space `Hˢ(𝕋ᵈ)`. -/
theorem mFourierLp_mem_sobolev (s : ℝ) (n : d → ℤ) : mFourierLp 2 n ∈ sobolev (d := d) s := by
  classical
  change Memℓp _ 2
  have h : (fun m ↦ (sobolevWeight s m : ℂ) * mFourierBasis.repr (mFourierLp 2 n) m) =
      ⇑(lp.single 2 n ((sobolevWeight s n : ℂ) : ℂ)) := by
    ext m
    rw [← coe_mFourierBasis, HilbertBasis.repr_self, lp.single_apply, lp.single_apply]
    by_cases hm : m = n
    · subst hm; simp
    · simp [hm]
  rw [h]
  exact (lp.single 2 n _).2

end UnitAddTorus
