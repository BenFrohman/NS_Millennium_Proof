/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

import NS_Millennium_Proof.Modules.ArnoldGeometric

open ArnoldGeometric

namespace TrajectoryDistinction

/-- A trajectory of the vorticity field inside the coadjoint orbit. -/
def FieldTrajectory := ℝ → CoadjointOrbit

/-- A particle trajectory in the physical domain. -/
def ParticleTrajectory := ℝ → T3

/-- The two trajectory notions are kept in separate types by construction.
No identification between CoadjointOrbit-valued paths and T3-valued paths
is provided or required. -/

end TrajectoryDistinction
