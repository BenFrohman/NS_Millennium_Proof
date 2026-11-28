# `local_existence` on current main

The stated theorem is short-time existence from a smooth, divergence-free,
finite-energy initial field and `0 < ν`. That statement is open. Its proof is
`sorry`.

Unpacking a `KatoLocalWitness` is `local_existence_of_witness`. It is not
Kato/Leray local existence.

On 27 August 2026, commit `8d282b3` had the stated type and a `sorry`.
Commit `a058b37` kept the name and replaced the type with the witness unpack.
Current `main` (`f28622f`) still had that witness type, and also required
`IsPhysicalNSSolution`. This branch puts the stated type back and moves the
unpack to `local_existence_of_witness`.

`beale_kato_majda` on current `main` is not the 27 August `sorry`, and it is
not the `a058b37` wrapper that ignored the integral. It calls
`Tstar_eq_top_of_bkm` and then `smoothness_of_Tstar_top`. This branch does not
change that theorem.

The branch `kernel/cohesive-tether-kappa-bkm` is 390 commits behind `main`.
It is not merged here.
