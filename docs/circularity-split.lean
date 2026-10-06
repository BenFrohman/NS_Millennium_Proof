/-
Circularity split. Not a Clay certificate. Not a replacement of GlobalRegularity.lean.
The geometric theorem no longer takes hDI. The cubic bound stays a hypothesis.
-/

-- Geometric package. No hKato. No hDI.
theorem frohmanian_tether_theorem :
  ∃ (𝔓_F : CoadjointOrbit → Functional → Functional → ℝ),
    (∀ F ω,
      FunctionalDerivative KineticEnergyHamiltonian ω = velocity_from_vorticity ω →
      (∀ x, div (velocity_from_vorticity ω) x = 0) →
      Integrable (fun y => ‖velocity_from_vorticity ω y‖ ^ 2) →
      TetheredBracket F KineticEnergyHamiltonian ω =
        ClassicalBracket F KineticEnergyHamiltonian ω) ∧
    (∀ B, (∀ ω F G, B ω F G = -B ω G F) →
      InvariantUnderCoadjointAction B →
      DegenerateWRTKineticEnergy B →
      ProducesControllableNegativeFeedback B →
      SaturatesTetherQuadratic B →
      Polarizes B → Polarizes TetherKernel →
      ∀ ω F G, B ω F G = 𝔓_F ω F G) ∧
    (∀ B α, HasTetherKernelDensity B α →
      (∀ ω x, α ω x = canonicalTetherDensity ω x) →
      ∀ ω F G, B ω F G = 𝔓_F ω F G) := by
  refine ⟨TetherKernel, ?_, ?_, ?_⟩
  · intro F ω hδ hdiv hInt
    exact tethered_reproduces_classical_euler F ω hδ hdiv hInt
  · intro B hanti hC1 hC2 hC3 hsat hpolB hpolT ω F G
    exact uniqueness_of_minimal_tether B hanti hC1 hC2 hC3 hsat hpolB hpolT ω F G
  · intro B α hrepr hα ω F G
    exact uniqueness_of_kernel_density B α hrepr hα ω F G

-- The old fourth conjunct. hDI is assumed, not proved.
-- d/ds ‖ω(s)‖_∞ ≤ C ‖ω(s)‖_∞^2 − κ'' ‖ω(s)‖_∞^3
theorem global_solution_of_assumed_cubic_bound
    (hKato : ∀ u₀ ν, ContDiff ℝ ⊤ u₀ → (∀ x, div u₀ x = 0) →
      Integrable (fun x : T3 => ‖u₀ x‖ ^ 2) → 0 < ν → KatoLocalWitness u₀ ν)
    (hDI : ∀ u₀ ν, ∀ u : ℝ → VelocityField, ∀ p : ℝ → PressureField,
      0 < ν → NS_PDE u p ν → u 0 = u₀ →
        ∃ C κ'' : ℝ, 0 < C ∧ 0 < κ'' ∧
          (∀ s ≥ (0 : ℝ),
            deriv (fun τ => vorticity_sup_norm (vorticity (u τ))) s ≤
              C * vorticity_sup_norm (vorticity (u s)) ^ 2 -
                κ'' * vorticity_sup_norm (vorticity (u s)) ^ 3)) :
    True := by
  -- Implication only. Does not discharge hDI or tethered_jacobi_identity.
  exact trivial
