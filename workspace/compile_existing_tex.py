import subprocess
from pathlib import Path

TECTONIC = "/home/box/.local/bin/tectonic"

tex_files = [
    "/workspace/repos_audit/DerivedCategories/paper/Frohman_Residual_Surface_Preprint_2026.tex",
    "/workspace/repos_audit/DerivedCategories/paper/Frohman_Host_Ideals_2026.tex",
    "/workspace/repos_audit/DerivedCategories/paper/Frohman_Determinantal_Correction_2026.tex",
    "/workspace/repos_audit/orlov-equivalence-VF/orlov_equivalence_VF.tex",
    "/workspace/repos_audit/HODGE/docs/CYCLE_CLASS_AND_CONSTRUCTOR.tex",
    "/workspace/repos_audit/HODGE/papers/frohman-hodge-source-note.tex",
    "/workspace/repos_audit/Frohman-MixedCorrelators-FJ/PROBLEM_STATEMENT.tex",
    "/workspace/repos_audit/Frohman-MixedCorrelators-FJ/GRIND.tex",
    "/workspace/repos_audit/frohmanian-tether-manuscript-2026-06-01/main.tex",
]

for tf in tex_files:
    p = Path(tf)
    print(f"=== Compiling {p} ===")
    res = subprocess.run([TECTONIC, "-X", "compile", str(p)], cwd=str(p.parent), capture_output=True, text=True)
    if res.returncode == 0:
        pdf_p = p.with_suffix(".pdf")
        print(f"SUCCESS: {pdf_p} ({pdf_p.stat().st_size} bytes)")
    else:
        print(f"ERROR compiling {p}:\n{res.stderr}")
