# Lake certificate bundle

This directory is a real Lean lake-build / kernel-certificate attempt
from this repository's own committed lake-manifest.json.
A hand-written CI_RUN summary is not a certificate.
Third-party or dummy checkers do not prove or pass anything;
the final pass, if any, rests only on the Lean kernel and #print axioms.

Commit: 1ea649e495b5e06fafec75a05bb8ec07f13dae80
GitHub Actions run: 44047249293
Run URL: https://github.com/BenFrohman/frohmanian-tether-sdiff/actions/runs/44047249293

File SHA-256 checksums:

```
04391af995de9ab8206e2416e0efd7df1233b6b1ff3248dce9bd7e1b4b67da07  commit.txt  (41 bytes)
9b15cac2501c60eb823b6fd3cc0e7aeb8ff90b1d339e263aca066cb3fb42c48f  lake-build.log  (77252 bytes)
7d1ab35f9874f0c261e99ae06fe05446a8cec85dd4c9af79b016b73032bc0955  lake-manifest.json  (4377 bytes)
8095fe42eb7ea75170395baef767b631a7e12815683c1014503faaef22741d19  lake-manifest.json.sha256  (65 bytes)
d91090911843ae0d8f1ec3129a20d9c93d421c467b25377ddb844b865d3191b5  lake-manifest.json.sha256sum  (85 bytes)
1098ca8368e0db12138f33b070187e1f6527984ae0451a587b20e3e661f96a76  lean-toolchain  (29 bytes)
e41cafe001e39dbb66fb873f701d705c8dc484cb9346a125bf422bfe9b00d2b3  mathlib-rev.txt  (140 bytes)
7afaad5db39ef5d56ffb2b9caeef2240906582b3bff3707c7952b2b1b619afe8  versions.txt  (654 bytes)
```

Note: #print axioms output is not in this bundle, or the axiom step did not run.

