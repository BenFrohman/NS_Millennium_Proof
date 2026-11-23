/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

module

public import NS_Millennium_Proof.Modules.ArnoldGeometric

/-!
# Trajectory distinction

`FieldTrajectory` (paths in the coadjoint orbit of vorticity fields) and
`ParticleTrajectory` (paths of points in the physical domain `T3`) are kept in
separate types by construction. No identification between them is provided or
required, and nothing here asserts any regularity or dynamics.
-/

@[expose] public section

open NavierStokes3D ArnoldGeometric

namespace TrajectoryDistinction

/-- A trajectory of the vorticity field inside the coadjoint orbit. -/
def FieldTrajectory := ℝ → CoadjointOrbit

/-- A particle trajectory in the physical domain. -/
def ParticleTrajectory := ℝ → T3

end TrajectoryDistinction

end
