/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/
theorem tether_coadjoint_invariance
    (_g : T3 → T3) (F G : Functional) (ω : CoadjointOrbit) :
    TetherKernel (CoadjointAction _g ω) F G = TetherKernel ω F G := ...
