# Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
# Released under Apache 2.0 license as described in the file LICENSE.
# Authors: Benjamin Stanley Frohman
"""Print every Lean module of the library (root plus MetriplecticTetherModel/*.lean)."""
import glob, os
mods = ["MetriplecticTetherModel"] + sorted(
    "MetriplecticTetherModel." + os.path.basename(f)[:-5] for f in glob.glob("MetriplecticTetherModel/*.lean"))
print("\n".join(mods))
