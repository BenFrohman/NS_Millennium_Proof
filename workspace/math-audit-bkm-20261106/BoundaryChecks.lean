import Clay.Gaps.DirectionAlignment

open Clay.StatementB Clay.Gaps.DirectionAlignment

-- Semantic regression: the existing DHY packet has no relation to u.
theorem existing_dhy_iff_bkm : dhyImpliesRegularity ↔ PeriodicBKMIntegrability := by
  constructor
  · intro h ν hν u0 u p T hu0 hT hsol
    apply h ν hν u0 u p T hu0 hT hsol
    refine ⟨⟨fun _ => 0, fun _ => 0, fun _ => 0, fun _ => 0⟩, 0, ?_⟩
    intro t ht
    constructor <;> simp
  · intro h ν hν u0 u p T hu0 hT hsol _
    exact h ν hν u0 u p T hu0 hT hsol

-- Integer parity disappears over the actual rational coefficient field.
theorem rational_parity_map_surjective : Function.Surjective (fun q : ℚ => q * 2) := by
  intro y
  refine ⟨y / 2, ?_⟩
  ring

-- Any nonzero algebraic class rules out the global zero cycle-map model.
theorem cycle_map_ne_zero_of_detected_class
    {Z V : Type*} [AddCommGroup Z] [Module ℚ Z]
    [AddCommGroup V] [Module ℚ V]
    (cl : Z →ₗ[ℚ] V) (z : Z) (h : cl z ≠ 0) : cl ≠ 0 := by
  intro hz
  apply h
  rw [hz]
  rfl

#print axioms existing_dhy_iff_bkm
#print axioms rational_parity_map_surjective
#print axioms cycle_map_ne_zero_of_detected_class

-- Any rational one-dimensional target is exhausted by a single nonzero cycle class.
theorem rational_target_surjective_of_nonzero_cycle
    {Z : Type*} [AddCommGroup Z] [Module ℚ Z]
    (cl : Z →ₗ[ℚ] ℚ) (z : Z) (hz : cl z ≠ 0) : Function.Surjective cl := by
  intro y
  refine ⟨(y / cl z) • z, ?_⟩
  rw [map_smul]
  change (y / cl z) * cl z = y
  exact div_mul_cancel₀ y hz

#print axioms rational_target_surjective_of_nonzero_cycle
