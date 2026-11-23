-- TRUTH-GATE LOCK BEGIN
/-- The repository's statement (`clay_B_exact_of_integrability`). -/
def formal_claim : Prop :=
  ∀ ν : ℝ, PeriodicBKMIntegrability ν → Clay_B_exact ν

/-- Paper (inside the hypothesis): `(u, p)` is a smooth `ℤ³`-periodic solution of
`∂ₜu + (u·∇)u = νΔu − ∇p`, `div u = 0` on `[0, T] × ℝ³`, with `T > 0` and `u(0) = u₀`. -/
def paperSolutionOn (ν : ℝ) (u₀ : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) (T : ℝ)
    (u : ℝ → EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3))
    (p : ℝ → EuclideanSpace ℝ (Fin 3) → ℝ) : Prop :=
  0 < T ∧
  (∀ t ∈ Set.Icc (0 : ℝ) T, ∀ x (j : Fin 3), u t (x + EuclideanSpace.single j 1) = u t x) ∧
  (∀ t ∈ Set.Icc (0 : ℝ) T, ∀ x (j : Fin 3), p t (x + EuclideanSpace.single j 1) = p t x) ∧
  ContDiffOn ℝ ∞ (fun q : ℝ × EuclideanSpace ℝ (Fin 3) => u q.1 q.2) (Set.Icc (0 : ℝ) T ×ˢ Set.univ) ∧
  ContDiffOn ℝ ∞ (fun q : ℝ × EuclideanSpace ℝ (Fin 3) => p q.1 q.2) (Set.Icc (0 : ℝ) T ×ˢ Set.univ) ∧
  (∀ t ∈ Set.Icc (0 : ℝ) T, ∀ x,
    derivWithin (fun s => u s x) (Set.Icc (0 : ℝ) T) t + fderiv ℝ (u t) x (u t x) =
      ν • ∑ i : Fin 3, fderiv ℝ (fun y => fderiv ℝ (u t) y (EuclideanSpace.single i 1)) x
          (EuclideanSpace.single i 1) - ∇ (p t) x) ∧
  (∀ t ∈ Set.Icc (0 : ℝ) T, ∀ x,
    ∑ i : Fin 3, fderiv ℝ (fun y => u t y i) x (EuclideanSpace.single i 1) = 0) ∧
  (∀ x, u 0 x = u₀ x)

/-- Paper: `T*(u₀)`, the supremum in `[−∞, ∞]` of the `T` with a solution on `[0, T]`. -/
noncomputable def paperTstar (ν : ℝ) (u₀ : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3)) :
    EReal :=
  sSup {s : EReal | ∃ T : ℝ, s = (T : EReal) ∧ ∃ u p, paperSolutionOn ν u₀ T u p}

/-- Paper: the vorticity `ω = curl u = (∂₂u₃ − ∂₃u₂, ∂₃u₁ − ∂₁u₃, ∂₁u₂ − ∂₂u₁)`
(coordinates indexed `0, 1, 2` in Lean). -/
noncomputable def paperCurl (v : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3))
    (x : EuclideanSpace ℝ (Fin 3)) : EuclideanSpace ℝ (Fin 3) :=
  EuclideanSpace.single 0 (fderiv ℝ (fun y => v y 2) x (EuclideanSpace.single 1 1)
      - fderiv ℝ (fun y => v y 1) x (EuclideanSpace.single 2 1)) +
    EuclideanSpace.single 1 (fderiv ℝ (fun y => v y 0) x (EuclideanSpace.single 2 1)
      - fderiv ℝ (fun y => v y 2) x (EuclideanSpace.single 0 1)) +
    EuclideanSpace.single 2 (fderiv ℝ (fun y => v y 1) x (EuclideanSpace.single 0 1)
      - fderiv ℝ (fun y => v y 0) x (EuclideanSpace.single 1 1))

/-- Paper: the hypothesis written out. For every smooth, divergence-free, `ℤ³`-periodic `u₀` and
every maximal solution `(u, p)` (a solution on `[0, T]` for every `0 < T < T*(u₀)`), the map
`t ↦ ‖ω(t)‖_{L∞} = sup_x |ω(t,x)|` is Lebesgue integrable on `[0, T]` for every real `T`. -/
def paperBKMIntegrability (ν : ℝ) : Prop :=
  0 < ν → ∀ u₀ : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3),
    ContDiff ℝ (⊤ : ℕ∞) u₀ →
    (∀ x, ∑ i : Fin 3, fderiv ℝ (fun y => u₀ y i) x (EuclideanSpace.single i 1) = 0) →
    (∀ x (j : Fin 3), u₀ (x + EuclideanSpace.single j 1) = u₀ x) →
    ∀ (u : ℝ → EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3))
      (p : ℝ → EuclideanSpace ℝ (Fin 3) → ℝ),
      (∀ T : ℝ, 0 < T → (T : EReal) < paperTstar ν u₀ → paperSolutionOn ν u₀ T u p) →
      ∀ T : ℝ, MeasureTheory.IntegrableOn (fun t => ⨆ x, ‖paperCurl (u t) x‖) (Set.Icc 0 T)

/-- Paper: Statement (B) holds conditionally on the hypothesis, both spelled out. -/
def paper_claim : Prop :=
  ∀ ν : ℝ, 0 < ν → paperBKMIntegrability ν →
    ∀ u₀ : EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3),
      ContDiff ℝ (⊤ : ℕ∞) u₀ →
      (∀ x, ∑ i : Fin 3, fderiv ℝ (fun y => u₀ y i) x (EuclideanSpace.single i 1) = 0) →
      (∀ x (j : Fin 3), u₀ (x + EuclideanSpace.single j 1) = u₀ x) →
      ∃ (u : ℝ → EuclideanSpace ℝ (Fin 3) → EuclideanSpace ℝ (Fin 3))
        (p : ℝ → EuclideanSpace ℝ (Fin 3) → ℝ),
        ContDiffOn ℝ ∞ (fun q : ℝ × EuclideanSpace ℝ (Fin 3) => u q.1 q.2)
            (Set.Ici (0 : ℝ) ×ˢ Set.univ) ∧
        ContDiffOn ℝ ∞ (fun q : ℝ × EuclideanSpace ℝ (Fin 3) => p q.1 q.2)
            (Set.Ici (0 : ℝ) ×ˢ Set.univ) ∧
        (∀ t ≥ (0 : ℝ), ∀ x,
          derivWithin (fun s => u s x) (Set.Ici (0 : ℝ)) t + fderiv ℝ (u t) x (u t x) =
            ν • ∑ i : Fin 3, fderiv ℝ (fun y => fderiv ℝ (u t) y (EuclideanSpace.single i 1)) x
                (EuclideanSpace.single i 1) - ∇ (p t) x) ∧
        (∀ t ≥ (0 : ℝ), ∀ x,
          ∑ i : Fin 3, fderiv ℝ (fun y => u t y i) x (EuclideanSpace.single i 1) = 0) ∧
        (∀ x, u 0 x = u₀ x) ∧
        (∀ t ≥ (0 : ℝ), ∀ x (j : Fin 3),
          u t (x + EuclideanSpace.single j 1) = u t x ∧ p t (x + EuclideanSpace.single j 1) = p t x)

theorem periodic_iff {α : Type*} (g : T3 → α) :
    IsZ3Periodic g ↔ ∀ x (j : Fin 3), g (x + EuclideanSpace.single j 1) = g x := by
  rw [isZ3Periodic_iff_unit_shifts]
  rfl

theorem solutionOn_iff (ν : ℝ) (u₀ : VelocityField) (T : ℝ) (u : TimeDependentVelocity)
    (p : TimeDependentPressure) :
    IsPeriodicSmoothSolutionOn ν u₀ (fun _ _ => 0) T u p ↔ paperSolutionOn ν u₀ T u p := by
  unfold IsPeriodicSmoothSolutionOn paperSolutionOn
  simp only [periodic_iff, convective, laplacian, pressureGradient, div, add_zero]

theorem tstar_eq (ν : ℝ) (u₀ : VelocityField) : periodicTstar ν u₀ = paperTstar ν u₀ := by
  unfold periodicTstar periodicExistenceTimes paperTstar
  simp only [solutionOn_iff]

theorem curl_eq (v : VelocityField) : vorticity v = paperCurl v := by
  funext x
  simp only [vorticity, curl, directionalCoord, paperCurl]

theorem integrability_iff (ν : ℝ) : PeriodicBKMIntegrability ν ↔ paperBKMIntegrability ν := by
  unfold PeriodicBKMIntegrability paperBKMIntegrability IsPeriodicMaximalSolution
    IsPeriodicSmoothInitialData
  simp only [solutionOn_iff, tstar_eq, curl_eq, periodic_iff, div, vorticity_sup_norm]
  constructor
  · intro h hν u₀ hs hd hp u p hmax T
    exact h hν u₀ ⟨hs, hd, hp⟩ u p hmax T
  · rintro h hν u₀ ⟨hs, hd, hp⟩ u p hmax T
    exact h hν u₀ hs hd hp u p hmax T

/-- The fixed correspondence between the formal statement and the paper's claim. -/
theorem intended_correspondence : formal_claim ↔ paper_claim := by
  constructor
  · intro h ν hν hint u₀ hs hd hp
    obtain ⟨u, p, hpu, hpp, hsu, hsp, hns, hdiv, h0⟩ :=
      h ν ((integrability_iff ν).2 hint) hν u₀ ⟨hs, hd, (periodic_iff u₀).2 hp⟩
    refine ⟨u, p, hsu, hsp, ?_, hdiv, h0, ?_⟩
    · intro t ht x
      have := hns t ht x
      simp only [convective, laplacian, pressureGradient, add_zero] at this
      exact this
    · intro t ht x j
      exact ⟨(periodic_iff (u t)).1 (hpu t ht) x j, (periodic_iff (p t)).1 (hpp t ht) x j⟩
  · rintro h ν hint hν u₀ ⟨hs, hd, hp⟩
    obtain ⟨u, p, hsu, hsp, hns, hdiv, h0, hper⟩ :=
      h ν hν ((integrability_iff ν).1 hint) u₀ hs hd ((periodic_iff u₀).1 hp)
    refine ⟨u, p, fun t ht => (periodic_iff (u t)).2 fun x j => (hper t ht x j).1,
      fun t ht => (periodic_iff (p t)).2 fun x j => (hper t ht x j).2, hsu, hsp, ?_, hdiv, h0⟩
    intro t ht x
    simp only [convective, laplacian, pressureGradient, add_zero]
    exact hns t ht x
-- TRUTH-GATE LOCK END
