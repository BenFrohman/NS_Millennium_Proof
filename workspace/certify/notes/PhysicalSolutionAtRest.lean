import FrohmanianTether
open NavierStokes3D

theorem physical_time_deriv_zero_at_zero (u : TimeDependentVelocity) (hu : IsPhysicalNSSolution u)
    (x : T3) : deriv (fun s => u s x) 0 = 0 := by
  obtain ⟨hd, -, -, -, hneg⟩ := hu
  have h := (hd 0 le_rfl x).hasDerivAt
  have hw : HasDerivWithinAt (fun s => u s x) (deriv (fun s => u s x) 0) (Set.Iic 0) 0 :=
    h.hasDerivWithinAt
  have hc : HasDerivWithinAt (fun s => u s x) 0 (Set.Iic 0) 0 := by
    have : HasDerivWithinAt (fun _ : ℝ => u 0 x) 0 (Set.Iic 0) 0 := hasDerivWithinAt_const _ _ _
    refine this.congr (fun s hs => ?_) (by simp)
    simp [hneg s hs]
  exact (uniqueDiffOn_Iic (0:ℝ) 0 Set.right_mem_Iic).eq_deriv _ hw hc

/-- Any Kato local witness starts at rest in time: the data solve the steady equations at `t = 0`. -/
theorem kato_witness_steady_at_zero (u₀ : VelocityField) (ν : ℝ) (w : KatoLocalWitness u₀ ν) (x : T3) :
    convective u₀ u₀ x + pressureGradient (w.p 0) x = ν • laplacian u₀ x := by
  have h := (w.pde 0 le_rfl x).1
  have h0 : time_deriv w.u 0 x = 0 := physical_time_deriv_zero_at_zero w.u w.phys x
  rw [h0, zero_add, w.init] at h
  exact h
#print axioms kato_witness_steady_at_zero
